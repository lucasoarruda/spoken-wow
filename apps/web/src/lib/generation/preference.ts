/**
 * Which generator a collaborator spends with, and how they have set fish.audio up.
 *
 * The collaborator's, not an admin's (migration 0041): each generates with their own key, so
 * each decides which provider that key is for. ElevenLabs' model and settings stay an
 * admin's, per language; fish.audio's are the collaborator's own, because nobody else pays
 * for them.
 *
 * No row is ElevenLabs with fish.audio's defaults, which is what everybody had before this.
 */
import "server-only";

import { db } from "@/lib/db";
import { DEFAULT_FISH_MODEL, isFishModel } from "@/lib/voices/fish";

import { FISH_DEFAULTS, type FishSettings } from "./fish-tts";
import type { Provider } from "./speakers/speaker";

export type Preference = { provider: Provider; fish: FishSettings };

export const DEFAULT_PREFERENCE: Preference = {
  provider: "elevenlabs",
  fish: { model: DEFAULT_FISH_MODEL, ...FISH_DEFAULTS },
};

export class PreferenceError extends Error {}

/** fish.audio's documented ranges (docs.fish.audio, the TTS request schema). */
const RANGES = {
  temperature: [0, 1],
  topP: [0, 1],
  speed: [0.5, 2],
} as const;

/**
 * Coerce and check untrusted fish settings, or throw PreferenceError.
 *
 * The model is checked against the list rather than passed through, because fish.audio
 * quietly falls back to s2.1-pro for a model it does not know -- a typo would be billed at
 * full price with nothing saying so.
 */
export function validateFish(input: unknown): FishSettings {
  if (!input || typeof input !== "object") throw new PreferenceError("fish settings must be an object");
  const raw = input as Record<string, unknown>;
  if (!isFishModel(raw.model)) throw new PreferenceError(`unknown fish.audio model ${String(raw.model)}`);

  const number = (key: keyof typeof RANGES) => {
    const value = Number(raw[key]);
    const [min, max] = RANGES[key];
    if (!Number.isFinite(value) || value < min || value > max) {
      throw new PreferenceError(`${key} must be between ${min} and ${max}`);
    }
    return value;
  };
  return {
    model: raw.model,
    temperature: number("temperature"),
    topP: number("topP"),
    speed: number("speed"),
  };
}

export async function readPreference(userId: string): Promise<Preference> {
  const { rows } = await db().query<{ provider: Provider; fish: unknown }>(
    `select "provider", "fish" from "generation_preference" where "userId" = $1`,
    [userId],
  );
  const row = rows[0];
  if (!row) return DEFAULT_PREFERENCE;

  // Settings saved under a model fish.audio has since withdrawn read as the defaults rather
  // than failing every line: the collaborator sees them on /profile and can choose again.
  let fish = DEFAULT_PREFERENCE.fish;
  try {
    if (row.fish) fish = validateFish(row.fish);
  } catch {
    fish = DEFAULT_PREFERENCE.fish;
  }
  return { provider: row.provider, fish };
}

export async function writePreference(userId: string, preference: Preference): Promise<void> {
  await db().query(
    `insert into "generation_preference" ("userId", "provider", "fish", "updatedAt")
     values ($1, $2, $3::jsonb, now())
     on conflict ("userId") do update set
       "provider" = excluded."provider",
       "fish" = excluded."fish",
       "updatedAt" = now()`,
    [userId, preference.provider, JSON.stringify(preference.fish)],
  );
}
