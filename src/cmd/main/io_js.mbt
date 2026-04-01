///|
extern "js" fn read_file_or_none(path : String) -> String? =
  #| (path) => {
  #|   try {
  #|     const fs = require("node:fs");
  #|     return fs.readFileSync(path, "utf8");
  #|   } catch (_err) {
  #|     return null;
  #|   }
  #| }

///|
extern "js" fn write_file_ok(path : String, content : String) -> Bool =
  #| (path, content) => {
  #|   try {
  #|     const fs = require("node:fs");
  #|     fs.writeFileSync(path, content, "utf8");
  #|     return true;
  #|   } catch (_err) {
  #|     return false;
  #|   }
  #| }

///|
fn read_text_file(path : String) -> Result[String, String] {
  match read_file_or_none(path) {
    Some(content) => Ok(content)
    None => Err("failed to read file: \{path}")
  }
}

///|
fn write_text_file(path : String, content : String) -> Result[Unit, String] {
  if write_file_ok(path, content) {
    Ok(())
  } else {
    Err("failed to write file: \{path}")
  }
}
