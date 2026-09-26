-- What happened in a language, who did it, and when: one row per act.
--
-- Until now the answer was spread over a dozen tables and mostly lost. `take` and
-- `lexicon_change` were the only true histories. The text tables keep every version but
-- their restores only move `isCurrent`, so who put an old version back was never written
-- down. The rest -- take_ack, voice_clone, fish_reference, language, generation_setting --
-- are one row holding whoever touched them last, and deletes (an un-ignore, a removed grant,
-- a dropped voice sample) left nothing at all. A language admin asking "what changed in
-- Portuguese this week, and who did it" had no page to look at and no query to run.
--
-- ONE TABLE, WRITTEN BY THE APP, NOT A VIEW OVER THE OTHERS. A view can only show what the
-- other tables kept, and what they did not keep -- restores, deletes, the value a word had
-- before somebody changed it -- is most of what an audit is for.
--
-- WRITTEN IN THE SAME TRANSACTION AS THE ACT where there is one, so an event is never
-- recorded for a change that rolled back. See lib/activity/store.ts.
--
-- "lang" NULL means every language: an ignore that applies everywhere, or a change to
-- shared settings. Every language's log shows those rows.
--
-- "detail" is jsonb because each kind carries different facts (a take's version and cost,
-- a word's old and new rule, a grant's capability). The kinds and their details are typed
-- in lib/activity/kinds.ts; the database only checks the shape of the row.
create table "activity" (
  "id"      bigserial   primary key,
  "at"      timestamptz not null default now(),
  "lang"    text        check ("lang" ~ '^[a-z]{2}[A-Z]{2}$'),
  "kind"    text        not null,
  "source"  text        check ("source" in ('quests', 'zones', 'books')),
  -- What the act was about: a file, a word, a voice, a user, a report. Free text on purpose,
  -- since every kind points at something different; the page knows how to link each.
  "subject" text,
  "lineId"  text,
  "detail"  jsonb       not null default '{}',
  -- SET NULL like every provenance column here: the record of what somebody did outlives
  -- their account. Null also means the app itself, or a pipeline run with no user.
  "actorId" text        references "user" ("id") on delete set null
);

-- The page reads one language newest first, by keyset on ("at", "id").
create index "activity_lang_at_idx" on "activity" ("lang", "at" desc, "id" desc);
-- And the rows that belong to every language, which it merges in.
create index "activity_global_at_idx" on "activity" ("at" desc, "id" desc) where "lang" is null;
-- A queue batch's takes are folded under the batch's row: counted there, listed when opened.
-- Who has done anything in a language, for the page's person filter -- and what deleting a
-- user has to find to set null, which would otherwise scan the whole log.
create index "activity_actor_idx" on "activity" ("actorId", "lang");
create index "activity_batch_idx" on "activity" (("detail"->>'batchId'))
  where "kind" = 'take.generated';

-- BACKFILL from whatever the existing tables kept, so the log does not start empty. Each
-- row is placed at the time its source recorded. What those tables never kept -- restores,
-- deletes, a word's previous rule -- is not invented: the history starts with gaps, and the
-- app fills them from here on.

-- Staged in a temporary table first because several source columns never had a foreign key
-- to "user" (contribution, line_override), and hold ids of accounts since deleted. Those
-- become null, the same as SET NULL would have made them. Copied in time order, so ids
-- follow time for the history as they will from here on.
create temp table "activity_backfill" (like "activity" including defaults) on commit drop;

-- Takes the site or a pipeline cut. Imported takes are the bulk load of audio made before
-- this site existed, and belong to nobody's activity. A take the queue cut is tied to its
-- batch through the job that made it, so the page can fold a batch into one row.
insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select t."createdAt", t."lang", 'take.generated', t."source", t."file", t."lineId",
       jsonb_strip_nulls(jsonb_build_object(
         'version', t."version", 'provider', t."provider", 'credits', t."credits",
         'costUsd', t."costUsd", 'batchId', j."batchId")),
       t."createdBy"
  from "take" t
  left join "regeneration_job" j
    on j."source" = t."source" and j."lang" = t."lang" and j."file" = t."file"
   and j."version" = t."version" and j."state" = 'done'
 where t."origin" = 'generated';

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "detail", "actorId")
select b."createdAt", b."lang", 'batch.queued', b."source", b."id"::text,
       jsonb_build_object('batchId', b."id", 'label', b."label",
                          'count', (select count(*) from "regeneration_job" j where j."batchId" = b."id")),
       b."createdBy"
  from "regeneration_batch" b;

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "detail", "actorId")
select b."stoppedAt", b."lang", 'batch.stopped', b."source", b."id"::text,
       jsonb_strip_nulls(jsonb_build_object('batchId', b."id", 'label', b."label",
                                            'reason', b."stoppedBecause")),
       null
  from "regeneration_batch" b
 where b."stoppedAt" is not null;

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "actorId")
select a."ackedAt", a."lang", 'take.acked', a."source", a."file", a."ackedBy"
  from "take_ack" a;

