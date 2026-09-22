"""Where audio comes from: one interface, several backends.

Synthesis used to be ElevenLabs and nothing else - the URL, the key and the payload shape
were spelled out inline in synthesize.py. That was fine while the only pack was English and
made in the cloud, and it stops being fine the moment a pack is generated on someone's own
GPU: a local model has no API key, no HTTP call and no hosted voice list, so there is
nothing for the old code path to parameterise.

A provider answers two questions and nothing else:

    voice_map()   which of the corpus's race-gender-flavor voices can this backend speak
    render()      turn one line's text into mp3 bytes

Everything around them - which lines to select, refusing to overwrite a take, the store
layout, duration measurement - stays in synthesize.py, because it is identical whoever
makes the audio.

The backends differ in where a *voice* lives. ElevenLabs holds cloned voices server-side and
names them, so the map is an API call returning ids. Chatterbox clones zero-shot from a
reference clip at generation time, so the map is a directory of wav files and the 'id' is a
path. Both sides of that difference are hidden behind the same dict.
"""
import os
import subprocess

import requests

from tts_cli.consts import GENDER_DICT, RACE_DICT
from tts_cli.voice_config import apply_pronunciation, seed_for

ELEVENLABS_API_URL = "https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
ELEVENLABS_VOICES_URL = "https://api.elevenlabs.io/v1/voices"

#: Reference clips for local cloning, named like the voices they stand in for:
#: voice/references/orc-male-shady.wav. The same race-gender-flavor vocabulary the corpus
#: uses, so a corpus line names its reference without any mapping table.
REFERENCE_EXTENSIONS = (".wav", ".flac", ".mp3")


def voice_name_is_usable(name: str) -> bool:
    """Is this a race-gender[-flavor] name the corpus could ask for?

    The flavor is optional: narrator-male is a pseudo-race for gameobjects and has no NPC
    voice sets to choose between.
    """
    parts = name.split("-")
    return (len(parts) in (2, 3)
            and parts[0] in set(RACE_DICT.values())
            and parts[1] in set(GENDER_DICT.values()))


class ElevenLabsProvider:
    """Hosted synthesis. Voices are clones held in the account, addressed by id."""

    name = "elevenlabs"
    #: Audio comes back as mp3 already, which is what the store holds.
    returns_mp3 = True

    def __init__(self, api_key: str = None, http_post=requests.post, http_get=requests.get):
        if api_key is None:
            from tts_cli.env_vars import ELEVENLABS_API_KEY
            api_key = ELEVENLABS_API_KEY
        self.api_key = api_key
        self._post = http_post
        self._get = http_get

    def voice_map(self) -> dict:
        """Map 'race-gender[-flavor]' -> voice id for voices this project can use."""
        response = self._get(ELEVENLABS_VOICES_URL, headers={"xi-api-key": self.api_key})
        if response.status_code != 200:
            raise RuntimeError(
                f"could not list ElevenLabs voices ({response.status_code}): "
                f"{response.text[:200]}")
        return {v["name"]: v["voice_id"] for v in response.json()["voices"]
                if voice_name_is_usable(v["name"])}

    def payload(self, line: dict, generation_cfg: dict, rules: dict,
                language: str = None) -> dict:
        payload = {
            "text": apply_pronunciation(line["text"], rules),
            "model_id": generation_cfg["model_id"],
            "voice_settings": generation_cfg["voice_settings"],
        }
        seed = seed_for(line["npcId"], generation_cfg["seed_strategy"])
        if seed is not None:
            payload["seed"] = seed
        # The API takes an ISO-639-1 code, not a WoW locale: ptBR is spoken as 'pt'. Sent
        # only when a language is asked for, so English generation keeps its old payload
        # byte for byte and cannot drift.
        if language:
            payload["language_code"] = iso_639_1(language)
        return payload

    def render(self, line: dict, voice_id: str, generation_cfg: dict, rules: dict,
               language: str = None) -> tuple:
        payload = self.payload(line, generation_cfg, rules, language)
        response = self._post(ELEVENLABS_API_URL.format(voice_id=voice_id), json=payload,
                              headers={"xi-api-key": self.api_key})
        if response.status_code != 200:
            raise RuntimeError(
                f"ElevenLabs returned {response.status_code}: {response.text[:200]}")
        if response.headers.get("Content-Type") != "audio/mpeg":
            raise RuntimeError(
                f'response was not audio (Content-Type {response.headers.get("Content-Type")})')
        return response.content, payload


