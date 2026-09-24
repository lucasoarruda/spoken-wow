import { describe, expect, it, vi } from "vitest";

vi.mock("server-only", () => ({}));

const { fishRules } = await import("../fish-lexicon");
const { fishLexiconVersion } = await import("./fish");
import type { LexiconEntry } from "../lexicon";

const ENTRIES: LexiconEntry[] = [
  { grapheme: "Thrall", ipa: "θɹɔl", confidence: "high" },
  { grapheme: "Gnomeregan", alias: "nomeregan", confidence: "high" },
];

describe("the lexicon version a fish.audio take records", () => {
  it("is nothing when no rule applied", () => {
    expect(fishLexiconVersion([])).toBeNull();
  });

  it("moves with the rules fish.audio uses, not with the ones it ignores", () => {
    const english = fishLexiconVersion(fishRules(ENTRIES, "enUS"));
    const german = fishLexiconVersion(fishRules(ENTRIES, "deDE"));
    const germanWithMoreIpa = fishLexiconVersion(
      fishRules([...ENTRIES, { grapheme: "Arthas", ipa: "ˈɑɹθəs", confidence: "high" }], "deDE"),
    );
    expect(english).toMatch(/^fish:[0-9a-f]{16}$/);
    expect(german).not.toBe(english);
    expect(germanWithMoreIpa).toBe(german);
  });
});
