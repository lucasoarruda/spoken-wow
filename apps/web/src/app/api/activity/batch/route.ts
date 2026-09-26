/**
 * The takes one queue batch cut, for the activity page's batch row when it is opened.
 *
 * Fetched on demand rather than sent with the page: the page folds a batch into one row
 * precisely because it can be hundreds of takes, and most batches are never opened.
 *
 * Behind the same capability as the page, in the batch's language.
 */
import { NextRequest } from "next/server";

import { batchTakes } from "@/lib/activity/store";
import { requireIn } from "@/lib/generation/authz";

export const dynamic = "force-dynamic";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export async function GET(request: NextRequest) {
  const { lang, denied } = await requireIn(request, "admin");
  if (denied) return denied;

  const id = request.nextUrl.searchParams.get("id");
  if (!id || !UUID.test(id)) {
    return Response.json({ error: "id must be a batch id" }, { status: 400 });
  }

  return Response.json({ takes: await batchTakes(lang, id) });
}
