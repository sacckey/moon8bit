///|
struct WebGameSpec {
  id : String
  title : String
  status_text : String
  export_filename : String
  default_assets_dsl : String
}

///|
enum WebGame {
  Driftbird(@lib.DriftbirdGame)
}

///|
let driftbird_spec : WebGameSpec = {
  id: "driftbird",
  title: "Driftbird",
  status_text: "HUD is in-canvas (S/F/H). Audio events are configurable in Sound tab.",
  export_filename: "driftbird_assets.dsl",
  default_assets_dsl: @lib.sample_assets_dsl(),
}

///|
fn normalize_game_id(raw : String) -> String {
  let trimmed = raw.trim().to_string()
  if trimmed == "" {
    driftbird_spec.id
  } else {
    trimmed
  }
}

///|
fn resolve_game_spec(raw_game_id : String) -> WebGameSpec {
  let game_id = normalize_game_id(raw_game_id)
  if game_id == driftbird_spec.id {
    driftbird_spec
  } else {
    driftbird_spec
  }
}

///|
fn initial_bundle_for_spec(spec : WebGameSpec) -> @lib.AssetBundle {
  match @lib.parse_assets_dsl(spec.default_assets_dsl) {
    Ok(bundle) => bundle
    Err(_) => @lib.load_sample_assets()
  }
}

///|
fn init_web_game(
  spec : WebGameSpec,
  bundle : @lib.AssetBundle,
  config : @lib.EngineConfig,
) -> WebGame {
  if spec.id == driftbird_spec.id {
    WebGame::Driftbird(
      @lib.engine_init(@lib.new_driftbird_game(bundle), config),
    )
  } else {
    WebGame::Driftbird(
      @lib.engine_init(@lib.new_driftbird_game(bundle), config),
    )
  }
}

///|
fn step_web_game(
  game : WebGame,
  config : @lib.EngineConfig,
  input : @lib.InputState,
  frame_index : Int,
) -> (WebGame, @lib.Frame) {
  match game {
    Driftbird(inner) => {
      let (next, frame) = @lib.engine_step(inner, config, input, frame_index)
      (WebGame::Driftbird(next), frame)
    }
  }
}

///|
fn audio_events_for_step(
  previous : WebGame,
  next : WebGame,
  input : @lib.InputState,
) -> Array[String] {
  match (previous, next) {
    (Driftbird(prev), Driftbird(curr)) =>
      @driftbird.audio_events_for_step(prev, curr, input)
  }
}
