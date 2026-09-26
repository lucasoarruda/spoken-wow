/**
 * Deleting a clip leaves nothing on disk, so the activity row is the only record of it.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const { deleteSample, recordActivity } = vi.hoisted(() => ({
  deleteSample: vi.fn(async () => true),
  recordActivity: vi.fn(async () => {}),
}));

vi.mock("@/lib/voices/authz", () => ({
  requireVoiceManager: async () => ({ session: { user: { id: "admin" } }, denied: null }),
  requireVoiceViewer: async () => ({ denied: Response.json({}, { status: 403 }) }),
}));
vi.mock("@/lib/voices/samples", () => ({
  deleteSample,
  isStoredSampleName: () => true,
  samplePath: async () => "",
}));
vi.mock("@/lib/activity/store", () => ({ recordActivity }));
vi.mock("@/lib/lang-server", () => ({
  langParam: async (request: Request) => ({
    lang: new URL(request.url).searchParams.get("lang") ?? "enUS",
    denied: null,
  }),
}));

import { DELETE } from "./route";

const FILE = "1700000000000-abc.mp3";

function remove() {
  return DELETE(
    new Request(`https://example.com/api/voices/tauren-female-official/samples/${FILE}?lang=frFR`, {
      method: "DELETE",
    }),
    { params: Promise.resolve({ voice: "tauren-female-official", file: FILE }) },
  );
}

describe("DELETE /api/voices/[voice]/samples/[file]", () => {
  beforeEach(() => recordActivity.mockClear());

  it("records who deleted which clip, in the language it was deleted from", async () => {
    expect((await remove()).status).toBe(200);
    expect(recordActivity).toHaveBeenCalledWith({
      kind: "sample.deleted",
      lang: "frFR",
      actorId: "admin",
      subject: "tauren-female-official",
      detail: { files: [FILE] },
    });
  });

  it("records nothing when there was no such clip", async () => {
    deleteSample.mockResolvedValueOnce(false);
    expect((await remove()).status).toBe(404);
    expect(recordActivity).not.toHaveBeenCalled();
  });
});
