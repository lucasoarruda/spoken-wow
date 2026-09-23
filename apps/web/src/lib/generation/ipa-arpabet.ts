/**
 * English IPA, as the lexicon holds it, to the CMU ARPAbet fish.audio's phoneme tags take.
 *
 * fish.audio does not read IPA at all ("IPA is not supported for English phoneme tags",
 * docs.fish.audio), and ARPAbet is what its English phoneme control was trained on. The
 * lexicon stays IPA because ElevenLabs reads that, so this converts on the way out rather
 * than asking anybody to keep two pronunciations of every name in step.
 *
 * Covers the General American inventory the seeded lexicon is written in, plus the few
 * British vowels that turn up in it. A symbol outside that makes the whole entry null
 * rather than a guess: a name spoken without its rule is merely unhelped, while one spoken
 * from a half-converted rule is wrong in a way nobody asked for.
 */

/** Longest first, so a diphthong or an affricate is never read as its two halves. */
const MULTI: [string, string][] = [
  ["eɪ", "EY"],
  ["aɪ", "AY"],
  ["ɔɪ", "OY"],
  ["oʊ", "OW"],
  ["əʊ", "OW"],
  ["aʊ", "AW"],
  ["tʃ", "CH"],
  ["dʒ", "JH"],
  ["ɜɹ", "ER"],
  ["ɝ", "ER"],
  ["ɚ", "ER"],
];

const VOWELS: Record<string, string> = {
  i: "IY",
  ɪ: "IH",
  e: "EY",
  ɛ: "EH",
  æ: "AE",
  a: "AA",
  ɑ: "AA",
  ɒ: "AA",
  ɔ: "AO",
  o: "OW",
  ʊ: "UH",
  u: "UW",
  ʌ: "AH",
  ə: "AH",
  ɜ: "ER",
};

const CONSONANTS: Record<string, string> = {
  b: "B",
  d: "D",
  f: "F",
  ɡ: "G",
  g: "G",
  h: "HH",
  j: "Y",
  k: "K",
  l: "L",
  m: "M",
  n: "N",
  ŋ: "NG",
  p: "P",
  ɹ: "R",
  r: "R",
  s: "S",
  ʃ: "SH",
  t: "T",
  θ: "TH",
  ð: "DH",
  v: "V",
  w: "W",
  z: "Z",
  ʒ: "ZH",
};

/** ARPAbet vowels, which carry a stress digit; consonants never do. */
const ARPA_VOWELS = new Set([...Object.values(VOWELS), "EY", "AY", "OY", "OW", "AW", "ER"]);

/**
 * Marks that mean nothing to ARPAbet: syllable breaks, and length, which is a property of
 * the vowel ARPAbet already names.
 */
const IGNORED = new Set([".", "ː", "ˑ"]);

type Phone = { arpa: string; stress: 0 | 1 | 2 | null };

export function ipaToArpabet(ipa: string): string | null {
  const phones: Phone[] = [];
  let pending: 1 | 2 | null = null;
  let i = 0;

  while (i < ipa.length) {
    const ch = ipa[i];
    if (ch === "ˈ" || ch === "ˌ") {
      // The mark opens a syllable; its stress belongs to that syllable's vowel, which may be
      // a consonant or two further on.
      pending = ch === "ˈ" ? 1 : 2;
      i += 1;
      continue;
    }
    if (IGNORED.has(ch)) {
      i += 1;
      continue;
    }

    const multi = MULTI.find(([symbol]) => ipa.startsWith(symbol, i));
    // "əɹ" is ER before a consonant or at the end ("Ruthoran"), but a schwa and an R when
    // a vowel follows and takes the R as its onset ("Azeroth").
    const schwaR = ipa.startsWith("əɹ", i) && !startsVowel(ipa, i + 2);
    const arpa = schwaR ? "ER" : (multi?.[1] ?? VOWELS[ch] ?? CONSONANTS[ch]);
    if (!arpa) return null;

    const vowel = ARPA_VOWELS.has(arpa);
    phones.push({ arpa, stress: vowel ? pending ?? 0 : null });
    if (vowel) pending = null;
    i += schwaR ? 2 : (multi?.[0].length ?? 1);
  }

  const vowels = phones.filter((phone) => phone.stress !== null);
  if (vowels.length === 0) return null;
  // One syllable and no mark is stressed, as CMUdict writes every monosyllable: "θɹɔl" is
  // TH R AO1 L, not AO0.
  if (vowels.length === 1 && !/[ˈˌ]/.test(ipa)) vowels[0].stress = 1;

  return phones
    .map((phone) => (phone.stress === null ? phone.arpa : `${phone.arpa}${phone.stress}`))
    .join(" ");
}

function startsVowel(ipa: string, at: number): boolean {
  const next = ipa.slice(at).replace(/^[ˈˌ.]+/, "");
  return next !== "" && (next[0] in VOWELS || MULTI.some(([symbol, arpa]) => next.startsWith(symbol) && ARPA_VOWELS.has(arpa)));
}
