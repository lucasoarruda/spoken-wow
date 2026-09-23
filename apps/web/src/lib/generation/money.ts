/**
 * Dollars as fish.audio costs are shown.
 *
 * A line on fish.audio costs a fraction of a cent, so two decimals would show most takes as
 * $0.00 -- which reads as free, and is the one thing an unpriced or cheap take must not look
 * like. Below a cent, four significant places; above it, cents.
 *
 * Free of server imports: the take history and the queue panel are client components.
 */
export function usd(value: number): string {
  if (value === 0) return "$0";
  if (Math.abs(value) < 0.01) return `$${value.toPrecision(2)}`;
  return `$${value.toFixed(2)}`;
}
