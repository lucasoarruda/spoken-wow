-- Seed a first pronunciation lexicon for every language other than English, once.
--
-- Each was adapted from English's lexicon as it stood in production on 2026-09-24 (145
-- entries), against that language's own text: the grapheme is the word as the language's
-- corpus writes it, and the IPA is how a narrator speaking that language would say it. They
-- are a starting point, written without listening, so an entry the author was unsure of is
-- marked "check" and its note says what to listen for.
--
-- IPA only, never a respelling, and no length mark: eleven_v3 mis-realises a vowel carrying
-- one. Whole-word matching is why the inflected languages carry a form per case or plural
-- (Тралла is not covered by Тралл), and why Chinese and Korean carry so few - their names
-- are written in scripts with fixed readings, and the entries left are polyphones, Latin
-- strings and numerals.
--
-- Like 0008, this is the only copy of these seeds in the repo, and editing the entries below
-- changes nothing: migrations run once. Changes are made in the editor at /{lang}/lexicon.
--
-- ON CONFLICT DO NOTHING because a language may already have a lexicon somebody saved, and
-- a seed must never overwrite real work. A seeded row has no dictionary yet, so it is in
-- force only once an admin with an ElevenLabs key presses Upload on that language's page.
--
-- Additive: the previous release reads these rows the way it reads any saved lexicon.

