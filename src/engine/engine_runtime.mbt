///|
type EngineConfig = @model.EngineConfig

///|
type InputState = @model.InputState

///|
type Frame = @model.Frame

///|
pub(all) enum EngineEvent {
  Sfx(String)
  BgmStart
  BgmStop
} derive(Eq, Show)

///|
pub(all) enum EngineCommand {
  Emit(EngineEvent)
  SetTimeout(Int, EngineEvent)
  SetInterval(Int, EngineEvent)
  ClearTimers
} derive(Eq, Show)

///|
pub(all) struct EngineTimer {
  kind : EngineEvent
  remaining_frames : Int
  interval_frames : Int
} derive(Eq, Show)

///|
pub(all) struct UpdateContext {
  config : EngineConfig
  input : InputState
  prev_input : InputState
  tick : Int
  dt_ms : Int
} derive(Eq, Show)

///|
pub(all) struct DrawContext {
  config : EngineConfig
  tick : Int
} derive(Eq, Show)

///|
pub(all) struct EngineInstance[T] {
  config : EngineConfig
  game : T
  tick : Int
  prev_input : InputState
  event_queue : Array[EngineEvent]
  timers : Array[EngineTimer]
} derive(Eq, Show)

///|
let input_none : InputState = @model.input_none

///|
pub(open) trait Game {
  init(Self, EngineConfig) -> Self
  update(Self, UpdateContext) -> (Self, Array[EngineCommand])
  draw(Self, DrawContext) -> Frame
}

///|
fn dt_ms(config : EngineConfig) -> Int {
  if config.fps <= 0 {
    16
  } else {
    1000 / config.fps
  }
}

///|
fn[T] make_update_context(
  state : EngineInstance[T],
  input : InputState,
) -> UpdateContext {
  UpdateContext::{
    config: state.config,
    input,
    prev_input: state.prev_input,
    tick: state.tick,
    dt_ms: dt_ms(state.config),
  }
}

///|
fn[T] make_draw_context(state : EngineInstance[T]) -> DrawContext {
  DrawContext::{ config: state.config, tick: state.tick }
}

///|
fn timer_frames(frames : Int) -> Int {
  if frames <= 0 {
    1
  } else {
    frames
  }
}

///|
fn advance_timers(
  timers : Array[EngineTimer],
) -> (Array[EngineTimer], Array[EngineEvent]) {
  let next_timers : Array[EngineTimer] = []
  let emitted : Array[EngineEvent] = []
  for timer in timers {
    let remaining = timer.remaining_frames - 1
    if remaining <= 0 {
      emitted.push(timer.kind)
      if timer.interval_frames > 0 {
        next_timers.push(EngineTimer::{
          kind: timer.kind,
          remaining_frames: timer.interval_frames,
          interval_frames: timer.interval_frames,
        })
      }
    } else {
      next_timers.push(EngineTimer::{
        kind: timer.kind,
        remaining_frames: remaining,
        interval_frames: timer.interval_frames,
      })
    }
  }
  (next_timers, emitted)
}

///|
fn copy_timers(timers : Array[EngineTimer]) -> Array[EngineTimer] {
  let next_timers : Array[EngineTimer] = []
  for timer in timers {
    next_timers.push(timer)
  }
  next_timers
}

///|
fn apply_commands(
  base_timers : Array[EngineTimer],
  commands : Array[EngineCommand],
) -> (Array[EngineTimer], Array[EngineEvent]) {
  let mut timers = copy_timers(base_timers)
  let emitted : Array[EngineEvent] = []
  for command in commands {
    match command {
      Emit(event) => emitted.push(event)
      SetTimeout(frames, event) =>
        timers.push(EngineTimer::{
          kind: event,
          remaining_frames: timer_frames(frames),
          interval_frames: 0,
        })
      SetInterval(frames, event) => {
        let interval = timer_frames(frames)
        timers.push(EngineTimer::{
          kind: event,
          remaining_frames: interval,
          interval_frames: interval,
        })
      }
      ClearTimers => timers = []
    }
  }
  (timers, emitted)
}

///|
pub fn[T : Game] engine_init(
  initial : T,
  config : EngineConfig,
) -> EngineInstance[T] {
  EngineInstance::{
    config,
    game: Game::init(initial, config),
    tick: 0,
    prev_input: input_none,
    event_queue: [],
    timers: [],
  }
}

///|
pub fn[T : Game] engine_step(
  state : EngineInstance[T],
  input : InputState,
) -> (EngineInstance[T], Frame) {
  let update_ctx = make_update_context(state, input)
  let (next_game, commands) = Game::update(state.game, update_ctx)
  let (next_timers, timer_emitted) = advance_timers(state.timers)
  let (final_timers, command_emitted) = apply_commands(next_timers, commands)
  let all_emitted : Array[EngineEvent] = []
  for event in timer_emitted {
    all_emitted.push(event)
  }
  for event in command_emitted {
    all_emitted.push(event)
  }
  let next_state = EngineInstance::{
    config: state.config,
    game: next_game,
    tick: state.tick + 1,
    prev_input: input,
    event_queue: all_emitted,
    timers: final_timers,
  }
  let rendered = Game::draw(next_state.game, make_draw_context(next_state))
  (next_state, rendered)
}

///|
pub fn[T : Game] run_fixed_frames(
  initial : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (EngineInstance[T], Array[Frame]) {
  let mut state = engine_init(initial, config)
  let frames : Array[Frame] = []
  for input in inputs {
    let (next, rendered) = engine_step(state, input)
    state = next
    frames.push(rendered)
  }
  (state, frames)
}

///|
pub fn[T] engine_game(state : EngineInstance[T]) -> T {
  state.game
}

///|
pub fn[T] engine_with_game(
  state : EngineInstance[T],
  game : T,
) -> EngineInstance[T] {
  EngineInstance::{
    config: state.config,
    game,
    tick: state.tick,
    prev_input: state.prev_input,
    event_queue: state.event_queue,
    timers: state.timers,
  }
}

///|
pub fn[T] engine_events(state : EngineInstance[T]) -> Array[EngineEvent] {
  state.event_queue
}

///|
pub fn[T] engine_take_events(
  state : EngineInstance[T],
) -> (EngineInstance[T], Array[EngineEvent]) {
  (
    EngineInstance::{
      config: state.config,
      game: state.game,
      tick: state.tick,
      prev_input: state.prev_input,
      event_queue: [],
      timers: state.timers,
    },
    state.event_queue,
  )
}

///|
pub fn emit(event : EngineEvent) -> EngineCommand {
  EngineCommand::Emit(event)
}

///|
pub fn sfx(name : String) -> EngineCommand {
  EngineCommand::Emit(EngineEvent::Sfx(name))
}

///|
pub fn bgm_start() -> EngineCommand {
  EngineCommand::Emit(EngineEvent::BgmStart)
}

///|
pub fn bgm_stop() -> EngineCommand {
  EngineCommand::Emit(EngineEvent::BgmStop)
}

///|
pub fn set_timeout_cmd(frames : Int, event : EngineEvent) -> EngineCommand {
  EngineCommand::SetTimeout(frames, event)
}

///|
pub fn set_interval_cmd(frames : Int, event : EngineEvent) -> EngineCommand {
  EngineCommand::SetInterval(frames, event)
}

///|
pub fn clear_timers_cmd() -> EngineCommand {
  EngineCommand::ClearTimers
}
