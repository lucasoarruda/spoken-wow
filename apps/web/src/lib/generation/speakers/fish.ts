/**
 * fish.audio, as a Speaker.
 *
 * A slot's "voice id" here is its reference's clipHash: the thing fish.audio actually clones
 * from is the clip and its transcript, so that is what a take should record. voices() reads
 * the hashes for a language and speak() loads the clips they name.
 *
 * The settings are the collaborator's own (generation_preference), not an admin's: who
 * generates with fish.audio chooses how.
 */
import "server-only";

import type { Lang } from "@/lib/lang";
import { fishCost, type FishOptions } from "@/lib/voices/fish";
import { listReferences, loadReferences } from "@/lib/voices/references";

import { failure } from "../errors";
import { fishSpeech, type FishSettings } from "../fish-tts";
import { accentTagged, audioTags } from "../narration";
import type { Speaker, SpeakRequest, Spoken, Voices } from "./speaker";

/** What a fish.audio take is recorded as having been cut at: what fish-tts.ts asks for. */
export const FISH_OUTPUT_FORMAT = "mp3_44100_128";

export function fishSpeaker(options: FishOptions & { settings: FishSettings }): Speaker {
  const { settings } = options;

  return {
    provider: "fish",

    async voices(lang: Lang): Promise<Voices> {
      const references = await listReferences(lang);
      return {
        ids: new Map([...references].map(([voice, reference]) => [voice, reference.clipHash])),
        error: null,
      };
    },

    missing(voice: string): string {
      return `no fish.audio reference for "${voice}"`;
    },

    shape(text: string, raceTag: string | undefined): string {
      // fish.audio's S2 models read [bracketed] cues as directions, so the ElevenLabs shaping
      // carries over as it is until the spike shows which of them fish.audio performs.
      return accentTagged(audioTags(text), raceTag);
    },

    async speak({ turns, lang }: SpeakRequest): Promise<Spoken> {
      // One speaker per distinct voice, in order of first appearance: the NPC is speaker 0
      // and the narrator 1, whichever of them opens the line.
      const speakers = [...new Set(turns.map((turn) => turn.voiceId))];
      const clips = await loadReferences(lang, speakers);
      if (!speakers.every((hash) => clips.has(hash))) {
        // voices() handed this hash out moments ago, so the reference was re-cut or removed in
        // between. Refused rather than spoken from whatever is there now, which would record
        // a voice id the audio was not made from.
        return {
          ok: false,
          failure: failure(
            "voice-missing",
            "a fish.audio reference changed while this line was being generated; try again",
          ),
        };
      }

      const speech = await fishSpeech(
        {
          turns: turns.map((turn) => ({ text: turn.text, speaker: speakers.indexOf(turn.voiceId) })),
          references: speakers.map((hash) => [clips.get(hash)!]),
          settings,
        },
        options,
      );
      if (!speech.ok) return speech;

      return {
        ok: true,
        audio: speech.audio,
        // No lead-in: fish.audio has not been shown to need one.
        leadIn: false,
        leadInSec: null,
        credits: null,
        costUsd: fishCost(settings.model, speech.bytes),
        made: {
          modelId: settings.model,
          settings: { temperature: settings.temperature, top_p: settings.topP, speed: settings.speed },
          outputFormat: FISH_OUTPUT_FORMAT,
          dictionaryId: null,
          dictionaryVersion: null,
        },
      };
    },
  };
}
