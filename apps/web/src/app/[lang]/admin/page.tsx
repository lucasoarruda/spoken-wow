import type { Metadata } from "next";
import { headers } from "next/headers";
import { notFound } from "next/navigation";

import LanguageTable from "@/components/LanguageTable";
import UserTable, { type UserRow } from "@/components/UserTable";
import { userIdsWithApiKey } from "@/lib/api-key";
import { auth } from "@/lib/auth";
import { listGrants, viewerOf } from "@/lib/grants/store";
import { langName } from "@/lib/lang";
import { languageStates } from "@/lib/languages/store";
import { isAdmin, langsWhere } from "@/lib/permissions";
import { currentSession } from "@/lib/session";

export const metadata: Metadata = { title: "Users · Spoken" };

export const dynamic = "force-dynamic";

/**
 * Who may do what, in one place: a global admin's whole user list with each person's role
 * and languages, or -- for somebody who is admin in a language -- the people working in the
 * languages they look after, and the means to bring more in without asking anybody.
 *
 * The real access boundary is api/grants and the admin plugin's own routes; this decides
 * only what to draw. A 404 for everyone else: a member has no business learning it exists.
 */
export default async function Page() {
  const session = await currentSession();
  const viewer = await viewerOf(session);
  const administered = langsWhere(viewer, "admin");
  if (!session || !viewer || administered.length === 0) notFound();

  if (!isAdmin(viewer.role)) {
    // Built from the grants rather than listUsers, which is the admin plugin's and lists
    // every address on the site -- more than looking after one language entitles anybody to.
    const grants = await listGrants(administered);
    const users = new Map<string, UserRow>();
    for (const row of grants) users.set(row.userId, { id: row.userId, name: row.name, email: row.email });

    return (
      <main className="mx-auto max-w-4xl px-5 pt-6 pb-36">
        <h1 className="text-xl font-semibold">Users</h1>
        <p className="text-muted-foreground mt-1 mb-5 text-sm">
          Who works on {administered.map(langName).join(", ")}. You may let somebody edit or
          regenerate there; they need to have registered first.
        </p>
        <UserTable
          users={[...users.values()]}
          grants={grants}
          viewer={viewer}
          currentUserId={session.user.id}
          keyedUserIds={null}
        />
      </main>
    );
  }

  const [{ users }, grants, keyed, languages] = await Promise.all([
    auth.api.listUsers({
      headers: await headers(),
      query: { limit: 200, sortBy: "createdAt", sortDirection: "asc" },
    }),
    listGrants(),
    // Which accounts hold a key, and nothing else about it. An admin hands out what spends,
    // so they must be able to take back what it spends with; reading a colleague's
    // credential is not part of that, so no value crosses this boundary -- not even the
    // redacted hint the owner sees on their own profile.
    userIdsWithApiKey(),
    languageStates(),
  ]);

  return (
    <main className="mx-auto max-w-5xl px-5 pt-6 pb-36">
      <h1 className="text-xl font-semibold">Users</h1>
      <p className="text-muted-foreground mt-1 mb-5 text-sm">
        Everyone who registers starts as a member. What somebody may do beyond reading is
        granted one language at a time, English included; an admin may do everything
        everywhere. Regenerating spends credits from the person&apos;s own ElevenLabs or
        fish.audio account, so a grant is only half of it — the key is theirs, set on their
        profile.
      </p>
      <UserTable
        users={users.map((user) => ({ ...user, createdAt: new Date(user.createdAt).toISOString() }))}
        grants={grants}
        viewer={viewer}
        currentUserId={session.user.id}
        keyedUserIds={keyed}
      />

      <h2 className="mt-10 text-lg font-semibold">Languages</h2>
      <p className="text-muted-foreground mt-1 mb-4 text-sm">
        A language switched on appears in everyone&apos;s header. One that is off can still be
        opened by an admin at its address, to prepare it before anybody else sees it.
      </p>
      <LanguageTable
        initial={languages.map((state) => ({ ...state, name: langName(state.code) }))}
      />
    </main>
  );
}
