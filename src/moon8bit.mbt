///|
pub fn version_tag() -> String {
  "moon8bit-v0.1-mvp"
}

///|
pub fn assets_cli_output(dsl : String) -> String {
  match parse_assets_dsl_to_json_string(dsl) {
    Ok(json) => json
    Err(error) => "error(line=\{error.line}): \{error.message}"
  }
}

///|
pub fn demo_snapshot(frame_count : Int) -> String {
  let safe_count = if frame_count <= 0 { 1 } else { frame_count }
  let (_, ascii_frames) = run_driftbird_demo(safe_count)
  if ascii_frames.length() == 0 {
    ""
  } else {
    ascii_frames[ascii_frames.length() - 1]
  }
}
