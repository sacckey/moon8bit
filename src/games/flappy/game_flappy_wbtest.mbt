///|

///|
fn test_bundle() -> @model.AssetBundle {
  let pixels : Array[Int] = []
  for _ in 0..<64 {
    pixels.push(3)
  }
  let tile_pixels : Array[Int] = []
  for _ in 0..<(256 * 64) {
    tile_pixels.push(-1)
  }

  @model.AssetBundle::{
    palette: @model.Palette::{
      name: "test",
      colors: [
        "#000000", "#111111", "#222222", "#333333", "#444444", "#555555", "#666666",
        "#777777",
      ],
    },
    sprites: [@model.Sprite::{ name: "bird", width: 8, height: 8, pixels }],
    tiles: @model.Tiles::{
      name: "main",
      tile_count: 256,
      tile_names: [],
      tile_solid: [],
      pixels: tile_pixels,
    },
    tilemaps: [],
    placements: [],
    sounds: [],
    bgms: [],
  }
}

///|
fn test_inputs(frame_count : Int) -> Array[@model.InputState] {
  let inputs : Array[@model.InputState] = []
  for i in 0..<frame_count {
    let flap = i % 8 == 0 || i % 13 == 0
    if flap {
      inputs.push(@model.input_state(["Space"], ["Space"], []))
    } else {
      inputs.push(@model.input_none)
    }
  }
  inputs
}

///|
test "engine deterministic with identical inputs" {
  let bundle = test_bundle()
  let inputs = test_inputs(48)
  let (state1, frames1) = run_flappy(bundle, inputs)
  let (state2, frames2) = run_flappy(bundle, inputs)

  assert_eq(state1, state2)
  assert_eq(frames1, frames2)
}

///|
test "reset input restores game state" {
  let bundle = test_bundle()
  let inputs = [
    @model.input_none,
    @model.input_state(["Space"], ["Space"], []),
    @model.input_state(["KeyR"], ["KeyR"], []),
    @model.input_none,
  ]

  let (state, _) = run_flappy(bundle, inputs)
  assert_true(!state.is_over())
  assert_eq(state.score(), 0)
}

///|
test "rect intersection basics" {
  let a = @model.Rect::{ x: 0, y: 0, w: 4, h: 4 }
  let b = @model.Rect::{ x: 2, y: 2, w: 4, h: 4 }
  let c = @model.Rect::{ x: 5, y: 5, w: 2, h: 2 }

  assert_true(@model.rect_intersects(a, b))
  assert_true(!@model.rect_intersects(a, c))
}

///|
test "collider API detects hits against multiple obstacles" {
  let bird = @model.collider_box("bird", 5, 5, 3, 3)
  let obstacles = [
    @model.collider_box("pipe_top", 0, 0, 3, 3),
    @model.collider_box("pipe_bottom", 6, 6, 4, 4),
  ]

  assert_true(@model.collider_hits_any(bird, obstacles))
  let hit = match @model.collider_first_hit(bird, obstacles) {
    Some(v) => v
    None => panic()
  }
  assert_eq(hit.tag, "pipe_bottom")
}

///|
test "collider API ignores empty collider boxes" {
  let bird = @model.collider_box("bird", 5, 5, 3, 3)
  let empty = @model.collider_box("pipe", 6, 6, 0, 4)
  let solid = @model.collider_box("pipe", 20, 20, 4, 4)

  assert_true(!@model.collider_intersects(bird, empty))
  assert_true(!@model.collider_hits_any(bird, [empty, solid]))
  assert_eq(@model.collider_first_hit(bird, [empty, solid]), None)
}

///|
test "engine step records pipe collision hit tag" {
  let config = @model.default_engine_config()
  let runtime = @engine.engine_init(new_flappy_game(test_bundle()), config)
  let state = @engine.engine_game(runtime)

  state.is_started = true
  state.bird_x = 8
  state.bird_y = 10.0
  state.bird_vy = 0.0
  state.pipe_x = 10
  state.pipe_width = 7
  state.pipe_gap_y = 14
  state.gap_height = 11
  state.is_over = false
  state.last_hit_tag = None

  let prepared = @engine.engine_with_game(runtime, state)
  let (next_runtime, _) = @engine.engine_step(prepared, @model.input_none)
  let next = @engine.engine_game(next_runtime)
  assert_true(next.is_over())
  assert_eq(next.last_hit_tag(), Some("pipe_top"))
}

///|
test "engine step increments score when passing a pipe" {
  let config = @model.default_engine_config()
  let runtime = @engine.engine_init(new_flappy_game(test_bundle()), config)
  let state = @engine.engine_game(runtime)

  state.is_started = true
  state.is_over = false
  state.score = 0
  state.bird_x = 20
  state.bird_y = 20.0
  state.bird_vy = 0.0
  state.pipe_x = 10
  state.pipe_width = 5
  state.pipe_gap_y = 0
  state.gap_height = 30
  state.pipe_scored = false

  let prepared = @engine.engine_with_game(runtime, state)
  let (next_runtime, _) = @engine.engine_step(prepared, @model.input_none)
  let next = @engine.engine_game(next_runtime)
  assert_eq(next.score(), 1)
  assert_true(next.pipe_scored)
}

///|
test "parity score baseline increments once per pipe pass" {
  let config = @model.default_engine_config()
  let runtime = @engine.engine_init(new_flappy_game(test_bundle()), config)
  let state = @engine.engine_game(runtime)
  state.is_started = true
  state.is_over = false
  state.score = 0
  state.bird_x = 20
  state.bird_y = 20.0
  state.bird_vy = 0.0
  state.pipe_x = state.bird_x - state.pipe_width
  state.pipe_gap_y = 0
  state.gap_height = 30
  state.pipe_scored = false

  let prepared = @engine.engine_with_game(runtime, state)
  let (next1_runtime, _) = @engine.engine_step(prepared, @model.input_none)
  let (next2_runtime, _) = @engine.engine_step(next1_runtime, @model.input_none)
  let next1 = @engine.engine_game(next1_runtime)
  let next2 = @engine.engine_game(next2_runtime)
  assert_eq(next1.score(), 1)
  assert_eq(next2.score(), 1)
  assert_true(next2.pipe_scored)
}

///|
test "parity collision baseline reports ground hit" {
  let config = @model.default_engine_config()
  let runtime = @engine.engine_init(new_flappy_game(test_bundle()), config)
  let state = @engine.engine_game(runtime)

  state.is_started = true
  state.bird_y = Double::from_int(config.height - 4)
  state.bird_vy = 0.0
  state.is_over = false
  state.last_hit_tag = None

  let prepared = @engine.engine_with_game(runtime, state)
  let (next_runtime, _) = @engine.engine_step(prepared, @model.input_none)
  let next = @engine.engine_game(next_runtime)
  assert_true(next.is_over())
  assert_eq(next.last_hit_tag(), Some("ground"))
}

///|
test "parity reset baseline restores zeroed run state" {
  let inputs = [
    @model.input_state(["Space"], ["Space"], []),
    @model.input_none,
    @model.input_state(["KeyR"], ["KeyR"], []),
    @model.input_none,
  ]
  let config = @model.default_engine_config()
  let (state, _) = run_flappy(test_bundle(), inputs, config~)

  assert_true(!state.is_started())
  assert_true(!state.is_over())
  assert_eq(state.score(), 0)
  assert_eq(state.last_hit_tag(), None)
}
