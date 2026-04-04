///|
test "root wrapper step and run remain equivalent to engine primitives" {
  let bundle = load_sample_assets()
  let cfg = default_engine_config()
  let input = input_state(true, false)

  let base_state = engine_init(new_driftbird_game(bundle), cfg)
  let wrapped_state = engine_init(new_driftbird_game(bundle), cfg)

  let (next_base, frame_base) = engine_step(base_state, cfg, input, 0)
  let (next_wrapped, frame_wrapped) = step(wrapped_state, cfg, input, 0)

  assert_eq(next_wrapped, next_base)
  assert_eq(frame_wrapped, frame_base)

  let inputs = scripted_demo_inputs(24)
  let (final_base, frames_base) = run_fixed_frames(
    new_driftbird_game(bundle),
    cfg,
    inputs,
  )
  let (final_wrapped, frames_wrapped) = run(
    new_driftbird_game(bundle),
    cfg,
    inputs,
  )

  assert_eq(final_wrapped, final_base)
  assert_eq(frames_wrapped, frames_base)
}

///|
test "root wrapper frame helpers remain equivalent to Frame methods" {
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

///|
test "root wrapper re-exports input utility helpers" {
  assert_true(btnp(true, false))
  assert_true(!btnp(true, true))
  assert_true(!btnp(false, false))

  assert_true(every(0, 4))
  assert_true(every(8, 4))
  assert_true(!every(9, 4))
  assert_true(!every(9, -1))
}
