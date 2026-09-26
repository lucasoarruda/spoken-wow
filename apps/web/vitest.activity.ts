/**
 * Keep test runs out of the activity log of the database they share.
 *
 * The suite runs against whatever DATABASE_URL names, which locally is the development
 * database the site itself reads -- and nearly every write the tests exercise now records an
 * activity row. Most of those are nobody's (a take cut by a stub, a batch the worker stops),
 * and the rest belong to users a test creates and deletes, which SET NULL leaves as nobody's
 * too. Left alone, one run buries the real log under hundreds of rows by "system".
 *
 * So the run remembers the newest row when it starts and, when it ends, deletes the unowned
 * rows after it. Owned rows are left: a test that writes as a real account cleans up after
 * itself, and a person using the site during the run should keep their history. Something
 * the site's own queue does as nobody in those same minutes is lost with the tests' rows,
 * which is the price of sharing one database.
 */
import type { TestProject } from "vitest/node";
import { Client } from "pg";

async function connect(project: TestProject): Promise<Client | null> {
  const url = process.env.DATABASE_URL ?? project.config.env?.DATABASE_URL;
  if (!url) return null;
  const client = new Client({ connectionString: url });
  try {
    await client.connect();
    await client.query(`select 1 from "activity" limit 1`);
    return client;
  } catch {
    // No database, or not migrated: the suites that need one say so themselves.
    await client.end().catch(() => {});
    return null;
  }
}

export default async function setup(project: TestProject) {
  const client = await connect(project);
  if (!client) return;
  const { rows } = await client.query<{ id: string }>(
    `select coalesce(max("id"), 0)::text as "id" from "activity"`,
  );
  await client.end();
  const last = rows[0].id;

  return async () => {
    const after = await connect(project);
    if (!after) return;
    try {
      await after.query(`delete from "activity" where "id" > $1::bigint and "actorId" is null`, [last]);
    } finally {
      await after.end();
    }
  };
}
