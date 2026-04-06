# Submission Checklist (moon8bit)

## Metadata

- Submission target: MoonBit SCC 2026
- Deadline: 2026-04-21
- Current status date: 2026-04-06

## Stage 1 Gates

- [x] Google Form submitted (2026-04-01)
- [x] Submission timestamp recorded in `docs/handoff.md`
- [x] Stage 1 acceptance received (2026-04-02)

## Acceptance Expectations (2026-04-02)

- [x] MoonBit is central in architecture/runtime logic
- [x] Final target is tracked as a complete runnable application
- [x] E2E runnable path is documented
- [x] Distribution path is explicit (GitHub Pages)

## Messaging Safety

- [ ] Claims are implementation-fact based only
- [ ] No uniqueness/superiority claims without proof
- [ ] Public-facing docs avoid unnecessary competitor comparisons

## Showcase Readiness

- [x] Application text covers goal/users/architecture/feasibility
- [x] Public kickoff evidence exists (active public repo + commit history)
- [x] README covers goals/scope/usage/environment
- [x] README covers reproducible build/run/test path
- [x] Core-path tests and edge-case validation are documented

## Capability Track (Current)

- [ ] WebGPU path reaches minimum parity for current frame primitives
- [x] Audio path supports practical BGM + SFX playback
- [x] Minimal GUI authoring path exists for sprite + sound editing
- [x] Browser editing loop supports apply/import/export of `assets.dsl`

## moon8bit Unique Value Track

- [x] Text-first asset workflow is central
- [x] Deterministic runtime remains testable/reproducible
- [x] AI-friendly diagnostics remain (line-numbered parser errors)
- [x] Baseline vs moon8bit-specific value is documented

## Required Artifacts

- [ ] Final repository URL confirmation
- [ ] Final application text (300+ words) freeze
- [ ] AI usage / retrospective finalization
- [x] README reproducible run steps
- [ ] Demo video/GIF ready and viewable

## Repository Docs to Confirm

- [x] `README.mbt.md`
- [x] `docs/application-draft.md`
- [x] `docs/ai-usage-log.md`
- [x] `docs/decision-log.md`
- [x] `docs/demo-script.md`
- [x] `docs/north-star.md`

## Reproducibility Checks

Run from module root:

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

Open:

- `http://localhost:8000/`
- `http://localhost:8000/g/`
- `http://localhost:8000/g/driftbird/`

Expected:

- [ ] Game tab is playable (`Space` / `ArrowUp`, `R`)
- [ ] DSL tab `Apply` updates screen output
- [ ] DSL `Import` loads local file and applies
- [ ] DSL `Export` downloads current editor text
- [ ] Sprite tab can edit sprite pixels and write back to DSL
- [ ] Sound tab can preview/tune BGM/SFX
- [ ] In-canvas HUD updates (`S`, `F`, `H`)

## Final Submission Pass

- [ ] Freeze major features (docs/bugfix only)
- [ ] Re-run reproducibility checks
- [ ] Ensure docs match implementation
- [ ] Ensure commit history is clean/readable
- [ ] Submit final application text + demo link

## Current Priorities (2026-04-06)

1. Finalize docs/README sync to current architecture and URL paths.
2. Freeze complete E2E flow and record final demo video/GIF.
3. Decide WebGPU final-scope (minimal MVP or defer with explicit note).
4. Finalize submission text with implementation-fact wording only.

## Full Buildout Checklist (Minimal + WebGPU Complete)

- [ ] [P01] Freeze final minimal runtime/API principles (single source of truth).
- [ ] [P02] Define and fix game template contract for new games (`init/update/draw` + assets path).
- [ ] [P03] Refactor `game_driftbird.mbt` toward minimal authoring style (major line-count reduction).
- [ ] [P04] Finalize minimal drawing API surface (core only; extras separated).
- [ ] [P05] Finalize input API surface (raw-first + minimal helpers).
- [ ] [P06] Finalize `EngineCommand`/`EngineEvent` vocabulary as game-neutral primitives.
- [ ] [P07] Finalize scheduler semantics (`timeout/interval/cancel`) and lock tests.
- [ ] [P08] Freeze shared web runtime boundary (`cmd/web` game-neutral contract).
- [ ] [P09] Add automated new-game scaffolding (template + generation command/script).
- [ ] [P10] Freeze `assets.dsl` core grammar and extension points.
- [ ] [P11] Complete sprite editor workflow (edit/apply/save/restore).
- [ ] [P12] Define sound data model (waveform/ADSR/pitch/volume/loop).
- [ ] [P13] Implement sound text format integration into project asset flow.
- [ ] [P14] Complete sound editor UX (preset/slider/test + DSL sync).
- [ ] [P15] Integrate audio runtime path (engine events to playback behavior).
- [ ] [P16] Finalize BGM/SFX policy (mixing, priority, stop rules).
- [ ] [P17] Introduce renderer abstraction (`Canvas2D` / `WebGPU` backends).
- [ ] [P18] Move current Canvas2D renderer into renderer abstraction.
- [ ] [P19] Implement WebGPU minimum path (`Frame` upload + render).
- [ ] [P20] Implement WebGPU native path for practical parity (sprite/tilemap/text draw route).
- [ ] [P21] Optimize WebGPU path (buffer reuse, upload strategy, pipeline tuning).
- [ ] [P22] Add WebGPU resilience (feature detection, fallback, device-lost recovery).
- [ ] [P23] Normalize pixel-perfect scaling behavior across Canvas/WebGPU.
- [ ] [P24] Complete in-browser asset workflow consistency (DSL/Sprite/Sound end-to-end).
- [ ] [P25] Finalize import/export contract for full asset round-trip.
- [ ] [P26] Finalize apply/reload semantics between editor and running game.
- [ ] [P27] Complete multi-game path workflow (`/g/<id>/` discovery/build/publish).
- [ ] [P28] Strengthen CI for all games (check/test/per-game web build/bundle generation).
- [ ] [P29] Add deterministic E2E replay coverage for game behavior stability.
- [ ] [P30] Add Canvas/WebGPU parity validation and acceptable-diff policy.
- [ ] [P31] Add audio regression checks for event-to-sound behavior.
- [ ] [P32] Finalize API/architecture docs for minimal principles and non-goals.
- [ ] [P33] Add at least one additional game sample written in the minimal style.
- [ ] [P34] Measure and optimize runtime/package footprint (fps/memory/bundle size).
- [ ] [P35] Final cleanup pass (naming, module boundaries, dead-code removal) before feature freeze.
