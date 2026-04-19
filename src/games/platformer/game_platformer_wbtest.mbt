///|
fn solid_sprite(name : String, color : Int) -> @model.Sprite {
  let pixels : Array[Int] = []
  for _ in 0..<64 {
    pixels.push(color)
  }
  @model.Sprite::{ name, width: 8, height: 8, pixels }
}

///|
fn platformer_test_bundle() -> @model.AssetBundle {
  let tile_count = 8
  let tile_pixels = Array::make(tile_count * 64, -1)
  for i in 0..<64 {
    tile_pixels[1 * 64 + i] = 5 // solid ground tile
    tile_pixels[4 * 64 + i] = 3 // goal tile
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
      @model.Placement::{ name: "enemy_a", sprite: "enemy", x: 72, y: 128 },
      @model.Placement::{ name: "coin_a", sprite: "coin", x: 24, y: 100 },
    ],
    sounds: [],
    bgms: [],
  }
}

///|
fn platformer_config(bundle : @model.AssetBundle) -> @model.EngineConfig {
  @engine.config(screen_w, screen_h, fps=60, scale=1, palette=bundle.palette)
}

///|
fn platformer_input_script(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let down : Array[String] = []
    let pressed : Array[String] = []
    down.push("KeyD")
    if i == 6 || i == 30 {
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
test "platformer deterministic replay with identical scripted inputs" {
  let bundle = platformer_test_bundle()
  let config = platformer_config(bundle)
  let inputs = platformer_input_script(180)
  let (runtime1, frames1) = @engine.run_fixed_frames(
    new_platformer_game(bundle),
    config,
    inputs,
  )
  let (runtime2, frames2) = @engine.run_fixed_frames(
    new_platformer_game(bundle),
    config,
    inputs,
  )

  assert_eq(@engine.engine_game(runtime1), @engine.engine_game(runtime2))
  assert_eq(frames1, frames2)
}

///|
test "platformer uses single player placement as spawn" {
  let bundle = platformer_test_bundle()
  let runtime = init_game(bundle, platformer_config(bundle))
  let state = @engine.engine_game(runtime)
  assert_eq(state.player_x, 24)
  assert_eq(state.player_y, 100)
}

///|
test "platformer collects overlapping coin placement" {
  let bundle = platformer_test_bundle()
  let runtime = init_game(bundle, platformer_config(bundle))
  let before_state = @engine.engine_game(runtime)
  let before_count = before_state.coins.length()
  assert_eq(before_state.coins_collected, 0)
  assert_true(before_count > 0)

  let (next_runtime, _) = @engine.engine_step(runtime, @model.input_none)
  let next = @engine.engine_game(next_runtime)
  assert_eq(next.coins_collected, 1)
  assert_eq(next.coins.length(), before_count - 1)
}
