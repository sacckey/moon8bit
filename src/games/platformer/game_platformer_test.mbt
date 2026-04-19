///|
fn solid_sprite(name : String, color : Int) -> @model.Sprite {
  let pixels : Array[Int] = []
  for _ in 0..<64 {
    pixels.push(color)
  }
  @model.Sprite::{ name, width: 8, height: 8, pixels }
}

///|
fn test_bundle() -> @model.AssetBundle {
  let tile_count = 8
  let tile_pixels = Array::make(tile_count * 64, -1)
  for i in 0..<64 {
    tile_pixels[1 * 64 + i] = 5
    tile_pixels[4 * 64 + i] = 3
  }
  let tile_solid = Array::make(tile_count, false)
  tile_solid[1] = true

  let map_w = 40
  let map_h = 18
  let stage = Array::make(map_w * map_h, -1)
  for x in 0..<map_w {
    stage[(map_h - 1) * map_w + x] = 1
  }
  stage[(map_h - 2) * map_w + 20] = 4

  @model.AssetBundle::{
    palette: @model.palette_default(),
    sprites: [
      solid_sprite("player", 6),
      solid_sprite("enemy", 4),
      solid_sprite("coin", 3),
    ],
    tiles: @model.Tiles::{
      name: "main",
      tile_count,
      tile_names: [],
      tile_solid,
      pixels: tile_pixels,
    },
    tilemaps: [
      @model.Tilemap::{
        name: "stage",
        width: map_w,
        height: map_h,
        tiles: stage,
      },
    ],
    placements: [
      @model.Placement::{
        name: "spawn_player",
        sprite: "player",
        x: 24,
        y: 100,
      },
    ],
    sounds: [],
    bgms: [],
  }
}

///|
fn platformer_config(bundle : @model.AssetBundle) -> @model.EngineConfig {
  @engine.config(256, 144, fps=60, scale=1, palette=bundle.palette)
}

///|
fn platformer_inputs(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = ["KeyD"]
    let pressed : Array[String] = []
    if i == 6 {
      down.push("Space")
      pressed.push("Space")
    } else if i > 6 && i < 10 {
      down.push("Space")
    }
    inputs.push(@model.input_state(down, pressed, []))
  }
  inputs
}

///|
fn run_platformer(
  bundle : @model.AssetBundle,
  inputs : Array[@model.InputState],
) -> (@engine.EngineInstance[@platformer.PlatformerGame], Array[@model.Frame]) {
  let mut runtime = @platformer.init_game(bundle, platformer_config(bundle))
  let frames : Array[@model.Frame] = []
  for input in inputs {
    let (next, frame) = @platformer.step_game(runtime, input)
    runtime = next
    frames.push(frame)
  }
  (runtime, frames)
}

///|
test "platformer deterministic replay with identical inputs" {
  let bundle = test_bundle()
  let inputs = platformer_inputs(120)
  let (runtime1, frames1) = run_platformer(bundle, inputs)
  let (runtime2, frames2) = run_platformer(bundle, inputs)

  assert_eq(runtime1, runtime2)
  assert_eq(frames1, frames2)
}

///|
test "platformer right movement changes rendered frame" {
  let bundle = test_bundle()
  let idle_inputs = [@model.input_none, @model.input_none]
  let move_inputs = [
    @model.input_state(["KeyD"], ["KeyD"], []),
    @model.input_state(["KeyD"], [], []),
  ]
  let (_, idle_frames) = run_platformer(bundle, idle_inputs)
  let (_, move_frames) = run_platformer(bundle, move_inputs)

  assert_true(idle_frames[1] != move_frames[1])
}
