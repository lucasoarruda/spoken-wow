/** The signed-in user's fish.audio key. The handlers, and their rules, are keyRoutes'. */
import { keyRoutes } from "@/lib/profile/key-routes";
import { getWallet } from "@/lib/voices/fish";

export const dynamic = "force-dynamic";

// The balance is free to read; fish.audio has no plans, so there is no tier to record.
export const { GET, POST, DELETE } = keyRoutes("fish", async (key) => {
  await getWallet({ apiKey: key });
  return { tier: null };
});
