///|
pub type DriftbirdNightGame = @driftbird.DriftbirdGame

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
  frame_index : Int,
) -> (DriftbirdNightGame, Frame) {
  @driftbird.step_game(game, config, input, frame_index)
}

///|
pub fn step_audio_events(
  previous : DriftbirdNightGame,
  next : DriftbirdNightGame,
  input : InputState,
) -> Array[String] {
  @driftbird.step_audio_events(previous, next, input)
}
