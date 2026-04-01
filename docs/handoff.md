# Handoff

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
   - collision hit tag surfaced in web status (`hit=<tag>`)
   - runtime test for `pipe_top` collision tag
3. Added submission prep assets:
   - `docs/submission-checklist.md`
   - `docs/demo-script.md`

## Current State

- Build/Test status: pass (`moon check`, `moon test`, `moon build --target js cmd/web`)
- Demo status: playable web demo with live apply + import/export + collision tag feedback
- Known limitations:
  - No direct browser-to-local file overwrite; import/export workflow is used
  - WebGPU backend is not included in v1

## Next 1-2 Tasks

1. Record 30-45s demo GIF/video following `docs/demo-script.md`.
2. Final pass on submission form text and links using `docs/submission-checklist.md`.

## Risks / Open Questions

- Ensure final demo media clearly shows both DSL apply and collision tag (`hit=<tag>`).
- Keep remaining changes to docs/bugfix only until submission.

## Quick Restart Commands

```bash
moon check
moon test
moon build --target js cmd/web
python3 -m http.server 8000
```

## 2026-04-01 End-of-Day TODO Snapshot

- Next focus: logic-shrinking API layer on top of current wrappers.
- Candidate helpers: input edge (`btnp`), deterministic timer/spawn helpers, lightweight collision helpers, minimal UI helpers.
- Refactor policy: apply to `game_driftbird` incrementally with behavior parity tests (score/collision/reset).
