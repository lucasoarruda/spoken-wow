/**
 * Against a real Postgres, like lib/takes/store.test.ts: what is worth pinning here is SQL
 * -- the language filter with its every-language rows, the keyset cursor at microsecond
 * precision, a batch's takes folded out of the page, and an event rolling back with its
 * transaction -- and a mocked database would only echo the statements back.
 *
 * Every row is written by a user made for the run and filtered by them, so the test can
 * share a database with real activity.
 *
 * Needs DATABASE_URL and migration 0050 applied.
 */
import { randomUUID } from "node:crypto";

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from "vitest";

const { closeDb, db } = await import("@/lib/db");
const { batchTakes, listActivity, recordActivities, recordActivity } = await import("./store");

let actor: string;

beforeAll(async () => {
  try {
    await db().query(`select 1 from "activity" limit 1`);
  } catch (error) {
    throw new Error(
      "store.test.ts needs a migrated database (migration 0050). Run:\n" +
        '  deploy/web/bin/migrate.sh "$PWD/apps/web"\n' +
        String(error),
    );
  }
});

beforeEach(async () => {
  actor = `activity-test-${randomUUID()}`;
  await db().query(
    `insert into "user" ("id", "name", "email", "emailVerified") values ($1, 'Tester', $2, true)`,
    [actor, `${actor}@example.test`],
  );
});

afterEach(async () => {
  await db().query(`delete from "activity" where "actorId" = $1`, [actor]);
  await db().query(`delete from "user" where "id" = $1`, [actor]);
});

afterAll(async () => {
  await closeDb();
});

describe("listActivity", () => {
  it("shows a language's rows and the every-language ones, not another language's", async () => {
    await recordActivity({ kind: "ignore.set", lang: "deDE", actorId: actor, subject: "de", detail: {} });
    await recordActivity({ kind: "ignore.set", lang: null, actorId: actor, subject: "all", detail: {} });
    await recordActivity({ kind: "ignore.set", lang: "frFR", actorId: actor, subject: "fr", detail: {} });

    const { rows } = await listActivity({ lang: "deDE", actorId: actor });

    expect(rows.map((row) => row.subject).sort()).toEqual(["all", "de"]);
    expect(rows[0].actorName).toBe("Tester");
  });

  it("filters by category", async () => {
    await recordActivity({ kind: "ignore.set", lang: "deDE", actorId: actor, detail: {} });
    await recordActivity({ kind: "grant.added", lang: "deDE", actorId: actor, detail: { capability: "edit" } });

    const { rows } = await listActivity({ lang: "deDE", actorId: actor, category: "admin" });

    expect(rows.map((row) => row.kind)).toEqual(["grant.added"]);
  });

  it("pages through rows written in the same millisecond without skipping any", async () => {
    // One statement, so every row shares a transaction timestamp to the microsecond: the
    // id is all that orders them, which is the case a cursor rounded through a Date loses.
    await recordActivities(
      Array.from({ length: 5 }, (_, n) => ({
        kind: "ignore.set" as const,
        lang: "deDE" as const,
        actorId: actor,
        subject: String(n),
        detail: {},
      })),
    );

    const seen: string[] = [];
    let before;
    for (let guard = 0; guard < 10; guard++) {
      const page = await listActivity({ lang: "deDE", actorId: actor, limit: 2, before });
      seen.push(...page.rows.map((row) => row.subject!));
      if (!page.next) break;
      before = page.next;
    }

    expect(seen.sort()).toEqual(["0", "1", "2", "3", "4"]);
  });

  it("folds a batch's takes under the batch and counts them there", async () => {
    const batchId = randomUUID();
    await recordActivity({
      kind: "batch.queued",
      lang: "deDE",
      source: "zones",
      actorId: actor,
      subject: batchId,
      detail: { batchId, count: 2 },
    });
    for (const version of [1, 2]) {
      await recordActivity({
        kind: "take.generated",
        lang: "deDE",
        source: "zones",
        actorId: actor,
        subject: `1411/test-${version}`,
        detail: { version, batchId },
      });
    }
    await recordActivity({
      kind: "take.generated",
      lang: "deDE",
      source: "zones",
      actorId: actor,
      subject: "1411/by-hand",
      detail: { version: 1 },
    });

    const { rows } = await listActivity({ lang: "deDE", actorId: actor });

    expect(rows.map((row) => row.kind).sort()).toEqual(["batch.queued", "take.generated"]);
    expect(rows.find((row) => row.kind === "batch.queued")?.takes).toBe(2);
    expect((await batchTakes("deDE", batchId)).map((row) => row.subject).sort()).toEqual([
      "1411/test-1",
      "1411/test-2",
    ]);
  });
});

describe("recordActivity", () => {
  it("rolls back with the transaction it was written in", async () => {
    const client = await db().connect();
    try {
      await client.query("begin");
      await recordActivity({ kind: "ignore.set", lang: "deDE", actorId: actor, detail: {} }, client);
      await client.query("rollback");
    } finally {
      client.release();
    }

    const { rows } = await listActivity({ lang: "deDE", actorId: actor });
    expect(rows).toEqual([]);
  });

  it("does not throw outside a transaction when the row cannot be written", async () => {
    // An actor that is no user breaks the foreign key: the act it describes must not fail.
    await expect(
      recordActivity({ kind: "ignore.set", lang: "deDE", actorId: `missing-${randomUUID()}`, detail: {} }),
    ).resolves.toBeUndefined();
  });
});
