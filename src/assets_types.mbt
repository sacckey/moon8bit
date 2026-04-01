///|
pub struct Palette {
  name : String
  colors : Array[String]
} derive(Eq, Show)

///|
pub struct Sprite {
  name : String
  width : Int
  height : Int
  pixels : Array[Int]
} derive(Eq, Show)

///|
pub struct Tilemap {
  name : String
  width : Int
  height : Int
  tiles : Array[Int]
} derive(Eq, Show)

///|
pub struct AssetBundle {
  palette : Palette
  sprites : Array[Sprite]
  tilemaps : Array[Tilemap]
} derive(Eq, Show)

///|
pub struct DslError {
  line : Int
  message : String
} derive(Eq, Show)

///|
pub fn palette_default() -> Palette {
  Palette::{
    name: "retro16",
    colors: [
      "#101820", "#1f4068", "#2e8b57", "#f2aa4c", "#e94f37", "#8f6f4f", "#f6f7eb",
      "#7f5af0",
    ],
  }
}

///|
pub fn sprite_pixel(sprite : Sprite, x : Int, y : Int) -> Int? {
  if x < 0 || x >= sprite.width || y < 0 || y >= sprite.height {
    None
  } else {
    let idx = y * sprite.width + x
    Some(sprite.pixels[idx])
  }
}

///|
pub fn tile_at(tilemap : Tilemap, x : Int, y : Int) -> Int? {
  if x < 0 || x >= tilemap.width || y < 0 || y >= tilemap.height {
    None
  } else {
    let idx = y * tilemap.width + x
    Some(tilemap.tiles[idx])
  }
}

///|
pub fn find_sprite(bundle : AssetBundle, name : String) -> Sprite? {
  for sprite in bundle.sprites {
    if sprite.name == name {
      return Some(sprite)
    }
  }
  None
}

///|
pub fn find_tilemap(bundle : AssetBundle, name : String) -> Tilemap? {
  for tilemap in bundle.tilemaps {
    if tilemap.name == name {
      return Some(tilemap)
    }
  }
  None
}
