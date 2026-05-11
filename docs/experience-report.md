# moon8bit Experience Report

Author: sacckey
Project: moon8bit — AI-Friendly Retro 2D Engine in MoonBit
Date: 2026-05-11

## 1. Background and Goal

`moon8bit` started as a practical question: can we make a small retro game engine that is genuinely easy to develop with both humans and AI, not only for one demo game but for repeated iteration?

The project goal was not to build the largest engine. The goal was to build a compact, inspectable system where:

- assets are easy to edit and diff,
- game behavior is deterministic and testable,
- web-based iteration is fast enough for daily use,
- MoonBit is central in architecture and runtime behavior.

From the beginning, I set a text-first workflow as a core constraint. Instead of binary-first authoring, the engine uses `assets.dsl` and keeps parser diagnostics explicit (including line-level error feedback). This was selected to reduce AI iteration friction and to keep review/debug loops readable in Git history.

## 2. Why MoonBit + AI Worked for This Project

MoonBit worked well for this style of system development because it encouraged clear package boundaries and deterministic, explicit data flow. I organized the project around:

- `model` (data types),
- `assets` (DSL parse/validation),
- `engine` (runtime execution),
- `games` (game logic),
- `cmd/web` (shared browser runtime/editor).

This separation made AI collaboration more tractable. When a feature request came in (for example tilemap editing, camera behavior, or sound DSL extensions), I could constrain the change to one or two packages and verify behavior through tests.

AI assistance was most useful in:

- drafting parser edge-case tests,
- generating first-pass UI wiring for editor tabs,
- proposing refactoring candidates,
- accelerating repetitive code transformation.

AI was less reliable in:

- preserving long-horizon architectural intent across many turns,
- judging product direction tradeoffs without strict constraints,
- avoiding incidental coupling between shared and game-specific layers.

Because of this, human curation was essential throughout. I had to continuously enforce boundary rules and reject shortcut implementations when they harmed long-term consistency.

## 3. Development Workflow and Iteration Model

The effective workflow became:

1. define one concrete behavior target,
2. implement in a narrow scope,
3. add/adjust tests immediately,
4. run `moon check` + `moon test`,
5. validate in browser (`site/g/<game_id>/`),
6. sync docs only after behavior was stable.

This sounds obvious, but in AI-assisted coding the order matters. If docs or wrappers were updated before internal behavior stabilized, rework increased significantly.

The browser editor became the daily integration surface. The current tabs are:

- Game / DSL / Palette / Sprite / Tile / Tilemap / SFX / BGM

This made it possible to validate the full loop (edit -> apply -> play) without leaving one page.

## 4. Architectural Decisions and Their Impact

### 4.1 Text-First Asset DSL

I chose DSL as the source of truth for palette/sprite/tile/tilemap/place/sound/bgm.
Impact:

- easy diffs and review,
- easier AI patching than binary assets,
- explicit parse errors with line references.

Tradeoff:

- parser and write-back logic become core complexity,
- editor synchronization must be carefully controlled.

### 4.2 Deterministic Runtime

I kept a fixed-step update model with explicit `init/update/draw` boundaries and command/event scheduling in runtime.
Impact:

- replayability and stable tests,
- predictable behavior across games.

Tradeoff:

- strict ordering decisions are required for timers/events,
- convenience shortcuts often need to be rejected.

### 4.3 Shared Layer Must Stay Game-Neutral

A recurring risk was accidental game coupling in shared runtime/editor logic.
I repeatedly applied a rule: shared packages should expose primitives, while game meaning stays in game packages.

Impact:

- better reuse across multiple sample games,
- lower architectural drift.

Tradeoff:

- some feature requests took longer because immediate shortcuts were not accepted.

## 5. AI Collaboration: What Helped and What Failed

### What helped

- Fast boilerplate generation for UI/editor scaffolding.
- Rapid proposal of alternative implementations.
- Test expansion for parser and regression scenarios.
- Refactoring support once the target shape was precisely specified.

### What failed

- If requirements were ambiguous, AI often optimized for local completion rather than architectural integrity.
- If I requested “make it smaller/simpler” without precise constraints, code could become superficially shorter but structurally worse.
- AI can confidently propose incorrect direction shifts unless guarded by explicit non-negotiables.

### Practical rule I learned

For AI-native system work, “prompt quality” is not enough. You need explicit architectural guardrails that stay fixed over time. In this project, those guardrails were:

- text-first assets,
- deterministic core loop,
- game-neutral shared layers,
- reproducibility-first validation.

Without guardrails, iteration speed appears high in the short term but produces long-term cleanup cost.

## 6. Engineering Quality and Reproducibility Status

At submission stage, the project provides:

- reproducible local workflow via documented commands,
- web deployment path through GitHub Pages,
- multiple playable game samples (flappy, breakout, snake, shooting, platformer),
- test coverage across parser/runtime/game behavior,
- deterministic behavior checks and regression tests.

The current test status is:

- `moon test`: 94 passed, 0 failed.

For evaluator reproduction, the main steps are:

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

Then open `/g/` and run per-game pages.

## 7. References to Existing OSS

The following projects influenced design direction and workflow thinking:

- pyxel
- TIC-80
- Reight (R8)

These were references for conceptual design and ergonomics. The implementation of moon8bit in this repository was authored within this project workflow.

## 8. Main Insights

1. **Text assets are a force multiplier for AI collaboration.**
   They reduce patch cost and review cost more than expected.

2. **Determinism is not only for tests; it stabilizes human-AI communication.**
   When behavior is reproducible, debugging discussions become concrete.

3. **Shared-layer neutrality is easy to break and expensive to recover.**
   Explicit constraints are required from day one.

4. **UI/editor capability should evolve alongside core runtime, not after.**
   Many practical issues were discovered only when real editing loops were used.

5. **AI speed is real, but architectural discipline determines final quality.**
   The best outcomes came from constrained iteration, not unconstrained generation.

## 9. Future Work

If continued, the next technical priorities would be:

- further editor UX refinement for larger projects,
- additional runtime helpers where game code repeats common patterns,
- continued stabilization of rendering/audio paths across environments,
- expanded documentation examples for new game authors.

The core direction remains unchanged: keep moon8bit compact, deterministic, text-first, and practical for both human and AI-driven development.
