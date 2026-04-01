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
