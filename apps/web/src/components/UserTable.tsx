"use client";

import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";

import GrantCell, { GrantPicker } from "@/components/GrantCell";
import Pagination from "@/components/Pagination";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { authClient } from "@/lib/auth-client";
import type { GrantRow } from "@/lib/grants/store";
import type { Lang } from "@/lib/lang";
import {
  CAPABILITIES,
  canGrant,
  isAdmin,
  ROLES,
  type Capability,
  type Role,
  type Viewer,
} from "@/lib/permissions";

export type UserRow = {
  id: string;
  name: string | null;
  email: string;
  /** Present for a global admin's listing only, as are the joined date and the key. */
  role?: string | undefined;
  createdAt?: string;
};

const NONE: readonly GrantRow[] = [];

type Props = {
  users: UserRow[];
  /** Every grant the viewer may see: all of them for an admin, their languages' otherwise. */
  grants: GrantRow[];
  viewer: Viewer;
  /** The signed-in user, whose own role is deliberately not editable here. */
  currentUserId: string;
  /**
   * Who holds a key. Presence only - no value crosses this boundary. Null for a language
   * admin, who hands out nothing that spends on anybody else's behalf and so takes nothing
   * back.
   */
  keyedUserIds: string[] | null;
  /** Where a global admin's list is; null for a language admin's, which is not paged. */
  page: { page: number; pageCount: number } | null;
};

/** `users`, plus whoever in `grants` is not among them yet, in the order they turned up. */
function withGrantees(users: UserRow[], grants: readonly GrantRow[]): UserRow[] {
  const seen = new Map(users.map((user) => [user.id, user]));
  for (const grant of grants) {
    if (!seen.has(grant.userId)) {
      seen.set(grant.userId, { id: grant.userId, name: grant.name, email: grant.email });
    }
  }
  return seen.size === users.length ? users : [...seen.values()];
}

