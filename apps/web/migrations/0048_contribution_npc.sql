-- The NPC a moderator named for a quest contribution whose envelope named none.
--
-- Some envelopes reach triage with no `npc` at all -- a quest keyed on quest and event, or a
-- client that could not read its target. The moderator who knows who speaks the line fills in
-- the id and the name here, on the contribution, beside the kind 0033 already keeps: `meta`
-- stays exactly what the player's client sent. Every reader (the triage page, accept, the
-- export) treats a row with these set as if its envelope had carried `npc`.
--
-- Both or neither: an id with no name, or a name with no id, is not an answer. Null for every
-- row whose envelope named its own NPC. Additive and forward-only.

alter table "contribution"
  add column if not exists "npcId" integer,
  add column if not exists "npcName" text;

alter table "contribution"
  add constraint "contribution_npc_both_check" check (("npcId" is null) = ("npcName" is null));
