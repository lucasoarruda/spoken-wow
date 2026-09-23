/**
 * What the explorer needs before it offers to generate anything: which voices exist, how
 * much is left to spend, and what settings are in force -- for whichever generator the
 * collaborator has chosen.
 *
 * Fetched once per page load by anyone who can regenerate, which is why the settings come
 * along - a collaborator cannot open /voices, and "what am I about to spend, and how" should
 * not require the page that they cannot reach.
 *
 * Not refused when the caller has no key, unlike the routes that spend. This is the answer
 * the explorer asks for on load, and the useful answer to "what can you generate" from
 * somebody who has not been to /profile is "nothing yet, and here is why" - which is what
 * `noApiKey` carries. A 428 here would leave the page unable to say it.
 */
import { readApiKey } from "@/lib/api-key";
import { requireIn } from "@/lib/generation/authz";
import { observedFishRate, observedRate } from "@/lib/generation/calibration";
import { readPreference, speakingConfig } from "@/lib/generation/preference";
import { speakerFrom } from "@/lib/generation/speakers/for";
import { getWallet } from "@/lib/voices/fish";
import { generationStatus } from "@/lib/generation/status";

export const dynamic = "force-dynamic";

// In the page's language (?lang=): which slots have a voice, and the accent tags, are its own.
export async function GET(request: Request) {
  const { session, lang, denied } = await requireIn(request, "regenerate");
  if (denied) return denied;

  // Whichever generator this collaborator spends with: the voices, the balance and the rate
  // all belong to it, and an estimate in the other provider's unit would be no estimate.
  const preference = await readPreference(session.user.id);
  // A row that will not open reads as no key here. The distinction between the two is worth
  // making where it can be acted on, which is requireApiKey on the routes that spend; this
  // one only decides whether to draw a balance.
  const [apiKey, settings] = await Promise.all([
    readApiKey(session.user.id, preference.provider).catch(() => null),
    speakingConfig(preference.elevenlabs, lang),
  ]);

  if (preference.provider === "fish") {
    const [voices, wallet, rate] = await Promise.all([
      speakerFrom("fish", apiKey ?? "", preference).voices(lang),
      apiKey ? getWallet({ apiKey }).catch(() => null) : Promise.resolve(null),
      observedFishRate(preference.fish.model, lang),
    ]);
    return Response.json({
      voices: [...voices.ids.keys()].sort(),
      subscription: null,
      error: apiKey && !wallet ? "could not read the fish.audio balance" : null,
      noApiKey: !apiKey,
      settings,
      rate,
      provider: "fish",
      wallet: wallet ? { credit: wallet.credit } : null,
    });
  }

  // The rate is calibrated from what this account has actually been charged for this model,
  // because it is a property of the plan and cannot be read from the API. See billing.ts.
  const [status, rate] = await Promise.all([
    generationStatus(apiKey ? { apiKey } : {}, lang),
    observedRate(preference.elevenlabs.modelId),
  ]);
  return Response.json({
    voices: status.voices,
    subscription: status.subscription,
    error: status.error,
    noApiKey: !apiKey,
    settings,
    rate,
    provider: "elevenlabs",
  });
}
