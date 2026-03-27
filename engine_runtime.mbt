///|
pub trait Game {
  init(Self, RuntimeContext) -> Self
  update(Self, RuntimeContext) -> Self
  draw(Self, RuntimeContext) -> Frame
}

///|
fn make_context(
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> RuntimeContext {
  let dt_ms = if config.fps <= 0 { 16 } else { 1000 / config.fps }
  RuntimeContext::{ config, input, frame, dt_ms }
}

///|
pub fn[T : Game] engine_init(initial : T, config : EngineConfig) -> T {
  let context = make_context(config, input_none, 0)
  Game::init(initial, context)
}

///|
pub fn[T : Game] engine_step(
  game : T,
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> (T, Frame) {
  let context = make_context(config, input, frame)
  let next = Game::update(game, context)
  let rendered = Game::draw(next, context)
  (next, rendered)
}

///|
pub fn[T : Game] run_fixed_frames(
  initial : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (T, Array[Frame]) {
  let mut state = engine_init(initial, config)
  let frames : Array[Frame] = []
  for i, input in inputs {
    let (next, rendered) = engine_step(state, config, input, i)
    state = next
    frames.push(rendered)
  }
  (state, frames)
}
