/**
 * How each provider is sent a line, before the lexicon: the one function regenerate.ts and
 * the staleness check must agree on.
 *
 * A table keyed by provider rather than a Speaker method, because staleness judges takes by
 * whichever provider made them, with no Speaker -- and no key -- in hand. A take is compared
 * against its own provider's shaping, so it never reads as stale because another provider
 * would be sent the line differently.
 */
import { accentTagged, audioTags } from "../narration";
import type { Provider } from "../providers";

/**
 * Audio tags as brackets, and the race's accent direction in front of the NPC's words. Last,
 * so the direction sits before the words rather than before a `<hic>` not yet rewritten.
 */
function bracketed(text: string, raceTag: string | undefined): string {
  return accentTagged(audioTags(text), raceTag);
}

// fish.audio's S2 models read [bracketed] cues as directions too, so it is shaped the same
// way until listening shows which of them it performs.
export const SHAPE: Record<Provider, (text: string, raceTag: string | undefined) => string> = {
  elevenlabs: bracketed,
  fish: bracketed,
};
