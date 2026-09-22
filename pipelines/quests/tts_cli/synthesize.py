"""Render corpus lines into the audio store.

Reads text and voice from the committed corpus, so this stage needs no database. Which
backend actually speaks the line lives in tts_cli/providers.py; everything here is the part
that is the same whoever speaks it - where the file goes, refusing to destroy a take that
already exists, and measuring what came back.
"""
import os

import mutagen.mp3

from tts_cli.providers import ElevenLabsProvider
from tts_cli.store import store_path
from tts_cli.voice_config import apply_pronunciation, seed_for  # noqa: F401  (re-exported)

#: Kept so the old import site still resolves; the URL now lives with its provider.
API_URL = "https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"


def build_payload(line: dict, generation_cfg: dict, rules: dict,
                  language: str = None) -> dict:
    """The ElevenLabs request body for one line.

    Still here, and still ElevenLabs-shaped, because it is what the existing English
    pipeline and its tests describe. A local backend builds its own request; see
    ChatterboxProvider.render.
    """
    return ElevenLabsProvider(api_key="", http_post=None, http_get=None).payload(
        line, generation_cfg, rules, language)


def _duration(path: str) -> float:
    return round(mutagen.mp3.MP3(path).info.length, 3)


def synthesize_line(line: dict, voice_id: str, store_dir: str,
                    generation_cfg: dict = None, rules: dict = None,
                    http_post=None, force: bool = False,
                    provider=None, language: str = None) -> dict:
    """Synthesize one line into the store.

    Refuses to overwrite unless forced: audio already in the store cost real money, and a
    re-roll is not always an improvement. That guard is the reason a 55-hour local batch
    can simply be re-run after a crash - every line already made is skipped, so the run
    resumes instead of starting over.

    `voice_id` is whatever the provider's voice map yielded: an ElevenLabs voice id, or the
    path to a reference clip for a backend that clones locally.
    """
    if not line.get("generatable", True):
        raise ValueError(
            f'{line["lineId"]} is never voiced ({line.get("skipReason")})')

    from tts_cli.voice_config import load_generation, load_pronunciation

    generation_cfg = load_generation() if generation_cfg is None else generation_cfg
    rules = load_pronunciation() if rules is None else rules

    path = store_path(store_dir, line)
    if os.path.isfile(path) and not force:
        raise FileExistsError(f"{path} already exists; pass force to replace it")

    if provider is None:
        # http_post keeps working as the injection point it always was, so every existing
        # caller and test drives the hosted backend without knowing providers exist.
        import requests
        provider = ElevenLabsProvider(http_post=http_post or requests.post)

    audio, request = provider.render(line, voice_id, generation_cfg, rules, language)

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as f:
        f.write(audio)

    return {
        "lineId": line["lineId"],
        "path": path,
        "durationSec": _duration(path),
        "characters": len(request["text"]),
        "seed": request.get("seed"),
        "spokenText": request["text"],
        "provider": provider.name,
    }
