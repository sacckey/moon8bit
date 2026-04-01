#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

moon build --target js src/cmd/web

mkdir -p demo
cp _build/js/debug/build/cmd/web/web.js demo/web.js
cp _build/js/debug/build/cmd/web/web.js.map demo/web.js.map

echo "Updated demo/web.js and demo/web.js.map"
