import type { Metadata } from "next";
import { redirect } from "next/navigation";

import ApiKeySection from "@/components/ApiKeySection";
import GeneratorSection from "@/components/GeneratorSection";
import { apiKeyStatus } from "@/lib/api-key";
import { readPreference } from "@/lib/generation/preference";
import { FISH_MODELS } from "@/lib/voices/fish";
import { viewerOf } from "@/lib/grants/store";
import { localeHref } from "@/lib/lang";
import { pageLang } from "@/lib/lang-server";
import { spendsCredits } from "@/lib/permissions";
import { currentSession } from "@/lib/session";

export const metadata: Metadata = { title: "Profile · Spoken" };

// The stored key's state changes underneath this page, and it is per-user, so nothing here
// can be cached between views.
export const dynamic = "force-dynamic";

/**
 * The account's own page.
 *
 * A redirect to /login rather than the 404 /admin and /voices give a member: every signed-in
 * user has a profile, so the only question here is who is asking, and signing in answers it.
 */
export default async function Page({ params }: { params: Promise<{ lang: string }> }) {
  const lang = await pageLang(params);
  const session = await currentSession();
  if (!session) redirect(localeHref(lang, "/login"));

  const role = session.user.role;
  const spends = spendsCredits(await viewerOf(session));
  // The status, never the key. Sent to a client component as props, so this is the shape
  // that decides what the browser can possibly learn.
  const [status, fishStatus, preference] = spends
    ? await Promise.all([
        apiKeyStatus(session.user.id),
        apiKeyStatus(session.user.id, "fish"),
        readPreference(session.user.id),
      ])
    : [null, null, null];
  const models = FISH_MODELS.map((model) => ({
    id: model.id,
    label: model.label,
    preview: model.preview,
    price:
      model.usdPerMillionBytes === null
        ? "price not published"
        : model.usdPerMillionBytes === 0
          ? "free"
          : `$${model.usdPerMillionBytes} per million bytes`,
  }));

  return (
    <main className="mx-auto max-w-4xl px-5 pt-6 pb-36">
      <h1 className="text-xl font-semibold">Profile</h1>

      <dl className="mt-4 mb-8 grid max-w-md grid-cols-[6rem_1fr] gap-y-1 text-sm">
        <dt className="text-muted-foreground">Email</dt>
        <dd>{session.user.email}</dd>
        <dt className="text-muted-foreground">Role</dt>
        <dd>
          <span className="rounded border px-1.5 text-xs uppercase">{role ?? "member"}</span>
        </dd>
      </dl>

      {spends ? (
        <div className="space-y-10">
          {preference && (
            <GeneratorSection
              initial={preference}
              hasFishKey={fishStatus !== null}
              models={models}
            />
          )}
          <ApiKeySection initial={status} />
          <ApiKeySection initial={fishStatus} provider="fish" />
        </div>
      ) : (
        // Said rather than hidden: a member who has been told "go and regenerate that line"
        // needs to know which of the two things they are missing.
        <p className="text-muted-foreground max-w-xl text-sm">
          Generating audio needs the <strong className="text-foreground">collaborator</strong>{" "}
          role, or the right to regenerate in a language. Ask an admin for it, and this page
          will then ask you for an ElevenLabs key of your own.
        </p>
      )}
    </main>
  );
}
