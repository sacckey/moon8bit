///|
type DslError = @model.DslError

///|
type Palette = @model.Palette

///|
type Sprite = @model.Sprite

///|
type Tiles = @model.Tiles

///|
type Tilemap = @model.Tilemap

///|
type Placement = @model.Placement

///|
type SoundDef = @model.SoundDef

///|
type BgmDef = @model.BgmDef

///|
type AssetBundle = @model.AssetBundle

///|
fn palette_default() -> Palette {
  @model.palette_default()
}

///|
fn[T] err(line : Int, message : String) -> Result[T, DslError] {
  Err(DslError::{ line, message })
}

///|
fn normalize_line(line : String) -> String {
  line.trim().to_string()
}

///|
fn is_ignorable_line(line : String) -> Bool {
  if line.length() == 0 {
    true
  } else {
    line.unsafe_get(0) == '#'
  }
}

///|
fn split_ws(line : String) -> Array[String] {
  line
  .split(" ")
  .map(StringView::to_string)
  .filter(token => token != "")
  .collect()
}

///|
fn parse_int_token(
  token : String,
  line : Int,
  field : String,
) -> Result[Int, DslError] {
  try @string.parse_int(token[:]) |> Ok catch {
    _ => err(line, "invalid integer for \{field}: \{token}")
  }
}

///|
fn decode_pixel_symbol(ch : Char) -> Int? {
  if ch == '.' {
    Some(-1)
  } else if ch is ('0'..='9') {
    Some(ch.to_int() - '0'.to_int())
  } else if ch is ('a'..='f') {
    Some(10 + ch.to_int() - 'a'.to_int())
  } else if ch is ('A'..='F') {
    Some(10 + ch.to_int() - 'A'.to_int())
  } else {
    None
  }
}

///|
fn is_supported_sprite_axis(size : Int) -> Bool {
  size == 8 || size == 16 || size == 32
}

///|
fn parse_palette_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[(Palette, Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() != 2 {
    return err(header_line, "palette header must be: palette <name>")
  }

  let colors : Array[String] = []
  let name = header[1]
  let mut cursor = start_line_index + 1

  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      return Ok((Palette::{ name, colors }, cursor + 1))
    }

    let tokens = split_ws(raw)
    if tokens.length() != 3 || tokens[0] != "color" {
      return err(line_no, "palette row must be: color <index> <hex>")
    }

    let idx = match parse_int_token(tokens[1], line_no, "palette index") {
      Ok(v) => v
      Err(e) => return Err(e)
    }
    if idx < 0 || idx > 255 {
      return err(line_no, "palette index must be in 0..255")
    }
    if idx != colors.length() {
      return err(
        line_no,
        "palette index must be sequential: expected \{colors.length()}, got \{idx}",
      )
    }

    colors.push(tokens[2])
    cursor += 1
  }

  err(header_line, "palette block is missing `end`")
}

///|
fn parse_sprite_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[(Sprite, Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() != 4 {
    return err(
      header_line, "sprite header must be: sprite <name> <width> <height>",
    )
  }

  let width = match parse_int_token(header[2], header_line, "sprite width") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let height = match parse_int_token(header[3], header_line, "sprite height") {
    Ok(v) => v
    Err(e) => return Err(e)
  }

  if width <= 0 || height <= 0 {
    return err(header_line, "sprite width/height must be positive")
  }
  if !is_supported_sprite_axis(width) || !is_supported_sprite_axis(height) {
    return err(
      header_line, "sprite width/height must each be one of: 8, 16, 32",
    )
  }

  let pixels : Array[Int] = []
  let mut row_count = 0
  let mut cursor = start_line_index + 1

  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      if row_count != height {
        return err(
          line_no,
          "sprite \{header[1]} expects \{height} rows, got \{row_count}",
        )
      }
      return Ok(
        (Sprite::{ name: header[1], width, height, pixels }, cursor + 1),
      )
    }

    if row_count >= height {
      return err(line_no, "sprite has too many rows")
    }

    if raw.length() != width {
      return err(
        line_no,
        "sprite row width mismatch: expected \{width}, got \{raw.length()}",
      )
    }

    for _, ch in raw {
      let value = match decode_pixel_symbol(ch) {
        Some(v) => v
        None =>
          return err(
            line_no,
            "unsupported sprite symbol: \{ch.to_string()} (use .,0-9,a-f)",
          )
      }
      pixels.push(value)
    }

    row_count += 1
    cursor += 1
  }

  err(header_line, "sprite block is missing `end`")
}

