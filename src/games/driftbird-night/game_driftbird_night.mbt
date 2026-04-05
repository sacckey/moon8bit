///|
pub type DriftbirdNightGame = @driftbird.DriftbirdRuntime

///|
type AssetBundle = @model.AssetBundle

///|
type EngineConfig = @model.EngineConfig

///|
type InputState = @model.InputState

///|
type Frame = @model.Frame

///|
pub fn init_game(
  bundle : AssetBundle,
  config : EngineConfig,
) -> DriftbirdNightGame {
  @driftbird.init_game(bundle, config)
}

///|
pub fn step_game(
  game : DriftbirdNightGame,
  config : EngineConfig,
  input : InputState,
) -> (DriftbirdNightGame, Frame) {
  @driftbird.step_game(game, config, input)
}

///|
pub fn step_audio_events(
  previous : DriftbirdNightGame,
  next : DriftbirdNightGame,
  input : InputState,
) -> Array[String] {
  @driftbird.step_audio_events(previous, next, input)
}
