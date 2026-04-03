# moon8bit North Star (v1)

## Mission

Build `moon8bit` as a retro 2D engine that is easy for both humans and AI to use, with a text-first asset workflow.

## Core Product Direction

- Retro game target first (small 2D games, pixel style).
- AI-friendly workflow as a first-class goal (text DSL, deterministic loop, clear errors).
- Portable runtime model with MoonBit, with Web demo as the primary showcase in v1.
- Keep API ergonomics simple enough for short human/AI-generated game code.

## In Scope (v1)

- Engine core with `init/update/draw` model and fixed-step runtime.
- DSL v1 for `palette`, `sprite`, `tilemap`.
- CLI conversion path (DSL -> JSON).
- Web demo with live DSL apply and visible gameplay effect.
- Basic tests for parser, runtime determinism, and sample game integration.
- Practical baseline capability expansion before final deadline:
  - WebGPU rendering path (minimum viable backend parity with current frame primitives)
  - sound playback path (BGM + core SFX)
  - minimal GUI editing path (sprite + sound authoring)

## Out of Scope (v1)

- Built-in external LLM API integration.
- Full editor suite / full IDE.
- Large-scale ECS, physics stack, or full game framework.
- high-end audio tooling (full DAW-style sequencing/mixing)
- advanced visual editors beyond minimum authoring workflow

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
  - rendering, input loop, assets, audio, and basic editor workflows
- moon8bit-specific value (what we emphasize):
  - text-first AI iteration workflow
  - deterministic behavior + reproducible validation
  - compact and inspectable MoonBit implementation

## Success Criteria by Final Submission (2026-04-21)

- Reproducible build/run flow for reviewers.
- One playable driftbird side-scroller demo on Web.
- Clear docs for architecture decisions and AI usage.
- Sufficient tests covering core paths and edge cases.

## Locked Definition (2026-04-04)

This section is the fixed planning baseline for remaining SCC work.

### Product Goal (Fixed)

- Deliver a complete and runnable MoonBit-centered retro engine application by 2026-04-21.
- Keep the engine minimal while still practical for real game authoring.
- Keep game authoring short, readable, and AI-assisted-friendly.

### Core Value We Must Prove

1. Minimal engine surface (small API, small conceptual cost).
2. Short game code (wrapper-driven authoring with low boilerplate).
3. Small text-first assets (diff-friendly, AI-editable).
4. Fast debug/iteration loop (line-number diagnostics + deterministic behavior).

### Differentiation vs Selene (Comparison Axis)

- We do not compete on total engine breadth (ECS/3D/full editor scope).
- We compete on focused retro iteration speed and simplicity.
- We emphasize measurable AI/human iteration efficiency:
  - fewer steps to first playable result
  - shorter sample code
  - deterministic replay/testing
  - clearer parser/runtime error feedback

### Required Capability Tracks

- Baseline track (must exist in runnable form):
  - WebGPU path with minimum practical parity for current frame primitives
  - Sound path with BGM + core SFX
  - Browser GUI authoring for sprite + sound
  - Browser editing + local rebuild workflow for practical iteration
- moon8bit unique track (must remain central):
  - text-first asset workflow
  - deterministic runtime + reproducible validation
  - AI-friendly diagnostics and compact wrappers

### Delivery Rule for New Features

- Every new capability is shipped as one set:
  - Primitive runtime implementation
  - User-facing wrapper API
  - tests (including reproducibility/parity where applicable)
  - README usage example
- No delayed "wrapper later" feature delivery.

### Non-Goals (Fixed)

- Chasing full-feature parity with broad ECS/3D engines.
- Expanding into large generalized framework scope before completing core minimal goals.
