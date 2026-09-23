/**
 * A reference's cut clip, to listen to beside its transcript.
 *
 * Answered by serveFile, which the take audio routes use too.
 */
import fs from "node:fs";

import { langParam } from "@/lib/lang-server";
import { serveFile } from "@/lib/stream";
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

  // Not immutable: the same URL serves whatever the slot's reference is now, and the ETag is
  // the clipHash, which changes exactly when the clip or its transcript does.
  return serveFile(request, target, size, {
    etag: `"${reference.clipHash}"`,
    cacheControl: "private, no-cache",
  });
}
