-- One fish.audio key per person, sealed, beside the ElevenLabs one.
--
-- fish.audio is a second generator a collaborator may choose instead of ElevenLabs, and it is
-- spent from the collaborator's own key for the reason 0018 gives for ElevenLabs: a server-
-- wide key would leave "who paid for this line" with no answer.
--
-- A table of its own rather than a "provider" column on "elevenlabs_key": that table's
-- primary key is "userId", and widening it to (userId, provider) is a change the release
-- before this one would not survive. Nothing is lost by the split; the two keys are never
-- read together.
--
-- The columns are 0018's, sealed the same way by src/lib/secrets.ts, less "tier": fish.audio
-- bills from a prepaid balance per byte, so there is no plan to record.
create table "fish_key" (
  "userId" text not null primary key references "user" ("id") on delete cascade,
  "ciphertext" text not null,
  "iv" text not null,
  "tag" text not null,
  "hint" text not null,
  -- When fish.audio last confirmed the key, which is when it was saved.
  "verifiedAt" timestamptz,
  "createdAt" timestamptz default CURRENT_TIMESTAMP not null,
  "updatedAt" timestamptz default CURRENT_TIMESTAMP not null
);
