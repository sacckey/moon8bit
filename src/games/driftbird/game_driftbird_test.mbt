///|

///|
fn test_bundle() -> @model.AssetBundle {
  let pixels : Array[Int] = []
  for _ in 0..<64 {
    pixels.push(3)
  }

  @model.AssetBundle::{
    palette: @model.Palette::{
      name: "test",
      colors: [
        "#000000", "#111111", "#222222", "#333333", "#444444", "#555555", "#666666",
        "#777777",
      ],
    },
    sprites: [@model.Sprite::{ name: "bird", width: 8, height: 8, pixels }],
    tilemaps: [],
  }
}

///|
test "run_driftbird_demo returns requested frame count" {
  let bundle = test_bundle()
  let (state, frames) = @driftbird.run_driftbird_demo(bundle, 24)
  assert_eq(frames.length(), 24)
  assert_true(state.score() >= 0)
  assert_true(frames[23].length() > 0)
}

///|
test "driftbird waits for flap input before start" {
  let inputs = [@model.input_none, @model.input_none, @model.input_none]
  let (state, _) = @driftbird.run_driftbird(test_bundle(), inputs)

  assert_true(!state.is_started())
  assert_true(!state.is_over())
  assert_eq(state.score(), 0)
}

///|
test "driftbird restarts on flap after game over" {
  let inputs : Array[@model.InputState] = []
  inputs.push(@model.input_state(true, false))
  for _ in 0..<64 {
    inputs.push(@model.input_none)
  }
  inputs.push(@model.input_state(true, false))

  let (state, _) = @driftbird.run_driftbird(test_bundle(), inputs)
  assert_true(state.is_started())
  assert_true(!state.is_over())
}
