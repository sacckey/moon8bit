///|
pub type Palette = @model.Palette

///|
pub type Sprite = @model.Sprite

///|
pub type Tiles = @model.Tiles

///|
pub type Tilemap = @model.Tilemap

///|
pub type AssetBundle = @model.AssetBundle

///|
pub type SoundDef = @model.SoundDef

///|
pub type BgmDef = @model.BgmDef

///|
pub type DslError = @model.DslError

///|
pub type EngineConfig = @model.EngineConfig

///|
pub type InputState = @model.InputState

///|
pub type UpdateContext = @engine.UpdateContext

///|
pub type DrawContext = @engine.DrawContext

///|
pub type EngineEvent = @engine.EngineEvent

///|
pub type EngineCommand = @engine.EngineCommand

///|
pub type Rect = @model.Rect

///|
pub type Collider = @model.Collider

///|
pub type Camera = @model.Camera

///|
pub type Frame = @model.Frame

///|
pub type EngineInstance[T] = @engine.EngineInstance[T]

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
pub fn tile_id_at_px(tilemap : Tilemap, px : Int, py : Int) -> Int? {
  @engine.tile_id_at_px(tilemap, px, py)
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
pub fn tile_pixel(tiles : Tiles, tile_id : Int, x : Int, y : Int) -> Int? {
  @model.tile_pixel(tiles, tile_id, x, y)
}

///|
pub fn tile_solid(tiles : Tiles, tile_id : Int) -> Bool {
  @model.tile_solid(tiles, tile_id)
}

///|
pub fn tile_solid_at_px(
  tilemap : Tilemap,
  tiles : Tiles,
  px : Int,
  py : Int,
) -> Bool {
  @engine.tile_solid_at_px(tilemap, tiles, px, py)
}

///|
pub fn tile_solid_any_in_rect(
  tilemap : Tilemap,
  tiles : Tiles,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
) -> Bool {
  @engine.tile_solid_any_in_rect(tilemap, tiles, x, y, w, h)
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
pub fn[T : @engine.Game] engine_init(
  initial : T,
  config : EngineConfig,
) -> EngineInstance[T] {
  @engine.engine_init(initial, config)
}

///|
pub fn[T : @engine.Game] engine_step(
  state : EngineInstance[T],
  input : InputState,
) -> (EngineInstance[T], Frame) {
  @engine.engine_step(state, input)
}

///|
pub fn[T : @engine.Game] run_fixed_frames(
  initial : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (EngineInstance[T], Array[Frame]) {
  @engine.run_fixed_frames(initial, config, inputs)
}

///|
pub fn[T] engine_game(state : EngineInstance[T]) -> T {
  @engine.engine_game(state)
}

///|
pub fn[T] engine_with_game(
  state : EngineInstance[T],
  game : T,
) -> EngineInstance[T] {
  @engine.engine_with_game(state, game)
}

///|
pub fn[T] engine_events(state : EngineInstance[T]) -> Array[EngineEvent] {
  @engine.engine_events(state)
}

///|
pub fn[T] engine_take_events(
  state : EngineInstance[T],
) -> (EngineInstance[T], Array[EngineEvent]) {
  @engine.engine_take_events(state)
}

///|
pub fn emit(event : EngineEvent) -> EngineCommand {
  @engine.emit(event)
}

///|
pub fn sfx(name : String) -> EngineCommand {
  @engine.sfx(name)
}

///|
pub fn bgm_start() -> EngineCommand {
  @engine.bgm_start()
}

///|
pub fn bgm_stop() -> EngineCommand {
  @engine.bgm_stop()
}

///|
pub fn set_timeout_cmd(frames : Int, event : EngineEvent) -> EngineCommand {
  @engine.set_timeout_cmd(frames, event)
}

///|
pub fn set_interval_cmd(frames : Int, event : EngineEvent) -> EngineCommand {
  @engine.set_interval_cmd(frames, event)
}

///|
pub fn clear_timers_cmd() -> EngineCommand {
  @engine.clear_timers_cmd()
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
pub fn key_down_any(input : InputState, keys : Array[String]) -> Bool {
  @engine.key_down_any(input, keys)
}

///|
pub fn key_pressed_any(input : InputState, keys : Array[String]) -> Bool {
  @engine.key_pressed_any(input, keys)
}

///|
pub fn key_released_any(input : InputState, keys : Array[String]) -> Bool {
  @engine.key_released_any(input, keys)
}

///|
pub fn every(frame : Int, interval : Int) -> Bool {
  @engine.every(frame, interval)
}

///|
pub fn[T : @engine.Game] step(
  state : EngineInstance[T],
  input : InputState,
) -> (EngineInstance[T], Frame) {
  @engine.step(state, input)
}

///|
pub fn[T : @engine.Game] run(
  game : T,
  config : EngineConfig,
  inputs : Array[InputState],
) -> (EngineInstance[T], Array[Frame]) {
  @engine.run(game, config, inputs)
}

///|
pub fn[T] game_state(state : EngineInstance[T]) -> T {
  @engine.game_state(state)
}

///|
pub fn[T] with_game(state : EngineInstance[T], game : T) -> EngineInstance[T] {
  @engine.with_game(state, game)
}

///|
pub fn[T] events(state : EngineInstance[T]) -> Array[EngineEvent] {
  @engine.events(state)
}

///|
pub fn[T] take_events(
  state : EngineInstance[T],
) -> (EngineInstance[T], Array[EngineEvent]) {
  @engine.take_events(state)
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
pub fn camera(x : Int, y : Int) -> Camera {
  @engine.camera(x, y)
}

///|
pub fn world_to_screen_x(world_x : Int, camera : Camera) -> Int {
  @engine.world_to_screen_x(world_x, camera)
}

///|
pub fn world_to_screen_y(world_y : Int, camera : Camera) -> Int {
  @engine.world_to_screen_y(world_y, camera)
}

///|
pub fn screen_to_world_x(screen_x : Int, camera : Camera) -> Int {
  @engine.screen_to_world_x(screen_x, camera)
}

///|
pub fn screen_to_world_y(screen_y : Int, camera : Camera) -> Int {
  @engine.screen_to_world_y(screen_y, camera)
}

///|
pub fn camera_clamp(
  camera : Camera,
  map_width_px : Int,
  map_height_px : Int,
  view_width_px : Int,
  view_height_px : Int,
) -> Camera {
  @engine.camera_clamp(
    camera, map_width_px, map_height_px, view_width_px, view_height_px,
  )
}

///|
pub fn camera_follow(
  target_x : Int,
  target_y : Int,
  view_width_px : Int,
  view_height_px : Int,
  map_width_px : Int,
  map_height_px : Int,
) -> Camera {
  @engine.camera_follow(
    target_x, target_y, view_width_px, view_height_px, map_width_px, map_height_px,
  )
}

///|
pub fn spr(frame : Frame, sprite : Sprite, x : Int, y : Int) -> Unit {
  @engine.spr(frame, sprite, x, y)
}

///|
pub fn rect_world(
  frame : Frame,
  world_x : Int,
  world_y : Int,
  w : Int,
  h : Int,
  color : Int,
  camera : Camera,
) -> Unit {
  @engine.rect_world(frame, world_x, world_y, w, h, color, camera)
}

///|
pub fn spr_world(
  frame : Frame,
  sprite : Sprite,
  world_x : Int,
  world_y : Int,
  camera : Camera,
) -> Unit {
  @engine.spr_world(frame, sprite, world_x, world_y, camera)
}

///|
pub fn draw_tilemap(
  frame : Frame,
  tilemap : Tilemap,
  tiles : Tiles,
  dst_x : Int,
  dst_y : Int,
  dst_w : Int,
  dst_h : Int,
  cam_x : Int,
  cam_y : Int,
) -> Unit {
  @engine.draw_tilemap(
    frame, tilemap, tiles, dst_x, dst_y, dst_w, dst_h, cam_x, cam_y,
  )
}

///|
pub fn draw_tilemap_world(
  frame : Frame,
  tilemap : Tilemap,
  tiles : Tiles,
  dst_x : Int,
  dst_y : Int,
  dst_w : Int,
  dst_h : Int,
  camera : Camera,
) -> Unit {
  @engine.draw_tilemap_world(
    frame, tilemap, tiles, dst_x, dst_y, dst_w, dst_h, camera,
  )
}

///|
pub fn assets_cli_output(dsl : String) -> String {
  match parse_assets_dsl_to_json_string(dsl) {
    Ok(json) => json
    Err(error) => "error(line=\{error.line}): \{error.message}"
  }
}
