#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

moon build --target js src/cmd/web

cp _build/js/debug/build/cmd/web/web.js site/demo/web.js

echo "Updated site/demo/web.js"
