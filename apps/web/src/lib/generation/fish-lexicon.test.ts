import { describe, expect, it } from "vitest";

import { applyFishLexicon, fishRules, fishUse } from "./fish-lexicon";
import type { LexiconEntry } from "./lexicon";

const ENTRIES: LexiconEntry[] = [
  { grapheme: "Thrall", ipa: "θɹɔl", confidence: "high" },
  { grapheme: "Caer", ipa: "kɑɹ", confidence: "high" },
  { grapheme: "Hakkar", ipa: "ˈhækɑɹ", confidence: "high" },
  { grapheme: "Atal'Hakkar", ipa: "ɑtəlˈhækɑɹ", confidence: "high" },
  { grapheme: "Thuzad", alias: "thoozad", confidence: "check" },
  { grapheme: "Gnomeregan", alias: "nomeregan", confidence: "high" },
  { grapheme: "Loch", ipa: "lɔx", confidence: "check" },
];

const phoneme = (arpabet: string) => `<|phoneme_start|>${arpabet}<|phoneme_end|>`;

describe("English", () => {
  const rules = fishRules(ENTRIES, "enUS");
  const apply = (text: string) => applyFishLexicon(text, rules);

  it("speaks IPA as an ARPAbet phoneme tag, and a respelling as written", () => {
    expect(apply("Thrall waits in Gnomeregan.")).toBe(
      `${phoneme("TH R AO1 L")} waits in nomeregan.`,
    );
  });

  it("matches whole words only", () => {
    expect(apply("Caer Darrow, not Caern.")).toBe(`${phoneme("K AA1 R")} Darrow, not Caern.`);
  });

  it("treats an apostrophe as part of a name, except in a possessive", () => {
    expect(apply("Kel'Thuzad")).toBe("Kel'Thuzad");
    expect(apply("Thrall's axe")).toBe(`${phoneme("TH R AO1 L")}'s axe`);
  });

  it("prefers the longest name, and never rewrites a replacement", () => {
    expect(apply("Atal'Hakkar and Hakkar")).toBe(
      `${phoneme("AA0 T AH0 L HH AE1 K AA0 R")} and ${phoneme("HH AE1 K AA0 R")}`,
    );
  });

  it("ignores case, as the lexicon's rules do", () => {
    expect(apply("THRALL!")).toBe(`${phoneme("TH R AO1 L")}!`);
  });

  it("skips an entry whose IPA will not convert", () => {
    expect(apply("Loch Modan")).toBe("Loch Modan");
    expect(fishUse(ENTRIES[6], "enUS")).toBe("unused");
  });
});

describe("another language", () => {
  const rules = fishRules(ENTRIES, "deDE");

  it("uses respellings only: fish.audio has no phoneme format for it", () => {
    expect(applyFishLexicon("Thrall grüßt Gnomeregan.", rules)).toBe("Thrall grüßt nomeregan.");
    expect(fishUse(ENTRIES[0], "deDE")).toBe("unused");
    expect(fishUse(ENTRIES[5], "deDE")).toBe("respelling");
  });
});
