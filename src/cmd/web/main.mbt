///|
pub fn[G] run_web_game(
  init_game : (@lib.AssetBundle, @lib.EngineConfig) -> @lib.EngineInstance[G],
  step_game : (@lib.EngineInstance[G], @lib.InputState) -> (
    @lib.EngineInstance[G],
    @lib.Frame,
  ),
  config? : @lib.EngineConfig = @lib.default_engine_config(),
) -> Unit {
  let display_scale = config.scale
  let title_ref : Ref[String] = @ref.new("Game")
  let status_text_ref : Ref[String] = @ref.new("Ready")
  let export_filename_ref : Ref[String] = @ref.new("assets.dsl")
  let state_ref : Ref[@lib.EngineInstance[G]?] = @ref.new(None)
  let palette_ref : Ref[@lib.Palette] = @ref.new(@lib.palette_default())
  let prev_keys_down_ref : Ref[Array[String]] = @ref.new([])
  let pointer_prev_down_ref : Ref[Bool] = @ref.new(false)
  let bgm_playing_ref : Ref[Bool] = @ref.new(false)

  let has_key = fn(keys : Array[String], key : String) -> Bool {
    for current in keys {
      if current == key {
        return true
      }
    }
    false
  }

  let diff_keys = fn(
    current : Array[String],
    previous : Array[String],
  ) -> Array[String] {
    let diff : Array[String] = []
    for key in current {
      if !has_key(previous, key) {
        diff.push(key)
      }
    }
    diff
  }

  let poll_input = fn() -> @lib.InputState {
    let keys_down = web_keys_down()
    let prev_keys_down = prev_keys_down_ref.val
    let keys_pressed = diff_keys(keys_down, prev_keys_down)
    let keys_released = diff_keys(prev_keys_down, keys_down)
    prev_keys_down_ref.val = keys_down

    let pointer_down = web_pointer_down()
    let pointer_pressed = pointer_down && !pointer_prev_down_ref.val
    let pointer_released = !pointer_down && pointer_prev_down_ref.val
    pointer_prev_down_ref.val = pointer_down

    @lib.input_state(
      keys_down,
      keys_pressed,
      keys_released,
      pointer_x=web_pointer_x(),
      pointer_y=web_pointer_y(),
      pointer_down~,
      pointer_pressed~,
      pointer_released~,
    )
  }

  let draw_frame = fn(frame : @lib.Frame) -> Unit {
    let colors = palette_ref.val.colors
    web_render_frame(frame.pixels, frame.width, frame.height, colors)
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

    let input = poll_input()
    let (next, rendered) = step_game(previous, input)
    let (next_cleared, events) = @lib.engine_take_events(next)

    for event in events {
      match event {
        @lib.EngineEvent::BgmStart => start_bgm_if_needed()
        @lib.EngineEvent::BgmStop => stop_bgm_if_playing()
        @lib.EngineEvent::Sfx(kind) => web_audio_play_sfx(kind)
      }
    }

    state_ref.val = Some(next_cleared)
    draw_frame(rendered)
  }

  let apply_dsl_text = fn(dsl_text : String) -> Unit {
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
    stop_bgm_if_playing()
    web_set_editor_feedback("Applied DSL successfully", false)
  }

  let on_apply = fn() -> Unit { apply_dsl_text(web_get_editor_text()) }

  let on_export = fn() -> Unit {
    let current = web_get_editor_text()
    let export_filename = export_filename_ref.val
    web_download_text(export_filename, current)
    web_set_editor_feedback("Exported DSL as \{export_filename}", false)
  }

  let on_import = fn(dsl_text : String) -> Unit {
    web_set_editor_text(dsl_text)
    web_sprite_editor_refresh()
    apply_dsl_text(dsl_text)
  }

  web_init_canvas(config.width, config.height, display_scale)
  web_init_gpu(config.width, config.height)
  web_set_status("Loading game...")
  web_bind_apply(on_apply)
  web_bind_export(on_export)
  web_bind_import(on_import)
  web_init_sprite_editor()
  web_bootstrap_game(
    fn(title, status_text, export_filename, dsl_text) {
      title_ref.val = title
      status_text_ref.val = status_text
      export_filename_ref.val = export_filename
      web_set_status("\{title_ref.val}: \{status_text_ref.val}")
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
