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
let enemy_sprite_name = "enemy"

///|
struct EnemyActor {
  name : String
  x : Int
  y : Int
  dir : Int
} derive(Eq, Show)

///|
pub struct PlatformerGame {
  bundle : @model.AssetBundle
  mut player_x : Int
  mut player_y : Int
  mut vel_x : Int
  mut vel_y : Int
  mut on_ground : Bool
  mut enemies : Array[EnemyActor]
  mut camera : @model.Camera
  mut is_over : Bool
  mut is_clear : Bool
} derive(Eq, Show)

///|
fn stage_tilemap(game : PlatformerGame) -> @model.Tilemap {
  match @model.find_tilemap(game.bundle, "stage") {
    Some(tm) => tm
    None => panic()
  }
}

///|
fn enemy_sprite(game : PlatformerGame) -> @model.Sprite? {
  @model.find_sprite(game.bundle, enemy_sprite_name)
}

///|
fn enemy_placements(game : PlatformerGame) -> Array[@model.Placement] {
  @model.find_placements_by_sprite(game.bundle, enemy_sprite_name)
}

///|
fn enemy_size(game : PlatformerGame) -> (Int, Int) {
  match enemy_sprite(game) {
    Some(sp) => (sp.width, sp.height)
    None => (8, 8)
  }
}

///|
fn map_width_px(game : PlatformerGame) -> Int {
  stage_tilemap(game).width * 8
}

///|
fn map_height_px(game : PlatformerGame) -> Int {
  stage_tilemap(game).height * 8
}

///|
fn player_hits_solid(game : PlatformerGame, x : Int, y : Int) -> Bool {
  @engine.tile_solid_any_in_rect(
    stage_tilemap(game),
    game.bundle.tiles,
    x,
    y,
    player_w,
    player_h,
  )
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
fn clamp_enemy_x_range(game : PlatformerGame, x : Int, enemy_w : Int) -> Int {
  @engine.clamp(x, 0, map_width_px(game) - enemy_w)
}

///|
fn spawn_enemies(game : PlatformerGame) -> Array[EnemyActor] {
  let actors : Array[EnemyActor] = []
  let (enemy_w, _) = enemy_size(game)
  let mut idx = 0
  for placement in enemy_placements(game) {
    let cx = clamp_enemy_x_range(game, placement.x, enemy_w)
    let dir = if idx % 2 == 0 { 1 } else { -1 }
    actors.push(EnemyActor::{ name: placement.name, x: cx, y: placement.y, dir })
    idx += 1
  }
  actors
}

///|
fn enemy_hits_solid(
  game : PlatformerGame,
  x : Int,
  y : Int,
  enemy_w : Int,
  enemy_h : Int,
) -> Bool {
  @engine.tile_solid_any_in_rect(
    stage_tilemap(game),
    game.bundle.tiles,
    x,
    y,
    enemy_w,
    enemy_h,
  )
}

///|
fn enemy_blocked_at(
  game : PlatformerGame,
  x : Int,
  y : Int,
  enemy_w : Int,
  enemy_h : Int,
) -> Bool {
  if x < 0 || x + enemy_w > map_width_px(game) {
    return true
  }
  if y < 0 || y + enemy_h > map_height_px(game) {
    return true
  }
  enemy_hits_solid(game, x, y, enemy_w, enemy_h)
}

///|
fn step_enemies(game : PlatformerGame) -> Unit {
  if game.enemies.length() == 0 {
    return
  }
  let (enemy_w, enemy_h) = enemy_size(game)
  let next_enemies : Array[EnemyActor] = []
  for enemy in game.enemies {
    let mut dir = if enemy.dir == 0 { 1 } else { enemy.dir }
    let mut next_x = enemy.x + dir

    if enemy_blocked_at(game, next_x, enemy.y, enemy_w, enemy_h) {
      dir = -dir
      let fallback_x = enemy.x + dir
      if enemy_blocked_at(game, fallback_x, enemy.y, enemy_w, enemy_h) {
        next_x = enemy.x
      } else {
        next_x = fallback_x
      }
    }

    next_enemies.push(EnemyActor::{
      name: enemy.name,
      x: next_x,
      y: enemy.y,
      dir,
    })
  }
  game.enemies = next_enemies
}

///|
fn reset_game(game : PlatformerGame) -> PlatformerGame {
  game.player_x = 16
  game.player_y = screen_h - 40
  game.vel_x = 0
  game.vel_y = 0
  game.on_ground = false
  game.enemies = spawn_enemies(game)
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
  let (next_x, blocked) = @engine.swept_move_x(
    stage_tilemap(game),
    game.bundle.tiles,
    game.player_x,
    game.player_y,
    player_w,
    player_h,
    game.vel_x,
  )
  game.player_x = next_x
  if blocked {
    game.vel_x = 0
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
  let (next_y, blocked) = @engine.swept_move_y(
    stage_tilemap(game),
    game.bundle.tiles,
    game.player_x,
    game.player_y,
    player_w,
    player_h,
    game.vel_y,
  )
  game.player_y = next_y
  if blocked {
    if game.vel_y > 0 {
      game.on_ground = true
    }
    game.vel_y = 0
  }
}

///|
fn check_goal(game : PlatformerGame, ctx : @engine.UpdateContext) -> Unit {
  if game.is_clear {
    return
  }
  if @engine.tile_id_any_in_rect(
      stage_tilemap(game),
      game.player_x,
      game.player_y,
      player_w,
      player_h,
      goal_tile_id,
    ) {
    game.is_clear = true
    ctx.sfx("goal")
    ctx.bgm_stop()
  }
}

///|
fn check_enemy_hit(game : PlatformerGame, ctx : @engine.UpdateContext) -> Unit {
  if game.is_over || game.is_clear {
    return
  }
  let enemy = match enemy_sprite(game) {
    Some(v) => v
    None => return
  }
  let player_rect = @model.Rect::{
    x: game.player_x,
    y: game.player_y,
    w: player_w,
    h: player_h,
  }
  for enemy_actor in game.enemies {
    let enemy_rect = @model.Rect::{
      x: enemy_actor.x,
      y: enemy_actor.y,
      w: enemy.width,
      h: enemy.height,
    }
    if @model.rect_intersects(player_rect, enemy_rect) {
      game.is_over = true
      ctx.sfx("hit")
      ctx.bgm_stop()
      return
    }
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
  let game = reset_game(PlatformerGame::{
    bundle,
    player_x: 0,
    player_y: 0,
    vel_x: 0,
    vel_y: 0,
    on_ground: false,
    enemies: [],
    camera: @engine.camera(0, 0),
    is_over: false,
    is_clear: false,
  })
  ignore(stage_tilemap(game))
  game
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
  step_enemies(self)
  check_enemy_hit(self, ctx)

  if self.is_over {
    return self
  }

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

  @engine.draw_tilemap_world(
    frame,
    stage_tilemap(self),
    self.bundle.tiles,
    0,
    0,
    screen_w,
    screen_h,
    self.camera,
  )

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

  match enemy_sprite(self) {
    Some(enemy) =>
      for enemy_actor in self.enemies {
        @engine.spr_world(
          frame,
          enemy,
          enemy_actor.x,
          enemy_actor.y,
          self.camera,
        )
      }
    None => ()
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
