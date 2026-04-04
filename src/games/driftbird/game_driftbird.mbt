///|
type Palette = @model.Palette

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
type RuntimeContext = @model.RuntimeContext

///|
type Frame = @model.Frame

///|
fn parse_assets_dsl(input : String) -> Result[AssetBundle, @model.DslError] {
  @assets.parse_assets_dsl(input)
}

///|
fn palette_default() -> Palette {
  @model.palette_default()
}

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
fn default_engine_config() -> EngineConfig {
  @model.default_engine_config()
}

///|
fn btn(flap : Bool, reset : Bool) -> InputState {
  @engine.btn(flap, reset)
}

///|
fn btnp(current : Bool, previous : Bool) -> Bool {
  @engine.btnp(current, previous)
}

///|
fn every(frame : Int, interval : Int) -> Bool {
  @engine.every(frame, interval)
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
) -> (T, Array[Frame]) {
  @engine.run(game, config, inputs)
}

///|
fn default_bird_sprite() -> Sprite {
  Sprite::{
    name: "bird",
    width: 5,
    height: 3,
    pixels: [-1, 6, 6, 6, -1, 6, 4, 6, 4, 6, -1, 6, 6, 6, -1],
  }
}

///|
pub fn sample_assets_dsl() -> String {
  [
    "# moon8bit asset DSL v1", "palette dawn", "color 0 #0f1a20", "color 1 #274060",
    "color 2 #2e8b57", "color 3 #f2aa4c", "color 4 #e94f37", "color 5 #8f6f4f", "color 6 #f6f7eb",
    "end", "", "sprite bird 5 3", ".666.", "64646", ".666.", "end", "", "tilemap bg 8 6",
    "0 0 0 0 0 0 0 0", "0 0 1 0 0 1 0 0", "0 0 0 0 0 0 0 0", "0 0 0 0 0 0 0 0", "0 0 0 0 0 0 0 0",
    "1 0 0 1 0 0 1 0", "end", "", "tilemap ground 8 2", "5 5 5 5 5 5 5 5", "3 3 3 3 3 3 3 3",
    "end",
  ].join("\n")
}

///|
pub fn load_sample_assets() -> AssetBundle {
  match parse_assets_dsl(sample_assets_dsl()) {
    Ok(bundle) => bundle
    Err(_) =>
      AssetBundle::{
        palette: palette_default(),
        sprites: [default_bird_sprite()],
        tilemaps: [],
      }
  }
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
  mut tick : Int
  mut terrain_offset : Int
  mut is_started : Bool
  mut is_over : Bool
  mut last_hit_tag : String?
  mut pipe_scored : Bool
  mut prev_input : InputState
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
  if max_gap_top <= min_gap_top {
    return min_gap_top
  }

  let span = max_gap_top - min_gap_top + 1
  let mixed = seed * 37 + 17
  let non_negative = if mixed < 0 { -mixed } else { mixed }
  min_gap_top + non_negative % span
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
  game.tick = 0
  game.terrain_offset = 0
  game.is_started = false
  game.is_over = false
  game.last_hit_tag = None
  game.pipe_scored = false
  game.prev_input = @model.input_none
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
    tick: 0,
    terrain_offset: 0,
    is_started: false,
    is_over: false,
    last_hit_tag: None,
    pipe_scored: false,
    prev_input: @model.input_none,
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
fn step_running(
  game : DriftbirdGame,
  ctx : RuntimeContext,
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
    game.pipe_gap_y = next_gap_y(game.tick + 97, ctx.config, game.gap_height)
    game.pipe_scored = false
  }

  game.terrain_offset = (game.terrain_offset + 1) % ctx.config.width
  game.tick += 1

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
pub impl @engine.Game for DriftbirdGame with init(self, ctx) {
  reset_driftbird(self, ctx.config)
}

///|
pub impl @engine.Game for DriftbirdGame with update(self, ctx) {
  let flap_pressed = btnp(ctx.input.flap, self.prev_input.flap)
  let reset_pressed = btnp(ctx.input.reset, self.prev_input.reset)

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

  next.prev_input = ctx.input
  next
}

///|
pub impl @engine.Game for DriftbirdGame with draw(self, ctx) {
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

  let sprite = match find_sprite(self.bundle, "bird") {
    Some(found) => found
    None => default_bird_sprite()
  }
  spr(frame, sprite, self.bird_x, bird_y_px(self))

  if !self.is_started {
    rect(frame, 0, 0, ctx.config.width, 1, 6)
  } else if self.is_over {
    rect(frame, 0, 0, ctx.config.width, 1, 4)
  }

  frame
}

///|
pub fn scripted_demo_inputs(frame_count : Int) -> Array[InputState] {
  let inputs : Array[InputState] = []
  for i in 0..<frame_count {
    let flap = every(i, 8) || every(i, 13)
    inputs.push(btn(flap, false))
  }
  inputs
}

///|
pub fn run_driftbird(
  inputs : Array[InputState],
  config? : EngineConfig = default_engine_config(),
) -> (DriftbirdGame, Array[Frame]) {
  let bundle = load_sample_assets()
  let initial = new_driftbird_game(bundle)
  run(initial, config, inputs)
}

///|
pub fn run_driftbird_demo(frame_count : Int) -> (DriftbirdGame, Array[String]) {
  let inputs = scripted_demo_inputs(frame_count)
  let (state, frames) = run_driftbird(inputs)
  let ascii_frames = frames.map(frame => frame.to_ascii())
  (state, ascii_frames)
}
