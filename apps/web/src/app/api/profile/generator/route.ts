/**
 * Which generator the signed-in collaborator spends with, and their fish.audio settings.
 *
 * Choosing fish.audio needs a fish.audio key already stored: a choice that could only fail
 * would move the next batch onto a provider with nothing to pay for it, and the failure would
 * arrive in the queue rather than here.
 */
import { apiKeyStatus } from "@/lib/api-key";
import { viewerOf } from "@/lib/grants/store";
import {
  PreferenceError,
  readPreference,
  validateFish,
  writePreference,
} from "@/lib/generation/preference";
import { spendsCredits } from "@/lib/permissions";
import { currentSession } from "@/lib/session";

export const dynamic = "force-dynamic";

const FORBIDDEN = () => Response.json({ error: "not allowed" }, { status: 403 });

async function spender() {
  const session = await currentSession();
  return session && spendsCredits(await viewerOf(session)) ? session : null;
}

export async function GET() {
  const session = await spender();
  if (!session) return FORBIDDEN();
  return Response.json({ preference: await readPreference(session.user.id) });
}

export async function PUT(request: Request) {
  const session = await spender();
  if (!session) return FORBIDDEN();

  const body = (await request.json().catch(() => ({}))) as { provider?: unknown; fish?: unknown };
  if (body.provider !== "elevenlabs" && body.provider !== "fish") {
    return Response.json({ error: "provider must be 'elevenlabs' or 'fish'" }, { status: 400 });
  }

  let fish;
  try {
    fish = validateFish(body.fish);
  } catch (error) {
    if (error instanceof PreferenceError) {
      return Response.json({ error: error.message }, { status: 400 });
    }
    throw error;
  }

  if (body.provider === "fish" && !(await apiKeyStatus(session.user.id, "fish"))) {
    return Response.json(
      { error: "store a fish.audio key before choosing fish.audio" },
      { status: 409 },
    );
  }

  const preference = { provider: body.provider, fish } as const;
  await writePreference(session.user.id, preference);
  return Response.json({ preference });
}
