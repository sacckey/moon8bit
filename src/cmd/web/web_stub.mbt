///|
fn web_init_canvas(width : Int, height : Int, scale : Int) -> Unit {
  ignore(width)
  ignore(height)
  ignore(scale)
}

///|
fn web_keys_down() -> Array[String] {
  []
}

///|
fn web_pointer_x() -> Int {
  0
}

///|
fn web_pointer_y() -> Int {
  0
}

///|
fn web_pointer_down() -> Bool {
  false
}

///|
fn web_bootstrap_game(
  on_ok : (String, String, String, String) -> Unit,
  on_error : (String) -> Unit,
) -> Unit {
  ignore(on_error)
  on_ok(
    "Game",
    "Web stub mode",
    "assets.dsl",
    [
      "# moon8bit asset DSL v1", "palette default", "color 0 #101820", "color 1 #274060",
      "color 2 #2e8b57", "color 3 #f2aa4c", "color 4 #e94f37", "color 5 #8f6f4f",
      "color 6 #f6f7eb", "color 7 #7f5af0", "end", "", "sprite sample 8 8", "........",
      "...33...", "..3333..", ".333333.", ".333333.", "..3333..", "...33...", "........",
      "end",
    ].join("\n"),
  )
}

///|
fn web_set_status(text : String) -> Unit {
  ignore(text)
}

///|
fn web_renderer_kind() -> String {
  "stub"
}

///|
fn web_get_editor_text() -> String {
  ""
}

///|
fn web_set_editor_text(text : String) -> Unit {
  ignore(text)
}

///|
fn web_set_editor_feedback(text : String, is_error : Bool) -> Unit {
  ignore(text)
  ignore(is_error)
}

///|
fn web_bind_apply(cb : () -> Unit) -> Unit {
  cb()
}

///|
fn web_bind_export(cb : () -> Unit) -> Unit {
  ignore(cb)
}

///|
fn web_bind_import(cb : (String) -> Unit) -> Unit {
  ignore(cb)
}

///|
fn web_download_text(filename : String, text : String) -> Unit {
  ignore(filename)
  ignore(text)
}

///|
fn web_init_sprite_editor() -> Unit {

}

///|
fn web_sprite_editor_refresh() -> Unit {

}

///|
fn web_init_tilemap_editor() -> Unit {

}

///|
fn web_tilemap_editor_refresh() -> Unit {

}

///|
fn web_audio_start_bgm() -> Unit {

}

///|
fn web_audio_stop_bgm() -> Unit {

}

///|
fn web_audio_play_sfx(kind : String) -> Unit {
  ignore(kind)
}

///|
fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit {
  ignore(fps)
  cb()
}

///|
fn web_apply_sound_bundle(
  sounds : Array[@lib.SoundDef],
  bgms : Array[@lib.BgmDef],
) -> Unit {
  ignore(sounds)
  ignore(bgms)
}

///|
fn web_render_frame(
  pixels : Array[Int],
  width : Int,
  height : Int,
  colors : Array[String],
) -> Unit {
  ignore(pixels)
  ignore(width)
  ignore(height)
  ignore(colors)
}

///|
fn web_init_gpu(width : Int, height : Int) -> Unit {
  ignore(width)
  ignore(height)
}
