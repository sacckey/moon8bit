///|
pub type DriftbirdRuntime = @engine.EngineInstance[DriftbirdGame]

///|
pub struct DriftbirdGame {
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
pub fn DriftbirdGame::score(self : DriftbirdGame) -> Int {
  self.score
}

///|
pub fn DriftbirdGame::is_over(self : DriftbirdGame) -> Bool {
  self.is_over
}

///|
pub fn DriftbirdGame::is_started(self : DriftbirdGame) -> Bool {
  self.is_started
}

///|
pub fn DriftbirdGame::last_hit_tag(self : DriftbirdGame) -> String? {
  self.last_hit_tag
}

///|
pub fn new_driftbird_game(bundle : @model.AssetBundle) -> DriftbirdGame {
  DriftbirdGame::{
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
fn reset(game : DriftbirdGame, config : @model.EngineConfig) -> DriftbirdGame {
  game.bird_x = 8
  game.bird_y = Double::from_int(config.height / 2)
  game.bird_vy = 0.0
  game.pipe_width = 5
  game.gap_height = 11
  game.pipe_x = config.width + 4
  game.pipe_gap_y = @engine.rand(11, 5, config.height - 2 - game.gap_height - 3)
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
  game : DriftbirdGame,
  config : @model.EngineConfig,
) -> Array[@model.Collider] {
  let ground_y = config.height - 2
  let bottom_y = game.pipe_gap_y + game.gap_height
  let bottom_h = ground_y - bottom_y
  let cols = [
    @model.collider_box(
      "pipe_top",
      game.pipe_x,
      0,
      game.pipe_width,
      game.pipe_gap_y,
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
fn detect_hit(game : DriftbirdGame, config : @model.EngineConfig) -> String? {
  let ground_y = config.height - 2
  let by = game.bird_y.to_int()
  if game.bird_y < 0.0 {
    return Some("ceiling")
  }
  if by + 3 > ground_y {
    return Some("ground")
  }
  @engine.aabb_hit_tag(game.bird_x, by, 5, 3, pipe_colliders(game, config))
}

///|
fn step_physics(
  game : DriftbirdGame,
  ctx : @engine.UpdateContext,
  flap : Bool,
) -> DriftbirdGame {
  if flap {
    game.bird_vy = -2.5
  }
  let g = if game.bird_vy < 0.0 {
    0.42
  } else {
    let gd = 0.16 + game.bird_vy * 0.04
    if gd > 0.28 {
      0.28
    } else {
      gd
    }
  }
  game.bird_vy = game.bird_vy + g
  if game.bird_vy < -2.35 {
    game.bird_vy = -2.35
  }
  if game.bird_vy > 4.8 {
    game.bird_vy = 4.8
  }
  game.bird_y += game.bird_vy

  game.pipe_x -= 1
  if !game.pipe_scored && game.pipe_x + game.pipe_width < game.bird_x {
    game.score += 1
    game.pipe_scored = true
  }
  if game.pipe_x + game.pipe_width < 0 {
    game.pipe_x = ctx.config.width + 6
    game.pipe_gap_y = @engine.rand(
      ctx.tick + 97,
      5,
      ctx.config.height - 2 - game.gap_height - 3,
    )
    game.pipe_scored = false
  }
  game.terrain_offset = (game.terrain_offset + 1) % ctx.config.width

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
fn draw_tilemap_rows(
  frame : @model.Frame,
  tilemap : @model.Tilemap,
  scroll_x : Int,
  start_y : Int,
  w : Int,
  rows : Int,
) -> Unit {
  for row in 0..<rows {
    let ty = row % tilemap.height
    for x in 0..<w {
      let tx = (x + scroll_x) % tilemap.width
      match @model.tile_at(tilemap, tx, ty) {
        Some(c) => frame.set_pixel(x, start_y + row, c)
        None => ()
      }
    }
  }
}

///|
pub impl @engine.Game for DriftbirdGame with init(self, config) {
  reset(self, config)
}

///|
pub impl @engine.Game for DriftbirdGame with update(self, ctx) {
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
pub impl @engine.Game for DriftbirdGame with draw(self, ctx) {
  let w = ctx.config.width
  let h = ctx.config.height
  let ground_rows = 2
  let ground_y = h - ground_rows
  let frame = @model.Frame::new(w, h, fill=0)

  match @model.find_tilemap(self.bundle, "bg") {
    Some(tm) =>
      draw_tilemap_rows(frame, tm, self.terrain_offset / 2, 0, w, ground_y)
    None => ()
  }
  match @model.find_tilemap(self.bundle, "ground") {
    Some(tm) =>
      draw_tilemap_rows(
        frame,
        tm,
        self.terrain_offset,
        ground_y,
        w,
        ground_rows,
      )
    None => frame.draw_rect(0, ground_y, w, ground_rows, 3)
  }

  // pipes
  frame.draw_rect(self.pipe_x, 0, self.pipe_width, self.pipe_gap_y, 2)
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
) -> DriftbirdRuntime {
  @engine.engine_init(new_driftbird_game(bundle), config)
}

///|
pub fn step_game(
  game : DriftbirdRuntime,
  input : @model.InputState,
) -> (DriftbirdRuntime, @model.Frame) {
  @engine.engine_step(game, input)
}

///|
pub fn run_driftbird(
  bundle : @model.AssetBundle,
  inputs : Array[@model.InputState],
  config? : @model.EngineConfig = @model.default_engine_config(),
) -> (DriftbirdGame, Array[@model.Frame]) {
  let (runtime, frames) = @engine.run(
    new_driftbird_game(bundle),
    config,
    inputs,
  )
  (@engine.engine_game(runtime), frames)
}
