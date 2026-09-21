"""Convert a legacy AI_VoiceOver sound pack into a Spoken Quests pack in a language.

The packs this project builds come out of `build_module` from a corpus and an audio
store. A pack that somebody else recorded has neither: all that exists is the built
addon folder -- a TOC, a Module.lua, and generated/*.lua lookup tables beside a tree of
audio. Rebuilding it is not an option, so this converts it in place instead.

What a conversion is, precisely:

  - the TOC gains the keys this addon reads (X-SpokenQuests-DataModule-*) beside the
    inherited X-VoiceOver-DataModule-* ones it already has, and gains the language the
    pack was recorded in (X-SpokenQuests-Language). The inherited keys are kept, not
    replaced: the same folder then still loads under upstream AI_VoiceOver.

  - Module.lua is rewritten to register under the converted folder's own name, since
    the registration name and the folder name must agree.

  - the lookup tables and the audio are NOT touched. They are the pack's substance and
    the conversion has no opinion about them; a legacy table is already the shape
    DataModules reads.

The audio is left where it is by default (`--link`, a symlink into the source tree):
a legacy pack runs to gigabytes, and copying it to test a TOC change is a poor trade.
`--copy` makes a standalone folder when one is actually wanted.

This tool reads a pack; it does not publish one. A converted third-party pack carries
whatever licence its author gave it -- for the ptBR Vanilla pack that motivated this,
All Rights Reserved -- so its output belongs on the machine that ran the conversion and
nowhere else.
"""
import os
import re
import shutil

#: The key the converted pack declares its language with. Read by
#: addons/SpokenQuests/Language.lua; absent means enUS.
LANGUAGE_KEY = "X-SpokenQuests-Language"

#: The module keys, in both generations. A converted pack carries both so that it loads
#: under this addon and under the upstream it came from.
NEW_PREFIX = "X-SpokenQuests-DataModule-"
OLD_PREFIX = "X-VoiceOver-DataModule-"

#: The suffixes worth carrying over. Anything else in the legacy TOC is left as it is.
MODULE_SUFFIXES = ("Version", "Priority", "Maps")

MODULE_LUA = """if not VoiceOver or not VoiceOver.DataModules then return end

{module} = {{}}

function {module}:GetSoundPath(fileName, event)
    setfenv(1, VoiceOver)
    if Enums.SoundEvent:IsQuestEvent(event) then
        return format([[generated\\sounds\\quests\\%s{extension}]], fileName)
    elseif Enums.SoundEvent:IsGossipEvent(event) then
        return format([[generated\\sounds\\gossip\\%s{extension}]], fileName)
    end
end

VoiceOver.DataModules:Register("{module}", {module})
"""


class ConversionError(Exception):
    """The source is not a pack this tool can convert."""


def find_toc(pack_dir: str) -> str:
    """The pack's TOC.

    A pack folder holds exactly one; more than one means a client-flavored addon rather
    than a data pack, and this tool would not know which to convert.
    """
    tocs = sorted(name for name in os.listdir(pack_dir) if name.endswith(".toc"))
    if not tocs:
        raise ConversionError(f"No .toc in {pack_dir}: not an addon folder")
    if len(tocs) > 1:
        raise ConversionError(
            f"{len(tocs)} .toc files in {pack_dir} ({', '.join(tocs)}): "
            "a data pack has one")
    return os.path.join(pack_dir, tocs[0])


def read_toc_keys(toc_text: str) -> dict:
    """The `## Key: value` header lines, as a dict. Later duplicates win, as the client does."""
    keys = {}
    for line in toc_text.splitlines():
        match = re.match(r"^##\s*([^:]+):\s*(.*)$", line)
        if match:
            keys[match.group(1).strip()] = match.group(2).strip()
    return keys


def module_key(keys: dict, suffix: str):
    """One module key, whichever generation the pack declares it in.

    The same precedence DataModules:ModuleMeta uses: the new key first, so a pack
    already carrying both converts to what it already says.
    """
    for prefix in (NEW_PREFIX, OLD_PREFIX):
        value = keys.get(prefix + suffix)
        if value:
            return value
    return None


def audio_extension(pack_dir: str) -> str:
    """The extension the pack's audio actually uses, read off the files.

    Legacy packs ship mp3; this project's own ship ogg. Guessing wrong produces a pack
    whose every path is broken, and the file tree is right there to ask.
    """
    sounds = os.path.join(pack_dir, "generated", "sounds")
    for root, _dirs, files in os.walk(sounds):
        for name in sorted(files):
            stem, extension = os.path.splitext(name)
            if extension.lower() in (".mp3", ".ogg"):
                return extension.lower()
    raise ConversionError(
        f"No .mp3 or .ogg under {sounds}: nothing to convert")


