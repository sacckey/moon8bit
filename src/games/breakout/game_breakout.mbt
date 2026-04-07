///|
pub struct BreakoutGame {
  // paddle
  mut pad_x : Int
  // ball
  mut ball_x : Double
  mut ball_y : Double
  mut ball_vx : Double
  mut ball_vy : Double
  // blocks: 0=empty, 1..7=color index
  blocks : Array[Int]
  mut score : Int
  mut lives : Int
  mut is_started : Bool
  mut is_over : Bool
  mut is_clear : Bool
} derive(Eq, Show)

// layout constants

///|
let screen_w = 128

///|
let screen_h = 128

///|
let pad_w = 20

///|
let pad_h = 3

///|
let pad_y : Int = screen_h - 10

///|
let ball_r = 2

///|
let block_cols = 11

///|
let block_rows = 5

///|
let block_w = 11

///|
let block_h = 5

///|
let blocks_off_x = 4

///|
let blocks_off_y = 14

///|
let ball_speed = 2.0

///|
fn block_color(row : Int) -> Int {
  match row % 5 {
    0 => 3
    1 => 5
    2 => 4
    3 => 7
    _ => 2
  }
}

///|
fn init_blocks() -> Array[Int] {
  let bs = Array::make(block_cols * block_rows, 0)
  for r in 0..<block_rows {
    for c in 0..<block_cols {
      bs[r * block_cols + c] = block_color(r)
    }
  }
  bs
}

///|
fn reset_ball(game : BreakoutGame) -> Unit {
  game.ball_x = Double::from_int(game.pad_x + pad_w / 2)
  game.ball_y = Double::from_int(pad_y - ball_r - 1)
  game.ball_vx = ball_speed
  game.ball_vy = -ball_speed
}

///|
pub fn new_breakout_game() -> BreakoutGame {
  BreakoutGame::{
    pad_x: screen_w / 2 - pad_w / 2,
    ball_x: 0.0,
    ball_y: 0.0,
    ball_vx: 0.0,
    ball_vy: 0.0,
    blocks: init_blocks(),
    score: 0,
    lives: 3,
    is_started: false,
    is_over: false,
    is_clear: false,
  }
}

///|
fn blocks_remaining(game : BreakoutGame) -> Int {
  let mut n = 0
  for c in game.blocks {
    if c > 0 {
      n += 1
    }
  }
  n
}

///|
fn step_physics(game : BreakoutGame, ctx : @engine.UpdateContext) -> Unit {
  let prev_x = game.ball_x
  let prev_y = game.ball_y
  game.ball_x += game.ball_vx
  game.ball_y += game.ball_vy

  // wall bounce
  if game.ball_x - Double::from_int(ball_r) < 0.0 {
    game.ball_x = Double::from_int(ball_r)
    game.ball_vx = -game.ball_vx
    ctx.sfx("hit")
  }
  if game.ball_x + Double::from_int(ball_r) > Double::from_int(screen_w) {
    game.ball_x = Double::from_int(screen_w - ball_r)
    game.ball_vx = -game.ball_vx
    ctx.sfx("hit")
  }
  if game.ball_y - Double::from_int(ball_r) < 0.0 {
    game.ball_y = Double::from_int(ball_r)
    game.ball_vy = -game.ball_vy
    ctx.sfx("hit")
  }

  // paddle bounce
  let bx = game.ball_x.to_int()
  let by = game.ball_y.to_int()
  if game.ball_vy > 0.0 &&
    by + ball_r >= pad_y &&
    by - ball_r <= pad_y + pad_h &&
    bx >= game.pad_x &&
    bx <= game.pad_x + pad_w {
    game.ball_vy = -game.ball_vy
    // slight angle based on hit position
    let offset = bx - (game.pad_x + pad_w / 2)
    game.ball_vx = Double::from_int(offset) * 0.15 + game.ball_vx * 0.5
    // clamp vx
    if game.ball_vx > ball_speed * 1.5 {
      game.ball_vx = ball_speed * 1.5
    }
    if game.ball_vx < -ball_speed * 1.5 {
      game.ball_vx = -ball_speed * 1.5
    }
    ctx.sfx("hit")
  }

  // block collision — collect hits, resolve with a single stable bounce
  let cx = game.ball_x.to_int()
  let cy = game.ball_y.to_int()
  let prev_cx = prev_x.to_int()
  let prev_cy = prev_y.to_int()
  let now_left = cx - ball_r
  let now_right = cx + ball_r
  let now_top = cy - ball_r
  let now_bottom = cy + ball_r
  let prev_left = prev_cx - ball_r
  let prev_right = prev_cx + ball_r
  let prev_top = prev_cy - ball_r
  let prev_bottom = prev_cy + ball_r

  let mut hit_x = false
  let mut hit_y = false
  let mut min_overlap_x = screen_w
  let mut min_overlap_y = screen_h
  let mut hit_count = 0
  for i in 0..<(block_cols * block_rows) {
    if game.blocks[i] == 0 {
      continue
    }
    let bc = i % block_cols
    let br = i / block_cols
    let bk_x = blocks_off_x + bc * block_w
    let bk_y = blocks_off_y + br * block_h
    let bk_right = bk_x + block_w
    let bk_bottom = bk_y + block_h
    if now_right > bk_x &&
      now_left < bk_right &&
      now_bottom > bk_y &&
      now_top < bk_bottom {
      game.blocks[i] = 0
      game.score += 10
      hit_count += 1

      let entered_x = (prev_right <= bk_x && now_right > bk_x) ||
        (prev_left >= bk_right && now_left < bk_right)
      let entered_y = (prev_bottom <= bk_y && now_bottom > bk_y) ||
        (prev_top >= bk_bottom && now_top < bk_bottom)
      if entered_x {
        hit_x = true
      }
      if entered_y {
        hit_y = true
      }

      let overlap_x = (if now_right < bk_right { now_right } else { bk_right }) -
        (if now_left > bk_x { now_left } else { bk_x })
      let overlap_y = (if now_bottom < bk_bottom {
          now_bottom
        } else {
          bk_bottom
        }) -
        (if now_top > bk_y { now_top } else { bk_y })
      if overlap_x > 0 && overlap_x < min_overlap_x {
        min_overlap_x = overlap_x
      }
      if overlap_y > 0 && overlap_y < min_overlap_y {
        min_overlap_y = overlap_y
      }
    }
  }
  if hit_count > 0 {
    // If entry axis is ambiguous (touching seams/corners), pick the shallower penetration axis.
    if !hit_x && !hit_y {
      if min_overlap_y < min_overlap_x {
        hit_y = true
      } else {
        hit_x = true
      }
    } else if hit_x && hit_y {
      if min_overlap_y < min_overlap_x {
        hit_x = false
      } else {
        hit_y = false
      }
    }

    // Reflect once and rewind only on reflected axis to avoid jitter/explosions.
    if hit_y {
      game.ball_vy = -game.ball_vy
      game.ball_y = prev_y
    }
    if hit_x {
      game.ball_vx = -game.ball_vx
      game.ball_x = prev_x
    }
    ctx.sfx("break")
  }

  // ball lost
  if game.ball_y - Double::from_int(ball_r) > Double::from_int(screen_h) {
    game.lives -= 1
    ctx.sfx("lose")
    if game.lives <= 0 {
      game.is_over = true
    } else {
      game.is_started = false
      reset_ball(game)
    }
  }
}

