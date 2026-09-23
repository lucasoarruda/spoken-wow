/**
 * A collaborator's generator choice, against the real table it lives in.
 */
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";

vi.mock("server-only", () => ({}));

const { closeDb, db } = await import("@/lib/db");
const { DEFAULT_PREFERENCE, readPreference, validateFish, writePreference } = await import(
  "./preference"
);

const USER = "test-generator-preference";
const FISH = { model: "s2.1-pro-free", temperature: 0.4, topP: 0.8, speed: 1.2 };

beforeAll(async () => {
  await db().query(
    `insert into "user" ("id", "name", "email", "emailVerified")
     values ($1, 'Test Preference', $2, false) on conflict ("id") do nothing`,
    [USER, `${USER}@example.invalid`],
  );
});

afterAll(async () => {
  await db().query(`delete from "user" where "id" = $1`, [USER]);
  await closeDb();
});

describe("fish.audio settings", () => {
  it("take a known model and values in fish.audio's ranges", () => {
    expect(validateFish(FISH)).toEqual(FISH);
  });

  it.each([
    [{ ...FISH, model: "s1" }, /unknown fish.audio model/],
    [{ ...FISH, model: "s2.1-pr0" }, /unknown fish.audio model/],
    [{ ...FISH, temperature: 1.5 }, /temperature/],
    [{ ...FISH, topP: -0.1 }, /topP/],
    [{ ...FISH, speed: 3 }, /speed/],
    [{ ...FISH, speed: "fast" }, /speed/],
  ])("refuse %j", (input, message) => {
    expect(() => validateFish(input)).toThrow(message);
  });
});

describe("a preference", () => {
  it("is ElevenLabs with fish.audio's defaults until one is saved", async () => {
    expect(await readPreference(USER)).toEqual(DEFAULT_PREFERENCE);
  });

  it("is what was saved", async () => {
    await writePreference(USER, { provider: "fish", fish: FISH });
    expect(await readPreference(USER)).toEqual({ provider: "fish", fish: FISH });
  });

  it("falls back to the defaults for settings naming a withdrawn model", async () => {
    await db().query(
      `update "generation_preference" set "fish" = $2::jsonb where "userId" = $1`,
      [USER, JSON.stringify({ ...FISH, model: "s0-retired" })],
    );
    expect((await readPreference(USER)).fish).toEqual(DEFAULT_PREFERENCE.fish);
  });
});
