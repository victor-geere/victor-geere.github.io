#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/../../tools/check-lean.sh" "$HERE" Rescue.lean Shadow.lean Archimedean.lean Symbol.lean Limit.lean Weil.lean Hadamard.lean Rectangle.lean ExplicitFormula.lean
