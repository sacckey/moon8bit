///|
let screen_w = 128

///|
let screen_h = 128

///|
let hud_h = 9

///|
let play_y : Int = hud_h

///|
let player_speed = 2

///|
let bullet_speed = 4

///|
let enemy_w = 8

///|
let enemy_h = 8

///|
let player_w = 8

///|
let player_h = 8

///|
let bullet_w = 2

///|
let bullet_h = 4

///|
let shoot_interval = 12

///|
let star_count = 30

///|
struct Bullet {
  x : Int
  mut y : Int
} derive(Eq, Show)

///|
struct Enemy {
  x : Int
  mut y : Int
  mut alive : Bool
} derive(Eq, Show)

///|
struct Star {
  mut x : Int
  mut y : Int
  mut speed : Int
  mut color : Int
} derive(Eq, Show)

///|
pub struct ShootingGame {
  bundle : @model.AssetBundle
  mut player_x : Int
  mut player_y : Int
  mut bullets : Array[Bullet]
  mut enemies : Array[Enemy]
  mut score : Int
  mut lives : Int
  mut shoot_timer : Int
  mut spawn_timer : Int
  stars : Array[Star]
  mut seed : Int
  mut star_seed : Int
  mut is_over : Bool
} derive(Eq, Show)

///|
fn new_shooting_game(bundle : @model.AssetBundle) -> ShootingGame {
  let (stars, star_seed) = init_stars(424242, star_count)
  ShootingGame::{
    bundle,
    player_x: screen_w / 2 - player_w / 2,
    player_y: screen_h - player_h - 12,
    bullets: [],
    enemies: [],
    score: 0,
    lives: 3,
    shoot_timer: 0,
    spawn_timer: 0,
    stars,
    seed: 99991,
    star_seed,
    is_over: false,
  }
}

///|
fn next_seed(seed : Int) -> Int {
  (seed * 1664525 + 1013904223).land(0x7FFFFFFF)
}

///|
fn init_stars(seed : Int, count : Int) -> (Array[Star], Int) {
  let stars : Array[Star] = []
  let mut s = seed
  for _ in 0..<count {
    s = next_seed(s)
    let x = @engine.rand(s, 0, screen_w)
    s = next_seed(s)
    let y = @engine.rand(s, play_y, screen_h)
    s = next_seed(s)
    let speed = if @engine.rand(s, 0, 4) == 0 { 2 } else { 1 }
    let color = if speed == 2 { 6 } else { 1 }
    stars.push(Star::{ x, y, speed, color })
  }
  (stars, s)
}

///|
fn reset_star_to_top(star : Star, seed : Int) -> Int {
  let mut s = next_seed(seed)
  star.x = @engine.rand(s, 0, screen_w)
  s = next_seed(s)
  star.y = play_y + @engine.rand(s, 0, 2)
  s = next_seed(s)
  star.speed = if @engine.rand(s, 0, 4) == 0 { 2 } else { 1 }
  star.color = if star.speed == 2 { 6 } else { 1 }
  s
}

///|
pub impl @engine.Game for ShootingGame with init(self, _config) {
  new_shooting_game(self.bundle)
}

///|
pub impl @engine.Game for ShootingGame with update(self, ctx) {
  if self.is_over {
    if @engine.key_pressed(ctx.input, "Space") {
      return new_shooting_game(self.bundle)
    }
    return self
  }

  // star background
  for star in self.stars {
    star.y += star.speed
    if star.y >= screen_h {
      self.star_seed = reset_star_to_top(star, self.star_seed)
    }
  }

  // player movement
  if @engine.key_down(ctx.input, "ArrowLeft") ||
    @engine.key_down(ctx.input, "KeyA") {
    self.player_x -= player_speed
  }
  if @engine.key_down(ctx.input, "ArrowRight") ||
    @engine.key_down(ctx.input, "KeyD") {
    self.player_x += player_speed
  }
  if @engine.key_down(ctx.input, "ArrowUp") ||
    @engine.key_down(ctx.input, "KeyW") {
    self.player_y -= player_speed
  }
  if @engine.key_down(ctx.input, "ArrowDown") ||
    @engine.key_down(ctx.input, "KeyS") {
    self.player_y += player_speed
  }
  self.player_x = @engine.clamp(self.player_x, 0, screen_w - player_w)
  self.player_y = @engine.clamp(self.player_y, play_y, screen_h - player_h)

