///|
let config : @lib.EngineConfig = @lib.default_engine_config()

///|
let display_scale : Int = config.scale

///|
let current_spec : WebGameSpec = resolve_game_spec(web_route_game_id())

///|
let initial_bundle : @lib.AssetBundle = initial_bundle_for_spec(current_spec)

///|
let initial_game : WebGame = init_web_game(current_spec, initial_bundle, config)

///|
let state_ref : Ref[WebGame] = @ref.new(initial_game)

///|
let frame_ref : Ref[Int] = @ref.new(0)

///|
let palette_ref : Ref[@lib.Palette] = @ref.new(initial_bundle.palette)

///|
let default_palette : @lib.Palette = @lib.palette_default()

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
  } else if index >= 0 && index < default_palette.colors.length() {
    default_palette.colors[index]
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
  let prev_started = game_started(state_ref.val)
  let prev_over = game_over(state_ref.val)
  let (next, rendered) = step_web_game(
    state_ref.val,
    config,
    input,
    frame_index,
  )

  if input.flap {
    web_audio_play_sfx(current_spec.sound_events.flap)
  }
  if input.reset {
    web_audio_play_sfx(current_spec.sound_events.reset)
    stop_bgm_if_playing()
  }
  if !prev_started && game_started(next) {
    start_bgm_if_needed()
  }
  if prev_over && !game_over(next) && game_started(next) {
    start_bgm_if_needed()
  }
  if !prev_over && game_over(next) {
    web_audio_play_sfx(current_spec.sound_events.hit)
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

  state_ref.val = init_web_game(current_spec, bundle, config)
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
  web_download_text(current_spec.export_filename, current)
  web_set_editor_feedback(
    "Exported DSL as \{current_spec.export_filename}",
    false,
  )
}

///|
fn on_import(dsl_text : String) -> Unit {
  web_set_editor_text(dsl_text)
  web_sprite_editor_refresh()
  apply_dsl_text(dsl_text)
}

///|
fn main {
  web_init_canvas(config.width, config.height, display_scale)
  web_set_status("\{current_spec.title}: \{current_spec.status_text}")

  web_set_editor_text(current_spec.default_assets_dsl)
  web_bind_apply(on_apply)
  web_bind_export(on_export)
  web_bind_import(on_import)
  web_init_sprite_editor()
  web_sprite_editor_refresh()
  on_apply()

  web_start_loop(tick, config.fps)
}
