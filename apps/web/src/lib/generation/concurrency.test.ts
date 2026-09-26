import { describe, expect, it } from "vitest";

import { POOL_MAX } from "@/lib/db";

import {
  afterRateLimit,
  budgetFor,
  clampToPool,
  COOL_DOWN_MS,
  DEFAULT_MAX_ACTIVE,
  familyOf,
  LaneLoad,
  maxActiveFrom,
  POOL_RESERVE,
  pickLane,
  tierLimit,
} from "./concurrency";

describe("familyOf", () => {
  it("puts flash models in the flash family", () => {
    expect(familyOf("eleven_flash_v2_5")).toBe("flash");
  });

  // The docs name only flash in the higher column. Guessing high costs a wave of 429s;
  // guessing low costs nothing but time, so turbo sits with the standard models.
  it("keeps turbo and multilingual in the standard family", () => {
    expect(familyOf("eleven_turbo_v2_5")).toBe("standard");
    expect(familyOf("eleven_multilingual_v2")).toBe("standard");
    expect(familyOf("eleven_v3")).toBe("standard");
  });
});

describe("tierLimit", () => {
  it("matches the published table", () => {
    expect(tierLimit("free", "standard")).toBe(2);
    expect(tierLimit("starter", "standard")).toBe(3);
    expect(tierLimit("creator", "standard")).toBe(5);
    expect(tierLimit("pro", "standard")).toBe(10);
    expect(tierLimit("scale", "standard")).toBe(15);
    expect(tierLimit("business", "standard")).toBe(15);

    expect(tierLimit("free", "flash")).toBe(4);
    expect(tierLimit("starter", "flash")).toBe(6);
    expect(tierLimit("creator", "flash")).toBe(10);
    expect(tierLimit("pro", "flash")).toBe(20);
    expect(tierLimit("scale", "flash")).toBe(30);
    expect(tierLimit("business", "flash")).toBe(30);
  });

  it("reads the tier case-insensitively, since it is upstream text", () => {
    expect(tierLimit("Creator", "standard")).toBe(5);
  });

  it("treats enterprise as business, because 'elevated' is not a number", () => {
    expect(tierLimit("enterprise", "flash")).toBe(30);
  });

  it("falls back to the smallest limit for an unknown or absent tier", () => {
    expect(tierLimit("something_new", "flash")).toBe(2);
    expect(tierLimit(null, "flash")).toBe(2);
  });
});

describe("budgetFor", () => {
  // One slot stays free so the single-line Regenerate button and the pronunciation previews
  // on /lexicon are not starved by a running batch.
  it("reserves a slot for interactive work", () => {
    expect(budgetFor("pro", "eleven_multilingual_v2")).toBe(9);
    expect(budgetFor("scale", "eleven_flash_v2_5")).toBe(29);
  });

  it("never drops below one, so a batch always makes progress", () => {
    expect(budgetFor("free", "eleven_multilingual_v2")).toBe(1);
    expect(budgetFor(null, "eleven_multilingual_v2")).toBe(1);
  });
});

describe("clampToPool", () => {
  it("reduces a large tier's budget to what the pool can serve", () => {
    // scale on a flash model is 29, which would want 58 connections. Two per job in flight,
    // less the reserve, is the most the pool can hand out without deadlocking on itself.
    expect(clampToPool(29, 30)).toBe(12);
    expect(clampToPool(29, 30)).toBeLessThan(budgetFor("scale", "eleven_flash_v2_5"));
  });

  it("leaves a budget the pool can already serve alone", () => {
    expect(clampToPool(3, 30)).toBe(3);
  });

  it("never drops below one, however small the pool", () => {
    expect(clampToPool(9, POOL_RESERVE)).toBe(1);
  });

  it("keeps the configured pool able to serve the budget it allows", () => {
    // The pairing that matters in production: whatever POOL_MAX and POOL_RESERVE are, the
    // clamped budget must still fit in the pool alongside the reserve.
    const largest = clampToPool(Number.MAX_SAFE_INTEGER, POOL_MAX);
    expect(largest * 2 + POOL_RESERVE).toBeLessThanOrEqual(POOL_MAX);
  });
});

describe("afterRateLimit", () => {
  it("leaves the budget alone when nothing has been rate limited", () => {
    expect(afterRateLimit(10, null, 1_000)).toBe(10);
  });

  it("halves the budget for the cool-down after a 429", () => {
    expect(afterRateLimit(10, 1_000, 1_000)).toBe(5);
    expect(afterRateLimit(9, 1_000, 1_000)).toBe(4);
  });

  it("never halves below one", () => {
    expect(afterRateLimit(1, 1_000, 1_000)).toBe(1);
  });

  it("returns to the derived budget once the cool-down expires", () => {
    expect(afterRateLimit(10, 1_000, 1_000 + COOL_DOWN_MS + 1)).toBe(10);
  });
});

describe("pickLane", () => {
  /** Run pickLane to exhaustion the way pump() does, and report where the slots went. */
  function fill(widths: Record<string, number>, cap: number): Record<string, number> {
    const lanes: LaneLoad[] = Object.entries(widths).map(([key, width]) => ({ key, running: 0, width }));
    let inFlight = 0;
    for (let key = pickLane(lanes, inFlight, cap); key; key = pickLane(lanes, inFlight, cap)) {
      lanes.find((lane) => lane.key === key)!.running += 1;
      inFlight += 1;
    }
    return Object.fromEntries(lanes.map((lane) => [lane.key, lane.running]));
  }

  it("shares the cap evenly between lanes that could each use more", () => {
    expect(fill({ a: 9, b: 9, c: 9 }, 12)).toEqual({ a: 4, b: 4, c: 4 });
  });

  it("leaves slots empty rather than push a lane past its own width", () => {
    expect(fill({ a: 4 }, 12)).toEqual({ a: 4 });
  });

  it("fills narrow lanes to their width and gives the rest to the wide one", () => {
    expect(fill({ a: 1, b: 2, c: 20 }, 12)).toEqual({ a: 1, b: 2, c: 9 });
  });

  it("prefers the lane least full for its width, and the earlier one on a tie", () => {
    const lanes: LaneLoad[] = [
      { key: "a", running: 1, width: 2 },
      { key: "b", running: 1, width: 4 },
      { key: "c", running: 1, width: 4 },
    ];
    expect(pickLane(lanes, 3, 12)).toBe("b");
  });

  it("returns null at the cap, and when every lane is full", () => {
    expect(pickLane([{ key: "a", running: 0, width: 4 }], 12, 12)).toBeNull();
    expect(pickLane([{ key: "a", running: 4, width: 4 }], 4, 12)).toBeNull();
    expect(pickLane([], 0, 12)).toBeNull();
  });
});

describe("maxActiveFrom", () => {
  it("reads a positive integer", () => {
    expect(maxActiveFrom("1")).toBe(1);
    expect(maxActiveFrom(" 5 ")).toBe(5);
  });

  it("falls back to the default for anything else", () => {
    for (const raw of [undefined, "", "0", "-1", "2.5", "abc", "3x"]) {
      expect(maxActiveFrom(raw)).toBe(DEFAULT_MAX_ACTIVE);
    }
    expect(DEFAULT_MAX_ACTIVE).toBe(3);
  });
});
