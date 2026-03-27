///|
let config : @lib.EngineConfig = @lib.default_engine_config()

///|
let display_scale : Int = config.scale * 2

///|
let initial_bundle : @lib.AssetBundle = @lib.load_sample_assets()

///|
let initial_game : @lib.BirdLikeGame = @lib.engine_init(
  @lib.new_bird_like_game(initial_bundle),
  config,
)

///|
let state_ref : Ref[@lib.BirdLikeGame] = @ref.new(initial_game)

///|
let frame_ref : Ref[Int] = @ref.new(0)

///|
let palette_ref : Ref[@lib.Palette] = @ref.new(initial_bundle.palette)

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
  let flap = web_key_down("Space") || web_key_down("ArrowUp")
  let reset = web_key_down("KeyR")
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
  web_set_status(
    "moon8bit canvas demo  score=\{next.score()}  frame=\{frame_ref.val}  reset=R",
  )
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

  state_ref.val = @lib.engine_init(@lib.new_bird_like_game(bundle), config)
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
fn main {
  web_init_canvas(config.width, config.height, display_scale)

  web_set_editor_text(@lib.sample_assets_dsl())
  web_bind_apply(on_apply)
  on_apply()

  web_start_loop(tick, config.fps)
}
