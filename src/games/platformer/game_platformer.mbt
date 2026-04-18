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
let move_speed = 1

///|
let jump_speed = -6

///|
let gravity = 1

///|
let max_fall_speed = 5

///|
let goal_tile_id = 4

///|
let gravity_step_interval = 2

///|
let gravity_step_interval_fall = 1

///|
let coyote_frames = 6

///|
let jump_buffer_frames = 6

///|
let jump_cut_velocity = -2

///|
let enemy_sprite_name = "enemy"

///|
let player_sprite_name = "player"

///|
let coin_sprite_name = "coin"

///|
let default_player_spawn_x : Int = 16

///|
let default_player_spawn_y : Int = screen_h - 40

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
  mut coins : Array[@model.Placement]
  mut coins_collected : Int
  mut camera : @model.Camera
  mut coyote_timer : Int
  mut jump_buffer_timer : Int
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
fn coin_placements(game : PlatformerGame) -> Array[@model.Placement] {
  @model.find_placements_by_sprite(game.bundle, coin_sprite_name)
}

///|
fn player_placements(game : PlatformerGame) -> Array[@model.Placement] {
  @model.find_placements_by_sprite(game.bundle, player_sprite_name)
}

///|
fn enemy_size(game : PlatformerGame) -> (Int, Int) {
  match enemy_sprite(game) {
    Some(sp) => (sp.width, sp.height)
    None => (8, 8)
  }
}

///|
fn coin_sprite(game : PlatformerGame) -> @model.Sprite? {
  @model.find_sprite(game.bundle, coin_sprite_name)
}

///|
fn coin_size(game : PlatformerGame) -> (Int, Int) {
  match coin_sprite(game) {
    Some(sp) => (sp.width, sp.height)
    None => (8, 8)
  }
}

///|
fn initial_player_spawn(game : PlatformerGame) -> (Int, Int) {
  let placements = player_placements(game)
  if placements.length() == 1 {
    let spawn = placements[0]
    let max_x = map_width_px(game) - player_w
    let max_y = map_height_px(game) - player_h
    (@engine.clamp(spawn.x, 0, max_x), @engine.clamp(spawn.y, 0, max_y))
  } else {
    (default_player_spawn_x, default_player_spawn_y)
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
fn spawn_coins(game : PlatformerGame) -> Array[@model.Placement] {
  let coins : Array[@model.Placement] = []
  let (coin_w, coin_h) = coin_size(game)
  let max_x = map_width_px(game) - coin_w
  let max_y = map_height_px(game) - coin_h
  for placement in coin_placements(game) {
    coins.push(@model.Placement::{
      name: placement.name,
      sprite: placement.sprite,
      x: @engine.clamp(placement.x, 0, max_x),
      y: @engine.clamp(placement.y, 0, max_y),
    })
  }
  coins
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
  let (spawn_x, spawn_y) = initial_player_spawn(game)
  game.player_x = spawn_x
  game.player_y = spawn_y
  game.vel_x = 0
  game.vel_y = 0
  game.on_ground = false
  game.enemies = spawn_enemies(game)
  game.coins = spawn_coins(game)
  game.coins_collected = 0
  game.camera = @engine.camera(0, 0)
  game.coyote_timer = 0
  game.jump_buffer_timer = 0
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
fn check_coin_hit(game : PlatformerGame) -> Unit {
  if game.is_over || game.is_clear || game.coins.length() == 0 {
    return
  }
  let (coin_w, coin_h) = coin_size(game)
  let player_rect = @model.Rect::{
    x: game.player_x,
    y: game.player_y,
    w: player_w,
    h: player_h,
  }
  let remaining : Array[@model.Placement] = []
  let mut gained = 0
  for coin in game.coins {
    let coin_rect = @model.Rect::{ x: coin.x, y: coin.y, w: coin_w, h: coin_h }
    if @model.rect_intersects(player_rect, coin_rect) {
      gained += 1
    } else {
      remaining.push(coin)
    }
  }
  if gained > 0 {
    game.coins_collected += gained
    game.coins = remaining
  }
}

///|
fn update_jump_timers(game : PlatformerGame, input : @model.InputState) -> Unit {
  if game.on_ground {
    game.coyote_timer = coyote_frames
  } else if game.coyote_timer > 0 {
    game.coyote_timer -= 1
  }

  let jump_pressed = @engine.key_pressed_any(input, ["Space", "ArrowUp", "KeyW"])
  if jump_pressed {
    game.jump_buffer_timer = jump_buffer_frames
  } else if game.jump_buffer_timer > 0 {
    game.jump_buffer_timer -= 1
  }
}

///|
fn apply_horizontal_input(
  game : PlatformerGame,
  input : @model.InputState,
) -> Unit {
  let left = @engine.key_down_any(input, ["ArrowLeft", "KeyA"])
  let right = @engine.key_down_any(input, ["ArrowRight", "KeyD"])
  game.vel_x = if left == right {
    0
  } else if left {
    -move_speed
  } else {
    move_speed
  }
}

///|
fn try_start_jump(game : PlatformerGame, ctx : @engine.UpdateContext) -> Unit {
  if game.jump_buffer_timer <= 0 {
    return
  }
  if !game.on_ground && game.coyote_timer <= 0 {
    return
  }

  game.vel_y = jump_speed
  game.on_ground = false
  game.coyote_timer = 0
  game.jump_buffer_timer = 0
  ctx.sfx("jump")
}

///|
fn apply_jump_cut(game : PlatformerGame, input : @model.InputState) -> Unit {
  if game.vel_y >= jump_cut_velocity {
    return
  }
  let jump_held = @engine.key_down_any(input, ["Space", "ArrowUp", "KeyW"])
  if !jump_held {
    game.vel_y = jump_cut_velocity
  }
}

///|
fn apply_gameplay_input(
  game : PlatformerGame,
  ctx : @engine.UpdateContext,
) -> Unit {
  update_jump_timers(game, ctx.input)
  apply_horizontal_input(game, ctx.input)
  try_start_jump(game, ctx)
  apply_jump_cut(game, ctx.input)
}

///|
fn apply_gravity(game : PlatformerGame, tick : Int) -> Unit {
  let gravity_interval = if game.vel_y < 0 {
    gravity_step_interval
  } else {
    gravity_step_interval_fall
  }
  if game.vel_y < max_fall_speed && tick % gravity_interval == 0 {
    game.vel_y += gravity
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
    coins: [],
    coins_collected: 0,
    camera: @engine.camera(0, 0),
    coyote_timer: 0,
    jump_buffer_timer: 0,
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
  apply_gravity(self, ctx.tick)
  step_horizontal(self)
  step_vertical(self)
  step_enemies(self)
  check_enemy_hit(self, ctx)
  check_coin_hit(self)

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

  let (coin_w, coin_h) = coin_size(self)
  match coin_sprite(self) {
    Some(coin_sprite) =>
      for coin in self.coins {
        @engine.spr_world(frame, coin_sprite, coin.x, coin.y, self.camera)
      }
    None =>
      for coin in self.coins {
        @engine.rect_world(
          frame,
          coin.x,
          coin.y,
          coin_w,
          coin_h,
          3,
          self.camera,
        )
      }
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
  let total_coins = self.coins_collected + self.coins.length()
  let coin_text = "COIN \{self.coins_collected}/\{total_coins}"
  @engine.ui_text(
    frame,
    screen_w - @engine.ui_text_width(coin_text) - 1,
    1,
    coin_text,
    3,
  )

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
