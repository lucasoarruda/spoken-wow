/**
 * Which NPC a kind-less contribution meant, answered by whoever edits its language.
 *
 * Needs DATABASE_URL and migrations applied.
 */
import { afterAll, afterEach, describe, expect, it, vi } from "vitest";

import { closeDb, db } from "@/lib/db";

/** Every language the mocked viewer may edit; the route's gate asks about exactly one. */
const editable = new Set<string>();
const asked: { capability: string; lang: string }[] = [];

vi.mock("@/lib/generation/authz", () => ({
  requireCapability: async (capability: string, lang: string) => {
    asked.push({ capability, lang });
    return capability === "edit" && editable.has(lang)
      ? { session: { user: { id: "test" } }, denied: null }
      : { session: null, denied: Response.json({ error: "not allowed" }, { status: 403 }) };
  },
}));

// Mocked to assert the row's shape. A real insert would not fail the test -- recordActivity
// swallows its own errors outside a transaction -- but the session's "test" user does not
// exist, so it would only log a foreign-key error and leave nothing to check.
const { recordActivity } = vi.hoisted(() => ({ recordActivity: vi.fn() }));
vi.mock("@/lib/activity/store", () => ({ recordActivity }));

import { POST } from "./route";

/** A bucket no other run shares, so a concurrent run's cleanup can't race this one's rows. */
const ip = `test-${Math.random().toString(36).slice(2, 10)}`;

afterEach(async () => {
  editable.clear();
  asked.length = 0;
  recordActivity.mockClear();
  await db().query(`delete from "contribution" where "ip" = $1`, [ip]);
});

afterAll(async () => {
  await closeDb();
});

async function kindless(locale: string): Promise<number> {
  const { rows } = await db().query<{ id: number }>(
    `insert into "contribution" ("source", "key", "locale", "meta", "raw", "dedup", "text", "ip")
     values ('quests', 'q:1:accept', $2, '{"npc": "12345"}', 'raw', $3, 'Words.', $1) returning "id"`,
    [ip, locale, `${ip}-${locale}`],
  );
  return rows[0].id;
}

function post(body: unknown): Request {
  return new Request("https://example.com/api/contributions/kind", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

describe("POST /api/contributions/kind", () => {
  it("lets whoever edits the row's language answer it", async () => {
    const id = await kindless("ptBR");
    editable.add("ptBR");
    const response = await POST(post({ id, npcKind: "creature" }));
    expect(response.status).toBe(200);
    expect(asked).toEqual([{ capability: "edit", lang: "ptBR" }]);
    const { rows } = await db().query(`select "npcKind" from "contribution" where "id" = $1`, [id]);
    expect(rows[0].npcKind).toBe("creature");
    expect(recordActivity).toHaveBeenCalledWith(
      expect.objectContaining({
        kind: "contribution.edited",
        lang: "ptBR",
        subject: String(id),
        actorId: "test",
        detail: { field: "npcKind", value: "creature" },
      }),
    );
  });

  it("refuses somebody who edits another language only", async () => {
    const id = await kindless("ptBR");
    editable.add("enUS");
    expect((await POST(post({ id, npcKind: "creature" }))).status).toBe(403);
  });

  it("asks about English for an id that is not there, and says nothing more to a stranger", async () => {
    expect((await POST(post({ id: 999_999_999, npcKind: "creature" }))).status).toBe(403);
    expect(asked).toEqual([{ capability: "edit", lang: "enUS" }]);
  });
});
