# Handoff

## 2026-04-06 Runtime/Docs Sync Note

- Runtime architecture status:
  - `EngineInstance` owns tick/input-history/event-queue/timers.
  - `Game::update` emits `EngineCommand`; timer scheduling is command-driven.
  - `UpdateContext` / `DrawContext` split is complete.
- Web architecture status:
  - `cmd/web` is shared game-neutral runtime UI.
  - each game has its own web entry package (`src/games/<id>/web`).
  - published paths are generated under `site/g/<game_id>/`.
- Reproducible local commands:
  - `moon check`
  - `moon test`
  - `./scripts/update_demo_bundle.sh`
  - `python3 -m http.server 8000 --directory site`
- Current primary URLs:
  - `/` top
  - `/g/` game list
  - `/g/driftbird/` playable editor/runtime page

## 2026-04-02 Acceptance Note (SCC Stage 1)

- Application status: accepted.
- Acceptance summary: "no major issues", development can proceed.
- Organizer expectations to track in implementation/docs:
  - MoonBit remains central in system logic/architecture/runtime.
  - Final delivery should be a complete runnable application.
  - Final submission should include E2E runnable examples and clear build/run/test docs.
  - Practical distribution path should be explicit (GitHub Pages / Releases / install channel).
- Source: acceptance email received on 2026-04-02.

## 2026-04-01 Kickoff Note (SCC Stage 1)

- Public kickoff status: active (repository is public and under active development)
- Stage 1 form status: submitted
- Submission timestamp: `2026-04-01 20:34 JST`
- Submission text source: `docs/application-draft.md`
- Submitted form summary:
  - Project title: `moon8bit`
  - Project description source: `docs/application-draft.md` (300+ words)
  - Why MoonBit / About You: completed and submitted
- Showcase alignment updates completed:
  - concrete scope fields added (goal/target users/architecture/feasibility)
  - README environment requirements clarified
  - checklist expanded with showcase readiness checks
  - baseline-vs-unique framing documented (`WebGPU/Sound/GUI` baseline + AI workflow differentiation)

## Session End Summary

- Date: 2026-03-28
- Commit(s): pending manual commit

## Done Today

1. Finalized submission-facing docs:
   - `docs/application-draft.md` (300+ words, SCC-axis mapping)
   - `README.mbt.md` evaluator quickstart
2. Improved explainability and validation:
   - collision outcome surfaced via in-canvas HUD (`H=<hit-code>`)
   - runtime test for `pipe_top` collision tag
3. Added submission prep assets:
   - `docs/submission-checklist.md`
   - `docs/demo-script.md`

## Current State

- Build/Test status: pass (`moon check`, `moon test`, `./scripts/update_demo_bundle.sh`)
- Demo status: playable per-game web pages with live apply + import/export + sprite/sound tabs
- Known limitations:
  - No direct browser-to-local file overwrite; import/export workflow is used
  - WebGPU backend is not included in v1

## Next 1-2 Tasks

1. Record 30-45s demo GIF/video following `docs/demo-script.md`.
2. Final pass on submission form text and links using `docs/submission-checklist.md`.

## Risks / Open Questions

- Ensure final demo media clearly shows DSL apply and HUD updates (`S/F/H`).
- Keep remaining changes to docs/bugfix only until submission.

## Quick Restart Commands

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

## 2026-04-01 End-of-Day TODO Snapshot

- Next focus: logic-shrinking API layer on top of current wrappers.
- Candidate helpers: input edge (`btnp`), deterministic timer/spawn helpers, lightweight collision helpers, minimal UI helpers.
- Refactor policy: apply to `game_driftbird` incrementally with behavior parity tests (score/collision/reset).
