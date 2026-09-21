"""Converting a legacy AI_VoiceOver pack into a Spoken Quests pack in a language.

The fixture below is the real legacy layout, not an invented one: it is what
quests/AI_VoiceOverData_Vanilla looked like in this repo's own history before the
rename -- a TOC carrying X-VoiceOver-DataModule-* keys, a Module.lua registering under
the folder name, generated/*.lua lookup tables and generated/sounds/{quests,gossip}.

What the conversion must get right is narrow and worth stating: the pack keeps working
under upstream (the inherited keys survive), starts working here (the new keys appear),
declares its language, and does not touch a byte of the lookup tables or the audio.
"""
import os

import pytest

from tts_cli.convert_legacy import (ConversionError, convert, convert_toc,
                                    find_toc, read_toc_keys)

LEGACY_TOC = """## Interface: 100000
## Title: VoiceOver Data - Vanilla
## Notes: Contains voiceovers for content released during the Vanilla era.
## Version: 0.1
## LoadOnDemand: 1
## X-Part-Of: VoiceOver
## X-Child-Of: VoiceOver
## X-VoiceOver-DataModule-Version: 1
## X-VoiceOver-DataModule-Priority: 100
## X-VoiceOver-DataModule-Maps: 0, 1, 30, 33

Module.lua
generated\\quest_id_lookups.lua
generated\\sound_length_table.lua
"""

LEGACY_MODULE = """if not VoiceOver or not VoiceOver.DataModules then return end

AI_VoiceOverData_Vanilla = {}

function AI_VoiceOverData_Vanilla:GetSoundPath(fileName, event)
    setfenv(1, VoiceOver)
    if Enums.SoundEvent:IsQuestEvent(event) then
        return format([[generated\\sounds\\quests\\%s.mp3]], fileName)
    end
end

VoiceOver.DataModules:Register("AI_VoiceOverData_Vanilla", AI_VoiceOverData_Vanilla)
"""

LENGTH_TABLE = """if not VoiceOver or not VoiceOver.DataModules then return end
AI_VoiceOverData_Vanilla.SoundLengthLookupByFileName = {["5-accept"]=4.5,["abc123"]=2.0}
"""


def legacy_pack(tmp_path, extension=".mp3", toc=LEGACY_TOC):
    """A legacy pack on disk, in the shape the real one has."""
    pack = tmp_path / "AI_VoiceOverData_Vanilla"
    generated = pack / "generated"
    for sub in ("quests", "gossip"):
        (generated / "sounds" / sub).mkdir(parents=True)
    (generated / "sounds" / "quests" / f"5-accept{extension}").write_bytes(b"\0" * 64)
    (generated / "sounds" / "gossip" / f"abc123{extension}").write_bytes(b"\0" * 64)
    (generated / "quest_id_lookups.lua").write_text("-- lookups\n", encoding="utf-8")
    (generated / "sound_length_table.lua").write_text(LENGTH_TABLE, encoding="utf-8")
    (pack / "Module.lua").write_text(LEGACY_MODULE, encoding="utf-8")
    (pack / "AI_VoiceOverData_Vanilla.toc").write_text(toc, encoding="utf-8")
    return str(pack)


def test_converted_toc_carries_both_key_generations(tmp_path):
    """Upstream must keep loading the converted folder, and this addon must start to."""
    out = convert_toc(LEGACY_TOC, "ptBR", "SpokenQuestsAudioPtBR")
    keys = read_toc_keys(out)
    assert keys["X-SpokenQuests-DataModule-Version"] == "1"
    assert keys["X-VoiceOver-DataModule-Version"] == "1"
    assert keys["X-SpokenQuests-DataModule-Priority"] == "100"
    assert keys["X-VoiceOver-DataModule-Priority"] == "100"
    assert keys["X-SpokenQuests-DataModule-Maps"] == "0, 1, 30, 33"


def test_converted_toc_declares_the_language(tmp_path):
    keys = read_toc_keys(convert_toc(LEGACY_TOC, "ptBR", "SpokenQuestsAudioPtBR"))
    assert keys["X-SpokenQuests-Language"] == "ptBR"