def convert_toc(toc_text: str, language: str, module_name: str) -> str:
    """The converted TOC text.

    Both key generations are written with the values the source declared, the language
    is stamped, and every other line the source carried is kept -- including Notes and
    LoadOnDemand, which a pack needs and this tool has no better answer for.
    """
    keys = read_toc_keys(toc_text)
    if module_key(keys, "Version") is None:
        raise ConversionError(
            "No X-SpokenQuests-DataModule-Version or X-VoiceOver-DataModule-Version "
            "in the TOC: this addon is not a sound pack")

    managed = {LANGUAGE_KEY}
    for prefix in (NEW_PREFIX, OLD_PREFIX):
        for suffix in MODULE_SUFFIXES:
            managed.add(prefix + suffix)

    out = []
    inserted = False
    for line in toc_text.splitlines():
        match = re.match(r"^##\s*([^:]+):\s*(.*)$", line)
        name = match.group(1).strip() if match else None
        if name in managed:
            # Dropped here and re-emitted together below, so the converted pack has one
            # block of module keys rather than the source's scattering plus ours.
            if not inserted:
                inserted = True
                for prefix in (NEW_PREFIX, OLD_PREFIX):
                    for suffix in MODULE_SUFFIXES:
                        value = module_key(keys, suffix)
                        if value is not None:
                            out.append(f"## {prefix}{suffix}: {value}")
                out.append(f"## {LANGUAGE_KEY}: {language}")
            continue
        if name == "Title":
            out.append(f"## Title: {match.group(2).strip()} ({language})")
            continue
        out.append(line)

    return "\n".join(out) + "\n"


def convert(pack_dir: str, out_dir: str, language: str, module_name: str = None,
            copy: bool = False) -> dict:
    """Convert the pack at `pack_dir` into `out_dir`. Returns a report.

    `module_name` defaults to the output folder's name, which is what the client will
    call the addon and therefore what Module.lua must register under.
    """
    if not os.path.isdir(pack_dir):
        raise ConversionError(f"{pack_dir} is not a directory")
    if os.path.abspath(pack_dir) == os.path.abspath(out_dir):
        raise ConversionError("Refusing to convert a pack over itself")

    toc_path = find_toc(pack_dir)
    with open(toc_path, encoding="utf-8-sig") as f:
        toc_text = f.read()

    module_name = module_name or os.path.basename(os.path.normpath(out_dir))
    extension = audio_extension(pack_dir)

    os.makedirs(out_dir, exist_ok=True)

    # The lookup tables: copied rather than linked. They are small, and a converted pack
    # whose tables move when the source is deleted is a trap.
    generated_src = os.path.join(pack_dir, "generated")
    generated_out = os.path.join(out_dir, "generated")
    os.makedirs(generated_out, exist_ok=True)
    tables = []
    for name in sorted(os.listdir(generated_src)):
        if name.endswith(".lua"):
            shutil.copy2(os.path.join(generated_src, name),
                         os.path.join(generated_out, name))
            tables.append(name)
    if not tables:
        raise ConversionError(f"No lookup tables in {generated_src}")

    # The audio: linked by default. Gigabytes that the conversion does not change.
    sounds_src = os.path.join(generated_src, "sounds")
    sounds_out = os.path.join(generated_out, "sounds")
    if os.path.lexists(sounds_out):
        if os.path.islink(sounds_out):
            os.unlink(sounds_out)
        else:
            shutil.rmtree(sounds_out)
    if copy:
        shutil.copytree(sounds_src, sounds_out)
    else:
        os.symlink(os.path.abspath(sounds_src), sounds_out)

    with open(os.path.join(out_dir, "Module.lua"), "w", encoding="utf-8") as f:
        f.write(MODULE_LUA.format(module=module_name, extension=extension))

    out_toc = os.path.join(out_dir, module_name + ".toc")
    with open(out_toc, "w", encoding="utf-8") as f:
        f.write(convert_toc(toc_text, language, module_name))

    return {
        "packDir": out_dir,
        "moduleName": module_name,
        "language": language,
        "audioFormat": extension,
        "audioLinked": not copy,
        "tables": tables,
        "sourceToc": os.path.basename(toc_path),
    }
