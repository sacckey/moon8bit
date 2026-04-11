///|
test "asset lookup helpers work on explicit bundle" {
  let palette = @model.Palette::{ name: "p", colors: ["#000000", "#ffffff"] }
  let sprite = @model.Sprite::{
    name: "hero",
    width: 2,
    height: 2,
    pixels: [1, -1, 0, 1],
  }
  let tilemap = @model.Tilemap::{
    name: "stage",
    tileset: "main",
    width: 2,
    height: 1,
    tiles: [3, 4],
  }
  let bundle = @model.AssetBundle::{
    palette,
    sprites: [sprite],
    tilesets: [],
    tilemaps: [tilemap],
    sounds: [],
    bgms: [],
  }

  let found_sprite = match @model.find_sprite(bundle, "hero") {
    Some(v) => v
    None => panic()
  }
  assert_eq(@model.sprite_pixel(found_sprite, 0, 0), Some(1))
  assert_eq(@model.sprite_pixel(found_sprite, 1, 0), Some(-1))
  assert_eq(@model.sprite_pixel(found_sprite, 2, 0), None)

  let found_tilemap = match @model.find_tilemap(bundle, "stage") {
    Some(v) => v
    None => panic()
  }
  assert_eq(@model.tile_at(found_tilemap, 0, 0), Some(3))
  assert_eq(@model.tile_at(found_tilemap, 1, 0), Some(4))
  assert_eq(@model.tile_at(found_tilemap, 2, 0), None)
}

///|
test "frame drawing and collider helpers behave as expected" {
  let frame = @model.Frame::new(6, 4, fill=-1)
  frame.clear(0)
  frame.set_pixel(1, 1, 3)
  frame.draw_rect(2, 1, 2, 2, 4)

  let spr = @model.Sprite::{ name: "dot", width: 1, height: 1, pixels: [7] }
  frame.blit(spr, 5, 3)

  assert_eq(frame.get_pixel(1, 1), Some(3))
  assert_eq(frame.get_pixel(2, 1), Some(4))
  assert_eq(frame.get_pixel(3, 2), Some(4))
  assert_eq(frame.get_pixel(5, 3), Some(7))

  let a = @model.collider_box("a", 0, 0, 3, 3)
  let b = @model.collider_box("b", 2, 2, 3, 3)
  let c = @model.collider_box("c", 8, 8, 1, 1)
  assert_true(@model.rect_intersects(a.rect, b.rect))
  assert_true(@model.collider_intersects(a, b))
  assert_true(!@model.collider_intersects(a, c))
  assert_true(@model.collider_hits_any(a, [b, c]))
  assert_eq(@model.collider_first_hit(a, [c, b]), Some(b))
}
