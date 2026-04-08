# moon8bit North Star (v1)

## Mission

Build `moon8bit` as a retro 2D engine that is easy for both humans and AI to use, with a text-first asset workflow.

## Core Product Direction

- Retro game target first (small 2D games, pixel style).
- AI-friendly workflow as a first-class goal (text DSL, deterministic loop, clear errors).
- Portable runtime model with MoonBit, with Web demo as the primary showcase in v1.
- Keep API ergonomics simple enough for short human/AI-generated game code.

## In Scope (v1)

- [x] Engine core with `init/update/draw` model and fixed-step runtime.
- [x] DSL v1 for `palette`, `sprite`, `tilemap`.
- [x] CLI conversion path (DSL -> JSON).
- [x] Web demo with live DSL apply and visible gameplay effect.
- [x] Basic tests for parser, runtime determinism, and sample game integration.
- [x] WebGPU rendering path (Canvas2D fallback, nearest sampler, palette cache).
- [x] Sound playback path (BGM + core SFX via Web Audio API).
- [x] Minimal GUI editing path (sprite editor + sound editor tabs).
- [x] Imperative game API (`ctx.sfx`, `ctx.set_timeout`, `ctx.bgm_stop` etc.).
- [x] Multiple sample games (driftbird, breakout, snake, shooting).

## Out of Scope (v1)

- Built-in external LLM API integration.
- Full editor suite / full IDE.
- Large-scale ECS, physics stack, or full game framework.
- High-end audio tooling (full DAW-style sequencing/mixing).
- Advanced visual editors beyond minimum authoring workflow.

## Non-Negotiables

- Keep asset format text-first and diff-friendly.
- Keep core gameplay loop deterministic for reproducible tests.
- Keep API and docs understandable for AI-assisted generation.
- Keep claims evidence-based; avoid uniqueness claims without explicit proof.

## Positioning Guardrails

- Describe moon8bit by implemented facts, not competitor comparison.
- "AI-friendly" claims should be backed by concrete features:
  - text-first DSL assets
  - line-numbered parser diagnostics
  - deterministic runtime + reproducible tests
  - web edit/apply/import/export loop

## Baseline vs Unique

- Baseline (expected for a practical retro engine):
  - rendering (Canvas2D + WebGPU), input loop, assets, audio, and basic editor workflows
- moon8bit-specific value (what we emphasize):
  - text-first AI iteration workflow
  - deterministic behavior + reproducible validation
  - compact and inspectable MoonBit implementation

## Success Criteria by Final Submission (2026-04-21)

- [x] Reproducible build/run flow for reviewers.
- [x] Multiple playable game demos on Web.
- [x] WebGPU rendering path functional.
- [x] Clear docs for architecture decisions and AI usage.
- [x] Sufficient tests covering core paths and edge cases.
- [ ] Demo video/GIF recorded.
- [ ] Final application text frozen.

## Architecture Rule (Fixed: 2026-04-05)

- Prioritize design consistency over demo speed.
- Shared packages must stay game-neutral:
  - no game-specific nouns in shared types/functions
  - no game-specific branching in `cmd/web` runtime path
- Input is modeled as raw device state in shared layer:
  - keys/pointer snapshot + edge state
  - game meaning is resolved only in game packages

## Non-Goals (Fixed)

- Chasing full-feature parity with broad ECS/3D engines.
- Expanding into large generalized framework scope before completing core minimal goals.
