/**
 * One owner's queue as the panel shows it.
 *
 * Its own module with no imports, because both sides need it: queue.ts builds it on the
 * server and the panel renders it in the client bundle, where queue.ts (which imports `pg`)
 * may not go.
 */
export type QueueLine = {
  /** Null for jobs whose batch nobody owns. */
  owner: string | null;
  /** The owner's name, or "Deleted account". */
  name: string;
  pending: number;
  running: number;
  /** Whether it is among the QUEUE_MAX_ACTIVE queues draining now. */
  status: "active" | "waiting";
  /** Queues ranked before this one; 0 for an active queue. */
  ahead: number;
  /** Whether the viewer owns it, so the panel can pick out theirs without a client session. */
  mine: boolean;
};

/** The part of a queue's row after its name. */
export function queueStatus(queue: QueueLine): string {
  const pending = `${queue.pending.toLocaleString("en-US")} pending`;
  if (queue.status === "waiting") return `waiting, ${queue.ahead} ahead · ${pending}`;
  return `${queue.running.toLocaleString("en-US")} running · ${pending}`;
}
