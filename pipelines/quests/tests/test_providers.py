"""The provider layer: who actually speaks a line.

These tests never load a model and never call an API. A fake engine stands in for
Chatterbox and a fake response for ElevenLabs, which is the point - the pipeline is written
on a headless host with no GPU and run on someone else's desktop, so everything except the
generation itself has to be verifiable here.
"""
import os

import pytest

from tts_cli.providers import (ChatterboxProvider, ElevenLabsProvider, get_provider,
                               iso_639_1, voice_name_is_usable)

LINE = {
    "lineId": "q:123:complete",
    "npcId": 240,
    "voice": "human-male",
    "fileName": "123-complete",
    "text": "Hm... I have heard of this Collector.",
    "generatable": True,
}
CFG = {
    "model_id": "eleven_v3",
    "voice_settings": {"stability": 0.5, "similarity_boost": 0.75,
                       "style": 0, "use_speaker_boost": True},
    "seed_strategy": "npc",
}
RULES = {r"\bHm\b": "Hmm"}


class FakeResponse:
    def __init__(self, status=200, content=b"ID3fake", ctype="audio/mpeg", body=None):
        self.status_code = status
        self.content = content
        self.headers = {"Content-Type": ctype}
        self.text = "error body"
        self._body = body

    def json(self):
        return self._body


class FakeEngine:
    """Stands in for ChatterboxMultilingualTTS. Records what it was asked for."""

    sr = 24000

    def __init__(self):
        self.calls = []

    def generate(self, **kwargs):
        self.calls.append(kwargs)
        return [0.0, 0.5, -0.5]


def _wav_bytes(wav, sample_rate):
    return b"MP3" + bytes(len(wav))


# --- naming: the vocabulary both backends share ----------------------------------------

def test_a_race_gender_flavor_name_is_usable():
    assert voice_name_is_usable("orc-male-shady")


def test_a_race_gender_name_is_usable_without_a_flavor():
    assert voice_name_is_usable("narrator-male")


def test_a_stock_voice_name_is_not_usable():
    assert not voice_name_is_usable("Rachel")


def test_an_unknown_race_is_not_usable():
    assert not voice_name_is_usable("ogre-male-standard")


# --- language codes ---------------------------------------------------------------------

def test_a_wow_locale_becomes_an_iso_639_1_code():
    # Both backends want the language, not the locale: ptBR is spoken as 'pt'.
    assert iso_639_1("ptBR") == "pt"
    assert iso_639_1("enUS") == "en"


# --- ElevenLabs -------------------------------------------------------------------------

def test_elevenlabs_lists_only_voices_the_corpus_can_name():
    body = {"voices": [{"name": "orc-male-shady", "voice_id": "v1"},
                       {"name": "Rachel", "voice_id": "v2"}]}
    provider = ElevenLabsProvider(api_key="k",
                                  http_get=lambda *a, **k: FakeResponse(body=body))
    assert provider.voice_map() == {"orc-male-shady": "v1"}


def test_elevenlabs_surfaces_a_failed_voice_listing():
    provider = ElevenLabsProvider(api_key="k",
                                  http_get=lambda *a, **k: FakeResponse(status=401))
    with pytest.raises(RuntimeError, match="401"):
        provider.voice_map()


def test_english_generation_sends_no_language_code():
    # The English pipeline's payload must not change shape now that a language exists:
    # every line already in the store was made without this field.
    payload = ElevenLabsProvider(api_key="k").payload(LINE, CFG, RULES)
    assert "language_code" not in payload


def test_a_language_is_sent_as_an_iso_code():
    payload = ElevenLabsProvider(api_key="k").payload(LINE, CFG, RULES, language="ptBR")
    assert payload["language_code"] == "pt"


def test_elevenlabs_returns_the_audio_and_what_it_spoke():
    provider = ElevenLabsProvider(api_key="k", http_post=lambda *a, **k: FakeResponse())
    audio, request = provider.render(LINE, "v1", CFG, RULES)
    assert audio == b"ID3fake"
    assert request["text"].startswith("Hmm...")


# --- Chatterbox -------------------------------------------------------------------------

