///|
test "parse assets dsl builds bundle with expected entries" {
  let dsl = [
    "palette simple", "color 0 #000000", "color 1 #ffffff", "end", "", "sprite hero 8 8",
    "1.......", "........", "........", "........", "........", "........", "........",
    "........", "end", "", "tile 0 black", "00000000", "00000000", "00000000", "00000000",
    "00000000", "00000000", "00000000", "00000000", "end", "tile 1 white", "11111111",
    "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111",
    "end", "", "tilemap bg 2 1", "0 1", "end",
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

  let ok_dsl = [
    "tile 0 t0", "33333333", "33333333", "33333333", "33333333", "33333333", "33333333",
    "33333333", "33333333", "end", "tilemap m 1 1", "0", "end",
  ].join("\n")
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
fn encode_sound_and_bgm_blocks(
  sounds : Array[@model.SoundDef],
  bgms : Array[@model.BgmDef],
) -> String {
  let lines : Array[String] = []
  for s in sounds {
    lines.push("sound \{s.name}")
    lines.push("wave \{s.wave}")
    lines.push("attack \{s.attack.to_string()}")
    lines.push("decay \{s.decay.to_string()}")
    lines.push("volume \{s.volume.to_string()}")
    lines.push("f0 \{s.f0.to_string()}")
    lines.push("f1 \{s.f1.to_string()}")
    lines.push("end")
    lines.push("")
  }
  let note_name_from_midi = fn(midi : Int) -> String {
    if midi < 0 {
      return "R"
    }
    let names = [
      "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B",
    ]
    let semitone = (midi % 12 + 12) % 12
    let octave = midi / 12 - 1
    "\{names[semitone]}\{octave.to_string()}"
  }
  for b in bgms {
    let loop_text = if b.loop_ { "true" } else { "false" }
    lines.push("bgm \{b.name}")
    lines.push("wave \{b.wave}")
    lines.push("volume \{b.volume.to_string()}")
    lines.push("step_sec \{b.step_sec.to_string()}")
    lines.push("loop \{loop_text}")
    let note_tokens = b.notes.map(note_name_from_midi)
    let notes_suffix = if note_tokens.length() > 0 {
      let joined = note_tokens.join(" ")
      " \{joined}"
    } else {
      ""
    }
    lines.push("notes\{notes_suffix}")
    lines.push("end")
    lines.push("")
  }
  if lines.length() > 0 && lines[lines.length() - 1] == "" {
    ignore(lines.pop())
  }
  lines.join("\n")
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
test "sound and bgm blocks survive parse round-trip: fields match" {
  let dsl = [
    "sound zap", "wave sawtooth", "attack 0.005", "decay 0.15", "volume 0.09", "f0 440",
    "f1 220", "end", "", "bgm loop1", "wave triangle", "volume 0.04", "step_sec 0.2",
    "loop false", "notes C3 E3 G3 R C4", "end",
  ].join("\n")
  let bundle1 = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  // Verify sound fields
  let s = bundle1.sounds[0]
  assert_eq(s.name, "zap")
  assert_eq(s.wave, "sawtooth")
  assert_eq(s.f0, 440)
  assert_eq(s.f1, 220)
  // Verify bgm fields
  let b = bundle1.bgms[0]
  assert_eq(b.name, "loop1")
  assert_eq(b.wave, "triangle")
  assert_eq(b.loop_, false)
  assert_eq(b.notes, [48, 52, 55, -1, 60])
  let redsl = encode_sound_and_bgm_blocks(bundle1.sounds, bundle1.bgms)
  let bundle2 = match @assets.parse_assets_dsl(redsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_eq(bundle2.sounds, bundle1.sounds)
  assert_eq(bundle2.bgms, bundle1.bgms)
}

///|
test "multiple sound and bgm blocks in one DSL" {
  let dsl = [
    "sound flap", "wave square", "attack 0.003", "decay 0.10", "volume 0.07", "f0 520",
    "f1 360", "end", "", "sound hit", "wave sawtooth", "attack 0.01", "decay 0.2",
    "volume 0.12", "f0 200", "f1 80", "end", "", "bgm main", "wave square", "volume 0.05",
    "step_sec 0.125", "loop true", "notes C4 E4 G4", "end", "", "bgm ambient", "wave sine",
    "volume 0.03", "step_sec 0.25", "loop true", "notes A3 C4", "end",
  ].join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  assert_eq(bundle.sounds.length(), 2)
  assert_eq(bundle.bgms.length(), 2)
  assert_eq(bundle.sounds[0].name, "flap")
  assert_eq(bundle.sounds[1].name, "hit")
  assert_eq(bundle.bgms[0].name, "main")
  assert_eq(bundle.bgms[1].name, "ambient")
  assert_eq(bundle.bgms[1].wave, "sine")
}

///|
test "parse tile block: pixel data and tile id mapping" {
  let row = "01234567"
  let rows8 = [row, row, row, row, row, row, row, row]
  let dsl = (["tile 0 a"] + rows8 + ["end", "tile 1 b"] + rows8 + ["end"]).join(
    "\n",
  )
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(e) => {
      println(e.message)
      panic()
    }
  }
  assert_eq(bundle.tilesets.length(), 1)
  let ts = bundle.tilesets[0]
  assert_eq(ts.name, "main")
  assert_eq(ts.tile_count, 256)
  assert_eq(ts.tile_names[0], "a")
  assert_eq(ts.tile_names[1], "b")
  assert_eq(ts.tile_solid[0], false)
  assert_eq(ts.tile_solid[1], false)
  assert_eq(ts.pixels.length(), 16384) // 256 * 8 * 8
  // tile 0 row 0: 01234567
  assert_eq(ts.pixels[0], 0)
  assert_eq(ts.pixels[7], 7)
  // tile 1 starts at offset 64
  assert_eq(ts.pixels[64], 0)
}

///|
test "parse tileset block: solid attribute per tile" {
  let row = "00000000"
  let rows8 = [row, row, row, row, row, row, row, row]
  let dsl = (["tile 0 floor solid"] +
  rows8 +
  ["end", "tile 1 deco"] +
  rows8 +
  ["end"]).join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  let ts = bundle.tilesets[0]
  assert_eq(ts.tile_names[0], "floor")
  assert_eq(ts.tile_names[1], "deco")
  assert_eq(ts.tile_solid[0], true)
  assert_eq(ts.tile_solid[1], false)
}

///|
test "parse tilemap block: tile IDs" {
  let tile_row = "00000000"
  let tile_rows = [
    tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row,
  ]
  let dsl = (["tile 0 solid"] +
  tile_rows +
  ["end", "tilemap m 3 2", "0 0 0", "0 . 0", "end"]).join("\n")
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(e) => {
      println(e.message)
      panic()
    }
  }
  assert_eq(bundle.tilemaps.length(), 1)
  let tm = bundle.tilemaps[0]
  assert_eq(tm.name, "m")
  assert_eq(tm.tileset, "main")
  assert_eq(tm.width, 3)
  assert_eq(tm.height, 2)
  assert_eq(tm.tiles, [0, 0, 0, 0, -1, 0])
}

///|
test "tilemap transparent cell must use dot token" {
  let tile_row = "00000000"
  let tile_rows = [
    tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row,
  ]
  let dsl = (["tile 0 solid"] +
  tile_rows +
  ["end", "tilemap m 2 1", "0 -1", "end"]).join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("transparent cell must be `.`") is Some(_))
}

///|
test "tileset directive is removed (no legacy compatibility)" {
  let dsl = ["tileset 1", "end"].join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("unknown directive: tileset") is Some(_))
}

