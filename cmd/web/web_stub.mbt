///|
fn web_init_canvas(width : Int, height : Int, scale : Int) -> Unit {
  ignore(width)
  ignore(height)
  ignore(scale)
}

///|
fn web_key_down(code : String) -> Bool {
  ignore(code)
  false
}

///|
fn web_clear(color : String) -> Unit {
  ignore(color)
}

///|
fn web_fill_rect(x : Int, y : Int, w : Int, h : Int, color : String) -> Unit {
  ignore(x)
  ignore(y)
  ignore(w)
  ignore(h)
  ignore(color)
}

///|
fn web_set_status(text : String) -> Unit {
  ignore(text)
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
fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit {
  ignore(fps)
  cb()
}
