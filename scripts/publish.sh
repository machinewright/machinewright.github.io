#!/usr/bin/env bash
# Publish the user-site home page (machinewright.github.io) with gh: create the repo if missing, push main,
# make it public, enable Pages from main /.
set -euo pipefail
cd "$(dirname "$0")/.."
OWNER=${OWNER:-machinewright}; REPO="$OWNER.github.io"
[ -z "$(git status --porcelain)" ] || { echo "uncommitted changes; commit first" >&2; exit 1; }
gh repo view "$OWNER/$REPO" >/dev/null 2>&1 || gh repo create "$OWNER/$REPO" --private --description "Machinewright's home page" --disable-wiki
git push "https://github.com/$OWNER/$REPO.git" HEAD:main
gh repo edit "$OWNER/$REPO" --visibility public --accept-visibility-change-consequences >/dev/null 2>&1 || true
gh api -X POST "repos/$OWNER/$REPO/pages" -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 || echo "(pages already enabled)"
echo "https://$REPO/"
