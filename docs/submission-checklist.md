# Submission Checklist (moon8bit)

## Metadata

- Submission target: MoonBit SCC 2026
- Deadline: 2026-04-21
- Last updated: 2026-04-21

## Final Submission Essentials (Official Summary)

Based on:
- SCC Regulations (`https://www.moonbitlang.com/2026-scc`, especially Evaluation + Open Source Requirements)
- Suggested materials guidance:
  - public GitHub repo with commit history
  - README (goals/scope/usage/environment)
  - reproducible build/run path
  - tests/validation for core and edge cases
  - optional: demo video/screenshots/deployment links

- [x] Public GitHub repository is confirmed public and commit history preserved
- [x] README covers goals, scope, usage, and environment requirements
- [x] Reproducible build/run path for core workflow is documented
- [x] Tests/validation materials for key paths and edge cases are present
- [x] OSI-approved license is present (`LICENSE`: Apache-2.0)
- [x] Supporting artifacts/scripts are open-sourced in repository
- [x] Development retrospective materials are present (`docs/decision-log.md`, `docs/ai-usage-log.md`)
- [ ] Demo video/GIF is finalized and shareable
- [ ] Screenshots are finalized and shareable
- [x] Deployment links are documented (`README.mbt.md` GitHub Pages section)

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
- [x] DSL v1: `palette`, `sprite`, `tile`, `tilemap`, `place` with line-numbered diagnostics
- [x] Tile DSL: `tile <id> <name> [solid]` with inline 8×8 pixel data; named solid flags
- [x] Placement DSL: `place <name> <sprite> <x> <y>` for actor spawn data; `find_placements_by_sprite`
- [x] CLI flow: DSL conversion and validation
- [x] Web Canvas2D rendering path
- [x] WebGPU rendering path with Canvas2D fallback
- [x] Renderer status display (`renderer=webgpu` / `renderer=2d`)
- [x] Audio: BGM + SFX via Web Audio API
- [x] Input: raw key/pointer state + edge transitions (`key_down`, `key_pressed`, `key_released`, `key_down_any`, etc.)
- [x] Collision: `Rect`, `Collider`, AABB with hit tags; `rect_intersects`, `tile_solid_any_in_rect`, `tile_id_any_in_rect`
- [x] Swept collision helpers: `swept_move_x / swept_move_y`
- [x] Camera: `camera_follow`, `camera_clamp`, `world_to_screen_*`, `spr_world`, `rect_world`, `draw_tilemap_world`
- [x] Tilemap rendering: `draw_tilemap` (camera offset, transparent tiles), `draw_tilemap_world`
- [x] Scheduler: `set_timeout`, `set_interval`, `clear_timers` via `EngineCommand`; `ctx.bgm_start()`
- [x] Imperative game API: `ctx.sfx()`, `ctx.bgm_start()`, `ctx.bgm_stop()`, `ctx.set_timeout()` etc.
- [x] Utility: `rand(seed, min, max)`, `clamp(value, min, max)`, `every(tick, interval)`
- [x] UI primitives: `ui_text`, `ui_panel`, `ui_text_width`, `ui_center_x/y`
- [x] Browser editor: DSL apply/import/export loop; fullscreen layout, dynamic canvas scaling
- [x] Sprite editor GUI tab
- [x] Tile editor GUI tab: 8×8 pixel editor, tile name/solid metadata
- [x] Tilemap editor GUI tab: tilemap paint/erase, `+ Map`/`Del Map`/`Resize`, tile `name`/`solid`, tile 8×8 pixel edit, dirty/feedback
- [x] Sound editor GUI tab: SFX cards (wave/f0/f1/ATK/DEC/VOL + Test/Dup/Del), `+ SFX`, multi-BGM selector, `+ BGM`/`Dup`/`Del`, dirty indicator
- [x] Per-game web pages under `site/g/<game_id>/`

## Sample Games

- [x] flappy (side-scroller: input / collision / scrolling / audio)
- [x] breakout (ball physics: subframe collision / entry-axis detection)
- [x] snake (grid game: wrap / food spawn / growth)
- [x] shooting (shooter: star parallax / enemy / sprites)
- [x] platformer (camera / swept collision / placement spawn / coyote time / jump buffer)

## Engineering Quality

- [x] 94 tests passing (`moon test`)
- [x] Deterministic runtime: same inputs → same frames
- [x] Collision regression tests (pipe hit / ground hit / score increment)
- [x] Timer/event ordering tests
- [x] Parser error tests (line-numbered diagnostics)
- [x] Sound DSL tests (sound/bgm block parse, note name to MIDI, error cases)
- [x] Tile/tilemap DSL tests (parse, validation, pixel lookup, round-trip)
- [x] Placement DSL tests (parse, unknown sprite reference error)
- [x] Test coverage for breakout / snake / shooting / platformer
- [x] E2E replay coverage per game

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
- [x] `docs/tilemap-spec.md`

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
- `http://localhost:8000/g/flappy/`

Expected:

- [ ] Flappy Game tab is playable (`Space` / `ArrowUp`, `R`)
- [ ] Status bar shows `renderer=webgpu` or `renderer=2d`
- [ ] DSL tab `Apply` updates screen output
- [ ] DSL `Import` loads local file and applies
- [ ] DSL `Export` downloads current editor text
- [ ] Sprite tab can edit sprite pixels and write back to DSL
- [ ] Palette tab can edit 16 colors (picker + HEX) and write back to DSL
- [ ] Tile tab can edit 8x8 pixels and write back to DSL
- [ ] Tilemap tab can edit map/tile and write back to DSL
- [ ] SFX tab can preview/tune SFX
- [ ] BGM tab can preview/tune BGM

## Final Submission Pass

- [ ] Freeze major features (docs/bugfix only after this point)
- [ ] Re-run reproducibility checks
- [ ] Ensure docs match implementation
- [ ] Ensure commit history is clean/readable
- [ ] Submit final application text + demo link

## Remaining Priorities (2026-04-19)

1. Demo video/GIF recording (playable games: flappy, platformer, shooting recommended).
2. Final application text freeze (`docs/application-draft.md`).
3. Final reproducibility pass (build → run → edit loop on clean env).