-- deDE: 208 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('deDE', $lexicon$[
  {
    "grapheme": "Magatha",
    "confidence": "check",
    "ipa": "ˈmaɡata",
    "note": "TH as plain t, German style"
  },
  {
    "grapheme": "Magathas",
    "confidence": "check",
    "ipa": "ˈmaɡatas",
    "note": "genitive"
  },
  {
    "grapheme": "Narache",
    "confidence": "check",
    "ipa": "naˈʁatʃi",
    "note": "keeps English CH /tʃ/ and final i; German reading would give x and a schwa"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ˌooˈɪks",
    "note": "letter names O-O-X, German"
  },
  {
    "grapheme": "Draenor",
    "confidence": "check",
    "ipa": "ˈdʁɛnɔʁ",
    "note": "AE as ä, two syllables; was an alias in English"
  },
  {
    "grapheme": "Draenors",
    "confidence": "check",
    "ipa": "ˈdʁɛnɔʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Maiev",
    "confidence": "check",
    "ipa": "ˈmaɪɛf",
    "note": "MY-ev with German final devoicing"
  },
  {
    "grapheme": "Satyrnaar",
    "confidence": "check",
    "ipa": "ˈzatʏʁnaʁ",
    "note": "built on German Satyr (z, ʏ)"
  },
  {
    "grapheme": "Alterac",
    "confidence": "high",
    "ipa": "ˈaltəʁak",
    "note": "pin first-syllable stress"
  },
  {
    "grapheme": "Alteracs",
    "confidence": "high",
    "ipa": "ˈaltəʁaks",
    "note": "genitive"
  },
  {
    "grapheme": "Alteractal",
    "confidence": "high",
    "ipa": "ˈaltəʁakˌtal",
    "note": "compound: Alterac valley"
  },
  {
    "grapheme": "Alteractals",
    "confidence": "high",
    "ipa": "ˈaltəʁakˌtals",
    "note": "compound genitive"
  },
  {
    "grapheme": "Alteracgebirge",
    "confidence": "high",
    "ipa": "ˈaltəʁakɡəˌbɪʁɡə",
    "note": "compound: Alterac Mountains"
  },
  {
    "grapheme": "Alteracgebirges",
    "confidence": "high",
    "ipa": "ˈaltəʁakɡəˌbɪʁɡəs",
    "note": "compound genitive"
  },
  {
    "grapheme": "Gnomeregan",
    "confidence": "check",
    "ipa": "ˈɡnoməʁeɡan",
    "note": "German Gnom keeps its G; unlike English the G is spoken"
  },
  {
    "grapheme": "Gnomereganverbannten",
    "confidence": "check",
    "ipa": "ˈɡnoməʁeɡanfɛʁˌbantən",
    "note": "compound: Gnomeregan exiles"
  },
  {
    "grapheme": "Azeroth",
    "confidence": "high",
    "ipa": "ˈazəʁɔt",
    "note": "German: TH as t"
  },
  {
    "grapheme": "Azeroths",
    "confidence": "high",
    "ipa": "ˈazəʁɔts",
    "note": "genitive"
  },
  {
    "grapheme": "Kalimdor",
    "confidence": "high",
    "ipa": "ˈkalɪmdɔʁ"
  },
  {
    "grapheme": "Kalimdors",
    "confidence": "high",
    "ipa": "ˈkalɪmdɔʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Lordaeron",
    "confidence": "check",
    "ipa": "ˈlɔʁdəʁɔn",
    "note": "three syllables as in English; German readers may say LOR-dä-ron"
  },
  {
    "grapheme": "Lordaerons",
    "confidence": "check",
    "ipa": "ˈlɔʁdəʁɔns",
    "note": "genitive"
  },
  {
    "grapheme": "Quel'Thalas",
    "confidence": "high",
    "ipa": "kɛlˈtalas",
    "note": "QU as k, not kv; TH as t"
  },
  {
    "grapheme": "Eldre'Thalas",
    "confidence": "check",
    "ipa": "ɛlˈdʁetalas"
  },
  {
    "grapheme": "Kel'Thuzad",
    "confidence": "high",
    "ipa": "kɛlˈtuzat",
    "note": "final devoicing"
  },
  {
    "grapheme": "Kel'Thuzads",
    "confidence": "high",
    "ipa": "kɛlˈtuzats",
    "note": "genitive"
  },
  {
    "grapheme": "Naxxramas",
    "confidence": "high",
    "ipa": "naksˈʁamas"
  },
  {
    "grapheme": "Ahn'Qiraj",
    "confidence": "check",
    "ipa": "anˈkiʁaʃ",
    "note": "final J: ʒ devoiced to ʃ in German; English note says contested ʒ/dʒ"
  },
  {
    "grapheme": "Ahn'Qirajs",
    "confidence": "check",
    "ipa": "anˈkiʁaʃs",
    "note": "genitive"
  },
  {
    "grapheme": "Qiraji",
    "confidence": "high",
    "ipa": "kiˈʁaʒi",
    "note": "Q as k, J as ʒ"
  },
  {
    "grapheme": "Qirajifeinde",
    "confidence": "high",
    "ipa": "kiˈʁaʒiˌfaɪndə",
    "note": "compound"
  },
  {
    "grapheme": "Qirajimacht",
    "confidence": "high",
    "ipa": "kiˈʁaʒiˌmaxt",
    "note": "compound"
  },
  {
    "grapheme": "Qirajimagie",
    "confidence": "high",
    "ipa": "kiˈʁaʒimaˌɡi",
    "note": "compound"
  },
  {
    "grapheme": "Qirajiartefakte",
    "confidence": "high",
    "ipa": "kiˈʁaʒiaʁtəˌfaktə",
    "note": "compound"
  },
  {
    "grapheme": "Qirajibestandteilen",
    "confidence": "high",
    "ipa": "kiˈʁaʒibəˌʃtanttaɪlən",
    "note": "compound"
  },
  {
    "grapheme": "C'Thun",
    "confidence": "high",
    "ipa": "kəˈtun",
    "note": "TH as t"
  },
  {
    "grapheme": "C'Thuns",
    "confidence": "high",
    "ipa": "kəˈtuns",
    "note": "genitive"
  },
  {
    "grapheme": "Silithus",
    "confidence": "check",
    "ipa": "ˈzilitʊs",
    "note": "German voiced initial s; keep Silithiden consistent"
  },
  {
    "grapheme": "Silithid",
    "confidence": "check",
    "ipa": "ˈzilitɪt",
    "note": "final devoicing"
  },
  {
    "grapheme": "Silithiden",
    "confidence": "check",
    "ipa": "ziliˈtidən",
    "note": "German plural, stress shifts to -TI-"
  },
  {
    "grapheme": "Zul'Farrak",
    "confidence": "check",
    "ipa": "tsulˈfaʁak",
    "note": "German Z as ts"
  },
  {
    "grapheme": "Zul'Gurub",
    "confidence": "check",
    "ipa": "tsulɡuˈʁup",
    "note": "German Z as ts, final devoicing"
  },
  {
    "grapheme": "Zul'Gurubs",
    "confidence": "check",
    "ipa": "tsulɡuˈʁups",
    "note": "genitive"
  },
  {
    "grapheme": "Zandalar",
    "confidence": "check",
    "ipa": "ˈtsandalaʁ",
    "note": "German Z as ts"
  },
  {
    "grapheme": "Zandalars",
    "confidence": "check",
    "ipa": "ˈtsandalaʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Zandalari",
    "confidence": "check",
    "ipa": "tsandaˈlaʁi",
    "note": "not in English lexicon as a form: the trolls themselves"
  },
  {
    "grapheme": "Zandalarianer",
    "confidence": "check",
    "ipa": "tsandalaʁiˈanɐ",
    "note": "German demonym"
  },
  {
    "grapheme": "zandalarianischen",
    "confidence": "check",
    "ipa": "tsandalaʁiˈanɪʃən",
    "note": "German adjective"
  },
  {
    "grapheme": "zandalarianische",
    "confidence": "check",
    "ipa": "tsandalaʁiˈanɪʃə",
    "note": "German adjective"
  },
  {
    "grapheme": "Atal'ai",
    "confidence": "high",
    "ipa": "ˈatalaɪ"
  },
  {
    "grapheme": "Atal'Hakkar",
    "confidence": "check",
    "ipa": "atalˈhakaʁ"
  },
  {
    "grapheme": "Hakkar",
    "confidence": "high",
    "ipa": "ˈhakaʁ"
  },
  {
    "grapheme": "Hakkars",
    "confidence": "high",
    "ipa": "ˈhakaʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Hakkari",
    "confidence": "high",
    "ipa": "haˈkaʁi"
  },
  {
    "grapheme": "Hakkarigötze",
    "confidence": "high",
    "ipa": "haˈkaʁiˌɡœtsə",
    "note": "compound"
  },
  {
    "grapheme": "Jin'do",
    "confidence": "check",
    "ipa": "ˈdʒɪndo",
    "note": "J as dʒ, not German j"
  },
  {
    "grapheme": "Un'Goro",
    "confidence": "high",
    "ipa": "ʊnˈɡoʁo"
  },
  {
    "grapheme": "Un'Goros",
    "confidence": "high",
    "ipa": "ʊnˈɡoʁos",
    "note": "genitive"
  },
  {
    "grapheme": "Teldrassil",
    "confidence": "high",
    "ipa": "tɛlˈdʁasɪl"
  },
  {
    "grapheme": "Teldrassils",
    "confidence": "high",
    "ipa": "tɛlˈdʁasɪls",
    "note": "genitive"
  },
  {
    "grapheme": "Darnassus",
    "confidence": "high",
    "ipa": "daʁˈnasʊs"
  },
  {
    "grapheme": "Dolanaar",
    "confidence": "high",
    "ipa": "dolaˈnaʁ"
  },
  {
    "grapheme": "Auberdine",
    "confidence": "check",
    "ipa": "ˈobɐdin",
    "note": "French-style AU as o, silent final e; German readers would say OW-ber-dee-ne"
  },
  {
    "grapheme": "Auberdines",
    "confidence": "check",
    "ipa": "ˈobɐdins",
    "note": "genitive"
  },
  {
    "grapheme": "Rut'theran",
    "confidence": "check",
    "ipa": "ˈʁuttəʁan"
  },
  {
    "grapheme": "Ban'ethil",
    "confidence": "check",
    "ipa": "banˈetɪl"
  },
  {
    "grapheme": "Tirisfal",
    "confidence": "high",
    "ipa": "ˈtɪʁɪsfal"
  },
  {
    "grapheme": "Tirisfals",
    "confidence": "high",
    "ipa": "ˈtɪʁɪsfals",
    "note": "genitive"
  },
  {
    "grapheme": "Desolace",
    "confidence": "check",
    "ipa": "ˈdɛzolɛs",
    "note": "DES-o-lace; German readers may add a final syllable"
  },
  {
    "grapheme": "Feralas",
    "confidence": "high",
    "ipa": "feˈʁalas"
  },
  {
    "grapheme": "Tanaris",
    "confidence": "high",
    "ipa": "taˈnaʁɪs"
  },
  {
    "grapheme": "Tanariswüste",
    "confidence": "high",
    "ipa": "taˈnaʁɪsˌvʏstə",
    "note": "compound: Tanaris desert"
  },
  {
    "grapheme": "Uldaman",
    "confidence": "high",
    "ipa": "ˈʊldaman"
  },
  {
    "grapheme": "Dalaran",
    "confidence": "high",
    "ipa": "ˈdalaʁan"
  },
  {
    "grapheme": "Dalarans",
    "confidence": "high",
    "ipa": "ˈdalaʁans",
    "note": "genitive"
  },
  {
    "grapheme": "Stromgarde",
    "confidence": "check",
    "ipa": "ˈstʁɔmɡaʁt",
    "note": "English st kept, silent final e; ʃt (German Strom) is plausible"
  },
  {
    "grapheme": "Stromgardes",
    "confidence": "check",
    "ipa": "ˈstʁɔmɡaʁts",
    "note": "genitive"
  },
  {
    "grapheme": "Arathi",
    "confidence": "high",
    "ipa": "aˈʁati"
  },
  {
    "grapheme": "Arathibecken",
    "confidence": "high",
    "ipa": "aˈʁatiˌbɛkən",
    "note": "compound: Arathi Basin, very frequent"
  },
  {
    "grapheme": "Arathibeckens",
    "confidence": "high",
    "ipa": "aˈʁatiˌbɛkəns",
    "note": "compound genitive"
  },
  {
    "grapheme": "Arathihochland",
    "confidence": "high",
    "ipa": "aˈʁatiˌhoxlant",
    "note": "compound: Arathi Highlands"
  },
  {
    "grapheme": "Arathihochlands",
    "confidence": "high",
    "ipa": "aˈʁatiˌhoxlants",
    "note": "compound genitive"
  },
  {
    "grapheme": "Arathor",
    "confidence": "high",
    "ipa": "ˈaʁatɔʁ"
  },
  {
    "grapheme": "Arathors",
    "confidence": "high",
    "ipa": "ˈaʁatɔʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Andorhal",
    "confidence": "high",
    "ipa": "ˈandɔʁhal"
  },
  {
    "grapheme": "Stratholme",
    "confidence": "check",
    "ipa": "ˈstʁatɔlm",
    "note": "English VO drops the L (STRATH-ome); German readers say it; st vs ʃt also open"
  },
  {
    "grapheme": "Stratholmes",
    "confidence": "check",
    "ipa": "ˈstʁatɔlms",
    "note": "genitive"
  },
  {
    "grapheme": "Scholomance",
    "confidence": "high",
    "ipa": "ˈskolomans",
    "note": "SCH is sk, not German ʃ"
  },
  {
    "grapheme": "Kharanos",
    "confidence": "high",
    "ipa": "ˈkaʁanɔs"
  },
  {
    "grapheme": "Morogh",
    "confidence": "check",
    "ipa": "ˈmoʁɔk",
    "note": "Dun Morogh; English silent GH, German readers say a final k"
  },
  {
    "grapheme": "Modan",
    "confidence": "high",
    "ipa": "ˈmodan",
    "note": "Loch Modan"
  },
  {
    "grapheme": "Modans",
    "confidence": "high",
    "ipa": "ˈmodans",
    "note": "genitive"
  },
  {
    "grapheme": "Elwynn",
    "confidence": "check",
    "ipa": "ˈɛlvɪn",
    "note": "German W as v"
  },
  {
    "grapheme": "Mulgore",
    "confidence": "high",
    "ipa": "ˈmʊlɡɔʁ",
    "note": "MULL-gore, silent final e"
  },
  {
    "grapheme": "Mulgores",
    "confidence": "high",
    "ipa": "ˈmʊlɡɔʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Durotar",
    "confidence": "high",
    "ipa": "ˈduʁotaʁ"
  },
  {
    "grapheme": "Durotars",
    "confidence": "high",
    "ipa": "ˈduʁotaʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Orgrimmar",
    "confidence": "high",
    "ipa": "ˈɔʁɡʁɪmaʁ"
  },
  {
    "grapheme": "Orgrimmars",
    "confidence": "high",
    "ipa": "ˈɔʁɡʁɪmaʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Orgrimmarlegion",
    "confidence": "high",
    "ipa": "ˈɔʁɡʁɪmaʁleˌɡjon",
    "note": "compound"
  },
  {
    "grapheme": "Theramore",
    "confidence": "high",
    "ipa": "ˈteʁamɔʁ",
    "note": "TH as t, silent final e"
  },
  {
    "grapheme": "Theramores",
    "confidence": "high",
    "ipa": "ˈteʁamɔʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Gadgetzan",
    "confidence": "check",
    "ipa": "ˈɡɛdʒətsan",
    "note": "English gadget, German z as ts"
  },
  {
    "grapheme": "Gadgetzans",
    "confidence": "check",
    "ipa": "ˈɡɛdʒətsans",
    "note": "genitive"
  },
  {
    "grapheme": "Azshara",
    "confidence": "check",
    "ipa": "aˈʃaʁa",
    "note": "ZSH as one ʃ; English has ʒʃ"
  },
  {
    "grapheme": "Azsharas",
    "confidence": "check",
    "ipa": "aˈʃaʁas",
    "note": "genitive"
  },
  {
    "grapheme": "Sen'jin",
    "confidence": "check",
    "ipa": "ˈsɛndʒɪn",
    "note": "voiceless s and dʒ, not German z / j"
  },
  {
    "grapheme": "Grom'gol",
    "confidence": "high",
    "ipa": "ˈɡʁɔmɡɔl"
  },
  {
    "grapheme": "Zoram",
    "confidence": "check",
    "ipa": "ˈtsoʁam",
    "note": "German Z as ts"
  },
  {
    "grapheme": "Zoramstrand",
    "confidence": "check",
    "ipa": "ˈtsoʁamˌʃtʁant",
    "note": "compound: Zoram Strand"
  },
  {
    "grapheme": "Zoramstrands",
    "confidence": "check",
    "ipa": "ˈtsoʁamˌʃtʁants",
    "note": "compound genitive"
  },
  {
    "grapheme": "Zoramstrandes",
    "confidence": "check",
    "ipa": "ˈtsoʁamˌʃtʁandəs",
    "note": "compound genitive"
  },
  {
    "grapheme": "Zoraschwarms",
    "confidence": "check",
    "ipa": "ˈtsoʁaˌʃvaʁms",
    "note": "German for Hive'Zora; Z as ts"
  },
  {
    "grapheme": "Blackfathom",
    "confidence": "check",
    "ipa": "ˈblɛkfɛsəm",
    "note": "German has no ð; voiced TH approximated with s"
  },
  {
    "grapheme": "Winterspring",
    "confidence": "check",
    "ipa": "ˈvɪntɐspʁɪŋ",
    "note": "English name kept; German W and er; sp not ʃp"
  },
  {
    "grapheme": "Caer",
    "confidence": "check",
    "ipa": "kɛʁ",
    "note": "Caer Darrow; one syllable"
  },
  {
    "grapheme": "Thelsamar",
    "confidence": "high",
    "ipa": "tɛlˈsamaʁ"
  },
  {
    "grapheme": "Thrall",
    "confidence": "high",
    "ipa": "tʁal",
    "note": "German VO: TRALL, short a"
  },
  {
    "grapheme": "Thralls",
    "confidence": "high",
    "ipa": "tʁals",
    "note": "genitive"
  },
  {
    "grapheme": "Sylvanas",
    "confidence": "high",
    "ipa": "zʏlˈvanas",
    "note": "German VO: z and ʏ, stress on -VA-"
  },
  {
    "grapheme": "Tyrande",
    "confidence": "check",
    "ipa": "tiˈʁandə",
    "note": "English ends -day; German readers give a schwa"
  },
  {
    "grapheme": "Tyrandes",
    "confidence": "check",
    "ipa": "tiˈʁandəs",
    "note": "genitive"
  },
  {
    "grapheme": "Cenarius",
    "confidence": "check",
    "ipa": "tseˈnaʁiʊs",
    "note": "German C before e as ts"
  },
  {
    "grapheme": "Cenarion",
    "confidence": "check",
    "ipa": "tseˈnaʁiɔn"
  },
  {
    "grapheme": "Elune",
    "confidence": "check",
    "ipa": "eˈlunə",
    "note": "German readers voice the final e"
  },
  {
    "grapheme": "Elunes",
    "confidence": "check",
    "ipa": "eˈlunəs",
    "note": "genitive"
  },
  {
    "grapheme": "Ragnaros",
    "confidence": "high",
    "ipa": "ˈʁaɡnaʁɔs"
  },
  {
    "grapheme": "Nefarian",
    "confidence": "high",
    "ipa": "neˈfaʁian"
  },
  {
    "grapheme": "Nefarians",
    "confidence": "high",
    "ipa": "neˈfaʁians",
    "note": "genitive"
  },
  {
    "grapheme": "Arthas",
    "confidence": "high",
    "ipa": "ˈaʁtas",
    "note": "TH as t; Arthas' genitive is covered by this entry"
  },
  {
    "grapheme": "Uther",
    "confidence": "high",
    "ipa": "ˈutɐ",
    "note": "TH as t"
  },
  {
    "grapheme": "Uthers",
    "confidence": "high",
    "ipa": "ˈutɐs",
    "note": "genitive"
  },
  {
    "grapheme": "Bolvar",
    "confidence": "high",
    "ipa": "ˈbɔlvaʁ",
    "note": "V as v, not f"
  },
  {
    "grapheme": "Cairne",
    "confidence": "high",
    "ipa": "kɛʁn",
    "note": "one syllable, not KA-ir-ne"
  },
  {
    "grapheme": "Cairnes",
    "confidence": "high",
    "ipa": "kɛʁns",
    "note": "genitive"
  },
  {
    "grapheme": "Mekkatorque",
    "confidence": "high",
    "ipa": "ˈmɛkatɔʁk",
    "note": "silent -que"
  },
  {
    "grapheme": "Mekkatorques",
    "confidence": "high",
    "ipa": "ˈmɛkatɔʁks",
    "note": "genitive"
  },
  {
    "grapheme": "Medivh",
    "confidence": "high",
    "ipa": "meˈdif",
    "note": "VH is a plain v, devoiced to f at word end"
  },
  {
    "grapheme": "Medivhs",
    "confidence": "high",
    "ipa": "meˈdifs",
    "note": "genitive"
  },
  {
    "grapheme": "Ysera",
    "confidence": "check",
    "ipa": "iˈzeʁa"
  },
  {
    "grapheme": "Yseras",
    "confidence": "check",
    "ipa": "iˈzeʁas",
    "note": "genitive"
  },
  {
    "grapheme": "Staghelm",
    "confidence": "check",
    "ipa": "ˈstakhɛlm",
    "note": "st, not ʃt"
  },
  {
    "grapheme": "Staghelms",
    "confidence": "check",
    "ipa": "ˈstakhɛlms",
    "note": "genitive"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "high",
    "ipa": "malˈfuʁiɔn"
  },
  {
    "grapheme": "Malfurions",
    "confidence": "high",
    "ipa": "malˈfuʁiɔns",
    "note": "genitive"
  },
  {
    "grapheme": "Arugal",
    "confidence": "high",
    "ipa": "ˈaʁuɡal"
  },
  {
    "grapheme": "Arugals",
    "confidence": "high",
    "ipa": "ˈaʁuɡals",
    "note": "genitive"
  },
  {
    "grapheme": "Amnennar",
    "confidence": "check",
    "ipa": "amˈnɛnaʁ"
  },
  {
    "grapheme": "Charlga",
    "confidence": "check",
    "ipa": "ˈtʃaʁlɡa",
    "note": "CH as tʃ, not German ç/x"
  },
  {
    "grapheme": "Razorflank",
    "confidence": "check",
    "ipa": "ˈʁezɐflɛŋk",
    "note": "English name kept"
  },
  {
    "grapheme": "Razorflanks",
    "confidence": "check",
    "ipa": "ˈʁezɐflɛŋks",
    "note": "genitive"
  },
  {
    "grapheme": "Dathrohan",
    "confidence": "check",
    "ipa": "ˈdatʁohan"
  },
  {
    "grapheme": "Naralex",
    "confidence": "high",
    "ipa": "ˈnaʁalɛks"
  },
  {
    "grapheme": "Theradras",
    "confidence": "check",
    "ipa": "teˈʁadʁas"
  },
  {
    "grapheme": "Zaetar",
    "confidence": "check",
    "ipa": "ˈtsɛtaʁ",
    "note": "German Z as ts, AE as ä"
  },
  {
    "grapheme": "Zaetars",
    "confidence": "check",
    "ipa": "ˈtsɛtaʁs",
    "note": "genitive"
  },
  {
    "grapheme": "Valthalak",
    "confidence": "high",
    "ipa": "ˈvaltalak",
    "note": "V as v, not German f"
  },
  {
    "grapheme": "Valthalaks",
    "confidence": "high",
    "ipa": "ˈvaltalaks",
    "note": "genitive; the more frequent form"
  },
  {
    "grapheme": "Silverlaine",
    "confidence": "check",
    "ipa": "ˈsɪlvɐlen",
    "note": "English name kept"
  },
  {
    "grapheme": "Barov",
    "confidence": "high",
    "ipa": "ˈbaʁɔf",
    "note": "final devoicing"
  },
  {
    "grapheme": "Barovs",
    "confidence": "high",
    "ipa": "ˈbaʁɔfs",
    "note": "genitive"
  },
  {
    "grapheme": "Norgannon",
    "confidence": "high",
    "ipa": "ˈnɔʁɡanɔn"
  },
  {
    "grapheme": "Agamaggan",
    "confidence": "check",
    "ipa": "ˌaɡaˈmaɡan"
  },
  {
    "grapheme": "Aku'mai",
    "confidence": "high",
    "ipa": "ˈakumaɪ"
  },
  {
    "grapheme": "Thunderbrew",
    "confidence": "check",
    "ipa": "ˈtandɐbʁu",
    "note": "English name left untranslated in two lines (elsewhere Donnerbräu)"
  },
  {
    "grapheme": "Runetotem",
    "confidence": "check",
    "ipa": "ˈʁuntotɛm",
    "note": "English Rune + totem, two words' worth; silent e"
  },
  {
    "grapheme": "Bloodhoof",
    "confidence": "check",
    "ipa": "ˈbladhuf",
    "note": "English name kept"
  },
  {
    "grapheme": "Trollbane",
    "confidence": "check",
    "ipa": "ˈtʁɔlben",
    "note": "English name; also appears as German Trollbann"
  },
  {
    "grapheme": "Trollbanes",
    "confidence": "check",
    "ipa": "ˈtʁɔlbens",
    "note": "genitive"
  },
  {
    "grapheme": "Lightbringer",
    "confidence": "high",
    "ipa": "ˈlaɪtbʁɪŋɐ",
    "note": "English name kept"
  },
  {
    "grapheme": "Lightbringers",
    "confidence": "high",
    "ipa": "ˈlaɪtbʁɪŋɐs",
    "note": "genitive"
  },
  {
    "grapheme": "Sul'thraze",
    "confidence": "check",
    "ipa": "sʊlˈtʁes"
  },
  {
    "grapheme": "Trol'kalar",
    "confidence": "high",
    "ipa": "tʁɔlˈkalaʁ"
  },
  {
    "grapheme": "Mosh'aru",
    "confidence": "high",
    "ipa": "mɔʃˈaʁu"
  },
  {
    "grapheme": "Gri'lek",
    "confidence": "high",
    "ipa": "ˈɡʁilɛk"
  },
  {
    "grapheme": "Jammal'an",
    "confidence": "check",
    "ipa": "dʒaˈmalan",
    "note": "J as dʒ"
  },
  {
    "grapheme": "Jammal'ans",
    "confidence": "check",
    "ipa": "dʒaˈmalans",
    "note": "genitive"
  },
  {
    "grapheme": "Mai'Zoth",
    "confidence": "check",
    "ipa": "maɪˈtsɔt",
    "note": "German Z as ts, TH as t"
  },
  {
    "grapheme": "Lar'korwi",
    "confidence": "high",
    "ipa": "laʁˈkɔʁvi"
  },
  {
    "grapheme": "Lar'korwis",
    "confidence": "high",
    "ipa": "laʁˈkɔʁvis",
    "note": "genitive"
  },
  {
    "grapheme": "Mar'alith",
    "confidence": "high",
    "ipa": "maʁˈalɪt"
  },
  {
    "grapheme": "Mor'zul",
    "confidence": "high",
    "ipa": "mɔʁˈtsul"
  },
  {
    "grapheme": "Mor'zuls",
    "confidence": "high",
    "ipa": "mɔʁˈtsuls",
    "note": "genitive"
  },
  {
    "grapheme": "Gor'mul",
    "confidence": "check",
    "ipa": "ɡɔʁˈmul"
  },
  {
    "grapheme": "Rin'ji",
    "confidence": "high",
    "ipa": "ˈʁɪndʒi",
    "note": "J as dʒ"
  },
  {
    "grapheme": "Rin'jis",
    "confidence": "high",
    "ipa": "ˈʁɪndʒis",
    "note": "genitive"
  },
  {
    "grapheme": "Zando'zan",
    "confidence": "high",
    "ipa": "ˈtsandotsan"
  },
  {
    "grapheme": "Bath'rah",
    "confidence": "high",
    "ipa": "ˈbatʁa"
  },
  {
    "grapheme": "Jen'shan",
    "confidence": "high",
    "ipa": "ˈdʒɛnʃan",
    "note": "J as dʒ"
  },
  {
    "grapheme": "E'ko",
    "confidence": "high",
    "ipa": "ˈeko"
  },
  {
    "grapheme": "Pele'keiki",
    "confidence": "high",
    "ipa": "ˌpeleˈkeki",
    "note": "Hawaiian-styled troll name; EI is e, not German aɪ"
  },
  {
    "grapheme": "Mau'ari",
    "confidence": "high",
    "ipa": "maʊˈaʁi"
  },
  {
    "grapheme": "Throm'ka",
    "confidence": "check",
    "ipa": "ˈtʁɔmka",
    "note": "orcish greeting"
  },
  {
    "grapheme": "Gnoll",
    "confidence": "check",
    "ipa": "ɡnɔl",
    "note": "German keeps the G, as in Gnom"
  },
  {
    "grapheme": "Gnolle",
    "confidence": "check",
    "ipa": "ˈɡnɔlə",
    "note": "plural"
  },
  {
    "grapheme": "Gnollen",
    "confidence": "check",
    "ipa": "ˈɡnɔlən",
    "note": "plural dative"
  },
  {
    "grapheme": "Gnolls",
    "confidence": "check",
    "ipa": "ɡnɔls"
  },
  {
    "grapheme": "Murloc",
    "confidence": "high",
    "ipa": "ˈmʊʁlɔk"
  },
  {
    "grapheme": "Murlocs",
    "confidence": "high",
    "ipa": "ˈmʊʁlɔks",
    "note": "plural"
  },
  {
    "grapheme": "Furbolg",
    "confidence": "high",
    "ipa": "ˈfʊʁbɔlk",
    "note": "final devoicing"
  },
  {
    "grapheme": "Furbolgs",
    "confidence": "high",
    "ipa": "ˈfʊʁbɔlks",
    "note": "plural"
  },
  {
    "grapheme": "Naga",
    "confidence": "high",
    "ipa": "ˈnaɡa"
  },
  {
    "grapheme": "Kodo",
    "confidence": "high",
    "ipa": "ˈkodo"
  },
  {
    "grapheme": "Kodos",
    "confidence": "high",
    "ipa": "ˈkodos",
    "note": "plural"
  },
  {
    "grapheme": "Tauren",
    "confidence": "high",
    "ipa": "ˈtaʊʁən"
  },
  {
    "grapheme": "Worgen",
    "confidence": "check",
    "ipa": "ˈvɔʁɡən",
    "note": "German W as v"
  },
  {
    "grapheme": "Defias",
    "confidence": "check",
    "ipa": "deˈfias",
    "note": "English stresses -FY-; German reading de-FI-as"
  },
  {
    "grapheme": "Defiasbruderschaft",
    "confidence": "check",
    "ipa": "deˈfiasˌbʁudɐʃaft",
    "note": "compound: Defias Brotherhood"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- esES: 147 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('esES', $lexicon$[
  {
    "grapheme": "Magatha",
    "confidence": "high",
    "ipa": "maˈɡata"
  },
  {
    "grapheme": "Narache",
    "confidence": "check",
    "ipa": "naˈɾatʃe",
    "note": "English na-RAH-chee; final e read as Spanish e"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ˌo.oˈekis",
    "note": "robot model name spelled out as Spanish letters O-O-X"
  },
  {
    "grapheme": "Draenor",
    "confidence": "check",
    "ipa": "ˈdɾeinoɾ",
    "note": "English DRAY-nor; Spanish readers may say dra-e-NOR"
  },
  {
    "grapheme": "Maiev",
    "confidence": "check",
    "ipa": "ˈmaieb",
    "note": "MY-ev; Spanish has no /v/"
  },
  {
    "grapheme": "Satyrnaar",
    "confidence": "check",
    "ipa": "ˈsateɾnaɾ",
    "note": "English SAY-ter-nar, adapted to Spanish vowels"
  },
  {
    "grapheme": "Mathias",
    "confidence": "high",
    "ipa": "maˈtias",
    "note": "TH as plain t"
  },
  {
    "grapheme": "Loch",
    "confidence": "high",
    "ipa": "lok",
    "note": "Loch Modan; kept in English spelling"
  },
  {
    "grapheme": "Arthas",
    "confidence": "high",
    "ipa": "ˈaɾtas",
    "note": "TH as t, as Spanish VO; also covers English Arthas's"
  },
  {
    "grapheme": "Gnomeregan",
    "confidence": "check",
    "ipa": "ɡnomeˈɾeɡan",
    "note": "Spanish keeps the G as in 'gnomo'; penultimate stress per Spanish reading, English is NO-meh-re-gan"
  },
  {
    "grapheme": "Azeroth",
    "confidence": "check",
    "ipa": "aθeˈɾot",
    "note": "Castilian z = θ; final stress as commonly heard in Spain, English stresses AZ-"
  },
  {
    "grapheme": "Kalimdor",
    "confidence": "check",
    "ipa": "ˈkalimdoɾ",
    "note": "English stress; Spanish players often say kalim-DOR"
  },
  {
    "grapheme": "Lordaeron",
    "confidence": "check",
    "ipa": "loɾˈdeɾon",
    "note": "three syllables, not lor-da-e-ron"
  },
  {
    "grapheme": "Quel'Thalas",
    "confidence": "high",
    "ipa": "kelˈtalas"
  },
  {
    "grapheme": "Eldre'Thalas",
    "confidence": "check",
    "ipa": "elˈdɾeitalas"
  },
  {
    "grapheme": "Kel'Thuzad",
    "confidence": "high",
    "ipa": "kelˈtuθad",
    "note": "Castilian z = θ"
  },
  {
    "grapheme": "Naxxramas",
    "confidence": "high",
    "ipa": "naksˈɾamas"
  },
  {
    "grapheme": "Ahn'Qiraj",
    "confidence": "check",
    "ipa": "ankiˈɾax",
    "note": "final consonant contested (English /ʒ/ or /dʒ/); Spanish readers use jota"
  },
  {
    "grapheme": "Qiraji",
    "confidence": "check",
    "ipa": "kiˈɾaxi",
    "note": "keep consistent with Ahn'Qiraj"
  },
  {
    "grapheme": "C'Thun",
    "confidence": "check",
    "ipa": "keˈtun",
    "note": "English kuh-THOON"
  },
  {
    "grapheme": "Silithus",
    "confidence": "high",
    "ipa": "ˈsilitus",
    "note": "SIL-ith-us; silithid kept consistent"
  },
  {
    "grapheme": "silithid",
    "confidence": "high",
    "ipa": "ˈsilitid"
  },
  {
    "grapheme": "Zul'Farrak",
    "confidence": "check",
    "ipa": "θulˈfaɾak",
    "note": "Castilian z = θ"
  },
  {
    "grapheme": "Zul'Gurub",
    "confidence": "check",
    "ipa": "θulɡuˈɾub",
    "note": "Castilian z = θ"
  },
  {
    "grapheme": "Zandalar",
    "confidence": "check",
    "ipa": "ˈθandalaɾ"
  },
  {
    "grapheme": "Atal'ai",
    "confidence": "high",
    "ipa": "ˈatalai"
  },
  {
    "grapheme": "Atal'Hakkar",
    "confidence": "check",
    "ipa": "atalˈxakaɾ",
    "note": "H read as Spanish jota"
  },
  {
    "grapheme": "Hakkar",
    "confidence": "check",
    "ipa": "ˈxakaɾ",
    "note": "H read as Spanish jota rather than silent"
  },
  {
    "grapheme": "Hakkari",
    "confidence": "check",
    "ipa": "xaˈkaɾi"
  },
  {
    "grapheme": "Jin'do",
    "confidence": "check",
    "ipa": "ˈɟʝindo",
    "note": "troll J as ɟʝ, not jota"
  },
  {
    "grapheme": "Un'Goro",
    "confidence": "high",
    "ipa": "unˈɡoɾo"
  },
  {
    "grapheme": "Teldrassil",
    "confidence": "high",
    "ipa": "telˈdɾasil"
  },
  {
    "grapheme": "Darnassus",
    "confidence": "high",
    "ipa": "daɾˈnasus"
  },
  {
    "grapheme": "Dolanaar",
    "confidence": "high",
    "ipa": "dolaˈnaɾ"
  },
  {
    "grapheme": "Auberdine",
    "confidence": "check",
    "ipa": "ˈobeɾdin",
    "note": "English AW-ber-deen; final e silent"
  },
  {
    "grapheme": "Rut'theran",
    "confidence": "check",
    "ipa": "ˈrutteɾan"
  },
  {
    "grapheme": "Ban'ethil",
    "confidence": "check",
    "ipa": "banˈetil"
  },
  {
    "grapheme": "Tirisfal",
    "confidence": "high",
    "ipa": "ˈtiɾisfal"
  },
  {
    "grapheme": "Desolace",
    "confidence": "check",
    "ipa": "ˈdesoleis",
    "note": "final e silent; not the Spanish word"
  },
  {
    "grapheme": "Feralas",
    "confidence": "high",
    "ipa": "feˈɾalas"
  },
  {
    "grapheme": "Tanaris",
    "confidence": "high",
    "ipa": "taˈnaɾis"
  },
  {
    "grapheme": "Uldaman",
    "confidence": "high",
    "ipa": "ˈuldaman"
  },
  {
    "grapheme": "Uldamán",
    "confidence": "check",
    "ipa": "uldaˈman",
    "note": "not in English lexicon: esES also spells it with an accent, which forces final stress"
  },
  {
    "grapheme": "Dalaran",
    "confidence": "high",
    "ipa": "ˈdalaɾan"
  },
  {
    "grapheme": "Alterac",
    "confidence": "high",
    "ipa": "ˈalteɾak"
  },
  {
    "grapheme": "Stromgarde",
    "confidence": "check",
    "ipa": "esˈtɾomɡaɾd",
    "note": "final e silent; Spanish prothetic e before st"
  },
  {
    "grapheme": "Arathi",
    "confidence": "high",
    "ipa": "aˈɾati"
  },
  {
    "grapheme": "Arathor",
    "confidence": "high",
    "ipa": "ˈaɾatoɾ"
  },
  {
    "grapheme": "Andorhal",
    "confidence": "check",
    "ipa": "ˈandoɾal",
    "note": "H silent as Spanish readers say it"
  },
  {
    "grapheme": "Stratholme",
    "confidence": "check",
    "ipa": "esˈtɾatolm",
    "note": "silent L in Blizzard's VO is not carried; STRAT-olm"
  },
  {
    "grapheme": "Scholomance",
    "confidence": "high",
    "ipa": "esˈkolomans",
    "note": "hard C, not SHOL-; final e silent"
  },
  {
    "grapheme": "Kharanos",
    "confidence": "high",
    "ipa": "ˈkaɾanos"
  },
  {
    "grapheme": "Morogh",
    "confidence": "check",
    "ipa": "ˈmoɾo",
    "note": "Dun Morogh; final GH silent, but MOR-og is widely used"
  },
  {
    "grapheme": "Modan",
    "confidence": "high",
    "ipa": "ˈmodan",
    "note": "Loch Modan"
  },
  {
    "grapheme": "Elwynn",
    "confidence": "high",
    "ipa": "ˈelwin"
  },
  {
    "grapheme": "Mulgore",
    "confidence": "high",
    "ipa": "ˈmulɡoɾ",
    "note": "official narration MULL-gore; final e silent"
  },
  {
    "grapheme": "Durotar",
    "confidence": "high",
    "ipa": "ˈduɾotaɾ"
  },
  {
    "grapheme": "Orgrimmar",
    "confidence": "check",
    "ipa": "ˈoɾɡɾimaɾ",
    "note": "English stress; Spanish players often say orgri-MAR"
  },
  {
    "grapheme": "Theramore",
    "confidence": "high",
    "ipa": "ˈteɾamoɾ",
    "note": "final e silent"
  },
  {
    "grapheme": "Gadgetzan",
    "confidence": "check",
    "ipa": "ˈɡaɟʝetθan"
  },
  {
    "grapheme": "Azshara",
    "confidence": "check",
    "ipa": "aˈʃaɾa",
    "note": "English has azh-SHAR-a; Spanish lacks /ʒ/"
  },
  {
    "grapheme": "Sen'jin",
    "confidence": "check",
    "ipa": "ˈsenɟʝin",
    "note": "troll J as ɟʝ, not jota"
  },
  {
    "grapheme": "Grom'gol",
    "confidence": "high",
    "ipa": "ˈɡɾomɡol"
  },
  {
    "grapheme": "Zoram",
    "confidence": "check",
    "ipa": "ˈθoɾam"
  },
  {
    "grapheme": "Blackfathom",
    "confidence": "check",
    "ipa": "blakˈfadom",
    "note": "untranslated leftover (esES is Brazanegra)"
  },
  {
    "grapheme": "Kraul",
    "confidence": "high",
    "ipa": "kɾaul",
    "note": "Razorfen Kraul; untranslated leftover"
  },
  {
    "grapheme": "Winterspring",
    "confidence": "check",
    "ipa": "ˈwinteɾspɾin",
    "note": "untranslated leftover (esES is Cuna del Invierno)"
  },
  {
    "grapheme": "Thelsamar",
    "confidence": "high",
    "ipa": "telˈsamaɾ"
  },
  {
    "grapheme": "Thrall",
    "confidence": "high",
    "ipa": "tɾal",
    "note": "TH as t, as Spanish VO"
  },
  {
    "grapheme": "Sylvanas",
    "confidence": "high",
    "ipa": "silˈbanas"
  },
  {
    "grapheme": "Tyrande",
    "confidence": "high",
    "ipa": "tiˈɾande"
  },
  {
    "grapheme": "Cenarius",
    "confidence": "high",
    "ipa": "θeˈnaɾius",
    "note": "Castilian c = θ"
  },
  {
    "grapheme": "Cenarion",
    "confidence": "high",
    "ipa": "θeˈnaɾion",
    "note": "Castilian c = θ"
  },
  {
    "grapheme": "Elune",
    "confidence": "check",
    "ipa": "eˈlune",
    "note": "English ih-LOON; Spanish reading pronounces the final e"
  },
  {
    "grapheme": "Ragnaros",
    "confidence": "high",
    "ipa": "ˈraɡnaɾos"
  },
  {
    "grapheme": "Nefarian",
    "confidence": "high",
    "ipa": "neˈfaɾian"
  },
  {
    "grapheme": "Uther",
    "confidence": "check",
    "ipa": "ˈuteɾ",
    "note": "English YOO-ther"
  },
  {
    "grapheme": "Bolvar",
    "confidence": "high",
    "ipa": "ˈbolbaɾ"
  },
  {
    "grapheme": "Cairne",
    "confidence": "check",
    "ipa": "kaiɾn",
    "note": "one syllable in English (cairn); final e silent"
  },
  {
    "grapheme": "Magni",
    "confidence": "high",
    "ipa": "ˈmaɡni"
  },
  {
    "grapheme": "Mekkatorque",
    "confidence": "high",
    "ipa": "ˈmekatoɾk",
    "note": "final -que is silent, not -ke"
  },
  {
    "grapheme": "Medivh",
    "confidence": "high",
    "ipa": "meˈdib",
    "note": "the VH is a plain V"
  },
  {
    "grapheme": "Ysera",
    "confidence": "high",
    "ipa": "iˈseɾa"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "high",
    "ipa": "malˈfuɾion"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "check",
    "ipa": "malfuˈɾjon",
    "note": "not in English lexicon: esES accented spelling forces final stress"
  },
  {
    "grapheme": "Arugal",
    "confidence": "high",
    "ipa": "ˈaɾuɡal"
  },
  {
    "grapheme": "Amnennar",
    "confidence": "check",
    "ipa": "amˈnenaɾ"
  },
  {
    "grapheme": "Charlga",
    "confidence": "check",
    "ipa": "ˈtʃaɾlɡa"
  },
  {
    "grapheme": "Razorflank",
    "confidence": "check",
    "ipa": "ˈreiθoɾflank",
    "note": "untranslated leftover"
  },
  {
    "grapheme": "Dathrohan",
    "confidence": "check",
    "ipa": "ˈdatɾoxan"
  },
  {
    "grapheme": "Naralex",
    "confidence": "high",
    "ipa": "ˈnaɾaleks"
  },
  {
    "grapheme": "Theradras",
    "confidence": "check",
    "ipa": "teˈɾadɾas"
  },
  {
    "grapheme": "Zaetar",
    "confidence": "check",
    "ipa": "ˈθeitaɾ"
  },
  {
    "grapheme": "Valthalak",
    "confidence": "high",
    "ipa": "ˈbaltalak"
  },
  {
    "grapheme": "Silverlaine",
    "confidence": "check",
    "ipa": "ˈsilbeɾlein",
    "note": "untranslated baron name; final e silent"
  },
  {
    "grapheme": "Barov",
    "confidence": "high",
    "ipa": "ˈbaɾob"
  },
  {
    "grapheme": "Norgannon",
    "confidence": "high",
    "ipa": "ˈnoɾɡanon"
  },
  {
    "grapheme": "Agamaggan",
    "confidence": "check",
    "ipa": "aɡaˈmaɡan"
  },
  {
    "grapheme": "Aku'mai",
    "confidence": "high",
    "ipa": "ˈakumai"
  },
  {
    "grapheme": "Thunderbrew",
    "confidence": "check",
    "ipa": "ˈtandeɾbɾu",
    "note": "untranslated leftover (esES is Cebatruenos)"
  },
  {
    "grapheme": "Runetotem",
    "confidence": "check",
    "ipa": "ˈruntotem",
    "note": "untranslated leftover (esES is Runatótem)"
  },
  {
    "grapheme": "Trollbane",
    "confidence": "check",
    "ipa": "ˈtɾolbein",
    "note": "untranslated leftover (esES is Aterratrols)"
  },
  {
    "grapheme": "Lightbringer",
    "confidence": "check",
    "ipa": "ˈlaitbɾinɡeɾ",
    "note": "untranslated leftover (esES is el Iluminado)"
  },
  {
    "grapheme": "Destellamatic",
    "confidence": "check",
    "ipa": "desteʎaˈmatik",
    "note": "Sparklematic's esES name; Spanish reading would stress the last syllable"
  },
  {
    "grapheme": "Sul'thraze",
    "confidence": "check",
    "ipa": "sulˈtɾeis"
  },
  {
    "grapheme": "Trol'kalar",
    "confidence": "high",
    "ipa": "tɾolˈkalaɾ"
  },
  {
    "grapheme": "Mosh'aru",
    "confidence": "high",
    "ipa": "moʃˈaɾu"
  },
  {
    "grapheme": "Gri'lek",
    "confidence": "high",
    "ipa": "ˈɡɾilek"
  },
  {
    "grapheme": "Jammal'an",
    "confidence": "check",
    "ipa": "ɟʝaˈmalan",
    "note": "troll J as ɟʝ, not jota"
  },
  {
    "grapheme": "Mai'Zoth",
    "confidence": "check",
    "ipa": "maiˈθot"
  },
  {
    "grapheme": "Lar'korwi",
    "confidence": "high",
    "ipa": "laɾˈkoɾwi"
  },
  {
    "grapheme": "Mar'alith",
    "confidence": "high",
    "ipa": "maɾˈalit"
  },
  {
    "grapheme": "Mor'zul",
    "confidence": "check",
    "ipa": "moɾˈθul"
  },
  {
    "grapheme": "Gor'mul",
    "confidence": "check",
    "ipa": "ɡoɾˈmul"
  },
  {
    "grapheme": "Rin'ji",
    "confidence": "check",
    "ipa": "ˈrinɟʝi",
    "note": "troll J as ɟʝ, not jota"
  },
  {
    "grapheme": "Zando'zan",
    "confidence": "check",
    "ipa": "ˈθandoθan"
  },
  {
    "grapheme": "Bath'rah",
    "confidence": "high",
    "ipa": "ˈbatɾa"
  },
  {
    "grapheme": "Jen'shan",
    "confidence": "check",
    "ipa": "ˈɟʝenʃan",
    "note": "troll J as ɟʝ, not jota"
  },
  {
    "grapheme": "E'ko",
    "confidence": "high",
    "ipa": "ˈeko"
  },
  {
    "grapheme": "Pele'keiki",
    "confidence": "high",
    "ipa": "ˌpeleˈkeiki",
    "note": "Hawaiian-styled troll name"
  },
  {
    "grapheme": "Mau'ari",
    "confidence": "high",
    "ipa": "mauˈaɾi"
  },
  {
    "grapheme": "Throm'ka",
    "confidence": "check",
    "ipa": "ˈtɾomka",
    "note": "orcish greeting"
  },
  {
    "grapheme": "Throm-ka",
    "confidence": "check",
    "ipa": "ˈtɾomka",
    "note": "not in English lexicon: esES hyphenated variant of Throm'ka"
  },
  {
    "grapheme": "Hive'Regal",
    "confidence": "check",
    "ipa": "xaibˈreɡal",
    "note": "H as jota"
  },
  {
    "grapheme": "Hive'Zora",
    "confidence": "check",
    "ipa": "xaibˈθoɾa"
  },
  {
    "grapheme": "Hive'Ashi",
    "confidence": "check",
    "ipa": "xaibˈaʃi"
  },
  {
    "grapheme": "gnoll",
    "confidence": "check",
    "ipa": "ɡnol",
    "note": "Spanish keeps the G as in 'gnomo'"
  },
  {
    "grapheme": "gnolls",
    "confidence": "check",
    "ipa": "ɡnols",
    "note": "plural"
  },
  {
    "grapheme": "murloc",
    "confidence": "high",
    "ipa": "ˈmuɾlok"
  },
  {
    "grapheme": "murlocs",
    "confidence": "high",
    "ipa": "ˈmuɾloks",
    "note": "plural"
  },
  {
    "grapheme": "kobolds",
    "confidence": "high",
    "ipa": "ˈkobolds",
    "note": "plural; singular does not occur"
  },
  {
    "grapheme": "quilboar",
    "confidence": "check",
    "ipa": "ˈkilboɾ",
    "note": "untranslated leftover (esES is jabaespín)"
  },
  {
    "grapheme": "furbolgs",
    "confidence": "high",
    "ipa": "ˈfuɾbolɡs",
    "note": "plural; singular does not occur"
  },
  {
    "grapheme": "naga",
    "confidence": "high",
    "ipa": "ˈnaɡa"
  },
  {
    "grapheme": "nagas",
    "confidence": "high",
    "ipa": "ˈnaɡas",
    "note": "plural"
  },
  {
    "grapheme": "kodo",
    "confidence": "high",
    "ipa": "ˈkodo"
  },
  {
    "grapheme": "kodos",
    "confidence": "high",
    "ipa": "ˈkodos",
    "note": "plural"
  },
  {
    "grapheme": "tauren",
    "confidence": "check",
    "ipa": "ˈtauɾen",
    "note": "English TOR-en; Spanish reads the au diphthong"
  },
  {
    "grapheme": "taurens",
    "confidence": "check",
    "ipa": "ˈtauɾens",
    "note": "plural"
  },
  {
    "grapheme": "worgen",
    "confidence": "high",
    "ipa": "ˈwoɾɡen",
    "note": "hard G"
  },
  {
    "grapheme": "Defias",
    "confidence": "check",
    "ipa": "deˈfias",
    "note": "English dih-FYE-us"
  },
  {
    "grapheme": "Scourge",
    "confidence": "check",
    "ipa": "esˈkoɾdʒ",
    "note": "untranslated leftover (esES is la Plaga)"
  },
  {
    "grapheme": "Forsaken",
    "confidence": "check",
    "ipa": "foɾˈseiken",
    "note": "untranslated leftover (esES is Renegados)"
  },
  {
    "grapheme": "Razorfen",
    "confidence": "check",
    "ipa": "ˈreiθoɾfen",
    "note": "not in English lexicon: untranslated in Razorfen Kraul"
  },
  {
    "grapheme": "Zoram'gar",
    "confidence": "check",
    "ipa": "ˈθoɾamɡaɾ",
    "note": "not in English lexicon: keep consistent with Zoram"
  },
  {
    "grapheme": "Jaina",
    "confidence": "check",
    "ipa": "ˈɟʝaina",
    "note": "not in English lexicon: J would be read as jota; Spanish VO says YAI-na"
  },
  {
    "grapheme": "Wildhammer",
    "confidence": "check",
    "ipa": "ˈwaildxameɾ",
    "note": "not in English lexicon: untranslated clan name"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- esMX: 131 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('esMX', $lexicon$[
  {
    "grapheme": "Magatha",
    "confidence": "high",
    "ipa": "ˈmaɡata",
    "note": "English stress kept; Spanish default would stress -GA-"
  },
  {
    "grapheme": "Narache",
    "confidence": "high",
    "ipa": "naˈɾatʃe"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ˌoˌoˈekis",
    "note": "English alias replaced: spelled out o-o-equis"
  },
  {
    "grapheme": "Draenor",
    "confidence": "check",
    "ipa": "ˈdɾaenoɾ",
    "note": "English was an alias; stress on DRAE kept from English, Spanish default is final"
  },
  {
    "grapheme": "Maiev",
    "confidence": "check",
    "ipa": "ˈmajeb",
    "note": "MY-ev; final v as Spanish b"
  },
  {
    "grapheme": "Satyrnaar",
    "confidence": "check",
    "ipa": "ˈsatiɾnaɾ",
    "note": "English stress kept; Spanish default is final"
  },
  {
    "grapheme": "Mathias",
    "confidence": "high",
    "ipa": "maˈtias"
  },
  {
    "grapheme": "Loch",
    "confidence": "check",
    "ipa": "lok",
    "note": "Loch Modan; Spanish spelling rules would give /lotʃ/"
  },
  {
    "grapheme": "Gnomeregan",
    "confidence": "check",
    "ipa": "ˈnomeɾeɡan",
    "note": "silent G; English first-syllable stress kept, Spanish default is -RE-"
  },
  {
    "grapheme": "Azeroth",
    "confidence": "check",
    "ipa": "ˈaseɾot",
    "note": "TH as t, seseo; English stress kept, Spanish default is final"
  },
  {
    "grapheme": "Kalimdor",
    "confidence": "check",
    "ipa": "ˈkalimdoɾ",
    "note": "English stress kept, Spanish default is final"
  },
  {
    "grapheme": "Lordaeron",
    "confidence": "check",
    "ipa": "ˈloɾdeɾon",
    "note": "three syllables, not LOR-da-e-ron; English stress kept"
  },
  {
    "grapheme": "Quel'Thalas",
    "confidence": "high",
    "ipa": "kelˈtalas"
  },
  {
    "grapheme": "Eldre'Thalas",
    "confidence": "check",
    "ipa": "eldɾeˈtalas"
  },
  {
    "grapheme": "Kel'Thuzad",
    "confidence": "high",
    "ipa": "kelˈtusad",
    "note": "English stress on THU kept; Spanish default is final"
  },
  {
    "grapheme": "Naxxramas",
    "confidence": "high",
    "ipa": "naksˈɾamas"
  },
  {
    "grapheme": "Ahn'Qiraj",
    "confidence": "check",
    "ipa": "ankiˈɾax",
    "note": "final J as Spanish jota; English /ʒ/ has no esMX equivalent, /dʒ/ also plausible"
  },
  {
    "grapheme": "Qiraji",
    "confidence": "check",
    "ipa": "kiˈɾaxi",
    "note": "keep consistent with Ahn'Qiraj"
  },
  {
    "grapheme": "C'Thun",
    "confidence": "check",
    "ipa": "keˈtun"
  },
  {
    "grapheme": "Silithus",
    "confidence": "check",
    "ipa": "siˈlitus",
    "note": "stress kept consistent with the localized silítidos"
  },
  {
    "grapheme": "Zul'Farrak",
    "confidence": "high",
    "ipa": "sulˈfarak",
    "note": "seseo Z"
  },
  {
    "grapheme": "Zul'Gurub",
    "confidence": "high",
    "ipa": "sulɡuˈɾub"
  },
  {
    "grapheme": "Zandalar",
    "confidence": "high",
    "ipa": "ˈsandalaɾ"
  },
  {
    "grapheme": "Zandalari",
    "confidence": "high",
    "ipa": "sandaˈlaɾi"
  },
  {
    "grapheme": "Atal'ai",
    "confidence": "high",
    "ipa": "ˈatalaj"
  },
  {
    "grapheme": "Atal'Hakkar",
    "confidence": "check",
    "ipa": "atalˈxakaɾ",
    "note": "foreign H as soft jota"
  },
  {
    "grapheme": "Hakkar",
    "confidence": "high",
    "ipa": "ˈxakaɾ",
    "note": "foreign H as soft jota, not silent"
  },
  {
    "grapheme": "Hakkari",
    "confidence": "high",
    "ipa": "xaˈkaɾi"
  },
  {
    "grapheme": "Jin'do",
    "confidence": "check",
    "ipa": "ˈdʒindo",
    "note": "J as English dʒ, not Spanish jota"
  },
  {
    "grapheme": "Un'Goro",
    "confidence": "high",
    "ipa": "unˈɡoɾo"
  },
  {
    "grapheme": "Teldrassil",
    "confidence": "high",
    "ipa": "telˈdɾasil",
    "note": "Spanish default would stress final -SIL"
  },
  {
    "grapheme": "Darnassus",
    "confidence": "high",
    "ipa": "daɾˈnasus"
  },
  {
    "grapheme": "Dolanaar",
    "confidence": "high",
    "ipa": "dolaˈnaɾ"
  },
  {
    "grapheme": "Auberdine",
    "confidence": "check",
    "ipa": "ˈobeɾdin",
    "note": "French-style, final E silent; a Spanish reader might say au-ber-DI-ne"
  },
  {
    "grapheme": "Rut'theran",
    "confidence": "check",
    "ipa": "ˈruteɾan"
  },
  {
    "grapheme": "Ban'ethil",
    "confidence": "check",
    "ipa": "banˈetil"
  },
  {
    "grapheme": "Tirisfal",
    "confidence": "high",
    "ipa": "ˈtiɾisfal"
  },
  {
    "grapheme": "Desolace",
    "confidence": "check",
    "ipa": "ˈdesolas",
    "note": "English DES-o-lace; Spanish default would be de-so-LA-se"
  },
  {
    "grapheme": "Feralas",
    "confidence": "high",
    "ipa": "feˈɾalas"
  },
  {
    "grapheme": "Tanaris",
    "confidence": "high",
    "ipa": "taˈnaɾis"
  },
  {
    "grapheme": "Uldaman",
    "confidence": "high",
    "ipa": "ˈuldaman"
  },
  {
    "grapheme": "Dalaran",
    "confidence": "high",
    "ipa": "ˈdalaɾan"
  },
  {
    "grapheme": "Alterac",
    "confidence": "high",
    "ipa": "ˈalteɾak"
  },
  {
    "grapheme": "Stromgarde",
    "confidence": "check",
    "ipa": "ˈstɾomɡaɾd",
    "note": "final E silent; model may add a prothetic e-"
  },
  {
    "grapheme": "Arathi",
    "confidence": "high",
    "ipa": "aˈɾati"
  },
  {
    "grapheme": "Arathor",
    "confidence": "high",
    "ipa": "ˈaɾatoɾ"
  },
  {
    "grapheme": "Andorhal",
    "confidence": "high",
    "ipa": "ˈandoɾal"
  },
  {
    "grapheme": "Stratholme",
    "confidence": "check",
    "ipa": "ˈstɾatom",
    "note": "silent L in Blizzard's VO; STRAT-olm also common"
  },
  {
    "grapheme": "Scholomance",
    "confidence": "check",
    "ipa": "ˈskolomans",
    "note": "hard C, not SHOL- or CHOL-"
  },
  {
    "grapheme": "Kharanos",
    "confidence": "high",
    "ipa": "ˈkaɾanos"
  },
  {
    "grapheme": "Morogh",
    "confidence": "check",
    "ipa": "ˈmoɾo",
    "note": "Dun Morogh; final GH silent, MOR-og widely used"
  },
  {
    "grapheme": "Modan",
    "confidence": "high",
    "ipa": "ˈmodan",
    "note": "Loch Modan"
  },
  {
    "grapheme": "Elwynn",
    "confidence": "high",
    "ipa": "ˈelwin"
  },
  {
    "grapheme": "Mulgore",
    "confidence": "high",
    "ipa": "ˈmulɡoɾ",
    "note": "race intro cinematic: MULL-gore; final E silent"
  },
  {
    "grapheme": "Durotar",
    "confidence": "high",
    "ipa": "ˈduɾotaɾ"
  },
  {
    "grapheme": "Orgrimmar",
    "confidence": "check",
    "ipa": "ˈoɾɡɾimaɾ",
    "note": "English stress kept; Spanish default is final"
  },
  {
    "grapheme": "Theramore",
    "confidence": "high",
    "ipa": "ˈteɾamoɾ",
    "note": "final E silent"
  },
  {
    "grapheme": "Gadgetzan",
    "confidence": "check",
    "ipa": "ˈɡadʒetsan"
  },
  {
    "grapheme": "Azshara",
    "confidence": "check",
    "ipa": "asˈʃaɾa",
    "note": "English has a real /ʒ/; ʃ is the closest esMX loan sound"
  },
  {
    "grapheme": "Sen'jin",
    "confidence": "check",
    "ipa": "ˈsendʒin",
    "note": "J as dʒ, not Spanish jota"
  },
  {
    "grapheme": "Grom'gol",
    "confidence": "high",
    "ipa": "ˈɡɾomɡol"
  },
  {
    "grapheme": "Zoram",
    "confidence": "high",
    "ipa": "ˈsoɾam"
  },
  {
    "grapheme": "Thelsamar",
    "confidence": "high",
    "ipa": "telˈsamaɾ"
  },
  {
    "grapheme": "Thrall",
    "confidence": "high",
    "ipa": "tɾal",
    "note": "TH as t; LL is /l/, not Spanish /ʝ/"
  },
  {
    "grapheme": "Sylvanas",
    "confidence": "high",
    "ipa": "silˈbanas"
  },
  {
    "grapheme": "Tyrande",
    "confidence": "high",
    "ipa": "tiˈɾande"
  },
  {
    "grapheme": "Cenarius",
    "confidence": "high",
    "ipa": "seˈnaɾjus"
  },
  {
    "grapheme": "Cenarion",
    "confidence": "high",
    "ipa": "seˈnaɾjon"
  },
  {
    "grapheme": "Elune",
    "confidence": "high",
    "ipa": "eˈlune"
  },
  {
    "grapheme": "Ragnaros",
    "confidence": "high",
    "ipa": "ˈraɡnaɾos"
  },
  {
    "grapheme": "Nefarian",
    "confidence": "high",
    "ipa": "neˈfaɾjan"
  },
  {
    "grapheme": "Arthas",
    "confidence": "high",
    "ipa": "ˈaɾtas"
  },
  {
    "grapheme": "Uther",
    "confidence": "check",
    "ipa": "ˈuteɾ",
    "note": "English YOO-ther; Spanish reading drops the glide"
  },
  {
    "grapheme": "Bolvar",
    "confidence": "high",
    "ipa": "ˈbolbaɾ"
  },
  {
    "grapheme": "Cairne",
    "confidence": "check",
    "ipa": "ˈkeɾn",
    "note": "one syllable in English; a Spanish reader would say CAIR-ne"
  },
  {
    "grapheme": "Mekkatorque",
    "confidence": "check",
    "ipa": "ˈmekatoɾk",
    "note": "final -que silent"
  },
  {
    "grapheme": "Medivh",
    "confidence": "check",
    "ipa": "meˈdib",
    "note": "the VH is a plain V"
  },
  {
    "grapheme": "Ysera",
    "confidence": "high",
    "ipa": "iˈseɾa"
  },
  {
    "grapheme": "Staghelm",
    "confidence": "check",
    "ipa": "ˈstaɡxelm",
    "note": "only 3 untranslated occurrences; elsewhere Corzocelada"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "high",
    "ipa": "malˈfuɾjon"
  },
  {
    "grapheme": "Arugal",
    "confidence": "high",
    "ipa": "ˈaɾuɡal"
  },
  {
    "grapheme": "Amnennar",
    "confidence": "check",
    "ipa": "amˈnenaɾ"
  },
  {
    "grapheme": "Charlga",
    "confidence": "check",
    "ipa": "ˈtʃaɾlɡa"
  },
  {
    "grapheme": "Dathrohan",
    "confidence": "check",
    "ipa": "ˈdatɾoan"
  },
  {
    "grapheme": "Naralex",
    "confidence": "high",
    "ipa": "ˈnaɾaleks"
  },
  {
    "grapheme": "Theradras",
    "confidence": "check",
    "ipa": "teˈɾadɾas"
  },
  {
    "grapheme": "Zaetar",
    "confidence": "check",
    "ipa": "ˈsetaɾ",
    "note": "English ZAY-tar"
  },
  {
    "grapheme": "Valthalak",
    "confidence": "high",
    "ipa": "ˈbaltalak"
  },
  {
    "grapheme": "Silverlaine",
    "confidence": "high",
    "ipa": "ˈsilbeɾlejn"
  },
  {
    "grapheme": "Barov",
    "confidence": "high",
    "ipa": "ˈbaɾob"
  },
  {
    "grapheme": "Norgannon",
    "confidence": "high",
    "ipa": "ˈnoɾɡanon"
  },
  {
    "grapheme": "Agamaggan",
    "confidence": "check",
    "ipa": "ˌaɡaˈmaɡan"
  },
  {
    "grapheme": "Aku'mai",
    "confidence": "high",
    "ipa": "ˈakumaj"
  },
  {
    "grapheme": "Sul'thraze",
    "confidence": "check",
    "ipa": "sulˈtɾejs"
  },
  {
    "grapheme": "Trol'kalar",
    "confidence": "high",
    "ipa": "tɾolˈkalaɾ"
  },
  {
    "grapheme": "Mosh'aru",
    "confidence": "high",
    "ipa": "moʃˈaɾu"
  },
  {
    "grapheme": "Gri'lek",
    "confidence": "high",
    "ipa": "ˈɡɾilek"
  },
  {
    "grapheme": "Jammal'an",
    "confidence": "check",
    "ipa": "dʒaˈmalan"
  },
  {
    "grapheme": "Mai'Zoth",
    "confidence": "high",
    "ipa": "majˈsot"
  },
  {
    "grapheme": "Lar'korwi",
    "confidence": "high",
    "ipa": "laɾˈkoɾwi"
  },
  {
    "grapheme": "Mar'alith",
    "confidence": "high",
    "ipa": "maɾˈalit"
  },
  {
    "grapheme": "Mor'zul",
    "confidence": "high",
    "ipa": "moɾˈsul"
  },
  {
    "grapheme": "Gor'mul",
    "confidence": "check",
    "ipa": "ɡoɾˈmul"
  },
  {
    "grapheme": "Rin'ji",
    "confidence": "high",
    "ipa": "ˈrindʒi"
  },
  {
    "grapheme": "Zando'zan",
    "confidence": "high",
    "ipa": "ˈsandosan"
  },
  {
    "grapheme": "Bath'rah",
    "confidence": "high",
    "ipa": "ˈbatɾa"
  },
  {
    "grapheme": "Jen'shan",
    "confidence": "high",
    "ipa": "ˈdʒenʃan"
  },
  {
    "grapheme": "E'ko",
    "confidence": "high",
    "ipa": "ˈeko"
  },
  {
    "grapheme": "Pele'keiki",
    "confidence": "high",
    "ipa": "ˌpeleˈkejki",
    "note": "Hawaiian-styled troll name"
  },
  {
    "grapheme": "Mau'ari",
    "confidence": "high",
    "ipa": "mawˈaɾi"
  },
  {
    "grapheme": "Throm'ka",
    "confidence": "check",
    "ipa": "ˈtɾomka",
    "note": "orcish greeting"
  },
  {
    "grapheme": "Hive'Regal",
    "confidence": "check",
    "ipa": "xajbˈriɡal",
    "note": "rare untranslated form; usually Colmen'Regal"
  },
  {
    "grapheme": "Hive'Zora",
    "confidence": "check",
    "ipa": "xajbˈsoɾa",
    "note": "rare untranslated form; usually Colmen'Zora"
  },
  {
    "grapheme": "gnoll",
    "confidence": "high",
    "ipa": "nol",
    "note": "silent G; LL is /l/, not Spanish /ʝ/"
  },
  {
    "grapheme": "gnolls",
    "confidence": "high",
    "ipa": "nols",
    "note": "plural of gnoll"
  },
  {
    "grapheme": "kobold",
    "confidence": "high",
    "ipa": "ˈkobold",
    "note": "unaccented spelling; Spanish default would stress -BOLD"
  },
  {
    "grapheme": "kobolds",
    "confidence": "high",
    "ipa": "ˈkobolds",
    "note": "unaccented plural"
  },
  {
    "grapheme": "furbolgs",
    "confidence": "high",
    "ipa": "ˈfuɾbolɡs",
    "note": "only the plural occurs"
  },
  {
    "grapheme": "tauren",
    "confidence": "high",
    "ipa": "ˈtawɾen"
  },
  {
    "grapheme": "Defias",
    "confidence": "check",
    "ipa": "deˈfi.as",
    "note": "English de-FYE-as; Spanish reading de-FI-as, not DE-fias"
  },
  {
    "grapheme": "Colmen'Regal",
    "confidence": "check",
    "ipa": "kolmenˈreɡal",
    "note": "not in English lexicon: esMX name for Hive'Regal; Spanish default would stress re-GAL"
  },
  {
    "grapheme": "Colmen'Zora",
    "confidence": "check",
    "ipa": "kolmenˈsoɾa",
    "note": "not in English lexicon: esMX name for Hive'Zora"
  },
  {
    "grapheme": "Colmen'Ashi",
    "confidence": "check",
    "ipa": "kolmenˈaʃi",
    "note": "not in English lexicon: esMX name for Hive'Ashi"
  },
  {
    "grapheme": "Destellamatic",
    "confidence": "check",
    "ipa": "desteʝaˈmatik",
    "note": "not in English lexicon: esMX name for Sparklematic; Spanish default would stress final -TIC"
  },
  {
    "grapheme": "Darrow",
    "confidence": "check",
    "ipa": "ˈdaro",
    "note": "not in English lexicon: Castel Darrow replaces Caer Darrow; W silent"
  },
  {
    "grapheme": "Darrowmere",
    "confidence": "check",
    "ipa": "ˈdaromiɾ",
    "note": "not in English lexicon: lake Darrowmere"
  },
  {
    "grapheme": "Ner'zhul",
    "confidence": "check",
    "ipa": "neɾˈsul",
    "note": "not in English lexicon: ZH has no esMX equivalent"
  },
  {
    "grapheme": "Kil'jaeden",
    "confidence": "check",
    "ipa": "kilˈdʒeden",
    "note": "not in English lexicon: J as dʒ, AE as e"
  },
  {
    "grapheme": "Hyjal",
    "confidence": "check",
    "ipa": "xiˈdʒal",
    "note": "not in English lexicon: Spanish rules would give i-JAL with jota"
  },
  {
    "grapheme": "Aegwynn",
    "confidence": "check",
    "ipa": "ˈeɡwin",
    "note": "not in English lexicon: AE, W and Y traps"
  },
  {
    "grapheme": "Ravenholdt",
    "confidence": "check",
    "ipa": "ˈrejbenxolt",
    "note": "not in English lexicon: RAY-ven-holt"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- frFR: 169 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('frFR', $lexicon$[
  {
    "grapheme": "Magatha",
    "confidence": "high",
    "ipa": "maɡata",
    "note": "TH read as plain T"
  },
  {
    "grapheme": "tauren",
    "confidence": "high",
    "ipa": "toʁɛn",
    "note": "oral -en (to-RENN), not nasal as in 'européen'"
  },
  {
    "grapheme": "taurens",
    "confidence": "high",
    "ipa": "toʁɛn",
    "note": "plural of tauren; silent s"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ooiks",
    "note": "letters spelled out, French letter names"
  },
  {
    "grapheme": "Draenor",
    "confidence": "high",
    "ipa": "dʁenɔʁ",
    "note": "French VO: DRÉ-nor, AE as one vowel"
  },
  {
    "grapheme": "Maiev",
    "confidence": "check",
    "ipa": "majɛv",
    "note": "MA-yev; keeps AI from becoming /ɛ/"
  },
  {
    "grapheme": "Satyrnaar",
    "confidence": "high",
    "ipa": "satiʁnaʁ"
  },
  {
    "grapheme": "Loch",
    "confidence": "high",
    "ipa": "lɔk",
    "note": "Loch Modan; CH is /k/, not /ʃ/"
  },
  {
    "grapheme": "Arthas",
    "confidence": "high",
    "ipa": "aʁtas",
    "note": "French VO: AR-tasse; covers d'Arthas/qu'Arthas"
  },
  {
    "grapheme": "Gnomeregan",
    "confidence": "check",
    "ipa": "ɡnɔmeʁeɡɑ̃",
    "note": "GN as in French 'gnome' (/ɡn/, not /ɲ/); final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Azeroth",
    "confidence": "high",
    "ipa": "azeʁɔt",
    "note": "French VO; covers the frequent elided d'Azeroth"
  },
  {
    "grapheme": "Kalimdor",
    "confidence": "high",
    "ipa": "kalimdɔʁ",
    "note": "IM kept oral, not nasal 'Kalindor'"
  },
  {
    "grapheme": "Lordaeron",
    "confidence": "check",
    "ipa": "lɔʁdeʁɔ̃",
    "note": "three syllables, AE as /e/; final -on nasal"
  },
  {
    "grapheme": "Quel'Thalas",
    "confidence": "high",
    "ipa": "kɛltalas"
  },
  {
    "grapheme": "Quel’Thalas",
    "confidence": "high",
    "ipa": "kɛltalas",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Eldre'Thalas",
    "confidence": "check",
    "ipa": "ɛldʁətalas",
    "note": "mostly elided d'Eldre'Thalas"
  },
  {
    "grapheme": "Eldre’Thalas",
    "confidence": "check",
    "ipa": "ɛldʁətalas",
    "note": "curly-apostrophe spelling of the same name in the corpus; mostly elided d’Eldre’Thalas"
  },
  {
    "grapheme": "Kel'Thuzad",
    "confidence": "check",
    "ipa": "kɛltyzad",
    "note": "U read French /y/; /u/ (Kel-tou-zad) also heard"
  },
  {
    "grapheme": "Kel’Thuzad",
    "confidence": "check",
    "ipa": "kɛltyzad",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Naxxramas",
    "confidence": "high",
    "ipa": "naksʁamas"
  },
  {
    "grapheme": "Ahn'Qiraj",
    "confidence": "check",
    "ipa": "ankiʁaʒ",
    "note": "AHN kept oral, not nasal /ɑ̃/; final /ʒ/ as in English entry"
  },
  {
    "grapheme": "Ahn’Qiraj",
    "confidence": "check",
    "ipa": "ankiʁaʒ",
    "note": "curly-apostrophe spelling of the same name in the corpus; the majority spelling"
  },
  {
    "grapheme": "Qiraji",
    "confidence": "high",
    "ipa": "kiʁaʒi"
  },
  {
    "grapheme": "C'Thun",
    "confidence": "check",
    "ipa": "kətun",
    "note": "ke-TOUNE; how French players say it is contested"
  },
  {
    "grapheme": "C’Thun",
    "confidence": "check",
    "ipa": "kətun",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Silithus",
    "confidence": "high",
    "ipa": "silitys",
    "note": "final S sounded"
  },
  {
    "grapheme": "silithide",
    "confidence": "high",
    "ipa": "silitid",
    "note": "French localization of silithid; keep consistent with Silithus"
  },
  {
    "grapheme": "silithides",
    "confidence": "high",
    "ipa": "silitid",
    "note": "plural of silithide"
  },
  {
    "grapheme": "Zul'Farrak",
    "confidence": "high",
    "ipa": "zulfaʁak",
    "note": "ZOUL, as French players and troll VO say it, not French /zyl/"
  },
  {
    "grapheme": "Zul'Gurub",
    "confidence": "high",
    "ipa": "zulɡuʁub",
    "note": "ZOUL-gou-ROUB, troll U as /u/"
  },
  {
    "grapheme": "Zul’Gurub",
    "confidence": "high",
    "ipa": "zulɡuʁub",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Gurubashi",
    "confidence": "high",
    "ipa": "ɡuʁubaʃi",
    "note": "not in English lexicon: untranslated in frFR; U as /u/ to match Zul'Gurub"
  },
  {
    "grapheme": "Zandalar",
    "confidence": "check",
    "ipa": "zɑ̃dalaʁ",
    "note": "AN before a consonant nasal, as French reads it"
  },
  {
    "grapheme": "zandalarien",
    "confidence": "check",
    "ipa": "zɑ̃dalaʁjɛ̃",
    "note": "French adjective from Zandalar; keep the stem consistent"
  },
  {
    "grapheme": "zandalariens",
    "confidence": "check",
    "ipa": "zɑ̃dalaʁjɛ̃",
    "note": "plural of zandalarien"
  },
  {
    "grapheme": "Atal'ai",
    "confidence": "high",
    "ipa": "atalaj",
    "note": "final AI is /aj/, not French /ɛ/"
  },
  {
    "grapheme": "Atal'Hakkar",
    "confidence": "check",
    "ipa": "atalakaʁ",
    "note": "H silent (the localization elides: d'Atal'Hakkar)"
  },
  {
    "grapheme": "Hakkar",
    "confidence": "high",
    "ipa": "akaʁ",
    "note": "H silent; the localization writes d'Hakkar"
  },
  {
    "grapheme": "Hakkari",
    "confidence": "high",
    "ipa": "akaʁi",
    "note": "H silent, consistent with Hakkar"
  },
  {
    "grapheme": "Jin’do",
    "confidence": "check",
    "ipa": "dʒindo",
    "note": "DJINN-do; French would read JIN as nasal /ʒɛ̃/"
  },
  {
    "grapheme": "Jin'do",
    "confidence": "check",
    "ipa": "dʒindo",
    "note": "straight-apostrophe spelling of Jin’do"
  },
  {
    "grapheme": "Un'Goro",
    "confidence": "high",
    "ipa": "unɡɔʁo",
    "note": "OUN, not French nasal 'un' /œ̃/; almost always elided d'Un'Goro"
  },
  {
    "grapheme": "Un’Goro",
    "confidence": "high",
    "ipa": "unɡɔʁo",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Teldrassil",
    "confidence": "high",
    "ipa": "tɛldʁasil"
  },
  {
    "grapheme": "Darnassus",
    "confidence": "high",
    "ipa": "daʁnasys",
    "note": "final S sounded"
  },
  {
    "grapheme": "Dolanaar",
    "confidence": "high",
    "ipa": "dolanaʁ"
  },
  {
    "grapheme": "Rut'theran",
    "confidence": "check",
    "ipa": "ʁuteʁɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Ban'ethil",
    "confidence": "check",
    "ipa": "banetil",
    "note": "BAN kept oral before the apostrophe"
  },
  {
    "grapheme": "Tirisfal",
    "confidence": "high",
    "ipa": "tiʁisfal"
  },
  {
    "grapheme": "Desolace",
    "confidence": "check",
    "ipa": "dezɔlas",
    "note": "rare untranslated spelling; matches the usual Désolace"
  },
  {
    "grapheme": "Feralas",
    "confidence": "high",
    "ipa": "feʁalas"
  },
  {
    "grapheme": "Tanaris",
    "confidence": "high",
    "ipa": "tanaʁis",
    "note": "final S sounded"
  },
  {
    "grapheme": "Uldaman",
    "confidence": "check",
    "ipa": "yldamɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Dalaran",
    "confidence": "check",
    "ipa": "dalaʁɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Alterac",
    "confidence": "high",
    "ipa": "alteʁak",
    "note": "covers the frequent d'Alterac"
  },
  {
    "grapheme": "Stromgarde",
    "confidence": "high",
    "ipa": "stʁɔmɡaʁd",
    "note": "OM kept oral, not nasal /ɔ̃/"
  },
  {
    "grapheme": "Arathi",
    "confidence": "high",
    "ipa": "aʁati",
    "note": "covers d'Arathi"
  },
  {
    "grapheme": "Arathor",
    "confidence": "high",
    "ipa": "aʁatɔʁ"
  },
  {
    "grapheme": "Andorhal",
    "confidence": "high",
    "ipa": "ɑ̃dɔʁal"
  },
  {
    "grapheme": "Stratholme",
    "confidence": "check",
    "ipa": "stʁatɔlm",
    "note": "L sounded as a French reader would; English VO drops it"
  },
  {
    "grapheme": "Scholomance",
    "confidence": "high",
    "ipa": "skɔlɔmɑ̃s",
    "note": "hard SCH /sk/, not /ʃ/"
  },
  {
    "grapheme": "Kharanos",
    "confidence": "high",
    "ipa": "kaʁanɔs"
  },
  {
    "grapheme": "Morogh",
    "confidence": "check",
    "ipa": "mɔʁɔɡ",
    "note": "Dun Morogh; final G sounded, GH not silent in French reading"
  },
  {
    "grapheme": "Modan",
    "confidence": "check",
    "ipa": "mɔdɑ̃",
    "note": "Loch Modan; final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Elwynn",
    "confidence": "high",
    "ipa": "ɛlwin",
    "note": "W as /w/, not /v/"
  },
  {
    "grapheme": "Mulgore",
    "confidence": "high",
    "ipa": "mylɡɔʁ"
  },
  {
    "grapheme": "Durotar",
    "confidence": "high",
    "ipa": "dyʁɔtaʁ"
  },
  {
    "grapheme": "Orgrimmar",
    "confidence": "high",
    "ipa": "ɔʁɡʁimaʁ"
  },
  {
    "grapheme": "Theramore",
    "confidence": "high",
    "ipa": "teʁamɔʁ"
  },
  {
    "grapheme": "Gadgetzan",
    "confidence": "check",
    "ipa": "ɡadʒɛtzɑ̃",
    "note": "DG as /dʒ/ as in French 'gadget'; final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Azshara",
    "confidence": "check",
    "ipa": "azʃaʁa",
    "note": "ZSH kept as Z+CH"
  },
  {
    "grapheme": "Sen'jin",
    "confidence": "check",
    "ipa": "sɛndʒin",
    "note": "DJ as in Vol'jin; French would read nasal 'sin-jin'"
  },
  {
    "grapheme": "Grom'gol",
    "confidence": "high",
    "ipa": "ɡʁɔmɡɔl",
    "note": "OM oral"
  },
  {
    "grapheme": "Zoram",
    "confidence": "high",
    "ipa": "zɔʁam",
    "note": "final AM oral"
  },
  {
    "grapheme": "Caer",
    "confidence": "check",
    "ipa": "kaʁ",
    "note": "Caer Darrow; one syllable"
  },
  {
    "grapheme": "Thelsamar",
    "confidence": "high",
    "ipa": "tɛlsamaʁ"
  },
  {
    "grapheme": "Thrall",
    "confidence": "high",
    "ipa": "tʁal",
    "note": "French VO: TRAL"
  },
  {
    "grapheme": "Sylvanas",
    "confidence": "high",
    "ipa": "silvanas",
    "note": "final S sounded"
  },
  {
    "grapheme": "Tyrande",
    "confidence": "high",
    "ipa": "tiʁɑ̃d"
  },
  {
    "grapheme": "Cénarius",
    "confidence": "high",
    "ipa": "senaʁjys",
    "note": "French spelling of Cenarius"
  },
  {
    "grapheme": "Cenarius",
    "confidence": "high",
    "ipa": "senaʁjys",
    "note": "rare unaccented spelling; same as Cénarius"
  },
  {
    "grapheme": "Cenarion",
    "confidence": "check",
    "ipa": "senaʁjɔ̃",
    "note": "rare untranslated form; usual text says cénarien"
  },
  {
    "grapheme": "Elune",
    "confidence": "high",
    "ipa": "elyn",
    "note": "French VO: é-LUNE"
  },
  {
    "grapheme": "Ragnaros",
    "confidence": "high",
    "ipa": "ʁaɡnaʁɔs",
    "note": "GN as /ɡn/, not /ɲ/"
  },
  {
    "grapheme": "Nefarian",
    "confidence": "check",
    "ipa": "nefaʁjɑ̃",
    "note": "final -ian nasal as French reads it"
  },
  {
    "grapheme": "Uther",
    "confidence": "high",
    "ipa": "ytɛʁ"
  },
  {
    "grapheme": "Bolvar",
    "confidence": "high",
    "ipa": "bɔlvaʁ"
  },
  {
    "grapheme": "Cairne",
    "confidence": "high",
    "ipa": "kɛʁn",
    "note": "one syllable"
  },
  {
    "grapheme": "Magni",
    "confidence": "high",
    "ipa": "maɡni",
    "note": "GN as /ɡn/, not French /ɲ/ as in 'magnifique'"
  },
  {
    "grapheme": "Mekkatorque",
    "confidence": "high",
    "ipa": "mɛkatɔʁk"
  },
  {
    "grapheme": "Medivh",
    "confidence": "high",
    "ipa": "mediv",
    "note": "the VH is a plain V"
  },
  {
    "grapheme": "Ysera",
    "confidence": "check",
    "ipa": "izeʁa",
    "note": "intervocalic S voiced as French reads it"
  },
  {
    "grapheme": "Staghelm",
    "confidence": "check",
    "ipa": "staɡɛlm",
    "note": "H silent"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "high",
    "ipa": "malfyʁjɔ̃"
  },
  {
    "grapheme": "Arugal",
    "confidence": "high",
    "ipa": "aʁyɡal"
  },
  {
    "grapheme": "Amnennar",
    "confidence": "check",
    "ipa": "amnenaʁ"
  },
  {
    "grapheme": "Charlga",
    "confidence": "check",
    "ipa": "ʃaʁlɡa",
    "note": "CH as French /ʃ/"
  },
  {
    "grapheme": "Dathrohan",
    "confidence": "check",
    "ipa": "datʁɔɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Naralex",
    "confidence": "high",
    "ipa": "naʁalɛks"
  },
  {
    "grapheme": "Theradras",
    "confidence": "check",
    "ipa": "teʁadʁas"
  },
  {
    "grapheme": "Zaetar",
    "confidence": "check",
    "ipa": "zetaʁ",
    "note": "AE as /e/, like Draenor"
  },
  {
    "grapheme": "Valthalak",
    "confidence": "high",
    "ipa": "valtalak"
  },
  {
    "grapheme": "Silverlaine",
    "confidence": "check",
    "ipa": "silvœʁlɛn",
    "note": "rare untranslated spelling; usual text says Argelaine"
  },
  {
    "grapheme": "Barov",
    "confidence": "high",
    "ipa": "baʁɔv"
  },
  {
    "grapheme": "Norgannon",
    "confidence": "high",
    "ipa": "nɔʁɡanɔ̃"
  },
  {
    "grapheme": "Agamaggan",
    "confidence": "check",
    "ipa": "aɡamaɡɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Aku'mai",
    "confidence": "high",
    "ipa": "akumaj",
    "note": "AKOU-maï; U as /u/, AI as /aj/"
  },
  {
    "grapheme": "Thunderbrew",
    "confidence": "check",
    "ipa": "tœndœʁbʁu",
    "note": "English name kept in frFR, French approximation of the English"
  },
  {
    "grapheme": "Runetotem",
    "confidence": "high",
    "ipa": "ʁyntɔtɛm",
    "note": "reads as French 'rune' + 'totem'"
  },
  {
    "grapheme": "Bloodhoof",
    "confidence": "check",
    "ipa": "blœduf",
    "note": "English name kept in frFR; H dropped as French speakers do"
  },
  {
    "grapheme": "Trollbane",
    "confidence": "check",
    "ipa": "tʁɔlbɛn",
    "note": "English name kept in frFR"
  },
  {
    "grapheme": "Lightbringer",
    "confidence": "check",
    "ipa": "lajtbʁiŋœʁ",
    "note": "English name kept in frFR"
  },
  {
    "grapheme": "Sul'thraze",
    "confidence": "check",
    "ipa": "syltʁaz"
  },
  {
    "grapheme": "Trol'kalar",
    "confidence": "high",
    "ipa": "tʁɔlkalaʁ"
  },
  {
    "grapheme": "Mosh'aru",
    "confidence": "high",
    "ipa": "mɔʃaʁu"
  },
  {
    "grapheme": "Gri'lek",
    "confidence": "high",
    "ipa": "ɡʁilɛk"
  },
  {
    "grapheme": "Jammal'an",
    "confidence": "check",
    "ipa": "dʒamalɑ̃",
    "note": "J as /dʒ/ like the troll names; final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Mai'Zoth",
    "confidence": "high",
    "ipa": "majzɔt",
    "note": "AI as /aj/"
  },
  {
    "grapheme": "Lar'korwi",
    "confidence": "high",
    "ipa": "laʁkɔʁwi"
  },
  {
    "grapheme": "Mar’alith",
    "confidence": "high",
    "ipa": "maʁalit",
    "note": "the majority spelling (curly apostrophe)"
  },
  {
    "grapheme": "Mar'alith",
    "confidence": "high",
    "ipa": "maʁalit"
  },
  {
    "grapheme": "Mor’zul",
    "confidence": "high",
    "ipa": "mɔʁzul",
    "note": "the majority spelling (curly apostrophe)"
  },
  {
    "grapheme": "Mor'zul",
    "confidence": "high",
    "ipa": "mɔʁzul"
  },
  {
    "grapheme": "Gor'mul",
    "confidence": "check",
    "ipa": "ɡɔʁmul"
  },
  {
    "grapheme": "Rin'ji",
    "confidence": "high",
    "ipa": "ʁindʒi",
    "note": "RIN oral, not nasal"
  },
  {
    "grapheme": "Zando'zan",
    "confidence": "check",
    "ipa": "zɑ̃dozɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "Bath'rah",
    "confidence": "high",
    "ipa": "batʁa"
  },
  {
    "grapheme": "Bath’rah",
    "confidence": "high",
    "ipa": "batʁa",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Jen'shan",
    "confidence": "check",
    "ipa": "dʒɛnʃɑ̃",
    "note": "final -an read nasal as a French narrator would; oral /an/ also plausible"
  },
  {
    "grapheme": "E'ko",
    "confidence": "high",
    "ipa": "eko",
    "note": "always written l'E'ko"
  },
  {
    "grapheme": "Pele'keiki",
    "confidence": "high",
    "ipa": "pelekeki",
    "note": "Hawaiian-styled troll name"
  },
  {
    "grapheme": "Pele’keiki",
    "confidence": "high",
    "ipa": "pelekeki",
    "note": "curly-apostrophe spelling of the same name in the corpus; Hawaiian-styled troll name"
  },
  {
    "grapheme": "Mau'ari",
    "confidence": "high",
    "ipa": "mawaʁi",
    "note": "AU is not French /o/"
  },
  {
    "grapheme": "Throm'ka",
    "confidence": "check",
    "ipa": "tʁɔmka",
    "note": "orcish greeting; OM oral"
  },
  {
    "grapheme": "Ruche'Regal",
    "confidence": "high",
    "ipa": "ʁyʃʁeɡal",
    "note": "French localization of Hive'Regal"
  },
  {
    "grapheme": "Ruche’Regal",
    "confidence": "high",
    "ipa": "ʁyʃʁeɡal",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Ruche'Zora",
    "confidence": "high",
    "ipa": "ʁyʃzɔʁa",
    "note": "French localization of Hive'Zora"
  },
  {
    "grapheme": "Ruche’Zora",
    "confidence": "high",
    "ipa": "ʁyʃzɔʁa",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "Ruche'Ashi",
    "confidence": "high",
    "ipa": "ʁyʃaʃi",
    "note": "French localization of Hive'Ashi"
  },
  {
    "grapheme": "Ruche’Ashi",
    "confidence": "high",
    "ipa": "ʁyʃaʃi",
    "note": "curly-apostrophe spelling of the same name in the corpus"
  },
  {
    "grapheme": "gnoll",
    "confidence": "high",
    "ipa": "ɡnɔl",
    "note": "GN as /ɡn/, not /ɲ/"
  },
  {
    "grapheme": "gnolls",
    "confidence": "high",
    "ipa": "ɡnɔl",
    "note": "plural of gnoll"
  },
  {
    "grapheme": "murloc",
    "confidence": "high",
    "ipa": "myʁlɔk"
  },
  {
    "grapheme": "murlocs",
    "confidence": "high",
    "ipa": "myʁlɔk",
    "note": "plural of murloc"
  },
  {
    "grapheme": "kobold",
    "confidence": "high",
    "ipa": "kɔbɔld",
    "note": "final D sounded"
  },
  {
    "grapheme": "kobolds",
    "confidence": "high",
    "ipa": "kɔbɔld",
    "note": "plural of kobold"
  },
  {
    "grapheme": "furbolg",
    "confidence": "high",
    "ipa": "fyʁbɔlɡ",
    "note": "final G sounded"
  },
  {
    "grapheme": "furbolgs",
    "confidence": "high",
    "ipa": "fyʁbɔlɡ",
    "note": "plural of furbolg"
  },
  {
    "grapheme": "worgen",
    "confidence": "high",
    "ipa": "wɔʁɡɛn",
    "note": "W as /w/, hard G; not French /vɔʁʒɛ̃/"
  },
  {
    "grapheme": "worgens",
    "confidence": "high",
    "ipa": "wɔʁɡɛn",
    "note": "plural of worgen"
  },
  {
    "grapheme": "Défias",
    "confidence": "high",
    "ipa": "defjas",
    "note": "French spelling of Defias; final S sounded"
  },
  {
    "grapheme": "Defias",
    "confidence": "high",
    "ipa": "defjas",
    "note": "rare unaccented spelling"
  },
  {
    "grapheme": "Stormwind",
    "confidence": "check",
    "ipa": "stɔʁmwind",
    "note": "not in English lexicon: English name kept in frFR (439x)"
  },
  {
    "grapheme": "Ironforge",
    "confidence": "check",
    "ipa": "ajʁɔnfɔʁdʒ",
    "note": "not in English lexicon: English name kept in frFR; French reading would give /iʁɔ̃fɔʁʒ/"
  },
  {
    "grapheme": "Undercity",
    "confidence": "check",
    "ipa": "œndœʁsiti",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Thunder",
    "confidence": "check",
    "ipa": "tœndœʁ",
    "note": "not in English lexicon: Thunder Bluff kept in English in frFR"
  },
  {
    "grapheme": "Thunderhorn",
    "confidence": "check",
    "ipa": "tœndœʁɔʁn",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Ashenvale",
    "confidence": "check",
    "ipa": "aʃənvɛl",
    "note": "not in English lexicon: English spelling alongside Orneval; French would read /aʃɑ̃val/"
  },
  {
    "grapheme": "Hinterlands",
    "confidence": "check",
    "ipa": "intœʁlands",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Southshore",
    "confidence": "check",
    "ipa": "sawʃɔʁ",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Goldshire",
    "confidence": "check",
    "ipa": "ɡɔldʃajʁ",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Lakeshire",
    "confidence": "check",
    "ipa": "lɛkʃajʁ",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Proudmoore",
    "confidence": "check",
    "ipa": "pʁawdmuʁ",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Doomhammer",
    "confidence": "check",
    "ipa": "dumamœʁ",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Ravenholdt",
    "confidence": "check",
    "ipa": "ʁevənɔlt",
    "note": "not in English lexicon: English name kept in frFR"
  },
  {
    "grapheme": "Ratchet",
    "confidence": "check",
    "ipa": "ʁatʃɛt",
    "note": "not in English lexicon: English name kept in frFR; CH as /tʃ/"
  },
  {
    "grapheme": "Kil'jaeden",
    "confidence": "check",
    "ipa": "kildʒɛdɛn",
    "note": "not in English lexicon: J as /dʒ/, final -en oral"
  },
  {
    "grapheme": "Ner'zhul",
    "confidence": "check",
    "ipa": "nɛʁzul",
    "note": "not in English lexicon: ZH as /z/, U as /u/ (Ner'zhoul)"
  },
  {
    "grapheme": "Gul'dan",
    "confidence": "check",
    "ipa": "ɡuldɑ̃",
    "note": "not in English lexicon: GOUL-dane, U as /u/"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- ptBR: 128 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('ptBR', $lexicon$[
  {
    "grapheme": "Magatha",
    "confidence": "high",
    "ipa": "ˈmaɡatɐ",
    "note": "TH read as t"
  },
  {
    "grapheme": "Narache",
    "confidence": "high",
    "ipa": "naˈɾatʃi",
    "note": "CH as tʃ, not pt ʃ"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ˌɔˌɔˈʃis",
    "note": "letters spelled out, pt letter names (ó ó xis); EN alias was 'oh oh ex'"
  },
  {
    "grapheme": "Draenor",
    "confidence": "check",
    "ipa": "ˈdɾɛnoɾ",
    "note": "EN had a no-op alias; AE as one vowel, EN first-syllable stress"
  },
  {
    "grapheme": "Maiev",
    "confidence": "check",
    "ipa": "ˈmajɛv",
    "note": "stress contested (MY-ev vs mai-EV)"
  },
  {
    "grapheme": "Satyrnaar",
    "confidence": "check",
    "ipa": "ˈsatiɾˌnaɾ",
    "note": "EN stress pinned"
  },
  {
    "grapheme": "Mathias",
    "confidence": "check",
    "ipa": "maˈtʃias",
    "note": "read like pt Matias; EN is ma-THAI-as"
  },
  {
    "grapheme": "Loch",
    "confidence": "high",
    "ipa": "ˈlɔk",
    "note": "Loch Modan; CH as k"
  },
  {
    "grapheme": "Gnomeregan",
    "confidence": "check",
    "ipa": "ˈnomeɾeɡɐ̃",
    "note": "silent G as in EN, although pt 'gnomo' sounds the G; EN initial stress pinned"
  },
  {
    "grapheme": "Azeroth",
    "confidence": "check",
    "ipa": "azeˈɾɔt",
    "note": "TH as t; BR usage stresses the last syllable (EN stresses the first) - confirm vs pt VO"
  },
  {
    "grapheme": "Kalimdor",
    "confidence": "check",
    "ipa": "ˈkalimdoɾ",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Lordaeron",
    "confidence": "check",
    "ipa": "ˈlɔɾdeɾõ",
    "note": "three syllables, AE as e, not LOR-day-ron"
  },
  {
    "grapheme": "Quel'Thalas",
    "confidence": "high",
    "ipa": "kɛwˈtalas",
    "note": "also spelled Quel'thalas"
  },
  {
    "grapheme": "Eldre'Thalas",
    "confidence": "check",
    "ipa": "ɛwˈdɾetalas"
  },
  {
    "grapheme": "Kel'Thuzad",
    "confidence": "high",
    "ipa": "kɛwˈtuzad"
  },
  {
    "grapheme": "Naxxramas",
    "confidence": "high",
    "ipa": "naksˈɾamas"
  },
  {
    "grapheme": "Ahn'Qiraj",
    "confidence": "high",
    "ipa": "ɐ̃kiˈɾaʒ",
    "note": "final consonant contested: ʒ here, some say dʒ"
  },
  {
    "grapheme": "Qiraji",
    "confidence": "high",
    "ipa": "kiˈɾaʒi"
  },
  {
    "grapheme": "qirajis",
    "confidence": "high",
    "ipa": "kiˈɾaʒis",
    "note": "pt plural of qiraji"
  },
  {
    "grapheme": "C'Thun",
    "confidence": "check",
    "ipa": "kiˈtũ"
  },
  {
    "grapheme": "Silithus",
    "confidence": "check",
    "ipa": "ˈsilitus",
    "note": "EN first-syllable stress; pt default would be si-LI-tus"
  },
  {
    "grapheme": "Zul'Farrak",
    "confidence": "high",
    "ipa": "zuwˈfahak",
    "note": "RR as h"
  },
  {
    "grapheme": "Zul'Gurub",
    "confidence": "high",
    "ipa": "zuwɡuˈɾub"
  },
  {
    "grapheme": "Zandalar",
    "confidence": "check",
    "ipa": "ˈzɐ̃dalaɾ",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Atal'ai",
    "confidence": "high",
    "ipa": "ˈatalaj"
  },
  {
    "grapheme": "Atal'Hakkar",
    "confidence": "check",
    "ipa": "atawˈhakaɾ",
    "note": "H is sounded (pt would drop it)"
  },
  {
    "grapheme": "Hakkar",
    "confidence": "high",
    "ipa": "ˈhakaɾ",
    "note": "H is sounded (pt would drop it)"
  },
  {
    "grapheme": "Hakkari",
    "confidence": "high",
    "ipa": "haˈkaɾi",
    "note": "H is sounded"
  },
  {
    "grapheme": "Jin'do",
    "confidence": "high",
    "ipa": "ˈdʒindo",
    "note": "J as dʒ, not pt ʒ"
  },
  {
    "grapheme": "Un'Goro",
    "confidence": "high",
    "ipa": "ũˈɡoɾo"
  },
  {
    "grapheme": "Teldrassil",
    "confidence": "high",
    "ipa": "tɛwˈdɾasiw"
  },
  {
    "grapheme": "Darnassus",
    "confidence": "high",
    "ipa": "daɾˈnasus",
    "note": "SS keeps s voiceless"
  },
  {
    "grapheme": "Dolanaar",
    "confidence": "high",
    "ipa": "dolaˈnaɾ"
  },
  {
    "grapheme": "Auberdine",
    "confidence": "check",
    "ipa": "ˈɔbeɾdʒin",
    "note": "AU as ɔ (EN), final -ine without pt final vowel"
  },
  {
    "grapheme": "Rut'theran",
    "confidence": "check",
    "ipa": "ˈhuteɾɐ̃"
  },
  {
    "grapheme": "Ban'ethil",
    "confidence": "check",
    "ipa": "bɐ̃ˈnɛtʃiw"
  },
  {
    "grapheme": "Tirisfal",
    "confidence": "check",
    "ipa": "ˈtʃiɾisfaw",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Feralas",
    "confidence": "high",
    "ipa": "feˈɾalas"
  },
  {
    "grapheme": "Tanaris",
    "confidence": "high",
    "ipa": "taˈnaɾis"
  },
  {
    "grapheme": "Uldaman",
    "confidence": "check",
    "ipa": "ˈuwdamɐ̃",
    "note": "EN first-syllable stress"
  },
  {
    "grapheme": "Dalaran",
    "confidence": "check",
    "ipa": "ˈdalaɾɐ̃",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Alterac",
    "confidence": "check",
    "ipa": "ˈawteɾak",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Stromgarde",
    "confidence": "check",
    "ipa": "ˈstɾɔmɡaɾd",
    "note": "final E silent"
  },
  {
    "grapheme": "Arathi",
    "confidence": "high",
    "ipa": "aˈɾatʃi"
  },
  {
    "grapheme": "Arathor",
    "confidence": "check",
    "ipa": "ˈaɾatoɾ",
    "note": "EN first-syllable stress"
  },
  {
    "grapheme": "Andorhal",
    "confidence": "check",
    "ipa": "ˈɐ̃dɔɾhɔw",
    "note": "H sounded; EN first-syllable stress"
  },
  {
    "grapheme": "Stratholme",
    "confidence": "check",
    "ipa": "ˈstɾatom",
    "note": "silent L in Blizzard's EN VO"
  },
  {
    "grapheme": "Kharanos",
    "confidence": "check",
    "ipa": "ˈkaɾanos",
    "note": "EN first-syllable stress; pt default ka-RA-nos"
  },
  {
    "grapheme": "Morogh",
    "confidence": "high",
    "ipa": "ˈmɔɾo",
    "note": "Dun Morogh; final GH silent"
  },
  {
    "grapheme": "Modan",
    "confidence": "check",
    "ipa": "ˈmodɐ̃",
    "note": "Loch Modan"
  },
  {
    "grapheme": "Elwynn",
    "confidence": "high",
    "ipa": "ˈɛwin"
  },
  {
    "grapheme": "Mulgore",
    "confidence": "high",
    "ipa": "ˈmuwɡɔɾ",
    "note": "MULL-gore per the tauren intro cinematic; final E silent"
  },
  {
    "grapheme": "Durotar",
    "confidence": "check",
    "ipa": "ˈduɾotaɾ",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Orgrimmar",
    "confidence": "check",
    "ipa": "ˈɔɾɡɾimaɾ",
    "note": "EN first-syllable stress; pt default would be final"
  },
  {
    "grapheme": "Theramore",
    "confidence": "high",
    "ipa": "ˈtɛɾamɔɾ",
    "note": "final E silent"
  },
  {
    "grapheme": "Azshara",
    "confidence": "high",
    "ipa": "aʒˈʃaɾɐ",
    "note": "the ZSH is a real ʒ, not a plain z"
  },
  {
    "grapheme": "Sen'jin",
    "confidence": "high",
    "ipa": "ˈsendʒin",
    "note": "J as dʒ"
  },
  {
    "grapheme": "Grom'gol",
    "confidence": "high",
    "ipa": "ˈɡɾɔmɡow"
  },
  {
    "grapheme": "Zoram",
    "confidence": "check",
    "ipa": "ˈzɔɾɐ̃",
    "note": "must not become pt -ão (ZÓ-rão)"
  },
  {
    "grapheme": "Thelsamar",
    "confidence": "high",
    "ipa": "tɛwˈsamaɾ"
  },
  {
    "grapheme": "Thrall",
    "confidence": "high",
    "ipa": "ˈtɾaw",
    "note": "TH as t, final L vocalised"
  },
  {
    "grapheme": "Sylvanas",
    "confidence": "high",
    "ipa": "siwˈvanas"
  },
  {
    "grapheme": "Sylvana",
    "confidence": "high",
    "ipa": "siwˈvanɐ",
    "note": "not in English lexicon: pt localization spells her Sylvana"
  },
  {
    "grapheme": "Tyrande",
    "confidence": "check",
    "ipa": "tʃiˈɾɐ̃dej",
    "note": "EN ends in -day; pt would say -dʒi"
  },
  {
    "grapheme": "Cenarius",
    "confidence": "high",
    "ipa": "seˈnaɾjus"
  },
  {
    "grapheme": "Ragnaros",
    "confidence": "check",
    "ipa": "ˈhaɡnaɾos",
    "note": "EN first-syllable stress; pt default rag-NA-ros"
  },
  {
    "grapheme": "Nefarian",
    "confidence": "check",
    "ipa": "neˈfaɾjɐ̃"
  },
  {
    "grapheme": "Arthas",
    "confidence": "high",
    "ipa": "ˈaɾtas"
  },
  {
    "grapheme": "Uther",
    "confidence": "check",
    "ipa": "ˈjuteɾ",
    "note": "EN YOO-ther; pt readers may say Ú-ter"
  },
  {
    "grapheme": "Bolvar",
    "confidence": "high",
    "ipa": "ˈbɔwvaɾ"
  },
  {
    "grapheme": "Caerne",
    "confidence": "check",
    "ipa": "ˈkɛɾni",
    "note": "not in English lexicon: pt spelling of Cairne; one syllable in EN"
  },
  {
    "grapheme": "Magni",
    "confidence": "high",
    "ipa": "ˈmaɡni"
  },
  {
    "grapheme": "Mekkatorque",
    "confidence": "check",
    "ipa": "ˈmɛkatɔɾk",
    "note": "final -que silent"
  },
  {
    "grapheme": "Medivh",
    "confidence": "high",
    "ipa": "meˈdʒiv",
    "note": "the VH is a plain v"
  },
  {
    "grapheme": "Ysera",
    "confidence": "check",
    "ipa": "iˈsɛɾɐ",
    "note": "voiceless s as in EN; pt would voice it"
  },
  {
    "grapheme": "Malfurion",
    "confidence": "check",
    "ipa": "mawˈfuɾjõ"
  },
  {
    "grapheme": "Arugal",
    "confidence": "check",
    "ipa": "ˈaɾuɡaw",
    "note": "EN first-syllable stress"
  },
  {
    "grapheme": "Amnennar",
    "confidence": "check",
    "ipa": "amˈnenaɾ"
  },
  {
    "grapheme": "Charlga",
    "confidence": "check",
    "ipa": "ˈtʃaɾwɡɐ",
    "note": "CH as tʃ"
  },
  {
    "grapheme": "Dathrohan",
    "confidence": "check",
    "ipa": "ˈdatɾohɐ̃",
    "note": "H sounded"
  },
  {
    "grapheme": "Naralex",
    "confidence": "high",
    "ipa": "ˈnaɾalɛks"
  },
  {
    "grapheme": "Theradras",
    "confidence": "check",
    "ipa": "teˈɾadɾas"
  },
  {
    "grapheme": "Zaetar",
    "confidence": "check",
    "ipa": "ˈzetaɾ",
    "note": "AE as e"
  },
  {
    "grapheme": "Valthalak",
    "confidence": "high",
    "ipa": "ˈvawtalak"
  },
  {
    "grapheme": "Silverlaine",
    "confidence": "check",
    "ipa": "ˈsiwveɾlejn"
  },
  {
    "grapheme": "Barov",
    "confidence": "high",
    "ipa": "ˈbaɾov"
  },
  {
    "grapheme": "Norgannon",
    "confidence": "check",
    "ipa": "ˈnɔɾɡanõ"
  },
  {
    "grapheme": "Agamaggan",
    "confidence": "check",
    "ipa": "aɡaˈmaɡɐ̃"
  },
  {
    "grapheme": "Aku'mai",
    "confidence": "high",
    "ipa": "ˈakumaj"
  },
  {
    "grapheme": "Trollbane",
    "confidence": "check",
    "ipa": "ˈtɾɔwbejn",
    "note": "name kept in English by the pt localization"
  },
  {
    "grapheme": "Sul'thraze",
    "confidence": "check",
    "ipa": "suwˈtɾejz"
  },
  {
    "grapheme": "Trol'kalar",
    "confidence": "high",
    "ipa": "tɾɔwˈkalaɾ"
  },
  {
    "grapheme": "Mosh'aru",
    "confidence": "high",
    "ipa": "mɔʃˈaɾu"
  },
  {
    "grapheme": "Gri'lek",
    "confidence": "high",
    "ipa": "ˈɡɾilɛk"
  },
  {
    "grapheme": "Jammal'an",
    "confidence": "check",
    "ipa": "dʒaˈmalɐ̃",
    "note": "J as dʒ"
  },
  {
    "grapheme": "Mai'Zoth",
    "confidence": "high",
    "ipa": "majˈzɔt"
  },
  {
    "grapheme": "Lar'korwi",
    "confidence": "high",
    "ipa": "laɾˈkɔɾwi"
  },
  {
    "grapheme": "Mar'alith",
    "confidence": "high",
    "ipa": "maɾˈalit"
  },
  {
    "grapheme": "Mor'zul",
    "confidence": "high",
    "ipa": "mɔɾˈzuw"
  },
  {
    "grapheme": "Gor'mul",
    "confidence": "check",
    "ipa": "ɡɔɾˈmuw"
  },
  {
    "grapheme": "Rin'ji",
    "confidence": "high",
    "ipa": "ˈhindʒi"
  },
  {
    "grapheme": "Zando'zan",
    "confidence": "high",
    "ipa": "ˈzɐ̃dozɐ̃"
  },
  {
    "grapheme": "Bath'rah",
    "confidence": "high",
    "ipa": "ˈbatɾa"
  },
  {
    "grapheme": "Jen'shan",
    "confidence": "high",
    "ipa": "ˈdʒenʃɐ̃"
  },
  {
    "grapheme": "E'ko",
    "confidence": "high",
    "ipa": "ˈɛko"
  },
  {
    "grapheme": "Pele'keiki",
    "confidence": "high",
    "ipa": "ˌpɛleˈkejki",
    "note": "Hawaiian-styled troll name"
  },
  {
    "grapheme": "Mau'ari",
    "confidence": "high",
    "ipa": "mawˈaɾi"
  },
  {
    "grapheme": "Throm'ka",
    "confidence": "check",
    "ipa": "ˈtɾɔmka",
    "note": "orcish greeting"
  },
  {
    "grapheme": "gnoll",
    "confidence": "check",
    "ipa": "ˈnɔw",
    "note": "silent G as in EN; pt readers often sound it"
  },
  {
    "grapheme": "gnolls",
    "confidence": "check",
    "ipa": "ˈnɔws",
    "note": "plural"
  },
  {
    "grapheme": "murloc",
    "confidence": "high",
    "ipa": "ˈmuɾlɔk"
  },
  {
    "grapheme": "murlocs",
    "confidence": "high",
    "ipa": "ˈmuɾlɔks",
    "note": "plural"
  },
  {
    "grapheme": "kobold",
    "confidence": "high",
    "ipa": "ˈkobowd"
  },
  {
    "grapheme": "kobolds",
    "confidence": "high",
    "ipa": "ˈkobowds",
    "note": "plural"
  },
  {
    "grapheme": "furbolg",
    "confidence": "high",
    "ipa": "ˈfuɾbɔwɡ"
  },
  {
    "grapheme": "furbolgs",
    "confidence": "high",
    "ipa": "ˈfuɾbɔwɡs",
    "note": "plural"
  },
  {
    "grapheme": "kodo",
    "confidence": "high",
    "ipa": "ˈkodo",
    "note": "final o not reduced to u"
  },
  {
    "grapheme": "kodos",
    "confidence": "high",
    "ipa": "ˈkodos",
    "note": "plural"
  },
  {
    "grapheme": "tauren",
    "confidence": "high",
    "ipa": "ˈtawɾen"
  },
  {
    "grapheme": "taurens",
    "confidence": "high",
    "ipa": "ˈtawɾens",
    "note": "plural"
  },
  {
    "grapheme": "taurena",
    "confidence": "high",
    "ipa": "tawˈɾenɐ",
    "note": "feminine form used by the pt localization"
  },
  {
    "grapheme": "worgen",
    "confidence": "high",
    "ipa": "ˈwɔɾɡen",
    "note": "hard G (pt would read ʒ before e)"
  },
  {
    "grapheme": "worgens",
    "confidence": "high",
    "ipa": "ˈwɔɾɡens",
    "note": "plural; hard G"
  },
  {
    "grapheme": "Defias",
    "confidence": "check",
    "ipa": "ˈdɛfjas",
    "note": "pt localization also writes Défias, so pt stress on DÉ; EN is de-FYE-as"
  },
  {
    "grapheme": "Geringontzan",
    "confidence": "check",
    "ipa": "ʒeɾĩɡõˈtsɐ̃",
    "note": "not in English lexicon: pt name of Gadgetzan (pun on geringonça); TZ as ts"
  },
  {
    "grapheme": "Brastematic",
    "confidence": "check",
    "ipa": "bɾasteˈmatʃik",
    "note": "not in English lexicon: pt name of Sparklematic; no final vowel"
  },
  {
    "grapheme": "Onyxia",
    "confidence": "check",
    "ipa": "oˈniksjɐ",
    "note": "not in English lexicon: X as ks, not pt ʃ"
  },
  {
    "grapheme": "Kel'Theril",
    "confidence": "check",
    "ipa": "kɛwˈtɛɾiw",
    "note": "not in English lexicon: apostrophe name, 15 occurrences"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- ruRU: 335 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('ruRU', $lexicon$[
  {
    "grapheme": "Магата",
    "confidence": "check",
    "ipa": "mɐˈɡatə",
    "note": "Магата; stress on the second syllable (English MAG-a-tha) is a guess"
  },
  {
    "grapheme": "Магате",
    "confidence": "check",
    "ipa": "mɐˈɡatʲɪ",
    "note": "inflected form, same stress as Магата"
  },
  {
    "grapheme": "Магату",
    "confidence": "check",
    "ipa": "mɐˈɡatʊ",
    "note": "inflected form, same stress as Магата"
  },
  {
    "grapheme": "Магаты",
    "confidence": "check",
    "ipa": "mɐˈɡatɨ",
    "note": "inflected form, same stress as Магата"
  },
  {
    "grapheme": "Нараче",
    "confidence": "high",
    "ipa": "nɐˈratɕɪ",
    "note": "Нараче, indeclinable"
  },
  {
    "grapheme": "Дренора",
    "confidence": "high",
    "ipa": "drʲɪˈnorə",
    "note": "Дренор, established final stress"
  },
  {
    "grapheme": "Дренор",
    "confidence": "high",
    "ipa": "drʲɪˈnor",
    "note": "inflected form, same stress as Дренора"
  },
  {
    "grapheme": "Дреноре",
    "confidence": "high",
    "ipa": "drʲɪˈnorʲɪ",
    "note": "inflected form, same stress as Дренора"
  },
  {
    "grapheme": "Майев",
    "confidence": "check",
    "ipa": "ˈmajɪf",
    "note": "Майев"
  },
  {
    "grapheme": "Матиас",
    "confidence": "check",
    "ipa": "mɐˈtʲiəs",
    "note": "Матиас; English stress kept on -ти-"
  },
  {
    "grapheme": "Матиасу",
    "confidence": "check",
    "ipa": "mɐˈtʲiəsʊ",
    "note": "inflected form, same stress as Матиас"
  },
  {
    "grapheme": "Артас",
    "confidence": "high",
    "ipa": "ˈartəs",
    "note": "Артас, initial stress as in the Russian WC3 dub"
  },
  {
    "grapheme": "Артаса",
    "confidence": "high",
    "ipa": "ˈartəsə",
    "note": "inflected form, same stress as Артас"
  },
  {
    "grapheme": "Артасу",
    "confidence": "high",
    "ipa": "ˈartəsʊ",
    "note": "inflected form, same stress as Артас"
  },
  {
    "grapheme": "Гномреган",
    "confidence": "high",
    "ipa": "ɡnəmrʲɪˈɡan",
    "note": "Гномреган, final stress in Russian usage"
  },
  {
    "grapheme": "Гномрегана",
    "confidence": "high",
    "ipa": "ɡnəmrʲɪˈɡanə",
    "note": "inflected form, same stress as Гномреган"
  },
  {
    "grapheme": "Гномрегане",
    "confidence": "high",
    "ipa": "ɡnəmrʲɪˈɡanʲɪ",
    "note": "inflected form, same stress as Гномреган"
  },
  {
    "grapheme": "Азерота",
    "confidence": "high",
    "ipa": "ɐzʲɪˈrotə",
    "note": "Азерот, final stress established in Russian"
  },
  {
    "grapheme": "Азерот",
    "confidence": "high",
    "ipa": "ɐzʲɪˈrot",
    "note": "inflected form, same stress as Азерота"
  },
  {
    "grapheme": "Азероте",
    "confidence": "high",
    "ipa": "ɐzʲɪˈrotʲɪ",
    "note": "inflected form, same stress as Азерота"
  },
  {
    "grapheme": "Азероту",
    "confidence": "high",
    "ipa": "ɐzʲɪˈrotʊ",
    "note": "inflected form, same stress as Азерота"
  },
  {
    "grapheme": "Азеротом",
    "confidence": "high",
    "ipa": "ɐzʲɪˈrotəm",
    "note": "inflected form, same stress as Азерота"
  },
  {
    "grapheme": "Калимдора",
    "confidence": "high",
    "ipa": "kəlʲɪmˈdorə",
    "note": "Калимдор"
  },
  {
    "grapheme": "Калимдор",
    "confidence": "high",
    "ipa": "kəlʲɪmˈdor",
    "note": "inflected form, same stress as Калимдора"
  },
  {
    "grapheme": "Калимдоре",
    "confidence": "high",
    "ipa": "kəlʲɪmˈdorʲɪ",
    "note": "inflected form, same stress as Калимдора"
  },
  {
    "grapheme": "Калимдору",
    "confidence": "high",
    "ipa": "kəlʲɪmˈdorʊ",
    "note": "inflected form, same stress as Калимдора"
  },
  {
    "grapheme": "Калимдором",
    "confidence": "high",
    "ipa": "kəlʲɪmˈdorəm",
    "note": "inflected form, same stress as Калимдора"
  },
  {
    "grapheme": "Лордерона",
    "confidence": "high",
    "ipa": "ɫərdʲɪˈronə",
    "note": "Лордерон"
  },
  {
    "grapheme": "Лордерон",
    "confidence": "high",
    "ipa": "ɫərdʲɪˈron",
    "note": "inflected form, same stress as Лордерона"
  },
  {
    "grapheme": "Лордероне",
    "confidence": "high",
    "ipa": "ɫərdʲɪˈronʲɪ",
    "note": "inflected form, same stress as Лордерона"
  },
  {
    "grapheme": "Лордерону",
    "confidence": "high",
    "ipa": "ɫərdʲɪˈronʊ",
    "note": "inflected form, same stress as Лордерона"
  },
  {
    "grapheme": "Лордероном",
    "confidence": "high",
    "ipa": "ɫərdʲɪˈronəm",
    "note": "inflected form, same stress as Лордерона"
  },
  {
    "grapheme": "Кель'Таласа",
    "confidence": "check",
    "ipa": "kʲɪlʲˈtaɫəsə",
    "note": "Кель'Талас; English stress THAL kept, some say -ла́с"
  },
  {
    "grapheme": "Кель'Талас",
    "confidence": "check",
    "ipa": "kʲɪlʲˈtaɫəs",
    "note": "inflected form, same stress as Кель'Таласа"
  },
  {
    "grapheme": "Эльдре'Таласа",
    "confidence": "check",
    "ipa": "ɛlʲdrʲɪˈtaɫəsə",
    "note": "Эльдре'Талас, kept parallel with Кель'Талас"
  },
  {
    "grapheme": "Эльдре'Талас",
    "confidence": "check",
    "ipa": "ɛlʲdrʲɪˈtaɫəs",
    "note": "inflected form, same stress as Эльдре'Таласа"
  },
  {
    "grapheme": "Эльдре'Таласе",
    "confidence": "check",
    "ipa": "ɛlʲdrʲɪˈtaɫəsʲɪ",
    "note": "inflected form, same stress as Эльдре'Таласа"
  },
  {
    "grapheme": "Кел'Тузада",
    "confidence": "high",
    "ipa": "kʲɪɫtʊˈzadə",
    "note": "Кел'Тузад"
  },
  {
    "grapheme": "Кел'Тузад",
    "confidence": "high",
    "ipa": "kʲɪɫtʊˈzat",
    "note": "inflected form, same stress as Кел'Тузада"
  },
  {
    "grapheme": "Кел'Тузаду",
    "confidence": "high",
    "ipa": "kʲɪɫtʊˈzadʊ",
    "note": "inflected form, same stress as Кел'Тузада"
  },
  {
    "grapheme": "Кел'Тузадом",
    "confidence": "high",
    "ipa": "kʲɪɫtʊˈzadəm",
    "note": "inflected form, same stress as Кел'Тузада"
  },
  {
    "grapheme": "Наксрамас",
    "confidence": "high",
    "ipa": "nəksrɐˈmas",
    "note": "Наксрамас"
  },
  {
    "grapheme": "Наксрамасе",
    "confidence": "high",
    "ipa": "nəksrɐˈmasʲɪ",
    "note": "inflected form, same stress as Наксрамас"
  },
  {
    "grapheme": "Наксрамаса",
    "confidence": "high",
    "ipa": "nəksrɐˈmasə",
    "note": "inflected form, same stress as Наксрамас"
  },
  {
    "grapheme": "Ан'Кираже",
    "confidence": "high",
    "ipa": "ɐnkʲɪˈraʐɨ",
    "note": "Ан'Кираж; Russian final devoicing gives ш in the bare form"
  },
  {
    "grapheme": "Ан'Киража",
    "confidence": "high",
    "ipa": "ɐnkʲɪˈraʐə",
    "note": "inflected form, same stress as Ан'Кираже"
  },
  {
    "grapheme": "Ан'Кираж",
    "confidence": "high",
    "ipa": "ɐnkʲɪˈraʂ",
    "note": "inflected form, same stress as Ан'Кираже"
  },
  {
    "grapheme": "ан'киражской",
    "confidence": "high",
    "ipa": "ɐnkʲɪˈraʂskəj",
    "note": "inflected form, same stress as Ан'Кираже"
  },
  {
    "grapheme": "Киражи",
    "confidence": "high",
    "ipa": "kʲɪˈraʐɨ",
    "note": "киражи and adjective forms"
  },
  {
    "grapheme": "Киражские",
    "confidence": "high",
    "ipa": "kʲɪˈraʂskʲɪjɪ",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "киражских",
    "confidence": "high",
    "ipa": "kʲɪˈraʂskʲɪx",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "киражская",
    "confidence": "high",
    "ipa": "kʲɪˈraʂskəjə",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "Киражей",
    "confidence": "high",
    "ipa": "kʲɪˈraʐɨj",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "киражским",
    "confidence": "high",
    "ipa": "kʲɪˈraʂskʲɪm",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "киражами",
    "confidence": "high",
    "ipa": "kʲɪˈraʐəmʲɪ",
    "note": "inflected form, same stress as Киражи"
  },
  {
    "grapheme": "К'Тун",
    "confidence": "high",
    "ipa": "ˈktun",
    "note": "К'Тун, one syllable with a kt cluster"
  },
  {
    "grapheme": "К'Туна",
    "confidence": "high",
    "ipa": "ˈktunə",
    "note": "inflected form, same stress as К'Тун"
  },
  {
    "grapheme": "Силитусе",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʊsʲɪ",
    "note": "Силитус; English initial stress kept, players also say Сили́тус"
  },
  {
    "grapheme": "Силитуса",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʊsə",
    "note": "inflected form, same stress as Силитусе"
  },
  {
    "grapheme": "Силитус",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʊs",
    "note": "inflected form, same stress as Силитусе"
  },
  {
    "grapheme": "силитидов",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪdəf",
    "note": "силитиды; kept consistent with Силитус"
  },
  {
    "grapheme": "силитиды",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪdɨ",
    "note": "inflected form, same stress as силитидов"
  },
  {
    "grapheme": "силитидами",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪdəmʲɪ",
    "note": "inflected form, same stress as силитидов"
  },
  {
    "grapheme": "силитидам",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪdəm",
    "note": "inflected form, same stress as силитидов"
  },
  {
    "grapheme": "силитидский",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪtskʲɪj",
    "note": "inflected form, same stress as силитидов"
  },
  {
    "grapheme": "силитид",
    "confidence": "check",
    "ipa": "ˈsʲilʲɪtʲɪt",
    "note": "inflected form, same stress as силитидов"
  },
  {
    "grapheme": "Зул'Фаррака",
    "confidence": "high",
    "ipa": "zʊɫfɐˈrakə",
    "note": "Зул'Фаррак"
  },
  {
    "grapheme": "Зул'Фаррак",
    "confidence": "high",
    "ipa": "zʊɫfɐˈrak",
    "note": "inflected form, same stress as Зул'Фаррака"
  },
  {
    "grapheme": "Зул'Фарраке",
    "confidence": "high",
    "ipa": "zʊɫfɐˈrakʲɪ",
    "note": "inflected form, same stress as Зул'Фаррака"
  },
  {
    "grapheme": "Зул'Гуруба",
    "confidence": "high",
    "ipa": "zʊɫɡʊˈrubə",
    "note": "Зул'Гуруб"
  },
  {
    "grapheme": "Зул'Гурубе",
    "confidence": "high",
    "ipa": "zʊɫɡʊˈrubʲɪ",
    "note": "inflected form, same stress as Зул'Гуруба"
  },
  {
    "grapheme": "Зул'Гуруб",
    "confidence": "high",
    "ipa": "zʊɫɡʊˈrup",
    "note": "inflected form, same stress as Зул'Гуруба"
  },
  {
    "grapheme": "Зандалара",
    "confidence": "high",
    "ipa": "zəndɐˈɫarə",
    "note": "Зандалар and зандаларский/зандаларцы"
  },
  {
    "grapheme": "Зандалар",
    "confidence": "high",
    "ipa": "zəndɐˈɫar",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "зандаларского",
    "confidence": "high",
    "ipa": "zəndɐˈɫarskəɡə",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Зандаларе",
    "confidence": "high",
    "ipa": "zəndɐˈɫarʲɪ",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Зандаларов",
    "confidence": "high",
    "ipa": "zəndɐˈɫarəf",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Зандаларский",
    "confidence": "high",
    "ipa": "zəndɐˈɫarskʲɪj",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Зандалары",
    "confidence": "high",
    "ipa": "zəndɐˈɫarɨ",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Зандаларские",
    "confidence": "high",
    "ipa": "zəndɐˈɫarskʲɪjɪ",
    "note": "inflected form, same stress as Зандалара"
  },
  {
    "grapheme": "Атал'ай",
    "confidence": "high",
    "ipa": "ɐtɐˈɫaj",
    "note": "Атал'ай"
  },
  {
    "grapheme": "Аталаи",
    "confidence": "check",
    "ipa": "ɐtɐˈɫaɪ",
    "note": "not in English lexicon as such: the localization also writes Аталаи without apostrophe (26x); stress on -ла-"
  },
  {
    "grapheme": "Атал'Хаккара",
    "confidence": "high",
    "ipa": "ɐtəɫxɐˈkarə",
    "note": "Атал'Хаккар"
  },
  {
    "grapheme": "Хаккара",
    "confidence": "high",
    "ipa": "xɐˈkarə",
    "note": "Хаккар"
  },
  {
    "grapheme": "Хаккар",
    "confidence": "high",
    "ipa": "xɐˈkar",
    "note": "inflected form, same stress as Хаккара"
  },
  {
    "grapheme": "Хаккару",
    "confidence": "high",
    "ipa": "xɐˈkarʊ",
    "note": "inflected form, same stress as Хаккара"
  },
  {
    "grapheme": "Хаккари",
    "confidence": "high",
    "ipa": "xɐˈkarʲɪ",
    "note": "inflected form, same stress as Хаккара"
  },
  {
    "grapheme": "Джин'до",
    "confidence": "high",
    "ipa": "ˈdʐɨndə",
    "note": "Джин'до"
  },
  {
    "grapheme": "Ун'Горо",
    "confidence": "high",
    "ipa": "ʊnˈɡorə",
    "note": "Ун'Горо"
  },
  {
    "grapheme": "Тельдрассила",
    "confidence": "high",
    "ipa": "tʲɪlʲdrɐˈsʲiɫə",
    "note": "Тельдрассил"
  },
  {
    "grapheme": "Тельдрассил",
    "confidence": "high",
    "ipa": "tʲɪlʲdrɐˈsʲiɫ",
    "note": "inflected form, same stress as Тельдрассила"
  },
  {
    "grapheme": "Тельдрассиле",
    "confidence": "high",
    "ipa": "tʲɪlʲdrɐˈsʲilʲɪ",
    "note": "inflected form, same stress as Тельдрассила"
  },
  {
    "grapheme": "Тельдрассилом",
    "confidence": "high",
    "ipa": "tʲɪlʲdrɐˈsʲiɫəm",
    "note": "inflected form, same stress as Тельдрассила"
  },
  {
    "grapheme": "Дарнасса",
    "confidence": "high",
    "ipa": "dɐrˈnasə",
    "note": "Дарнасс"
  },
  {
    "grapheme": "Дарнассе",
    "confidence": "high",
    "ipa": "dɐrˈnasʲɪ",
    "note": "inflected form, same stress as Дарнасса"
  },
  {
    "grapheme": "Дарнасс",
    "confidence": "high",
    "ipa": "dɐrˈnas",
    "note": "inflected form, same stress as Дарнасса"
  },
  {
    "grapheme": "Дарнассом",
    "confidence": "high",
    "ipa": "dɐrˈnasəm",
    "note": "inflected form, same stress as Дарнасса"
  },
  {
    "grapheme": "Дарнас",
    "confidence": "high",
    "ipa": "dɐrˈnas",
    "note": "localization also spells it Дарнас with one с"
  },
  {
    "grapheme": "Дарнаса",
    "confidence": "high",
    "ipa": "dɐrˈnasə",
    "note": "inflected form, same stress as Дарнас"
  },
  {
    "grapheme": "Дарнасе",
    "confidence": "high",
    "ipa": "dɐrˈnasʲɪ",
    "note": "inflected form, same stress as Дарнас"
  },
  {
    "grapheme": "Дарнасский",
    "confidence": "high",
    "ipa": "dɐrˈnaskʲɪj",
    "note": "inflected form, same stress as Дарнас"
  },
  {
    "grapheme": "Доланааре",
    "confidence": "high",
    "ipa": "dəɫɐˈnarʲɪ",
    "note": "Доланаар, double а read as one vowel"
  },
  {
    "grapheme": "Доланаара",
    "confidence": "high",
    "ipa": "dəɫɐˈnarə",
    "note": "inflected form, same stress as Доланааре"
  },
  {
    "grapheme": "Доланаар",
    "confidence": "high",
    "ipa": "dəɫɐˈnar",
    "note": "inflected form, same stress as Доланааре"
  },
  {
    "grapheme": "Аубердин",
    "confidence": "high",
    "ipa": "ɐʊbʲɪrˈdʲin",
    "note": "Аубердин"
  },
  {
    "grapheme": "Аубердина",
    "confidence": "high",
    "ipa": "ɐʊbʲɪrˈdʲinə",
    "note": "inflected form, same stress as Аубердин"
  },
  {
    "grapheme": "Аубердине",
    "confidence": "high",
    "ipa": "ɐʊbʲɪrˈdʲinʲɪ",
    "note": "inflected form, same stress as Аубердин"
  },
  {
    "grapheme": "Аубердину",
    "confidence": "high",
    "ipa": "ɐʊbʲɪrˈdʲinʊ",
    "note": "inflected form, same stress as Аубердин"
  },
  {
    "grapheme": "Рут'теран",
    "confidence": "check",
    "ipa": "rʊtʲɪˈran",
    "note": "Рут'теран; Russian usage stresses the last syllable (English RU-theran)"
  },
  {
    "grapheme": "Бен'этиль",
    "confidence": "check",
    "ipa": "bʲɪˈnɛtʲɪlʲ",
    "note": "Бен'этиль (localization spells Бен-); English stress on -э-"
  },
  {
    "grapheme": "Тирисфальских",
    "confidence": "high",
    "ipa": "tʲɪrʲɪsˈfalʲskʲɪx",
    "note": "Тирисфаль and тирисфальские"
  },
  {
    "grapheme": "Тирисфаля",
    "confidence": "high",
    "ipa": "tʲɪrʲɪsˈfalʲə",
    "note": "inflected form, same stress as Тирисфальских"
  },
  {
    "grapheme": "Тирисфальские",
    "confidence": "high",
    "ipa": "tʲɪrʲɪsˈfalʲskʲɪjɪ",
    "note": "inflected form, same stress as Тирисфальских"
  },
  {
    "grapheme": "Тирисфале",
    "confidence": "high",
    "ipa": "tʲɪrʲɪsˈfalʲɪ",
    "note": "inflected form, same stress as Тирисфальских"
  },
  {
    "grapheme": "Тирисфаль",
    "confidence": "high",
    "ipa": "tʲɪrʲɪsˈfalʲ",
    "note": "inflected form, same stress as Тирисфальских"
  },
  {
    "grapheme": "Фераласа",
    "confidence": "high",
    "ipa": "fʲɪrɐˈɫasə",
    "note": "Фералас"
  },
  {
    "grapheme": "Фераласе",
    "confidence": "high",
    "ipa": "fʲɪrɐˈɫasʲɪ",
    "note": "inflected form, same stress as Фераласа"
  },
  {
    "grapheme": "Фералас",
    "confidence": "high",
    "ipa": "fʲɪrɐˈɫas",
    "note": "inflected form, same stress as Фераласа"
  },
  {
    "grapheme": "фераласском",
    "confidence": "high",
    "ipa": "fʲɪrɐˈɫaskəm",
    "note": "inflected form, same stress as Фераласа"
  },
  {
    "grapheme": "Фераласу",
    "confidence": "high",
    "ipa": "fʲɪrɐˈɫasʊ",
    "note": "inflected form, same stress as Фераласа"
  },
  {
    "grapheme": "Танарис",
    "confidence": "high",
    "ipa": "tənɐˈrʲis",
    "note": "Танарис"
  },
  {
    "grapheme": "Танариса",
    "confidence": "high",
    "ipa": "tənɐˈrʲisə",
    "note": "inflected form, same stress as Танарис"
  },
  {
    "grapheme": "Танарисе",
    "confidence": "high",
    "ipa": "tənɐˈrʲisʲɪ",
    "note": "inflected form, same stress as Танарис"
  },
  {
    "grapheme": "Танарису",
    "confidence": "high",
    "ipa": "tənɐˈrʲisʊ",
    "note": "inflected form, same stress as Танарис"
  },
  {
    "grapheme": "Ульдаман",
    "confidence": "high",
    "ipa": "ʊlʲdɐˈman",
    "note": "Ульдаман"
  },
  {
    "grapheme": "Ульдамана",
    "confidence": "high",
    "ipa": "ʊlʲdɐˈmanə",
    "note": "inflected form, same stress as Ульдаман"
  },
  {
    "grapheme": "Ульдамане",
    "confidence": "high",
    "ipa": "ʊlʲdɐˈmanʲɪ",
    "note": "inflected form, same stress as Ульдаман"
  },
  {
    "grapheme": "Ульдаманские",
    "confidence": "high",
    "ipa": "ʊlʲdɐˈmanskʲɪjɪ",
    "note": "inflected form, same stress as Ульдаман"
  },
  {
    "grapheme": "Даларана",
    "confidence": "high",
    "ipa": "dəɫɐˈranə",
    "note": "Даларан"
  },
  {
    "grapheme": "Даларан",
    "confidence": "high",
    "ipa": "dəɫɐˈran",
    "note": "inflected form, same stress as Даларана"
  },
  {
    "grapheme": "Даларане",
    "confidence": "high",
    "ipa": "dəɫɐˈranʲɪ",
    "note": "inflected form, same stress as Даларана"
  },
  {
    "grapheme": "даларанский",
    "confidence": "high",
    "ipa": "dəɫɐˈranskʲɪj",
    "note": "inflected form, same stress as Даларана"
  },
  {
    "grapheme": "Даларанских",
    "confidence": "high",
    "ipa": "dəɫɐˈranskʲɪx",
    "note": "inflected form, same stress as Даларана"
  },
  {
    "grapheme": "Альтерака",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakə",
    "note": "Альтерак and альтеракский"
  },
  {
    "grapheme": "Альтеракской",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskəj",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтеракских",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskʲɪx",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтерак",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrak",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтеракскую",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskʊjʊ",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтеракские",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskʲɪjɪ",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтеракского",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskəɡə",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтераке",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakʲɪ",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Альтеракскими",
    "confidence": "high",
    "ipa": "ɐlʲtʲɪˈrakskʲɪmʲɪ",
    "note": "inflected form, same stress as Альтерака"
  },
  {
    "grapheme": "Стромгарда",
    "confidence": "high",
    "ipa": "strɐmˈɡardə",
    "note": "Стромгард"
  },
  {
    "grapheme": "Стромгарде",
    "confidence": "high",
    "ipa": "strɐmˈɡardʲɪ",
    "note": "inflected form, same stress as Стромгарда"
  },
  {
    "grapheme": "Стромгард",
    "confidence": "high",
    "ipa": "strɐmˈɡart",
    "note": "inflected form, same stress as Стромгарда"
  },
  {
    "grapheme": "Стромгардом",
    "confidence": "high",
    "ipa": "strɐmˈɡardəm",
    "note": "inflected form, same stress as Стромгарда"
  },
  {
    "grapheme": "Арати",
    "confidence": "high",
    "ipa": "ɐˈratʲɪ",
    "note": "Арати, indeclinable"
  },
  {
    "grapheme": "Аратора",
    "confidence": "high",
    "ipa": "ɐrɐˈtorə",
    "note": "Аратор"
  },
  {
    "grapheme": "Аратор",
    "confidence": "high",
    "ipa": "ɐrɐˈtor",
    "note": "inflected form, same stress as Аратора"
  },
  {
    "grapheme": "Араторской",
    "confidence": "high",
    "ipa": "ɐrɐˈtorskəj",
    "note": "inflected form, same stress as Аратора"
  },
  {
    "grapheme": "Андорала",
    "confidence": "high",
    "ipa": "ɐndɐˈraɫə",
    "note": "Андорал"
  },
  {
    "grapheme": "Андорал",
    "confidence": "high",
    "ipa": "ɐndɐˈraɫ",
    "note": "inflected form, same stress as Андорала"
  },
  {
    "grapheme": "Андорале",
    "confidence": "high",
    "ipa": "ɐndɐˈralʲɪ",
    "note": "inflected form, same stress as Андорала"
  },
  {
    "grapheme": "Андоралом",
    "confidence": "high",
    "ipa": "ɐndɐˈraɫəm",
    "note": "inflected form, same stress as Андорала"
  },
  {
    "grapheme": "Стратхольм",
    "confidence": "high",
    "ipa": "strɐtˈxolʲm",
    "note": "Стратхольм, т and х pronounced separately"
  },
  {
    "grapheme": "Стратхольма",
    "confidence": "high",
    "ipa": "strɐtˈxolʲmə",
    "note": "inflected form, same stress as Стратхольм"
  },
  {
    "grapheme": "Стратхольме",
    "confidence": "high",
    "ipa": "strɐtˈxolʲmʲɪ",
    "note": "inflected form, same stress as Стратхольм"
  },
  {
    "grapheme": "Караносе",
    "confidence": "high",
    "ipa": "kərɐˈnosʲɪ",
    "note": "Каранос"
  },
  {
    "grapheme": "Караноса",
    "confidence": "high",
    "ipa": "kərɐˈnosə",
    "note": "inflected form, same stress as Караносе"
  },
  {
    "grapheme": "Каранос",
    "confidence": "high",
    "ipa": "kərɐˈnos",
    "note": "inflected form, same stress as Караносе"
  },
  {
    "grapheme": "Морога",
    "confidence": "high",
    "ipa": "mɐˈroɡə",
    "note": "Дун Морог, final г devoiced"
  },
  {
    "grapheme": "Мороге",
    "confidence": "high",
    "ipa": "mɐˈroɡʲɪ",
    "note": "inflected form, same stress as Морога"
  },
  {
    "grapheme": "Морог",
    "confidence": "high",
    "ipa": "mɐˈrok",
    "note": "inflected form, same stress as Морога"
  },
  {
    "grapheme": "Морогом",
    "confidence": "high",
    "ipa": "mɐˈroɡəm",
    "note": "inflected form, same stress as Морога"
  },
  {
    "grapheme": "Модана",
    "confidence": "check",
    "ipa": "mɐˈdanə",
    "note": "Лок Модан; Russian players stress the last syllable (English MO-dan)"
  },
  {
    "grapheme": "Модан",
    "confidence": "check",
    "ipa": "mɐˈdan",
    "note": "inflected form, same stress as Модана"
  },
  {
    "grapheme": "Модане",
    "confidence": "check",
    "ipa": "mɐˈdanʲɪ",
    "note": "inflected form, same stress as Модана"
  },
  {
    "grapheme": "Моданом",
    "confidence": "check",
    "ipa": "mɐˈdanəm",
    "note": "inflected form, same stress as Модана"
  },
  {
    "grapheme": "Модану",
    "confidence": "check",
    "ipa": "mɐˈdanʊ",
    "note": "inflected form, same stress as Модана"
  },
  {
    "grapheme": "Элвиннского",
    "confidence": "check",
    "ipa": "ˈɛɫvʲɪnskəɡə",
    "note": "Элвиннский лес; stress contested (Э́лвиннский vs Элви́ннский)"
  },
  {
    "grapheme": "Элвиннском",
    "confidence": "check",
    "ipa": "ˈɛɫvʲɪnskəm",
    "note": "inflected form, same stress as Элвиннского"
  },
  {
    "grapheme": "Элвиннский",
    "confidence": "check",
    "ipa": "ˈɛɫvʲɪnskʲɪj",
    "note": "inflected form, same stress as Элвиннского"
  },
  {
    "grapheme": "Элвиннских",
    "confidence": "check",
    "ipa": "ˈɛɫvʲɪnskʲɪx",
    "note": "inflected form, same stress as Элвиннского"
  },
  {
    "grapheme": "Элвинн",
    "confidence": "check",
    "ipa": "ˈɛɫvʲɪn",
    "note": "inflected form, same stress as Элвиннского"
  },
  {
    "grapheme": "Мулгора",
    "confidence": "high",
    "ipa": "mʊɫˈɡorə",
    "note": "Мулгор"
  },
  {
    "grapheme": "Мулгор",
    "confidence": "high",
    "ipa": "mʊɫˈɡor",
    "note": "inflected form, same stress as Мулгора"
  },
  {
    "grapheme": "Мулгоре",
    "confidence": "high",
    "ipa": "mʊɫˈɡorʲɪ",
    "note": "inflected form, same stress as Мулгора"
  },
  {
    "grapheme": "Дуротара",
    "confidence": "high",
    "ipa": "dʊrɐˈtarə",
    "note": "Дуротар"
  },
  {
    "grapheme": "Дуротар",
    "confidence": "high",
    "ipa": "dʊrɐˈtar",
    "note": "inflected form, same stress as Дуротара"
  },
  {
    "grapheme": "Дуротаре",
    "confidence": "high",
    "ipa": "dʊrɐˈtarʲɪ",
    "note": "inflected form, same stress as Дуротара"
  },
  {
    "grapheme": "Дуротаром",
    "confidence": "high",
    "ipa": "dʊrɐˈtarəm",
    "note": "inflected form, same stress as Дуротара"
  },
  {
    "grapheme": "Оргриммара",
    "confidence": "high",
    "ipa": "ɐrɡrʲɪˈmarə",
    "note": "Оргриммар"
  },
  {
    "grapheme": "Оргриммар",
    "confidence": "high",
    "ipa": "ɐrɡrʲɪˈmar",
    "note": "inflected form, same stress as Оргриммара"
  },
  {
    "grapheme": "Оргриммаре",
    "confidence": "high",
    "ipa": "ɐrɡrʲɪˈmarʲɪ",
    "note": "inflected form, same stress as Оргриммара"
  },
  {
    "grapheme": "Оргриммаром",
    "confidence": "high",
    "ipa": "ɐrɡrʲɪˈmarəm",
    "note": "inflected form, same stress as Оргриммара"
  },
  {
    "grapheme": "оргриммарской",
    "confidence": "high",
    "ipa": "ɐrɡrʲɪˈmarskəj",
    "note": "inflected form, same stress as Оргриммара"
  },
  {
    "grapheme": "Терамора",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmorə",
    "note": "Терамор"
  },
  {
    "grapheme": "Терамор",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmor",
    "note": "inflected form, same stress as Терамора"
  },
  {
    "grapheme": "Тераморе",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmorʲɪ",
    "note": "inflected form, same stress as Терамора"
  },
  {
    "grapheme": "тераморских",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmorskʲɪx",
    "note": "inflected form, same stress as Терамора"
  },
  {
    "grapheme": "Тераморской",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmorskəj",
    "note": "inflected form, same stress as Терамора"
  },
  {
    "grapheme": "Тераморские",
    "confidence": "high",
    "ipa": "tʲɪrɐˈmorskʲɪjɪ",
    "note": "inflected form, same stress as Терамора"
  },
  {
    "grapheme": "Азшары",
    "confidence": "high",
    "ipa": "ɐsˈʂarɨ",
    "note": "Азшара; с+ш kept as a real sh-cluster"
  },
  {
    "grapheme": "Азшаре",
    "confidence": "high",
    "ipa": "ɐsˈʂarʲɪ",
    "note": "inflected form, same stress as Азшары"
  },
  {
    "grapheme": "Азшара",
    "confidence": "high",
    "ipa": "ɐsˈʂarə",
    "note": "inflected form, same stress as Азшары"
  },
  {
    "grapheme": "Азшару",
    "confidence": "high",
    "ipa": "ɐsˈʂarʊ",
    "note": "inflected form, same stress as Азшары"
  },
  {
    "grapheme": "Азшарой",
    "confidence": "high",
    "ipa": "ɐsˈʂarəj",
    "note": "inflected form, same stress as Азшары"
  },
  {
    "grapheme": "Сен'джин",
    "confidence": "check",
    "ipa": "ˈsʲendʐɨn",
    "note": "Сен'джин; English initial stress kept"
  },
  {
    "grapheme": "Гром'гол",
    "confidence": "check",
    "ipa": "ˈɡromɡəɫ",
    "note": "Гром'гол; English initial stress kept, many say Гром'го́л"
  },
  {
    "grapheme": "Гром'гола",
    "confidence": "check",
    "ipa": "ˈɡromɡəɫə",
    "note": "inflected form, same stress as Гром'гол"
  },
  {
    "grapheme": "Зорамском",
    "confidence": "check",
    "ipa": "ˈzorəmskəm",
    "note": "Зорамское взморье; English ZOR-am kept"
  },
  {
    "grapheme": "Зорамского",
    "confidence": "check",
    "ipa": "ˈzorəmskəɡə",
    "note": "inflected form, same stress as Зорамском"
  },
  {
    "grapheme": "Зорамское",
    "confidence": "check",
    "ipa": "ˈzorəmskəjɪ",
    "note": "inflected form, same stress as Зорамском"
  },
  {
    "grapheme": "Зорам",
    "confidence": "check",
    "ipa": "ˈzorəm",
    "note": "inflected form, same stress as Зорамском"
  },
  {
    "grapheme": "Зорама",
    "confidence": "check",
    "ipa": "ˈzorəmə",
    "note": "inflected form, same stress as Зорамском"
  },
  {
    "grapheme": "Каэр",
    "confidence": "check",
    "ipa": "ˈkaɛr",
    "note": "Каэр Дарроу; two syllables as the Russian spelling suggests"
  },
  {
    "grapheme": "Телcамар",
    "confidence": "high",
    "ipa": "tʲɪɫˈsamər",
    "note": "Телcамар: the localization spells it with a LATIN c inside a Cyrillic word"
  },
  {
    "grapheme": "Телcамара",
    "confidence": "high",
    "ipa": "tʲɪɫˈsamərə",
    "note": "inflected form, same stress as Телcамар"
  },
  {
    "grapheme": "Телcамаре",
    "confidence": "high",
    "ipa": "tʲɪɫˈsamərʲɪ",
    "note": "inflected form, same stress as Телcамар"
  },
  {
    "grapheme": "Телcамарские",
    "confidence": "high",
    "ipa": "tʲɪɫˈsamərskʲɪjɪ",
    "note": "inflected form, same stress as Телcамар"
  },
  {
    "grapheme": "Телсамар",
    "confidence": "high",
    "ipa": "tʲɪɫˈsamər",
    "note": "all-Cyrillic spelling of Телсамар"
  },
  {
    "grapheme": "Сильвана",
    "confidence": "high",
    "ipa": "sʲɪlʲˈvanə",
    "note": "Сильвана"
  },
  {
    "grapheme": "Сильваны",
    "confidence": "high",
    "ipa": "sʲɪlʲˈvanɨ",
    "note": "inflected form, same stress as Сильвана"
  },
  {
    "grapheme": "Сильване",
    "confidence": "high",
    "ipa": "sʲɪlʲˈvanʲɪ",
    "note": "inflected form, same stress as Сильвана"
  },
  {
    "grapheme": "Сильвану",
    "confidence": "high",
    "ipa": "sʲɪlʲˈvanʊ",
    "note": "inflected form, same stress as Сильвана"
  },
  {
    "grapheme": "Сильваной",
    "confidence": "high",
    "ipa": "sʲɪlʲˈvanəj",
    "note": "inflected form, same stress as Сильвана"
  },
  {
    "grapheme": "Тиранда",
    "confidence": "high",
    "ipa": "tʲɪˈrandə",
    "note": "Тиранда"
  },
  {
    "grapheme": "Тирандой",
    "confidence": "high",
    "ipa": "tʲɪˈrandəj",
    "note": "inflected form, same stress as Тиранда"
  },
  {
    "grapheme": "Тиранду",
    "confidence": "high",
    "ipa": "tʲɪˈrandʊ",
    "note": "inflected form, same stress as Тиранда"
  },
  {
    "grapheme": "Тиранды",
    "confidence": "high",
    "ipa": "tʲɪˈrandɨ",
    "note": "inflected form, same stress as Тиранда"
  },
  {
    "grapheme": "Кенария",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪjə",
    "note": "Кенарий / Круг Кенария"
  },
  {
    "grapheme": "Кенарийских",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪjskʲɪx",
    "note": "inflected form, same stress as Кенария"
  },
  {
    "grapheme": "Кенарий",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪj",
    "note": "inflected form, same stress as Кенария"
  },
  {
    "grapheme": "Кенарийского",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪjskəɡə",
    "note": "inflected form, same stress as Кенария"
  },
  {
    "grapheme": "Кенарийский",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪjskʲɪj",
    "note": "inflected form, same stress as Кенария"
  },
  {
    "grapheme": "Кенариуса",
    "confidence": "high",
    "ipa": "kʲɪˈnarʲɪʊsə",
    "note": "inflected form, same stress as Кенария"
  },
  {
    "grapheme": "Ценариона",
    "confidence": "check",
    "ipa": "tsɨˈnarʲɪənə",
    "note": "Ценарион (son of Cenarius in the lore books); stress guessed from English"
  },
  {
    "grapheme": "Ценарион",
    "confidence": "check",
    "ipa": "tsɨˈnarʲɪən",
    "note": "inflected form, same stress as Ценариона"
  },
  {
    "grapheme": "Элуны",
    "confidence": "high",
    "ipa": "ɛˈɫunɨ",
    "note": "Элуна"
  },
  {
    "grapheme": "Элуна",
    "confidence": "high",
    "ipa": "ɛˈɫunə",
    "note": "inflected form, same stress as Элуны"
  },
  {
    "grapheme": "Элуне",
    "confidence": "high",
    "ipa": "ɛˈɫunʲɪ",
    "note": "inflected form, same stress as Элуны"
  },
  {
    "grapheme": "Элуной",
    "confidence": "high",
    "ipa": "ɛˈɫunəj",
    "note": "inflected form, same stress as Элуны"
  },
  {
    "grapheme": "Рагнарос",
    "confidence": "high",
    "ipa": "rəɡnɐˈros",
    "note": "Рагнарос"
  },
  {
    "grapheme": "Рагнароса",
    "confidence": "high",
    "ipa": "rəɡnɐˈrosə",
    "note": "inflected form, same stress as Рагнарос"
  },
  {
    "grapheme": "Рагнаросом",
    "confidence": "high",
    "ipa": "rəɡnɐˈrosəm",
    "note": "inflected form, same stress as Рагнарос"
  },
  {
    "grapheme": "Нефариана",
    "confidence": "check",
    "ipa": "nʲɪfərʲɪˈanə",
    "note": "Нефариан; Russian usage final stress (English ne-FAR-ian)"
  },
  {
    "grapheme": "Нефариан",
    "confidence": "check",
    "ipa": "nʲɪfərʲɪˈan",
    "note": "inflected form, same stress as Нефариана"
  },
  {
    "grapheme": "Утера",
    "confidence": "high",
    "ipa": "ˈutʲɪrə",
    "note": "Утер; note one corpus line has the verb утёр written утер"
  },
  {
    "grapheme": "Утер",
    "confidence": "high",
    "ipa": "ˈutʲɪr",
    "note": "inflected form, same stress as Утера"
  },
  {
    "grapheme": "Болваром",
    "confidence": "check",
    "ipa": "bɐɫˈvarəm",
    "note": "Болвар; Russian usage final stress (English BOL-var)"
  },
  {
    "grapheme": "Болвар",
    "confidence": "check",
    "ipa": "bɐɫˈvar",
    "note": "inflected form, same stress as Болваром"
  },
  {
    "grapheme": "Болвара",
    "confidence": "check",
    "ipa": "bɐɫˈvarə",
    "note": "inflected form, same stress as Болваром"
  },
  {
    "grapheme": "Магни",
    "confidence": "high",
    "ipa": "ˈmaɡnʲɪ",
    "note": "Магни"
  },
  {
    "grapheme": "Меггакрут",
    "confidence": "check",
    "ipa": "mʲɪɡɐˈkrut",
    "note": "Меггакрут (pun on мега+крут), final stress"
  },
  {
    "grapheme": "Медива",
    "confidence": "high",
    "ipa": "mʲɪˈdʲivə",
    "note": "Медив"
  },
  {
    "grapheme": "Медив",
    "confidence": "high",
    "ipa": "mʲɪˈdʲif",
    "note": "inflected form, same stress as Медива"
  },
  {
    "grapheme": "Медиву",
    "confidence": "high",
    "ipa": "mʲɪˈdʲivʊ",
    "note": "inflected form, same stress as Медива"
  },
  {
    "grapheme": "Изера",
    "confidence": "high",
    "ipa": "ɪˈzʲerə",
    "note": "Изера"
  },
  {
    "grapheme": "Изеры",
    "confidence": "high",
    "ipa": "ɪˈzʲerɨ",
    "note": "inflected form, same stress as Изера"
  },
  {
    "grapheme": "Малфурион",
    "confidence": "check",
    "ipa": "mɐɫˈfurʲɪən",
    "note": "Малфурион; English stress kept, Малфурио́н also common"
  },
  {
    "grapheme": "Малфуриона",
    "confidence": "check",
    "ipa": "mɐɫˈfurʲɪənə",
    "note": "inflected form, same stress as Малфурион"
  },
  {
    "grapheme": "Малфуриону",
    "confidence": "check",
    "ipa": "mɐɫˈfurʲɪənʊ",
    "note": "inflected form, same stress as Малфурион"
  },
  {
    "grapheme": "Аругал",
    "confidence": "check",
    "ipa": "ˈarʊɡəɫ",
    "note": "Аругал; English initial stress kept"
  },
  {
    "grapheme": "Аругала",
    "confidence": "check",
    "ipa": "ˈarʊɡəɫə",
    "note": "inflected form, same stress as Аругал"
  },
  {
    "grapheme": "Аругалу",
    "confidence": "check",
    "ipa": "ˈarʊɡəɫʊ",
    "note": "inflected form, same stress as Аругал"
  },
  {
    "grapheme": "Аругалом",
    "confidence": "check",
    "ipa": "ˈarʊɡəɫəm",
    "note": "inflected form, same stress as Аругал"
  },
  {
    "grapheme": "Амненнара",
    "confidence": "check",
    "ipa": "ɐmˈnʲenərə",
    "note": "Амненнар"
  },
  {
    "grapheme": "Амненнар",
    "confidence": "check",
    "ipa": "ɐmˈnʲenər",
    "note": "inflected form, same stress as Амненнара"
  },
  {
    "grapheme": "Чарлга",
    "confidence": "check",
    "ipa": "ˈtɕarɫɡə",
    "note": "Чарлга"
  },
  {
    "grapheme": "Датрохан",
    "confidence": "check",
    "ipa": "ˈdatrəxən",
    "note": "Датрохан"
  },
  {
    "grapheme": "Наралекс",
    "confidence": "check",
    "ipa": "ˈnarəlʲɪks",
    "note": "Наралекс; English initial stress kept"
  },
  {
    "grapheme": "Наралекса",
    "confidence": "check",
    "ipa": "ˈnarəlʲɪksə",
    "note": "inflected form, same stress as Наралекс"
  },
  {
    "grapheme": "Терадрас",
    "confidence": "check",
    "ipa": "tʲɪˈradrəs",
    "note": "Терадрас"
  },
  {
    "grapheme": "Зейтара",
    "confidence": "high",
    "ipa": "ˈzʲejtərə",
    "note": "Зейтар"
  },
  {
    "grapheme": "Зейтар",
    "confidence": "high",
    "ipa": "ˈzʲejtər",
    "note": "inflected form, same stress as Зейтара"
  },
  {
    "grapheme": "Вальтхалака",
    "confidence": "check",
    "ipa": "ˈvalʲtxəɫəkə",
    "note": "Вальтхалак; English initial stress kept, т and х separate"
  },
  {
    "grapheme": "Вальтхалак",
    "confidence": "check",
    "ipa": "ˈvalʲtxəɫək",
    "note": "inflected form, same stress as Вальтхалака"
  },
  {
    "grapheme": "Баровых",
    "confidence": "high",
    "ipa": "ˈbarəvɨx",
    "note": "Баровы/Баровых; initial stress (English BA-rov)"
  },
  {
    "grapheme": "Баров",
    "confidence": "high",
    "ipa": "ˈbarəf",
    "note": "inflected form, same stress as Баровых"
  },
  {
    "grapheme": "Баровы",
    "confidence": "high",
    "ipa": "ˈbarəvɨ",
    "note": "inflected form, same stress as Баровых"
  },
  {
    "grapheme": "Норганнона",
    "confidence": "high",
    "ipa": "nɐrˈɡanənə",
    "note": "Норганнон"
  },
  {
    "grapheme": "Норганнон",
    "confidence": "high",
    "ipa": "nɐrˈɡanən",
    "note": "inflected form, same stress as Норганнона"
  },
  {
    "grapheme": "Агамагган",
    "confidence": "check",
    "ipa": "ɐɡɐˈmaɡən",
    "note": "Агамагган"
  },
  {
    "grapheme": "Аку'май",
    "confidence": "check",
    "ipa": "ˈakʊməj",
    "note": "Аку'май; English initial stress kept, many say Аку'ма́й"
  },
  {
    "grapheme": "Суль-траза",
    "confidence": "check",
    "ipa": "sʊlʲˈtrazə",
    "note": "Суль-траз, hyphenated in the localization"
  },
  {
    "grapheme": "Суль-траз",
    "confidence": "check",
    "ipa": "sʊlʲˈtras",
    "note": "inflected form, same stress as Суль-траза"
  },
  {
    "grapheme": "Трол'калар",
    "confidence": "high",
    "ipa": "trɐɫˈkaɫər",
    "note": "Трол'калар"
  },
  {
    "grapheme": "Мошару",
    "confidence": "high",
    "ipa": "mɐˈʂarʊ",
    "note": "Мошару (written without apostrophe)"
  },
  {
    "grapheme": "Гри'лек",
    "confidence": "high",
    "ipa": "ˈɡrʲilʲɪk",
    "note": "Гри'лек"
  },
  {
    "grapheme": "Гри'лека",
    "confidence": "high",
    "ipa": "ˈɡrʲilʲɪkə",
    "note": "inflected form, same stress as Гри'лек"
  },
  {
    "grapheme": "Джаммал'ан",
    "confidence": "check",
    "ipa": "dʐɐˈmaɫən",
    "note": "Джаммал'ан"
  },
  {
    "grapheme": "Джаммал'ана",
    "confidence": "check",
    "ipa": "dʐɐˈmaɫənə",
    "note": "inflected form, same stress as Джаммал'ан"
  },
  {
    "grapheme": "Май'Зот",
    "confidence": "high",
    "ipa": "mɐjˈzot",
    "note": "Май'зот"
  },
  {
    "grapheme": "Лар'корви",
    "confidence": "high",
    "ipa": "ɫɐrˈkorvʲɪ",
    "note": "Лар'корви"
  },
  {
    "grapheme": "Мар'алиту",
    "confidence": "high",
    "ipa": "mɐˈralʲɪtʊ",
    "note": "Мар'алит"
  },
  {
    "grapheme": "Мар'алит",
    "confidence": "high",
    "ipa": "mɐˈralʲɪt",
    "note": "inflected form, same stress as Мар'алиту"
  },
  {
    "grapheme": "Мор'зул",
    "confidence": "high",
    "ipa": "mɐrˈzuɫ",
    "note": "Мор'зул"
  },
  {
    "grapheme": "Гор'муля",
    "confidence": "check",
    "ipa": "ɡɐrˈmulʲə",
    "note": "Гор'муль"
  },
  {
    "grapheme": "Гор'муль",
    "confidence": "check",
    "ipa": "ɡɐrˈmulʲ",
    "note": "inflected form, same stress as Гор'муля"
  },
  {
    "grapheme": "Рин'джи",
    "confidence": "high",
    "ipa": "ˈrʲindʐɨ",
    "note": "Рин'джи"
  },
  {
    "grapheme": "Зандо'зан",
    "confidence": "high",
    "ipa": "ˈzandəzən",
    "note": "Зандо'зан"
  },
  {
    "grapheme": "Бат'ра",
    "confidence": "high",
    "ipa": "ˈbatrə",
    "note": "Бат'ра"
  },
  {
    "grapheme": "Джен'шан",
    "confidence": "high",
    "ipa": "ˈdʐenʂən",
    "note": "Джен'шан"
  },
  {
    "grapheme": "Э'ко",
    "confidence": "high",
    "ipa": "ˈɛkə",
    "note": "Э'ко"
  },
  {
    "grapheme": "Пеле'кейки",
    "confidence": "high",
    "ipa": "pʲɪlʲɪˈkʲejkʲɪ",
    "note": "Пеле'кейки"
  },
  {
    "grapheme": "Пелекейки",
    "confidence": "high",
    "ipa": "pʲɪlʲɪˈkʲejkʲɪ",
    "note": "spelling without apostrophe also in corpus"
  },
  {
    "grapheme": "Мау'ари",
    "confidence": "high",
    "ipa": "məʊˈarʲɪ",
    "note": "Мау'ари"
  },
  {
    "grapheme": "Тром'ка",
    "confidence": "check",
    "ipa": "ˈtromkə",
    "note": "Тром'ка, orcish greeting"
  },
  {
    "grapheme": "Регал",
    "confidence": "check",
    "ipa": "ˈrʲeɡəɫ",
    "note": "улей Регал; English stress on RE- kept"
  },
  {
    "grapheme": "Зора",
    "confidence": "high",
    "ipa": "ˈzorə",
    "note": "улей Зора"
  },
  {
    "grapheme": "Аши",
    "confidence": "high",
    "ipa": "ˈaʂɨ",
    "note": "улей Аши"
  },
  {
    "grapheme": "мурлоки",
    "confidence": "check",
    "ipa": "mʊrˈɫokʲɪ",
    "note": "мурлоки; Russian players mostly stress -ло́-"
  },
  {
    "grapheme": "мурлоков",
    "confidence": "check",
    "ipa": "mʊrˈɫokəf",
    "note": "inflected form, same stress as мурлоки"
  },
  {
    "grapheme": "мурлока",
    "confidence": "check",
    "ipa": "mʊrˈɫokə",
    "note": "inflected form, same stress as мурлоки"
  },
  {
    "grapheme": "мурлоками",
    "confidence": "check",
    "ipa": "mʊrˈɫokəmʲɪ",
    "note": "inflected form, same stress as мурлоки"
  },
  {
    "grapheme": "мурлок",
    "confidence": "check",
    "ipa": "mʊrˈɫok",
    "note": "inflected form, same stress as мурлоки"
  },
  {
    "grapheme": "мурлокам",
    "confidence": "check",
    "ipa": "mʊrˈɫokəm",
    "note": "inflected form, same stress as мурлоки"
  },
  {
    "grapheme": "фурболги",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡʲɪ",
    "note": "фурболги"
  },
  {
    "grapheme": "фурболгов",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡəf",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "фурболга",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡə",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "фурболг",
    "confidence": "check",
    "ipa": "fʊrˈboɫk",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "фурболгам",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡəm",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "фурболгах",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡəx",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "фурболгами",
    "confidence": "check",
    "ipa": "fʊrˈboɫɡəmʲɪ",
    "note": "inflected form, same stress as фурболги"
  },
  {
    "grapheme": "кодо",
    "confidence": "high",
    "ipa": "ˈkodə",
    "note": "кодо, indeclinable"
  },
  {
    "grapheme": "таурены",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnɨ",
    "note": "таурены; stress contested (та́урены vs тауре́ны)"
  },
  {
    "grapheme": "тауренов",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnəf",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "таурена",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnə",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "тауренами",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnəmʲɪ",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "таурен",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪn",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "таурену",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnʊ",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "тауренам",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnəm",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "тауреном",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnəm",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "тауренский",
    "confidence": "check",
    "ipa": "ˈtaʊrʲɪnskʲɪj",
    "note": "inflected form, same stress as таурены"
  },
  {
    "grapheme": "воргенов",
    "confidence": "high",
    "ipa": "ˈvorɡʲɪnəf",
    "note": "воргены, hard г"
  },
  {
    "grapheme": "воргены",
    "confidence": "high",
    "ipa": "ˈvorɡʲɪnɨ",
    "note": "inflected form, same stress as воргенов"
  },
  {
    "grapheme": "воргенах",
    "confidence": "high",
    "ipa": "ˈvorɡʲɪnəx",
    "note": "inflected form, same stress as воргенов"
  },
  {
    "grapheme": "ворген",
    "confidence": "high",
    "ipa": "ˈvorɡʲɪn",
    "note": "inflected form, same stress as воргенов"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "o.oˈiks",
    "note": "not Cyrillic: the corpus keeps Latin OOX twice; read as Russian letter names"
  },
  {
    "grapheme": "Дарроу",
    "confidence": "check",
    "ipa": "ˈdarəʊ",
    "note": "not in English lexicon: Каэр Дарроу/Дарроушир, -оу is a trap for Russian letter-to-sound"
  },
  {
    "grapheme": "Дарроушира",
    "confidence": "check",
    "ipa": "dərəʊˈʂɨrə",
    "note": "not in English lexicon: Дарроушир (Darrowshire)"
  },
  {
    "grapheme": "Дарроушир",
    "confidence": "check",
    "ipa": "dərəʊˈʂɨr",
    "note": "inflected form, same stress as Дарроушира"
  },
  {
    "grapheme": "Дарроушире",
    "confidence": "check",
    "ipa": "dərəʊˈʂɨrʲɪ",
    "note": "inflected form, same stress as Дарроушира"
  },
  {
    "grapheme": "Дарроумир",
    "confidence": "check",
    "ipa": "dərəʊˈmʲir",
    "note": "not in English lexicon: Дарроумир (Darrowmere)"
  },
  {
    "grapheme": "Гордунни",
    "confidence": "check",
    "ipa": "ɡɐrˈdunʲɪ",
    "note": "not in English lexicon: Гордунни ogres, invented name with unclear stress"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- koKR: 13 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('koKR', $lexicon$[
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "o.o.ek.sɯ",
    "note": "Latin robot-chicken code kept untranslated (OOX-17/TN etc.); read letter by letter as 오오엑스, not as a word"
  },
  {
    "grapheme": "SI",
    "confidence": "check",
    "ipa": "e.sɯ.a.i",
    "note": "not in English lexicon: SI:7 kept in Latin; letter names 에스아이, not the syllable 시"
  },
  {
    "grapheme": "Metz",
    "confidence": "check",
    "ipa": "me.tɕʰɯ",
    "note": "not in English lexicon: untranslated Latin name in a Korean signature line; Korean reading 메츠"
  },
  {
    "grapheme": "II",
    "confidence": "check",
    "ipa": "i",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (2)"
  },
  {
    "grapheme": "III",
    "confidence": "check",
    "ipa": "sam",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (3)"
  },
  {
    "grapheme": "IV",
    "confidence": "check",
    "ipa": "sa",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (4)"
  },
  {
    "grapheme": "V",
    "confidence": "check",
    "ipa": "o",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (5)"
  },
  {
    "grapheme": "VI",
    "confidence": "check",
    "ipa": "juk",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (6)"
  },
  {
    "grapheme": "VII",
    "confidence": "check",
    "ipa": "tɕʰil",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (7)"
  },
  {
    "grapheme": "VIII",
    "confidence": "check",
    "ipa": "pʰal",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (8)"
  },
  {
    "grapheme": "IX",
    "confidence": "check",
    "ipa": "ku",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (9)"
  },
  {
    "grapheme": "XI",
    "confidence": "check",
    "ipa": "ɕi.bil",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (11)"
  },
  {
    "grapheme": "XII",
    "confidence": "check",
    "ipa": "ɕi.bi",
    "note": "not in English lexicon: Roman numeral in quest titles (임무 지령 N); read as Sino-Korean number, not as letters (12)"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- zhCN: 8 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('zhCN', $lexicon$[
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ou˥.ou˥.ai˥˩.kʰɤ˥˩.sɹ̩˥",
    "note": "Latin name left untranslated (OOX-17/TN etc.); spelled as letters the way Chinese readers say them (ou ou ai-ke-si)"
  },
  {
    "grapheme": "塞纳里奥",
    "confidence": "high",
    "ipa": "sai˥˩.na˥˩.li˨˩.au˥˩",
    "note": "Cenarion; polyphonic 塞 must be sai4 (transliteration), not sai1/se4"
  },
  {
    "grapheme": "塞纳留斯",
    "confidence": "high",
    "ipa": "sai˥˩.na˥˩.ljou˧˥.sɹ̩˥",
    "note": "Cenarius; 塞 = sai4"
  },
  {
    "grapheme": "塞拉摩",
    "confidence": "high",
    "ipa": "sai˥˩.la˥.muo˧˥",
    "note": "Theramore; 塞 = sai4"
  },
  {
    "grapheme": "塞尔萨玛",
    "confidence": "high",
    "ipa": "sai˥˩.ɚ˨˩.sa˥˩.ma˨˩˦",
    "note": "Thelsamar; 塞 = sai4"
  },
  {
    "grapheme": "血蹄",
    "confidence": "high",
    "ipa": "ɕɥɛ˥˩.tʰi˧˥",
    "note": "Bloodhoof; literary xue4, not colloquial xie3"
  },
  {
    "grapheme": "风行者",
    "confidence": "high",
    "ipa": "fɤŋ˥.ɕiŋ˧˥.ʈʂɤ˨˩˦",
    "note": "Windrunner (Sylvanas); 行 = xing2, not hang2"
  },
  {
    "grapheme": "石爪",
    "confidence": "check",
    "ipa": "ʂɻ̩˧˥.ʈʂau˨˩˦",
    "note": "not in English lexicon: Stonetalon; 爪 literary zhao3 vs colloquial zhua3, both heard"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;

-- zhTW: 12 entries
insert into "pronunciation_lexicon_locale" ("lang", "entries")
values ('zhTW', $lexicon$[
  {
    "grapheme": "塞納里奧",
    "confidence": "high",
    "ipa": "saɪ˥˩na˥˩li˨˩aʊ˥˩",
    "note": "Cenarion; 塞 must be sài (transliteration reading), not sāi 'to stuff' or sè"
  },
  {
    "grapheme": "塞納裡奧",
    "confidence": "high",
    "ipa": "saɪ˥˩na˥˩li˨˩aʊ˥˩",
    "note": "Cenarion, variant spelling with 裡; 塞 = sài"
  },
  {
    "grapheme": "塞納留斯",
    "confidence": "high",
    "ipa": "saɪ˥˩na˥˩ljoʊ˧˥sɨ˥",
    "note": "Cenarius; 塞 = sài"
  },
  {
    "grapheme": "塞拉摩",
    "confidence": "high",
    "ipa": "saɪ˥˩la˥mwo˧˥",
    "note": "Theramore; 塞 = sài"
  },
  {
    "grapheme": "塞爾薩瑪",
    "confidence": "high",
    "ipa": "saɪ˥˩ɚ˨˩sa˥˩ma˨˩˦",
    "note": "Thelsamar; 塞 = sài"
  },
  {
    "grapheme": "古拉巴什",
    "confidence": "high",
    "ipa": "ku˨˩la˥pa˥ʂɻ̩˧˥",
    "note": "not in English lexicon: Gurubashi; 什 = shí, not shén as in 什麼"
  },
  {
    "grapheme": "亞什",
    "confidence": "high",
    "ipa": "ja˥˩ʂɻ̩˧˥",
    "note": "Hive'Ashi (English grapheme Hive'Ashi); 什 = shí, not shén"
  },
  {
    "grapheme": "沃姆什",
    "confidence": "check",
    "ipa": "wo˥˩mu˨˩ʂɻ̩˧˥",
    "note": "not in English lexicon: Omosh; 什 = shí"
  },
  {
    "grapheme": "哈繆爾",
    "confidence": "check",
    "ipa": "xa˥mjoʊ˥˩ɚ˨˩˦",
    "note": "not in English lexicon: Hamuul Runetotem; 繆 read miù (vs miào/móu), matching zhCN 哈缪尔"
  },
  {
    "grapheme": "山繆森",
    "confidence": "check",
    "ipa": "ʂan˥mjoʊ˥˩sən˥",
    "note": "not in English lexicon: Samuelson; 繆 read miù"
  },
  {
    "grapheme": "納伽茲",
    "confidence": "check",
    "ipa": "na˥˩ka˥tsɨ˥",
    "note": "not in English lexicon: Nagaz; 伽 read gā for the G sound; Taiwan readers may default to jiā or qié"
  },
  {
    "grapheme": "OOX",
    "confidence": "check",
    "ipa": "ˌoʊˌoʊˈɛks",
    "note": "untranslated Latin robot model (OOX-17/TN etc.); spell the letters out, O-O-X"
  }
]$lexicon$::jsonb)
on conflict ("lang") do nothing;
