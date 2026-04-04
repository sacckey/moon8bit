///|
pub fn config(
  width : Int,
  height : Int,
  fps? : Int = 30,
  scale? : Int = 4,
  palette? : @model.Palette = @model.palette_default(),
) -> EngineConfig {
  EngineConfig::{ width, height, fps, scale, palette }
}

///|
pub fn btn(flap : Bool, reset : Bool) -> InputState {
  @model.input_state(flap, reset)
}

///|
pub fn btnp(current : Bool, previous : Bool) -> Bool {
  current && !previous
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
pub fn[T : Game] step(
  game : T,
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> (T, Frame) {
  engine_step(game, config, input, frame)
}

///|
pub fn[T : Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (T, Array[Frame]) {
  run_fixed_frames(game, config, inputs)
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
