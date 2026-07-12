# Project 03 — Play With Colours

> **🛠️ Stack for this lesson** — Svelte (legacy 3 routes-based) · Vite.
> 📥 Template: [/learn/w3/template/project-03-colours](/learn/w3/template/project-03-colours)

A working hex-palette editor — typing a hex code validates, previews, and adds it to a grid; you can copy a swatch by click and delete entries. The whole app lives in `src/routes/index.svelte`. Your job is to extend it with a native color picker that two-way-syncs with the text input, plus an export feature.

**Time:** ~75 minutes · **Concept:** Concept 07–10 · Project 03

---

## What You'll Build

| # | TODO | Where |
|---|------|-------|
| 1 | Add `<input type="color">` next to the text input and sync both via `bind:value` (or a reactive `$:` block) | `src/routes/index.svelte` |
| 2 | When typing a valid hex, push the normalized value into the picker; when picking, push it into the text input | `src/routes/index.svelte` |
| 3 | Add an **Export** button that copies the palette as JSON to the clipboard | `src/routes/index.svelte` |
| 4 | (Stretch) Persist the palette to `localStorage` so it survives a refresh | `src/routes/index.svelte` |

The validator, RGB conversion, contrast text-color logic, copy-to-clipboard, delete, clear-all, and empty state are all implemented.

## Run It

```bash
npm install
npm run dev
```

Open `http://localhost:5173`.

## Verify

- [ ] Typing `#FF5733` validates and the preview swatch matches; clicking *Add to Palette* adds the card.
- [ ] The native `<input type="color">` reflects the current text input when the hex is valid, and editing the picker updates the text input live.
- [ ] Invalid inputs (e.g. `#GGGGGG`, `12`) show the error feedback block.
- [ ] Duplicate hex codes are rejected with the existing duplicate message.
- [ ] **Export** copies a JSON array of `{name, hex, rgbString}` entries to the clipboard.
- [ ] No console errors; existing features (delete, clear-all, copy on swatch click) still work.

## Stretch

- Persist the palette to `localStorage` and rehydrate on mount.
- Add a "harmony" button that fills the picker with the complementary color (`(255 - r), (255 - g), (255 - b)`).
- Render an HSL readout next to the existing RGB and Brightness lines.

## 🪞 Reflect on Your Work

Answer in 2-3 sentences each, in this README under your TODO commits. Your tutor reads these as part of grading.

1. **What did you learn that you didn't know before?** Name the most surprising thing — `bind:value` on a color input, the way the validator differs from the picker's view of `#000000`, anything that bit you.
2. **How did you collaborate with AI?** If you used Claude / ChatGPT / Cursor / Copilot, what part of the work did *you* contribute — the prompt, the verification, the design decision, the bug-fix? If you didn't use AI, what was the hardest thing to figure out alone?
3. **How do you know your code works?** Describe one specific thing you did to confirm — a screenshot of a palette, a clipboard paste, a behavior you watched.

> AI is a great collaborator. Owning your thinking, verifying the output, and explaining your design choices is what *learning* looks like in this course.

## Grading Rubric

| Criterion | Weight | What we look for |
|-----------|--------|------------------|
| Color picker integration | 40% | Both inputs stay in sync without race conditions; invalid text doesn't corrupt the picker. |
| Export feature | 30% | Output is valid JSON, copies cleanly, uses the same shape as the in-app palette. |
| Reactivity hygiene | 20% | No infinite `$:` loops, no manual DOM updates, deletes/clears still flow through `colorsList`. |
| Polish | 10% | UI labels new controls clearly; existing styling stays consistent. |

## Submit

When the Verify checklist is green, head to **[/learn/w3/certification](/learn/w3/certification)** and submit your repo URL or zipped project (exclude `node_modules/`).

<!-- claude-template-fix: readme-v3 -->
