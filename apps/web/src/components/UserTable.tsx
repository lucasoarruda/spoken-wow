"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import GrantCell from "@/components/GrantCell";
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
import { langName, type Lang } from "@/lib/lang";
import {
  CAPABILITIES,
  canGrant,
  isAdmin,
  langsWhere,
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
};

export default function UserTable({ users, grants: initialGrants, viewer, currentUserId, keyedUserIds }: Props) {
  const router = useRouter();
  const global = isAdmin(viewer.role);
  const [pendingId, setPendingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [keyed, setKeyed] = useState(() => new Set(keyedUserIds ?? []));
  const [grants, setGrants] = useState(initialGrants);

  // A language admin's list is whoever holds something in their languages, so somebody let
  // in by email joins it -- and stays, with nothing left, until the page is reloaded, rather
  // than vanishing from under the pointer that just removed their last grant.
  const [rows, setRows] = useState(users);
  const shown: UserRow[] = [
    ...rows,
    ...grants
      .filter((grant, index, all) => all.findIndex((other) => other.userId === grant.userId) === index)
      .filter((grant) => !rows.some((row) => row.id === grant.userId))
      .map((grant) => ({ id: grant.userId, name: grant.name, email: grant.email })),
  ];

  async function sendGrant(userId: string, method: "PUT" | "DELETE", target: string, body?: unknown) {
    setPendingId(userId);
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
    setGrants(data.grants);
    if (!global) setRows(shown);
    return true;
  }

  const grant = (user: { id: string; email: string }, lang: Lang, capability: Capability) =>
    sendGrant(user.id, "PUT", "/api/grants", { email: user.email, lang, capability });

  const revoke = (userId: string, lang: string, capability: Capability) =>
    void sendGrant(
      userId,
      "DELETE",
      `/api/grants?${new URLSearchParams({ userId, lang, capability })}`,
    );

  async function changeRole(userId: string, role: Role) {
    setPendingId(userId);
    setError(null);

    const { error } = await authClient.admin.setRole({ userId, role });

    if (error) {
      setError(error.message ?? "Could not change that role.");
    } else {
      router.refresh();
      setRows((current) => current.map((row) => (row.id === userId ? { ...row, role } : row)));
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
          {shown.length === 0 && (
            <tr>
              <td colSpan={2} className="text-muted-foreground py-2">
                Nobody works in your languages yet.
              </td>
            </tr>
          )}
          {shown.map((user) => (
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
                    grants={grants.filter((row) => row.userId === user.id)}
                    viewer={viewer}
                    busy={pendingId === user.id}
                    onGrant={(lang, capability) => grant(user, lang, capability)}
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

      {!global && (
        <AddByEmail
          viewer={viewer}
          busy={pendingId !== null}
          onGrant={(email, lang, capability) => grant({ id: "", email }, lang, capability)}
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
  const langs = langsWhere(viewer, "admin");
  const [email, setEmail] = useState("");
  const [lang, setLang] = useState<Lang | undefined>(langs[0]);
  const [capability, setCapability] = useState<Capability>("edit");
  const capabilities = lang ? CAPABILITIES.filter((cap) => canGrant(viewer, cap, lang)) : [];

  return (
    <form
      className="mt-4 flex flex-wrap items-center gap-2"
      onSubmit={(event) => {
        event.preventDefault();
        if (!lang) return;
        void onGrant(email, lang, capability).then((ok) => {
          if (ok) setEmail("");
        });
      }}
    >
      <Input
        type="email"
        required
        placeholder="their registered email"
        value={email}
        onChange={(event) => setEmail(event.target.value)}
        className="w-64"
      />
      <Select value={lang} onValueChange={(value) => setLang(value as Lang)}>
        <SelectTrigger className="w-40" aria-label="Language">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {langs.map((code) => (
            <SelectItem key={code} value={code}>
              {langName(code)}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <Select value={capability} onValueChange={(value) => setCapability(value as Capability)}>
        <SelectTrigger className="w-32" aria-label="Capability">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          {capabilities.map((cap) => (
            <SelectItem key={cap} value={cap}>
              {cap}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <Button type="submit" size="sm" disabled={busy || !lang}>
        Grant
      </Button>
    </form>
  );
}