def test_converted_toc_keeps_what_it_does_not_manage(tmp_path):
    """Notes, LoadOnDemand and the file list are the pack's own and must survive."""
    out = convert_toc(LEGACY_TOC, "ptBR", "SpokenQuestsAudioPtBR")
    keys = read_toc_keys(out)
    assert keys["LoadOnDemand"] == "1"
    assert keys["Interface"] == "100000"
    assert "Vanilla era" in keys["Notes"]
    assert "generated\\quest_id_lookups.lua" in out
    assert "Module.lua" in out


def test_the_language_is_visible_in_the_addon_list(tmp_path):
    """Two packs of the same content differ only by language; the title has to say so."""
    keys = read_toc_keys(convert_toc(LEGACY_TOC, "ptBR", "SpokenQuestsAudioPtBR"))
    assert keys["Title"] == "VoiceOver Data - Vanilla (ptBR)"


def test_a_pack_already_carrying_both_keys_converts_to_what_it_says(tmp_path):
    """The new key wins, as DataModules:ModuleMeta reads it."""
    toc = LEGACY_TOC.replace(
        "## X-VoiceOver-DataModule-Priority: 100",
        "## X-VoiceOver-DataModule-Priority: 100\n## X-SpokenQuests-DataModule-Priority: 7")
    keys = read_toc_keys(convert_toc(toc, "ptBR", "Pack"))
    assert keys["X-SpokenQuests-DataModule-Priority"] == "7"
    assert keys["X-VoiceOver-DataModule-Priority"] == "7"


def test_an_addon_that_is_not_a_pack_is_refused():
    with pytest.raises(ConversionError, match="not a sound pack"):
        convert_toc("## Interface: 100000\n## Title: Some addon\n", "ptBR", "Pack")


def test_convert_writes_a_loadable_pack(tmp_path):
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "SpokenQuestsAudioPtBR")
    report = convert(src, out, "ptBR")

    assert report["moduleName"] == "SpokenQuestsAudioPtBR"
    assert report["language"] == "ptBR"
    assert os.path.isfile(os.path.join(out, "SpokenQuestsAudioPtBR.toc"))

    module = open(os.path.join(out, "Module.lua"), encoding="utf-8").read()
    # The registration name must be the folder's, or EnumerateAddons finds a pack that
    # then registers under a name nothing looks for.
    assert 'Register("SpokenQuestsAudioPtBR", SpokenQuestsAudioPtBR)' in module
    assert "SpokenQuestsAudioPtBR:GetSoundPath" in module


def test_the_lookup_tables_are_re_pointed_onto_the_new_module(tmp_path):
    """The tables assign onto the source pack's module global, by its folder name.

    Module.lua registers under the converted folder's name; a table still assigning to
    the old global attaches to a table nothing registered, and the pack loads empty.
    The data between the assignments must not change.
    """
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    report = convert(src, out, "ptBR")

    assert report["tables"] == ["quest_id_lookups.lua", "sound_length_table.lua"]
    converted = open(os.path.join(out, "generated", "sound_length_table.lua"),
                     encoding="utf-8").read()
    assert "Pack.SoundLengthLookupByFileName" in converted
    assert "AI_VoiceOverData_Vanilla.SoundLengthLookupByFileName" not in converted
    assert '["5-accept"]=4.5,["abc123"]=2.0' in converted


def test_the_lookup_data_between_assignments_is_byte_identical(tmp_path):
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    convert(src, out, "ptBR")
    original = open(os.path.join(src, "generated", "sound_length_table.lua"),
                    encoding="utf-8").read()
    converted = open(os.path.join(out, "generated", "sound_length_table.lua"),
                     encoding="utf-8").read()
    original_data = original.split("=", 1)[1]
    converted_data = converted.split("=", 1)[1]
    assert converted_data == original_data


def test_the_audio_is_linked_rather_than_copied(tmp_path):
    """A legacy pack runs to gigabytes; a TOC change must not duplicate them."""
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    report = convert(src, out, "ptBR")

    sounds = os.path.join(out, "generated", "sounds")
    assert report["audioLinked"] is True
    assert os.path.islink(sounds)
    assert os.path.isfile(os.path.join(sounds, "quests", "5-accept.mp3"))


