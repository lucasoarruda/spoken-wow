/**
 * The caller's ElevenLabs voice slots: how many are used, and how many the plan allows.
 *
 * Asked by /voices after it has drawn, rather than read while rendering it: ElevenLabs'
 * subscription endpoint takes a second or more, and the only thing on the page that needs it
 * is the count in Populate. The read is the same memoised one the generator uses
 * (lib/generation/status.ts), so a page load here costs no second upstream call.
 *
 * Nulls rather than an error when there is no key or the account cannot be read: the dialog
 * already draws "unknown" as no line at all.
 */
import { readApiKey } from "@/lib/api-key";
import { accountSubscription } from "@/lib/generation/status";
import { requireVoiceViewer } from "@/lib/voices/authz";

export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  const { session, denied } = await requireVoiceViewer(request);
  if (denied) return denied;

  const apiKey = await readApiKey(session.user.id).catch(() => null);
  const { subscription } = apiKey ? await accountSubscription({ apiKey }) : { subscription: null };
  return Response.json({
    slotsUsed: subscription?.voiceSlotsUsed ?? null,
    slotLimit: subscription?.voiceLimit ?? null,
  });
}
