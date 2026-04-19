# Session Brief

## Session

- Date: 2026-04-18
- Branch: `main`
- Deadline: 2026-04-21

## Current State

- 72 tests passing
- 5 sample games: driftbird, breakout, snake, shooting, platformer
- WebGPU rendering live (Canvas2D fallback) + renderer status in UI
- Browser editor tabs: Game / DSL / Palette / Sprite / Tile / Tilemap / SFX / BGM
- Tilemap editor supports tile paint, sprite placement, map add/delete/resize, tile metadata (`name`/`solid`)

## Remaining Work (Implementation Priority)

1. **Game tests expansion**
   - Add automated tests for breakout / snake / shooting / platformer.
   - Keep driftbird as baseline regression set.

2. **Deterministic replay coverage**
   - Add per-game replay scripts and stable expected outputs.
   - Cover core loops: start/restart, score progression, game-over/clear paths.

3. **Platformer feel + regression lock**
   - Lock jump behavior (coyote/jump buffer/jump-cut) with tests.
   - Validate enemy movement and placement-driven spawn behavior.

4. **Editor UX polish for larger maps**
   - Verify viewport-grid workflow and map editing ergonomics.
   - Improve error/dirty/save feedback consistency across tabs.

5. **WebGPU hardening**
   - Reduce per-frame overhead (`writeTexture` path).
   - Keep graceful fallback behavior for unsupported/failed GPU contexts.

## Out of Scope Until Freeze

- New engine subsystems unrelated to current checklist
- Breaking DSL redesigns
- Non-essential architectural rewrites

## Quick Restart Commands

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```
