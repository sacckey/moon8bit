///|
pub type PlatformerRuntime = @engine.EngineInstance[PlatformerGame]

///|
let screen_w = 256

///|
let screen_h = 144

///|
let player_w = 8

///|
let player_h = 8

///|
let move_speed = 2

///|
let jump_speed = -7

///|
let gravity = 1

///|
let max_fall_speed = 7

///|
let goal_tile_id = 4

///|
pub struct PlatformerGame {
  bundle : @model.AssetBundle
  mut player_x : Int
  mut player_y : Int
  mut vel_x : Int
  mut vel_y : Int
  mut on_ground : Bool
  mut camera : @model.Camera
  mut is_over : Bool
  mut is_clear : Bool
} derive(Eq, Show)

///|
fn abs_i(value : Int) -> Int {
  if value < 0 {
    -value
  } else {
    value
  }
}

///|
fn stage_tilemap(game : PlatformerGame) -> @model.Tilemap? {
  @model.find_tilemap(game.bundle, "stage")
}

///|
fn map_width_px(game : PlatformerGame) -> Int {
  match stage_tilemap(game) {
    Some(tm) => tm.width * 8
    None => screen_w
  }
}

///|
fn map_height_px(game : PlatformerGame) -> Int {
  match stage_tilemap(game) {
    Some(tm) => tm.height * 8
    None => screen_h
  }
}

///|
fn player_hits_solid(game : PlatformerGame, x : Int, y : Int) -> Bool {
  match stage_tilemap(game) {
    Some(tm) =>
      @engine.tile_solid_any_in_rect(
        tm,
        game.bundle.tiles,
        x,
        y,
        player_w,
        player_h,
      )
    None => y + player_h >= screen_h - 16
  }
}

///|
fn update_camera(game : PlatformerGame) -> Unit {
  let target_x = game.player_x + player_w / 2
  let target_y = game.player_y + player_h / 2
  game.camera = @engine.camera_follow(
    target_x,
    target_y,
    screen_w,
    screen_h,
    map_width_px(game),
    map_height_px(game),
  )
}

///|
fn reset_game(game : PlatformerGame) -> PlatformerGame {
  game.player_x = 16
  game.player_y = screen_h - 40
  game.vel_x = 0
  game.vel_y = 0
  game.on_ground = false
  game.camera = @engine.camera(0, 0)
  game.is_over = false
  game.is_clear = false
  update_camera(game)
  game
}

///|
fn step_horizontal(game : PlatformerGame) -> Unit {
  if game.vel_x == 0 {
    return
  }
  let step = if game.vel_x > 0 { 1 } else { -1 }
  for _ in 0..<abs_i(game.vel_x) {
    let next_x = game.player_x + step
    if player_hits_solid(game, next_x, game.player_y) {
      game.vel_x = 0
      break
    }
    game.player_x = next_x
  }
  let max_x = map_width_px(game) - player_w
  game.player_x = @engine.clamp(game.player_x, 0, max_x)
}

///|
fn step_vertical(game : PlatformerGame) -> Unit {
  if game.vel_y == 0 {
    game.on_ground = player_hits_solid(game, game.player_x, game.player_y + 1)
    return
  }
  game.on_ground = false
  let step = if game.vel_y > 0 { 1 } else { -1 }
  for _ in 0..<abs_i(game.vel_y) {
    let next_y = game.player_y + step
    if player_hits_solid(game, game.player_x, next_y) {
      if step > 0 {
        game.on_ground = true
      }
      game.vel_y = 0
      break
    }
    game.player_y = next_y
  }
}

///|
fn check_goal(game : PlatformerGame, ctx : @engine.UpdateContext) -> Unit {
  if game.is_clear {
    return
  }
  match stage_tilemap(game) {
    Some(tm) => {
      let center_x = game.player_x + player_w / 2
      let center_y = game.player_y + player_h / 2
      match @engine.tile_id_at_px(tm, center_x, center_y) {
        Some(tile_id) if tile_id == goal_tile_id => {
          game.is_clear = true
          ctx.sfx("goal")
          ctx.bgm_stop()
        }
        _ => ()
      }
    }
    None => ()
  }
}

