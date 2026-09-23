-- The clip each voice slot is spoken from on fish.audio, per language.
--
-- fish.audio is used zero-shot: every request carries 10-30 seconds of the voice and its
-- exact transcript, and nothing is cloned into anybody's account. So unlike an ElevenLabs
-- clone, which lives in the account of whoever made it, a reference lives here and works
-- with every collaborator's key.
--
-- It is cut from a clip already on /voices rather than uploaded again: "sample" names the
-- file under voice/samples, and the window is where in it. The trimmed clip itself is kept
-- beside the samples, at voice/references/<lang>/<voice>.mp3.
--
-- "transcript" comes from fish.audio's speech-to-text and may be corrected by hand; fish.audio
-- is explicit that cloning quality depends on it matching the audio exactly. "clipHash" is a
-- sha-256 of the trimmed clip and the transcript together, and is what a take records as its
-- voiceId, so a re-cut reference is visible in the history of every take made after it.
create table "fish_reference" (
  "voice" text not null,
  "lang" text not null check ("lang" ~ '^[a-z]{2}[A-Z]{2}$'),
  "sample" text not null,
  "startSec" real not null,
  "endSec" real not null,
  "transcript" text not null,
  "clipHash" text not null,
  "updatedBy" text references "user" ("id") on delete set null,
  "updatedAt" timestamptz default CURRENT_TIMESTAMP not null,
  primary key ("voice", "lang"),
  -- fish.audio's own guidance is 10-30 seconds; shorter clones badly, longer only costs upload.
  check ("endSec" - "startSec" between 10 and 30)
);
