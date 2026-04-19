<br>
<p align="center">
  <img src="https://raw.githubusercontent.com/sacckey/moon8bit/refs/heads/main/resource/logo/moon8bit-logo.png" width="480px">
</p>
<br>

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

The core idea is simple:
- Keep assets text-first (DSL), not binary-first.
- Keep gameplay deterministic (fixed-step update).
- Keep output portable (MoonBit + Web/Wasm-ready runtime model).

**[Try the demo in your browser!](https://sacckey.github.io/moon8bit/g/)**

## SCC Scope Snapshot

- Engineering Goal: make AI-assisted retro game iteration practical in MoonBit.
- Target Users: solo developers/small teams building pixel-style prototypes and learners exploring MoonBit systems code.
- Architecture: `DSL parser -> runtime model -> renderer -> per-game web entry`, with CLI and tests wired to the same core package.
- Feasibility: four playable game demos, reproducible commands, parser/error tests, deterministic runtime tests, WebGPU rendering.

## Environment Requirements

- OS: macOS/Linux (current local verification environment: macOS/Darwin)
- MoonBit toolchain: `moon 0.1.20260209`
- Python: `Python 3.9.6` (for `python3 -m http.server --directory site`)
- Browser: Chrome 113+ / Edge 113+ recommended (WebGPU); Canvas2D fallback works in any modern browser

## Current Implementation

Implemented in this repository:

- **Engine core**
  - `Game` trait with `init/update/draw` phases
  - Fixed-step deterministic runtime (`EngineInstance`)
  - Imperative `UpdateContext` API: `ctx.sfx()`, `ctx.bgm_stop()`, `ctx.set_timeout()`, etc.
  - `EngineCommand` event/timer pipeline with ordering guarantees
  - Utility: `rand(seed, min, max)`, `clamp(value, min, max)`

- **Asset DSL**
  - `palette`, `sprite`, `tilemap`, `sound`, `bgm` blocks with `end`
  - Line-numbered parse errors
  - Sound: `wave`, `attack`, `decay`, `volume`, `f0`, `f1`
  - BGM: `wave`, `volume`, `step_sec`, `loop`, `notes` (white keys C–B + R for rest; MIDI internally)
  - DSL → JSON conversion helper

- **Rendering**
  - WebGPU path: full-screen triangle pipeline, nearest-neighbor sampler, palette RGBA cache, `device.lost` fallback
  - Canvas2D fallback: automatic when WebGPU unavailable
  - Renderer status displayed in page header (`renderer=webgpu` / `renderer=2d`)

- **Audio**
  - BGM: step sequencer from DSL `notes` array (MIDI → Hz at runtime)
  - SFX: envelope synthesis (`attack/decay/volume`, frequency sweep `f0→f1`)

- **Browser editor**
  - DSL tab: apply / import / export `assets.dsl`
  - Sprite tab: pixel editor synced with DSL sprites
  - Sound tab: full SFX/BGM editor with:
    - SFX cards: wave selector, F0/F1/ATK/DEC/VOL number inputs, Test / Dup / Del
    - `+ SFX` button to create new SFX entries from the UI
    - BGM selector dropdown for multiple BGM blocks, `+ BGM` / `Dup` / `Del`
    - BGM controls: wave, step_sec, loop, notes inputs
    - Dirty state indicator (`Modified` / `Saved`)
    - `Sync from DSL` / `Write to DSL` / `Write + Apply` round-trip
    - Safe write-back: aborts with error feedback on malformed unterminated sound/bgm blocks

- **Sample games**
  - `driftbird` — side-scroller: input, scrolling, collision, audio
  - `breakout` — ball physics: subframe collision, entry-axis bounce detection
  - `snake` — grid movement: wrap, food spawn via `rand`
  - `shooting` — shooter: parallax stars, sprite-based enemies

- **CLI**
  - `assets` — DSL text → JSON string
  - `assets-file` — DSL file → JSON file

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
1. Press `Space` to start and flap. Status bar shows `renderer=webgpu` or `renderer=2d`.
2. Edit DSL and click `Apply DSL` — scene updates immediately.
3. Open `Sprite` tab — edit pixels and click `Write + Apply`.
4. Open `Sound` tab — adjust SFX/BGM, use `Test`, then `Write to DSL` or `Write + Apply`.

## GitHub Pages

Publish artifacts are generated under `site/`:

```bash
./scripts/update_demo_bundle.sh
```

Entry paths:
- `/` top page
- `/g/` game list
- `/g/<game_id>/` per-game runtime/editor page (driftbird, breakout, snake, shooting)

## Controls and Editor

Default game controls (driftbird):
- `Space` / `ArrowUp`: start, restart, flap
- `R`: reset

Editor tabs:
- `Game`: playable runtime
- `DSL`: edit/apply/import/export `assets.dsl`
- `Sprite`: pixel editor synced with DSL sprites
- `Tilemap`: map + tile editor
  - Map editor: brush paint/erase on tilemap canvas (`Shift` or right-drag = erase)
  - Map management: `+ Map` / `Del Map` / `Resize` (`width` / `height` inputs)
  - Tile metadata: selected tile `name` and `solid` checkbox
  - Tile pixel editor: edit selected tile's 8x8 pixels with palette brush
  - `Sync from DSL` / `Write to DSL` / `Write + Apply` round-trip
  - Parse errors show line-numbered feedback in Tilemap tab
- `Sound`: SFX/BGM editor
  - Per-SFX cards: wave select, frequency, envelope, volume — Test / Dup / Del per card
  - `+ SFX` button creates new SFX entries from the GUI (no DSL edit needed)
  - BGM selector for multiple BGM blocks; `+ BGM` / `Dup` / `Del` to manage them
  - `Sync from DSL` imports DSL state into editor; `Write to DSL` / `Write + Apply` write back
  - `Modified` / `Saved` indicator shows unsaved editor changes

## CLI Usage

Convert DSL text to JSON:

```bash
moon run src/cmd/main -- assets "sprite hero 8 8\n1.......\n........\n........\n........\n........\n........\n........\n........\nend"
```

Convert DSL file to JSON file (`--target js`):

```bash
moon run src/cmd/main --target js -- assets-file assets.dsl assets.json
```

## Asset DSL Reference

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
..3334..
.333334.
333663..
end
```

- `.` means transparent (`-1`)
- `0-9`, `a-f`, `A-F` are palette indices
- Width/height must each be 8, 16, or 32

### Tilemap

```text
tilemap ground 8 2
5 5 5 5 5 5 5 5
3 3 3 3 3 3 3 3
end
```

### Sound (SFX)

```text
sound flap
wave square
attack 0.003
decay 0.10
volume 0.07
f0 520
f1 360
end
```

Triggered in game code via `ctx.sfx("flap")`.

### BGM

```text
bgm main
wave square
volume 0.04
step_sec 0.125
loop true
notes C4 E4 G4 E4 R
end
```

- Notes: `C D E F G A B` + optional `#`/`b` + octave (e.g. `C4`, `C#4`, `Db4`)
- `R` = rest (silence for one step)
- Controlled via `ctx.bgm_start()` / `ctx.bgm_stop()`

## Engine Model

- `init`: create/reset game state.
- `update(self, ctx) -> Self`: fixed-step state transition. Use `ctx` for events and timers.
- `draw(self, ctx) -> Frame`: pure frame generation from current state.

```mbt
pub impl @engine.Game for MyGame with update(self, ctx) {
  if @engine.key_pressed(ctx.input, "Space") {
    ctx.sfx("flap")
  }
  self
}
```

## Collision Model

- Engine provides reusable primitives: `Rect` + `Collider`.
- Games build tagged colliders and choose collision responses in game logic.
- Hit tags (e.g. `ground`, `pipe_top`) are stored in game state for explainable game-over behavior.

## Why AI-Friendly

- Text DSL is easy to prompt, diff, review, and regenerate.
- Line-numbered parser errors are easy to feed back into iterative AI loops.
- Deterministic game loop makes AI-generated tests stable.
- Compact module boundaries (`model/assets/engine/games/web`) are easy to inspect.

## Baseline and Differentiation

- Baseline capabilities:
  - WebGPU rendering path (Canvas2D fallback)
  - Practical audio path (BGM step sequencer + SFX synthesis)
  - Minimal GUI authoring path (sprite pixel editor + sound parameter editor)
- moon8bit-specific value:
  - Text-first asset workflow for AI iteration
  - Deterministic runtime and reproducible validation
  - Compact MoonBit codebase that remains easy to inspect

## Validation

52 tests covering:
- DSL success/error cases (palette, sprite, tilemap, sound, bgm, note names)
- Deterministic runtime replay
- Collision behavior (pipe hit, ground hit, score increment, timer ordering)
- Integration paths for driftbird game loops

```bash
moon test
```

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
