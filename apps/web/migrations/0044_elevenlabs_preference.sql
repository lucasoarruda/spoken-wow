-- ElevenLabs settings become each collaborator's own, as fish.audio's already are (0041).
--
-- Until now the model, the voice settings and the seed strategy were an admin's, per language,
-- in generation_setting and generation_setting_locale, while fish.audio's were each
-- collaborator's. Two answers to "who decides how my lines sound" was one too many, and the
-- one that applies to both is the collaborator's: the key, and so the bill, is theirs.
--
-- "elevenlabs" is { modelId, voiceSettings, seedStrategy }, one set for every language. NULL
-- means the built-in defaults. The race accent tags do NOT move: they change the text that is
-- sent, which staleness hashes, so they stay one answer per language in generation_setting.
--
-- Everyone who already holds an ElevenLabs key is given today's English settings, so nobody's
-- next take sounds different because of this deploy. Only where English has a settings row:
-- without one, the built-in defaults were in force already, and NULL keeps them.
--
-- generation_setting's model, voice and seed columns are left in place and simply no longer
-- read by generation, because the release before this one still reads them.
alter table "generation_preference" add column "elevenlabs" jsonb;

insert into "generation_preference" ("userId", "elevenlabs")
select k."userId",
       jsonb_build_object(
         'modelId', s."modelId",
         'voiceSettings', s."voiceSettings",
         'seedStrategy', s."seedStrategy"
       )
  from "elevenlabs_key" k
  cross join "generation_setting" s
 where s."id"
on conflict ("userId") do update
   set "elevenlabs" = excluded."elevenlabs"
 where "generation_preference"."elevenlabs" is null;