///|
pub impl @engine.Game for BreakoutGame with init(_self, _config) {
  let g = new_breakout_game()
  reset_ball(g)
  g
}

///|
pub impl @engine.Game for BreakoutGame with update(self, ctx) {
  if self.is_over || self.is_clear {
    if @engine.key_pressed(ctx.input, "Space") {
      let g = new_breakout_game()
      reset_ball(g)
      g.is_started = false
      return g
    }
    return self
  }

  // paddle movement
  let speed = 3
  if @engine.key_down(ctx.input, "ArrowLeft") ||
    @engine.key_down(ctx.input, "KeyA") {
    self.pad_x -= speed
  }
  if @engine.key_down(ctx.input, "ArrowRight") ||
    @engine.key_down(ctx.input, "KeyD") {
    self.pad_x += speed
  }
  self.pad_x = @engine.clamp(self.pad_x, 0, screen_w - pad_w)

  if !self.is_started {
    // ball follows paddle before launch
    self.ball_x = Double::from_int(self.pad_x + pad_w / 2)
    if @engine.key_pressed(ctx.input, "Space") {
      self.is_started = true
    }
    return self
  }

  step_physics(self, ctx)

  if blocks_remaining(self) == 0 {
    self.is_clear = true
  }

  self
}

///|
pub impl @engine.Game for BreakoutGame with draw(self, _ctx) {
  let frame = @model.Frame::new(screen_w, screen_h, fill=0)

  // background grid
  for y in 0..<screen_h {
    for x in 0..<screen_w {
      if x % 16 == 0 || y % 16 == 0 {
        frame.set_pixel(x, y, 1)
      }
    }
  }

  // blocks
  for i in 0..<(block_cols * block_rows) {
    let c = self.blocks[i]
    if c == 0 {
      continue
    }
    let bc = i % block_cols
    let br = i / block_cols
    let bk_x = blocks_off_x + bc * block_w
    let bk_y = blocks_off_y + br * block_h
    frame.draw_rect(bk_x, bk_y, block_w - 1, block_h - 1, c)
  }

  // paddle
  frame.draw_rect(self.pad_x, pad_y, pad_w, pad_h, 6)

  // ball
  let bx = self.ball_x.to_int()
  let by = self.ball_y.to_int()
  frame.draw_rect(bx - ball_r, by - ball_r, ball_r * 2, ball_r * 2, 6)

  // HUD
  frame.draw_rect(0, 0, screen_w, 9, 0)
  @engine.ui_text(frame, 1, 1, "S\{self.score} L\{self.lives}", 6)

  // overlay
  if !self.is_started && !self.is_over && !self.is_clear {
    let msg = "SPACE"
    let mw = @engine.ui_text_width(msg)
    let pw = mw + 4
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, 11)
    @engine.ui_panel(frame, px, py, pw, 11, 6, border=0)
    @engine.ui_text(frame, px + 2, py + 2, msg, 0)
  }
  if self.is_over {
    let pw = 44
    let ph = 19
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, ph)
    @engine.ui_panel(frame, px, py, pw, ph, 3, border=0)
    @engine.ui_text(frame, px + 2, py + 2, "GAME OVER", 6)
    @engine.ui_text(frame, px + 2, py + 11, "SPACE:retry", 6)
  }
  if self.is_clear {
    let pw = 44
    let ph = 19
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, ph)
    @engine.ui_panel(frame, px, py, pw, ph, 4, border=0)
    @engine.ui_text(frame, px + 2, py + 2, "CLEAR!", 6)
    @engine.ui_text(frame, px + 2, py + 11, "SPACE:retry", 6)
  }

  frame
}

///|
pub fn init_game(
  _bundle : @model.AssetBundle,
  config : @model.EngineConfig,
) -> @engine.EngineInstance[BreakoutGame] {
  @engine.engine_init(new_breakout_game(), config)
}

///|
pub fn step_game(
  game : @engine.EngineInstance[BreakoutGame],
  input : @model.InputState,
) -> (@engine.EngineInstance[BreakoutGame], @model.Frame) {
  @engine.engine_step(game, input)
}
