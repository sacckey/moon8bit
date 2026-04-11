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
  self.last_flap = @engine.key_pressed(ctx.input, "Space")
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
struct CommandGame {
  mut ticks : Int
} derive(Eq, Show)

///|
pub impl @engine.Game for CommandGame with init(self, _ctx) {
  self.ticks = 0
  self
}

///|
pub impl @engine.Game for CommandGame with update(self, ctx) {
  self.ticks += 1
  if ctx.tick == 0 {
    ctx.sfx("now")
    ctx.set_timeout(2, @engine.EngineEvent::Sfx("timer"))
  }
  self
}

///|
pub impl @engine.Game for CommandGame with draw(self, ctx) {
  let frame = @model.Frame::new(ctx.config.width, ctx.config.height, fill=0)
  frame.set_pixel(0, 0, self.ticks)
  frame
}

///|
struct TimeoutCommandGame {
  mut ticks : Int
} derive(Eq, Show)

///|
pub impl @engine.Game for TimeoutCommandGame with init(self, _ctx) {
  self.ticks = 0
  self
}

///|
pub impl @engine.Game for TimeoutCommandGame with update(self, ctx) {
  self.ticks += 1
  if ctx.tick == 0 {
    ctx.set_timeout(2, @engine.EngineEvent::Sfx("beep"))
  }
  self
}

///|
pub impl @engine.Game for TimeoutCommandGame with draw(self, ctx) {
  let frame = @model.Frame::new(ctx.config.width, ctx.config.height, fill=0)
  frame.set_pixel(0, 0, self.ticks)
  frame
}

///|
struct IntervalCommandGame {
  mut ticks : Int
} derive(Eq, Show)

///|
pub impl @engine.Game for IntervalCommandGame with init(self, _ctx) {
  self.ticks = 0
  self
}

///|
pub impl @engine.Game for IntervalCommandGame with update(self, ctx) {
  self.ticks += 1
  if ctx.tick == 0 {
    ctx.set_interval(2, @engine.EngineEvent::BgmStart)
  }
  self
}

///|
pub impl @engine.Game for IntervalCommandGame with draw(self, ctx) {
  let frame = @model.Frame::new(ctx.config.width, ctx.config.height, fill=0)
  frame.set_pixel(0, 0, self.ticks)
  frame
}

///|
struct EventOrderGame {
  mut ticks : Int
} derive(Eq, Show)

///|
pub impl @engine.Game for EventOrderGame with init(self, _ctx) {
  self.ticks = 0
  self
}

///|
pub impl @engine.Game for EventOrderGame with update(self, ctx) {
  self.ticks += 1
  if ctx.tick == 0 {
    ctx.set_interval(1, @engine.EngineEvent::Sfx("timer"))
  }
  if ctx.tick == 1 {
    ctx.sfx("now")
  }
  self
}

///|
pub impl @engine.Game for EventOrderGame with draw(self, ctx) {
  let frame = @model.Frame::new(ctx.config.width, ctx.config.height, fill=0)
  frame.set_pixel(0, 0, self.ticks)
  frame
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
  let input = @engine.btn(["Space"], keys_pressed=["Space"])
  let base_state = @engine.engine_init(new_counter_game(), cfg)
  let wrapped_state = @engine.engine_init(new_counter_game(), cfg)

  let (next_base, frame_base) = @engine.engine_step(base_state, input)
  let (next_wrapped, frame_wrapped) = @engine.step(wrapped_state, input)

  assert_eq(next_wrapped, next_base)
  assert_eq(frame_wrapped, frame_base)
  assert_eq(frame_wrapped.get_pixel(0, 0), Some(2))
  assert_eq(@engine.game_state(next_wrapped).ticks, 1)
}

