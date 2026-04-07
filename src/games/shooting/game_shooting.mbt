///|
let screen_w = 128

///|
let screen_h = 128

///|
let hud_h = 9

///|
let play_y : Int = hud_h

///|
let play_h : Int = screen_h - play_y

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
  mut seed : Int
  mut is_over : Bool
  mut scroll : Int
} derive(Eq, Show)

///|
fn new_shooting_game(bundle : @model.AssetBundle) -> ShootingGame {
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
    seed: 99991,
    is_over: false,
    scroll: 0,
  }
}

///|
fn next_seed(seed : Int) -> Int {
  (seed * 1664525 + 1013904223).land(0x7FFFFFFF)
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

  // scroll background
  self.scroll = (self.scroll + 1) % screen_h

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

  // scrolling star background
  for i in 0..<30 {
    let sx = @engine.rand(i * 7 + 1, 0, screen_w)
    let sy = (@engine.rand(i * 13 + 3, 0, screen_h) + self.scroll) % play_h +
      play_y
    let c = if i % 3 == 0 { 6 } else { 1 }
    frame.set_pixel(sx, sy, c)
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
    let pw = 56
    let ph = 19
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, ph)
    @engine.ui_panel(frame, px, py, pw, ph, 3, border=0)
    @engine.ui_text(frame, px + 2, py + 2, "GAME OVER", 6)
    @engine.ui_text(frame, px + 2, py + 11, "SPACE:retry", 6)
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
