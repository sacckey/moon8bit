///|
struct TestGame {
  mut count : Int
}

///|
pub impl @engine.Game for TestGame with init(self, _ctx) {
  self
}

///|
pub impl @engine.Game for TestGame with update(self, ctx) {
  if key_pressed(ctx.input, "KeyR") {
    self.count = 0
  } else if key_pressed(ctx.input, "Space") {
    self.count = self.count + 1
  }
  self
}

///|
pub impl @engine.Game for TestGame with draw(self, ctx) {
  let frame = Frame::new(ctx.config.width, ctx.config.height, fill=0)
  if self.count % 2 == 1 {
    pset(frame, 0, 0, 1)
  }
  frame
}

///|
test "root facade exposes metadata and defaults" {
  assert_eq(version_tag(), "moon8bit-v0.1-mvp")

  let cfg = default_engine_config()
  assert_eq(cfg.width, 256)
  assert_eq(cfg.height, 144)
  assert_eq(cfg.fps, 60)
}

///|
test "assets cli output covers success and parse errors" {
  let ok = assets_cli_output(["tilemap m 1 1", "3", "end"].join("\n"))
  assert_true(ok.find("\"tilemaps\"") is Some(_))

  let ng = assets_cli_output(["sprite s 8 8", "g.......", "end"].join("\n"))
  assert_true(ng.find("error(line=2):") is Some(_))
}

///|
test "root facade run supports generic game" {
  let inputs = [
    input_state(["Space"], ["Space"], []),
    input_state(["Space"], ["Space"], []),
    input_state(["KeyR"], ["KeyR"], []),
    input_none,
  ]
  let (state, frames) = run(
    TestGame::{ count: 0 },
    default_engine_config(),
    inputs,
  )
  assert_eq(frames.length(), inputs.length())
  assert_eq(game_state(state).count, 0)
  assert_true(frames[0].to_ascii().length() > 0)
}

///|
test "root facade exposes collision helpers" {
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
