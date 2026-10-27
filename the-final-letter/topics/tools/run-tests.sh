#!/usr/bin/env bash
# Run every topic's Python tests (pytest), stopping at the first failure.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
status=0
while IFS= read -r d; do
  echo "== ${d#"$ROOT"/} =="
  if ! python3 -m pytest -q "$d"; then status=1; fi
done < <(find "$ROOT" -mindepth 2 -maxdepth 2 -type d -name tests | sort)
exit "$status"
