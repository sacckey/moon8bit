///|
pub(all) struct EngineConfig {
  width : Int
  height : Int
  fps : Int
  scale : Int
  palette : Palette
} derive(Eq, Show)

///|
pub(all) struct InputState {
  keys_down : Array[String]
  keys_pressed : Array[String]
  keys_released : Array[String]
  pointer_x : Int
  pointer_y : Int
  pointer_down : Bool
  pointer_pressed : Bool
  pointer_released : Bool
} derive(Eq, Show)

///|
pub let input_none : InputState = InputState::{
  keys_down: [],
  keys_pressed: [],
  keys_released: [],
  pointer_x: 0,
  pointer_y: 0,
  pointer_down: false,
  pointer_pressed: false,
  pointer_released: false,
}

///|
pub fn input_state(
  keys_down : Array[String],
  keys_pressed : Array[String],
  keys_released : Array[String],
  pointer_x? : Int = 0,
  pointer_y? : Int = 0,
  pointer_down? : Bool = false,
  pointer_pressed? : Bool = false,
  pointer_released? : Bool = false,
) -> InputState {
  InputState::{
    keys_down,
    keys_pressed,
    keys_released,
    pointer_x,
    pointer_y,
    pointer_down,
    pointer_pressed,
    pointer_released,
  }
}

///|
fn has_key(keys : Array[String], key : String) -> Bool {
  for current in keys {
    if current == key {
      return true
    }
  }
  false
}

///|
pub fn key_down(input : InputState, key : String) -> Bool {
  has_key(input.keys_down, key)
}

///|
pub fn key_pressed(input : InputState, key : String) -> Bool {
  has_key(input.keys_pressed, key)
}

///|
pub fn key_released(input : InputState, key : String) -> Bool {
  has_key(input.keys_released, key)
}

///|
fn any_key(keys : Array[String], candidates : Array[String]) -> Bool {
  for key in candidates {
    if has_key(keys, key) {
      return true
    }
  }
  false
}

///|
pub fn key_down_any(input : InputState, candidates : Array[String]) -> Bool {
  any_key(input.keys_down, candidates)
}

///|
pub fn key_pressed_any(input : InputState, candidates : Array[String]) -> Bool {
  any_key(input.keys_pressed, candidates)
}

///|
pub fn key_released_any(input : InputState, candidates : Array[String]) -> Bool {
  any_key(input.keys_released, candidates)
}

///|
pub(all) struct RuntimeContext {
  config : EngineConfig
  input : InputState
  frame : Int
  dt_ms : Int
} derive(Eq, Show)

///|
pub(all) struct Rect {
  x : Int
  y : Int
  w : Int
  h : Int
} derive(Eq, Show)

///|
pub(all) struct Collider {
  tag : String
  rect : Rect
} derive(Eq, Show)

///|
pub fn default_engine_config() -> EngineConfig {
  EngineConfig::{
    width: 256,
    height: 144,
    fps: 60,
    scale: 4,
    palette: palette_default(),
  }
}

///|
pub fn rect_intersects(a : Rect, b : Rect) -> Bool {
  let a_right = a.x + a.w
  let a_bottom = a.y + a.h
  let b_right = b.x + b.w
  let b_bottom = b.y + b.h

  a.x < b_right && a_right > b.x && a.y < b_bottom && a_bottom > b.y
}

///|
pub fn collider(tag : String, rect : Rect) -> Collider {
  Collider::{ tag, rect }
}

///|
pub fn collider_box(
  tag : String,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
) -> Collider {
  collider(tag, Rect::{ x, y, w, h })
}

///|
pub fn collider_intersects(a : Collider, b : Collider) -> Bool {
  if a.rect.w <= 0 || a.rect.h <= 0 || b.rect.w <= 0 || b.rect.h <= 0 {
    false
  } else {
    rect_intersects(a.rect, b.rect)
  }
}

///|
pub fn collider_hits_any(target : Collider, others : Array[Collider]) -> Bool {
  for other in others {
    if collider_intersects(target, other) {
      return true
    }
  }
  false
}

///|
pub fn collider_first_hit(
  target : Collider,
  others : Array[Collider],
) -> Collider? {
  for other in others {
    if collider_intersects(target, other) {
      return Some(other)
    }
  }
  None
}
