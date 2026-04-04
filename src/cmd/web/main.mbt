///|
let config : @lib.EngineConfig = @lib.default_engine_config()

///|
let display_scale : Int = config.scale

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
let bgm_playing_ref : Ref[Bool] = @ref.new(false)

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
fn stop_bgm_if_playing() -> Unit {
  if bgm_playing_ref.val {
    web_audio_stop_bgm()
    bgm_playing_ref.val = false
  }
}

///|
fn start_bgm_if_needed() -> Unit {
  if !bgm_playing_ref.val {
    web_audio_start_bgm()
    bgm_playing_ref.val = true
  }
}

///|
fn tick() -> Unit {
  let frame_index = frame_ref.val
  let input = poll_input()
  let prev_started = state_ref.val.is_started()
  let prev_over = state_ref.val.is_over()
  let (next, rendered) = @lib.engine_step(
    state_ref.val,
    config,
    input,
    frame_index,
  )

  if input.flap {
    web_audio_play_sfx("flap")
  }
  if input.reset {
    web_audio_play_sfx("reset")
    stop_bgm_if_playing()
  }
  if !prev_started && next.is_started() {
    start_bgm_if_needed()
  }
  if prev_over && !next.is_over() && next.is_started() {
    start_bgm_if_needed()
  }
  if !prev_over && next.is_over() {
    web_audio_play_sfx("hit")
    stop_bgm_if_playing()
  }

  state_ref.val = next
  frame_ref.val = frame_index + 1

  draw_frame(rendered)
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
  stop_bgm_if_playing()

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
  web_set_status(
    "HUD is in-canvas (S/F/H). Audio: flap/reset/hit SFX. BGM path is enabled but muted (volume=0).",
  )

  web_set_editor_text(@lib.sample_assets_dsl())
  web_bind_apply(on_apply)
  web_bind_export(on_export)
  web_bind_import(on_import)
  on_apply()

  web_start_loop(tick, config.fps)
}