-- The rule a word had before and after was never stored, so these rows carry the word only.
-- Only saves somebody made: every save through the site has a user. Rows without one come
-- in bulk -- thousands of "removed" a minute in the development database -- and would bury
-- every real change under them.
insert into "activity_backfill" ("at", "lang", "kind", "subject", "actorId")
select c."changedAt", c."lang", 'lexicon.' || c."kind", c."grapheme", c."changedBy"
  from "lexicon_change" c
 where c."changedBy" is not null;

-- Text versions somebody wrote. Extracted, scraped and translated versions came from a
-- pipeline, not a person, and would bury the edits under tens of thousands of rows.
insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select q."createdAt", q."lang", 'text.edited', 'quests', q."lineId", q."lineId",
       jsonb_strip_nulls(jsonb_build_object('version', q."version", 'variant', q."variant",
                                            'text', q."text", 'note', q."note", 'origin', q."origin")),
       q."editedBy"
  from "quest_line" q
 where q."origin" in ('edited', 'contributed');

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select b."createdAt", b."lang", 'text.edited', 'books', b."lineId", b."lineId",
       jsonb_strip_nulls(jsonb_build_object('version', b."version", 'text', b."text", 'note', b."note")),
       b."editedBy"
  from "book_line" b
 where b."origin" = 'edited';

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select l."createdAt", l."lang", 'text.edited', 'zones', l."lineId", l."lineId",
       jsonb_strip_nulls(jsonb_build_object('version', l."version", 'text', l."full",
                                            'short', l."short", 'note', l."note")),
       l."editedBy"
  from "lore_line" l
 where l."origin" = 'edited';

insert into "activity_backfill" ("at", "lang", "kind", "subject", "detail", "actorId")
select n."createdAt", n."lang", 'name.edited', n."kind" || ':' || n."entityId",
       jsonb_strip_nulls(jsonb_build_object('version', n."version", 'name', n."name", 'note', n."note")),
       n."editedBy"
  from "entity_name" n
 where n."origin" = 'edited';

-- One-row tables: only the latest act survives, so that is the one recorded.
insert into "activity_backfill" ("at", "lang", "kind", "subject", "detail", "actorId")
select g."grantedAt", g."lang", 'grant.added', g."userId",
       jsonb_build_object('capability', g."capability"), g."grantedBy"
  from "language_grant" g;

insert into "activity_backfill" ("at", "lang", "kind", "subject", "detail", "actorId")
select v."clonedAt", v."lang", 'voice.cloned', v."voice",
       jsonb_strip_nulls(jsonb_build_object('voiceId', v."voiceId", 'sampleCount', v."sampleCount")),
       v."clonedBy"
  from "voice_clone" v;

insert into "activity_backfill" ("at", "lang", "kind", "subject", "detail", "actorId")
select f."updatedAt", f."lang", 'reference.set', f."voice",
       jsonb_strip_nulls(jsonb_build_object('sample', f."sample", 'transcript', f."transcript")),
       f."updatedBy"
  from "fish_reference" f;

-- NPC identities are resolved once for every language, from the English side.
insert into "activity_backfill" ("at", "lang", "kind", "subject", "detail", "actorId")
select r."updatedAt", 'enUS', 'npc.resolved', r."npcKind" || ':' || r."npcId",
       jsonb_strip_nulls(jsonb_build_object('npcName', r."npcName", 'race', r."race",
                                            'gender', r."gender", 'flavor', r."flavor")),
       r."resolvedBy"
  from "npc_resolution" r
 where r."resolvedBy" is not null;

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select r."resolvedAt", r."lang", 'report.resolved', r."source", r."id"::text, r."lineId",
       jsonb_build_object('status', r."status", 'category', r."category"), r."resolvedBy"
  from "report" r
 where r."resolvedAt" is not null;

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "detail", "actorId")
select c."updatedAt", c."locale", 'contribution.resolved', c."source", c."id"::text,
       jsonb_build_object('status', c."status", 'key', c."key"), c."resolvedBy"
  from "contribution" c
 where c."resolvedBy" is not null and c."locale" ~ '^[a-z]{2}[A-Z]{2}$';

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select i."createdAt", i."lang", 'ignore.set', 'quests', i."lineId", i."lineId",
       jsonb_strip_nulls(jsonb_build_object('reason', i."reason")), i."createdBy"
  from "line_ignore" i;

insert into "activity_backfill" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select o."updatedAt", 'enUS', 'override.set', 'quests', o."file", o."lineId",
       jsonb_build_object('text', o."text"), o."updatedBy"
  from "line_override" o;

insert into "activity" ("at", "lang", "kind", "source", "subject", "lineId", "detail", "actorId")
select b."at", b."lang", b."kind", b."source", b."subject", b."lineId", b."detail", u."id"
  from "activity_backfill" b
  left join "user" u on u."id" = b."actorId"
 where b."at" is not null
 order by b."at", b."id";
