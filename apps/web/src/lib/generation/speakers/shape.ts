/**
 * How each provider is sent a line, before the lexicon: the one function a Speaker and the
 * staleness check must agree on.
 *
 * A table rather than a method alone, because staleness judges takes that were made by
 * whichever provider made them, with no Speaker -- and no key -- in hand. A take is compared
 * against its own provider's shaping, so an ElevenLabs take never reads as stale because
 * fish.audio would be sent the line differently, or the reverse.
 */
import { accentTagged, audioTags } from "../narration";
import type { Provider } from "./speaker";

export const SHAPE: Record<Provider, (text: string, raceTag: string | undefined) => string> = {
  // The accent direction goes on last, so it sits in front of the words rather than in
  // front of a `<hic>` audioTags has yet to rewrite.
  elevenlabs: (text, raceTag) => accentTagged(audioTags(text), raceTag),
  // fish.audio's S2 models read [bracketed] cues as directions, so ElevenLabs' shaping
  // carries over as it is until the spike shows which of them fish.audio performs.
  fish: (text, raceTag) => accentTagged(audioTags(text), raceTag),
};
