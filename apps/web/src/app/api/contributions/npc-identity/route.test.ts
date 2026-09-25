/**
 * Which NPC speaks a quest contribution whose envelope named none, answered by whoever edits its
 * language.
 *
 * Needs DATABASE_URL and migrations applied.
 */
import { afterAll, afterEach, describe, expect, it, vi } from "vitest";

import { closeDb, db } from "@/lib/db";

/** Every language the mocked viewer may edit; the route's gate asks about exactly one. */
const editable = new Set<string>();
const resolved: unknown[] = [];

vi.mock("@/lib/generation/authz", () => ({
  requireCapability: async (capability: string, lang: string) =>
    capability === "edit" && editable.has(lang)
      ? { session: { user: { id: "test" } }, denied: null }
      : { session: null, denied: Response.json({ error: "not allowed" }, { status: 403 }) },
}));

// The corpus scan is resolve.ts's own business and tested there; this only needs to see it asked.
vi.mock("@/lib/npc/resolve", async (importOriginal) => ({
  ...(await importOriginal<typeof import("@/lib/npc/resolve")>()),
  resolveNpc: async (observed: unknown) => {
    resolved.push(observed);
    return null;
  },
}));

import { POST } from "./route";

/** A bucket no other run shares, so a concurrent run's cleanup can't race this one's rows. */
const ip = `test-${Math.random().toString(36).slice(2, 10)}`;

afterEach(async () => {
  editable.clear();
  resolved.length = 0;
  await db().query(`delete from "contribution" where "ip" = $1`, [ip]);
});

afterAll(async () => {
  await closeDb();
});

async function contribution(meta: Record<string, string>, source = "quests"): Promise<number> {
  const { rows } = await db().query<{ id: number }>(
    `insert into "contribution" ("source", "key", "locale", "build", "meta", "raw", "dedup", "text", "ip")
     values ($4, 'q:1:accept', 'ptBR', '1.15.7/1', $2, 'raw', $3, 'Words.', $1) returning "id"`,
    [ip, JSON.stringify(meta), `${ip}-${Math.random()}`, source],
  );
  return rows[0].id;
}

function post(body: unknown): Request {
  return new Request("https://example.com/api/contributions/npc-identity", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

describe("POST /api/contributions/npc-identity", () => {
  it("records the NPC and resolves it", async () => {
    const id = await contribution({});
    editable.add("ptBR");
    const response = await POST(post({ id, npcKind: "creature", npcId: 240, npcName: " Marshal Dughan " }));
    expect(response.status).toBe(200);
    const { rows } = await db().query(`select "npcKind", "npcId", "npcName" from "contribution" where "id" = $1`, [id]);
    expect(rows[0]).toEqual({ npcKind: "creature", npcId: 240, npcName: "Marshal Dughan" });
    expect(resolved).toEqual([expect.objectContaining({ npcKind: "creature", npcId: 240, npcName: "Marshal Dughan", build: "1.15.7/1" })]);
  });

  it("requires both the id and the name", async () => {
    const id = await contribution({});
    editable.add("ptBR");
    expect((await POST(post({ id, npcKind: "creature", npcId: "240", npcName: "X" }))).status).toBe(400);
    expect((await POST(post({ id, npcKind: "creature", npcId: 240, npcName: "  " }))).status).toBe(400);
    expect((await POST(post({ id, npcKind: "creature", npcId: -1, npcName: "X" }))).status).toBe(400);
  });

  it("leaves an envelope's own NPC alone", async () => {
    const id = await contribution({ npc: "12345 X", kind: "creature" });
    editable.add("ptBR");
    expect((await POST(post({ id, npcKind: "creature", npcId: 240, npcName: "Y" }))).status).toBe(409);
    expect(resolved).toEqual([]);
  });

  it("leaves a row that is not a quest's alone", async () => {
    const id = await contribution({}, "zones");
    editable.add("ptBR");
    expect((await POST(post({ id, npcKind: "creature", npcId: 240, npcName: "Y" }))).status).toBe(409);
  });

  it("refuses somebody who edits another language only", async () => {
    const id = await contribution({});
    editable.add("enUS");
    expect((await POST(post({ id, npcKind: "creature", npcId: 240, npcName: "Y" }))).status).toBe(403);
  });
});
