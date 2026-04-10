///|
test "parse assets dsl builds bundle with expected entries" {
  let dsl = [
    "palette simple", "color 0 #000000", "color 1 #ffffff", "end", "", "sprite hero 8 8",
    "1.......", "........", "........", "........", "........", "........", "........",
    "........", "end", "", "tilemap bg 2 1", "0 1", "end",
  ].join("\n")

  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }

  assert_eq(bundle.palette.name, "simple")
  assert_eq(bundle.palette.colors.length(), 2)
  assert_eq(bundle.sprites.length(), 1)
  assert_eq(bundle.tilemaps.length(), 1)
}

///|
test "json conversion and parse errors are reported" {
  let dsl = ["sprite s 8 8", "g.......", "end"].join("\n")
  let parse_err = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_eq(parse_err.line, 2)
  assert_true(parse_err.message.find("unsupported sprite symbol") is Some(_))

  let ok_dsl = ["tilemap m 1 1", "3", "end"].join("\n")
  let json_text = match @assets.parse_assets_dsl_to_json_string(ok_dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_true(json_text.find("\"tilemaps\"") is Some(_))
  assert_true(json_text.find("\"name\": \"m\"") is Some(_))
}

///|
test "parse sound block into bundle" {
  let dsl = [
    "sound flap", "wave square", "attack 0.003", "decay 0.10", "volume 0.07", "f0 520",
    "f1 360", "end",
  ].join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_eq(bundle.sounds.length(), 1)
  let s = bundle.sounds[0]
  assert_eq(s.name, "flap")
  assert_eq(s.wave, "square")
  assert_eq(s.volume, 0.07)
  assert_eq(s.f0, 520)
  assert_eq(s.f1, 360)
}

///|
test "parse bgm block with notes into bundle" {
  let dsl = [
    "bgm main", "wave square", "volume 0.05", "step_sec 0.125", "loop true", "notes C4 E4 G4 R",
    "end",
  ].join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_eq(bundle.bgms.length(), 1)
  let b = bundle.bgms[0]
  assert_eq(b.name, "main")
  assert_eq(b.wave, "square")
  assert_eq(b.loop_, true)
  // C4=60, E4=64, G4=67, R=-1
  assert_eq(b.notes, [60, 64, 67, -1])
}

///|
test "note name to midi: white keys" {
  let dsl = [
    "bgm test", "wave square", "volume 0.1", "step_sec 0.1", "loop false", "notes C4 D4 E4 F4 G4 A4 B4 C5",
    "end",
  ].join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_eq(bundle.bgms[0].notes, [60, 62, 64, 65, 67, 69, 71, 72])
}

///|
test "note name to midi: sharps and flats" {
  let dsl = [
    "bgm test", "wave square", "volume 0.1", "step_sec 0.1", "loop false", "notes C#4 Db4 F#3 Gb3 Bb2 A#2",
    "end",
  ].join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  // C#4=61, Db4=61, F#3=54, Gb3=54, Bb2=46, A#2=46
  assert_eq(bundle.bgms[0].notes, [61, 61, 54, 54, 46, 46])
}

///|
test "sound block reports error for unknown field" {
  let dsl = ["sound boom", "wave square", "unknown 1.0", "end"].join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("unknown sound field") is Some(_))
}

///|
test "sound block reports error for invalid wave" {
  let dsl = ["sound boom", "wave pulse", "end"].join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("invalid wave") is Some(_))
}

///|
test "bgm block reports error for invalid wave" {
  let dsl = [
    "bgm main", "wave pulse", "volume 0.1", "step_sec 0.1", "loop false", "notes C4",
    "end",
  ].join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("invalid wave") is Some(_))
}

///|
test "bgm block reports error for invalid note name" {
  let dsl = [
    "bgm main", "wave square", "volume 0.1", "step_sec 0.1", "loop false", "notes X4",
    "end",
  ].join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("invalid note name") is Some(_))
}

///|
test "sprite size must be 8/16/32 on each axis" {
  let dsl = ["sprite s 7 8", "end"].join("\n")
  let parse_err = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_eq(parse_err.line, 1)
  assert_true(parse_err.message.find("one of: 8, 16, 32") is Some(_))
}
