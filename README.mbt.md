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

Convert DSL text to JSON:

```bash
moon run cmd/main -- assets "sprite hero 2 1\\n11\\nend"
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

## Engine Model

- `init`: create/reset game state.
- `update`: fixed-step state transition (deterministic).
- `draw`: pure frame generation from current state.

This structure makes generated game code easy for AI to produce and refactor.

## Why AI-Friendly

- Text DSL is easy to prompt, diff, review, and regenerate.
- Line-numbered parser errors are easy to feed back into iterative AI loops.
- Deterministic game loop makes AI-generated tests stable.

## Validation

This repository currently includes:
- DSL success/error tests
- Deterministic engine tests
- Integration test for bird-like sample loop

Run everything:

```bash
moon test
```
