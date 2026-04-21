<br>
<p align="center">
  <img src="https://raw.githubusercontent.com/sacckey/moon8bit/refs/heads/main/resource/logo/moon8bit-logo.png" width="480px">
</p>
<br>

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

Goal:
- Make AI-assisted retro game iteration practical in MoonBit.

Scope:
- Text-first asset workflow (`assets.dsl`)
- Deterministic fixed-step runtime (`init/update/draw`)
- Browser runtime/editor with WebGPU + Canvas2D fallback
- Per-game packaging under `src/games/<game_id>`

**[Try the demo in your browser](https://sacckey.github.io/moon8bit/g/)**

## What This Repository Includes

- `src/model` — core data types (`AssetBundle`, `Frame`, `InputState`, tile/collision types)
- `src/assets` — DSL parser and JSON conversion helpers
- `src/engine` — deterministic runtime loop, update/draw contexts, events/timers, drawing helpers
- `src/cmd/main` — CLI (`assets`, `assets-file`)
- `src/cmd/web` — shared browser runtime/editor shell and renderer/audio glue
- `src/games/<game_id>` — per-game logic, tests, `assets.dsl`, `game_spec.json`, and `web` entry package
- `scripts/update_demo_bundle.sh` — builds per-game web bundles and regenerates `site/g/<game_id>/*`

Implemented editor tabs:
- `Game / DSL / Palette / Sprite / Tile / Tilemap / SFX / BGM`

Sample games:
- `flappy`, `breakout`, `snake`, `shooting`, `platformer`

## Environment Requirements

- MoonBit toolchain (`moon`)
- Python 3 (for local static hosting)
- Modern browser (WebGPU-capable browser recommended; Canvas2D fallback is automatic)

## Reproducible Build / Run Path

```bash
moon check
moon test
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

Open:
- `http://localhost:8000/` (top)
- `http://localhost:8000/g/` (game list)
- `http://localhost:8000/g/<game_id>/` (per-game page)

Quick verification checklist:
- Game is playable in `Game` tab
- `renderer=webgpu` or `renderer=2d` status is visible
- DSL edit + `Apply` reflects immediately
- Sprite/Tile/Tilemap/SFX/BGM edits can be applied and reflected

## Distribution

`site/` contents are generated from current game packages:

```bash
./scripts/update_demo_bundle.sh
```

Generated paths:
- `/` top page
- `/g/` game list
- `/g/<game_id>/` per-game playable/editor page

## Project Documents

- Submission draft: `docs/application-draft.md`
- AI usage retrospective: `docs/ai-usage-log.md`
- Architecture decisions: `docs/decision-log.md`
- Docs index (submission-facing vs internal): `docs/README.md`

## License

Apache-2.0 (`LICENSE`)
