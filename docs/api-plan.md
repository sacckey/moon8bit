# moon8bit API Plan (Thin Wrapper Layer)

## Status

- Date: 2026-04-06
- Scope: wrapper/API layer status and remaining API-facing work
- Source of truth for architecture: `docs/north-star.md`

## Implemented Wrapper Surface

Current public wrapper APIs are available and tested:

```mbt
pub fn config(
  width : Int,
  height : Int,
  fps? : Int = 60,
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
  state : EngineInstance[T],
  input : InputState,
) -> (EngineInstance[T], Frame)

pub fn[T : Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (EngineInstance[T], Array[Frame])

pub fn cls(frame : Frame, color : Int) -> Unit
pub fn pset(frame : Frame, x : Int, y : Int, color : Int) -> Unit
pub fn rect(frame : Frame, x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit
pub fn spr(frame : Frame, sprite : Sprite, x : Int, y : Int) -> Unit
```

## Runtime API Evolution (Implemented)

- Runtime ownership moved to `EngineInstance`.
- `engine_step` no longer requires caller-owned frame counter.
- `Game` protocol now uses context split:
  - `UpdateContext`
  - `DrawContext`
- Event/timer handling is command-based:
  - `EngineCommand::Emit`
  - `EngineCommand::SetTimeout`
  - `EngineCommand::SetInterval`
  - `EngineCommand::ClearTimers`

## Compatibility Policy

- Existing stable wrappers remain additive and game-neutral.
- Shared layers expose raw input state only (keys/pointer + edge transitions).
- Game-specific meaning (`jump`, `reset`, etc.) is resolved in game packages.

## Validation Status

- Wrapper equivalence tests: implemented.
- Determinism/runtime regression tests: implemented.
- Event ordering behavior tests: implemented.
- `pkg.generated.mbti` is reviewed with each API-facing change.

## Remaining API-Facing Work

1. Keep sample game code short by adding only game-neutral helpers.
2. Avoid re-introducing game-specific nouns into shared API.
3. Keep README examples synchronized with actual signatures.

## Historical Note

- This file is now an implementation-status document.
- Earlier draft signatures that used explicit frame arguments are superseded by the current `EngineInstance`-based runtime model.
