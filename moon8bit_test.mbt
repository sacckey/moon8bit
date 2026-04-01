///|
test "parse sample DSL" {
  let bundle = match parse_assets_dsl(sample_assets_dsl()) {
    Ok(v) => v
    Err(_) => panic()
  }

  assert_eq(bundle.palette.name, "dawn")
  assert_eq(bundle.palette.colors.length(), 7)
  assert_eq(bundle.sprites.length(), 1)
  assert_eq(bundle.tilemaps.length(), 2)

  let bird = match find_sprite(bundle, "bird") {
    Some(v) => v
    None => panic()
  }
  assert_eq(bird.width, 5)
  assert_eq(bird.height, 3)

  assert_true(find_tilemap(bundle, "bg") is Some(_))
  assert_true(find_tilemap(bundle, "ground") is Some(_))
}

///|
test "parse error reports line number" {
  let broken = ["sprite hero 2 1", "g1", "end"].join("\n")

  let err = match parse_assets_dsl(broken) {
    Ok(_) => panic()
    Err(e) => e
  }

  assert_eq(err.line, 2)
  assert_true(err.message.find("unsupported sprite symbol") is Some(_))
}

///|
test "tilemap width mismatch is detected" {
  let broken = ["tilemap stage 3 1", "1 2", "end"].join("\n")

  let err = match parse_assets_dsl(broken) {
    Ok(_) => panic()
    Err(e) => e
  }

  assert_eq(err.line, 2)
  assert_true(err.message.find("tilemap row width mismatch") is Some(_))
}

///|
test "assets CLI output returns JSON" {
  let json_text = assets_cli_output(sample_assets_dsl())
  assert_true(json_text.find("\"palette\"") is Some(_))
  assert_true(json_text.find("\"sprites\"") is Some(_))
  assert_true(json_text.find("\"tilemaps\"") is Some(_))
}

///|
test "driftbird demo runs and renders" {
  let (state, frames) = run_driftbird_demo(24)
  assert_eq(frames.length(), 24)
  assert_true(state.score() >= 0)
  assert_true(frames[23].length() > 0)
}

///|
test "driftbird draw reflects ground tilemap colors" {
  let dsl = ["tilemap ground 1 2", "4", "6", "end"].join("\n")
  let bundle = match parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }

  let config = default_engine_config()
  let state = engine_init(new_driftbird_game(bundle), config)
  let (_, frame) = engine_step(state, config, input_none, 0)

  assert_eq(frame.get_pixel(0, config.height - 2), Some(4))
  assert_eq(frame.get_pixel(0, config.height - 1), Some(6))
}

///|
test "driftbird draw reflects bg tilemap colors" {
  let dsl = [
    "tilemap bg 1 1", "4", "end", "", "tilemap ground 1 2", "3", "3", "end",
  ].join("\n")

  let bundle = match parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }

  let config = default_engine_config()
  let state = engine_init(new_driftbird_game(bundle), config)
  let (_, frame) = engine_step(state, config, input_state(true, false), 0)

  assert_eq(frame.get_pixel(0, 0), Some(4))
}

///|
test "driftbird records collision tag on game over" {
  let inputs : Array[InputState] = []
  inputs.push(input_state(true, false))
  for _ in 0..<64 {
    inputs.push(input_none)
  }

  let (state, _) = run_driftbird(inputs)
  assert_true(state.is_over())
  assert_eq(state.last_hit_tag(), Some("ground"))
}

///|
test "driftbird waits for flap before start" {
  let inputs = [input_none, input_none, input_none]
  let (state, _) = run_driftbird(inputs)

  assert_true(!state.is_started())
  assert_true(!state.is_over())
  assert_eq(state.score(), 0)
}

///|
test "driftbird restarts from game over on flap input" {
  let inputs : Array[InputState] = []
  inputs.push(input_state(true, false))
  for _ in 0..<64 {
    inputs.push(input_none)
  }
  inputs.push(input_state(true, false))

  let (state, _) = run_driftbird(inputs)
  assert_true(state.is_started())
  assert_true(!state.is_over())
}

///|
test "wrapped sample runs with wrapper API" {
  let (state, frames) = run_wrapped_sample(30)
  assert_eq(frames.length(), 30)
  assert_true(state.tick >= 0)
  assert_true(frames[0].to_ascii().length() > 0)
}
