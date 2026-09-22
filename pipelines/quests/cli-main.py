"""Command line entry point for the voiceline production pipeline.

Only `extract` needs a database:

    init-db           download and import the vmangos dump      maintainer, rare
    extract           world DB -> corpus/corpus.json.gz         maintainer, rare
    import-corpus     corpus.json.gz -> Postgres                maintainer, rare
    export-corpus     Postgres -> corpus.json.gz                maintainer, rare
    export-ignores    line_ignore -> corpus/ignored.json        maintainer, rare
    import-audio      an existing sound pack -> audio/          once
    synthesize        corpus + voice config -> audio/           everyday
    build             corpus + audio/ -> dist/<module>          per release
    install           dist/<module> -> WoW AddOns               per release
    convert-legacy    an AI_VoiceOver pack -> a language pack   third-party packs

The maintainer's synthesis moved to the website (spoken.rusty.one), but this CLI keeps a
local `synthesize` that goes through tts_cli/providers.py - the hosted ElevenLabs API or a
local model on your own GPU - because a language pack recorded off a reference voice is a
many-hour local batch, not a website form.
"""
import argparse

from tts_cli.build import (DEFAULT_ADDONS_DIR, DEFAULT_DIST_DIR,
                           DEFAULT_MODULE_NAME, build_module, install_module)
from tts_cli.corpus import DEFAULT_CORPUS_PATH, load_corpus
from tts_cli.factions import (DEFAULT_FACTIONS_PATH, PACKS, load_sides, pack_stems,
                              pack_title)
from tts_cli.ignores import DEFAULT_IGNORED_PATH, ignored_files, load_ignored
from tts_cli.providers import PROVIDERS, get_provider
from tts_cli.select import estimate, select_lines, unique_by_file
from tts_cli.store import DEFAULT_SOURCE_DIR, DEFAULT_STORE_DIR, import_audio
from tts_cli.synthesize import synthesize_line
from tts_cli.voice_config import apply_pronunciation, load_pronunciation
# fetch_voice_map still exists for callers that want the hosted list directly; synthesize
# now goes through a provider, which answers the same question for either backend.

# init-db and extract are imported inside their branches: they pull in
# pandas and PyMySQL, which the everyday path deliberately does not install.

parser = argparse.ArgumentParser(description="Voiceline production pipeline for WoW dialog")
subparsers = parser.add_subparsers(dest="mode", help="Available modes")

subparsers.add_parser(
    "init-db",
    help="Download the vmangos dump and import it. Needed only before 'extract'.")
subparsers.add_parser(
    "extract",
    help="Query the world DB and write the committed corpus. The only stage needing MySQL.") \
    .add_argument("--out", default=DEFAULT_CORPUS_PATH)
subparsers.add_parser(
    "import-corpus",
    help="corpus.json.gz -> Postgres. Needed by a maintainer, not to produce audio.") \
    .add_argument("--corpus", default=DEFAULT_CORPUS_PATH)
ign = subparsers.add_parser(
    "export-ignores",
    help="line_ignore -> corpus/ignored.json, which build reads.")
ign.add_argument("--ignored", default=DEFAULT_IGNORED_PATH)
ign.add_argument("--check", action="store_true",
                 help="Compare instead of writing; exits 1 if they differ.")

exp = subparsers.add_parser(
    "export-corpus",
    help="Postgres -> corpus.json.gz. The committed file is an export of the table.")
exp.add_argument("--corpus", default=DEFAULT_CORPUS_PATH)
exp.add_argument("--check", action="store_true",
                 help="Compare instead of writing; exits 1 if they differ.")

syn = subparsers.add_parser(
    "synthesize",
    help="Render selected corpus lines into the audio store.")
syn.add_argument("--line-id")
syn.add_argument("--npc", help="NPC id or name substring")
syn.add_argument("--quest", help="Quest id or title substring")
syn.add_argument("--voice", help="e.g. human-male")
syn.add_argument("--missing", action="store_true",
                 help="Only lines with no audio in the store")
syn.add_argument("--area", nargs=5, type=float, metavar=("MAP", "X1", "X2", "Y1", "Y2"),
                 help="Only NPCs spawned in this world-coordinate box")
syn.add_argument("--force", action="store_true", help="Replace audio already in the store")
syn.add_argument("--limit", type=int)
syn.add_argument("--dry-run", action="store_true",
                 help="Report what would be generated and what it would cost")
syn.add_argument("--store", default=DEFAULT_STORE_DIR)
syn.add_argument("--corpus", default=DEFAULT_CORPUS_PATH)
syn.add_argument("--ignored", default=DEFAULT_IGNORED_PATH)
syn.add_argument("--provider", default="elevenlabs", choices=sorted(PROVIDERS),
                 help="Who speaks the lines: the hosted API, or a local model on your GPU")
