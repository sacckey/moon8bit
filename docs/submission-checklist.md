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