export default function UserTable({
  users: initialUsers,
  grants: initialGrants,
  viewer,
  currentUserId,
  keyedUserIds,
  page,
}: Props) {
  const router = useRouter();
  const global = isAdmin(viewer.role);
  // Busy is per row, or "new" for the form that lets somebody in by email.
  const [pendingId, setPendingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [keyed, setKeyed] = useState(() => new Set(keyedUserIds ?? []));
  const [grants, setGrants] = useState(initialGrants);
  // A language admin's list is the grant holders, since they cannot list the users. It only
  // ever grows: somebody let in by email joins it, and somebody whose last grant was just
  // removed stays until the page is reloaded rather than vanishing from under the pointer.
  // A global admin's is the page of users it was given, and the grants of anybody on
  // another page are not a reason to show them on this one.
  const adopt = (current: UserRow[], next: readonly GrantRow[]) =>
    global ? current : withGrantees(current, next);
  const [users, setUsers] = useState(() => adopt(initialUsers, initialGrants));

  const grantsOf = useMemo(() => {
    const byUser = new Map<string, GrantRow[]>();
    for (const grant of grants) {
      const held = byUser.get(grant.userId);
      if (held) held.push(grant);
      else byUser.set(grant.userId, [grant]);
    }
    return byUser;
  }, [grants]);

  async function sendGrant(busyKey: string, method: "PUT" | "DELETE", target: string, body?: unknown) {
    setPendingId(busyKey);
    setError(null);
    const response = await fetch(target, {
      method,
      headers: { "Content-Type": "application/json" },
      body: body === undefined ? undefined : JSON.stringify(body),
    }).catch(() => null);
    setPendingId(null);
    const data = (await response?.json().catch(() => ({}))) as { grants?: GrantRow[]; error?: string };
    if (!response?.ok || !data.grants) {
      setError(data?.error ?? "That did not work.");
      return false;
    }
    // The route answers with every grant the viewer may see, which is this table's.
    const next = data.grants;
    setGrants(next);
    setUsers((current) => adopt(current, next));
    return true;
  }

  const grant = (busyKey: string, email: string, lang: Lang, capability: Capability) =>
    sendGrant(busyKey, "PUT", "/api/grants", { email, lang, capability });

  const revoke = (userId: string, lang: Lang, capability: Capability) =>
    void sendGrant(userId, "DELETE", `/api/grants?${new URLSearchParams({ userId, lang, capability })}`);

  async function changeRole(userId: string, role: Role) {
    setPendingId(userId);
    setError(null);

    const { error } = await authClient.admin.setRole({ userId, role });

    if (error) {
      setError(error.message ?? "Could not change that role.");
    } else {
      setUsers((current) => current.map((user) => (user.id === userId ? { ...user, role } : user)));
    }
    setPendingId(null);
  }

  /**
   * Take back what a grant spends with.
   *
   * The counterpart of handing out regenerate: someone who leaves should not need psql to be
   * un-keyed. Removing is the whole of the power - an admin can see that a key exists and
   * delete it, never read it.
   */
  async function clearKey(userId: string) {
    setPendingId(userId);
    setError(null);

    const response = await fetch(`/api/profile/api-key?userId=${encodeURIComponent(userId)}`, {
      method: "DELETE",
    });

    if (!response.ok) {
      setError("Could not clear that key.");
    } else {
      setKeyed((current) => {
        const next = new Set(current);
        next.delete(userId);
        return next;
      });
    }
    setPendingId(null);
  }

  return (
    <>
      {error && (
        <p role="alert" className="text-destructive mb-3 text-sm">
          {error}
        </p>
      )}

      <table className="w-full text-sm">
        <thead>
          <tr className="text-muted-foreground border-b text-left text-xs">
            <th className="py-2 pr-3 font-normal">Name</th>
            <th className="py-2 pr-3 font-normal">Email</th>
            {global && <th className="py-2 pr-3 font-normal">Joined</th>}
            {global && <th className="py-2 pr-3 font-normal">Role</th>}
            <th className="py-2 pr-3 font-normal">Languages</th>
            {global && <th className="py-2 font-normal">Key</th>}
          </tr>
        </thead>
        <tbody>
          {users.length === 0 && (
            <tr>
              <td colSpan={3} className="text-muted-foreground py-2">
                Nobody works in your languages yet.
              </td>
            </tr>
          )}
          {users.map((user) => (
            <tr key={user.id} className="border-b align-top last:border-0">
              <td className="py-2 pr-3">{user.name}</td>
              <td className="text-muted-foreground py-2 pr-3">{user.email}</td>
              {global && (
                <td className="text-muted-foreground py-2 pr-3 whitespace-nowrap">
                  {user.createdAt?.slice(0, 10)}
                </td>
              )}
              {global && (
                <td className="py-2 pr-3">
                  <RoleCell
                    user={user}
                    self={user.id === currentUserId}
                    busy={pendingId === user.id}
                    onChange={(role) => changeRole(user.id, role)}
                  />
                </td>
              )}
              <td className="py-2 pr-3">
                {isAdmin(user.role) ? (
                  <span className="text-muted-foreground text-xs">every language, as admin</span>
                ) : (
                  <GrantCell
                    grants={grantsOf.get(user.id) ?? NONE}
                    viewer={viewer}
                    busy={pendingId === user.id}
                    onGrant={(lang, capability) => grant(user.id, user.email, lang, capability)}
                    onRevoke={(lang, capability) => revoke(user.id, lang, capability)}
                  />
                )}
              </td>
              {global && (
                <td className="py-2 whitespace-nowrap">
                  {keyed.has(user.id) ? (
                    <span className="flex items-center gap-2">
                      <span aria-label="key set">✓</span>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        disabled={pendingId === user.id}
                        onClick={() => clearKey(user.id)}
                      >
                        Clear
                      </Button>
                    </span>
                  ) : (
                    <span className="text-muted-foreground">—</span>
                  )}
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>

      {page && (
        <Pagination
          page={page.page}
          pageCount={page.pageCount}
          onPage={(next) => router.push(`?page=${next}`)}
        />
      )}

      {!global && (
        <AddByEmail
          viewer={viewer}
          busy={pendingId === "new"}
          onGrant={(email, lang, capability) => grant("new", email, lang, capability)}
        />
      )}
    </>
  );
}

function RoleCell({
  user,
  self,
  busy,
  onChange,
}: {
  user: UserRow;
  self: boolean;
  busy: boolean;
  onChange: (role: Role) => void;
}) {
  const role = user.role ?? "member";
  // No select for yourself: demoting the only admin would lock the last account out of the
  // only page that can undo it, leaving SQL as the only way back in.
  if (self) {
    return (
      <span className="flex items-center gap-2">
        <Badge variant="outline" className="uppercase">
          {role}
        </Badge>
        <span className="text-muted-foreground text-xs">you</span>
      </span>
    );
  }
  return (
    <Select value={role} disabled={busy} onValueChange={(value) => onChange(value as Role)}>
      <SelectTrigger className="w-32" aria-label={`Role for ${user.email}`}>
        <SelectValue />
      </SelectTrigger>
      <SelectContent>
        {ROLES.map((option) => (
          <SelectItem key={option} value={option}>
            {option}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}

/**
 * Letting somebody new into a language, for a language admin, who cannot see the users who
 * hold nothing there yet. By email: an address is what a translator gives somebody when
 * asking to be let in.
 */
function AddByEmail({
  viewer,
  busy,
  onGrant,
}: {
  viewer: Viewer;
  busy: boolean;
  onGrant: (email: string, lang: Lang, capability: Capability) => Promise<boolean>;
}) {
  const [email, setEmail] = useState("");
  return (
    <div className="mt-4">
      <GrantPicker
        offer={(lang) => CAPABILITIES.filter((cap) => canGrant(viewer, cap, lang))}
        busy={busy}
        onPick={(lang, capability) =>
          void onGrant(email, lang, capability).then((ok) => {
            if (ok) setEmail("");
          })
        }
      >
        <Input
          type="email"
          required
          placeholder="their registered email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          className="w-64"
        />
      </GrantPicker>
    </div>
  );
}
