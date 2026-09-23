/**
 * The clip each voice slot is spoken from on fish.audio, per language.
 *
 * fish.audio is used zero-shot: every request carries 10-30 seconds of the voice and exactly
 * what is said in it. So a reference is a window cut from one of the slot's clips on
 * /voices, a transcript of that window, and a row in fish_reference (migration 0042) saying
 * which clip and where. Nothing is created in anybody's fish.audio account, which is why a
 * reference made by one admin works with every collaborator's key.
 *
 * The transcript matters as much as the audio -- fish.audio's guidance is that it must match
 * exactly, punctuation included -- so it is fish.audio's own speech-to-text, open to
 * correction by hand.
 */
import "server-only";

import { execFile } from "node:child_process";
import crypto from "node:crypto";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { promisify } from "node:util";

import { db } from "@/lib/db";
import type { Lang } from "@/lib/lang";
import { VOICE_REFERENCES_DIR } from "@/lib/paths";
import { writeAtomic } from "@/lib/takes/bytes";

import { FFMPEG } from "./merge";
import { isVoiceSlot } from "./slots";

const run = promisify(execFile);

/** fish.audio's guidance: shorter clones badly, longer only costs upload on every request. */
export const MIN_REFERENCE_SECONDS = 10;
export const MAX_REFERENCE_SECONDS = 30;
/** What the panel offers before anybody has chosen: a comfortable middle of the range. */
export const DEFAULT_REFERENCE_SECONDS = 20;

export type Reference = {
  voice: string;
  lang: Lang;
  sample: string;
  startSec: number;
  endSec: number;
  transcript: string;
  clipHash: string;
  updatedAt: string;
};

/** A reason to refuse a window, worth showing a human, or null. */
export function rejectWindow(startSec: number, endSec: number): string | null {
  if (!Number.isFinite(startSec) || !Number.isFinite(endSec)) return "the window must be numbers";
  if (startSec < 0) return "the window cannot start before the clip does";
  const length = endSec - startSec;
  if (length < MIN_REFERENCE_SECONDS || length > MAX_REFERENCE_SECONDS) {
    return `a reference must be ${MIN_REFERENCE_SECONDS}-${MAX_REFERENCE_SECONDS} seconds long, not ${length.toFixed(1)}`;
  }
  return null;
}

/**
 * Of the clip and the transcript together: a new transcript for the same audio is a
 * different reference, because fish.audio clones from both.
 */
export function clipHash(audio: Buffer, transcript: string): string {
  return crypto.createHash("sha256").update(audio).update("\0").update(transcript).digest("hex");
}

export function referencePath(voice: string, lang: Lang): string {
  return path.join(VOICE_REFERENCES_DIR, lang, `${voice}.mp3`);
}

type Row = Omit<Reference, "updatedAt" | "lang"> & { lang: string; updatedAt: Date };

function fromRow(row: Row): Reference {
  return { ...row, lang: row.lang as Lang, updatedAt: row.updatedAt.toISOString() };
}

const COLUMNS = `"voice", "lang", "sample", "startSec", "endSec", "transcript", "clipHash", "updatedAt"`;

export async function readReference(voice: string, lang: Lang): Promise<Reference | null> {
  const { rows } = await db().query<Row>(
    `select ${COLUMNS} from "fish_reference" where "voice" = $1 and "lang" = $2`,
    [voice, lang],
  );
  return rows[0] ? fromRow(rows[0]) : null;
}

/** Every reference in one language, by voice. */
export async function listReferences(lang: Lang): Promise<Map<string, Reference>> {
  const { rows } = await db().query<Row>(
    `select ${COLUMNS} from "fish_reference" where "lang" = $1`,
    [lang],
  );
  return new Map(rows.map((row) => [row.voice, fromRow(row)]));
}

/**
 * The clip and transcript a request sends, found by the hash a Speaker handed out.
 *
 * By hash rather than by voice: the hash is what `voices()` resolved and what the take will
 * record, so a reference re-cut between the two must fail the request rather than send
 * different audio from what the take claims.
 */
export async function loadReferences(
  lang: Lang,
  hashes: string[],
): Promise<Map<string, { audio: Buffer; text: string }>> {
  const { rows } = await db().query<{ voice: string; transcript: string; clipHash: string }>(
    `select "voice", "transcript", "clipHash" from "fish_reference"
      where "lang" = $1 and "clipHash" = any($2::text[])`,
    [lang, hashes],
  );
  const loaded = await Promise.all(
    rows.map(async (row) => {
      const audio = await fs.readFile(referencePath(row.voice, lang));
      return [row.clipHash, { audio, text: row.transcript }] as const;
    }),
  );
  return new Map(loaded);
}

