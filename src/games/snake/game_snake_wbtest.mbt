///|
fn snake_input_script(frame_count : Int) -> Array[@model.InputState] {
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
fn snake_config() -> @model.EngineConfig {
  @engine.config(screen_w, screen_h, fps=60, scale=1)
}

///|
test "snake deterministic replay with identical scripted inputs" {
  let config = snake_config()
  let inputs = snake_input_script(96)
  let (runtime1, frames1) = @engine.run_fixed_frames(
    new_snake_game(),
    config,
    inputs,
  )
  let (runtime2, frames2) = @engine.run_fixed_frames(
    new_snake_game(),
    config,
    inputs,
  )

  assert_eq(@engine.engine_game(runtime1), @engine.engine_game(runtime2))
  assert_eq(frames1, frames2)
}

///|
test "snake moves exactly at configured move interval" {
  let runtime = @engine.engine_init(new_snake_game(), snake_config())
  let initial_head = @engine.engine_game(runtime).body[0]

  let mut state = runtime
  for _ in 0..<(move_interval - 1) {
    let (next, _) = @engine.engine_step(state, @model.input_none)
    state = next
  }

  let before_move = @engine.engine_game(state).body[0]
  assert_eq(before_move, initial_head)

  let (after_step, _) = @engine.engine_step(state, @model.input_none)
  let moved_head = @engine.engine_game(after_step).body[0]
  assert_eq(moved_head.x, initial_head.x + 1)
  assert_eq(moved_head.y, initial_head.y)
}

///|
test "snake wraps on horizontal edge" {
  let runtime = @engine.engine_init(new_snake_game(), snake_config())
  let state = @engine.engine_game(runtime)
  state.body = [
    Pos::{ x: grid_w - 1, y: 8 },
    Pos::{ x: grid_w - 2, y: 8 },
    Pos::{ x: grid_w - 3, y: 8 },
  ]
  state.dir = Right
  state.next_dir = Right
  state.timer = move_interval - 1
  let prepared = @engine.engine_with_game(runtime, state)

  let (next_runtime, _) = @engine.engine_step(prepared, @model.input_none)
  let head = @engine.engine_game(next_runtime).body[0]
  assert_eq(head.x, 0)
  assert_eq(head.y, 8)
}
