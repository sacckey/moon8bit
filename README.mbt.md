# moon8bit

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

The core idea is simple:
- Keep assets text-first (DSL), not binary-first.
- Keep gameplay deterministic (fixed-step update).
- Keep output portable (MoonBit + Web/Wasm-ready runtime model).

## SCC Scope Snapshot

- Engineering Goal: make AI-assisted retro game iteration practical in MoonBit.
- Target Users: solo developers/small teams building pixel-style prototypes and learners exploring MoonBit systems code.
- Architecture Idea: `DSL parser -> runtime model -> renderer -> web demo`, with CLI and tests wired to the same core package.
- Feasibility Today: playable driftbird demo, reproducible commands, parser/error tests, runtime determinism tests.

## Environment Requirements

- OS: macOS/Linux (current local verification environment: macOS/Darwin)
- MoonBit toolchain: `moon 0.1.20260209`
- Python: `Python 3.9.6` (for `python3 -m http.server`)
- Browser: a modern browser with Canvas 2D support (Chrome/Safari/Edge class)

## Current MVP

Implemented in this repository:
- Public engine API:
  - `EngineConfig`
  - `Game` trait with `init/update/draw`
  - `Sprite`, `Tilemap`, `Palette`, `AssetBundle`
- Asset DSL v1 parser:
  - `palette`, `sprite`, `tilemap`, `end`
  - line-numbered parse errors
- Asset conversion helper:
  - DSL -> JSON string
- Sample game:
  - driftbird side scroller
  - flap/reset input
  - collision detection and scrolling obstacles
  - engine-level `Collider` API usage for overlap detection
- CLI:
  - `demo`
  - `sample-dsl`
  - `assets`

## Quick Start

```bash
moon check
moon test
moon run cmd/main -- demo 60
```

## Evaluator Quickstart (3-5 min)

```bash
moon check
moon test
moon build --target js cmd/web
python3 -m http.server 8000
# open http://localhost:8000/demo/
```

Then in browser:

1. Press `Space` to start and flap.
2. Edit a tile value in DSL and click `Apply DSL`.
3. Confirm the scene changes and status line updates (`score`, `frame`, `hit`).

Run browser demo (Canvas 2D):

```bash
moon build --target js cmd/web
python3 -m http.server 8000
# open http://localhost:8000/demo/
```

Update GitHub Pages demo bundle (`demo/web.js`):

```bash
./scripts/update_demo_bundle.sh
```

GitHub Pages path (if Pages serves from root):

```text
https://<github-user>.github.io/<repo>/demo/
```

Controls:
- `Space` / `ArrowUp`: start, restart, and flap (one jump per key press)
- `R`: reset
- edit DSL in the textarea and click `Apply DSL` (or `Ctrl/Cmd + Enter`)
- `Export DSL`: download current editor text as `moon8bit_assets.dsl`
- `Import DSL`: load a local `.dsl`/`.txt` file into the editor and apply it
- status line shows `hit=<tag>` after collisions (`ground`, `ceiling`, `pipe_top`, `pipe_bottom`)

Convert DSL text to JSON:

```bash
moon run cmd/main -- assets "sprite hero 2 1\\n11\\nend"
```

Convert DSL file to JSON file (`--target js`):

```bash
moon run cmd/main --target js -- assets-file assets.dsl assets.json
```

Print built-in sample DSL:

```bash
moon run cmd/main -- sample-dsl
```

## DSL v1

### Palette

```text
palette dawn
color 0 #0f1a20
color 1 #274060
end
```

### Sprite

```text
sprite bird 5 3
.666.
64646
.666.
end
```

- `.` means transparent (`-1`)
- `0-9`, `a-f`, `A-F` are palette indices

### Tilemap

```text
tilemap ground 8 2
5 5 5 5 5 5 5 5
3 3 3 3 3 3 3 3
end
```

- `ground` is used for the scrolling floor band.
- `bg` is used for the scrolling background layer.

## Engine Model

- `init`: create/reset game state.
- `update`: fixed-step state transition (deterministic).
- `draw`: pure frame generation from current state.

This structure makes generated game code easy for AI to produce and refactor.

## Collision Model

- Engine provides reusable primitives: `Rect` + `Collider`.
- Games build tagged colliders and choose collision responses in game logic.
- The driftbird sample stores `last_hit_tag` (e.g. `ground`, `pipe_top`) for explainable game-over behavior.

## Why AI-Friendly

- Text DSL is easy to prompt, diff, review, and regenerate.
- Line-numbered parser errors are easy to feed back into iterative AI loops.
- Deterministic game loop makes AI-generated tests stable.

## Baseline and Differentiation

- Baseline capabilities we are pursuing as a practical engine:
  - playable rendering paths (Canvas now, WebGPU path as next milestone)
  - practical audio path (BGM + SFX)
  - minimal GUI authoring path (sprite + sound)
- moon8bit-specific value:
  - text-first asset workflow for AI iteration
  - deterministic runtime and reproducible validation
  - compact MoonBit codebase that remains easy to inspect

## Context Harness (Anti-Drift)

To avoid goal drift across daily AI-assisted sessions, keep these docs updated:

- `docs/north-star.md`: project mission, scope, and non-goals.
- `docs/session-brief.md`: session start checklist (today focus and out-of-scope).
- `docs/decision-log.md`: short architecture/product decisions with reasons.
- `docs/handoff.md`: session end `Done / Next / Risks`.
- `docs/ai-usage-log.md`: retrospective log of AI usage.

Recommended routine:

1. Start session by reading `north-star` and writing `session-brief`.
2. During work, append major decisions to `decision-log`.
3. End session by writing `handoff` and updating `ai-usage-log`.

## Submission Prep

- `docs/submission-checklist.md`: final pre-submit checklist.
- `docs/demo-script.md`: 30-45 second demo recording flow.
- `docs/application-draft.md`: current submission description draft.

## Validation

This repository currently includes:
- DSL success/error tests
- Deterministic engine tests
- Integration test for driftbird sample loop

Run everything:

```bash
moon test
```
