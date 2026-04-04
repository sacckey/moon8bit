///|
test "font uses 8x8 cell width with scaling" {
  assert_eq(@font.text_width(""), 0)
  assert_eq(@font.text_width("A1"), 16)
  assert_eq(@font.text_width("A1", scale=2), 32)
  assert_eq(@font.text_width("A1", scale=0), 0)
}

///|
test "font draws ascii glyphs in 8x8 cells with top padding" {
  let frame = @model.Frame::new(24, 12, fill=-1)
  @font.draw_text(frame, 0, 0, "A1", 5)

  assert_eq(frame.get_pixel(3, 1), Some(5))
  assert_eq(frame.get_pixel(2, 2), Some(5))
  assert_eq(frame.get_pixel(11, 1), Some(5))

  let scaled = @model.Frame::new(24, 20, fill=-1)
  @font.draw_text(scaled, 0, 0, "A", 6, scale=2)
  assert_eq(scaled.get_pixel(6, 2), Some(6))
  assert_eq(scaled.get_pixel(4, 4), Some(6))
  assert_eq(scaled.get_pixel(0, 0), Some(-1))
}

///|
test "font covers printable ascii" {
  for code in 33..<127 {
    let ch = code.unsafe_to_char()
    let text = String::from_array([ch])
    let frame = @model.Frame::new(8, 8, fill=-1)
    @font.draw_text(frame, 0, 0, text, 7)

    let mut lit = false
    for y in 0..<8 {
      for x in 0..<8 {
        if frame.get_pixel(x, y) == Some(7) {
          lit = true
        }
      }
    }
    assert_true(lit)
  }
}
