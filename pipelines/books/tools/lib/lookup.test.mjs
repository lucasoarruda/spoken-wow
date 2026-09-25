import { test } from "node:test";
import assert from "node:assert/strict";

import { lookupPath } from "./lookup.mjs";

test("English's lookup stays in the pack folder", () => {
  assert.match(lookupPath("enUS"), /addons\/SpokenBooksAudio\/Data\/Sounds\.lua$/);
});

test("another language's is build output, never in English's folder", () => {
  const path = lookupPath("esMX");
  assert.match(path, /build\/books\/esMX\/Data\/Sounds\.lua$/);
  assert.doesNotMatch(path, /addons\//);
});
