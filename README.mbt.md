<br>
<p align="center">
  <img src="https://raw.githubusercontent.com/sacckey/moon8bit/refs/heads/main/resource/logo/moon8bit-logo.png" width="480px">
</p>
<br>

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

Core ideas:
- Text-first assets (`assets.dsl`), not binary-first workflows
- Deterministic fixed-step runtime for reproducible behavior/tests
- Portable runtime model (MoonBit + Web/Wasm)

**[Try the demo in your browser](https://sacckey.github.io/moon8bit/g/)**

## Current Snapshot

- Goal: make AI-assisted retro game iteration practical in MoonBit
- Architecture: `assets DSL parser -> runtime model -> renderer -> shared web runtime`
- Renderer: WebGPU path + Canvas2D fallback (`renderer=webgpu|2d` status)
- Sample games: `flappy`, `breakout`, `snake`, `shooting`, `platformer`
- Browser editor tabs: `Game / DSL / Palette / Sprite / Tile / Tilemap / SFX / BGM`

## Repository Layout

- `src/model` — core data types (`AssetBundle`, `Frame`, `InputState`, tile/collision types)
- `src/assets` — DSL parser and JSON conversion helpers
- `src/engine` — deterministic runtime loop, update/draw contexts, events/timers, drawing helpers
- `src/cmd/main` — CLI (`assets`, `assets-file`)
- `src/cmd/web` — shared browser runtime/editor shell and renderer/audio glue
- `src/games/<game_id>` — per-game logic, tests, `assets.dsl`, `game_spec.json`, and `web` entry package
- `scripts/update_demo_bundle.sh` — builds per-game web bundles and regenerates `site/g/*`

## Requirements

- MoonBit toolchain (`moon`)
- Python 3 (`python3 -m http.server` for local preview)
- Modern browser (WebGPU-capable browser recommended; Canvas2D fallback is automatic)

## Quick Start

```bash
moon check
moon test
```

## Run Local Web Demo

```bash
./scripts/update_demo_bundle.sh
python3 -m http.server 8000 --directory site
```

Open:
- `http://localhost:8000/` (top)
- `http://localhost:8000/g/` (game list)
- `http://localhost:8000/g/<game_id>/` (per-game page)

## CLI Usage

Convert DSL text to JSON:

```bash
moon run src/cmd/main -- assets "sprite hero 8 8\n1.......\n........\n........\n........\n........\n........\n........\n........\nend"
```

Convert DSL file to JSON file:

```bash
moon run src/cmd/main --target js -- assets-file assets.dsl assets.json
```

## Browser Editor

- `Game`: playable runtime view
- `DSL`: edit/apply/import/export `assets.dsl`
- `Palette`: 0-15 palette color editor with DSL write-back
- `Sprite`: sprite list + pixel editor (add/dup/delete, rename, resize 8/16/32)
- `Tile`: tile (8x8) editor, tile metadata (`name`, `solid`)
- `Tilemap`: map paint/erase, map add/delete/resize, DSL write-back
- `SFX`: per-sound synthesis editor (`wave`, `f0/f1`, `attack`, `decay`, `volume`)
- `BGM`: multi-BGM editor (`wave`, `volume`, `step_sec`, `loop`, `notes`) + piano-roll editing (Drag: note, `Shift+Drag`: tie `~`, Right-drag: rest `R`)

## Asset DSL Reference

### Palette

```text
palette dawn
color 0 #0f1a20
color 1 #274060
end
```

Notes:
- Parser accepts sequential `color <index> <hex>` rows
- `index` must start at 0 and increase by 1

### Sprite

```text
sprite bird 8 8
...000..
..03330.
.0330340
.0333300
0033330.
0333330.
.03330..
..0000..
end
```

Notes:
- `.` = transparent (`-1`)
- `0-9`, `a-f`, `A-F` = palette indices
- Width/height must each be `8`, `16`, or `32`

### Tile

```text
tile 1 grass solid
22222222
23333332
23333332
23333332
23333332
23333332
23333332
22222222
end
```

Notes:
- Header: `tile <id> [name] [solid]`
- `id` must be in `0..255`
- Each tile is fixed 8x8

### Tilemap

```text
tilemap field 8 4
1 1 1 1 1 1 1 1
1 . . . . . . 1
1 . . . . . . 1
1 1 1 1 1 1 1 1
end
```

Notes:
- Header: `tilemap <name> <width> <height>`
- Use `.` for transparent cells

### Placement

```text
place player_spawn hero 16 32
```

Notes:
- Directive: `place <name> <sprite> <x> <y>`
- Parser validates referenced sprite names

### Sound (SFX)

```text
sound flap
wave square
attack 0.003
decay 0.10
volume 0.07
f0 520
f1 360
end
```

### BGM

```text
bgm main
wave square
volume 0.04
step_sec 0.125
loop true
notes C4 ~ ~ G4 R
end
```

Notes:
- Notes support `C D E F G A B`, optional `#`/`b`, octave (e.g. `C#4`, `Db4`), `R` (rest), and `~` (tie: extend previous note without re-attack)
- Parser keeps note tokens as text (`Array[String]`) and validates note syntax
- Runtime converts tokens to MIDI when rendering/playback needs pitch values
- BGM piano roll currently shows `C3` to `C7`, auto-fills available width, and supports horizontal scroll for long sequences

## Engine Model

- `init(self, config) -> Self`: initialize/reset state
- `update(self, ctx) -> Self`: deterministic fixed-step state transition
- `draw(self, ctx) -> Frame`: pure frame generation

Runtime event flow:
- Game emits commands/events (SFX, BGM start/stop, timers)
- Engine queues and dispatches events in deterministic order
- Web runtime consumes events for audio playback

## Why AI-Friendly

- Text DSL is easy to prompt/diff/review/regenerate
- Parser errors include line numbers for quick repair loops
- Deterministic loop keeps behavior and tests stable
- Compact package boundaries (`model/assets/engine/games/web`) make code inspection practical

## Publish to GitHub Pages

`site/` contents are generated from current game packages:

```bash
./scripts/update_demo_bundle.sh
```

Generated paths:
- `/` top page
- `/g/` game list
- `/g/<game_id>/` per-game playable/editor page