  // shoot
  self.shoot_timer -= 1
  if @engine.key_down(ctx.input, "Space") && self.shoot_timer <= 0 {
    self.bullets.push(Bullet::{
      x: self.player_x + player_w / 2 - bullet_w / 2,
      y: self.player_y - bullet_h,
    })
    self.shoot_timer = shoot_interval
    ctx.sfx("shoot")
  }

  // move bullets
  self.bullets = self.bullets.filter(fn(b) { b.y + bullet_h > play_y })
  for b in self.bullets {
    b.y -= bullet_speed
  }

  // spawn enemies
  self.spawn_timer -= 1
  let spawn_rate = if self.score < 5 {
    80
  } else if self.score < 15 {
    60
  } else {
    40
  }
  if self.spawn_timer <= 0 {
    self.seed = next_seed(self.seed)
    let ex = @engine.rand(self.seed, 0, screen_w - enemy_w)
    self.enemies.push(Enemy::{ x: ex, y: play_y - enemy_h, alive: true })
    self.spawn_timer = spawn_rate
  }

  // move enemies
  self.enemies = self.enemies.filter(fn(e) { e.alive && e.y < screen_h })
  for e in self.enemies {
    e.y += 1
  }

  // bullet vs enemy
  for b in self.bullets {
    for e in self.enemies {
      if !e.alive {
        continue
      }
      if b.x + bullet_w > e.x &&
        b.x < e.x + enemy_w &&
        b.y < e.y + enemy_h &&
        b.y + bullet_h > e.y {
        e.alive = false
        b.y = -100
        self.score += 1
        ctx.sfx("hit")
      }
    }
  }

  // enemy vs player
  for e in self.enemies {
    if !e.alive {
      continue
    }
    if e.x + enemy_w > self.player_x &&
      e.x < self.player_x + player_w &&
      e.y + enemy_h > self.player_y &&
      e.y < self.player_y + player_h {
      e.alive = false
      self.lives -= 1
      ctx.sfx("die")
      if self.lives <= 0 {
        self.is_over = true
      }
    }
  }

  self
}

///|
pub impl @engine.Game for ShootingGame with draw(self, _ctx) {
  let frame = @model.Frame::new(screen_w, screen_h, fill=0)

  // star background
  for star in self.stars {
    frame.set_pixel(star.x, star.y, star.color)
  }

  // enemies
  match @model.find_sprite(self.bundle, "enemy") {
    Some(spr) =>
      for e in self.enemies {
        if e.alive {
          frame.blit(spr, e.x, e.y)
        }
      }
    None =>
      for e in self.enemies {
        if e.alive {
          frame.draw_rect(e.x, e.y, enemy_w, enemy_h, 3)
        }
      }
  }

  // bullets
  for b in self.bullets {
    frame.draw_rect(b.x, b.y, bullet_w, bullet_h, 5)
  }

  // player
  match @model.find_sprite(self.bundle, "player") {
    Some(spr) => frame.blit(spr, self.player_x, self.player_y)
    None => frame.draw_rect(self.player_x, self.player_y, player_w, player_h, 4)
  }

  // HUD
  frame.draw_rect(0, 0, screen_w, hud_h, 0)
  @engine.ui_text(frame, 1, 1, "S\{self.score} L\{self.lives}", 6)

  // game over overlay
  if self.is_over {
    let title = "GAME OVER"
    let action = "SPACE:RETRY"
    let tw = @engine.ui_text_width(title)
    let aw = @engine.ui_text_width(action)
    let mw = if tw > aw { tw } else { aw }
    let pw = mw + 4
    let ph = 26
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, ph)
    @engine.ui_panel(frame, px, py, pw, ph, 3, border=0)
    @engine.ui_text(frame, px + @engine.ui_center_x(pw, tw), py + 4, title, 6)
    @engine.ui_text(frame, px + @engine.ui_center_x(pw, aw), py + 14, action, 6)
  }

  frame
}

///|
pub fn init_game(
  bundle : @model.AssetBundle,
  config : @model.EngineConfig,
) -> @engine.EngineInstance[ShootingGame] {
  @engine.engine_init(new_shooting_game(bundle), config)
}

///|
pub fn step_game(
  game : @engine.EngineInstance[ShootingGame],
  input : @model.InputState,
) -> (@engine.EngineInstance[ShootingGame], @model.Frame) {
  @engine.engine_step(game, input)
}
