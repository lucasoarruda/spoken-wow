"use client";

import { useState } from "react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { SEED_STRATEGIES, type SeedStrategy, type VoiceSettings } from "@/lib/generation/config";
import type { Preference as ServerPreference } from "@/lib/generation/preference";

/** The models a collaborator may pick. Mirrors FISH_MODELS in lib/voices/fish.ts, which is server-side. */
export type FishModelOption = { id: string; label: string; preview: boolean; price: string };

/** An ElevenLabs model the collaborator's account may use, read from the account. */
export type ElevenLabsModelOption = { id: string; name: string };

// Type-only: erased from the bundle, so the form and the server cannot drift apart on shape.
type Preference = Pick<ServerPreference, "provider" | "elevenlabs" | "fish">;

const SEED_LABELS: Record<SeedStrategy, string> = {
  npc: "Per NPC — every line an NPC speaks draws the same way",
  none: "None — each line is an independent draw",
};

/** The three 0-1 voice settings, as the admin form described them before they moved here. */
const SLIDERS: { key: "stability" | "similarity_boost" | "style"; label: string; hint: string }[] = [
  {
    key: "stability",
    label: "Stability",
    hint: "Low varies the delivery between takes; high flattens it. 0.5 is the API's own default.",
  },
  {
    key: "similarity_boost",
    label: "Similarity",
    hint: "How hard the model tries to match the clone, including any noise in the source clips.",
  },
  {
    key: "style",
    label: "Style",
    hint: "Exaggerates the source's delivery. Costs latency, and above ~0.5 tends to drift.",
  },
];

/**
 * Which generator this collaborator's lines are made with, and how each is set up.
 *
 * Both providers' settings are the collaborator's own, because their own key pays for them,
 * and they apply to every language they generate. What stays per language, and an admin's,
 * is the race accent tags on /voices. A batch keeps the generator it was started with, so
 * switching here affects the next batch, not one that is running.
 */
export default function GeneratorSection({
  initial,
  hasFishKey,
  models,
  elevenLabsModels,
}: {
  initial: Preference;
  hasFishKey: boolean;
  models: FishModelOption[];
  /** From the account; null when there is no key to ask with, or the account would not say. */
  elevenLabsModels: ElevenLabsModelOption[] | null;
}) {
  const [saved, setSaved] = useState(initial);
  const [draft, setDraft] = useState(initial);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const changed = JSON.stringify(draft) !== JSON.stringify(saved);
  const fish = draft.fish;
  const setFish = (change: Partial<Preference["fish"]>) =>
    setDraft((current) => ({ ...current, fish: { ...current.fish, ...change } }));
  const eleven = draft.elevenlabs;
  const setEleven = (change: Partial<Preference["elevenlabs"]>) =>
    setDraft((current) => ({ ...current, elevenlabs: { ...current.elevenlabs, ...change } }));
  const setVoice = (change: Partial<VoiceSettings>) =>
    setEleven({ voiceSettings: { ...eleven.voiceSettings, ...change } });
  // The saved model stays offered even when the account no longer lists it, so opening the
  // page never silently changes it.
  const elevenOptions = [
    ...(elevenLabsModels ?? []),
    ...(elevenLabsModels?.some((model) => model.id === eleven.modelId)
      ? []
      : [{ id: eleven.modelId, name: eleven.modelId }]),
  ];

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

      <h3 className="mb-2 text-sm font-medium">ElevenLabs</h3>
      <div className="mb-2 grid max-w-md grid-cols-[8rem_1fr] items-center gap-x-3 gap-y-2 text-sm">
        <Label htmlFor="eleven-model">Model</Label>
        <select
          id="eleven-model"
          value={eleven.modelId}
          onChange={(event) => setEleven({ modelId: event.target.value })}
          className="border-input bg-background h-8 rounded-md border px-2 text-sm"
        >
          {elevenOptions.map((model) => (
            <option key={model.id} value={model.id}>
              {model.name}
            </option>
          ))}
        </select>

        {SLIDERS.map(({ key, label, hint }) => (
          <div key={key} className="contents">
            <Label htmlFor={`eleven-${key}`} title={hint}>
              {label}
            </Label>
            <Input
              id={`eleven-${key}`}
              type="number"
              min={0}
              max={1}
              step={0.05}
              title={hint}
              value={eleven.voiceSettings[key]}
              onChange={(event) => setVoice({ [key]: Number(event.target.value) })}
              className="h-8 w-24"
            />
          </div>
        ))}

        <Label htmlFor="eleven-boost">Speaker boost</Label>
        <input
          id="eleven-boost"
          type="checkbox"
          checked={eleven.voiceSettings.use_speaker_boost}
          onChange={(event) => setVoice({ use_speaker_boost: event.target.checked })}
          className="size-4 justify-self-start"
        />

        <Label htmlFor="eleven-seed">Seed</Label>
        <select
          id="eleven-seed"
          value={eleven.seedStrategy}
          onChange={(event) => setEleven({ seedStrategy: event.target.value as SeedStrategy })}
          className="border-input bg-background h-8 rounded-md border px-2 text-sm"
        >
          {SEED_STRATEGIES.map((strategy) => (
            <option key={strategy} value={strategy}>
              {SEED_LABELS[strategy]}
            </option>
          ))}
        </select>
      </div>
      <p className="text-muted-foreground mb-5 text-xs">
        {elevenLabsModels === null
          ? "The models your account offers appear once an ElevenLabs key is stored."
          : "The models your ElevenLabs account offers."}{" "}
        Accent tags per race stay with the language, on /voices.
      </p>

      <h3 className="mb-2 text-sm font-medium">fish.audio</h3>
      <div className="mb-4 grid max-w-md grid-cols-[8rem_1fr] items-center gap-x-3 gap-y-2 text-sm">
        <Label htmlFor="fish-model">Model</Label>
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
