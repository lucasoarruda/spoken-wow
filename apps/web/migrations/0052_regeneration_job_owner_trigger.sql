-- A job's owner is filled in from its batch by the database, whoever inserts it.
--
-- 0051 copied the owner onto every job once, and the new enqueue writes it on every insert.
-- But activate.sh applies migrations before the pm2 reload, and a rollback runs the old code
-- against the new schema: in both windows the old enqueue is live, inserting jobs that name no
-- owner. The backfill does not run again, so those jobs would stay in the queue nobody owns
-- for good - drained as one shared queue, on the wrong key, under "Deleted account".
--
-- A trigger closes that for every writer, old or new, rather than trusting each release to
-- remember. It only fills a null: an insert that names the owner is left alone, and a batch
-- nobody owns leaves it null, which is what enqueue would have written anyway.
--
-- The backfill below repeats 0051's, for whatever an old release inserted between 0051 and
-- this. Re-runnable, additive and forward-only.

create or replace function "regeneration_job_owner_from_batch"() returns trigger
language plpgsql as $$
begin
  if new."owner" is null then
    select b."createdBy" into new."owner"
      from "regeneration_batch" b
     where b."id" = new."batchId";
  end if;
  return new;
end;
$$;

drop trigger if exists "regeneration_job_owner_from_batch" on "regeneration_job";
create trigger "regeneration_job_owner_from_batch"
  before insert on "regeneration_job"
  for each row execute function "regeneration_job_owner_from_batch"();

update "regeneration_job" j
   set "owner" = b."createdBy"
  from "regeneration_batch" b
 where b."id" = j."batchId"
   and j."owner" is null
   and b."createdBy" is not null;
