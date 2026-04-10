# Decision Log

Use one short entry per decision to prevent direction drift.

## Format

- Date:
- Decision:
- Why:
- Impact:

---

- Date: 2026-03-27
- Decision: Use text-first DSL (`palette/sprite/tilemap`) as asset source for v1.
- Why: AI and humans can iterate via small textual diffs with lower token cost than binary images.
- Impact: Parser/CLI and docs become core deliverables.

- Date: 2026-03-27
- Decision: Prioritize Web Canvas runtime before WebGPU.
- Why: Faster to make a playable and reviewable demo before deadline.
- Impact: Rendering backend remains simple; WebGPU can be an optional later path.

- Date: 2026-03-28
- Decision: Adopt local-first workflow (`localhost`) with browser live-apply loop.
- Why: Lowest operational overhead and fastest iteration for solo development.
- Impact: Persistence features (`Export/Import`) are planned as next UX step.

- Date: 2026-03-28
- Decision: Implement browser-level `Export/Import` for DSL persistence before direct file-write integration.
- Why: Reliable cross-environment UX with lower implementation risk for v1 timeline.
- Impact: Users can keep edited assets between sessions without server-side components.

- Date: 2026-03-28
- Decision: Introduce engine-level `Collider` API and route driftbird collision checks through it.
- Why: Remove game-specific ad-hoc collision logic and provide reusable overlap primitives.
- Impact: Future games can share one collision detection path while keeping collision response in game code.

- Date: 2026-03-28
- Decision: Adopt `driftbird` as the sample game naming for public-facing docs/demo text.
- Why: Avoid direct similarity to existing IP phrasing while keeping the gameplay concept clear.
- Impact: Documentation and demo messaging are aligned with safer, original naming.

- Date: 2026-03-28
- Decision: Record collision hit tags (`ground`, `ceiling`, `pipe_*`) in game state.
- Why: Keep collision outcomes explainable and allow game-side branching based on collision type.
- Impact: Integration tests can verify both game-over and collision cause, improving debugging and reproducibility.

- Date: 2026-03-28
- Decision: Surface collision outcomes in runtime UI and add a pipe-hit runtime test.
- Why: Make collision outcomes visible during demo play and prevent regressions in tag wiring.
- Impact: Better UX explainability and stronger confidence in collision behavior changes (currently shown via in-canvas HUD code).

- Date: 2026-03-28
- Decision: Rework submission draft to explicitly map SCC evaluation axes and add evaluator quickstart to README.
- Why: Reduce reviewer friction and make value proposition/scoring alignment obvious.
- Impact: Stronger explainability and faster project evaluation during screening.

- Date: 2026-03-28
- Decision: Add dedicated submission checklist/demo script and switch handoff to concrete session data.
- Why: Minimize last-week execution risk and make Monday restart frictionless.
- Impact: Clear pre-submit gate and stable handoff workflow.

- Date: 2026-03-28
- Decision: Use root-based GitHub Pages with `demo/` as the published web demo path.
- Why: `docs/` is reserved for project documents, so demo assets should be isolated without changing docs usage.
- Impact: Added root `index.html`, `demo/index.html`, and bundle sync script for Pages-ready deployment.

- Date: 2026-03-28
- Decision: Switch driftbird control flow to press-to-start/restart with edge-triggered jump input and pass-through scoring.
- Why: Prevent hold-to-fly behavior, improve game feel, and match retro loop expectations.
- Impact: Added `is_started` state, one-press jump semantics, pipe pass scoring, and new tests for start/restart/score behavior.

- Date: 2026-04-02
- Decision: Adopt a two-layer feature delivery rule (`Primitive + Wrapper`) for all new engine capabilities.
- Why: Prevent delayed API ergonomics and avoid relying on copied external implementations for each feature.
- Impact:
  - New features (e.g. audio/input helpers) must define both internal primitives and user-facing wrappers in the same change set.
  - Wrapper additions are not postponed to a later refactor phase.
  - Each feature change includes: behavior tests, deterministic/reproducibility checks (when applicable), and a minimal README usage example.
  - External engines may be referenced for design ideas only; moon8bit implementation code remains original.

