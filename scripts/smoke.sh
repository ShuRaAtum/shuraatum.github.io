#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "==> jekyll build"
bundle exec jekyll build --trace
echo "==> html-proofer (internal links only)"
bundle exec htmlproofer ./_site \
  --disable-external \
  --ignore-empty-alt \
  --ignore-missing-alt \
  --allow-hash-href
echo "==> OK"
