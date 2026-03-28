///|
let config : @lib.EngineConfig = @lib.default_engine_config()

///|
let display_scale : Int = config.scale * 2

///|
let initial_bundle : @lib.AssetBundle = @lib.load_sample_assets()

///|
let initial_game : @lib.DriftbirdGame = @lib.engine_init(
  @lib.new_driftbird_game(initial_bundle),
  config,
)

///|
let state_ref : Ref[@lib.DriftbirdGame] = @ref.new(initial_game)

///|
let frame_ref : Ref[Int] = @ref.new(0)

///|
let palette_ref : Ref[@lib.Palette] = @ref.new(initial_bundle.palette)

///|
let flap_prev_ref : Ref[Bool] = @ref.new(false)

///|
let reset_prev_ref : Ref[Bool] = @ref.new(false)

///|
fn palette_color(index : Int) -> String {
  let palette = palette_ref.val
  if index >= 0 && index < palette.colors.length() {
    palette.colors[index]
  } else {
    "#101820"
  }
}

///|
fn poll_input() -> @lib.InputState {
  let flap_down = web_key_down("Space") || web_key_down("ArrowUp")
  let flap = flap_down && !flap_prev_ref.val
  flap_prev_ref.val = flap_down

  let reset_down = web_key_down("KeyR")
  let reset = reset_down && !reset_prev_ref.val
  reset_prev_ref.val = reset_down

  @lib.input_state(flap, reset)
}

///|
fn draw_frame(frame : @lib.Frame) -> Unit {
  web_clear(palette_color(0))

  for y in 0..<frame.height {
    for x in 0..<frame.width {
      let color = frame.pixels[y * frame.width + x]
      if color >= 0 {
        web_fill_rect(x, y, 1, 1, palette_color(color))
      }
    }
  }
}

///|
fn tick() -> Unit {
  let frame_index = frame_ref.val
  let input = poll_input()
  let (next, rendered) = @lib.engine_step(
    state_ref.val,
    config,
    input,
    frame_index,
  )

  state_ref.val = next
  frame_ref.val = frame_index + 1

  draw_frame(rendered)
  let hit_tag = match next.last_hit_tag() {
    Some(v) => v
    None => "-"
  }

  if !next.is_started() {
    web_set_status(
      "moon8bit driftbird demo  PRESS SPACE TO START  score=\{next.score()}  frame=\{frame_ref.val}  hit=\{hit_tag}  reset=R",
    )
  } else if next.is_over() {
    web_set_status(
      "moon8bit driftbird demo  GAME OVER - PRESS SPACE TO RESTART  score=\{next.score()}  frame=\{frame_ref.val}  hit=\{hit_tag}  reset=R",
    )
  } else {
    web_set_status(
      "moon8bit driftbird demo  score=\{next.score()}  frame=\{frame_ref.val}  hit=\{hit_tag}  reset=R",
    )
  }
}

///|
fn apply_dsl_text(dsl_text : String) -> Unit {
  let bundle = match @lib.parse_assets_dsl(dsl_text) {
    Ok(parsed) => parsed
    Err(err) => {
      web_set_editor_feedback(
        "Parse error at line \{err.line}: \{err.message}",
        true,
      )
      return
    }
  }

  state_ref.val = @lib.engine_init(@lib.new_driftbird_game(bundle), config)
  palette_ref.val = bundle.palette
  frame_ref.val = 0

  web_set_editor_feedback("Applied DSL successfully", false)
  tick()
}

///|
fn on_apply() -> Unit {
  apply_dsl_text(web_get_editor_text())
}

///|
fn on_export() -> Unit {
  let current = web_get_editor_text()
  web_download_text("moon8bit_assets.dsl", current)
  web_set_editor_feedback("Exported DSL as moon8bit_assets.dsl", false)
}

///|
fn on_import(dsl_text : String) -> Unit {
  web_set_editor_text(dsl_text)
  apply_dsl_text(dsl_text)
}

///|
fn main {
  web_init_canvas(config.width, config.height, display_scale)

  web_set_editor_text(@lib.sample_assets_dsl())
  web_bind_apply(on_apply)
  web_bind_export(on_export)
  web_bind_import(on_import)
  on_apply()

  web_start_loop(tick, config.fps)
}
