# moon8bit API Plan (Pyxel-Style Thin Wrappers)

## Status

- Date: 2026-04-01
- Scope: post-Stage-1 implementation plan (4/1-4/7)
- Goal: add a shorter, flatter API without breaking current users

## Goals

- Keep existing public APIs (`engine_*`, `run_fixed_frames`, `Frame::*`) fully available.
- Add a thin wrapper layer with shorter names for human and AI-authored code.
- Keep behavior deterministic and equivalent to existing runtime/render semantics.
- Keep wrappers stateless (no hidden global engine state in v1).

## Non-Goals

- Full compatibility with any external engine API.
- Replacing or deleting current APIs.
- Introducing a global singleton runtime model in this phase.

## Proposed Public API (Draft)

All functions are wrappers over current APIs and should stay behavior-equivalent.

```mbt
pub fn config(
  width : Int,
  height : Int,
  fps? : Int = 30,
  scale? : Int = 4,
  palette? : Palette = palette_default(),
) -> EngineConfig

pub fn btn(
  keys_down : Array[String],
  keys_pressed? : Array[String] = [],
  keys_released? : Array[String] = [],
  pointer_x? : Int = 0,
  pointer_y? : Int = 0,
  pointer_down? : Bool = false,
  pointer_pressed? : Bool = false,
  pointer_released? : Bool = false,
) -> InputState

pub fn[T : Game] step(
  game : T,
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> (T, Frame)

pub fn[T : Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (T, Array[Frame])

pub fn cls(frame : Frame, color : Int) -> Unit

pub fn pset(frame : Frame, x : Int, y : Int, color : Int) -> Unit

pub fn rect(
  frame : Frame,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  color : Int,
) -> Unit

pub fn spr(frame : Frame, sprite : Sprite, x : Int, y : Int) -> Unit
```

## Mapping to Existing APIs

- `config` -> `EngineConfig::{ ... }` (same default values as `default_engine_config()`).
- `btn` -> `input_state(raw_keys/pointer_snapshot...)`.
- `step` -> `engine_step(game, config, input, frame)`.
- `run` -> `run_fixed_frames(game, config, inputs)`.
- `cls` -> `Frame::clear(color)`.
- `pset` -> `Frame::set_pixel(x, y, color)`.
- `rect` -> `Frame::draw_rect(x, y, w, h, color)`.
- `spr` -> `Frame::blit(sprite, x, y)`.

## Behavioral Contract

- Wrappers must not add hidden mutation beyond the wrapped call.
- Pixel bounds, transparency (`color < 0` in sprite pixels), and collision/runtime behavior remain unchanged.
- `step` and `run` keep fixed-step determinism identical to current engine behavior.

## Backward Compatibility Rules

- Existing public symbols remain exported and documented.
- New wrappers are additive-only in this phase.
- Any migration examples must show both styles:
  - existing style (`engine_step`, `Frame::set_pixel`, ...)
  - wrapped style (`step`, `pset`, ...)

## Validation Plan (Acceptance Criteria)

1. API compatibility:
   - existing tests pass unchanged.
   - `pkg.generated.mbti` diff shows additive API changes only.
2. Wrapper equivalence tests:
   - `step` output equals `engine_step`.
   - `run` output equals `run_fixed_frames`.
   - `cls/pset/rect/spr` frame results equal corresponding `Frame::*` calls.
3. Sample behavior:
   - `game_driftbird` baseline remains playable and behavior-consistent.
   - `game_driftbird` call sites adopt wrappers where applicable (`btn/run/cls/pset/rect/spr`).
4. Final verification commands:
   - `moon check`
   - `moon test`
   - `moon build --target js cmd/web`
   - `moon info && moon fmt`

## Implementation Notes (File Layout Draft)

- Add wrapper implementations in a focused package file (candidate: `engine_api.mbt`).
- Keep tests isolated (candidate: `engine_api_test.mbt`).
- Avoid mixing wrapper code into large gameplay files.

## Open Questions to Resolve Before Merge

- Should `config` also offer an overload that starts from `default_engine_config()` and only overrides selected fields?
- Should we expose compact key helpers (for example `key_down("Space")`) in the wrapper layer, or keep only explicit raw snapshots?
- Should we expose a CLI/web toggle to compare classic calls vs wrapped calls in the same demo?

## Note (2026-04-05)

- Shared input semantics are now raw-device-first; game-action naming in shared APIs is deprecated in planning docs.
- This document is retained as wrapper-history context; source of truth for direction is `docs/north-star.md` + `docs/decision-log.md`.
