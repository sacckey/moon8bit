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
pub type DriftbirdGame = @driftbird.DriftbirdGame

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
pub fn input_state(flap : Bool, reset : Bool) -> InputState {
  @model.input_state(flap, reset)
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
  fps? : Int = 30,
  scale? : Int = 4,
  palette? : Palette = palette_default(),
) -> EngineConfig {
  @engine.config(width, height, fps~, scale~, palette~)
}

///|
pub fn btn(flap : Bool, reset : Bool) -> InputState {
  @engine.btn(flap, reset)
}

///|
pub fn btnp(current : Bool, previous : Bool) -> Bool {
  @engine.btnp(current, previous)
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
pub fn sample_assets_dsl() -> String {
  @driftbird.sample_assets_dsl()
}

///|
pub fn load_sample_assets() -> AssetBundle {
  @driftbird.load_sample_assets()
}

///|
pub fn new_driftbird_game(bundle : AssetBundle) -> DriftbirdGame {
  @driftbird.new_driftbird_game(bundle)
}

///|
pub fn scripted_demo_inputs(frame_count : Int) -> Array[InputState] {
  @driftbird.scripted_demo_inputs(frame_count)
}

///|
pub fn run_driftbird(
  inputs : Array[InputState],
  config? : EngineConfig = default_engine_config(),
) -> (DriftbirdGame, Array[Frame]) {
  @driftbird.run_driftbird(inputs, config~)
}

///|
pub fn run_driftbird_demo(frame_count : Int) -> (DriftbirdGame, Array[String]) {
  @driftbird.run_driftbird_demo(frame_count)
}

///|
pub fn assets_cli_output(dsl : String) -> String {
  match parse_assets_dsl_to_json_string(dsl) {
    Ok(json) => json
    Err(error) => "error(line=\{error.line}): \{error.message}"
  }
}

///|
pub fn demo_snapshot(frame_count : Int) -> String {
  let safe_count = if frame_count <= 0 { 1 } else { frame_count }
  let (_, ascii_frames) = run_driftbird_demo(safe_count)
  if ascii_frames.length() == 0 {
    ""
  } else {
    ascii_frames[ascii_frames.length() - 1]
  }
}
