# AI Usage Log

## Scope
- Goal: implement an MVP for an AI-friendly retro game engine in MoonBit.
- Constraints: short timeline, deterministic behavior, easy evaluator reproduction.

## References to existing OSS (if applicable)
- pyxel
- TIC-80
- Reight (R8)
- These were used as design/workflow references only; moon8bit implementation code was authored in this repository.

## AI-assisted tasks
- Converted high-level project intent into concrete API boundaries.
- Drafted DSL grammar and parser structure (`palette`, `sprite`, `tilemap`, `end`).
- Generated test case candidates for success/error scenarios.
- Produced first-pass README and submission draft text.

## Human decisions
- Chose to keep v1 asset format text-first and avoid external LLM API coupling.
- Chose flappy side-scroller as sample to cover input/collision/scrolling in one scene.
- Prioritized deterministic runtime and parser diagnostics over graphics complexity.

## Verification steps
- `moon check`
- `moon test`
- manual `moon run src/cmd/main -- assets "sprite hero 8 8\\n........\\n........\\n........\\n........\\n........\\n........\\n........\\n........\\nend"`
- manual `moon run src/cmd/main --target js -- assets-file <in.dsl> <out.json>`

## Notes
- AI output was used as implementation accelerator, but interface shape and tradeoffs were human-curated.

## 2026-04-09 Update

- WebGPU rendering path implemented with AI assistance:
  - Full-screen triangle pipeline, nearest sampler, `bytesPerRow` alignment, `device.lost` fallback.
  - Palette RGBA cache (hash-based rebuild) to avoid per-frame hex parsing.
  - `__moon8bit_render_fn` swap pattern for async GPU init / sync Canvas2D fallback.
- Imperative `UpdateContext` API designed and implemented (`ctx.sfx`, `ctx.bgm_stop`, `ctx.set_timeout` etc.).
- Three additional sample games added (breakout, snake, shooting):
  - Breakout subframe collision design (entry-axis detection with prev_x/prev_y) was iterated over multiple passes.
  - Snake food-spawn bug (negative rand index) identified and fixed.
  - Shooting bundle preservation bug (`init` using empty bundle) identified and fixed.
- `rand(seed, min, max)` LCG implementation: overflow bug (`Int.min_value()` on sign flip) caught and fixed with `.land(0x7FFFFFFF)`.
- Flappy code was reduced significantly by removing per-game type alias boilerplate and simplifying helper boundaries.

## Human decisions (2026-04-09 period)

- Chose CPU-side palette→RGBA conversion (not GPU-side) to keep WebGPU shader trivial.
- Chose entry-axis collision detection for breakout over simple AABB bounce.
- Chose `play_min_y=1` for snake to avoid food spawning under HUD.
- Chose `ctx.sfx()` imperative API while keeping event-driven execution model unchanged.

## 2026-03-28 Update
- Added a context harness process to reduce long-session drift:
  - `docs/north-star.md`
  - `docs/session-brief.md`
  - `docs/decision-log.md`
  - `docs/handoff.md`
- Updated README with a daily start/end routine for AI-assisted work.
- Refined submission draft text to align directly with SCC evaluation axes.
- Added evaluator quickstart steps in README for faster reproduction.
- Added submission-ready operational docs (`submission-checklist`, `demo-script`) and concrete handoff notes.
- Prepared GitHub Pages publishing layout (`root index + demo/ path`) and bundle sync script.
- Refined gameplay loop to flappy naming and press-based controls (`Press Space` start/restart, edge-trigger jump, pass-through scoring) with additional regression tests.
