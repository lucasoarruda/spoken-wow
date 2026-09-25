"""The per-language gossip text file export-locale-text writes and build reads."""
from tts_cli.locale_text import load_locale_text, write_locale_text

ROWS = [{"lineId": "g:abc123", "originalText": "Move along.", "localeText": "Circule."}]


def test_a_written_language_reads_back(tmp_path):
    path = write_locale_text(str(tmp_path / "esMX" / "locale-text.json.gz"), "esMX", ROWS)

    assert load_locale_text(path) == ("esMX", ROWS)


def test_writing_the_same_rows_twice_is_the_same_file(tmp_path):
    path = str(tmp_path / "locale-text.json.gz")
    write_locale_text(path, "esMX", ROWS)
    first = open(path, "rb").read()
    write_locale_text(path, "esMX", ROWS)

    assert open(path, "rb").read() == first
