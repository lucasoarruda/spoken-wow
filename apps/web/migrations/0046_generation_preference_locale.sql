-- Which generator a collaborator spends with, per language.
--
-- The choice moved from /profile to /voices, which is per language, and the two providers are
-- not equally ready everywhere: fish.audio can only voice a language that has references cut,
-- and ElevenLabs only one whose clones are in the collaborator's account. A single switch for
-- every language would make one of them fail every line in the other.
--
-- Only the choice is per language. The settings for each provider stay one set per user in
-- generation_preference, since a model or a stability is a property of how somebody likes
-- their lines to sound, not of the language they are in.
--
-- A separate table rather than a "lang" column on generation_preference: that table's primary
-- key is the user, and the release before this one still reads and upserts on it. No row here
-- falls back to generation_preference."provider", so nobody's generator changes on deploy.
create table "generation_preference_locale" (
  "userId" text not null references "user" ("id") on delete cascade,
  "lang" text not null check ("lang" ~ '^[a-z]{2}[A-Z]{2}$'),
  "provider" text not null check ("provider" in ('elevenlabs', 'fish')),
  "updatedAt" timestamptz default CURRENT_TIMESTAMP not null,
  primary key ("userId", "lang")
);
