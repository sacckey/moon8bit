///|
pub type FlappyRuntime = @engine.EngineInstance[FlappyGame]

///|
let hud_h = 9

///|
let play_y : Int = hud_h

///|
let game_w = 128

///|
let game_h = 128

///|
let ground_rows = 2

///|
let ground_y : Int = game_h - ground_rows

///|
let bg_color : Int = 1

///|
pub struct FlappyGame {
  bundle : @model.AssetBundle
  mut bird_x : Int
  mut bird_y : Double
  mut bird_vy : Double
  mut pipe_x : Int
  mut pipe_gap_y : Int
  mut pipe_width : Int
  mut gap_height : Int
  mut score : Int
  mut terrain_offset : Int
  mut is_started : Bool
  mut is_over : Bool
  mut last_hit_tag : String?
  mut pipe_scored : Bool
} derive(Eq, Show)

///|
pub fn FlappyGame::score(self : FlappyGame) -> Int {
  self.score
}

///|
pub fn FlappyGame::is_over(self : FlappyGame) -> Bool {
  self.is_over
}

///|
pub fn FlappyGame::is_started(self : FlappyGame) -> Bool {
  self.is_started
}

///|
pub fn FlappyGame::last_hit_tag(self : FlappyGame) -> String? {
  self.last_hit_tag
}

///|
pub fn new_flappy_game(bundle : @model.AssetBundle) -> FlappyGame {
  FlappyGame::{
    bundle,
    bird_x: 8,
    bird_y: 0.0,
    bird_vy: 0.0,
    pipe_x: 0,
    pipe_gap_y: 0,
    pipe_width: 0,
    gap_height: 0,
    score: 0,
    terrain_offset: 0,
    is_started: false,
    is_over: false,
    last_hit_tag: None,
    pipe_scored: false,
  }
}

///|
fn reset(game : FlappyGame, _config : @model.EngineConfig) -> FlappyGame {
  game.bird_x = 8
  game.bird_y = Double::from_int((play_y + ground_y) / 2)
  game.bird_vy = 0.0
  game.pipe_width = 20
  game.gap_height = 25
  game.pipe_x = game_w + 2
  game.pipe_gap_y = @engine.rand(11, play_y + 2, ground_y - game.gap_height - 2)
  game.score = 0
  game.terrain_offset = 0
  game.is_started = false
  game.is_over = false
  game.last_hit_tag = None
  game.pipe_scored = false
  game
}

///|
fn pipe_colliders(
  game : FlappyGame,
  _config : @model.EngineConfig,
) -> Array[@model.Collider] {
  let bottom_y = game.pipe_gap_y + game.gap_height
  let bottom_h = ground_y - bottom_y
  let cols = [
    @model.collider_box(
      "pipe_top",
      game.pipe_x,
      play_y,
      game.pipe_width,
      game.pipe_gap_y - play_y,
    ),
  ]
  if bottom_h > 0 {
    cols.push(
      @model.collider_box(
        "pipe_bottom",
        game.pipe_x,
        bottom_y,
        game.pipe_width,
        bottom_h,
      ),
    )
  }
  cols
}

///|
fn detect_hit(game : FlappyGame, config : @model.EngineConfig) -> String? {
  let by = game.bird_y.to_int()
  if game.bird_y < Double::from_int(play_y) {
    return Some("ceiling")
  }
  let ground_hit = match @model.find_tilemap(game.bundle, "stage") {
    Some(tm) => {
      let foot_y = by + 3
      @engine.tile_solid_at_px(tm, game.bundle.tiles, game.bird_x, foot_y) ||
      @engine.tile_solid_at_px(tm, game.bundle.tiles, game.bird_x + 4, foot_y)
    }
    None => by + 3 > ground_y
  }
  if ground_hit {
    return Some("ground")
  }
  @engine.aabb_hit_tag(game.bird_x, by, 5, 3, pipe_colliders(game, config))
}

///|
fn step_physics(
  game : FlappyGame,
  ctx : @engine.UpdateContext,
  flap : Bool,
) -> FlappyGame {
  let flap_impulse = -3.1
  let gravity_up = 0.26
  let gravity_down_base = 0.12
  let gravity_down_gain = 0.03
  let gravity_down_max = 0.22
  let min_vy = -3.3
  let max_vy = 4.2

  if flap {
    game.bird_vy = flap_impulse
  }
  let g = if game.bird_vy < 0.0 {
    gravity_up
  } else {
    let gd = gravity_down_base + game.bird_vy * gravity_down_gain
    if gd > gravity_down_max {
      gravity_down_max
    } else {
      gd
    }
  }
  game.bird_vy = game.bird_vy + g
  if game.bird_vy < min_vy {
    game.bird_vy = min_vy
  }
  if game.bird_vy > max_vy {
    game.bird_vy = max_vy
  }
  game.bird_y += game.bird_vy

  game.pipe_x -= 1
  if !game.pipe_scored && game.pipe_x + game.pipe_width < game.bird_x {
    game.score += 1
    game.pipe_scored = true
  }
  if game.pipe_x + game.pipe_width < 0 {
    game.pipe_x = game_w + 2
    game.pipe_gap_y = @engine.rand(
      ctx.tick + 97,
      play_y + 2,
      ground_y - game.gap_height - 2,
    )
    game.pipe_scored = false
  }
  game.terrain_offset = (game.terrain_offset + 1) % game_w

  match detect_hit(game, ctx.config) {
    Some(tag) => {
      game.last_hit_tag = Some(tag)
      game.is_over = true
    }
    None => ()
  }
  game
}

