# Handoff

## 2026-04-18 Current State

- Build/Test status: pass (`moon check`, `moon test`, 72 tests)
- Sample games: driftbird, breakout, snake, shooting, platformer
- Renderer: WebGPU + Canvas2D fallback, runtime status visible (`renderer=webgpu|2d`)
- Audio: DSL-managed SFX/BGM, editor split into `SFX` and `BGM` tabs
- Editor tabs: `Game / DSL / Palette / Sprite / Tile / Tilemap / SFX / BGM`

### Architecture status

- `EngineInstance` owns tick/event-queue/timers; command-driven runtime path is stable.
- Shared `cmd/web` runtime remains game-neutral; per-game web entry under `src/games/<id>/web`.
- Asset flow is text-first (`assets.dsl`) with GUI round-trip editors.
- Tilemap workflow includes tile edit, sprite placement, map resize, and viewport-grid overlay.

### Known limitations

- No browser-to-local overwrite (import/export workflow only).
- WebGPU still uses per-frame map/upload path; can be optimized with `writeTexture`.
- Non-driftbird games still lack automated tests and deterministic replay coverage.

### Reproducible local commands

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

URLs: `/` top, `/g/` game list, `/g/<game_id>/` playable editor page.

### Remaining implementation work before freeze

1. Add tests for breakout / snake / shooting / platformer.
2. Add deterministic replay/E2E checks per game.
3. Stabilize platformer feel with explicit regression tests.
4. Final editor UX polish for larger maps and feedback consistency.
5. WebGPU upload path hardening/perf (`writeTexture` migration).

---

## 2026-04-09 Current State

- Build/Test status: pass (`moon check`, `moon test`, 42 tests)
- MoonBit source: ~6,634 lines
- Sample games: driftbird, breakout, snake, shooting
- Renderer: WebGPU (with Canvas2D fallback), status shown in page header
- Audio: BGM + SFX via Web Audio API
- Editor: DSL apply/import/export, sprite editor, sound editor

### Architecture status

- `EngineInstance` owns tick/event-queue/timers.
- `Game::update(self, ctx) -> Self` — imperative API (`ctx.sfx`, `ctx.set_timeout` etc.).
- `UpdateContext.commands` collects engine commands; dispatched by `engine_step` after update.
- `cmd/web` is shared game-neutral runtime; each game has its own `src/games/<id>/web` entry.
- Published paths generated under `site/g/<game_id>/`.
- WebGPU: `web_js_gpu.mbt` (JS-target only), `web_init_gpu` called at startup, `__moon8bit_render_fn` swapped in on GPU ready.

### Known limitations

- No browser-to-local file overwrite; import/export workflow used instead.
- WebGPU uses `mapAsync` per frame — stable but could be replaced with `writeTexture` for lower overhead.
- breakout / snake / shooting have no automated tests yet.

### Reproducible local commands

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

URLs: `/` top, `/g/` game list, `/g/driftbird/` playable editor page.

### Remaining work before 2026-04-21

1. Add tests for breakout / snake / shooting.
2. Freeze application-draft.md (300+ words, implementation-fact only).
3. Record demo video/GIF.
4. Final docs/README sync.
5. Ensure commit history is clean/readable.
6. Submit final application text + demo link.

---

## 2026-04-06 Runtime/Docs Sync Note

- Runtime architecture status:
  - `EngineInstance` owns tick/input-history/event-queue/timers.
  - `Game::update` uses imperative `UpdateContext`; timer scheduling is command-driven.
  - `UpdateContext` / `DrawContext` split is complete.
- Web architecture status:
  - `cmd/web` is shared game-neutral runtime UI.
  - each game has its own web entry package (`src/games/<id>/web`).
  - published paths are generated under `site/g/<game_id>/`.

## 2026-04-02 Acceptance Note (SCC Stage 1)

- Application status: accepted.
- Acceptance summary: "no major issues", development can proceed.
- Organizer expectations:
  - MoonBit remains central in system logic/architecture/runtime.
  - Final delivery should be a complete runnable application.
  - Final submission should include E2E runnable examples and clear build/run/test docs.
  - Practical distribution path should be explicit (GitHub Pages).
- Source: acceptance email received on 2026-04-02.

## 2026-04-01 Kickoff Note (SCC Stage 1)

- Stage 1 form submitted: `2026-04-01 20:34 JST`
- Submission text source: `docs/application-draft.md`
- Project title: `moon8bit`
