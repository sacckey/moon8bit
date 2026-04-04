///|
struct CounterGame {
  mut ticks : Int
  mut last_flap : Bool
} derive(Eq, Show)

///|
pub impl @engine.Game for CounterGame with init(self, _ctx) {
  self.ticks = 0
  self.last_flap = false
  self
}

///|
pub impl @engine.Game for CounterGame with update(self, ctx) {
  self.ticks += 1
  self.last_flap = ctx.input.flap
  self
}

///|
pub impl @engine.Game for CounterGame with draw(self, ctx) {
  let frame = @model.Frame::new(ctx.config.width, ctx.config.height, fill=0)
  let color = if self.last_flap { 2 } else { 1 }
  frame.set_pixel(0, 0, color)
  frame.set_pixel(1, 0, self.ticks)
  frame
}

///|
fn new_counter_game() -> CounterGame {
  CounterGame::{ ticks: -1, last_flap: false }
}

///|
test "wrapper step matches engine_step with package local game" {
  let cfg = @engine.config(
    8,
    6,
    fps=20,
    scale=1,
    palette=@model.palette_default(),
  )
  let input = @engine.btn(true, false)
  let base_state = @engine.engine_init(new_counter_game(), cfg)
  let wrapped_state = @engine.engine_init(new_counter_game(), cfg)

  let (next_base, frame_base) = @engine.engine_step(base_state, cfg, input, 0)
  let (next_wrapped, frame_wrapped) = @engine.step(wrapped_state, cfg, input, 0)

  assert_eq(next_wrapped, next_base)
  assert_eq(frame_wrapped, frame_base)
  assert_eq(frame_wrapped.get_pixel(0, 0), Some(2))
}

///|
test "wrapper run matches run_fixed_frames for deterministic inputs" {
  let cfg = @engine.config(4, 4)
  let inputs = [
    @engine.btn(false, false),
    @engine.btn(true, false),
    @engine.btn(false, false),
  ]

  let (base_state, base_frames) = @engine.run_fixed_frames(
    new_counter_game(),
    cfg,
    inputs,
  )
  let (wrapped_state, wrapped_frames) = @engine.run(
    new_counter_game(),
    cfg,
    inputs,
  )

  assert_eq(wrapped_state, base_state)
  assert_eq(wrapped_frames, base_frames)
  assert_eq(wrapped_frames.length(), 3)
}

///|
test "wrapper input helpers detect edges and intervals" {
  assert_true(@engine.btnp(true, false))
  assert_true(!@engine.btnp(true, true))
  assert_true(!@engine.btnp(false, false))

  assert_true(@engine.every(0, 8))
  assert_true(@engine.every(16, 8))
  assert_true(!@engine.every(15, 8))
  assert_true(!@engine.every(3, 0))
}

///|
test "wrapper collision helpers cover common AABB workflows" {
  assert_true(@engine.aabb(1, 1, 3, 3, 3, 2, 4, 4))
  assert_true(!@engine.aabb(1, 1, 2, 2, 4, 4, 2, 2))

  let obstacles = [
    @model.collider_box("miss", 20, 20, 3, 3),
    @model.collider_box("pipe_top", 3, 2, 4, 4),
  ]
  assert_eq(@engine.aabb_hit_tag(1, 1, 3, 3, obstacles), Some("pipe_top"))
  assert_eq(@engine.aabb_hit_tag(50, 50, 2, 2, obstacles), None)
}
