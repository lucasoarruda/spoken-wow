"""
Fill a language's gossip in the vmangos world DB from cmangos's BroadcastText translations.

cmangos's classic-db ships locales/BroadcastTextLocales.sql
(https://github.com/cmangos/classic-db): gossip and NPC speech as the Classic client (1.13)
has it, for deDE, esES, esMX, frFR, ptBR and ruRU, keyed by the Blizzard ids vmangos's
broadcast_text uses. For ptBR it covers about 300 gossip lines retail TDB left out
(fill_locales_from_tdb.py); the other languages it barely adds to.

The text goes into the dump's locales_broadcast_text *_locN columns, and the ordinary
`make web-import-locale` carries it into Postgres. Only empty cells are written, never English
(untranslated()), and the file has no English of its own to compare, so a line whose id means
something else in 1.13 than in vmangos is not caught -- Classic kept 1.12's text, so that is
rare.

ptBR writes the player's gender as $Umale:female; where vmangos and the import expect
$Gmale:female;, and that is rewritten.

Local only, like the dump. Usage:
    python tools/fill_locales_from_cmangos.py --lang ptBR --broadcast-text BroadcastTextLocales.sql --dry-run
    python tools/fill_locales_from_cmangos.py --lang ptBR --broadcast-text BroadcastTextLocales.sql
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
sys.path.insert(0, str(HERE))

from fill_locales_from_tdb import untranslated  # noqa: E402

_STRING = r"'((?:[^'\\]|\\.)*)'"
_ESCAPE = re.compile(r"\\(.)", re.S)
_ESCAPES = {"0": "\0", "n": "\n", "r": "\r", "t": "\t"}
_PLAYER_GENDER = re.compile(r"\$[Uu](?=[^:;]*:[^;]*;)")


def _text(value: str) -> str:
    return _PLAYER_GENDER.sub("$G", _ESCAPE.sub(lambda m: _ESCAPES.get(m.group(1), m.group(1)), value))


def read_broadcast_text(source: str, lang: str) -> dict[int, tuple[str, str]]:
    """id -> (male text, female text) for one language, from BroadcastTextLocales.sql."""
    row = re.compile(rf"\((\d+), '{re.escape(lang)}', {_STRING}, {_STRING}, -?\d+\)")
    return {int(m.group(1)): (_text(m.group(2)), _text(m.group(3))) for m in row.finditer(source)}


def plan(texts: dict[int, tuple[str, str]], english: dict[int, tuple[str | None, str | None]],
         current: dict[int, tuple[str | None, str | None]]) -> tuple[dict[int, dict[str, str]], Counter]:
    """Which cells to write: id -> {column stem: text}, and what happened, counted."""
    writes: dict[int, dict[str, str]] = {}
    counts: Counter = Counter()
    for entry, pair in texts.items():
        if entry not in english:
            counts["no such id in vmangos"] += 1
            continue
        for i, stem in enumerate(("male_text", "female_text")):
            text, theirs = pair[i].strip(), (english[entry][i] or "").strip()
            if not text or not theirs:
                continue
            if untranslated(text, theirs):
                counts["source is English"] += 1
            elif (current.get(entry, (None, None))[i] or "").strip():
                counts["dump has its own"] += 1
            else:
                writes.setdefault(entry, {})[stem] = text
                counts["fills empty"] += 1
    return writes, counts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--lang", required=True)
    parser.add_argument("--broadcast-text", type=Path, required=True,
                        help="cmangos classic-db's locales/BroadcastTextLocales.sql")
    parser.add_argument("--dry-run", action="store_true", help="count what would be written")
    args = parser.parse_args()

    from fill_locales_from_tdb import add_ptbr_columns
    from tts_cli.sql_queries import make_connection
    from tts_cli.utils import language_code_to_language_number

    texts = read_broadcast_text(args.broadcast_text.read_text(encoding="utf-8"), args.lang)
    column = language_code_to_language_number(args.lang)
    conn = make_connection()
    try:
        with conn.cursor() as cur:
            if args.lang == "ptBR" and not args.dry_run:
                add_ptbr_columns(cur)
            cur.execute("select entry, male_text, female_text from broadcast_text")
            english = {int(r[0]): (r[1], r[2]) for r in cur.fetchall()}
            cur.execute(f"select entry, male_text_loc{column}, female_text_loc{column} from locales_broadcast_text")
            current = {int(r[0]): (r[1], r[2]) for r in cur.fetchall()}

            writes, counts = plan(texts, english, current)
            for outcome, n in sorted(counts.items()):
                print(f"  {outcome:22} {n:6}")
            if args.dry_run:
                return 0
            for entry, fields in writes.items():
                if entry not in current:
                    cur.execute("insert into locales_broadcast_text (entry) values (%s)", (entry,))
                assignments = ", ".join(f"`{stem}_loc{column}` = %s" for stem in fields)
                cur.execute(f"update locales_broadcast_text set {assignments} where entry = %s",
                            (*fields.values(), entry))
        conn.commit()
    finally:
        conn.close()
    print(f"wrote {sum(len(f) for f in writes.values())} cells over {len(writes)} ids")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
