///|
type Sprite = @model.Sprite

///|
type Tilemap = @model.Tilemap

///|
type AssetBundle = @model.AssetBundle

///|
type Collider = @model.Collider

///|
type EngineConfig = @model.EngineConfig

///|
type InputState = @model.InputState

///|
type UpdateContext = @engine.UpdateContext

///|
type DrawContext = @engine.DrawContext

///|
type Frame = @model.Frame

///|
type EngineEvent = @engine.EngineEvent

///|
pub type DriftbirdRuntime = @engine.EngineInstance[DriftbirdGame]

///|
fn find_sprite(bundle : AssetBundle, name : String) -> Sprite? {
  @model.find_sprite(bundle, name)
}

///|
fn find_tilemap(bundle : AssetBundle, name : String) -> Tilemap? {
  @model.find_tilemap(bundle, name)
}

///|
fn tile_at(tilemap : Tilemap, x : Int, y : Int) -> Int? {
  @model.tile_at(tilemap, x, y)
}

///|
fn collider_box(tag : String, x : Int, y : Int, w : Int, h : Int) -> Collider {
  @model.collider_box(tag, x, y, w, h)
}

///|
fn aabb_hit_tag(
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  obstacles : Array[Collider],
) -> String? {
  @engine.aabb_hit_tag(x, y, w, h, obstacles)
}

///|
fn ui_center_x(total_width : Int, item_width : Int) -> Int {
  @engine.ui_center_x(total_width, item_width)
}

///|
fn ui_center_y(total_height : Int, item_height : Int) -> Int {
  @engine.ui_center_y(total_height, item_height)
}

///|
fn ui_panel(
  frame : Frame,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  fill : Int,
  border? : Int = -1,
) -> Unit {
  @engine.ui_panel(frame, x, y, w, h, fill, border~)
}

///|
fn ui_text_width(text : String, scale? : Int = 1) -> Int {
  @engine.ui_text_width(text, scale~)
}

///|
fn ui_text(
  frame : Frame,
  x : Int,
  y : Int,
  text : String,
  color : Int,
  scale? : Int = 1,
) -> Unit {
  @engine.ui_text(frame, x, y, text, color, scale~)
}

///|
fn default_engine_config() -> EngineConfig {
  @model.default_engine_config()
}

///|
fn key_pressed(input : InputState, key : String) -> Bool {
  @model.key_pressed(input, key)
}

///|
fn pset(frame : Frame, x : Int, y : Int, color : Int) -> Unit {
  @engine.pset(frame, x, y, color)
}

