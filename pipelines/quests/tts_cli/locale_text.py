"""What an NPC's gossip reads as on a client in another language.

The addon finds a gossip line from the NPC's text as the client shows it, then plays the
file named for that line's hash. The hash is the English text's in every language, so the
file is found in any pack. The *text* is the part that changes with the client: an English
table cannot match a Spanish client's words, and nine gossip lines in ten belong to an NPC
with more than one, so a guess by word overlap across two languages is mostly wrong.

So a language's Gossip pack carries that language's text beside its English tables, and
nothing else does: the table is only any use on a client in that locale, and a player on one
who wants to hear the language installs its pack. export-locale-text writes the file from
Postgres, which holds `localeText` -- the line as the world database, and so the client,
has it -- for every line imported from there. build reads it and writes guarded tables that
load only on a client in that locale (see build.locale_tables).

Nothing here needs a database: this reads and writes the file, and corpus_db does the query.
"""
import gzip
import json
import os


def write_locale_text(path: str, lang: str, lines: list) -> str:
    """Write one language's rows: [{lineId, originalText, localeText}, ...]."""
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    # mtime=0 for the reason write_corpus gives: unchanged data, identical file.
    with gzip.GzipFile(path, "wb", mtime=0) as raw:
        raw.write(json.dumps({"lang": lang, "lines": lines},
                             ensure_ascii=False, indent=1).encode("utf-8"))
    return path


def load_locale_text(path: str):
    """(lang, rows) from a file write_locale_text wrote."""
    with gzip.open(path, "rt", encoding="utf-8") as f:
        document = json.load(f)
    return document["lang"], document["lines"]