///|
test "wrapper run matches run_fixed_frames for deterministic inputs" {
  let cfg = @engine.config(4, 4)
  let inputs = [
    @engine.btn([]),
    @engine.btn(["Space"], keys_pressed=["Space"]),
    @engine.btn([]),
  ]

  let (base_runtime, base_frames) = @engine.run_fixed_frames(
    new_counter_game(),
    cfg,
    inputs,
  )
  let (wrapped_runtime, wrapped_frames) = @engine.run(
    new_counter_game(),
    cfg,
    inputs,
  )

  assert_eq(wrapped_runtime, base_runtime)
  assert_eq(wrapped_frames, base_frames)
  assert_eq(wrapped_frames.length(), 3)
  assert_eq(@engine.game_state(wrapped_runtime).ticks, 3)
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

  let input = @engine.btn(["Space", "KeyA"], keys_pressed=["Space"], keys_released=[
    "KeyR",
  ])
  assert_true(@engine.key_down_any(input, ["ArrowUp", "Space"]))
  assert_true(!@engine.key_down_any(input, ["ArrowUp", "Enter"]))
  assert_true(@engine.key_pressed_any(input, ["Space", "KeyZ"]))
  assert_true(!@engine.key_pressed_any(input, ["KeyQ", "KeyZ"]))
  assert_true(@engine.key_released_any(input, ["KeyR", "KeyZ"]))
  assert_true(!@engine.key_released_any(input, ["KeyQ", "KeyZ"]))
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

///|
test "wrapper ui helpers provide centered layout and panel drawing" {
  assert_eq(@engine.ui_center_x(20, 6), 7)
  assert_eq(@engine.ui_center_y(11, 5), 3)
  assert_eq(@engine.ui_center_x(4, 8), 0)

  let frame = @model.Frame::new(10, 8, fill=-1)
  @engine.ui_panel(frame, 2, 1, 5, 4, 3, border=7)

  assert_eq(frame.get_pixel(2, 1), Some(7))
  assert_eq(frame.get_pixel(4, 2), Some(3))
  assert_eq(frame.get_pixel(6, 4), Some(7))
}

///|
test "wrapper ui text helpers render ascii glyphs in 8x8 cells and scaling" {
  assert_eq(@engine.ui_text_width("A1"), 16)
  assert_eq(@engine.ui_text_width("A1", scale=2), 32)
  assert_eq(@engine.ui_text_width("", scale=2), 0)

  let frame = @model.Frame::new(20, 12, fill=-1)
  @engine.ui_text(frame, 0, 0, "A1", 5)
  assert_eq(frame.get_pixel(3, 1), Some(5))
  assert_eq(frame.get_pixel(2, 2), Some(5))
  assert_eq(frame.get_pixel(11, 1), Some(5))

  let scaled = @model.Frame::new(20, 12, fill=-1)
  @engine.ui_text(scaled, 0, 0, "A", 6, scale=2)
  assert_eq(scaled.get_pixel(6, 2), Some(6))
  assert_eq(scaled.get_pixel(4, 4), Some(6))
  assert_eq(scaled.get_pixel(0, 0), Some(-1))
}

///|
test "draw_tilemap uses transparent+clip behavior without wrapping" {
  let pixels : Array[Int] = []
  for _ in 0..<64 {
    pixels.push(2)
  }
  let ts = @model.Tiles::{
    name: "main",
    tile_count: 1,
    tile_names: ["solid"],
    tile_solid: [true],
    pixels,
  }
  let tm = @model.Tilemap::{ name: "m", width: 1, height: 1, tiles: [0] }

  let frame = @model.Frame::new(8, 8, fill=-1)
  @engine.draw_tilemap(frame, tm, ts, 0, 0, 8, 8, 0, 0)
  assert_eq(frame.get_pixel(0, 0), Some(2))
  assert_eq(frame.get_pixel(7, 7), Some(2))
  assert_true(@engine.tile_solid_at_px(tm, ts, 0, 0))
  assert_true(!@engine.tile_solid_at_px(tm, ts, 10, 0))

  let shifted = @model.Frame::new(8, 8, fill=-1)
  @engine.draw_tilemap(shifted, tm, ts, 0, 0, 8, 8, 8, 0)
  assert_eq(shifted.get_pixel(0, 0), Some(-1))
  assert_eq(shifted.get_pixel(7, 7), Some(-1))

  let wider = @model.Frame::new(16, 8, fill=9)
  @engine.draw_tilemap(wider, tm, ts, 0, 0, 16, 8, 0, 0)
  assert_eq(wider.get_pixel(3, 3), Some(2))
  assert_eq(wider.get_pixel(12, 3), Some(9))

  let negative_cam = @model.Frame::new(8, 8, fill=9)
  @engine.draw_tilemap(negative_cam, tm, ts, 0, 0, 8, 8, -4, 0)
  assert_eq(negative_cam.get_pixel(0, 0), Some(9))
  assert_eq(negative_cam.get_pixel(4, 0), Some(2))
  assert_eq(negative_cam.get_pixel(7, 7), Some(2))
}

///|
test "tile_solid_any_in_rect checks overlapped tiles in map-space pixels" {
  let solid_px : Array[Int] = []
  for _ in 0..<64 {
    solid_px.push(1)
  }
  let empty_px : Array[Int] = []
  for _ in 0..<64 {
    empty_px.push(2)
  }
  let ts = @model.Tiles::{
    name: "main",
    tile_count: 2,
    tile_names: ["solid", "empty"],
    tile_solid: [true, false],
    pixels: solid_px + empty_px,
  }
  let tm = @model.Tilemap::{ name: "m", width: 2, height: 1, tiles: [0, 1] }
  assert_true(@engine.tile_solid_any_in_rect(tm, ts, 0, 0, 1, 1))
  assert_true(!@engine.tile_solid_any_in_rect(tm, ts, 8, 0, 8, 8))
  assert_true(@engine.tile_solid_any_in_rect(tm, ts, 7, 0, 2, 8))
  assert_true(!@engine.tile_solid_any_in_rect(tm, ts, -8, 0, 4, 4))
  assert_true(!@engine.tile_solid_any_in_rect(tm, ts, 0, 0, 0, 4))
}

///|
test "engine timeout command emits event once and can be consumed" {
  let cfg = @engine.config(4, 4)
  let initial = @engine.engine_init(TimeoutCommandGame::{ ticks: 0 }, cfg)

  let (step1, _) = @engine.engine_step(initial, @engine.btn([]))
  assert_eq(@engine.events(step1), [])

  let (step2, _) = @engine.engine_step(step1, @engine.btn([]))
  assert_eq(@engine.events(step2), [])

  let (step3, _) = @engine.engine_step(step2, @engine.btn([]))
  assert_eq(@engine.events(step3), [@engine.EngineEvent::Sfx("beep")])

  let (cleared, consumed) = @engine.take_events(step3)
  assert_eq(consumed, [@engine.EngineEvent::Sfx("beep")])
  assert_eq(@engine.events(cleared), [])

  let (step4, _) = @engine.engine_step(cleared, @engine.btn([]))
  assert_eq(@engine.events(step4), [])
}

///|
test "engine interval command emits events repeatedly" {
  let cfg = @engine.config(4, 4)
  let initial = @engine.engine_init(IntervalCommandGame::{ ticks: 0 }, cfg)

  let (step1, _) = @engine.engine_step(initial, @engine.btn([]))
  assert_eq(@engine.events(step1), [])

  let (step2, _) = @engine.engine_step(step1, @engine.btn([]))
  assert_eq(@engine.events(step2), [])

  let (step3, _) = @engine.engine_step(step2, @engine.btn([]))
  assert_eq(@engine.events(step3), [@engine.EngineEvent::BgmStart])

  let (step4, _) = @engine.engine_step(step3, @engine.btn([]))
  assert_eq(@engine.events(step4), [])

  let (step5, _) = @engine.engine_step(step4, @engine.btn([]))
  assert_eq(@engine.events(step5), [@engine.EngineEvent::BgmStart])
}

///|
test "engine commands support immediate emit and delayed timeout from update" {
  let cfg = @engine.config(4, 4)
  let initial = @engine.engine_init(CommandGame::{ ticks: 0 }, cfg)

  let (step1, _) = @engine.engine_step(initial, @engine.btn([]))
  assert_eq(@engine.events(step1), [@engine.EngineEvent::Sfx("now")])

  let (step2, _) = @engine.engine_step(step1, @engine.btn([]))
  assert_eq(@engine.events(step2), [])

  let (step3, _) = @engine.engine_step(step2, @engine.btn([]))
  assert_eq(@engine.events(step3), [@engine.EngineEvent::Sfx("timer")])
}

///|
test "engine emits timer events before immediate command events in same frame" {
  let cfg = @engine.config(4, 4)
  let initial = @engine.engine_init(EventOrderGame::{ ticks: 0 }, cfg)

  let (step1, _) = @engine.engine_step(initial, @engine.btn([]))
  assert_eq(@engine.events(step1), [])

  let (step2, _) = @engine.engine_step(step1, @engine.btn([]))
  assert_eq(@engine.events(step2), [
    @engine.EngineEvent::Sfx("timer"),
    @engine.EngineEvent::Sfx("now"),
  ])

  let (cleared, consumed) = @engine.take_events(step2)
  assert_eq(consumed, [
    @engine.EngineEvent::Sfx("timer"),
    @engine.EngineEvent::Sfx("now"),
  ])
  assert_eq(@engine.events(cleared), [])
}

///|
test "rand returns value in [min, max) and is deterministic" {
  let v = @engine.rand(42, 0, 10)
  assert_true(v >= 0 && v < 10)
  assert_eq(@engine.rand(42, 0, 10), v)
  assert_eq(@engine.rand(42, 5, 5), 5)
  assert_eq(@engine.rand(42, 3, 4), 3)
  for seed in 0..<50 {
    let r = @engine.rand(seed, 10, 20)
    assert_true(r >= 10 && r < 20)
  }
}
