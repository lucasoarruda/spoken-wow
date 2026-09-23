"use client";

import { useState } from "react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

/** The models a collaborator may pick. Mirrors FISH_MODELS in lib/voices/fish.ts, which is server-side. */
export type FishModelOption = { id: string; label: string; preview: boolean; price: string };

type Preference = {
  provider: "elevenlabs" | "fish";
  fish: { model: string; temperature: number; topP: number; speed: number };
};

/**
 * Which generator this collaborator's lines are made with, and how fish.audio is set up.
 *
 * ElevenLabs' model and settings are an admin's and live on /voices; fish.audio's are the
 * collaborator's own, because their own balance pays for them. A batch keeps the generator
 * it was started with, so switching here affects the next batch, not one that is running.
 */
export default function GeneratorSection({
  initial,
  hasFishKey,
  models,
}: {
  initial: Preference;
  hasFishKey: boolean;
  models: FishModelOption[];
}) {
  const [saved, setSaved] = useState(initial);
  const [draft, setDraft] = useState(initial);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const changed = JSON.stringify(draft) !== JSON.stringify(saved);
  const fish = draft.fish;
  const setFish = (change: Partial<Preference["fish"]>) =>
    setDraft((current) => ({ ...current, fish: { ...current.fish, ...change } }));

  async function save() {
    setBusy(true);
    setError(null);
    try {
      const response = await fetch("/api/profile/generator", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(draft),
      });
      const body = (await response.json()) as { preference?: Preference; error?: string };
      if (!response.ok || !body.preference) throw new Error(body.error ?? "could not save");
      setSaved(body.preference);
      setDraft(body.preference);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  }

  return (
    <section className="max-w-xl">
      <h2 className="mb-1 font-medium">Generator</h2>
      <p className="text-muted-foreground mb-4 text-sm">
        Which service makes the lines you regenerate. A batch keeps the generator it was started
        with, so switching affects the next one.
      </p>

      {error && (
        <p role="alert" className="text-destructive mb-3 text-sm">
          {error}
        </p>
      )}

      <fieldset className="mb-4 flex flex-wrap gap-4 text-sm">
        <legend className="sr-only">Generator</legend>
        <label className="flex items-center gap-2">
          <input
            type="radio"
            name="provider"
            checked={draft.provider === "elevenlabs"}
            onChange={() => setDraft({ ...draft, provider: "elevenlabs" })}
          />
          ElevenLabs
        </label>
        <label
          className="flex items-center gap-2"
          title={hasFishKey ? undefined : "Store a fish.audio key below first."}
        >
          <input
            type="radio"
            name="provider"
            disabled={!hasFishKey}
            checked={draft.provider === "fish"}
            onChange={() => setDraft({ ...draft, provider: "fish" })}
          />
          fish.audio
          {!hasFishKey && <span className="text-muted-foreground text-xs">(needs a key)</span>}
        </label>
      </fieldset>

      <div className="mb-4 grid max-w-md grid-cols-[8rem_1fr] items-center gap-x-3 gap-y-2 text-sm">
        <Label htmlFor="fish-model">fish.audio model</Label>
        <select
          id="fish-model"
          value={fish.model}
          onChange={(event) => setFish({ model: event.target.value })}
          className="border-input bg-background h-8 rounded-md border px-2 text-sm"
        >
          {models.map((model) => (
            <option key={model.id} value={model.id}>
              {model.label} — {model.price}
            </option>
          ))}
        </select>

        <Label htmlFor="fish-temperature">Temperature</Label>
        <Input
          id="fish-temperature"
          type="number"
          min={0}
          max={1}
          step={0.05}
          value={fish.temperature}
          onChange={(event) => setFish({ temperature: Number(event.target.value) })}
          className="h-8 w-24"
        />

        <Label htmlFor="fish-top-p">Top P</Label>
        <Input
          id="fish-top-p"
          type="number"
          min={0}
          max={1}
          step={0.05}
          value={fish.topP}
          onChange={(event) => setFish({ topP: Number(event.target.value) })}
          className="h-8 w-24"
        />

        <Label htmlFor="fish-speed">Speed</Label>
        <Input
          id="fish-speed"
          type="number"
          min={0.5}
          max={2}
          step={0.05}
          value={fish.speed}
          onChange={(event) => setFish({ speed: Number(event.target.value) })}
          className="h-8 w-24"
        />
      </div>
      <p className="text-muted-foreground mb-4 text-xs">
        Temperature and Top P trade consistency for expressiveness; fish.audio&apos;s defaults are
        0.7 for both. {models.find((model) => model.id === fish.model)?.preview &&
          "Preview models may change or disappear without notice, and have no published price."}
      </p>

      <Button type="button" disabled={busy || !changed} onClick={save}>
        {busy ? "Saving…" : "Save"}
      </Button>
    </section>
  );
}
