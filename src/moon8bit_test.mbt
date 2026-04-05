///|

///|
fn test_bundle() -> AssetBundle {
  let dsl = [
    "palette t", "color 0 #000000", "color 1 #111111", "color 2 #222222", "color 3 #333333",
    "color 4 #444444", "color 5 #555555", "color 6 #666666", "color 7 #777777", "end",
    "", "sprite bird 8 8", "33333333", "33333333", "33333333", "33333333", "33333333",
    "33333333", "33333333", "33333333", "end",
  ].join("\n")
  match parse_assets_dsl(dsl) {
    Ok(bundle) => bundle
    Err(_) => panic()
  }
}

///|
test "root facade exposes metadata and defaults" {
  assert_eq(version_tag(), "moon8bit-v0.1-mvp")

  let cfg = default_engine_config()
  assert_eq(cfg.width, 256)
  assert_eq(cfg.height, 144)
  assert_eq(cfg.fps, 60)
}

///|
test "assets cli output covers success and parse errors" {
  let ok = assets_cli_output(["tilemap m 1 1", "3", "end"].join("\n"))
  assert_true(ok.find("\"tilemaps\"") is Some(_))

  let ng = assets_cli_output(["sprite s 8 8", "g.......", "end"].join("\n"))
  assert_true(ng.find("error(line=2):") is Some(_))
}

///|
test "root facade runs driftbird demo" {
  let (state, frames) = run_driftbird_demo(test_bundle(), 24)
  assert_eq(frames.length(), 24)
  assert_true(state.score() >= 0)
  assert_true(frames[23].length() > 0)
}

///|
test "root facade exposes collision helpers" {
  let bird = collider_box("bird", 5, 5, 3, 3)
  let obstacles = [
    collider_box("pipe_top", 0, 0, 3, 3),
    collider_box("pipe_bottom", 6, 6, 4, 4),
  ]

  assert_true(collider_hits_any(bird, obstacles))
  let hit = match collider_first_hit(bird, obstacles) {
    Some(v) => v
    None => panic()
  }
  assert_eq(hit.tag, "pipe_bottom")
}
