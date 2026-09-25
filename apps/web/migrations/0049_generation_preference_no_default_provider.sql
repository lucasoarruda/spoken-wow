-- generation_preference."provider" no longer defaults to 'elevenlabs'.
--
-- The default generator is now fish.audio, and it is the code's to say (preference.ts,
-- defaultPreference), not the column's. The column only ever needs a value when somebody
-- chose one; a row made by saving settings before choosing anything leaves it NULL, which
-- reads as the default. With the old default, that first save pinned ElevenLabs as the
-- fallback for every language.
--
-- Existing rows keep what they hold: 'elevenlabs' there may have been a choice, and there is
-- no telling which. Forward-only.

alter table "generation_preference"
  alter column "provider" drop default,
  alter column "provider" drop not null;
