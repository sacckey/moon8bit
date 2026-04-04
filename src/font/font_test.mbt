///|
test "font 5x7 width follows monospace formula" {
  assert_eq(@font.text_width(""), 0)
  assert_eq(@font.text_width("A1"), 11)
  assert_eq(@font.text_width("A1", scale=2), 22)
  assert_eq(@font.text_width("A1", scale=0), 0)
}

///|
test "font 5x7 draws ascii glyphs with nearest scaling" {
  let frame = @model.Frame::new(24, 12, fill=-1)
  @font.draw_text(frame, 0, 0, "A1", 5)

  assert_eq(frame.get_pixel(2, 0), Some(5))
  assert_eq(frame.get_pixel(1, 1), Some(5))
  assert_eq(frame.get_pixel(8, 0), Some(5))

  let scaled = @model.Frame::new(24, 20, fill=-1)
  @font.draw_text(scaled, 0, 0, "A", 6, scale=2)
  assert_eq(scaled.get_pixel(4, 0), Some(6))
  assert_eq(scaled.get_pixel(5, 1), Some(6))
  assert_eq(scaled.get_pixel(0, 0), Some(-1))
}

///|
test "font 5x7 covers printable ascii" {
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
