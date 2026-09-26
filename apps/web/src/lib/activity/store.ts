/**
 * Writing and reading the activity log (migration 0050).
 *
 * WRITE INSIDE THE ACT'S TRANSACTION when it has one: pass its client, and the event
 * commits or rolls back with the change it describes. A write with no transaction to join
 * -- a file on disk, a one-statement upsert -- is recorded after the act succeeds, never
 * before, so the log does not claim things that failed.
 *
 * NEVER LET THE LOG BREAK THE ACT. Outside a transaction, a failure to record is logged and
 * swallowed: somebody regenerating a line should get their take whether or not the audit
 * row landed. Inside one, the error propagates like any other statement's, because
 * swallowing it would leave the transaction aborted anyway.
 */
import "server-only";

import type { PoolClient } from "pg";

import { db } from "@/lib/db";
import type { Lang } from "@/lib/lang";
import type { Source } from "@/lib/sections";

import { prefixesOf, type ActivityDetail, type ActivityKind, type Category } from "./kinds";

export type ActivityEvent<K extends ActivityKind = ActivityKind> = {
  kind: K;
  /** Null for an act that applies to every language. */
  lang: Lang | null;
  /** Null for the app itself, or a pipeline run with no user. */
  actorId: string | null;
  source?: Source | null;
  subject?: string | null;
  lineId?: string | null;
  detail: ActivityDetail[K];
};

const INSERT = `insert into "activity" ("lang", "kind", "source", "subject", "lineId", "detail", "actorId")
                select "lang", "kind", "source", "subject", "lineId", coalesce("detail", '{}'), "actorId"
                  from jsonb_to_recordset($1::jsonb) as r("lang" text, "kind" text, "source" text,
                       "subject" text, "lineId" text, "detail" jsonb, "actorId" text)`;

/** Record one act, as part of `client`'s transaction when given. */
export async function recordActivity<K extends ActivityKind>(
  event: ActivityEvent<K>,
  client?: Pick<PoolClient, "query">,
): Promise<void> {
  await recordActivities([event], client);
}

/**
 * Record many acts in one statement: clearing a search's worth of dirty takes is one click
 * and can be a thousand files, which as a thousand inserts would hold the request open.
 */
export async function recordActivities(
  events: ActivityEvent[],
  client?: Pick<PoolClient, "query">,
): Promise<void> {
  if (!events.length) return;
  const rows = JSON.stringify(
    events.map((event) => ({
      lang: event.lang,
      kind: event.kind,
      source: event.source ?? null,
      subject: event.subject ?? null,
      lineId: event.lineId ?? null,
      detail: event.detail,
      actorId: event.actorId,
    })),
  );
  if (client) {
    await client.query(INSERT, [rows]);
    return;
  }
  try {
    await db().query(INSERT, [rows]);
  } catch (error) {
    console.error(`activity: could not record ${events.length} ${events[0].kind}`, error);
  }
}

export type ActivityRow = {
  id: string;
  at: string;
  lang: Lang | null;
  kind: ActivityKind;
  source: Source | null;
  subject: string | null;
  lineId: string | null;
  detail: Record<string, unknown>;
  actorId: string | null;
  actorName: string | null;
  /** For a grant: the name of whoever received it, since the subject is only their id. */
  subjectName: string | null;
  /** For a queued batch: how many of its takes have been cut so far. */
  takes?: number;
};

/**
 * Where the next page starts. "at" is Postgres' own text for the timestamp, not a JS Date's:
 * a Date keeps milliseconds and the column keeps microseconds, so a cursor rounded through
 * one would skip every row in the same millisecond as the last one shown.
 */
export type Cursor = { at: string; id: string };

export type ActivityFilter = {
  lang: Lang;
  category?: Category;
  actorId?: string;
  source?: Source;
  /** Inclusive, ISO dates. */
  from?: string;
  to?: string;
  before?: Cursor;
  limit?: number;
};

const COLUMNS = `a."id"::text as "id", a."at", a."lang", a."kind", a."source", a."subject",
                 a."lineId", a."detail", a."actorId", u."name" as "actorName",
                 s."name" as "subjectName", a."at"::text as "cursorAt"`;