///|
fn parse_tile_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[((Int, String, Bool, Array[Int]), Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() < 2 {
    return err(header_line, "tile header must be: tile <id> [name] [solid]")
  }
  let tile_id = match parse_int_token(header[1], header_line, "tile id") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if tile_id < 0 || tile_id >= 256 {
    return err(header_line, "tile id must be in 0..255")
  }
  let mut tile_name = "tile_\{tile_id.to_string()}"
  let mut has_name = false
  let mut tile_solid = false
  if header.length() > 2 {
    for token in header[2:] {
      if token == "solid" {
        tile_solid = true
      } else if !has_name {
        tile_name = token
        has_name = true
      } else {
        return err(
          header_line,
          "unknown tile attribute: \{token} (supported: <name> and solid)",
        )
      }
    }
  }

  let pixels : Array[Int] = []
  let mut cursor = start_line_index + 1
  let mut row_count = 0
  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      if row_count != 8 {
        return err(
          line_no,
          "tile \{tile_id.to_string()} expects 8 rows, got \{row_count}",
        )
      }
      return Ok(((tile_id, tile_name, tile_solid, pixels), cursor + 1))
    }
    if row_count >= 8 {
      return err(line_no, "tile \{tile_id.to_string()} has too many rows")
    }
    if raw.length() != 8 {
      return err(
        line_no,
        "tile row must be exactly 8 characters wide, got \{raw.length()}",
      )
    }
    for _, ch in raw {
      let value = match decode_pixel_symbol(ch) {
        Some(v) => v
        None =>
          return err(
            line_no,
            "unsupported tile symbol: \{ch.to_string()} (use .,0-9,a-f)",
          )
      }
      pixels.push(value)
    }
    row_count += 1
    cursor += 1
  }
  err(header_line, "tile block is missing `end`")
}

///|
fn parse_tilemap_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[(Tilemap, Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() != 4 {
    return err(
      header_line, "tilemap header must be: tilemap <name> <width> <height>",
    )
  }
  let name = header[1]
  let width = match parse_int_token(header[2], header_line, "tilemap width") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let height = match parse_int_token(header[3], header_line, "tilemap height") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if width <= 0 || height <= 0 {
    return err(header_line, "tilemap width/height must be positive")
  }
  let tiles : Array[Int] = []
  let mut row_count = 0
  let mut cursor = start_line_index + 1
  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      if row_count != height {
        return err(
          line_no,
          "tilemap \{name} expects \{height} rows, got \{row_count}",
        )
      }
      return Ok((Tilemap::{ name, width, height, tiles }, cursor + 1))
    }
    if row_count >= height {
      return err(line_no, "tilemap has too many rows")
    }
    let row_tokens = split_ws(raw)
    if row_tokens.length() != width {
      return err(
        line_no,
        "tilemap row width mismatch: expected \{width}, got \{row_tokens.length()}",
      )
    }
    for token in row_tokens {
      let value = if token == "." {
        -1
      } else {
        let parsed = match parse_int_token(token, line_no, "tile id") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        if parsed == -1 {
          return err(
            line_no, "tilemap transparent cell must be `.` (do not use -1)",
          )
        }
        parsed
      }
      tiles.push(value)
    }
    row_count += 1
    cursor += 1
  }
  err(header_line, "tilemap block is missing `end`")
}

///|
fn parse_placement_line(
  header : Array[String],
  line_no : Int,
) -> Result[Placement, DslError] {
  if header.length() != 5 {
    return err(
      line_no, "place directive must be: place <name> <sprite> <x> <y>",
    )
  }
  let x = match parse_int_token(header[3], line_no, "placement x") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  let y = match parse_int_token(header[4], line_no, "placement y") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  Ok(Placement::{ name: header[1], sprite: header[2], x, y })
}

///|
fn parse_double_token(
  token : String,
  line : Int,
  field : String,
) -> Result[Double, DslError] {
  try @string.parse_double(token[:]) |> Ok catch {
    _ => err(line, "invalid number for \{field}: \{token}")
  }
}

///|
fn parse_wave_token(token : String, line : Int) -> Result[String, DslError] {
  match token {
    "sine" | "square" | "triangle" | "sawtooth" => Ok(token)
    _ =>
      err(
        line,
        "invalid wave: \{token} (expected sine/square/triangle/sawtooth)",
      )
  }
}

