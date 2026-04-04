///|
test "engine deterministic with identical inputs" {
  let inputs = scripted_demo_inputs(48)
  let (state1, frames1) = run_driftbird(inputs)
  let (state2, frames2) = run_driftbird(inputs)

  assert_eq(state1, state2)
  assert_eq(frames1, frames2)
}

///|
test "reset input restores game state" {
  let inputs = [
    @model.input_none,
    InputState::{ flap: true, reset: false },
    InputState::{ flap: false, reset: true },
    @model.input_none,
  ]

  let (state, _) = run_driftbird(inputs)
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
  let bird = collider_box("bird", 5, 5, 3, 3)
  let obstacles = [
    collider_box("pipe_top", 0, 0, 3, 3),
    collider_box("pipe_bottom", 6, 6, 4, 4),
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
  let bird = collider_box("bird", 5, 5, 3, 3)
  let empty = collider_box("pipe", 6, 6, 0, 4)
  let solid = collider_box("pipe", 20, 20, 4, 4)

  assert_true(!@model.collider_intersects(bird, empty))
  assert_true(!@model.collider_hits_any(bird, [empty, solid]))
  assert_eq(@model.collider_first_hit(bird, [empty, solid]), None)
}

///|
test "engine step records pipe collision hit tag" {
  let config = default_engine_config()
  let state = @engine.engine_init(
    new_driftbird_game(load_sample_assets()),
    config,
  )

  state.is_started = true
  state.bird_x = 8
  state.bird_y = 4.0
  state.bird_vy = 0.0
  state.pipe_x = 10
  state.pipe_width = 5
  state.pipe_gap_y = 8
  state.gap_height = 11
  state.is_over = false
  state.last_hit_tag = None

  let (next, _) = @engine.engine_step(state, config, @model.input_none, 0)
  assert_true(next.is_over())
  assert_eq(next.last_hit_tag(), Some("pipe_top"))
}

///|
test "engine step increments score when passing a pipe" {
  let config = default_engine_config()
  let state = @engine.engine_init(
    new_driftbird_game(load_sample_assets()),
    config,
  )

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

  let (next, _) = @engine.engine_step(state, config, @model.input_none, 0)
  assert_eq(next.score(), 1)
  assert_true(next.pipe_scored)
}
