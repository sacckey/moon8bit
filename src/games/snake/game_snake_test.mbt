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
fn snake_config() -> @model.EngineConfig {
  @engine.config(128, 128, fps=60, scale=1)
}

///|
fn snake_inputs(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    if i == 8 {
      down.push("ArrowDown")
      pressed.push("ArrowDown")
    } else if i == 24 {
      down.push("ArrowLeft")
      pressed.push("ArrowLeft")
    } else if i == 40 {
      down.push("ArrowUp")
      pressed.push("ArrowUp")
    }
    inputs.push(@model.input_state(down, pressed, []))
  }
  inputs
}

///|
fn run_snake(
  inputs : Array[@model.InputState],
) -> (@engine.EngineInstance[@snake.SnakeGame], Array[@model.Frame]) {
  let mut runtime = @snake.init_game(test_bundle(), snake_config())
  let frames : Array[@model.Frame] = []
  for input in inputs {
    let (next, frame) = @snake.step_game(runtime, input)
    runtime = next
    frames.push(frame)
  }
  (runtime, frames)
}

///|
test "snake deterministic replay with identical inputs" {
  let inputs = snake_inputs(96)
  let (runtime1, frames1) = run_snake(inputs)
  let (runtime2, frames2) = run_snake(inputs)

  assert_eq(runtime1, runtime2)
  assert_eq(frames1, frames2)
}

///|
test "snake frame changes after move interval elapsed" {
  let (_, frames) = run_snake(Array::make(9, @model.input_none))
  assert_true(frames[6] != frames[8])
}