///|
fn note_name_to_midi(name : String, line : Int) -> Result[Int, DslError] {
  // Supports:
  // - White keys: C D E F G A B
  // - Accidentals: # / b (e.g. C#4, Db4)
  // - Rest: R
  // MIDI: C4 = 60
  if name == "R" {
    return Ok(-1) // rest
  }
  if name.length() < 2 {
    return err(line, "invalid note: \{name} (expected e.g. C4, C#4, Db4, R)")
  }
  let letter = name.unsafe_get(0)
  let mut semitone = match letter {
    'C' => 0
    'D' => 2
    'E' => 4
    'F' => 5
    'G' => 7
    'A' => 9
    'B' => 11
    _ =>
      return err(
        line,
        "invalid note name: \{letter.to_string()} (use C D E F G A B with optional #/b, or R)",
      )
  }
  let mut octave_start = 1
  if name.length() >= 3 {
    let accidental = name.unsafe_get(1)
    if accidental == '#' {
      semitone += 1
      octave_start = 2
    } else if accidental == 'b' {
      semitone -= 1
      octave_start = 2
    }
  }
  if octave_start >= name.length() {
    return err(
      line,
      "invalid note: \{name} (missing octave, expected e.g. C4, C#4, Db4)",
    )
  }
  semitone = (semitone % 12 + 12) % 12
  let octave_str = name[octave_start:].to_string()
  let octave = match parse_int_token(octave_str, line, "octave") {
    Ok(v) => v
    Err(e) => return Err(e)
  }
  if octave < 0 || octave > 9 {
    return err(line, "octave out of range: \{octave} (expected 0..9)")
  }
  Ok(12 * (octave + 1) + semitone)
}

///|
fn parse_sound_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[(SoundDef, Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() != 2 {
    return err(header_line, "sound header must be: sound <name>")
  }
  let name = header[1]
  let mut wave = "square"
  let mut attack = 0.003
  let mut decay = 0.10
  let mut volume = 0.07
  let mut f0 = 520
  let mut f1 = 360
  let mut cursor = start_line_index + 1
  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      return Ok(
        (SoundDef::{ name, wave, attack, decay, volume, f0, f1 }, cursor + 1),
      )
    }
    let tokens = split_ws(raw)
    if tokens.length() < 2 {
      return err(line_no, "sound field must be: <key> <value>")
    }
    match tokens[0] {
      "wave" =>
        wave = match parse_wave_token(tokens[1], line_no) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "attack" =>
        attack = match parse_double_token(tokens[1], line_no, "attack") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "decay" =>
        decay = match parse_double_token(tokens[1], line_no, "decay") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "volume" | "peak" =>
        volume = match parse_double_token(tokens[1], line_no, "volume") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "f0" =>
        f0 = match parse_int_token(tokens[1], line_no, "f0") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "f1" =>
        f1 = match parse_int_token(tokens[1], line_no, "f1") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      _ => return err(line_no, "unknown sound field: \{tokens[0]}")
    }
    cursor += 1
  }
  err(header_line, "sound block is missing `end`")
}

///|
fn parse_bgm_block(
  lines : Array[String],
  header : Array[String],
  start_line_index : Int,
) -> Result[(BgmDef, Int), DslError] {
  let header_line = start_line_index + 1
  if header.length() != 2 {
    return err(header_line, "bgm header must be: bgm <name>")
  }
  let name = header[1]
  let mut wave = "square"
  let mut volume = 0.05
  let mut step_sec = 0.125
  let mut loop_ = true
  let mut notes : Array[Int] = []
  let mut cursor = start_line_index + 1
  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    let line_no = cursor + 1
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }
    if raw == "end" {
      return Ok(
        (BgmDef::{ name, wave, volume, step_sec, loop_, notes }, cursor + 1),
      )
    }
    let tokens = split_ws(raw)
    if tokens.length() < 2 {
      return err(line_no, "bgm field must be: <key> <value>")
    }
    match tokens[0] {
      "wave" =>
        wave = match parse_wave_token(tokens[1], line_no) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "volume" =>
        volume = match parse_double_token(tokens[1], line_no, "volume") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "step_sec" =>
        step_sec = match parse_double_token(tokens[1], line_no, "step_sec") {
          Ok(v) => v
          Err(e) => return Err(e)
        }
      "loop" =>
        loop_ = match tokens[1] {
          "true" => true
          "false" => false
          _ => return err(line_no, "loop must be true or false")
        }
      "notes" => {
        let note_tokens = tokens[1:]
        let parsed : Array[Int] = []
        for token in note_tokens {
          match note_name_to_midi(token.to_string(), line_no) {
            Ok(midi) => parsed.push(midi)
            Err(e) => return Err(e)
          }
        }
        notes = parsed
      }
      _ => return err(line_no, "unknown bgm field: \{tokens[0]}")
    }
    cursor += 1
  }
  err(header_line, "bgm block is missing `end`")
}

