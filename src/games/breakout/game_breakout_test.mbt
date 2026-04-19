///|
fn test_bundle() -> @model.AssetBundle {
  @model.AssetBundle::{
    palette: @model.palette_default(),
    sprites: [],
    tiles: @model.Tiles::{
      name: "main",
      tile_count: 8,
      tile_names: [],
      tile_solid: [],
      pixels: Array::make(8 * 64, -1),
    },
    tilemaps: [],
    placements: [],
    sounds: [],
    bgms: [],
  }
}

///|
fn breakout_config() -> @model.EngineConfig {
  @engine.config(128, 128, fps=60, scale=1)
}

///|
fn breakout_inputs(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    if i == 0 {
      down.push("Space")
      pressed.push("Space")
    }
    if i % 32 < 16 {
      down.push("ArrowRight")
    } else {
      down.push("ArrowLeft")
    }
    inputs.push(@model.input_state(down, pressed, []))
  }
  inputs
}

///|
fn run_breakout(
  inputs : Array[@model.InputState],
) -> (@engine.EngineInstance[@breakout.BreakoutGame], Array[@model.Frame]) {
  let mut runtime = @breakout.init_game(test_bundle(), breakout_config())
  let frames : Array[@model.Frame] = []
  for input in inputs {
    let (next, frame) = @breakout.step_game(runtime, input)
    runtime = next
    frames.push(frame)
  }
  (runtime, frames)
}

///|
test "breakout deterministic replay with identical inputs" {
  let inputs = breakout_inputs(180)
  let (runtime1, frames1) = run_breakout(inputs)
  let (runtime2, frames2) = run_breakout(inputs)

  assert_eq(runtime1, runtime2)
  assert_eq(frames1, frames2)
}

///|
test "breakout launching with space changes rendered progression" {
  let idle_inputs = [@model.input_none, @model.input_none, @model.input_none]
  let launch_inputs = [
    @model.input_state(["Space"], ["Space"], []),
    @model.input_none,
    @model.input_none,
  ]
  let (_, idle_frames) = run_breakout(idle_inputs)
  let (_, launch_frames) = run_breakout(launch_inputs)

  assert_true(idle_frames[2] != launch_frames[2])
}
