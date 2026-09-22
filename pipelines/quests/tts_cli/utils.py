import re

def get_first_n_words(text, n):
    words = re.findall(r'\S+', text)
    first_n_words = words[:n]
    return ' '.join(first_n_words)

def get_last_n_words(text, n):
    words = re.findall(r'\S+', text)
    last_n_words = words[-n:]
    return ' '.join(last_n_words)
    
def replace_dollar_bs_with_space(text):
    pattern = r'(\$[Bb])+'
    result = re.sub(pattern, ' ', text)
    return result

#: The locale columns vmangos carries, by the number its *_locN columns are suffixed with.
#: This is the world database's own list, not a list of languages a pack may be recorded
#: in - the two are routinely confused and they are not the same thing. Portuguese is the
#: case that proves it: a ptBR pack is perfectly legal (the addon reads
#: X-SpokenQuests-Language: ptBR), but vmangos has no Portuguese column to extract its text
#: from, so a ptBR corpus has to come from somewhere else.
LOCALE_NUMBERS = {
    "enUS": 0, "enGB": 0,
    "koKR": 1,
    "frFR": 2,
    "deDE": 3,
    "zhCN": 4,    # Simplified chinese
    "zhTW": 5,    # Traditional chinese
    "esES": 6,    # European spanish
    "esMX": 7,    # Mexican spanish
    "ruRU": 8,
}


def language_code_to_language_number(local_code: str) -> int:
    """The vmangos locale column for a language code.

    Raises for a language the world database does not carry. The message says so
    explicitly rather than just 'unsupported': the useful distinction for a caller is
    between a typo and a language that genuinely has no text in the dump, because the
    second one needs a translated corpus rather than a bug fix.
    """
    try:
        return LOCALE_NUMBERS[local_code]
    except KeyError:
        raise ValueError(
            f"{local_code} is not a locale the vmangos world database carries "
            f"(it has {', '.join(sorted(LOCALE_NUMBERS))}). A pack can still be recorded "
            f"in {local_code} - the addon reads any language from the pack's TOC - but its "
            "text must come from a translated corpus, not from a *_locN column."
        ) from None
