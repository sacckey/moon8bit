# moon8bit

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

The core idea is simple:
- Keep assets text-first (DSL), not binary-first.
- Keep gameplay deterministic (fixed-step update).
- Keep output portable (MoonBit + Web/Wasm-ready runtime model).

## SCC Scope Snapshot

- Engineering Goal: make AI-assisted retro game iteration practical in MoonBit.
- Target Users: solo developers/small teams building pixel-style prototypes and learners exploring MoonBit systems code.
- Architecture Idea: `DSL parser -> runtime model -> renderer -> per-game web entry`, with CLI and tests wired to the same core package.
- Feasibility Today: playable driftbird demos, reproducible commands, parser/error tests, runtime determinism tests.

## Environment Requirements

- OS: macOS/Linux (current local verification environment: macOS/Darwin)
- MoonBit toolchain: `moon 0.1.20260209`
- Python: `Python 3.9.6` (for `python3 -m http.server --directory site`)
- Browser: a modern browser with Canvas 2D support

## Current MVP

Implemented in this repository:
- Public engine API:
  - `EngineConfig`
  - `Game` trait with `init/update/draw`
  - `Sprite`, `Tilemap`, `Palette`, `AssetBundle`
  - `EngineInstance` runtime model
  - `EngineCommand` event/timer pipeline
- Asset DSL v1 parser:
  - `palette`, `sprite`, `tilemap`, `end`
  - line-numbered parse errors
- Asset conversion helper:
  - DSL -> JSON string
- Sample games:
  - driftbird side scroller (`driftbird`)
  - collision detection and scrolling obstacles
  - web demo audio cues (BGM + flap/reset/hit SFX)
- CLI:
  - `assets`
  - `assets-file`

## Quick Start

```bash
moon check
moon test
```

## Evaluator Quickstart (3-5 min)

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

Open:
- `http://localhost:8000/`
- `http://localhost:8000/g/`
- `http://localhost:8000/g/driftbird/`

Then in browser:
1. Press `Space` to start and flap.
2. Edit DSL and click `Apply DSL`.
3. Confirm scene/HUD changes.
4. Open `Sprite` and `Sound` tabs to verify GUI authoring path.

## GitHub Pages

Publish artifacts are generated under `site/`:

```bash
./scripts/update_demo_bundle.sh
```

Entry paths:
- `/` top page
- `/g/` game list
- `/g/<game_id>/` per-game runtime/editor page

## Controls and Editor

Game controls:
- `Space` / `ArrowUp`: start, restart, and flap
- `R`: reset

Editor tabs:
- `Game`: playable runtime
- `DSL`: edit/apply/import/export `assets.dsl`
- `Sprite`: pixel editor synced with DSL sprites
- `Sound`: BGM/SFX parameter tuning and test playback

In-canvas HUD:
- `S=score`
- `F=frame`
- `H=hit-code`

## CLI Usage

Convert DSL text to JSON:

```bash
moon run src/cmd/main -- assets "sprite hero 8 8\\n1.......\\n........\\n........\\n........\\n........\\n........\\n........\\n........\\nend"
```

Convert DSL file to JSON file (`--target js`):

```bash
moon run src/cmd/main --target js -- assets-file assets.dsl assets.json
```

## Wrapper API Quickstart

Thin wrapper layer:
- `config`
- `btn`
- `step` / `run`
- `cls` / `pset` / `rect` / `spr`

Minimal runtime example:

```mbt
fn quick_run(bundle : AssetBundle) -> Unit {
  let cfg = config(256, 144, fps=60, scale=4)
  let game = new_driftbird_game(bundle)
  let inputs = [
    btn([]),
    btn(["Space"], keys_pressed=["Space"]),
    btn([]),
  ]
  let (runtime, frames) = run(game, cfg, inputs)
  let state = game_state(runtime)
  println("score=\{state.score()} frames=\{frames.length()}")
}
```

Minimal drawing example:

```mbt
fn draw_preview(frame : Frame, sprite : Sprite) -> Unit {
  cls(frame, 0)
  rect(frame, 0, 142, 256, 2, 3)
  pset(frame, 1, 1, 6)
  spr(frame, sprite, 8, 20)
}
```

## Current Defaults and Constraints

- Default config: `256 x 144`, `60 fps`, `scale=4`.
- Sprite dimensions: each axis must be one of `8`, `16`, `32` (DSL validation).
- UI text rendering: 8x8 cell layout per character.

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
sprite bird 8 8
........
...33...
..33334.
.3336334
.3353334
..33333.
...33...
........
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

## Engine Model

- `init`: create/reset game state.
- `update`: fixed-step state transition (deterministic).
- `draw`: pure frame generation from current state.

## Collision Model

- Engine provides reusable primitives: `Rect` + `Collider`.
- Games build tagged colliders and choose collision responses in game logic.
- Driftbird stores `last_hit_tag` (e.g. `ground`, `pipe_top`) for explainable game-over behavior.

## Why AI-Friendly

- Text DSL is easy to prompt, diff, review, and regenerate.
- Line-numbered parser errors are easy to feed back into iterative AI loops.
- Deterministic game loop makes AI-generated tests stable.

## Baseline and Differentiation

- Baseline capabilities:
  - playable rendering path (Canvas now, WebGPU path as next milestone)
  - practical audio path (BGM + SFX in web demo)
  - minimal GUI authoring path (sprite + sound)
- moon8bit-specific value:
  - text-first asset workflow for AI iteration
  - deterministic runtime and reproducible validation
  - compact MoonBit codebase that remains easy to inspect

## Context Harness (Anti-Drift)

- `docs/north-star.md`
- `docs/session-brief.md`
- `docs/decision-log.md`
- `docs/handoff.md`
- `docs/ai-usage-log.md`

## Submission Prep

- `docs/submission-checklist.md`
- `docs/demo-script.md`
- `docs/application-draft.md`

## Validation

This repository includes:
- DSL success/error tests
- deterministic runtime tests
- integration tests for driftbird loops

Run everything:

```bash
moon test
```
