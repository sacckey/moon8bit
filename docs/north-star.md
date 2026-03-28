# moon8bit North Star (v1)

## Mission

Build `moon8bit` as a retro 2D engine that is easy for both humans and AI to use, with a text-first asset workflow.

## Core Product Direction

- Retro game target first (small 2D games, pixel style).
- AI-friendly workflow as a first-class goal (text DSL, deterministic loop, clear errors).
- Portable runtime model with MoonBit, with Web demo as the primary showcase in v1.

## In Scope (v1)

- Engine core with `init/update/draw` model and fixed-step runtime.
- DSL v1 for `palette`, `sprite`, `tilemap`.
- CLI conversion path (DSL -> JSON).
- Web demo with live DSL apply and visible gameplay effect.
- Basic tests for parser, runtime determinism, and sample game integration.

## Out of Scope (v1)

- Built-in external LLM API integration.
- Full editor suite / full IDE.
- Advanced rendering backends (WebGPU) as mandatory runtime.
- Large-scale ECS, physics stack, or full game framework.

## Non-Negotiables

- Keep asset format text-first and diff-friendly.
- Keep core gameplay loop deterministic for reproducible tests.
- Keep API and docs understandable for AI-assisted generation.

## Success Criteria by Final Submission (2026-04-21)

- Reproducible build/run flow for reviewers.
- One playable driftbird side-scroller demo on Web.
- Clear docs for architecture decisions and AI usage.
- Sufficient tests covering core paths and edge cases.
