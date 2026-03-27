///|
fn print_usage() -> Unit {
  println("moon8bit commands:")
  println("  moon run cmd/main -- demo [frames]")
  println("  moon run cmd/main -- sample-dsl")
  println("  moon run cmd/main -- assets \"<dsl with \\n escapes>\"")
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
    if arg == "demo" || arg == "assets" || arg == "sample-dsl" || arg == "help" {
      return args[i:args.length()].to_array()
    }
  }
  []
}

///|
fn parse_int_or_default(text : String, default_value : Int) -> Int {
  @strconv.parse_int(text) catch {
    _ => default_value
  }
}

///|
fn run_demo(tokens : Array[String]) -> Unit {
  let frame_count = if tokens.length() >= 2 {
    parse_int_or_default(tokens[1], 60)
  } else {
    60
  }

  let (state, frames) = @lib.run_bird_like_demo(frame_count)
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
    "sample-dsl" => println(@lib.sample_assets_dsl())
    "assets" => run_assets(tokens)
    _ => print_usage()
  }
}
