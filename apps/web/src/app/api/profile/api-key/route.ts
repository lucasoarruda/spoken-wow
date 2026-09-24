/** The signed-in user's ElevenLabs key. The handlers, and their rules, are keyRoutes'. */
import { keyRoutes } from "@/lib/profile/key-routes";
import { getSubscription } from "@/lib/voices/elevenlabs";

export const dynamic = "force-dynamic";

// The subscription call is free and answers with the plan, which the profile page shows.
export const { GET, POST, DELETE } = keyRoutes("elevenlabs", (key) => getSubscription({ apiKey: key }));
