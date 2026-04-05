#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

GAME_IDS=()
GAME_DIRS=()
while IFS= read -r spec_file; do
  dir="$(dirname "$spec_file")"
  GAME_DIRS+=("$dir")
done < <(find src/games -mindepth 2 -maxdepth 2 -name game_spec.json | sort)

if [[ ${#GAME_DIRS[@]} -eq 0 ]]; then
  echo "No game directories found in src/games" >&2
  exit 1
fi

for dir in "${GAME_DIRS[@]}"; do
  game_id="$(basename "$dir")"
  spec_file="$dir/game_spec.json"
  assets_file="$dir/assets.dsl"
  web_pkg_dir="$dir/web"
  web_pkg_file="$web_pkg_dir/moon.pkg"
  if [[ ! -f "$spec_file" ]]; then
    echo "Missing game spec: $spec_file" >&2
    exit 1
  fi
  if [[ ! -f "$assets_file" ]]; then
    echo "Missing assets DSL: $assets_file" >&2
    exit 1
  fi
  if [[ ! -f "$web_pkg_file" ]]; then
    echo "Missing web package: $web_pkg_file" >&2
    exit 1
  fi
  GAME_IDS+=("$game_id")
done

mkdir -p site/g
for game_id in "${GAME_IDS[@]}"; do
  moon build --target js "src/games/${game_id}/web"
  built_web_js="_build/js/debug/build/games/${game_id}/web/web.js"
  if [[ ! -f "$built_web_js" ]]; then
    echo "Built web.js not found for game ${game_id}: $built_web_js" >&2
    exit 1
  fi

  mkdir -p "site/g/${game_id}"
  cp "$built_web_js" "site/g/${game_id}/web.js"
  cp "src/games/${game_id}/game_spec.json" "site/g/${game_id}/game_spec.json"
  cp "src/games/${game_id}/assets.dsl" "site/g/${game_id}/assets.dsl"
  cat > "site/g/${game_id}/index.html" <<PAGE
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>moon8bit ${game_id}</title>
    <style>
      :root {
        color-scheme: dark;
      }
      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-content: center;
        gap: 10px;
        background: radial-gradient(circle at top, #1f4068, #0f1720 58%);
        color: #d9e2ec;
        font-family: "Courier New", Courier, monospace;
      }
      .hint {
        opacity: 0.9;
        font-size: 13px;
      }
      #moon8bit-canvas {
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.35);
      }
    </style>
  </head>
  <body>
    <div class="hint">Game: <b>${game_id}</b></div>
    <div class="hint">Controls: <b>Space/ArrowUp</b> action, <b>R</b> reset</div>
    <script src="./web.js"></script>
  </body>
</html>
PAGE
done

{
  cat <<'HEAD'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>moon8bit games</title>
  </head>
  <body>
    <h1>moon8bit games</h1>
    <ul>
HEAD

  for game_id in "${GAME_IDS[@]}"; do
    echo "      <li><a href=\"./${game_id}/\">${game_id}</a></li>"
  done

  cat <<'TAIL'
    </ul>
  </body>
</html>
TAIL
} > site/g/index.html

echo "Built per-game web.js and generated site/g/<game_id>/ pages"
