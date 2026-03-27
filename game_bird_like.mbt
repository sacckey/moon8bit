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
pub struct BirdLikeGame {
  bundle : AssetBundle
  mut bird_x : Int
  mut bird_y : Int
  mut bird_vy : Int
  mut pipe_x : Int
  mut pipe_gap_y : Int
  mut pipe_width : Int
  mut gap_height : Int
  mut score : Int
  mut tick : Int
  mut terrain_offset : Int
  mut is_over : Bool
} derive(Eq, Show)

///|
fn clamp(value : Int, min_value : Int, max_value : Int) -> Int {
  if value < min_value {
    min_value
  } else if value > max_value {
    max_value
  } else {
    value
  }
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
fn reset_bird_like(game : BirdLikeGame, config : EngineConfig) -> BirdLikeGame {
  game.bird_x = 8
  game.bird_y = config.height / 2
  game.bird_vy = 0
  game.pipe_width = 5
  game.gap_height = 11
  game.pipe_x = config.width + 4
  game.pipe_gap_y = next_gap_y(11, config, game.gap_height)
  game.score = 0
  game.tick = 0
  game.terrain_offset = 0
  game.is_over = false
  game
}

///|
fn bird_rect(game : BirdLikeGame) -> Rect {
  Rect::{ x: game.bird_x, y: game.bird_y, w: 5, h: 3 }
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
      frame.set_pixel(x, start_y + row, color)
    }
  }
}

///|
fn is_collision(game : BirdLikeGame, config : EngineConfig) -> Bool {
  let ground_y = config.height - 2
  let bird = bird_rect(game)

  if game.bird_y < 0 || game.bird_y + bird.h > ground_y {
    return true
  }

  let top_pipe = Rect::{
    x: game.pipe_x,
    y: 0,
    w: game.pipe_width,
    h: game.pipe_gap_y,
  }

  let bottom_y = game.pipe_gap_y + game.gap_height
  let bottom_h = ground_y - bottom_y
  let bottom_pipe = Rect::{
    x: game.pipe_x,
    y: bottom_y,
    w: game.pipe_width,
    h: if bottom_h > 0 {
      bottom_h
    } else {
      0
    },
  }

  rect_intersects(bird, top_pipe) ||
  (bottom_pipe.h > 0 && rect_intersects(bird, bottom_pipe))
}

///|
pub fn new_bird_like_game(bundle : AssetBundle) -> BirdLikeGame {
  BirdLikeGame::{
    bundle,
    bird_x: 8,
    bird_y: 0,
    bird_vy: 0,
    pipe_x: 0,
    pipe_gap_y: 0,
    pipe_width: 0,
    gap_height: 0,
    score: 0,
    tick: 0,
    terrain_offset: 0,
    is_over: false,
  }
}

///|
pub fn BirdLikeGame::score(self : BirdLikeGame) -> Int {
  self.score
}

///|
pub fn BirdLikeGame::is_over(self : BirdLikeGame) -> Bool {
  self.is_over
}

///|
pub impl Game for BirdLikeGame with init(self, ctx) {
  reset_bird_like(self, ctx.config)
}

///|
pub impl Game for BirdLikeGame with update(self, ctx) {
  if ctx.input.reset {
    return reset_bird_like(self, ctx.config)
  }

  if self.is_over {
    return self
  }

  if ctx.input.flap {
    self.bird_vy = -3
  }

  self.bird_vy = clamp(self.bird_vy + 1, -4, 3)
  self.bird_y += self.bird_vy

  self.pipe_x -= 1
  if self.pipe_x + self.pipe_width < 0 {
    self.pipe_x = ctx.config.width + 6
    self.score += 1
    self.pipe_gap_y = next_gap_y(self.tick + 97, ctx.config, self.gap_height)
  }

  self.terrain_offset = (self.terrain_offset + 1) % ctx.config.width
  self.tick += 1

  if is_collision(self, ctx.config) {
    self.is_over = true
  }

  self
}

///|
pub impl Game for BirdLikeGame with draw(self, ctx) {
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
          frame.set_pixel(x, 1, 1)
        }
        if (x + self.terrain_offset) % 11 == 0 {
          frame.set_pixel(x, 3, 1)
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
    None => frame.draw_rect(0, ground_y, ctx.config.width, ground_rows, 3)
  }

  frame.draw_rect(self.pipe_x, 0, self.pipe_width, self.pipe_gap_y, 2)
  let bottom_y = self.pipe_gap_y + self.gap_height
  let bottom_h = ground_y - bottom_y
  if bottom_h > 0 {
    frame.draw_rect(self.pipe_x, bottom_y, self.pipe_width, bottom_h, 2)
  }

  let sprite = match find_sprite(self.bundle, "bird") {
    Some(found) => found
    None => default_bird_sprite()
  }
  frame.blit(sprite, self.bird_x, self.bird_y)

  if self.is_over {
    frame.draw_rect(0, 0, ctx.config.width, 1, 4)
  }

  frame
}

///|
pub fn scripted_demo_inputs(frame_count : Int) -> Array[InputState] {
  let inputs : Array[InputState] = []
  for i in 0..<frame_count {
    let flap = i % 8 == 0 || i % 13 == 0
    inputs.push(InputState::{ flap, reset: false })
  }
  inputs
}

///|
pub fn run_bird_like(
  inputs : Array[InputState],
  config? : EngineConfig = default_engine_config(),
) -> (BirdLikeGame, Array[Frame]) {
  let bundle = load_sample_assets()
  let initial = new_bird_like_game(bundle)
  run_fixed_frames(initial, config, inputs)
}

///|
pub fn run_bird_like_demo(frame_count : Int) -> (BirdLikeGame, Array[String]) {
  let inputs = scripted_demo_inputs(frame_count)
  let (state, frames) = run_bird_like(inputs)
  let ascii_frames = frames.map(frame => frame.to_ascii())
  (state, ascii_frames)
}