def _clips(tmp_path, names):
    for name in names:
        (tmp_path / name).write_bytes(b"RIFFfake")
    return str(tmp_path)


def test_chatterbox_maps_voices_to_reference_clips(tmp_path):
    # A local clone has no account and no voice id: the voice is the recording.
    directory = _clips(tmp_path, ["orc-male-shady.wav", "human-female-standard.flac"])
    provider = ChatterboxProvider(reference_dir=directory)
    assert provider.voice_map() == {
        "orc-male-shady": os.path.join(directory, "orc-male-shady.wav"),
        "human-female-standard": os.path.join(directory, "human-female-standard.flac"),
    }


def test_chatterbox_ignores_clips_that_are_not_voice_names(tmp_path):
    directory = _clips(tmp_path, ["orc-male-shady.wav", "notes.txt", "Rachel.wav"])
    assert set(ChatterboxProvider(reference_dir=directory).voice_map()) == {"orc-male-shady"}


def test_chatterbox_says_what_is_missing_when_there_are_no_references(tmp_path):
    provider = ChatterboxProvider(reference_dir=str(tmp_path / "absent"))
    with pytest.raises(RuntimeError, match="reference"):
        provider.voice_map()


def test_chatterbox_speaks_the_normalized_text(tmp_path):
    engine = FakeEngine()
    provider = ChatterboxProvider(reference_dir=str(tmp_path), engine=engine,
                                  encoder=_wav_bytes)
    _, request = provider.render(LINE, "/clips/human-male.wav", CFG, RULES, language="ptBR")
    assert engine.calls[0]["text"].startswith("Hmm...")
    assert request["text"].startswith("Hmm...")


def test_chatterbox_clones_from_the_reference_it_was_given(tmp_path):
    engine = FakeEngine()
    provider = ChatterboxProvider(reference_dir=str(tmp_path), engine=engine,
                                  encoder=_wav_bytes)
    provider.render(LINE, "/clips/human-male.wav", CFG, RULES, language="ptBR")
    assert engine.calls[0]["audio_prompt_path"] == "/clips/human-male.wav"


def test_chatterbox_is_told_the_language(tmp_path):
    engine = FakeEngine()
    provider = ChatterboxProvider(reference_dir=str(tmp_path), engine=engine,
                                  encoder=_wav_bytes)
    provider.render(LINE, "/clips/human-male.wav", CFG, RULES, language="ptBR")
    assert engine.calls[0]["language_id"] == "pt"


def test_chatterbox_defaults_to_english_when_no_language_is_given(tmp_path):
    engine = FakeEngine()
    provider = ChatterboxProvider(reference_dir=str(tmp_path), engine=engine,
                                  encoder=_wav_bytes)
    provider.render(LINE, "/clips/human-male.wav", CFG, RULES)
    assert engine.calls[0]["language_id"] == "en"


def test_chatterbox_settings_come_from_the_generation_config(tmp_path):
    engine = FakeEngine()
    cfg = {**CFG, "chatterbox": {"exaggeration": 0.3, "cfg_weight": 0.2,
                                 "temperature": 0.7}}
    provider = ChatterboxProvider(reference_dir=str(tmp_path), engine=engine,
                                  encoder=_wav_bytes)
    provider.render(LINE, "/clips/human-male.wav", cfg, RULES)
    assert engine.calls[0]["exaggeration"] == 0.3
    assert engine.calls[0]["cfg_weight"] == 0.2


def test_chatterbox_never_loads_a_model_to_map_voices(tmp_path):
    # Importing torch or pulling 2GB of weights to answer "which voices do I have" would
    # make the reference check unusable as the fast pre-flight it is meant to be.
    provider = ChatterboxProvider(reference_dir=_clips(tmp_path, ["orc-male-shady.wav"]))
    provider.voice_map()
    assert provider._engine is None


# --- selection --------------------------------------------------------------------------

def test_providers_are_addressed_by_name():
    assert isinstance(get_provider("elevenlabs", api_key="k"), ElevenLabsProvider)


def test_an_unknown_provider_lists_the_known_ones():
    with pytest.raises(ValueError, match="chatterbox"):
        get_provider("festival")
