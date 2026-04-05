///|
fn print_usage() -> Unit {
  println("moon8bit commands:")
  println("  moon run cmd/main -- demo <assets.dsl> [frames]")
  println("  moon run cmd/main -- assets \"<dsl with \\n escapes>\"")
  println("  moon run cmd/main --target js -- assets-file <in.dsl> <out.json>")
}

///|
fn args_after_separator(args : Array[String]) -> Array[String] {
  let mut found_separator = false
  let tail : Array[String] = []

  for arg in args {
    if found_separator {
      tail.push(arg)
      continue
    }
    if arg == "--" {
      found_separator = true
    }
  }

  if found_separator {
    tail
  } else {
    args
  }
}

///|
fn extract_command_tokens(args : Array[String]) -> Array[String] {
  for i, arg in args {
    if arg == "demo" || arg == "assets" || arg == "assets-file" || arg == "help" {
      return args[i:args.length()].to_array()
    }
  }
  []
}

///|
fn parse_int_or_default(text : String, default_value : Int) -> Int {
  @string.parse_int(text[:]) catch {
    _ => default_value
  }
}

///|
fn run_demo(tokens : Array[String]) -> Unit {
  if tokens.length() < 2 {
    println("demo command requires: <assets.dsl> [frames]")
    print_usage()
    return
  }

  let assets_path = tokens[1]
  let frame_count = if tokens.length() >= 3 {
    parse_int_or_default(tokens[2], 60)
  } else {
    60
  }

  let source = match read_text_file(assets_path) {
    Ok(content) => content
    Err(msg) => {
      println(msg)
      return
    }
  }

  let bundle = match @lib.parse_assets_dsl(source) {
    Ok(parsed) => parsed
    Err(err) => {
      println("error(line=\{err.line}): \{err.message}")
      return
    }
  }

  let (state, frames) = @lib.run_driftbird_demo(bundle, frame_count)
  println(
    "moon8bit demo: frames=\{frame_count}, score=\{state.score()}, over=\{state.is_over()}",
  )

  if frames.length() > 0 {
    println(frames[frames.length() - 1])
  }
}

///|
fn run_assets(tokens : Array[String]) -> Unit {
  if tokens.length() < 2 {
    println("assets command requires DSL text")
    print_usage()
    return
  }

  let encoded = tokens[1:tokens.length()].to_array().join(" ")
  let decoded = encoded.replace_all(old="\\n", new="\n")
  println(@lib.assets_cli_output(decoded))
}

///|
fn run_assets_file(tokens : Array[String]) -> Unit {
  if tokens.length() < 3 {
    println("assets-file command requires: <in.dsl> <out.json>")
    print_usage()
    return
  }

  let input_path = tokens[1]
  let output_path = tokens[2]

  let source = match read_text_file(input_path) {
    Ok(content) => content
    Err(msg) => {
      println(msg)
      return
    }
  }

  let json_text = match @lib.parse_assets_dsl_to_json_string(source) {
    Ok(content) => content
    Err(err) => {
      println("error(line=\{err.line}): \{err.message}")
      return
    }
  }

  match write_text_file(output_path, json_text) {
    Ok(_) => println("wrote \{output_path}")
    Err(msg) => println(msg)
  }
}

///|
fn main {
  let args = @env.args()
  let tail = args_after_separator(args)
  let tokens = extract_command_tokens(tail)

  if tokens.length() == 0 {
    print_usage()
    return
  }

  match tokens[0] {
    "demo" => run_demo(tokens)
    "assets" => run_assets(tokens)
    "assets-file" => run_assets_file(tokens)
    _ => print_usage()
  }
}
