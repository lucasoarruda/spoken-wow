"""Reading cmangos's BroadcastText translations, and which of the dump's cells they fill."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "tools"))

from fill_locales_from_cmangos import plan, read_broadcast_text  # noqa: E402

SOURCE = (
    "INSERT INTO `broadcast_text_locale` (`ID`, `locale`, `Text_lang`, `Text1_lang`, `VerifiedBuild`) VALUES\n"
    "(14693, 'ptBR', 'Você foi $Uvitorioso:vitoriosa;, \\\"$n\\\"!', '', 31882),\n"
    "(14693, 'deDE', 'Dies ist Euer Tag!', '', 31882);\n"
)


def test_one_language_is_read_and_its_player_gender_token_rewritten():
    assert read_broadcast_text(SOURCE, "ptBR") == {14693: ('Você foi $Gvitorioso:vitoriosa;, "$n"!', "")}


ENGLISH = {1: ("I can sense it, you've won the day, $n!", "I can sense it, you've won the day, $n!")}


def test_only_empty_cells_are_filled_and_never_with_english():
    texts = {1: ("Percebo que você venceu o dia, $n!", "I can sense it, you've won the day, $n!")}
    writes, _ = plan(texts, ENGLISH, {1: (None, None)})
    assert writes == {1: {"male_text": "Percebo que você venceu o dia, $n!"}}
    writes, _ = plan(texts, ENGLISH, {1: ("Já traduzido, $n.", None)})
    assert writes == {}