///|
fn rect(frame : Frame, x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit {
  @engine.rect(frame, x, y, w, h, color)
}

///|
fn spr(frame : Frame, sprite : Sprite, x : Int, y : Int) -> Unit {
  @engine.spr(frame, sprite, x, y)
}

///|
fn[T : @engine.Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (@engine.EngineInstance[T], Array[Frame]) {
  @engine.run(game, config, inputs)
}

///|
pub struct DriftbirdGame {
  bundle : AssetBundle
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
fn clamp_double(
  value : Double,
  min_value : Double,
  max_value : Double,
) -> Double {
  if value < min_value {
    min_value
  } else if value > max_value {
    max_value
  } else {
    value
  }
}

///|
fn floor_to_int(value : Double) -> Int {
  let truncated = value.to_int()
  let truncated_double = Double::from_int(truncated)
  if value < truncated_double {
    truncated - 1
  } else {
    truncated
  }
}

///|
fn bird_y_px(game : DriftbirdGame) -> Int {
  floor_to_int(game.bird_y)
}

///|
fn next_gap_y(seed : Int, config : EngineConfig, gap_height : Int) -> Int {
  let ground_y = config.height - 2
  let min_gap_top = 5
  let max_gap_top = ground_y - gap_height - 3
  @engine.rand(seed, min_gap_top, max_gap_top + 1)
}

///|
fn reset_driftbird(
  game : DriftbirdGame,
  config : EngineConfig,
) -> DriftbirdGame {
  game.bird_x = 8
  game.bird_y = Double::from_int(config.height / 2)
  game.bird_vy = 0.0
  game.pipe_width = 5
  game.gap_height = 11
  game.pipe_x = config.width + 4
  game.pipe_gap_y = next_gap_y(11, config, game.gap_height)
  game.score = 0
  game.terrain_offset = 0
  game.is_started = false
  game.is_over = false
  game.last_hit_tag = None
  game.pipe_scored = false
  game
}

///|
fn draw_scrolling_tilemap_rows(
  frame : Frame,
  tilemap : Tilemap,
  scroll_x : Int,
  start_y : Int,
  screen_width : Int,
  rows : Int,
) -> Unit {
  if tilemap.width <= 0 || tilemap.height <= 0 || rows <= 0 {
    return
  }

  for row in 0..<rows {
    let tile_y = row % tilemap.height
    for x in 0..<screen_width {
      let tile_x = (x + scroll_x) % tilemap.width
      let color = match tile_at(tilemap, tile_x, tile_y) {
        Some(v) => v
        None => 3
      }
      pset(frame, x, start_y + row, color)
    }
  }
}

///|
fn hit_code(tag : String?) -> Int {
  match tag {
    Some("ground") => 1
    Some("ceiling") => 2
    Some("pipe_top") => 3
    Some("pipe_bottom") => 4
    _ => 0
  }
}

///|
fn draw_hud(
  frame : Frame,
  game : DriftbirdGame,
  config : EngineConfig,
  tick : Int,
) -> Unit {
  ui_panel(frame, 0, 0, config.width, 9, 0)
  let hud = "S\{game.score} F\{tick} H\{hit_code(game.last_hit_tag)}"
  ui_text(frame, 1, 1, hud, 6)
}

///|
fn draw_state_overlay(
  frame : Frame,
  game : DriftbirdGame,
  config : EngineConfig,
) -> Unit {
  let line1 = if game.is_over { "GAME" } else { "SPACE" }
  let line2 = if game.is_over { "OVER" } else { "" }
  let line1_w = ui_text_width(line1)
  let line2_w = ui_text_width(line2)
  let content_w = if line1_w > line2_w { line1_w } else { line2_w }
  let content_h = if line2 == "" { 7 } else { 15 }
  let panel_w = content_w + 4
  let panel_h = content_h + 4
  let panel_x = ui_center_x(config.width, panel_w)
  let panel_y = ui_center_y(config.height, panel_h)
  let fill = if game.is_over { 4 } else { 6 }
  let text_color = if game.is_over { 6 } else { 0 }

  ui_panel(frame, panel_x, panel_y, panel_w, panel_h, fill, border=0)
  ui_text(
    frame,
    panel_x + 2 + (content_w - line1_w) / 2,
    panel_y + 2,
    line1,
    text_color,
  )
  if line2 != "" {
    ui_text(
      frame,
      panel_x + 2 + (content_w - line2_w) / 2,
      panel_y + 10,
      line2,
      text_color,
    )
  }
}

///|
fn pipe_colliders(
  game : DriftbirdGame,
  config : EngineConfig,
) -> Array[Collider] {
  let ground_y = config.height - 2
  let colliders : Array[Collider] = []
  colliders.push(
    collider_box("pipe_top", game.pipe_x, 0, game.pipe_width, game.pipe_gap_y),
  )

  let bottom_y = game.pipe_gap_y + game.gap_height
  let bottom_h = ground_y - bottom_y
  if bottom_h > 0 {
    colliders.push(
      collider_box(
        "pipe_bottom",
        game.pipe_x,
        bottom_y,
        game.pipe_width,
        bottom_h,
      ),
    )
  }

  colliders
}

///|
fn detect_collision_tag(game : DriftbirdGame, config : EngineConfig) -> String? {
  let ground_y = config.height - 2
  let bird_top = bird_y_px(game)
  let bird_x = game.bird_x
  let bird_w = 5
  let bird_h = 3

  if game.bird_y < 0.0 {
    return Some("ceiling")
  }
  if bird_top + bird_h > ground_y {
    return Some("ground")
  }

  aabb_hit_tag(bird_x, bird_top, bird_w, bird_h, pipe_colliders(game, config))
}

///|
pub fn new_driftbird_game(bundle : AssetBundle) -> DriftbirdGame {
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
pub fn init_game(
  bundle : AssetBundle,
  config : EngineConfig,
) -> DriftbirdRuntime {
  @engine.engine_init(new_driftbird_game(bundle), config)
}

///|
pub fn step_game(
  game : DriftbirdRuntime,
  input : InputState,
) -> (DriftbirdRuntime, Frame) {
  @engine.engine_step(game, input)
}

///|
fn step_running(
  game : DriftbirdGame,
  ctx : UpdateContext,
  flap_pressed : Bool,
) -> DriftbirdGame {
  let flap_impulse : Double = -2.5
  let gravity_up : Double = 0.42
  let gravity_base_down : Double = 0.16
  let gravity_down_gain : Double = 0.04
  let gravity_down_max : Double = 0.28
  let min_vy : Double = -2.35
  let max_vy : Double = 4.8

  if flap_pressed {
    game.bird_vy = flap_impulse
  }

  // Keep apex transition smooth: falling gravity ramps up with current down speed.
  let g = if game.bird_vy < 0.0 {
    gravity_up
  } else {
    clamp_double(
      gravity_base_down + game.bird_vy * gravity_down_gain,
      gravity_base_down,
      gravity_down_max,
    )
  }
  game.bird_vy = clamp_double(game.bird_vy + g, min_vy, max_vy)
  game.bird_y += game.bird_vy

  game.pipe_x -= 1
  if !game.pipe_scored && game.pipe_x + game.pipe_width < game.bird_x {
    game.score += 1
    game.pipe_scored = true
  }
  if game.pipe_x + game.pipe_width < 0 {
    game.pipe_x = ctx.config.width + 6
    game.pipe_gap_y = next_gap_y(ctx.tick + 97, ctx.config, game.gap_height)
    game.pipe_scored = false
  }

  game.terrain_offset = (game.terrain_offset + 1) % ctx.config.width

  match detect_collision_tag(game, ctx.config) {
    Some(tag) => {
      game.last_hit_tag = Some(tag)
      game.is_over = true
    }
    None => ()
  }

  game
}

///|
pub impl @engine.Game for DriftbirdGame with init(self, config : EngineConfig) {
  reset_driftbird(self, config)
}

///|
pub impl @engine.Game for DriftbirdGame with update(self, ctx : UpdateContext) {
  let flap_pressed = @engine.key_pressed_any(ctx.input, ["Space", "ArrowUp"])
  let reset_pressed = key_pressed(ctx.input, "KeyR")

  if flap_pressed {
    ctx.sfx("flap")
  }
  if reset_pressed {
    ctx.clear_timers()
    ctx.sfx("reset")
    ctx.bgm_stop()
  }

  let was_started = self.is_started
  let was_over = self.is_over

  let next = if reset_pressed {
    reset_driftbird(self, ctx.config)
  } else if self.is_over {
    if !flap_pressed {
      self
    } else {
      let restarted = reset_driftbird(self, ctx.config)
      restarted.is_started = true
      step_running(restarted, ctx, flap_pressed)
    }
  } else if !self.is_started && !flap_pressed {
    self
  } else {
    if !self.is_started {
      self.is_started = true
    }
    step_running(self, ctx, flap_pressed)
  }

  if !was_started && next.is_started {
    ctx.set_timeout(1, EngineEvent::BgmStart)
  }
  if was_over && !next.is_over && next.is_started {
    ctx.set_timeout(1, EngineEvent::BgmStart)
  }
  if !was_over && next.is_over {
    ctx.set_timeout(1, EngineEvent::Sfx("hit"))
    ctx.bgm_stop()
  }

  next
}

///|
pub impl @engine.Game for DriftbirdGame with draw(self, ctx : DrawContext) {
  let frame = Frame::new(ctx.config.width, ctx.config.height, fill=0)
  let ground_rows = if ctx.config.height >= 2 { 2 } else { ctx.config.height }
  let ground_y = ctx.config.height - ground_rows
  let background_rows = if ground_y > 0 { ground_y } else { 0 }

  match find_tilemap(self.bundle, "bg") {
    Some(tilemap) =>
      draw_scrolling_tilemap_rows(
        frame,
        tilemap,
        self.terrain_offset / 2,
        0,
        ctx.config.width,
        background_rows,
      )
    None =>
      for x in 0..<ctx.config.width {
        if (x + self.terrain_offset) % 7 == 0 {
          pset(frame, x, 1, 1)
        }
        if (x + self.terrain_offset) % 11 == 0 {
          pset(frame, x, 3, 1)
        }
      }
  }

  match find_tilemap(self.bundle, "ground") {
    Some(tilemap) =>
      draw_scrolling_tilemap_rows(
        frame,
        tilemap,
        self.terrain_offset,
        ground_y,
        ctx.config.width,
        ground_rows,
      )
    None => rect(frame, 0, ground_y, ctx.config.width, ground_rows, 3)
  }

  rect(frame, self.pipe_x, 0, self.pipe_width, self.pipe_gap_y, 2)
  let bottom_y = self.pipe_gap_y + self.gap_height
  let bottom_h = ground_y - bottom_y
  if bottom_h > 0 {
    rect(frame, self.pipe_x, bottom_y, self.pipe_width, bottom_h, 2)
  }

  match find_sprite(self.bundle, "bird") {
    Some(sprite) => spr(frame, sprite, self.bird_x, bird_y_px(self))
    None => ()
  }

  draw_hud(frame, self, ctx.config, ctx.tick)
  if !self.is_started || self.is_over {
    draw_state_overlay(frame, self, ctx.config)
  }

  frame
}

///|
pub fn run_driftbird(
  bundle : AssetBundle,
  inputs : Array[InputState],
  config? : EngineConfig = default_engine_config(),
) -> (DriftbirdGame, Array[Frame]) {
  let initial = new_driftbird_game(bundle)
  let (runtime, frames) = run(initial, config, inputs)
  (@engine.engine_game(runtime), frames)
}
