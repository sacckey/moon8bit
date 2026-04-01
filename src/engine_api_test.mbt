///|
test "wrapper config and btn mirror existing constructors" {
  let default_config = default_engine_config()
  assert_eq(config(default_config.width, default_config.height), default_config)

  let custom_palette = palette_default()
  let custom = config(96, 72, fps=60, scale=2, palette=custom_palette)
  assert_eq(custom.width, 96)
  assert_eq(custom.height, 72)
  assert_eq(custom.fps, 60)
  assert_eq(custom.scale, 2)
  assert_eq(custom.palette, custom_palette)

  assert_eq(btn(true, false), input_state(true, false))
  assert_eq(btn(false, true), input_state(false, true))
}

///|
test "wrapper step matches engine_step" {
  let bundle = load_sample_assets()
  let engine_cfg = default_engine_config()
  let input = input_state(true, false)

  let base_state = engine_init(new_driftbird_game(bundle), engine_cfg)
  let wrapped_state = engine_init(new_driftbird_game(bundle), engine_cfg)

  let (next_base, frame_base) = engine_step(base_state, engine_cfg, input, 0)
  let (next_wrapped, frame_wrapped) = step(wrapped_state, engine_cfg, input, 0)

  assert_eq(next_wrapped, next_base)
  assert_eq(frame_wrapped, frame_base)
}

///|
test "wrapper run matches run_fixed_frames" {
  let inputs = scripted_demo_inputs(48)
  let engine_cfg = default_engine_config()
  let bundle = load_sample_assets()

  let (final_base, frames_base) = run_fixed_frames(
    new_driftbird_game(bundle),
    engine_cfg,
    inputs,
  )
  let (final_wrapped, frames_wrapped) = run(
    new_driftbird_game(bundle),
    engine_cfg,
    inputs,
  )

  assert_eq(final_wrapped, final_base)
  assert_eq(frames_wrapped, frames_base)
}

///|
test "wrapper frame helpers match Frame methods" {
  let bundle = load_sample_assets()
  let sprite = match find_sprite(bundle, "bird") {
    Some(v) => v
    None => panic()
  }

  let wrapped = Frame::new(8, 8, fill=-1)
  let base = Frame::new(8, 8, fill=-1)

  cls(wrapped, 0)
  base.clear(0)

  pset(wrapped, 1, 1, 3)
  base.set_pixel(1, 1, 3)

  rect(wrapped, 2, 2, 3, 2, 4)
  base.draw_rect(2, 2, 3, 2, 4)

  spr(wrapped, sprite, 4, 4)
  base.blit(sprite, 4, 4)

  assert_eq(wrapped, base)
}
