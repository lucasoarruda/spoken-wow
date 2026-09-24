/**
 * How long a fish.audio reference may be, and the check on a window: one module that both
 * the /voices panel and the route import, so the button and the server agree. Free of server
 * imports for the panel's sake; the rest of references.ts is server-only.
 */

/** fish.audio's guidance: shorter clones badly, longer only costs upload on every request. */
export const MIN_REFERENCE_SECONDS = 10;
export const MAX_REFERENCE_SECONDS = 30;
/** What the panel offers before anybody has chosen: a comfortable middle of the range. */
export const DEFAULT_REFERENCE_SECONDS = 20;

/** A reason to refuse a window, worth showing a human, or null. */
export function rejectWindow(startSec: number, endSec: number): string | null {
  if (!Number.isFinite(startSec) || !Number.isFinite(endSec)) return "the window must be numbers";
  if (startSec < 0) return "the window cannot start before the clip does";
  const length = endSec - startSec;
  if (length < MIN_REFERENCE_SECONDS || length > MAX_REFERENCE_SECONDS) {
    return `a reference must be ${MIN_REFERENCE_SECONDS}-${MAX_REFERENCE_SECONDS} seconds long, not ${length.toFixed(1)}`;
  }
  return null;
}
