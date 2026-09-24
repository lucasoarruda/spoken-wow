"use client";

import { useRouter } from "next/navigation";
import { useCallback, useEffect, useRef, useTransition } from "react";

import { finishNavigation, startNavigation } from "./NavigationProgress";

/**
 * router.push, and whether the page it asked for has arrived yet.
 *
 * A filter or a pager that pushes to its own route gets no loading.tsx: the segment has not
 * changed, so the old rows stay up, unmarked, until the server re-renders them, and a click
 * on "Next" looked like it had done nothing. Pushing inside a transition is what lets the
 * caller say "working" in the meantime, and the bar across the top say it too.
 */
export function usePendingPush() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  const push = useCallback(
    (href: string) => {
      startNavigation();
      startTransition(() => router.push(href));
    },
    [router],
  );
  // The bar also stops when the URL moves, but a push to the URL already open never moves
  // it, and would leave the bar running. Only once this hook's own push has settled: on
  // mount it has pushed nothing, and would stop a bar some link click had started.
  const pushed = useRef(false);
  useEffect(() => {
    if (pending) pushed.current = true;
    else if (pushed.current) {
      pushed.current = false;
      finishNavigation();
    }
  }, [pending]);
  return { pending, push };
}