///|
pub fn parse_assets_dsl(input : String) -> Result[AssetBundle, DslError] {
  let normalized = input
    .replace_all(old="\r\n", new="\n")
    .replace_all(old="\r", new="\n")
  let lines : Array[String] = normalized
    .split("\n")
    .map(StringView::to_string)
    .collect()

  let mut palette : Palette? = None
  let sprites : Array[Sprite] = []
  let tilemaps : Array[Tilemap] = []
  let tilemap_header_lines : Array[Int] = []
  let placements : Array[Placement] = []
  let placement_lines : Array[Int] = []
  let sounds : Array[SoundDef] = []
  let bgms : Array[BgmDef] = []
  let tile_count = 256
  let tile_names : Array[String] = []
  let tile_solid : Array[Bool] = []
  let tile_pixels : Array[Int] = []
  for i in 0..<tile_count {
    tile_names.push("tile_\{i.to_string()}")
    tile_solid.push(false)
  }
  for _ in 0..<(tile_count * 64) {
    tile_pixels.push(-1)
  }

  let mut cursor = 0
  while cursor < lines.length() {
    let raw = normalize_line(lines[cursor])
    if is_ignorable_line(raw) {
      cursor += 1
      continue
    }

    let tokens = split_ws(raw)
    if tokens.length() == 0 {
      cursor += 1
      continue
    }

    match tokens[0] {
      "palette" => {
        if palette is Some(_) {
          return err(cursor + 1, "palette can only be defined once")
        }
        let parsed = match parse_palette_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        palette = Some(parsed.0)
        cursor = parsed.1
      }
      "sprite" => {
        let parsed = match parse_sprite_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        sprites.push(parsed.0)
        cursor = parsed.1
      }
      "tile" => {
        let parsed = match parse_tile_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        let tile_id = parsed.0.0
        tile_names[tile_id] = parsed.0.1
        tile_solid[tile_id] = parsed.0.2
        let base = tile_id * 64
        for i in 0..<64 {
          tile_pixels[base + i] = parsed.0.3[i]
        }
        cursor = parsed.1
      }
      "tilemap" => {
        let header_line = cursor + 1
        let parsed = match parse_tilemap_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        tilemaps.push(parsed.0)
        tilemap_header_lines.push(header_line)
        cursor = parsed.1
      }
      "place" => {
        let line_no = cursor + 1
        let parsed = match parse_placement_line(tokens, line_no) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        placements.push(parsed)
        placement_lines.push(line_no)
        cursor += 1
      }
      "sound" => {
        let parsed = match parse_sound_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        sounds.push(parsed.0)
        cursor = parsed.1
      }
      "bgm" => {
        let parsed = match parse_bgm_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        bgms.push(parsed.0)
        cursor = parsed.1
      }
      _ => return err(cursor + 1, "unknown directive: \{tokens[0]}")
    }
  }

  // Post-parse: validate tile IDs against fixed 0..255 tile IDs.
  for i in 0..<tilemaps.length() {
    let tm = tilemaps[i]
    let header_line = tilemap_header_lines[i]
    for j in 0..<tm.tiles.length() {
      let tile_id = tm.tiles[j]
      if tile_id != -1 && (tile_id < 0 || tile_id >= tile_count) {
        let row = j / tm.width
        let col = j % tm.width
        return err(
          header_line,
          "tilemap '\{tm.name}': tile ID \{tile_id} at (\{col}, \{row}) out of range (valid: 0..255)",
        )
      }
    }
  }

  // Validate placement sprite references.
  for i in 0..<placements.length() {
    let placement = placements[i]
    let line_no = placement_lines[i]
    let mut found = false
    for sprite in sprites {
      if sprite.name == placement.sprite {
        found = true
        break
      }
    }
    if !found {
      return err(
        line_no,
        "placement '\{placement.name}' references unknown sprite: \{placement.sprite}",
      )
    }
  }

  Ok(AssetBundle::{
    palette: match palette {
      Some(p) => p
      None => palette_default()
    },
    sprites,
    tiles: Tiles::{
      name: "main",
      tile_count,
      tile_names,
      tile_solid,
      pixels: tile_pixels,
    },
    tilemaps,
    placements,
    sounds,
    bgms,
  })
}
