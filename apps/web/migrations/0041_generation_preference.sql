-- Which generator a collaborator spends with, and how they have set fish.audio up.
--
-- The choice is the collaborator's, not the site's: each generates with their own key, and a
-- pack may therefore hold takes from both providers. take."provider" (0043) is what says
-- which made each one.
--
-- "fish" is the collaborator's own fish.audio settings -- { model, temperature, top_p, speed }
-- -- and NULL means fish.audio's defaults. ElevenLabs settings are not here: they stay an
-- admin's, per language, in generation_setting.
--
-- No row means ElevenLabs, which is what everybody generated with before this existed.
create table "generation_preference" (
  "userId" text not null primary key references "user" ("id") on delete cascade,
  "provider" text not null default 'elevenlabs' check ("provider" in ('elevenlabs', 'fish')),
  "fish" jsonb,
  "updatedAt" timestamptz default CURRENT_TIMESTAMP not null
);
