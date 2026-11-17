#!/usr/bin/env bash
# Refresh the projekt-only branch of VIS, pull both submodules to their latest commits,
# and commit + push the new pins if anything changed.
# Usage: ./update.sh            (VIS clone at the default path)
#        VIS_DIR=/path ./update.sh
set -euo pipefail

VIS_DIR="${VIS_DIR:-$HOME/Documents/VSB/tretak/VIS}"
HERE="$(cd "$(dirname "$0")" && pwd)"

echo "Splitting projekt/ in $VIS_DIR ..."
git -C "$VIS_DIR" subtree split --prefix=projekt -b projekt
git -C "$VIS_DIR" push origin projekt

echo "Updating submodules ..."
cd "$HERE"
git submodule update --remote

if git diff --quiet; then
  echo "Already up to date, nothing to commit."
else
  git commit -am "Update submodules"
  git push
fi
