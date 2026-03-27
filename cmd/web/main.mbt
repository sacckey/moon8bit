///|
let config : @lib.EngineConfig = @lib.default_engine_config()

///|
let initial_game : @lib.BirdLikeGame = @lib.engine_init(
  @lib.new_bird_like_game(@lib.load_sample_assets()),
  config,
)

///|
let state_ref : Ref[@lib.BirdLikeGame] = @ref.new(initial_game)

///|
let frame_ref : Ref[Int] = @ref.new(0)

///|
fn palette_color(index : Int) -> String {
  if index >= 0 && index < config.palette.colors.length() {
    config.palette.colors[index]
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
fn main {
  web_init_canvas(config.width, config.height, config.scale)
  tick()
  web_start_loop(tick, config.fps)
}