const JOINS = `left join "user" u on u."id" = a."actorId"
               left join "user" s on a."kind" like 'grant.%' and s."id" = a."subject"`;

type Row = Omit<ActivityRow, "at"> & { at: Date; cursorAt: string };

/**
 * One page of a language's log, newest first, with the rows that belong to every language
 * merged in.
 *
 * TAKES A BATCH CUT ARE LEFT OUT and counted on the batch's row instead. A batch of three
 * hundred lines would otherwise be three hundred rows, pushing everything else that
 * happened that day off the page; batchTakes lists them when the row is opened.
 *
 * Keyset rather than offset: rows are added at the top while somebody pages down, and an
 * offset would show them the same rows twice.
 */
export async function listActivity(
  filter: ActivityFilter,
): Promise<{ rows: ActivityRow[]; next: Cursor | null }> {
  const limit = filter.limit ?? 50;
  const where = [`not (a."kind" = 'take.generated' and a."detail" ? 'batchId')`];
  const values: unknown[] = [filter.lang];
  const add = (clause: (n: number) => string, value: unknown) => {
    values.push(value);
    where.push(clause(values.length));
  };

  if (filter.category) {
    add((n) => `split_part(a."kind", '.', 1) = any($${n}::text[])`, prefixesOf(filter.category));
  }
  if (filter.actorId) add((n) => `a."actorId" = $${n}`, filter.actorId);
  if (filter.source) add((n) => `a."source" = $${n}`, filter.source);
  if (filter.from) add((n) => `a."at" >= $${n}::date`, filter.from);
  // The whole of the last day, not its first instant.
  if (filter.to) add((n) => `a."at" < $${n}::date + 1`, filter.to);
  if (filter.before) {
    values.push(filter.before.at, filter.before.id);
    where.push(`(a."at", a."id") < ($${values.length - 1}::timestamptz, $${values.length}::bigint)`);
  }
  values.push(limit + 1);
  const n = values.length;

  // The language's rows and the every-language rows as two branches, each newest first
  // under its own index and stopping at a page, merged afterwards. One `lang = $1 or lang
  // is null` reads as neither index, and Postgres sorts the language's whole history to
  // show fifty rows of it.
  const branch = (lang: string) => `(
      select a.* from "activity" a
       where ${lang} and ${where.join(" and ")}
       order by a."at" desc, a."id" desc
       limit $${n})`;

  const { rows } = await db().query<Row>(
    `select ${COLUMNS},
            case when a."kind" = 'batch.queued' then (
              select count(*)::int from "activity" t
               where t."kind" = 'take.generated' and t."detail"->>'batchId' = a."detail"->>'batchId'
            ) end as "takes"
       from (${branch(`a."lang" = $1`)} union all ${branch(`a."lang" is null`)}) a
       ${JOINS}
      order by a."at" desc, a."id" desc
      limit $${n}`,
    values,
  );

  const page = rows.slice(0, limit);
  const last = page.at(-1);
  return {
    rows: page.map(serialise),
    next: rows.length > limit && last ? { at: last.cursorAt, id: last.id } : null,
  };
}

/** The takes one queue batch cut, newest first. What a batch's row shows when opened. */
export async function batchTakes(lang: Lang, batchId: string): Promise<ActivityRow[]> {
  const { rows } = await db().query<Row>(
    `select ${COLUMNS}
       from "activity" a
       ${JOINS}
      where a."lang" = $1 and a."kind" = 'take.generated' and a."detail"->>'batchId' = $2
      order by a."at" desc, a."id" desc`,
    [lang, batchId],
  );
  return rows.map(serialise);
}

/** Everybody who has done anything in a language, for the person filter. */
export async function activityActors(lang: Lang): Promise<{ id: string; name: string }[]> {
  const { rows } = await db().query<{ id: string; name: string }>(
    `select u."id", u."name" from "user" u
      where exists (select 1 from "activity" a
                     where a."actorId" = u."id" and (a."lang" = $1 or a."lang" is null))
      order by u."name"`,
    [lang],
  );
  return rows;
}

function serialise(row: Row): ActivityRow {
  const { takes, cursorAt: _, ...rest } = row;
  return {
    ...rest,
    at: row.at.toISOString(),
    ...(takes === null || takes === undefined ? {} : { takes }),
  };
}
