import fs from "node:fs";
import path from "node:path";

import { describe, expect, it } from "vitest";

import { ipaToArpabet } from "./ipa-arpabet";

describe("IPA to ARPAbet", () => {
  it.each([
    // A monosyllable with no mark is stressed, as CMUdict writes one.
    ["θɹɔl", "TH R AO1 L"],
    ["ˈnoʊmɹəɡæn", "N OW1 M R AH0 G AE0 N"],
    // The stress mark opens the syllable; the digit lands on its vowel.
    ["kɛlˈθuzæd", "K EH0 L TH UW1 Z AE0 D"],
    ["ˌæɡəˈmæɡən", "AE2 G AH0 M AE1 G AH0 N"],
    // A schwa before an R that a vowel takes as its onset stays a schwa and an R...
    ["ˈæzəɹɒθ", "AE1 Z AH0 R AA0 TH"],
    // ...and before a consonant, or at the end, is the r-coloured ER.
    ["ˈɔbəɹdin", "AO1 B ER0 D IY0 N"],
    ["ˈjuθəɹ", "Y UW1 TH ER0"],
    ["ˈmɜɹlɒk", "M ER1 L AA0 K"],
    // Affricates and diphthongs are one phone, not two.
    ["ˈdʒɪndoʊ", "JH IH1 N D OW0"],
    ["ˈtʃɑɹlɡə", "CH AA1 R L G AH0"],
    ["kɹaʊl", "K R AW1 L"],
    // Length and syllable breaks mean nothing to ARPAbet.
    ["ˈθɹɔː.l", "TH R AO1 L"],
  ])("%s is %s", (ipa, arpabet) => {
    expect(ipaToArpabet(ipa)).toBe(arpabet);
  });

  it("refuses a symbol it cannot map, rather than guessing", () => {
    // A velar fricative: "loch" in Scots, which General American has no phone for.
    expect(ipaToArpabet("lɔx")).toBeNull();
  });

  it("refuses something with no vowel, which could not be spoken", () => {
    expect(ipaToArpabet("ˈθ")).toBeNull();
  });

  it("converts every entry the lexicon was seeded with", () => {
    const seed = fs.readFileSync(
      path.resolve(__dirname, "../../../migrations/0008_seed_pronunciation_lexicon.sql"),
      "utf8",
    );
    const ipas = [...seed.matchAll(/"ipa":\s*"([^"]+)"/g)].map((match) => match[1]);
    expect(ipas.length).toBeGreaterThan(100);
    expect(ipas.filter((ipa) => ipaToArpabet(ipa) === null)).toEqual([]);
  });
});
