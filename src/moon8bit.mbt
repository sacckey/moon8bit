///|
pub type Palette = @model.Palette

///|
pub type Sprite = @model.Sprite

///|
pub type Tilemap = @model.Tilemap

///|
pub type AssetBundle = @model.AssetBundle

///|
pub type DslError = @model.DslError

///|
pub type EngineConfig = @model.EngineConfig

///|
pub type InputState = @model.InputState

///|
pub type RuntimeContext = @model.RuntimeContext

///|
pub type Rect = @model.Rect

///|
pub type Collider = @model.Collider

///|
pub type Frame = @model.Frame

///|
pub let input_none : InputState = @model.input_none

///|
pub fn version_tag() -> String {
  "moon8bit-v0.1-mvp"
}

///|
pub fn palette_default() -> Palette {
  @model.palette_default()
}

///|
pub fn sprite_pixel(sprite : Sprite, x : Int, y : Int) -> Int? {
  @model.sprite_pixel(sprite, x, y)
}

///|
pub fn tile_at(tilemap : Tilemap, x : Int, y : Int) -> Int? {
  @model.tile_at(tilemap, x, y)
}

///|
pub fn find_sprite(bundle : AssetBundle, name : String) -> Sprite? {
  @model.find_sprite(bundle, name)
}

///|
pub fn find_tilemap(bundle : AssetBundle, name : String) -> Tilemap? {
  @model.find_tilemap(bundle, name)
}

///|
pub fn default_engine_config() -> EngineConfig {
  @model.default_engine_config()
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
pub fn rect_intersects(a : Rect, b : Rect) -> Bool {
  @model.rect_intersects(a, b)
}

///|
pub fn collider(tag : String, rect : Rect) -> Collider {
  @model.collider(tag, rect)
}

///|
pub fn collider_box(
  tag : String,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
) -> Collider {
  @model.collider_box(tag, x, y, w, h)
}

///|
pub fn collider_intersects(a : Collider, b : Collider) -> Bool {
  @model.collider_intersects(a, b)
}

///|
pub fn collider_hits_any(target : Collider, others : Array[Collider]) -> Bool {
  @model.collider_hits_any(target, others)
}

///|
pub fn collider_first_hit(
  target : Collider,
  others : Array[Collider],
) -> Collider? {
  @model.collider_first_hit(target, others)
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
  @engine.aabb(x1, y1, w1, h1, x2, y2, w2, h2)
}

///|
pub fn aabb_hit_tag(
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  obstacles : Array[Collider],
) -> String? {
  @engine.aabb_hit_tag(x, y, w, h, obstacles)
}

///|
pub fn ui_center_x(total_width : Int, item_width : Int) -> Int {
  @engine.ui_center_x(total_width, item_width)
}

///|
pub fn ui_center_y(total_height : Int, item_height : Int) -> Int {
  @engine.ui_center_y(total_height, item_height)
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
  @engine.ui_panel(frame, x, y, w, h, fill, border~)
}

///|
pub fn ui_text_width(text : String, scale? : Int = 1) -> Int {
  @engine.ui_text_width(text, scale~)
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
  @engine.ui_text(frame, x, y, text, color, scale~)
}

///|
pub fn parse_assets_dsl(input : String) -> Result[AssetBundle, DslError] {
  @assets.parse_assets_dsl(input)
}

///|
pub fn palette_to_json(palette : Palette) -> Json {
  @assets.palette_to_json(palette)
}

///|
pub fn sprite_to_json(sprite : Sprite) -> Json {
  @assets.sprite_to_json(sprite)
}

///|
pub fn tilemap_to_json(tilemap : Tilemap) -> Json {
  @assets.tilemap_to_json(tilemap)
}

///|
pub fn asset_bundle_to_json(bundle : AssetBundle) -> Json {
  @assets.asset_bundle_to_json(bundle)
}

///|
pub fn asset_bundle_to_json_string(bundle : AssetBundle) -> String {
  @assets.asset_bundle_to_json_string(bundle)
}

///|
pub fn parse_assets_dsl_to_json_string(
  input : String,
) -> Result[String, DslError] {
  @assets.parse_assets_dsl_to_json_string(input)
}

///|
pub fn[T : @engine.Game] engine_init(initial : T, config : EngineConfig) -> T {
  @engine.engine_init(initial, config)
}

///|
pub fn[T : @engine.Game] engine_step(
  game : T,
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> (T, Frame) {
  @engine.engine_step(game, config, input, frame)
}

///|
pub fn[T : @engine.Game] run_fixed_frames(
  initial : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (T, Array[Frame]) {
  @engine.run_fixed_frames(initial, config, inputs)
}

///|
pub fn config(
  width : Int,
  height : Int,
  fps? : Int = 60,
  scale? : Int = 4,
  palette? : Palette = palette_default(),
) -> EngineConfig {
  @engine.config(width, height, fps~, scale~, palette~)
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
  @engine.btn(
    keys_down,
    keys_pressed~,
    keys_released~,
    pointer_x~,
    pointer_y~,
    pointer_down~,
    pointer_pressed~,
    pointer_released~,
  )
}

///|
pub fn btnp(current : Bool, previous : Bool) -> Bool {
  @engine.btnp(current, previous)
}

///|
pub fn key_down(input : InputState, key : String) -> Bool {
  @engine.key_down(input, key)
}

///|
pub fn key_pressed(input : InputState, key : String) -> Bool {
  @engine.key_pressed(input, key)
}

///|
pub fn key_released(input : InputState, key : String) -> Bool {
  @engine.key_released(input, key)
}

///|
pub fn every(frame : Int, interval : Int) -> Bool {
  @engine.every(frame, interval)
}

///|
pub fn[T : @engine.Game] step(
  game : T,
  config : EngineConfig,
  input : InputState,
  frame : Int,
) -> (T, Frame) {
  @engine.step(game, config, input, frame)
}

///|
pub fn[T : @engine.Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (T, Array[Frame]) {
  @engine.run(game, config, inputs)
}

///|
pub fn cls(frame : Frame, color : Int) -> Unit {
  @engine.cls(frame, color)
}

///|
pub fn pset(frame : Frame, x : Int, y : Int, color : Int) -> Unit {
  @engine.pset(frame, x, y, color)
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
  @engine.rect(frame, x, y, w, h, color)
}

///|
pub fn spr(frame : Frame, sprite : Sprite, x : Int, y : Int) -> Unit {
  @engine.spr(frame, sprite, x, y)
}

///|
pub fn assets_cli_output(dsl : String) -> String {
  match parse_assets_dsl_to_json_string(dsl) {
    Ok(json) => json
    Err(error) => "error(line=\{error.line}): \{error.message}"
  }
}
