#!/usr/bin/env bash
# Check every topic's Lean core sequentially.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
status=0
while IFS= read -r d; do
  name="$(basename "$(dirname "$d")")"
  echo "== $name =="
  if ! "$d/check.sh" 2>&1 | tee "$d/BUILD.log"; then status=1; fi
done < <(find "$ROOT" -mindepth 2 -maxdepth 2 -type d -name lean | sort)
exit "$status"
