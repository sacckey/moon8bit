///|
pub fn config(
  width : Int,
  height : Int,
  fps? : Int = 60,
  scale? : Int = 4,
  palette? : @model.Palette = @model.palette_default(),
) -> EngineConfig {
  EngineConfig::{ width, height, fps, scale, palette }
}

///|
pub fn btn(
  keys_down : Array[String],
  keys_pressed? : Array[String] = [],
  keys_released? : Array[String] = [],
  pointer_x? : Int = 0,
  pointer_y? : Int = 0,
  pointer_down? : Bool = false,
  pointer_pressed? : Bool = false,
  pointer_released? : Bool = false,
) -> InputState {
  @model.input_state(
    keys_down,
    keys_pressed,
    keys_released,
    pointer_x~,
    pointer_y~,
    pointer_down~,
    pointer_pressed~,
    pointer_released~,
  )
}

///|
pub fn btnp(current : Bool, previous : Bool) -> Bool {
  current && !previous
}

///|
pub fn key_down(input : InputState, key : String) -> Bool {
  @model.key_down(input, key)
}

///|
pub fn key_pressed(input : InputState, key : String) -> Bool {
  @model.key_pressed(input, key)
}

///|
pub fn key_released(input : InputState, key : String) -> Bool {
  @model.key_released(input, key)
}

///|
pub fn key_down_any(input : InputState, keys : Array[String]) -> Bool {
  @model.key_down_any(input, keys)
}

///|
pub fn key_pressed_any(input : InputState, keys : Array[String]) -> Bool {
  @model.key_pressed_any(input, keys)
}

///|
pub fn key_released_any(input : InputState, keys : Array[String]) -> Bool {
  @model.key_released_any(input, keys)
}

///|
pub fn every(frame : Int, interval : Int) -> Bool {
  interval > 0 && frame % interval == 0
}

///|
pub fn aabb(
  x1 : Int,
  y1 : Int,
  w1 : Int,
  h1 : Int,
  x2 : Int,
  y2 : Int,
  w2 : Int,
  h2 : Int,
) -> Bool {
  @model.rect_intersects(@model.Rect::{ x: x1, y: y1, w: w1, h: h1 }, @model.Rect::{
    x: x2,
    y: y2,
    w: w2,
    h: h2,
  })
}

///|
pub fn aabb_hit_tag(
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  obstacles : Array[@model.Collider],
) -> String? {
  let target = @model.collider_box("_target", x, y, w, h)
  match @model.collider_first_hit(target, obstacles) {
    Some(hit) => Some(hit.tag)
    None => None
  }
}

///|
pub fn ui_center_x(total_width : Int, item_width : Int) -> Int {
  if total_width <= item_width {
    0
  } else {
    (total_width - item_width) / 2
  }
}

///|
pub fn ui_center_y(total_height : Int, item_height : Int) -> Int {
  if total_height <= item_height {
    0
  } else {
    (total_height - item_height) / 2
  }
}

///|
pub fn ui_panel(
  frame : Frame,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  fill : Int,
  border? : Int = -1,
) -> Unit {
  if w <= 0 || h <= 0 {
    return
  }
  frame.draw_rect(x, y, w, h, fill)
  if border >= 0 && w > 2 && h > 2 {
    frame.draw_rect(x, y, w, 1, border)
    frame.draw_rect(x, y + h - 1, w, 1, border)
    frame.draw_rect(x, y, 1, h, border)
    frame.draw_rect(x + w - 1, y, 1, h, border)
  }
}

///|
pub fn ui_text_width(text : String, scale? : Int = 1) -> Int {
  @font.text_width(text, scale~)
}

///|
pub fn ui_text(
  frame : Frame,
  x : Int,
  y : Int,
  text : String,
  color : Int,
  scale? : Int = 1,
) -> Unit {
  @font.draw_text(frame, x, y, text, color, scale~)
}

///|
pub fn[T : Game] step(
  state : EngineInstance[T],
  input : InputState,
) -> (EngineInstance[T], Frame) {
  engine_step(state, input)
}

///|
pub fn[T : Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (EngineInstance[T], Array[Frame]) {
  run_fixed_frames(game, config, inputs)
}

///|
pub fn[T] game_state(state : EngineInstance[T]) -> T {
  engine_game(state)
}

///|
pub fn[T] with_game(state : EngineInstance[T], game : T) -> EngineInstance[T] {
  engine_with_game(state, game)
}

///|
pub fn[T] events(state : EngineInstance[T]) -> Array[EngineEvent] {
  engine_events(state)
}

///|
pub fn[T] take_events(
  state : EngineInstance[T],
) -> (EngineInstance[T], Array[EngineEvent]) {
  engine_take_events(state)
}

///|
pub fn cls(frame : Frame, color : Int) -> Unit {
  frame.clear(color)
}

///|
pub fn pset(frame : Frame, x : Int, y : Int, color : Int) -> Unit {
  frame.set_pixel(x, y, color)
}

///|
pub fn rect(
  frame : Frame,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  color : Int,
) -> Unit {
  frame.draw_rect(x, y, w, h, color)
}

///|
pub fn spr(frame : Frame, sprite : @model.Sprite, x : Int, y : Int) -> Unit {
  frame.blit(sprite, x, y)
}
