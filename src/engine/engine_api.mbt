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
pub fn clamp(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
pub fn rand(seed : Int, min : Int, max : Int) -> Int {
  if max <= min {
    return min
  }
  let mixed = seed * 1664525 + 1013904223
  let non_negative = mixed.land(0x7FFFFFFF)
  min + non_negative % (max - min)
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

///|
/// Return the tile ID at pixel position (`px`,`py`) in map space.
/// Returns `None` when out of map bounds.
pub fn tile_id_at_px(tilemap : @model.Tilemap, px : Int, py : Int) -> Int? {
  if px < 0 || py < 0 {
    return None
  }
  let tx = px / 8
  let ty = py / 8
  @model.tile_at(tilemap, tx, ty)
}

///|
/// Return true when pixel position (`px`,`py`) falls on a solid tile.
pub fn tile_solid_at_px(
  tilemap : @model.Tilemap,
  tiles : @model.Tiles,
  px : Int,
  py : Int,
) -> Bool {
  match tile_id_at_px(tilemap, px, py) {
    Some(tile_id) => @model.tile_solid(tiles, tile_id)
    None => false
  }
}

///|
fn floor_div_tile(px : Int) -> Int {
  if px >= 0 {
    px / 8
  } else {
    (px - 7) / 8
  }
}

///|
/// Return true when any pixel inside the rectangle intersects a solid tile.
/// - Rect is expressed in map-space pixels.
/// - Out-of-map area is treated as non-solid.
/// - Empty or negative-size rect returns false.
pub fn tile_solid_any_in_rect(
  tilemap : @model.Tilemap,
  tiles : @model.Tiles,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
) -> Bool {
  if w <= 0 || h <= 0 {
    return false
  }
  let left_tx = floor_div_tile(x)
  let top_ty = floor_div_tile(y)
  let right_tx = floor_div_tile(x + w - 1)
  let bottom_ty = floor_div_tile(y + h - 1)
  for ty in top_ty..<=bottom_ty {
    for tx in left_tx..<=right_tx {
      match @model.tile_at(tilemap, tx, ty) {
        Some(tile_id) if @model.tile_solid(tiles, tile_id) => return true
        _ => ()
      }
    }
  }
  false
}

///|
/// Draw a region of a tilemap onto the frame using inline tile pixel data.
///
/// - `dst_x/dst_y`: top-left corner in the frame where drawing starts
/// - `dst_w/dst_h`: number of pixels to fill (clips at frame edges)
/// - `cam_x/cam_y`: pixel offset into the tilemap (no wrap)
///
/// Tile size is fixed at 8×8.  Tile ID -1 = transparent (skip).
/// Transparent pixels within a tile (value -1) are also skipped.
pub fn draw_tilemap(
  frame : Frame,
  tilemap : @model.Tilemap,
  tiles : @model.Tiles,
  dst_x : Int,
  dst_y : Int,
  dst_w : Int,
  dst_h : Int,
  cam_x : Int,
  cam_y : Int,
) -> Unit {
  if dst_w <= 0 ||
    dst_h <= 0 ||
    tilemap.width <= 0 ||
    tilemap.height <= 0 ||
    tiles.tile_count <= 0 {
    return
  }
  let tile_size = 8
  let map_px_w = tilemap.width * tile_size
  let map_px_h = tilemap.height * tile_size
  for dy in 0..<dst_h {
    let src_py = cam_y + dy
    if src_py < 0 || src_py >= map_px_h {
      continue
    }
    let ty = src_py / tile_size
    let tile_row = src_py % tile_size
    for dx in 0..<dst_w {
      let src_px = cam_x + dx
      if src_px < 0 || src_px >= map_px_w {
        continue
      }
      let tx = src_px / tile_size
      let tile_col = src_px % tile_size
      let tile_id = match @model.tile_at(tilemap, tx, ty) {
        Some(id) => id
        None => -1
      }
      if tile_id >= 0 {
        match @model.tile_pixel(tiles, tile_id, tile_col, tile_row) {
          Some(color) if color >= 0 =>
            frame.set_pixel(dst_x + dx, dst_y + dy, color)
          _ => ()
        }
      }
    }
  }
}
