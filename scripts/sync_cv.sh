#!/usr/bin/env bash
# Copy the CV PDFs built in the LaTeX CV repo into the site.
#   Full CV     -> assets/pdf/si-woo-eum-cv.pdf (also cv_en.pdf, kept for old links)
#   Research CV -> assets/pdf/si-woo-eum-research-cv.pdf
# Usage: scripts/sync_cv.sh [path-to-cv-repo]
set -euo pipefail

src="${1:-/home/shu/2026/paper/cv_eum}"
dest="$(cd "$(dirname "$0")/.." && pwd)/assets/pdf"

for f in cv_eum.pdf cv_eum_research.pdf; do
  [[ -f "$src/$f" ]] || { echo "missing $src/$f (build the CV first)" >&2; exit 1; }
done

cp "$src/cv_eum.pdf" "$dest/si-woo-eum-cv.pdf"
cp "$src/cv_eum.pdf" "$dest/cv_en.pdf"
cp "$src/cv_eum_research.pdf" "$dest/si-woo-eum-research-cv.pdf"

echo "Copied CVs from $src ($(git -C "$src" log -1 --format='%h %s' 2>/dev/null || echo 'not a git repo'))"
