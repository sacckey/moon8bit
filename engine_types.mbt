///|
pub struct EngineConfig {
  width : Int
  height : Int
  fps : Int
  scale : Int
  palette : Palette
} derive(Eq, Show)

///|
pub struct InputState {
  flap : Bool
  reset : Bool
} derive(Eq, Show)

///|
pub let input_none : InputState = InputState::{ flap: false, reset: false }

///|
pub fn input_state(flap : Bool, reset : Bool) -> InputState {
  InputState::{ flap, reset }
}

///|
pub struct RuntimeContext {
  config : EngineConfig
  input : InputState
  frame : Int
  dt_ms : Int
} derive(Eq, Show)

///|
pub struct Rect {
  x : Int
  y : Int
  w : Int
  h : Int
} derive(Eq, Show)

///|
pub fn default_engine_config() -> EngineConfig {
  EngineConfig::{
    width: 64,
    height: 48,
    fps: 30,
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
