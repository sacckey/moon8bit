///|
fn int_json(value : Int) -> Json {
  Json::number(value.to_double())
}

///|
fn int_array_json(values : Array[Int]) -> Json {
  Json::array(values.map(int_json))
}

///|
pub fn palette_to_json(palette : Palette) -> Json {
  let obj : Map[String, Json] = {
    "kind": Json::string("palette"),
    "name": Json::string(palette.name),
    "colors": Json::array(palette.colors.map(color => Json::string(color))),
  }
  Json::object(obj)
}

///|
pub fn sprite_to_json(sprite : Sprite) -> Json {
  let obj : Map[String, Json] = {
    "kind": Json::string("sprite"),
    "name": Json::string(sprite.name),
    "width": int_json(sprite.width),
    "height": int_json(sprite.height),
    "pixels": int_array_json(sprite.pixels),
  }
  Json::object(obj)
}

///|
pub fn tiles_to_json(tiles : Tiles) -> Json {
  let obj : Map[String, Json] = {
    "kind": Json::string("tiles"),
    "name": Json::string(tiles.name),
    "tile_count": int_json(tiles.tile_count),
    "tile_names": Json::array(tiles.tile_names.map(name => Json::string(name))),
    "tile_solid": Json::array(tiles.tile_solid.map(v => Json::boolean(v))),
    "pixels": int_array_json(tiles.pixels),
  }
  Json::object(obj)
}

///|
pub fn tilemap_to_json(tilemap : Tilemap) -> Json {
  let obj : Map[String, Json] = {
    "kind": Json::string("tilemap"),
    "name": Json::string(tilemap.name),
    "width": int_json(tilemap.width),
    "height": int_json(tilemap.height),
    "tiles": int_array_json(tilemap.tiles),
  }
  Json::object(obj)
}

///|
pub fn asset_bundle_to_json(bundle : AssetBundle) -> Json {
  let obj : Map[String, Json] = {
    "palette": palette_to_json(bundle.palette),
    "sprites": Json::array(bundle.sprites.map(sprite_to_json)),
    "tiles": tiles_to_json(bundle.tiles),
    "tilemaps": Json::array(bundle.tilemaps.map(tilemap_to_json)),
  }
  Json::object(obj)
}

///|
pub fn asset_bundle_to_json_string(bundle : AssetBundle) -> String {
  asset_bundle_to_json(bundle).stringify(indent=2)
}

///|
pub fn parse_assets_dsl_to_json_string(
  input : String,
) -> Result[String, DslError] {
  match parse_assets_dsl(input) {
    Ok(bundle) => Ok(asset_bundle_to_json_string(bundle))
    Err(e) => Err(e)
  }
}
