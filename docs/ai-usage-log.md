# AI Usage Log

## Scope
- Goal: implement an MVP for an AI-friendly retro game engine in MoonBit.
- Constraints: short timeline, deterministic behavior, easy evaluator reproduction.

## AI-assisted tasks
- Converted high-level project intent into concrete API boundaries.
- Drafted DSL grammar and parser structure (`palette`, `sprite`, `tilemap`, `end`).
- Generated test case candidates for success/error scenarios.
- Produced first-pass README and submission draft text.

## Human decisions
- Chose to keep v1 asset format text-first and avoid external LLM API coupling.
- Chose bird-like side-scroller as sample to cover input/collision/scrolling in one scene.
- Prioritized deterministic runtime and parser diagnostics over graphics complexity.

## Verification steps
- `moon check`
- `moon test`
- manual `moon run cmd/main -- demo 8`
- manual `moon run cmd/main -- assets "sprite hero 2 1\\n11\\nend"`

## Notes
- AI output was used as implementation accelerator, but interface shape and tradeoffs were human-curated.

## 2026-03-28 Update
- Added a context harness process to reduce long-session drift:
  - `docs/north-star.md`
  - `docs/session-brief.md`
  - `docs/decision-log.md`
  - `docs/handoff.md`
- Updated README with a daily start/end routine for AI-assisted work.
