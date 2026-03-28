///|
test "engine deterministic with identical inputs" {
  let inputs = scripted_demo_inputs(48)
  let (state1, frames1) = run_bird_like(inputs)
  let (state2, frames2) = run_bird_like(inputs)

  assert_eq(state1, state2)
  assert_eq(frames1, frames2)
}

///|
test "reset input restores game state" {
  let inputs = [
    input_none,
    InputState::{ flap: true, reset: false },
    InputState::{ flap: false, reset: true },
    input_none,
  ]

  let (state, _) = run_bird_like(inputs)
  assert_true(!state.is_over())
  assert_eq(state.score(), 0)
}

///|
test "rect intersection basics" {
  let a = Rect::{ x: 0, y: 0, w: 4, h: 4 }
  let b = Rect::{ x: 2, y: 2, w: 4, h: 4 }
  let c = Rect::{ x: 5, y: 5, w: 2, h: 2 }

  assert_true(rect_intersects(a, b))
  assert_true(!rect_intersects(a, c))
}

///|
test "collider API detects hits against multiple obstacles" {
  let bird = collider_box("bird", 5, 5, 3, 3)
  let obstacles = [
    collider_box("pipe_top", 0, 0, 3, 3),
    collider_box("pipe_bottom", 6, 6, 4, 4),
  ]

  assert_true(collider_hits_any(bird, obstacles))
  let hit = match collider_first_hit(bird, obstacles) {
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

  assert_true(!collider_intersects(bird, empty))
  assert_true(!collider_hits_any(bird, [empty, solid]))
  assert_eq(collider_first_hit(bird, [empty, solid]), None)
}
