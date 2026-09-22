"""Locale codes: what the world database carries, and what a pack may be recorded in.

These two are not the same list, and conflating them is what made a ptBR corpus look
impossible. vmangos has no Portuguese column; the addon will happily play a Portuguese
pack. The error message is the place that distinction gets explained, so it is tested.
"""
import pytest

from tts_cli.utils import language_code_to_language_number


def test_english_is_the_default_locale_column():
    assert language_code_to_language_number("enUS") == 0
    assert language_code_to_language_number("enGB") == 0


def test_a_carried_locale_maps_to_its_column():
    assert language_code_to_language_number("frFR") == 2
    assert language_code_to_language_number("ruRU") == 8


def test_portuguese_is_refused_because_the_database_has_no_column_for_it():
    with pytest.raises(ValueError) as exc:
        language_code_to_language_number("ptBR")
    assert "ptBR" in str(exc.value)


def test_the_refusal_explains_that_a_ptbr_pack_is_still_possible():
    # The failure a reader hits here is 'can we even do Portuguese?' - and the answer is
    # yes, from a translated corpus. Saying only 'unsupported' sends them to the wrong fix.
    with pytest.raises(ValueError) as exc:
        language_code_to_language_number("ptBR")
    message = str(exc.value)
    assert "corpus" in message
    assert "TOC" in message


def test_the_refusal_lists_the_locales_that_do_exist():
    with pytest.raises(ValueError) as exc:
        language_code_to_language_number("jaJP")
    assert "deDE" in str(exc.value)


def test_a_typo_raises_rather_than_silently_extracting_english():
    # It used to raise a bare Exception; a caller cannot tell that apart from a bug.
    with pytest.raises(ValueError):
        language_code_to_language_number("enUs")