/**
 * Cut `startSec`-`endSec` out of `source` as mono mp3.
 *
 * Re-encoded rather than stream-copied: a copy can only cut at frame boundaries and keeps
 * whatever format the clip arrived in, and fish.audio takes WAV, MP3 and FLAC only. Arguments
 * go to ffmpeg as an array, never through a shell.
 */
export async function cutClip(source: string, startSec: number, endSec: number): Promise<Buffer> {
  const dir = await fs.mkdtemp(path.join(os.tmpdir(), "spoken-reference-"));
  const out = path.join(dir, "reference.mp3");
  try {
    await run(
      FFMPEG,
      [
        "-hide_banner",
        "-loglevel",
        "error",
        "-ss",
        String(startSec),
        "-t",
        String(endSec - startSec),
        "-i",
        source,
        "-ac",
        "1",
        "-ar",
        "44100",
        "-b:a",
        "192k",
        "-y",
        out,
      ],
      { maxBuffer: 16 * 1024 * 1024 },
    );
    const audio = await fs.readFile(out);
    if (audio.byteLength === 0) throw new Error("ffmpeg produced an empty clip");
    return audio;
  } finally {
    await fs.rm(dir, { recursive: true, force: true });
  }
}

export type SaveReference = {
  voice: string;
  lang: Lang;
  sample: string;
  /** The clip on disk the window is cut from. */
  sourcePath: string;
  startSec: number;
  endSec: number;
  userId: string;
  /** fish.audio's speech-to-text, bound to the admin's own key by the caller. */
  transcribe: (audio: Buffer) => Promise<string>;
};

/**
 * Cut, transcribe and store a reference, replacing any the slot already had in `lang`.
 *
 * The file is written before the row, so a row never names audio that is not there; a
 * failure between the two leaves a file nothing points at, which the next save overwrites.
 */
export async function saveReference(input: SaveReference): Promise<Reference> {
  if (!(await isVoiceSlot(input.voice))) throw new Error(`unknown voice slot ${input.voice}`);
  const rejected = rejectWindow(input.startSec, input.endSec);
  if (rejected) throw new Error(rejected);

  const audio = await cutClip(input.sourcePath, input.startSec, input.endSec);
  const transcript = (await input.transcribe(audio)).trim();
  if (!transcript) throw new Error("fish.audio heard nothing in that window");

  await writeAtomic(referencePath(input.voice, input.lang), audio);
  await db().query(
    `insert into "fish_reference"
       ("voice", "lang", "sample", "startSec", "endSec", "transcript", "clipHash", "updatedBy", "updatedAt")
     values ($1, $2, $3, $4, $5, $6, $7, $8, now())
     on conflict ("voice", "lang") do update set
       "sample" = excluded."sample",
       "startSec" = excluded."startSec",
       "endSec" = excluded."endSec",
       "transcript" = excluded."transcript",
       "clipHash" = excluded."clipHash",
       "updatedBy" = excluded."updatedBy",
       "updatedAt" = now()`,
    [
      input.voice,
      input.lang,
      input.sample,
      input.startSec,
      input.endSec,
      transcript,
      clipHash(audio, transcript),
      input.userId,
    ],
  );
  return (await readReference(input.voice, input.lang))!;
}

/** A corrected transcript, which is a new reference as far as the hash is concerned. */
export async function saveTranscript(
  voice: string,
  lang: Lang,
  transcript: string,
  userId: string,
): Promise<Reference | null> {
  const text = transcript.trim();
  if (!text) throw new Error("a transcript cannot be empty");
  const audio = await fs.readFile(referencePath(voice, lang)).catch(() => null);
  if (!audio) return null;

  const { rowCount } = await db().query(
    `update "fish_reference"
        set "transcript" = $3, "clipHash" = $4, "updatedBy" = $5, "updatedAt" = now()
      where "voice" = $1 and "lang" = $2`,
    [voice, lang, text, clipHash(audio, text), userId],
  );
  return rowCount ? readReference(voice, lang) : null;
}

/** The row and the cut clip. The sample it was cut from stays. */
export async function deleteReference(voice: string, lang: Lang): Promise<void> {
  await db().query(`delete from "fish_reference" where "voice" = $1 and "lang" = $2`, [
    voice,
    lang,
  ]);
  await fs.rm(referencePath(voice, lang), { force: true });
}
