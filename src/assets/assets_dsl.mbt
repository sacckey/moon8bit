///|
type DslError = @model.DslError

///|
type Palette = @model.Palette

///|
type Sprite = @model.Sprite

///|
type Tilemap = @model.Tilemap

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
  try @strconv.parse_int(token) |> Ok catch {
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
          "tilemap \{header[1]} expects \{height} rows, got \{row_count}",
        )
      }
      return Ok(
        (Tilemap::{ name: header[1], width, height, tiles }, cursor + 1),
      )
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
      let value = match parse_int_token(token, line_no, "tile id") {
        Ok(v) => v
        Err(e) => return Err(e)
      }
      if value < 0 {
        return err(line_no, "tile id must be >= 0")
      }
      tiles.push(value)
    }

    row_count += 1
    cursor += 1
  }

  err(header_line, "tilemap block is missing `end`")
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
      "tilemap" => {
        let parsed = match parse_tilemap_block(lines, tokens, cursor) {
          Ok(v) => v
          Err(e) => return Err(e)
        }
        tilemaps.push(parsed.0)
        cursor = parsed.1
      }
      _ => return err(cursor + 1, "unknown directive: \{tokens[0]}")
    }
  }

  Ok(AssetBundle::{
    palette: match palette {
      Some(p) => p
      None => palette_default()
    },
    sprites,
    tilemaps,
  })
}