///|
fn apply_gameplay_input(
  game : PlatformerGame,
  ctx : @engine.UpdateContext,
) -> Unit {
  let left = @engine.key_down_any(ctx.input, ["ArrowLeft", "KeyA"])
  let right = @engine.key_down_any(ctx.input, ["ArrowRight", "KeyD"])
  game.vel_x = if left == right {
    0
  } else if left {
    -move_speed
  } else {
    move_speed
  }

  let jump_pressed = @engine.key_pressed_any(ctx.input, [
    "Space", "ArrowUp", "KeyW",
  ])
  if jump_pressed && game.on_ground {
    game.vel_y = jump_speed
    game.on_ground = false
    ctx.sfx("jump")
  }
}

///|
pub fn new_platformer_game(bundle : @model.AssetBundle) -> PlatformerGame {
  reset_game(PlatformerGame::{
    bundle,
    player_x: 0,
    player_y: 0,
    vel_x: 0,
    vel_y: 0,
    on_ground: false,
    camera: @engine.camera(0, 0),
    is_over: false,
    is_clear: false,
  })
}

///|
pub impl @engine.Game for PlatformerGame with init(self, _config) {
  let game = reset_game(self)
  game
}

///|
pub impl @engine.Game for PlatformerGame with update(self, ctx) {
  if ctx.tick == 0 {
    ctx.bgm_start()
  }

  let reset_pressed = @engine.key_pressed_any(ctx.input, ["KeyR", "Space"])
  if reset_pressed && (self.is_over || self.is_clear) {
    let game = reset_game(self)
    ctx.bgm_start()
    return game
  }

  if self.is_over || self.is_clear {
    return self
  }

  apply_gameplay_input(self, ctx)

  if self.vel_y < max_fall_speed {
    self.vel_y += gravity
  }
  step_horizontal(self)
  step_vertical(self)

  if self.player_y > map_height_px(self) + 16 {
    self.is_over = true
    ctx.sfx("hit")
    ctx.bgm_stop()
  }

  check_goal(self, ctx)
  update_camera(self)
  self
}

///|
pub impl @engine.Game for PlatformerGame with draw(self, _ctx) {
  let frame = @model.Frame::new(screen_w, screen_h, fill=1)

  match stage_tilemap(self) {
    Some(tm) =>
      @engine.draw_tilemap_world(
        frame,
        tm,
        self.bundle.tiles,
        0,
        0,
        screen_w,
        screen_h,
        self.camera,
      )
    None => frame.draw_rect(0, screen_h - 16, screen_w, 16, 0)
  }

  match @model.find_sprite(self.bundle, "player") {
    Some(player) =>
      @engine.spr_world(
        frame,
        player,
        self.player_x,
        self.player_y,
        self.camera,
      )
    None =>
      @engine.rect_world(
        frame,
        self.player_x,
        self.player_y,
        player_w,
        player_h,
        3,
        self.camera,
      )
  }

  frame.draw_rect(0, 0, screen_w, 9, 0)
  let status = if self.is_clear {
    "CLEAR R/SPACE"
  } else if self.is_over {
    "MISS R/SPACE"
  } else {
    "A/D move SPACE jump"
  }
  @engine.ui_text(frame, 1, 1, status, 6)

  frame
}

///|
pub fn init_game(
  bundle : @model.AssetBundle,
  config : @model.EngineConfig,
) -> PlatformerRuntime {
  @engine.engine_init(new_platformer_game(bundle), config)
}

///|
pub fn step_game(
  game : PlatformerRuntime,
  input : @model.InputState,
) -> (PlatformerRuntime, @model.Frame) {
  @engine.engine_step(game, input)
}
