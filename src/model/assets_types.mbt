///|
pub(all) struct Palette {
  name : String
  colors : Array[String]
} derive(Eq, Show)

///|
pub(all) struct Sprite {
  name : String
  width : Int
  height : Int
  pixels : Array[Int]
} derive(Eq, Show)

///|
/// A tileset holds inline 8×8 pixel tiles stored row-major per tile.
/// `pixels` length = tile_count × 64.  Pixel values follow the same
/// convention as Sprite: -1 = transparent, 0–N = palette index.
pub(all) struct Tileset {
  name : String
  tile_count : Int
  tile_names : Array[String]
  pixels : Array[Int]
} derive(Eq, Show)

///|
/// A tilemap stores a 2-D grid of tile IDs.
/// Internally, tile ID -1 = empty (transparent).
/// In DSL source, transparent cell is written as `.`.
/// All other IDs must be in [0, tile_count).
pub(all) struct Tilemap {
  name : String
  tileset : String
  width : Int
  height : Int
  tiles : Array[Int]
} derive(Eq, Show)

///|
pub(all) struct SoundDef {
  name : String
  wave : String
  attack : Double
  decay : Double
  volume : Double
  f0 : Int
  f1 : Int
} derive(Eq, Show)

///|
pub(all) struct BgmDef {
  name : String
  wave : String
  volume : Double
  step_sec : Double
  loop_ : Bool
  notes : Array[Int]
} derive(Eq, Show)

///|
pub(all) struct AssetBundle {
  palette : Palette
  sprites : Array[Sprite]
  tilesets : Array[Tileset]
  tilemaps : Array[Tilemap]
  sounds : Array[SoundDef]
  bgms : Array[BgmDef]
} derive(Eq, Show)

///|
pub(all) struct DslError {
  line : Int
  message : String
} derive(Eq, Show)

///|
pub fn find_sound(bundle : AssetBundle, name : String) -> SoundDef? {
  for s in bundle.sounds {
    if s.name == name {
      return Some(s)
    }
  }
  None
}

///|
pub fn find_bgm(bundle : AssetBundle, name : String) -> BgmDef? {
  for b in bundle.bgms {
    if b.name == name {
      return Some(b)
    }
  }
  None
}

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
/// Get the pixel value at (x, y) within tile `tile_id` of a tileset.
/// Returns None for out-of-range tile_id or coordinates.
pub fn tileset_tile_pixel(
  tileset : Tileset,
  tile_id : Int,
  x : Int,
  y : Int,
) -> Int? {
  if tile_id < 0 || tile_id >= tileset.tile_count {
    return None
  }
  if x < 0 || x >= 8 || y < 0 || y >= 8 {
    return None
  }
  let idx = tile_id * 64 + y * 8 + x
  Some(tileset.pixels[idx])
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
pub fn find_tileset(bundle : AssetBundle, name : String) -> Tileset? {
  for ts in bundle.tilesets {
    if ts.name == name {
      return Some(ts)
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
