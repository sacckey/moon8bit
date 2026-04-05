///|

///|
struct WrapperTestGame {
  mut count : Int
}

///|
pub impl @engine.Game for WrapperTestGame with init(self, _ctx) {
  self
}

///|
pub impl @engine.Game for WrapperTestGame with update(self, ctx) {
  if key_pressed(ctx.input, "KeyR") {
    self.count = 0
  } else if key_pressed(ctx.input, "Space") {
    self.count = self.count + 1
  }
  (self, [])
}

///|
pub impl @engine.Game for WrapperTestGame with draw(self, ctx) {
  let frame = Frame::new(ctx.config.width, ctx.config.height, fill=0)
  if self.count % 2 == 1 {
    pset(frame, 0, 0, 1)
  }
  frame
}

///|
fn wrapper_test_bundle() -> AssetBundle {
  let dsl = [
    "palette t", "color 0 #000000", "color 1 #111111", "color 2 #222222", "color 3 #333333",
    "color 4 #444444", "color 5 #555555", "color 6 #666666", "color 7 #777777", "end",
    "", "sprite bird 8 8", "33333333", "33333333", "33333333", "33333333", "33333333",
    "33333333", "33333333", "33333333", "end",
  ].join("\n")
  match parse_assets_dsl(dsl) {
    Ok(bundle) => bundle
    Err(_) => panic()
  }
}

///|
fn wrapper_test_inputs(frame_count : Int) -> Array[InputState] {
  let inputs : Array[InputState] = []
  for i in 0..<frame_count {
    let flap = every(i, 8) || every(i, 13)
    if flap {
      inputs.push(input_state(["Space"], ["Space"], []))
    } else {
      inputs.push(input_none)
    }
  }
  inputs
}

///|
test "root wrapper step and run remain equivalent to engine primitives" {
  let cfg = default_engine_config()
  let input = input_state(["Space"], ["Space"], [])

  let base_state = engine_init(WrapperTestGame::{ count: 0 }, cfg)
  let wrapped_state = engine_init(WrapperTestGame::{ count: 0 }, cfg)

  let (next_base, frame_base) = engine_step(base_state, input)
  let (next_wrapped, frame_wrapped) = step(wrapped_state, input)

  assert_eq(game_state(next_wrapped).count, game_state(next_base).count)
  assert_eq(frame_wrapped, frame_base)

  let inputs = wrapper_test_inputs(24)
  let (final_base_runtime, frames_base) = run_fixed_frames(
    WrapperTestGame::{ count: 0 },
    cfg,
    inputs,
  )
  let (final_wrapped_runtime, frames_wrapped) = run(
    WrapperTestGame::{ count: 0 },
    cfg,
    inputs,
  )

  assert_eq(
    game_state(final_wrapped_runtime).count,
    game_state(final_base_runtime).count,
  )
  assert_eq(frames_wrapped, frames_base)
}

///|
test "root wrapper frame helpers remain equivalent to Frame methods" {
  let bundle = wrapper_test_bundle()
  let sprite = match find_sprite(bundle, "bird") {
    Some(v) => v
    None => panic()
  }

  let wrapped = Frame::new(8, 8, fill=-1)
  let base = Frame::new(8, 8, fill=-1)

  cls(wrapped, 0)
  base.clear(0)

  pset(wrapped, 1, 1, 3)
  base.set_pixel(1, 1, 3)

  rect(wrapped, 2, 2, 3, 2, 4)
  base.draw_rect(2, 2, 3, 2, 4)

  spr(wrapped, sprite, 4, 4)
  base.blit(sprite, 4, 4)

  assert_eq(wrapped, base)
}

///|
test "root wrapper re-exports input utility helpers" {
  assert_true(btnp(true, false))
  assert_true(!btnp(true, true))
  assert_true(!btnp(false, false))

  assert_true(every(0, 4))
  assert_true(every(8, 4))
  assert_true(!every(9, 4))
  assert_true(!every(9, -1))
}

///|
test "root wrapper re-exports collision utility helpers" {
  assert_true(aabb(1, 1, 3, 3, 3, 2, 4, 4))
  assert_true(!aabb(1, 1, 2, 2, 4, 4, 2, 2))

  let obstacles = [
    collider_box("miss", 20, 20, 3, 3),
    collider_box("pipe_top", 3, 2, 4, 4),
  ]
  assert_eq(aabb_hit_tag(1, 1, 3, 3, obstacles), Some("pipe_top"))
  assert_eq(aabb_hit_tag(50, 50, 2, 2, obstacles), None)
}

///|
test "root wrapper re-exports ui utility helpers" {
  assert_eq(ui_center_x(20, 6), 7)
  assert_eq(ui_center_y(11, 5), 3)
  assert_eq(ui_center_y(3, 9), 0)

  let frame = Frame::new(10, 8, fill=-1)
  ui_panel(frame, 2, 1, 5, 4, 3, border=7)
  assert_eq(frame.get_pixel(2, 1), Some(7))
  assert_eq(frame.get_pixel(4, 2), Some(3))
}

///|
test "root wrapper re-exports ui text helpers" {
  assert_eq(ui_text_width("A1"), 16)
  assert_eq(ui_text_width("A1", scale=2), 32)

  let frame = Frame::new(20, 12, fill=-1)
  ui_text(frame, 0, 0, "A1", 5)
  assert_eq(frame.get_pixel(3, 1), Some(5))

  let scaled = Frame::new(20, 12, fill=-1)
  ui_text(scaled, 0, 0, "A", 6, scale=2)
  assert_eq(scaled.get_pixel(6, 2), Some(6))
}
