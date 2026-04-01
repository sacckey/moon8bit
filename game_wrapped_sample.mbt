///|
fn wrapped_player_sprite() -> Sprite {
  Sprite::{
    name: "wrapped_player",
    width: 3,
    height: 3,
    pixels: [-1, 6, -1, 6, 4, 6, -1, 6, -1],
  }
}

///|
pub struct WrappedSampleGame {
  mut x : Int
  mut y : Int
  mut vy : Int
  mut tick : Int
} derive(Eq, Show)

///|
fn reset_wrapped_sample(
  game : WrappedSampleGame,
  cfg : EngineConfig,
) -> WrappedSampleGame {
  game.x = 6
  game.y = if cfg.height > 8 { cfg.height / 2 } else { 2 }
  game.vy = 0
  game.tick = 0
  game
}

///|
pub impl Game for WrappedSampleGame with init(self, ctx) {
  reset_wrapped_sample(self, ctx.config)
}

///|
pub impl Game for WrappedSampleGame with update(self, ctx) {
  if ctx.input.reset {
    return reset_wrapped_sample(self, ctx.config)
  }

  if ctx.input.flap {
    self.vy = -2
  } else if self.vy < 2 {
    self.vy += 1
  }

  self.y += self.vy
  let min_y = 1
  let max_y = if ctx.config.height > 5 { ctx.config.height - 5 } else { 1 }
  if self.y < min_y {
    self.y = min_y
    self.vy = 0
  }
  if self.y > max_y {
    self.y = max_y
    self.vy = 0
  }

  let wrap_width = if ctx.config.width > 0 { ctx.config.width } else { 1 }
  self.x = (self.x + 1) % wrap_width
  self.tick += 1
  self
}

///|
pub impl Game for WrappedSampleGame with draw(self, ctx) {
  let frame = Frame::new(ctx.config.width, ctx.config.height, fill=0)
  let sprite = wrapped_player_sprite()
  let ground_h = if ctx.config.height > 2 { 2 } else { 1 }
  let ground_y = ctx.config.height - ground_h
  let wrap_width = if ctx.config.width > 0 { ctx.config.width } else { 1 }
  let star_x = self.tick * 3 % wrap_width

  cls(frame, 0)
  rect(frame, 0, ground_y, ctx.config.width, ground_h, 3)
  pset(frame, star_x, 1, 1)
  spr(frame, sprite, self.x, self.y)
  frame
}

///|
pub fn wrapped_sample_inputs(frame_count : Int) -> Array[InputState] {
  let inputs : Array[InputState] = []
  for i in 0..<frame_count {
    let flap = i % 10 == 0
    let reset = i == frame_count / 2
    inputs.push(btn(flap, reset))
  }
  inputs
}

///|
pub fn run_wrapped_sample(
  frame_count : Int,
  cfg? : EngineConfig = config(64, 48),
) -> (WrappedSampleGame, Array[Frame]) {
  let inputs = wrapped_sample_inputs(frame_count)
  let initial = WrappedSampleGame::{ x: 0, y: 0, vy: 0, tick: 0 }
  run(initial, cfg, inputs)
}
