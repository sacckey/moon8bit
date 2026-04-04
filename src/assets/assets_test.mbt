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
test "sprite size must be 8/16/32 on each axis" {
  let dsl = ["sprite s 7 8", "end"].join("\n")
  let parse_err = match @assets.parse_assets_dsl(dsl) {
    Ok(_) => panic()
    Err(e) => e
  }
  assert_eq(parse_err.line, 1)
  assert_true(parse_err.message.find("one of: 8, 16, 32") is Some(_))
}
