/**
 * Which generator the signed-in collaborator spends with, and their settings for each.
 *
 * Choosing fish.audio needs a fish.audio key already stored: a choice that could only fail
 * would move the next batch onto a provider with nothing to pay for it, and the failure would
 * arrive in the queue rather than here.
 */
import { apiKeyStatus } from "@/lib/api-key";
import {
  PreferenceError,
  validateElevenLabs,
  validateFish,
  writePreference,
} from "@/lib/generation/preference";
import { currentSpender } from "@/lib/generation/authz";
import { isProvider, PROVIDERS } from "@/lib/generation/providers";

export const dynamic = "force-dynamic";

const FORBIDDEN = () => Response.json({ error: "not allowed" }, { status: 403 });

export async function PUT(request: Request) {
  const session = await currentSpender();
  if (!session) return FORBIDDEN();

  const body = (await request.json().catch(() => ({}))) as {
    provider?: unknown;
    elevenlabs?: unknown;
    fish?: unknown;
  };
  if (!isProvider(body.provider)) {
    return Response.json({ error: `provider must be one of ${PROVIDERS.join(", ")}` }, { status: 400 });
  }

  let fish;
  let elevenlabs;
  try {
    fish = validateFish(body.fish);
    elevenlabs = validateElevenLabs(body.elevenlabs);
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

  const preference = { provider: body.provider, elevenlabs, fish } as const;
  await writePreference(session.user.id, preference);
  return Response.json({ preference });
}
