import { Loading } from "@/components/Loading";

/**
 * Every page's fallback while the server renders it, unless its section has its own.
 *
 * Without a boundary a dynamic page is fetched whole before the router commits, so a click
 * on a link to /contributions or /admin left the old page up and silent until the database
 * answered, and read as a link that had not worked. With one, Link prefetches up to here and
 * the header and this spinner replace the old page the moment the link is clicked.
 */
export default function PageLoading() {
  return (
    <main className="mx-auto max-w-6xl px-5 pt-6 pb-36">
      <Loading label="Loading…" />
    </main>
  );
}
