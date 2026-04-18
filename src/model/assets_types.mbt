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
/// Tile definitions hold inline 8×8 pixel tiles stored row-major per tile.
/// `pixels` length = tile_count × 64.  Pixel values follow the same
/// convention as Sprite: -1 = transparent, 0–N = palette index.
pub(all) struct Tiles {
  name : String
  tile_count : Int
  tile_names : Array[String]
  tile_solid : Array[Bool]
  pixels : Array[Int]
} derive(Eq, Show)

///|
/// A tilemap stores a 2-D grid of tile IDs.
/// Internally, tile ID -1 = empty (transparent).
/// In DSL source, transparent cell is written as `.`.
/// All other IDs must be in [0, tile_count).
pub(all) struct Tilemap {
  name : String
  width : Int
  height : Int
  tiles : Array[Int]
} derive(Eq, Show)

///|
pub(all) struct Placement {
  name : String
  sprite : String
  x : Int
  y : Int
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
  tiles : Tiles
  tilemaps : Array[Tilemap]
  placements : Array[Placement]
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
/// Get the pixel value at (x, y) within tile `tile_id`.
/// Returns None for out-of-range tile_id or coordinates.
pub fn tile_pixel(tiles : Tiles, tile_id : Int, x : Int, y : Int) -> Int? {
  if tile_id < 0 || tile_id >= tiles.tile_count {
    return None
  }
  if x < 0 || x >= 8 || y < 0 || y >= 8 {
    return None
  }
  let idx = tile_id * 64 + y * 8 + x
  Some(tiles.pixels[idx])
}

///|
/// Whether tile `tile_id` is marked as solid.
/// Returns false for out-of-range IDs.
pub fn tile_solid(tiles : Tiles, tile_id : Int) -> Bool {
  if tile_id < 0 || tile_id >= tiles.tile_count {
    return false
  }
  if tile_id < tiles.tile_solid.length() {
    tiles.tile_solid[tile_id]
  } else {
    false
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

///|
pub fn find_placements_by_sprite(
  bundle : AssetBundle,
  sprite_name : String,
) -> Array[Placement] {
  let placements : Array[Placement] = []
  for placement in bundle.placements {
    if placement.sprite == sprite_name {
      placements.push(placement)
    }
  }
  placements
}
