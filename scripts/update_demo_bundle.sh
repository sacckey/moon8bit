#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TEMPLATE_DIR="$ROOT_DIR/scripts/templates"
GAME_PAGE_TEMPLATE="$TEMPLATE_DIR/game-page.html.tmpl"
GAME_LIST_HEAD_TEMPLATE="$TEMPLATE_DIR/game-list-head.html.tmpl"
GAME_LIST_ITEM_TEMPLATE="$TEMPLATE_DIR/game-list-item.html.tmpl"
GAME_LIST_TAIL_TEMPLATE="$TEMPLATE_DIR/game-list-tail.html.tmpl"

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing file: $path" >&2
    exit 1
  fi
}

render_template_with_game_id() {
  local template="$1"
  local game_id="$2"
  local escaped="$game_id"
  escaped="${escaped//\\/\\\\}"
  escaped="${escaped//\//\\/}"
  escaped="${escaped//&/\\&}"
  sed "s/__GAME_ID__/${escaped}/g" "$template"
}

for template in \
  "$GAME_PAGE_TEMPLATE" \
  "$GAME_LIST_HEAD_TEMPLATE" \
  "$GAME_LIST_ITEM_TEMPLATE" \
  "$GAME_LIST_TAIL_TEMPLATE"
do
  require_file "$template"
done

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
  require_file "$spec_file"
  require_file "$assets_file"
  require_file "$web_pkg_file"
  GAME_IDS+=("$game_id")
done

mkdir -p site/g
for game_id in "${GAME_IDS[@]}"; do
  moon build --target js "src/games/${game_id}/web"
  built_web_js="_build/js/debug/build/games/${game_id}/web/web.js"
  require_file "$built_web_js"

  mkdir -p "site/g/${game_id}"
  cp "$built_web_js" "site/g/${game_id}/web.js"
  cp "src/games/${game_id}/game_spec.json" "site/g/${game_id}/game_spec.json"
  cp "src/games/${game_id}/assets.dsl" "site/g/${game_id}/assets.dsl"
  render_template_with_game_id "$GAME_PAGE_TEMPLATE" "$game_id" > "site/g/${game_id}/index.html"
done

{
  cat "$GAME_LIST_HEAD_TEMPLATE"

  for game_id in "${GAME_IDS[@]}"; do
    render_template_with_game_id "$GAME_LIST_ITEM_TEMPLATE" "$game_id"
  done

  cat "$GAME_LIST_TAIL_TEMPLATE"
} > site/g/index.html

echo "Built per-game web.js and generated site/g/<game_id>/ pages"
