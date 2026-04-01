///|
fn read_text_file(path : String) -> Result[String, String] {
  ignore(path)
  Err("file I/O for cmd/main is currently supported on --target js only")
}

///|
fn write_text_file(path : String, content : String) -> Result[Unit, String] {
  ignore(path)
  ignore(content)
  Err("file I/O for cmd/main is currently supported on --target js only")
}
