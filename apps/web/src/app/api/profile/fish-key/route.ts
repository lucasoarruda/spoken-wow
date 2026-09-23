/**
 * Setting, replacing and clearing the signed-in user's fish.audio key.
 *
 * The ElevenLabs route's rules, unchanged (../api-key/route.ts): nothing here ever returns
 * a key, and only somebody who spends somewhere may store one.
 */
import { apiKeyStatus, deleteApiKey, storeApiKey } from "@/lib/api-key";
import { viewerOf } from "@/lib/grants/store";
import { isAdmin, spendsCredits } from "@/lib/permissions";
import { currentSession } from "@/lib/session";
import { getWallet } from "@/lib/voices/fish";

export const dynamic = "force-dynamic";

const FORBIDDEN = () => Response.json({ error: "not allowed" }, { status: 403 });

async function spender() {
  const session = await currentSession();
  return session && spendsCredits(await viewerOf(session)) ? session : null;
}

export async function GET() {
  const session = await spender();
  if (!session) return FORBIDDEN();

  return Response.json({ status: await apiKeyStatus(session.user.id, "fish") });
}

export async function POST(request: Request) {
  const session = await spender();
  if (!session) return FORBIDDEN();

  const body = (await request.json().catch(() => ({}))) as { key?: unknown };
  const key = typeof body.key === "string" ? body.key.trim() : "";
  if (key === "") return Response.json({ error: "a key is required" }, { status: 400 });

  // Verified before it is stored, by reading the balance: it costs nothing, and a typo
  // surfacing here is one message rather than a batch stopped on its first line.
  try {
    await getWallet({ apiKey: key });
  } catch (error) {
    return Response.json(
      { error: error instanceof Error ? error.message : String(error) },
      { status: 400 },
    );
  }

  return Response.json({ status: await storeApiKey(session.user.id, key, null, "fish") });
}

/** The caller's own key, or -- with ?userId=, for admins -- somebody else's. */
export async function DELETE(request: Request) {
  const session = await currentSession();
  if (!session) return FORBIDDEN();

  const target = new URL(request.url).searchParams.get("userId");

  if (target && target !== session.user.id) {
    if (!isAdmin(session.user.role)) return FORBIDDEN();
    await deleteApiKey(target, "fish");
    return Response.json({ cleared: true });
  }

  await deleteApiKey(session.user.id, "fish");
  return Response.json({ status: null });
}
