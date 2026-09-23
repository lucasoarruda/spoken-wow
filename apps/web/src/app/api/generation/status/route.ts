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
import { readPreference } from "@/lib/generation/preference";
import { speakerFrom } from "@/lib/generation/speakers/for";
import { getWallet } from "@/lib/voices/fish";
import { readSettings } from "@/lib/generation/settings";
import { generationStatus } from "@/lib/generation/status";

export const dynamic = "force-dynamic";

// In the page's language (?lang=): which slots have a voice, and the settings, are its own.
export async function GET(request: Request) {
  const { session, lang, denied } = await requireIn(request, "regenerate");
  if (denied) return denied;

  // Whichever generator this collaborator spends with: the voices, the balance and the rate
  // all belong to it, and an estimate in the other provider's unit would be no estimate.
  const preference = await readPreference(session.user.id);

  // A row that will not open reads as no key here. The distinction between the two is worth
  // making where it can be acted on, which is requireApiKey on the routes that spend; this
  // one only decides whether to draw a balance.
  const apiKey = await readApiKey(session.user.id, preference.provider).catch(() => null);
  const settings = await readSettings(lang);
  // The collaborator's own ElevenLabs settings, with the language's accent tags, which are
  // the one part of the settings that stayed per language.
  const config = { ...preference.elevenlabs, raceTags: settings.config.raceTags };

  if (preference.provider === "fish") {
    const speaker = speakerFrom("fish", apiKey ?? "", preference);
    const [voices, wallet, rate] = await Promise.all([
      speaker.voices(lang),
      apiKey ? getWallet({ apiKey }).catch(() => null) : Promise.resolve(null),
      observedFishRate(preference.fish.model, lang),
    ]);
    return Response.json({
      voices: [...voices.ids.keys()].sort(),
      subscription: null,
      error: apiKey && !wallet ? "could not read the fish.audio balance" : null,
      noApiKey: !apiKey,
      settings: config,
      settingsSource: settings.source,
      rate,
      provider: "fish",
      wallet: wallet ? { credit: wallet.credit } : null,
    });
  }

  const status = await generationStatus(apiKey ? { apiKey } : {}, lang);

  // Calibrated from what this account has actually been charged for this model, because the
  // rate is a property of the plan and cannot be read from the API. See billing.ts.
  const rate = await observedRate(preference.elevenlabs.modelId);

  return Response.json({
    voices: status.voices,
    subscription: status.subscription,
    error: status.error,
    noApiKey: !apiKey,
    settings: config,
    settingsSource: settings.source,
    rate,
    provider: "elevenlabs",
  });
}
