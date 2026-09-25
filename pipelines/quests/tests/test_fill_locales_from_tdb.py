"""The TDB reader and the rule that decides a translation belongs to vmangos's English line."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "tools"))

from fill_locales_from_tdb import read_tables, same, untranslated  # noqa: E402


def test_the_dump_reader_keeps_named_columns_and_unescapes(tmp_path):
    dump = tmp_path / "tdb.sql"
    dump.write_text(
        "CREATE TABLE `page_text_locale` (\n"
        "  `ID` int unsigned NOT NULL,\n"
        "  `locale` varchar(4) NOT NULL,\n"
        "  `Text` text,\n"
        "  `VerifiedBuild` int DEFAULT '0'\n"
        ") ENGINE=InnoDB;\n"
        "INSERT INTO `page_text_locale` VALUES (15,'zhTW','It\\'s (brisk), $B\\\"so\\\" brisk',0),"
        "(16,'deDE',NULL,-1);\n",
        encoding="utf-8",
    )
    rows = read_tables(dump, {"page_text_locale": ["ID", "locale", "Text"]})["page_text_locale"]
    assert rows == [
        {"ID": "15", "locale": "zhTW", "Text": 'It\'s (brisk), $B"so" brisk'},
        {"ID": "16", "locale": "deDE", "Text": None},
    ]


def test_a_row_can_be_dropped_while_reading(tmp_path):
    dump = tmp_path / "tdb.sql"
    dump.write_text(
        "CREATE TABLE `t` (\n  `ID` int,\n  `locale` varchar(4)\n);\n"
        "INSERT INTO `t` VALUES (1,'ptBR'),(2,'frFR');\n",
        encoding="utf-8",
    )
    rows = read_tables(dump, {"t": ["ID", "locale"]}, lambda _t, row: row["locale"] == "ptBR")
    assert [row["ID"] for row in rows["t"]] == ["1"]


def test_the_same_line_despite_token_case_punctuation_and_line_breaks():
    assert same("Well done, $n. Here--take it.") == same("Well done, $N. Here - take it.")
    assert same("Hello Morgan,$B$BBusiness is brisk") == same("Hello Morgan,\n\nBusiness is brisk")


def test_a_changed_word_is_a_changed_line():
    assert same("a good mage") != same("a good $C")
    assert same("the behest of Tara") != same("the behest of Thenysil")
    assert same(None) == same("") == ""


def test_english_filed_under_another_language_is_not_a_translation():
    english = "Executor Zygand tells me you've been out killing Scarlet Crusaders, $n."
    assert untranslated(english, english)
    assert untranslated("Executor Zigano tells me you've been out killing Scarlet Crusaders.", english)
    assert not untranslated("O Executor Zygand me disse que você tem matado Cruzados Escarlates, $n.", english)


def test_a_short_line_sharing_a_name_is_still_a_translation():
    assert not untranslated("Olá, $n.", "Hello, $n.")
    assert not untranslated("Salve, $c!", "Hail, $c!")
