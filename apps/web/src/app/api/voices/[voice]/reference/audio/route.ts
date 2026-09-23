/**
 * A reference's cut clip, to listen to beside its transcript.
 *
 * Range support for Safari, as the sample route explains. The ETag is the clipHash, which
 * changes exactly when the clip or its transcript does.
 */
import fs from "node:fs";

import { langParam } from "@/lib/lang-server";
import { parseRange } from "@/lib/range";
import { streamOf } from "@/lib/stream";
import { denyVoiceRequest } from "@/lib/voices/authz";
import { readReference, referencePath } from "@/lib/voices/references";

export const dynamic = "force-dynamic";

type Context = { params: Promise<{ voice: string }> };

export async function GET(request: Request, context: Context) {
  const { voice } = await context.params;
  const denied = await denyVoiceRequest(voice);
  if (denied) return denied;
  const { lang, denied: noLang } = await langParam(request);
  if (noLang) return noLang;

  const reference = await readReference(voice, lang);
  if (!reference) return new Response("no reference", { status: 404 });

  const target = referencePath(voice, lang);
  let size: number;
  try {
    size = fs.statSync(target).size;
  } catch {
    return new Response("no reference clip", { status: 404 });
  }

  const etag = `"${reference.clipHash}"`;
  // Not immutable: the same URL serves whatever the slot's reference is now.
  const cacheControl = "private, no-cache";
  if (request.headers.get("if-none-match") === etag) {
    return new Response(null, { status: 304, headers: { ETag: etag, "Cache-Control": cacheControl } });
  }

  const range = parseRange(request.headers.get("range"), size);
  if (range === "unsatisfiable") {
    return new Response(null, {
      status: 416,
      headers: { "Content-Range": `bytes */${size}`, "Accept-Ranges": "bytes" },
    });
  }

  const headers: Record<string, string> = {
    "Content-Type": "audio/mpeg",
    "Accept-Ranges": "bytes",
    "Cache-Control": cacheControl,
    ETag: etag,
  };
  if (!range) {
    headers["Content-Length"] = String(size);
    return new Response(streamOf(target), { status: 200, headers });
  }
  headers["Content-Length"] = String(range.end - range.start + 1);
  headers["Content-Range"] = `bytes ${range.start}-${range.end}/${size}`;
  return new Response(streamOf(target, range.start, range.end), { status: 206, headers });
}
