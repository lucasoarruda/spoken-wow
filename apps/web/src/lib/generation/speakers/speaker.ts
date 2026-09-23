/**
 * Who makes the audio.
 *
 * Every take used to come from ElevenLabs by construction: the callers built ElevenLabs
 * payloads, resolved ElevenLabs voice ids and recorded ElevenLabs settings. A Speaker is
 * what those callers need from a provider and nothing more, so a second one can stand
 * behind the same three callers (regenerate.ts, narrated.ts and, later, preview.ts)
 * without any of them learning its name.
 *
 * What stays with the callers is everything that is about the line rather than the
 * provider: which text, whose voice slot, the seed, the lock, the take. What moves here is
 * everything a provider decides for itself: its model and settings, its dictionary, how
 * several voices become one file, and what a missing voice is called.
 */
import type { Lang } from "@/lib/lang";

import type { Failure } from "../errors";

export type Provider = "elevenlabs";

/** One voice speaking one stretch of the line. A line with a stage direction has two. */
export type Turn = {
  text: string;
  /** From `voices()`: whatever the provider speaks this slot with. */
  voiceId: string;
};

export type SpeakRequest = {
  turns: Turn[];
  lang: Lang;
  seed: number | null;
  /**
   * Whether this is narration spoken as dialogue, whatever the number of turns.
   *
   * Not simply `turns.length > 1`: a line that is all stage direction is one turn, and has
   * always gone through the same dialogue path as a line that is half one, so that every
   * narrated take was made, and is recorded, the same way.
   */
  dialogue?: boolean;
};

/**
 * What a take was made with, as its row records it.
 *
 * Returned by the provider rather than assembled by the caller, because only the provider
 * knows what it actually sent: ElevenLabs' dialogue endpoint takes stability alone, and a
 * row claiming the other settings would describe a take that never had them.
 */
export type Made = {
  modelId: string;
  settings: Record<string, unknown>;
  outputFormat: string;
  dictionaryId: string | null;
  dictionaryVersion: string | null;
};

export type Spoken =
  | {
      ok: true;
      /** Already trimmed of any lead-in: the audio to keep. */
      audio: Buffer;
      leadIn: boolean;
      leadInSec: number | null;
      /** ElevenLabs credits, exactly as billed. null when the provider did not say. */
      credits: number | null;
      made: Made;
    }
  | { ok: false; failure: Failure };

export type Voices = {
  /** Voice slot to what `speak` takes, for one language. */
  ids: ReadonlyMap<string, string>;
  /** Why the roster could not be read, if it could not. Reported, never thrown. */
  error: string | null;
};

export interface Speaker {
  readonly provider: Provider;
  /** The slots this provider can speak in `lang`, as the key in hand sees them. */
  voices(lang: Lang): Promise<Voices>;
  /** How a slot with no voice is named to the person who has to go and make one. */
  missing(voice: string): string;
  /**
   * The line as this provider should be sent it, before the lexicon.
   *
   * Audio tags and the race's accent direction are written for a model that performs
   * them. Staleness hashes this string, so it has to be the same function both use.
   */
  shape(text: string, raceTag: string | undefined): string;
  speak(request: SpeakRequest): Promise<Spoken>;
}
