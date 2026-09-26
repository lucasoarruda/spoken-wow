/**
 * The game's own clips for a voice, which is what a clone is made from.
 *
 * voice/npc-lines holds Blizzard's NPC greeting barks sorted into
 * `<race-gender>/<flavor>/`, which is exactly the shape of a voice slot name. So a slot
 * addresses its own source material by splitting on the last dash - no mapping table, and
 * nothing to keep in sync when a flavor is added. A slot with no flavor reads the files
 * directly in `<race-gender>/`: bloodelf-female is seeded from one of the game's blood elf
 * sets that way.
 */
import { BASE_LANG } from "@/lib/lang";
import { parseCloneName } from "./clone-name";
import type { Dirent } from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";

import { NPC_LINES_DIR } from "@/lib/paths";
import { isVoiceSlot } from "./slots";

/**
 * Absolute paths of the clips for a voice, oldest name first.
 *
 * Empty for a slot the game has no voice sets for, like narrator-male, a pseudo-race for
 * gameobjects. Empty rather than throwing, because "nothing to seed from" is a normal state
 * and the caller has to handle it either way.
 */
/**
 * `clone` is a clone's name (clone-name.ts). Another language's barks are its own client's,
 * spoken by its own actors, and sit under <npc lines>/<lang>/ in the same layout; English's
 * stay where they are.
 */
export async function npcLineClips(clone: string): Promise<string[]> {
  const parsed = parseCloneName(clone);
  if (!parsed || !(await isVoiceSlot(parsed.voice))) throw new Error(`unknown voice slot ${clone}`);

  const [race, gender, flavor] = parsed.voice.split("-");
  const root = parsed.lang === BASE_LANG ? NPC_LINES_DIR : path.join(NPC_LINES_DIR, parsed.lang);
  // A bare slot's folder also holds its race-gender's flavor folders, so only files count.
  const dir = flavor ? path.join(root, `${race}-${gender}`, flavor) : path.join(root, `${race}-${gender}`);

  let entries: Dirent[];
  try {
    entries = await fs.readdir(dir, { withFileTypes: true });
  } catch {
    return [];
  }

  return entries
    .filter((entry) => entry.isFile())
    .map((entry) => entry.name)
    .filter((name) => !name.startsWith("."))
    .sort((a, b) => a.localeCompare(b))
    .map((name) => path.join(dir, name));
}
