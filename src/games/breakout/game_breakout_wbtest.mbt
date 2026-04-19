///|
fn breakout_input_script(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    if i == 0 {
      down.push("Space")
      pressed.push("Space")
    }
    if i % 40 < 20 {
      down.push("ArrowRight")
    } else {
      down.push("ArrowLeft")
    }
    inputs.push(@model.input_state(down, pressed, []))
  }
  inputs
}

///|
fn breakout_config() -> @model.EngineConfig {
  @engine.config(screen_w, screen_h, fps=60, scale=1)
}

///|
test "breakout deterministic replay with identical scripted inputs" {
  let config = breakout_config()
  let inputs = breakout_input_script(180)
  let (runtime1, frames1) = @engine.run_fixed_frames(
    new_breakout_game(),
    config,
    inputs,
  )
  let (runtime2, frames2) = @engine.run_fixed_frames(
    new_breakout_game(),
    config,
    inputs,
  )

  assert_eq(@engine.engine_game(runtime1), @engine.engine_game(runtime2))
  assert_eq(frames1, frames2)
}

///|
test "breakout starts when pressing space" {
  let runtime = @engine.engine_init(new_breakout_game(), breakout_config())
  assert_true(!@engine.engine_game(runtime).is_started)

  let (next_runtime, _) = @engine.engine_step(
    runtime,
    @model.input_state(["Space"], ["Space"], []),
  )
  assert_true(@engine.engine_game(next_runtime).is_started)
}

///|
test "breakout paddle movement stays clamped at left wall" {
  let runtime = @engine.engine_init(new_breakout_game(), breakout_config())
  let state = @engine.engine_game(runtime)
  state.pad_x = 0
  let prepared = @engine.engine_with_game(runtime, state)

  let (next_runtime, _) = @engine.engine_step(
    prepared,
    @model.input_state(["ArrowLeft"], [], []),
  )
  assert_eq(@engine.engine_game(next_runtime).pad_x, 0)
}