- Date: 2026-04-05
- Decision: Prioritize architecture consistency over speed-to-demo.
- Why: Direction drift repeatedly occurred when short-term demo convenience overrode package boundaries.
- Impact:
  - Shared packages are reviewed with a "game-neutral" gate before merge.
  - Wrapper/API polish does not bypass internal boundary corrections.

- Date: 2026-04-05
- Decision: Standardize shared input model as raw device state (keys/pointer), not game actions.
- Why: Game-specific terms in shared types (`flap/reset`) caused coupling and blocked multi-game reuse.
- Impact:
  - Shared input APIs expose only raw keys/pointer state and edge transitions.
  - Action semantics (jump/reset/etc.) are resolved only in game packages.

- Date: 2026-04-05
- Decision: Adopt minimal internal redesign order for upcoming work.
- Why: Avoid large rewrites while preventing more surface-level API patches on unstable internals.
- Impact:
  - Next internal steps are fixed in order:
    1. input pipeline consistency
    2. runtime boundary clarity (`update/draw` responsibilities)
    3. minimal event handoff cleanup
  - Large feature additions are paused until this order is complete.

- Date: 2026-04-06
- Decision: Complete internal runtime cleanup with `EngineCommand`-driven timers/events as the single scheduling path.
- Why: Remove duplicated timer APIs and keep engine behavior simple, deterministic, and testable.
- Impact:
  - Command-based scheduling is the single public path for delayed/repeated events.
  - Added event ordering tests to lock queue semantics (`timer emissions` then `immediate commands` in the same frame).

- Date: 2026-04-06
- Decision: Standardize web publishing layout to generated per-game pages under `site/g/<game_id>/`.
- Why: Keep shared `cmd/web` game-neutral while supporting multiple games without hardcoded registry edits.
- Impact:
  - Build script generates per-game `web.js`, `assets.dsl`, and `game_spec.json`.
  - Runtime/editor entry points are now path-driven (`/g/<game_id>/`), with `/g/` as the game list.

- Date: 2026-04-06
- Decision: Replace tuple-return `Game::update` with imperative `UpdateContext` API (`ctx.sfx()`, `ctx.bgm_stop()`, `ctx.set_timeout()` etc.).
- Why: Returning `(Self, Array[EngineCommand])` was verbose and forced game authors to manage command arrays manually. Imperative API matches how game logic naturally reads.
- Impact:
  - `Game::update` signature simplified to `(Self, UpdateContext) -> Self`.
  - Engine execution model unchanged (commands still collected and dispatched after update).
  - Game code shorter and more readable.

- Date: 2026-04-07
- Decision: Add `rand(seed, min, max)` and `clamp(value, min, max)` as engine-level utilities.
- Why: Both were being reimplemented in every game. `rand` in particular required a correct LCG implementation to avoid sign-overflow bugs.
- Impact:
  - `rand` uses `(seed * 1664525 + 1013904223).land(0x7FFFFFFF)` to avoid `Int.min_value()` overflow.
  - Games can call `@engine.rand(ctx.tick, min, max)` for deterministic pseudo-random placement.

- Date: 2026-04-07
- Decision: Add breakout, snake, and shooting as additional sample games.
- Why: Single sample game (driftbird) does not demonstrate engine generality. Multiple games prove the `init/update/draw` contract works across different game patterns.
- Impact:
  - breakout: subframe collision with entry-axis detection (prev_x/prev_y) for accurate single-bounce behavior.
  - snake: grid-based movement, wrap logic, food spawn via `rand`.
  - shooting: parallax star background, sprite-based player/enemy.

- Date: 2026-04-08
- Decision: Implement WebGPU rendering path with Canvas2D fallback.
- Why: WebGPU is listed as a baseline capability track in north-star. Provides GPU-accelerated frame upload with nearest-neighbor sampling for pixel-art quality.
- Impact:
  - `web_js_gpu.mbt` implements palette RGBA cache, pixel buffer build, and WebGPU pipeline (full-screen triangle, nearest sampler).
  - `__moon8bit_render_fn` swap pattern allows async GPU init with immediate Canvas2D fallback.
  - `device.lost` detection falls back to Canvas2D silently.
  - Status bar displays `renderer=webgpu` or `renderer=2d` for observability.
