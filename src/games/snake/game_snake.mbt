///|
let grid_w = 16

///|
let grid_h = 16

///|
let cell = 8

///|
let play_min_y = 1

///|
let screen_w : Int = grid_w * cell

///|
let screen_h : Int = grid_h * cell

///|
let move_interval = 8 // frames per step

///|
enum Dir {
  Up
  Down
  Left
  Right
} derive(Eq, Show)

///|
struct Pos {
  x : Int
  y : Int
} derive(Eq, Show)

///|
pub struct SnakeGame {
  mut body : Array[Pos]
  mut dir : Dir
  mut next_dir : Dir
  mut food : Pos
  mut score : Int
  mut timer : Int
  mut is_over : Bool
  mut seed : Int
} derive(Eq, Show)

///|
fn spawn_food(seed : Int, body : Array[Pos]) -> (Pos, Int) {
  let next_seed = seed * 1664525 + 1013904223
  let candidates : Array[Pos] = []
  for y in play_min_y..<grid_h {
    for x in 0..<grid_w {
      let p = Pos::{ x, y }
      let occupied = body.iter().any(fn(b) { b.x == p.x && b.y == p.y })
      if !occupied {
        candidates.push(p)
      }
    }
  }
  if candidates.is_empty() {
    (Pos::{ x: 0, y: play_min_y }, next_seed)
  } else {
    (candidates[@engine.rand(next_seed, 0, candidates.length())], next_seed)
  }
}

///|
fn wrap_y(y : Int) -> Int {
  if y < play_min_y {
    grid_h - 1
  } else if y >= grid_h {
    play_min_y
  } else {
    y
  }
}

///|
pub fn new_snake_game() -> SnakeGame {
  let body = [Pos::{ x: 8, y: 8 }, Pos::{ x: 7, y: 8 }, Pos::{ x: 6, y: 8 }]
  let seed = 12345
  let (food, next_seed) = spawn_food(seed, body)
  SnakeGame::{
    body,
    dir: Right,
    next_dir: Right,
    food,
    score: 0,
    timer: 0,
    is_over: false,
    seed: next_seed,
  }
}

///|
pub impl @engine.Game for SnakeGame with init(_self, _config) {
  new_snake_game()
}

///|
pub impl @engine.Game for SnakeGame with update(self, ctx) {
  if self.is_over {
    if @engine.key_pressed(ctx.input, "Space") {
      return new_snake_game()
    }
    return self
  }

  // direction input — ignore 180° reversal
  let d = if @engine.key_pressed_any(ctx.input, ["ArrowUp", "KeyW"]) &&
    self.dir != Down {
    Up
  } else if @engine.key_pressed_any(ctx.input, ["ArrowDown", "KeyS"]) &&
    self.dir != Up {
    Down
  } else if @engine.key_pressed_any(ctx.input, ["ArrowLeft", "KeyA"]) &&
    self.dir != Right {
    Left
  } else if @engine.key_pressed_any(ctx.input, ["ArrowRight", "KeyD"]) &&
    self.dir != Left {
    Right
  } else {
    self.next_dir
  }
  self.next_dir = d

  self.timer += 1
  if self.timer < move_interval {
    return self
  }
  self.timer = 0
  self.dir = self.next_dir

  // advance head
  let head = self.body[0]
  let new_head = match self.dir {
    Up => Pos::{ x: head.x, y: wrap_y(head.y - 1) }
    Down => Pos::{ x: head.x, y: wrap_y(head.y + 1) }
    Left => Pos::{ x: (head.x - 1 + grid_w) % grid_w, y: head.y }
    Right => Pos::{ x: (head.x + 1) % grid_w, y: head.y }
  }

  // self collision
  let hit = self.body
    .iter()
    .any(fn(b) { b.x == new_head.x && b.y == new_head.y })
  if hit {
    ctx.sfx("die")
    self.is_over = true
    return self
  }

  // eat food
  let ate = new_head.x == self.food.x && new_head.y == self.food.y
  self.body = self.body.copy()
  self.body.insert(0, new_head)
  if ate {
    self.score += 1
    ctx.sfx("eat")
    let (next_food, next_seed) = spawn_food(self.seed, self.body)
    self.food = next_food
    self.seed = next_seed
  } else {
    let _ = self.body.pop()
  }

  self
}

///|
pub impl @engine.Game for SnakeGame with draw(self, _ctx) {
  let frame = @model.Frame::new(screen_w, screen_h, fill=0)

  // grid
  for y in 0..<grid_h {
    for x in 0..<grid_w {
      let c = if (x + y) % 2 == 0 { 0 } else { 1 }
      frame.draw_rect(x * cell, y * cell, cell, cell, c)
    }
  }

  // food
  frame.draw_rect(
    self.food.x * cell + 1,
    self.food.y * cell + 1,
    cell - 2,
    cell - 2,
    5,
  )

  // snake
  for i, seg in self.body {
    let c = if i == 0 { 3 } else { 2 }
    frame.draw_rect(seg.x * cell + 1, seg.y * cell + 1, cell - 2, cell - 2, c)
  }

  // HUD
  frame.draw_rect(0, 0, screen_w, 9, 0)
  @engine.ui_text(frame, 1, 1, "S\{self.score}", 6)

  // game over overlay
  if self.is_over {
    let pw = 56
    let ph = 19
    let px = @engine.ui_center_x(screen_w, pw)
    let py = @engine.ui_center_y(screen_h, ph)
    @engine.ui_panel(frame, px, py, pw, ph, 4, border=0)
    @engine.ui_text(frame, px + 2, py + 2, "GAME OVER", 6)
    @engine.ui_text(frame, px + 2, py + 11, "SPACE:retry", 6)
  }

  frame
}

///|
pub fn init_game(
  _bundle : @model.AssetBundle,
  config : @model.EngineConfig,
) -> @engine.EngineInstance[SnakeGame] {
  @engine.engine_init(new_snake_game(), config)
}

///|
pub fn step_game(
  game : @engine.EngineInstance[SnakeGame],
  input : @model.InputState,
) -> (@engine.EngineInstance[SnakeGame], @model.Frame) {
  @engine.engine_step(game, input)
}