///|
pub impl @engine.Game for FlappyGame with init(self, config) {
  reset(self, config)
}

///|
pub impl @engine.Game for FlappyGame with update(self, ctx) {
  let flap = @engine.key_pressed_any(ctx.input, ["Space", "ArrowUp"])
  let r = @engine.key_pressed(ctx.input, "KeyR")

  if flap {
    ctx.sfx("flap")
  }
  if r {
    ctx.clear_timers()
    ctx.sfx("reset")
    ctx.bgm_stop()
  }

  let was_started = self.is_started
  let was_over = self.is_over

  let next = if r {
    reset(self, ctx.config)
  } else if self.is_over {
    if flap {
      let g = reset(self, ctx.config)
      g.is_started = true
      step_physics(g, ctx, flap)
    } else {
      self
    }
  } else if !self.is_started {
    if flap {
      self.is_started = true
    }
    if self.is_started {
      step_physics(self, ctx, flap)
    } else {
      self
    }
  } else {
    step_physics(self, ctx, flap)
  }

  if !was_started && next.is_started {
    ctx.set_timeout(1, @engine.EngineEvent::BgmStart)
  }
  if was_over && !next.is_over && next.is_started {
    ctx.set_timeout(1, @engine.EngineEvent::BgmStart)
  }
  if !was_over && next.is_over {
    ctx.set_timeout(1, @engine.EngineEvent::Sfx("hit"))
    ctx.bgm_stop()
  }
  next
}

///|
pub impl @engine.Game for FlappyGame with draw(self, _ctx) {
  let w = game_w
  let h = game_h
  let frame = @model.Frame::new(w, h, fill=bg_color)
  match @model.find_tilemap(self.bundle, "stage") {
    Some(tm) =>
      @engine.draw_tilemap(frame, tm, self.bundle.tiles, 0, 0, w, h, 0, 0)
    _ => frame.draw_rect(0, ground_y, w, ground_rows, 3)
  }

  // pipes
  frame.draw_rect(
    self.pipe_x,
    play_y,
    self.pipe_width,
    self.pipe_gap_y - play_y,
    2,
  )
  let bottom_y = self.pipe_gap_y + self.gap_height
  let bottom_h = ground_y - bottom_y
  if bottom_h > 0 {
    frame.draw_rect(self.pipe_x, bottom_y, self.pipe_width, bottom_h, 2)
  }

  // bird
  match @model.find_sprite(self.bundle, "bird") {
    Some(spr) => frame.blit(spr, self.bird_x, self.bird_y.to_int())
    None => frame.draw_rect(self.bird_x, self.bird_y.to_int(), 5, 3, 3)
  }

  // HUD
  frame.draw_rect(0, 0, w, 9, 0)
  @engine.ui_text(frame, 1, 1, "S\{self.score}", 6)

  // overlay
  if !self.is_started || self.is_over {
    let msg1 = if self.is_over { "GAME" } else { "SPACE" }
    let msg2 = if self.is_over { "OVER" } else { "" }
    let cw = @engine.ui_text_width(msg1)
    let ch = if msg2 == "" { 7 } else { 15 }
    let pw = cw + 4
    let ph = ch + 4
    let px = @engine.ui_center_x(w, pw)
    let py = @engine.ui_center_y(h, ph)
    let fill = if self.is_over { 4 } else { 6 }
    let tc = if self.is_over { 6 } else { 0 }
    @engine.ui_panel(frame, px, py, pw, ph, fill, border=0)
    @engine.ui_text(frame, px + 2, py + 2, msg1, tc)
    if msg2 != "" {
      @engine.ui_text(frame, px + 2, py + 10, msg2, tc)
    }
  }
  frame
}

///|
pub fn init_game(
  bundle : @model.AssetBundle,
  config : @model.EngineConfig,
) -> FlappyRuntime {
  @engine.engine_init(new_flappy_game(bundle), config)
}

///|
pub fn step_game(
  game : FlappyRuntime,
  input : @model.InputState,
) -> (FlappyRuntime, @model.Frame) {
  @engine.engine_step(game, input)
}

///|
pub fn run_flappy(
  bundle : @model.AssetBundle,
  inputs : Array[@model.InputState],
  config? : @model.EngineConfig = @model.default_engine_config(),
) -> (FlappyGame, Array[@model.Frame]) {
  let (runtime, frames) = @engine.run(new_flappy_game(bundle), config, inputs)
  (@engine.engine_game(runtime), frames)
}
