# moon8bit

`moon8bit` is a compact retro 2D game engine prototype for MoonBit, designed to be **AI-friendly**.

The core idea is simple:
- Keep assets text-first (DSL), not binary-first.
- Keep gameplay deterministic (fixed-step update).
- Keep output portable (MoonBit + Web/Wasm-ready runtime model).

## Current MVP

Implemented in this repository:
- Public engine API:
  - `EngineConfig`
  - `Game` trait with `init/update/draw`
  - `Sprite`, `Tilemap`, `Palette`, `AssetBundle`
- Asset DSL v1 parser:
  - `palette`, `sprite`, `tilemap`, `end`
  - line-numbered parse errors
- Asset conversion helper:
  - DSL -> JSON string
- Sample game:
  - bird-like side scroller
  - flap/reset input
  - collision detection and scrolling obstacles
- CLI:
  - `demo`
  - `sample-dsl`
  - `assets`

## Quick Start

```bash
moon check
moon test
moon run cmd/main -- demo 60
```

Run browser demo (Canvas 2D):

```bash
moon build --target js cmd/web
python3 -m http.server 8000
# open http://localhost:8000/cmd/web/index.html
```

Controls:
- `Space` / `ArrowUp`: flap
- `R`: reset
- edit DSL in the textarea and click `Apply DSL` (or `Ctrl/Cmd + Enter`)
- `Export DSL`: download current editor text as `moon8bit_assets.dsl`
- `Import DSL`: load a local `.dsl`/`.txt` file into the editor and apply it

Convert DSL text to JSON:

```bash
moon run cmd/main -- assets "sprite hero 2 1\\n11\\nend"
```

Convert DSL file to JSON file (`--target js`):

```bash
moon run cmd/main --target js -- assets-file assets.dsl assets.json
```

Print built-in sample DSL:

```bash
moon run cmd/main -- sample-dsl
```

## DSL v1

### Palette

```text
palette dawn
color 0 #0f1a20
color 1 #274060
end
```

### Sprite

```text
sprite bird 5 3
.666.
64646
.666.
end
```

- `.` means transparent (`-1`)
- `0-9`, `a-f`, `A-F` are palette indices

### Tilemap

```text
tilemap ground 8 2
5 5 5 5 5 5 5 5
3 3 3 3 3 3 3 3
end
```

- `ground` is used for the scrolling floor band.
- `bg` is used for the scrolling background layer.

## Engine Model

- `init`: create/reset game state.
- `update`: fixed-step state transition (deterministic).
- `draw`: pure frame generation from current state.

This structure makes generated game code easy for AI to produce and refactor.

## Why AI-Friendly

- Text DSL is easy to prompt, diff, review, and regenerate.
- Line-numbered parser errors are easy to feed back into iterative AI loops.
- Deterministic game loop makes AI-generated tests stable.

## Context Harness (Anti-Drift)

To avoid goal drift across daily AI-assisted sessions, keep these docs updated:

- `docs/north-star.md`: project mission, scope, and non-goals.
- `docs/session-brief.md`: session start checklist (today focus and out-of-scope).
- `docs/decision-log.md`: short architecture/product decisions with reasons.
- `docs/handoff.md`: session end `Done / Next / Risks`.
- `docs/ai-usage-log.md`: retrospective log of AI usage.

Recommended routine:

1. Start session by reading `north-star` and writing `session-brief`.
2. During work, append major decisions to `decision-log`.
3. End session by writing `handoff` and updating `ai-usage-log`.

## Validation

This repository currently includes:
- DSL success/error tests
- Deterministic engine tests
- Integration test for bird-like sample loop

Run everything:

```bash
moon test
```
