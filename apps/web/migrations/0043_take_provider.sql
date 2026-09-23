-- Which generator made a take, and what it cost in money rather than credits.
--
-- "provider" defaults to 'elevenlabs', which is true of every take and job that exists, so
-- nothing is backfilled and the release before this one, which never writes the column, keeps
-- writing true rows.
--
-- "costUsd" is fish.audio's cost, which is dollars per byte and not ElevenLabs credits. It is
-- a column of its own rather than a reuse of "credits", because a sum over "credits" that
-- quietly added dollars to credits would be wrong without looking wrong. Either may be NULL:
-- a provider that did not say is a reason to report nothing, not to invent a number.
--
-- A job's provider is written when it is queued, not when it runs: the estimate the batch was
-- started on was for that provider, and a collaborator switching mid-batch must not move the
-- jobs already waiting to the other one.
alter table "take" add column "provider" text not null default 'elevenlabs'
  check ("provider" in ('elevenlabs', 'fish'));
alter table "take" add column "costUsd" numeric;

alter table "regeneration_job" add column "provider" text not null default 'elevenlabs'
  check ("provider" in ('elevenlabs', 'fish'));
alter table "regeneration_job" add column "costUsd" numeric;
