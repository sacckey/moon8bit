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
  @engine.config(screen_w, screen_h, fps=60, scale=1)
}

///|
fn shooting_input_script(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    if i % 16 < 8 {
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
test "shooting deterministic replay with identical scripted inputs" {
  let config = shooting_config()
  let bundle = test_bundle()
  let inputs = shooting_input_script(180)
  let (runtime1, frames1) = @engine.run_fixed_frames(
    new_shooting_game(bundle),
    config,
    inputs,
  )
  let (runtime2, frames2) = @engine.run_fixed_frames(
    new_shooting_game(bundle),
    config,
    inputs,
  )

  assert_eq(@engine.engine_game(runtime1), @engine.engine_game(runtime2))
  assert_eq(frames1, frames2)
}

///|
test "shooting fires bullet when space is held and cooldown is ready" {
  let runtime = @engine.engine_init(
    new_shooting_game(test_bundle()),
    shooting_config(),
  )
  let (next_runtime, _) = @engine.engine_step(
    runtime,
    @model.input_state(["Space"], ["Space"], []),
  )
  let next = @engine.engine_game(next_runtime)
  assert_eq(next.bullets.length(), 1)
  assert_eq(next.shoot_timer, shoot_interval)
}

///|
test "shooting spawns enemies after enough frames" {
  let runtime = @engine.engine_init(
    new_shooting_game(test_bundle()),
    shooting_config(),
  )
  let mut state = runtime
  for _ in 0..<90 {
    let (next, _) = @engine.engine_step(state, @model.input_none)
    state = next
  }
  assert_true(@engine.engine_game(state).enemies.length() > 0)
}
