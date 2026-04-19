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
fn shooting_config() -> @model.EngineConfig {
  @engine.config(128, 128, fps=60, scale=1)
}

///|
fn shooting_inputs(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    if i % 20 < 10 {
      down.push("ArrowRight")
    } else {
      down.push("ArrowLeft")
    }
    if i % 12 < 3 {
      down.push("Space")
    }
    if i % 12 == 0 {
      pressed.push("Space")
    }
    inputs.push(@model.input_state(down, pressed, []))
  }
  inputs
}

///|
fn run_shooting(
  inputs : Array[@model.InputState],
) -> (@engine.EngineInstance[@shooting.ShootingGame], Array[@model.Frame]) {
  let mut runtime = @shooting.init_game(test_bundle(), shooting_config())
  let frames : Array[@model.Frame] = []
  for input in inputs {
    let (next, frame) = @shooting.step_game(runtime, input)
    runtime = next
    frames.push(frame)
  }
  (runtime, frames)
}

///|
test "shooting deterministic replay with identical inputs" {
  let inputs = shooting_inputs(180)
  let (runtime1, frames1) = run_shooting(inputs)
  let (runtime2, frames2) = run_shooting(inputs)

  assert_eq(runtime1, runtime2)
  assert_eq(frames1, frames2)
}

///|
test "shooting move input changes immediate rendered frame" {
  let idle_inputs = [@model.input_none]
  let move_inputs = [@model.input_state(["ArrowRight"], ["ArrowRight"], [])]
  let (_, idle_frames) = run_shooting(idle_inputs)
  let (_, move_frames) = run_shooting(move_inputs)

  assert_true(idle_frames[0] != move_frames[0])
}
