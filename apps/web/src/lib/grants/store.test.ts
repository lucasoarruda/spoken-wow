/**
 * Grants against a real Postgres, for the activity rows they leave: a removed grant deletes
 * its own row, so the log is the only trace it ever existed.
 *
 * Needs DATABASE_URL and migrations applied.
 */
import { afterAll, beforeAll, describe, expect, it } from "vitest";

import { closeDb, db } from "@/lib/db";

import { addGrant, removeGrant } from "./store";

const GRANTEE = `test-grantee-${Math.random().toString(36).slice(2, 10)}`;
const GRANTER = `test-granter-${Math.random().toString(36).slice(2, 10)}`;

beforeAll(async () => {
  for (const id of [GRANTEE, GRANTER]) {
    await db().query(
      `insert into "user" ("id", "name", "email", "emailVerified") values ($1, $1, $2, false)`,
      [id, `${id}@example.invalid`],
    );
  }
});

afterAll(async () => {
  await db().query(`delete from "activity" where "subject" = $1`, [GRANTEE]);
  await db().query(`delete from "language_grant" where "userId" = $1`, [GRANTEE]);
  await db().query(`delete from "user" where "id" = any($1::text[])`, [[GRANTEE, GRANTER]]);
  await closeDb();
});

async function logged(kind: string) {
  const { rows } = await db().query(
    `select "lang", "actorId", "detail" from "activity" where "subject" = $1 and "kind" = $2`,
    [GRANTEE, kind],
  );
  return rows;
}

describe("removeGrant", () => {
  it("records who removed which grant, once, and nothing for a grant that was not there", async () => {
    await addGrant(GRANTEE, "ptBR", "edit", GRANTER);
    await removeGrant(GRANTEE, "ptBR", "edit", GRANTER);
    await removeGrant(GRANTEE, "ptBR", "edit", GRANTER);

    expect(await logged("grant.removed")).toEqual([
      { lang: "ptBR", actorId: GRANTER, detail: { capability: "edit" } },
    ]);
  });
});