///|
test "tilemap validation: tile ID out of range is an error" {
  let tile_row = "00000000"
  let tile_rows = [
    tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row, tile_row,
  ]
  let dsl = (["tile 0 solid"] +
  tile_rows +
  ["end", "tilemap m 2 1", "0 999", "end"]).join("\n")
  let e = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_true(e.message.find("out of range") is Some(_))
}

///|
test "tileset_tile_pixel returns correct color index" {
  // tile 0: all zeros, tile 1: all sevens
  let tile0 = "00000000"
  let tile1 = "77777777"
  let rows0 = [tile0, tile0, tile0, tile0, tile0, tile0, tile0, tile0]
  let rows1 = [tile1, tile1, tile1, tile1, tile1, tile1, tile1, tile1]
  let dsl = (["tile 0 low"] + rows0 + ["end", "tile 1 high"] + rows1 + ["end"]).join(
    "\n",
  )
  let bundle = match @assets.parse_assets_dsl(dsl) {
    Ok(v) => v
    Err(_) => panic()
  }
  let ts = bundle.tilesets[0]
  assert_eq(@model.tileset_tile_pixel(ts, 0, 0, 0), Some(0))
  assert_eq(@model.tileset_tile_pixel(ts, 0, 7, 7), Some(0))
  assert_eq(@model.tileset_tile_pixel(ts, 1, 0, 0), Some(7))
  assert_eq(@model.tileset_tile_pixel(ts, 1, 7, 7), Some(7))
  assert_eq(@model.tileset_tile_pixel(ts, 999, 0, 0), None) // out of range
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
