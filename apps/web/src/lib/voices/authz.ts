/**
 * The access boundary for the voice routes.
 *
 * Every /api/voices route calls this. The role checks in components only decide what to
 * draw — see canRegenerate's comment in permissions.ts — so the server check cannot be
 * skipped just because the UI would not have offered the control.
 *
 * 403 rather than /voices' 404: hiding a page from a member is worth doing, but pretending
 * an API route does not exist only makes a real misconfiguration harder to diagnose.
 */
import { headers } from "next/headers";

import { auth } from "@/lib/auth";
import { canManageVoices } from "@/lib/permissions";
import { isVoiceSlot } from "./slots";

export async function denyVoiceRequest(voice?: string): Promise<Response | null> {
  return (await requireVoiceManager(voice)).denied;
}

type Session = NonNullable<Awaited<ReturnType<typeof auth.api.getSession>>>;

/** The same check, keeping the session for a route that needs to know who is asking. */
export async function requireVoiceManager(
  voice?: string,
): Promise<{ session: Session; denied: null } | { session: null; denied: Response }> {
  const session = await auth.api.getSession({ headers: await headers() });
  if (!session || !canManageVoices(session.user.role)) {
    return { session: null, denied: Response.json({ error: "not allowed" }, { status: 403 }) };
  }
  // Checked after the session so an unauthorized caller cannot use the response to learn
  // which voice names exist.
  if (voice !== undefined && !(await isVoiceSlot(voice))) {
    return {
      session: null,
      denied: Response.json({ error: `unknown voice ${voice}` }, { status: 404 }),
    };
  }
  return { session, denied: null };
}
