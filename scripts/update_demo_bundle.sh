#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

moon build --target js src/cmd/web

cp _build/js/debug/build/cmd/web/web.js site/demo/web.js

GAME_IDS=(
  "driftbird"
  "driftbird-night"
)

mkdir -p site/g
for game_id in "${GAME_IDS[@]}"; do
  mkdir -p "site/g/${game_id}"
  cat > "site/g/${game_id}/index.html" <<EOF
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
    <script src="../../demo/web.js"></script>
  </body>
</html>
EOF
done

cat > site/g/index.html <<'EOF'
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
      <li><a href="./driftbird/">driftbird</a></li>
      <li><a href="./driftbird-night/">driftbird-night</a></li>
    </ul>
  </body>
</html>
EOF

echo "Updated site/demo/web.js and generated site/g/<game_id>/index.html pages"
