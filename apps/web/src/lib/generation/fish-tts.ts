/**
 * One fish.audio speech request, as tts.ts is one ElevenLabs request.
 *
 * Voices are zero-shot: every request carries each speaker's reference clip and its exact
 * transcript, so nothing has to exist in the spending account first. That is also why the
 * body is msgpack -- fish.audio takes inline references only as msgpack, never JSON.
 *
 * Several speakers are one request, not several: the turns are joined with fish.audio's
 * `<|speaker:N|>` tags and it returns one file. Stitching separate files would measure wrong
 * for the reason tts.ts gives for ElevenLabs' dialogue endpoint.
 */
import { encode } from "@msgpack/msgpack";

import { fishConfig, type FishOptions } from "@/lib/voices/fish";

import { classifyFish, failure, type Failure } from "./errors";

/** 10-30 seconds of one voice, and exactly what is said in it. */
export type FishReference = { audio: Buffer; text: string };

export type FishSettings = {
  model: string;
  temperature: number;
  topP: number;
  speed: number;
};

/** fish.audio's own defaults, which a collaborator who has set nothing gets. */
export const FISH_DEFAULTS = { temperature: 0.7, topP: 0.7, speed: 1 } as const;

export type FishSpeechRequest = {
  /** In order; `speaker` indexes `references`. */
  turns: { text: string; speaker: number }[];
  /** One clip per speaker. */
  references: FishReference[];
  settings: FishSettings;
};

/**
 * The text as fish.audio is sent it, and billed for.
 *
 * One speaker is sent bare. More are tagged at every turn, including the first, because the
 * tag is what says which reference a stretch is spoken from.
 */
export function fishText(request: Pick<FishSpeechRequest, "turns" | "references">): string {
  if (request.references.length === 1) return request.turns.map((turn) => turn.text).join(" ");
  return request.turns.map((turn) => `<|speaker:${turn.speaker}|>${turn.text}`).join("");
}

export function buildFishPayload(request: FishSpeechRequest): Record<string, unknown> {
  const { settings } = request;
  const single = request.references.length === 1;
  return {
    text: fishText(request),
    // fish.audio takes a list of clips for one speaker and a list of lists for several, which
    // it pairs with reference_id by position. The ids themselves may be anything for zero-shot.
    references: single ? request.references : request.references.map((clip) => [clip]),
    ...(single ? {} : { reference_id: request.references.map((_, index) => String(index)) }),
    temperature: settings.temperature,
    top_p: settings.topP,
    prosody: { speed: settings.speed },
    // What ElevenLabs returns today, so a pack is one format whichever made its files, and
    // package-audio.sh transcodes both the same way.
    format: "mp3",
    sample_rate: 44100,
    mp3_bitrate: 128,
    // Quality over time-to-first-byte: nothing here is streamed to a listener.
    latency: "normal",
    normalize: true,
  };
}

export type FishSpeechResult =
  | { ok: true; audio: Buffer; bytes: number }
  | { ok: false; failure: Failure };

export async function fishSpeech(
  request: FishSpeechRequest,
  options: FishOptions = {},
): Promise<FishSpeechResult> {
  if (!options.apiKey) {
    // "auth" because it is fatal to a batch: every later job would fail the same way.
    return { ok: false, failure: failure("auth", "no fish.audio key was supplied for this request") };
  }
  const { apiKey, baseUrl, fetchImpl } = fishConfig(options);
  const payload = buildFishPayload(request);

  let response: Response;
  try {
    response = await fetchImpl(`${baseUrl}/v1/tts`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/msgpack",
        // The model is a header, not a field. An unknown one silently falls back to
        // s2.1-pro, so validating the setting is the only guard against paying for a model
        // nobody chose.
        model: request.settings.model,
      },
      body: encode(payload),
    });
  } catch (error) {
    // DNS, TLS, a dropped connection: the next line may well get through.
    return {
      ok: false,
      failure: failure("upstream", `could not reach fish.audio: ${message(error)}`),
    };
  }

  if (!response.ok) {
    const raw = await response.text().catch(() => "");
    return { ok: false, failure: classifyFish(response.status, raw, "generating the line") };
  }

  // An error served with a 200 would otherwise be archived as an mp3 and play as silence.
  const contentType = response.headers.get("content-type") ?? "";
  if (!contentType.startsWith("audio/")) {
    const raw = await response.text().catch(() => "");
    return {
      ok: false,
      failure: failure(
        "upstream",
        `fish.audio answered 200 with ${contentType || "no content type"} rather than audio: ${raw.slice(0, 200)}`,
      ),
    };
  }

  const audio = Buffer.from(await response.arrayBuffer());
  if (audio.byteLength === 0) {
    return { ok: false, failure: failure("upstream", "fish.audio returned an empty response") };
  }

  // What fish.audio bills: the UTF-8 bytes of the text, speaker tags included.
  return { ok: true, audio, bytes: Buffer.byteLength(payload.text as string, "utf8") };
}

function message(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}
