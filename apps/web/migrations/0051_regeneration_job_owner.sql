-- Who a job's queue belongs to, copied from its batch.
--
-- The queue is drained per owner now: each owner's jobs form their own queue, at most
-- QUEUE_MAX_ACTIVE of them drain at once, and which ones is decided by each owner's oldest
-- unfinished job. Ranking and claiming by owner through a join to regeneration_batch on every
-- claim could not use an index, so the owner rides on the job.
--
-- No foreign key: the batch already references "user" with on delete set null, and a job
-- whose owner was deleted keeps the old id, which still groups its jobs as one queue.
-- Additive and forward-only.

alter table "regeneration_job" add column if not exists "owner" text;

update "regeneration_job" j
   set "owner" = b."createdBy"
  from "regeneration_batch" b
 where b."id" = j."batchId"
   and j."owner" is null
   and b."createdBy" is not null;

create index if not exists "regeneration_job_lane"
  on "regeneration_job" ("owner", "provider", "id")
  where "state" in ('pending', 'running');
