///|
pub fn[T] run_web_game(
  init_game : (@lib.AssetBundle, @lib.EngineConfig) -> T,
  step_game : (T, @lib.EngineConfig, @lib.InputState, Int) -> (T, @lib.Frame),
  step_audio_events : (T, T, @lib.InputState) -> Array[String],
  config? : @lib.EngineConfig = @lib.default_engine_config(),
) -> Unit {
  let display_scale = config.scale
  let spec_ref : Ref[WebGameSpec?] = @ref.new(None)
  let state_ref : Ref[T?] = @ref.new(None)
  let frame_ref : Ref[Int] = @ref.new(0)
  let palette_ref : Ref[@lib.Palette] = @ref.new(@lib.palette_default())
  let default_palette = @lib.palette_default()
  let flap_prev_ref : Ref[Bool] = @ref.new(false)
  let reset_prev_ref : Ref[Bool] = @ref.new(false)
  let bgm_playing_ref : Ref[Bool] = @ref.new(false)

  let palette_color = fn(index : Int) -> String {
    let palette = palette_ref.val
    if index >= 0 && index < palette.colors.length() {
      palette.colors[index]
    } else if index >= 0 && index < default_palette.colors.length() {
      default_palette.colors[index]
    } else {
      "#101820"
    }
  }

  let poll_input = fn() -> @lib.InputState {
    let flap_down = web_key_down("Space") || web_key_down("ArrowUp")
    let flap = flap_down && !flap_prev_ref.val
    flap_prev_ref.val = flap_down

    let reset_down = web_key_down("KeyR")
    let reset = reset_down && !reset_prev_ref.val
    reset_prev_ref.val = reset_down

    @lib.input_state(flap, reset)
  }

  let draw_frame = fn(frame : @lib.Frame) -> Unit {
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

  let stop_bgm_if_playing = fn() -> Unit {
    if bgm_playing_ref.val {
      web_audio_stop_bgm()
      bgm_playing_ref.val = false
    }
  }

  let start_bgm_if_needed = fn() -> Unit {
    if !bgm_playing_ref.val {
      web_audio_start_bgm()
      bgm_playing_ref.val = true
    }
  }

  let tick = fn() -> Unit {
    let previous = match state_ref.val {
      Some(game) => game
      None => return
    }

    let frame_index = frame_ref.val
    let input = poll_input()
    let (next, rendered) = step_game(previous, config, input, frame_index)

    for event in step_audio_events(previous, next, input) {
      if event == "@bgm_start" {
        start_bgm_if_needed()
      } else if event == "@bgm_stop" {
        stop_bgm_if_playing()
      } else {
        web_audio_play_sfx(event)
      }
    }

    state_ref.val = Some(next)
    frame_ref.val = frame_index + 1
    draw_frame(rendered)
  }

  let apply_dsl_text = fn(dsl_text : String) -> Unit {
    if spec_ref.val is None {
      web_set_editor_feedback("Game spec is not loaded yet", true)
      return
    }

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

    state_ref.val = Some(init_game(bundle, config))
    palette_ref.val = bundle.palette
    frame_ref.val = 0
    stop_bgm_if_playing()
    web_set_editor_feedback("Applied DSL successfully", false)
  }

  let on_apply = fn() -> Unit { apply_dsl_text(web_get_editor_text()) }

  let on_export = fn() -> Unit {
    let spec = match spec_ref.val {
      Some(v) => v
      None => {
        web_set_editor_feedback("Game spec is not loaded yet", true)
        return
      }
    }
    let current = web_get_editor_text()
    web_download_text(spec.export_filename, current)
    web_set_editor_feedback("Exported DSL as \{spec.export_filename}", false)
  }

  let on_import = fn(dsl_text : String) -> Unit {
    web_set_editor_text(dsl_text)
    web_sprite_editor_refresh()
    apply_dsl_text(dsl_text)
  }

  web_init_canvas(config.width, config.height, display_scale)
  web_set_status("Loading game...")
  web_bind_apply(on_apply)
  web_bind_export(on_export)
  web_bind_import(on_import)
  web_init_sprite_editor()
  web_bootstrap_game(
    fn(title, status_text, export_filename, dsl_text) {
      let spec : WebGameSpec = { title, status_text, export_filename }
      spec_ref.val = Some(spec)
      web_set_status("\{spec.title}: \{spec.status_text}")
      web_set_editor_text(dsl_text)
      web_sprite_editor_refresh()
      apply_dsl_text(dsl_text)
      tick()
      web_start_loop(tick, config.fps)
    },
    fn(error_message) {
      web_set_status("Boot error")
      web_set_editor_feedback(error_message, true)
    },
  )
}
