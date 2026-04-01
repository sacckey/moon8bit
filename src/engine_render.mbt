///|
pub struct Frame {
  width : Int
  height : Int
  pixels : Array[Int]
} derive(Eq, Show)

///|
fn palette_index_to_glyph(index : Int) -> String {
  match index {
    -1 => "."
    0 => " "
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "a"
    11 => "b"
    12 => "c"
    13 => "d"
    14 => "e"
    15 => "f"
    _ => "*"
  }
}

///|
pub fn Frame::new(width : Int, height : Int, fill? : Int = -1) -> Frame {
  Frame::{ width, height, pixels: Array::make(width * height, fill) }
}

///|
pub fn Frame::clear(self : Frame, color : Int) -> Unit {
  for i in 0..<self.pixels.length() {
    self.pixels[i] = color
  }
}

///|
pub fn Frame::set_pixel(self : Frame, x : Int, y : Int, color : Int) -> Unit {
  if x < 0 || x >= self.width || y < 0 || y >= self.height {
    return
  }
  let idx = y * self.width + x
  self.pixels[idx] = color
}

///|
pub fn Frame::get_pixel(self : Frame, x : Int, y : Int) -> Int? {
  if x < 0 || x >= self.width || y < 0 || y >= self.height {
    None
  } else {
    let idx = y * self.width + x
    Some(self.pixels[idx])
  }
}

///|
pub fn Frame::draw_rect(
  self : Frame,
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  color : Int,
) -> Unit {
  for py in y..<(y + h) {
    for px in x..<(x + w) {
      self.set_pixel(px, py, color)
    }
  }
}

///|
pub fn Frame::blit(self : Frame, sprite : Sprite, x : Int, y : Int) -> Unit {
  for sy in 0..<sprite.height {
    for sx in 0..<sprite.width {
      let idx = sy * sprite.width + sx
      let color = sprite.pixels[idx]
      if color >= 0 {
        self.set_pixel(x + sx, y + sy, color)
      }
    }
  }
}

///|
pub fn Frame::to_ascii(self : Frame) -> String {
  let out = StringBuilder::new(size_hint=self.width * self.height + self.height)
  for y in 0..<self.height {
    for x in 0..<self.width {
      let idx = y * self.width + x
      out.write_string(palette_index_to_glyph(self.pixels[idx]))
    }
    if y + 1 < self.height {
      out.write_string("\n")
    }
  }
  out.to_string()
}
