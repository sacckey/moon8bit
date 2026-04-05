///|
struct GameSoundEvents {
  flap : String
  reset : String
  hit : String
}

///|
struct WebGameSpec {
  id : String
  title : String
  status_text : String
  export_filename : String
  default_assets_dsl : String
  sound_events : GameSoundEvents
}

///|
enum WebGame {
  Driftbird(@lib.DriftbirdGame)
}

///|
let driftbird_sound_events : GameSoundEvents = {
  flap: "flap",
  reset: "reset",
  hit: "hit",
}

///|
let driftbird_spec : WebGameSpec = {
  id: "driftbird",
  title: "Driftbird",
  status_text: "HUD is in-canvas (S/F/H). Audio events are configurable in Sound tab.",
  export_filename: "driftbird_assets.dsl",
  default_assets_dsl: @lib.sample_assets_dsl(),
  sound_events: driftbird_sound_events,
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
fn game_started(game : WebGame) -> Bool {
  match game {
    Driftbird(inner) => inner.is_started()
  }
}

///|
fn game_over(game : WebGame) -> Bool {
  match game {
    Driftbird(inner) => inner.is_over()
  }
}