class ChatterboxProvider:
    """Local synthesis on your own GPU, cloning from reference clips.

    Chatterbox Multilingual is MIT for both code and weights, which is why it is the
    backend a redistributable pack can be built with: the non-commercial model licences
    that cover most open TTS weights reach the audio they generate, and would follow the
    pack downstream forever.

    The model is imported lazily and the engine is injectable, so this module - and the
    tests for it - stay importable on a machine with no torch, no GPU and no weights. That
    matters here: the pipeline is written on a headless host and run on someone else's
    desktop.

    Every output carries Resemble's PerTh watermark. It is inaudible and survives the mp3
    transcode, so it ships in the pack; say so in the pack's notes rather than discovering
    it later.
    """

    name = "chatterbox"
    #: The model yields wav; the store holds mp3, so rendering ends in a transcode.
    returns_mp3 = False

    def __init__(self, model_dir: str = None, reference_dir: str = None,
                 device: str = "cuda", engine=None, encoder=None):
        self.model_dir = model_dir
        self.reference_dir = reference_dir or DEFAULT_REFERENCE_DIR
        self.device = device
        self._engine = engine
        self._encode = encoder or wav_to_mp3

    @property
    def engine(self):
        """The loaded model. Imported here so the module needs no torch to import."""
        if self._engine is None:
            from chatterbox.mtl_tts import ChatterboxMultilingualTTS
            self._engine = (
                ChatterboxMultilingualTTS.from_local(self.model_dir, device=self.device)
                if self.model_dir
                else ChatterboxMultilingualTTS.from_pretrained(device=self.device))
        return self._engine

    def voice_map(self) -> dict:
        """Map 'race-gender[-flavor]' -> reference clip path.

        A local clone has no account and no id: the voice *is* the reference recording, so
        the map is the reference directory. Names match the corpus's voice names, which is
        what lets the same selection code drive either backend.
        """
        if not os.path.isdir(self.reference_dir):
            raise RuntimeError(
                f"no reference clips at {self.reference_dir}; Chatterbox clones a voice "
                "from a recording, so each corpus voice needs one named after it "
                "(e.g. orc-male-shady.wav)")
        found = {}
        for entry in sorted(os.listdir(self.reference_dir)):
            stem, ext = os.path.splitext(entry)
            if ext.lower() in REFERENCE_EXTENSIONS and voice_name_is_usable(stem):
                found.setdefault(stem, os.path.join(self.reference_dir, entry))
        return found

    def render(self, line: dict, reference_path: str, generation_cfg: dict, rules: dict,
               language: str = None) -> tuple:
        spoken = apply_pronunciation(line["text"], rules)
        settings = generation_cfg.get("chatterbox", {})
        request = {
            "text": spoken,
            "audio_prompt_path": reference_path,
            "language_id": iso_639_1(language or "enUS"),
            "exaggeration": settings.get("exaggeration", 0.5),
            "cfg_weight": settings.get("cfg_weight", 0.5),
            "temperature": settings.get("temperature", 0.8),
        }
        wav = self.engine.generate(**request)
        audio = self._encode(wav, getattr(self.engine, "sr", 24000))
        # Reported back the way the ElevenLabs payload is, so the caller can log what was
        # actually spoken and what it was asked to cost, whoever spoke it.
        return audio, {"text": spoken, **{k: v for k, v in request.items() if k != "text"}}


DEFAULT_REFERENCE_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "voice", "references")

PROVIDERS = {
    ElevenLabsProvider.name: ElevenLabsProvider,
    ChatterboxProvider.name: ChatterboxProvider,
}


def iso_639_1(language: str) -> str:
    """'ptBR' -> 'pt'. Both backends want the language, not the locale."""
    return language[:2].lower()


def wav_to_mp3(wav, sample_rate: int) -> bytes:
    """Transcode a generated waveform to mp3 the way the store holds it.

    Through ffmpeg on a pipe rather than a library, because the store's mp3s were made by
    ElevenLabs and this is the one place a locally generated file could end up encoded
    differently from the thousands already there.
    """
    import numpy as np

    samples = wav.detach().cpu().numpy() if hasattr(wav, "detach") else np.asarray(wav)
    samples = np.squeeze(samples)
    pcm = (np.clip(samples, -1.0, 1.0) * 32767).astype("<i2").tobytes()

    result = subprocess.run(
        ["ffmpeg", "-hide_banner", "-loglevel", "error",
         "-f", "s16le", "-ar", str(sample_rate), "-ac", "1", "-i", "pipe:0",
         "-codec:a", "libmp3lame", "-b:a", "128k", "-f", "mp3", "pipe:1"],
        input=pcm, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
    if result.returncode != 0:
        raise RuntimeError(f"ffmpeg failed: {result.stderr.decode()[:200]}")
    return result.stdout


def get_provider(name: str, **kwargs):
    if name not in PROVIDERS:
        raise ValueError(
            f"unknown provider {name!r}; known: {', '.join(sorted(PROVIDERS))}")
    return PROVIDERS[name](**kwargs)
