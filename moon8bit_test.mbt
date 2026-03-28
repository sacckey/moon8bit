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
test "bird-like demo runs and renders" {
  let (state, frames) = run_bird_like_demo(24)
  assert_eq(frames.length(), 24)
  assert_true(state.score() >= 0)
  assert_true(frames[23].length() > 0)
}

///|
test "bird-like draw reflects ground tilemap colors" {
  let dsl = ["tilemap ground 1 2", "4", "6", "end"].join("\n")
  let bundle = match parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }

  let config = default_engine_config()
  let state = engine_init(new_bird_like_game(bundle), config)
  let (_, frame) = engine_step(state, config, input_none, 0)

  assert_eq(frame.get_pixel(0, config.height - 2), Some(4))
  assert_eq(frame.get_pixel(0, config.height - 1), Some(6))
}

///|
test "bird-like draw reflects bg tilemap colors" {
  let dsl = [
    "tilemap bg 1 1", "4", "end", "", "tilemap ground 1 2", "3", "3", "end",
  ].join("\n")

  let bundle = match parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }

  let config = default_engine_config()
  let state = engine_init(new_bird_like_game(bundle), config)
  let (_, frame) = engine_step(state, config, input_none, 0)

  assert_eq(frame.get_pixel(0, 0), Some(4))
}

///|
test "bird-like records collision tag on game over" {
  let inputs : Array[InputState] = []
  for _ in 0..<64 {
    inputs.push(input_none)
  }

  let (state, _) = run_bird_like(inputs)
  assert_true(state.is_over())
  assert_eq(state.last_hit_tag(), Some("ground"))
}