syn.add_argument("--language", default=None,
                 help="The language being recorded, e.g. ptBR. Omitted means English.")
syn.add_argument("--model-dir", default=None,
                 help="Local model weights (chatterbox); omitted downloads them")
syn.add_argument("--references", default=None,
                 help="Reference clips to clone from (chatterbox); "
                      "one per voice, named e.g. orc-male-shady.wav")
syn.add_argument("--device", default="cuda",
                 help="Torch device for a local provider ('cuda' covers ROCm builds)")

bld = subparsers.add_parser(
    "build",
    help="Assemble the addon data module from the corpus and audio/ (make quests-sounds).")
bld.add_argument("--store", default=DEFAULT_STORE_DIR)
bld.add_argument("--corpus", default=DEFAULT_CORPUS_PATH)
bld.add_argument("--dist", default=DEFAULT_DIST_DIR)
bld.add_argument("--module", default=DEFAULT_MODULE_NAME)
bld.add_argument("--version", default="1.0.1")
bld.add_argument("--ignored", default=DEFAULT_IGNORED_PATH)
bld.add_argument("--pack", default="all", choices=PACKS,
                 help="which slice of the audio to ship (default: all)")
bld.add_argument("--factions", default=DEFAULT_FACTIONS_PATH)
bld.add_argument("--module-title", default=None,
                 help="TOC title; defaults to one naming the pack")
bld.add_argument("--language", default=None,
                 help="Stamp the pack's recorded language, e.g. ptBR. "
                      "Omitted leaves the key off, which the addon reads as English.")

ins = subparsers.add_parser(
    "install", help="Copy the built module into a WoW AddOns folder.")
ins.add_argument("--addons", default=DEFAULT_ADDONS_DIR)
ins.add_argument("--dist", default=DEFAULT_DIST_DIR)
ins.add_argument("--module", default=DEFAULT_MODULE_NAME)
ins.add_argument("--force", action="store_true",
                 help="Replace an existing install, moving it aside first")

ign = subparsers.add_parser(
    "ignored-files",
    help="Print store-relative mp3s whose every corpus line is ignored (rsync exclusions).")
ign.add_argument("--corpus", default=DEFAULT_CORPUS_PATH)
ign.add_argument("--ignored", default=DEFAULT_IGNORED_PATH)

subparsers.add_parser(
    "gen_lookup_tables",
    help="Generate the addon lookup tables and sound length table.") \
    .add_argument("--lang", default="enUS")

cvt = subparsers.add_parser(
    "convert-legacy",
    help="Convert a pre-built AI_VoiceOver pack into a Spoken Quests pack in a language.")
cvt.add_argument("source", help="The legacy pack folder (holds a .toc and generated/)")
cvt.add_argument("out", help="Where to write the converted pack; its name is the module's")
cvt.add_argument("--language", required=True,
                 help="The language the pack was recorded in, e.g. ptBR")
cvt.add_argument("--module", default=None,
                 help="Module name; defaults to the output folder's name")
cvt.add_argument("--copy", action="store_true",
                 help="Copy the audio instead of symlinking it (gigabytes; rarely wanted)")

args = parser.parse_args()

if args.mode == "init-db":
    from tts_cli.init_db import (download_and_extract_latest_db_dump,
                                 import_sql_files_to_database)
    download_and_extract_latest_db_dump()
    import_sql_files_to_database()
    print("Database initialized successfully.")

elif args.mode == "extract":
    from tts_cli.corpus import extract
    corpus = extract(args.out)
    print(f"Wrote {corpus['lineCount']} lines "
          f"and spawns for {len(corpus['spawns'])} NPCs to {args.out}")

elif args.mode == "import-corpus":
    # Imported here rather than at the top, the way extract is: psycopg2 is in
    # requirements-extract.txt, and the everyday path deliberately installs no database
    # client at all.
    from tts_cli.corpus_db import import_corpus
    import_corpus(args.corpus)

elif args.mode == "export-ignores":
    from tts_cli.corpus_db import export_ignores
    if not export_ignores(args.ignored, check=args.check) and args.check:
        raise SystemExit(1)

elif args.mode == "export-corpus":
    from tts_cli.corpus_db import export_corpus
    same = export_corpus(args.corpus, check=args.check)
    if args.check and not same:
        # Worth failing a build over: the file the addon build reads no longer matches what
        # the table would produce, so the table is not carrying everything it needs to.
        raise SystemExit(1)

