"use client";

import { useRouter } from "next/navigation";
import { useCallback, useTransition } from "react";

/**
 * router.push, and whether the page it asked for has arrived yet.
 *
 * A filter or a pager that pushes to its own route gets no loading.tsx: the segment has not
 * changed, so the old rows stay up, unmarked, until the server re-renders them, and a click
 * on "Next" looked like it had done nothing. Pushing inside a transition is what lets the
 * caller say "working" in the meantime.
 */
export function usePendingPush() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  const push = useCallback(
    (href: string) => startTransition(() => router.push(href)),
    [router],
  );
  return { pending, push };
}