def test_copy_makes_a_standalone_pack(tmp_path):
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    report = convert(src, out, "ptBR", copy=True)

    sounds = os.path.join(out, "generated", "sounds")
    assert report["audioLinked"] is False
    assert not os.path.islink(sounds)
    assert os.path.isfile(os.path.join(sounds, "gossip", "abc123.mp3"))


def test_the_sound_extension_follows_the_files(tmp_path):
    """Legacy packs ship mp3, this project's ship ogg; guessing breaks every path."""
    src = legacy_pack(tmp_path, extension=".ogg")
    out = str(tmp_path / "out" / "Pack")
    report = convert(src, out, "ptBR")

    assert report["audioFormat"] == ".ogg"
    module = open(os.path.join(out, "Module.lua"), encoding="utf-8").read()
    assert "%s.ogg" in module
    assert "%s.mp3" not in module


def test_converting_twice_is_stable(tmp_path):
    """Re-running over an existing output replaces it rather than accreting."""
    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    convert(src, out, "ptBR")
    first = open(os.path.join(out, "Pack.toc"), encoding="utf-8").read()
    convert(src, out, "ptBR")
    second = open(os.path.join(out, "Pack.toc"), encoding="utf-8").read()
    assert first == second
    assert os.path.islink(os.path.join(out, "generated", "sounds"))


def test_a_pack_with_no_audio_is_refused(tmp_path):
    src = legacy_pack(tmp_path)
    for sub in ("quests", "gossip"):
        folder = os.path.join(src, "generated", "sounds", sub)
        for name in os.listdir(folder):
            os.remove(os.path.join(folder, name))
    with pytest.raises(ConversionError, match="Nothing to convert|nothing to convert"):
        convert(src, str(tmp_path / "out" / "Pack"), "ptBR")


def test_converting_a_pack_over_itself_is_refused(tmp_path):
    src = legacy_pack(tmp_path)
    with pytest.raises(ConversionError, match="over itself"):
        convert(src, src, "ptBR")


def test_a_folder_with_two_tocs_is_refused(tmp_path):
    """A client-flavored addon, not a data pack: this tool would be guessing."""
    src = legacy_pack(tmp_path)
    open(os.path.join(src, "Other.toc"), "w").close()
    with pytest.raises(ConversionError, match="has one"):
        find_toc(src)


def test_the_sound_path_matches_what_this_project_builds(tmp_path):
    """A converted pack and a built one must address audio identically.

    Lua's [[ ]] takes backslashes literally, so the escaping here is easy to get wrong
    in a way nothing catches until the client plays silence. Pinned against build.py's
    own template rather than restated, so the two cannot drift.
    """
    from tts_cli.build import MODULE_LUA as BUILT

    src = legacy_pack(tmp_path)
    out = str(tmp_path / "out" / "Pack")
    convert(src, out, "ptBR")
    converted = open(os.path.join(out, "Module.lua"), encoding="utf-8").read()

    expected = BUILT.format(module="Pack", extension=".mp3")
    assert converted == expected


def test_legacy_crlf_endings_survive_conversion(tmp_path):
    """Real legacy packs ship CRLF tables and TOC (Windows-built). Neither may confuse
    the module rewrite (an assignment mid-table missed) nor crash the TOC handling."""
    src = legacy_pack(tmp_path)
    table = os.path.join(src, "generated", "sound_length_table.lua")
    text = open(table, encoding="utf-8").read().replace("\n", "\r\n")
    with open(table, "w", encoding="utf-8", newline="") as f:
        f.write(text)
    toc = os.path.join(src, "AI_VoiceOverData_Vanilla.toc")
    text = open(toc, encoding="utf-8").read().replace("\n", "\r\n")
    with open(toc, "w", encoding="utf-8", newline="") as f:
        f.write(text)

    out = str(tmp_path / "out" / "Pack")
    convert(src, out, "ptBR")

    converted = open(os.path.join(out, "generated", "sound_length_table.lua"),
                     encoding="utf-8").read()
    assert "Pack.SoundLengthLookupByFileName" in converted
    assert "AI_VoiceOverData_Vanilla." not in converted
    keys = read_toc_keys(open(os.path.join(out, "Pack.toc"), encoding="utf-8").read())
    assert keys["X-SpokenQuests-Language"] == "ptBR"