elif args.mode == "synthesize":
    corpus = load_corpus(args.corpus)
    ignored = load_ignored(args.ignored)
    area = (int(args.area[0]), (args.area[1], args.area[2]), (args.area[3], args.area[4])) \
        if args.area else None
    selected = select_lines(corpus, args.store, npc=args.npc, quest=args.quest,
                            voice=args.voice, line_id=args.line_id,
                            missing=args.missing, area=area, ignored=ignored)
    targets = unique_by_file([l for l in selected if l["generatable"]])
    if args.limit:
        targets = targets[:args.limit]

    est = estimate(targets)
    print(f"selected {len(selected)} lines -> {est['files']} files, "
          f"{est['characters']:,} characters")
    print(f"voices needed: {', '.join(est['voices']) or 'none'}")

    if args.dry_run or not targets:
        # Show what will actually be spoken, after pronunciation rules - that is the
        # thing worth eyeballing before spending characters.
        rules = load_pronunciation()
        for line in targets[:10]:
            spoken = apply_pronunciation(line["text"], rules)
            flag = "*" if spoken != line["text"] else " "
            print(f"  {flag} {line['lineId']:<26} {line['voice']:<14} {spoken[:52]}")
        if len(targets) > 10:
            print(f"    ... and {len(targets) - 10} more")
        if any(apply_pronunciation(l["text"], rules) != l["text"] for l in targets):
            print("  (* = pronunciation rules changed the spoken text)")
        raise SystemExit(0)

    kwargs = {}
    if args.provider == "chatterbox":
        kwargs = {"model_dir": args.model_dir, "reference_dir": args.references,
                  "device": args.device}
    provider = get_provider(args.provider, **kwargs)

    voice_map = provider.voice_map()
    unavailable = sorted(set(est["voices"]) - set(voice_map))
    if unavailable:
        raise SystemExit(
            f"{provider.name} cannot speak: {', '.join(unavailable)}\n"
            "Voices are named race-gender[-flavor] (e.g. orc-male-shady) - as clones in "
            "the ElevenLabs account, or as reference clips in the references directory.")

    done = failed = 0
    # Every failure is counted and printed rather than raised: a run of thousands of lines
    # on a local GPU takes many hours, and one bad line must not discard the ones already
    # made. Re-running resumes, because a line whose audio exists is refused as a rewrite.
    for line in tqdm(targets, unit="line", desc="Synthesizing"):
        try:
            synthesize_line(line, voice_map[line["voice"]], args.store, force=args.force,
                            provider=provider, language=args.language)
            done += 1
        except FileExistsError:
            pass
        except Exception as exc:
            failed += 1
            print(f"\n  {line['lineId']}: {exc}")
    print(f"\nsynthesized {done}, failed {failed}")
    if failed:
        print("Re-run the same command to retry only what is missing.")

elif args.mode == "build":
    corpus = load_corpus(args.corpus)
    # None for the whole store rather than the 'all' stem set, so a store file the corpus
    # cannot address still ships in the complete pack the way it always has.
    include = None if args.pack == "all" else \
        pack_stems(corpus, load_sides(args.factions), args.pack)
    report = build_module(corpus, args.store, args.dist,
                          args.module, args.version, progress=True,
                          ignored=load_ignored(args.ignored), include=include,
                          title=args.module_title or pack_title(args.pack),
                          language=args.language)
    print(f"\nbuilt {report['moduleDir']}")
    print(f"  audio files {report['audioFiles']} ({report['audioFormat']}, pack: {args.pack})")
    print(f"  language    {report['language'] or 'enUS (key not stamped)'}")
    for name, rows in sorted(report["tableRows"].items()):
        print(f"  {name:<32} {rows:>6} entries")

elif args.mode == "install":
    import os as _os
    report = install_module(_os.path.join(args.dist, args.module), args.addons, args.force)
    print(f"installed {report['target']}")
    if report["replaced"]:
        print(f"previous install moved to {report['replaced']}")

elif args.mode == "gen_lookup_tables":
    from tts_cli import utils
    from tts_cli.sql_queries import query_dataframe_for_all_quests_and_gossip
    from tts_cli.tts_utils import TTSProcessor

    tts_processor = TTSProcessor()
    language_number = utils.language_code_to_language_number(args.lang)
    print(f"Selected language: {args.lang}")
    df = query_dataframe_for_all_quests_and_gossip(language_number)
    df = tts_processor.preprocess_dataframe(df)
    tts_processor.generate_lookup_tables(df)

elif args.mode == "convert-legacy":
    from tts_cli.convert_legacy import convert
    report = convert(args.source, args.out, args.language, args.module, args.copy)
    print(f"converted {report['packDir']}")
    print(f"  module    {report['moduleName']}")
    print(f"  language  {report['language']}")
    print(f"  audio     {report['audioFormat']} "
          f"({'symlinked' if report['audioLinked'] else 'copied'})")
    print(f"  tables    {len(report['tables'])} carried over unchanged")
    # A converted third-party pack carries its author's licence, not this project's.
    print("\nThe converted pack holds the source pack's audio and its licence.\n"
          "Do not commit or redistribute it.")

else:
    parser.print_help()
