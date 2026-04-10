# Submission Checklist (moon8bit)

## Metadata

- Submission target: MoonBit SCC 2026
- Deadline: 2026-04-21
- Last updated: 2026-04-09

## Stage 1 Gates

- [x] Google Form submitted (2026-04-01)
- [x] Submission timestamp recorded in `docs/handoff.md`
- [x] Stage 1 acceptance received (2026-04-02)

## Messaging Safety

- [ ] Claims are implementation-fact based only
- [ ] No uniqueness/superiority claims without proof
- [ ] Public-facing docs avoid unnecessary competitor comparisons

## Core Implementation (Capability Track)

- [x] Engine core: `init/update/draw` fixed-step runtime
- [x] DSL v1: `palette`, `sprite`, `tilemap` with line-numbered diagnostics
- [x] CLI flow: DSL conversion and validation
- [x] Web Canvas2D rendering path
- [x] WebGPU rendering path with Canvas2D fallback
- [x] Renderer status display (`renderer=webgpu` / `renderer=2d`)
- [x] Audio: BGM + SFX via Web Audio API
- [x] Input: raw key/pointer state + edge transitions
- [x] Collision: `Rect`, `Collider`, AABB with hit tags
- [x] Scheduler: `set_timeout`, `set_interval`, `clear_timers` via `EngineCommand`
- [x] Imperative game API: `ctx.sfx()`, `ctx.bgm_stop()`, `ctx.set_timeout()` etc.
- [x] Utility: `rand(seed, min, max)`, `clamp(value, min, max)`
- [x] Browser editor: DSL apply/import/export loop
- [x] Sprite editor GUI tab
- [x] Sound editor GUI tab
- [x] Per-game web pages under `site/g/<game_id>/`

## Sample Games

- [x] driftbird (side-scroller: input / collision / scrolling / audio)
- [x] breakout (ball physics: subframe collision / entry-axis detection)
- [x] snake (grid game: wrap / food spawn / growth)
- [x] shooting (shooter: star parallax / enemy / sprites)

## Engineering Quality

- [x] 49 tests passing (`moon test`)
- [x] Deterministic runtime: same inputs → same frames
- [x] Collision regression tests (pipe hit / ground hit / score increment)
- [x] Timer/event ordering tests
- [x] Parser error tests (line-numbered diagnostics)
- [x] Sound DSL tests (sound/bgm block parse, note name to MIDI, error cases)
- [ ] Test coverage for breakout / snake / shooting
- [ ] E2E replay coverage per game

## Required Artifacts

- [ ] Final repository URL confirmation
- [ ] Final application text (300+ words) freeze
- [ ] AI usage / retrospective finalization
- [x] README reproducible run steps
- [ ] Demo video/GIF ready and viewable

## Repository Docs

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

- [ ] Driftbird Game tab is playable (`Space` / `ArrowUp`, `R`)
- [ ] Status bar shows `renderer=webgpu` or `renderer=2d`
- [ ] DSL tab `Apply` updates screen output
- [ ] DSL `Import` loads local file and applies
- [ ] DSL `Export` downloads current editor text
- [ ] Sprite tab can edit sprite pixels and write back to DSL
- [ ] Sound tab can preview/tune BGM/SFX

## Final Submission Pass

- [ ] Freeze major features (docs/bugfix only after this point)
- [ ] Re-run reproducibility checks
- [ ] Ensure docs match implementation
- [ ] Ensure commit history is clean/readable
- [ ] Submit final application text + demo link

## Remaining Priorities (2026-04-11)

1. Add tests for breakout / snake / shooting.
2. Record demo video/GIF.
3. Final docs sync (README updated 2026-04-11).
4. Freeze and submit.
