"use client";

import { useState } from "react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import type { GrantRow } from "@/lib/grants/store";
import { CODES, langName, type Lang } from "@/lib/lang";
import { CAPABILITIES, canGrant, type Capability, type Viewer } from "@/lib/permissions";

/**
 * One person's languages: what they hold in each, every capability removable, and a way to
 * add another.
 *
 * Offers only what `viewer` may hand out (lib/permissions.ts `canGrant`), so a language
 * admin sees edit and regenerate in their own languages and nothing else. The server
 * refuses anything else whatever this offers.
 */
export default function GrantCell({
  grants,
  viewer,
  busy,
  onGrant,
  onRevoke,
}: {
  /** This person's grants, as far as the viewer may see them. */
  grants: GrantRow[];
  viewer: Viewer;
  busy: boolean;
  onGrant: (lang: Lang, capability: Capability) => Promise<boolean>;
  onRevoke: (lang: string, capability: Capability) => void;
}) {
  const byLang = new Map<string, Capability[]>();
  for (const grant of grants) byLang.set(grant.lang, [...(byLang.get(grant.lang) ?? []), grant.capability]);

  return (
    <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
      {[...byLang].map(([lang, capabilities]) => (
        <span key={lang} className="flex items-center gap-1">
          <span className="text-muted-foreground text-xs">{langName(lang as Lang)}</span>
          {capabilities.map((capability) => {
            const removable = canGrant(viewer, capability, lang as Lang);
            return (
              <Badge key={capability} variant="outline" className={removable ? "pr-0.5" : undefined}>
                {capability}
                {removable ? (
                  <button
                    type="button"
                    disabled={busy}
                    aria-label={`Remove ${capability} in ${langName(lang as Lang)}`}
                    className="text-muted-foreground hover:text-foreground rounded-full px-1 disabled:opacity-50"
                    onClick={() => onRevoke(lang, capability)}
                  >
                    ×
                  </button>
                ) : null}
              </Badge>
            );
          })}
        </span>
      ))}
      <AddGrant held={grants} viewer={viewer} busy={busy} onGrant={onGrant} />
    </div>
  );
}

function AddGrant({
  held,
  viewer,
  busy,
  onGrant,
}: {
  held: GrantRow[];
  viewer: Viewer;
  busy: boolean;
  onGrant: (lang: Lang, capability: Capability) => Promise<boolean>;
}) {
  const [open, setOpen] = useState(false);
  const missing = (lang: Lang) =>
    CAPABILITIES.filter(
      (capability) =>
        canGrant(viewer, capability, lang) &&
        !held.some((grant) => grant.lang === lang && grant.capability === capability),
    );
  const langs = CODES.filter((code) => missing(code).length > 0);
  const [lang, setLang] = useState<Lang | undefined>(langs[0]);
  const chosen = lang && langs.includes(lang) ? lang : langs[0];
  const capabilities = chosen ? missing(chosen) : [];
  const [capability, setCapability] = useState<Capability | undefined>(capabilities[0]);
  const chosenCapability = capability && capabilities.includes(capability) ? capability : capabilities[0];

  if (langs.length === 0) return null;

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button variant="ghost" size="xs" disabled={busy}>
          + Grant
        </Button>
      </PopoverTrigger>
      <PopoverContent align="start" className="flex w-auto items-center gap-2">
        <Select value={chosen} onValueChange={(value) => setLang(value as Lang)}>
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
        <Select value={chosenCapability} onValueChange={(value) => setCapability(value as Capability)}>
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
        <Button
          size="sm"
          disabled={busy || !chosen || !chosenCapability}
          onClick={() => {
            if (!chosen || !chosenCapability) return;
            void onGrant(chosen, chosenCapability).then((ok) => {
              if (ok) setOpen(false);
            });
          }}
        >
          Grant
        </Button>
      </PopoverContent>
    </Popover>
  );
}
