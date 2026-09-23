import { decode } from "@msgpack/msgpack";
import { describe, expect, it, vi } from "vitest";

import { buildFishPayload, fishSpeech, fishText, type FishSpeechRequest } from "./fish-tts";

const NPC = { audio: Buffer.from("npc-clip"), text: "Well met, traveller." };
const NARRATOR = { audio: Buffer.from("narrator-clip"), text: "The dwarf nods." };
const SETTINGS = { model: "s2.1-pro-free", temperature: 0.7, topP: 0.7, speed: 1 };

const SOLO: FishSpeechRequest = {
  turns: [{ text: "Hiccup! Ho ho!", speaker: 0 }],
  references: [[NPC]],
  settings: SETTINGS,
};

const DIALOGUE: FishSpeechRequest = {
  turns: [
    { text: "Take this to Ironforge.", speaker: 0 },
    { text: "He hands you a letter.", speaker: 1 },
  ],
  references: [[NPC], [NARRATOR]],
  settings: SETTINGS,
};

const OPTIONS = { apiKey: "fish-key", baseUrl: "https://stub.invalid" };

function stub(response: Response) {
  const calls: { url: string; init: RequestInit }[] = [];
  const fetchImpl = vi.fn(async (url: string, init: RequestInit) => {
    calls.push({ url, init });
    return response;
  }) as unknown as typeof globalThis.fetch;
  return { calls, fetchImpl };
}

const audio = () =>
  new Response("ID3fish-mp3", { status: 200, headers: { "content-type": "audio/mpeg" } });

describe("the text fish.audio is sent", () => {
  it("is bare for one speaker", () => {
    expect(fishText(SOLO)).toBe("Hiccup! Ho ho!");
  });

  it("tags every turn, the first included, for several", () => {
    expect(fishText(DIALOGUE)).toBe(
      "<|speaker:0|>Take this to Ironforge.<|speaker:1|>He hands you a letter.",
    );
  });
});

describe("the payload", () => {
  it("carries one speaker's references as a flat list, with no reference_id", () => {
    const payload = buildFishPayload(SOLO);
    expect(payload.references).toEqual([NPC]);
    expect(payload).not.toHaveProperty("reference_id");
  });

  it("carries several speakers' as a list per speaker, paired with ids by position", () => {
    const payload = buildFishPayload(DIALOGUE);
    expect(payload.references).toEqual([[NPC], [NARRATOR]]);
    expect(payload.reference_id).toEqual(["0", "1"]);
  });

  it("asks for the format ElevenLabs returns, at quality latency", () => {
    expect(buildFishPayload(SOLO)).toMatchObject({
      format: "mp3",
      sample_rate: 44100,
      mp3_bitrate: 128,
      latency: "normal",
      temperature: 0.7,
      top_p: 0.7,
      prosody: { speed: 1 },
    });
  });
});

describe("a request", () => {
  it("is msgpack to /v1/tts, with the key as a bearer and the model as a header", async () => {
    const { calls, fetchImpl } = stub(audio());
    const result = await fishSpeech(SOLO, { ...OPTIONS, fetchImpl });

    expect(result.ok).toBe(true);
    expect(calls[0].url).toBe("https://stub.invalid/v1/tts");
    const headers = calls[0].init.headers as Record<string, string>;
    expect(headers.Authorization).toBe("Bearer fish-key");
    expect(headers["Content-Type"]).toBe("application/msgpack");
    expect(headers.model).toBe("s2.1-pro-free");

    // Binary survives the round trip as bytes, which is the point of msgpack here.
    const body = decode(calls[0].init.body as Uint8Array) as { references: { audio: Uint8Array }[] };
    expect(Buffer.from(body.references[0].audio).toString()).toBe("npc-clip");
  });

  it("reports the bytes it is billed for, tags included and counted as UTF-8", async () => {
    const { fetchImpl } = stub(audio());
    const russian = { ...SOLO, turns: [{ text: "Привет", speaker: 0 }] };
    const result = await fishSpeech(russian, { ...OPTIONS, fetchImpl });
    expect(result.ok && result.bytes).toBe(12);

    const dialogue = await fishSpeech(DIALOGUE, { ...OPTIONS, fetchImpl: stub(audio()).fetchImpl });
    expect(dialogue.ok && dialogue.bytes).toBe(Buffer.byteLength(fishText(DIALOGUE)));
  });

  it("is refused without a key, before anything is sent", async () => {
    const { calls, fetchImpl } = stub(audio());
    const result = await fishSpeech(SOLO, { baseUrl: OPTIONS.baseUrl, fetchImpl });
    expect(result.ok || result.failure.kind).toBe("auth");
    expect(calls).toHaveLength(0);
  });
});

describe("a failure", () => {
  const failing = async (status: number, body: string) =>
    fishSpeech(SOLO, {
      ...OPTIONS,
      fetchImpl: stub(new Response(body, { status })).fetchImpl,
    });

  it("keeps fish.audio's message", async () => {
    const result = await failing(402, JSON.stringify({ status: 402, message: "Insufficient balance" }));
    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.failure.kind).toBe("quota");
    expect(result.failure.fatal).toBe(true);
    expect(result.failure.message).toContain("Insufficient balance");
  });

  it.each([
    [401, "auth", true],
    [429, "rate-limit", false],
    [503, "rate-limit", false],
    [400, "bad-request", false],
    [500, "upstream", false],
  ])("%i is %s", async (status, kind, fatal) => {
    const result = await failing(status, JSON.stringify({ status, message: "no" }));
    expect(result.ok || [result.failure.kind, result.failure.fatal]).toEqual([kind, fatal]);
  });

  it("includes a 200 that is not audio, which would otherwise be archived as silence", async () => {
    const result = await fishSpeech(SOLO, {
      ...OPTIONS,
      fetchImpl: stub(Response.json({ message: "queued" })).fetchImpl,
    });
    expect(result.ok || result.failure.kind).toBe("upstream");
  });

  it("includes an empty body", async () => {
    const empty = new Response("", { status: 200, headers: { "content-type": "audio/mpeg" } });
    const result = await fishSpeech(SOLO, { ...OPTIONS, fetchImpl: stub(empty).fetchImpl });
    expect(result.ok || result.failure.kind).toBe("upstream");
  });
});
