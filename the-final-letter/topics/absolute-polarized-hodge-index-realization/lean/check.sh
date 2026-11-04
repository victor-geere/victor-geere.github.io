#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
# The Euler--Maclaurin development (imported by ZetaStrip.lean) lives in the
# neighbouring finite-window-zeros topic.
export LEAN_EXTRA_PATH="${LEAN_EXTRA_PATH:-$HERE/../../finite-window-zeros/lean}"
exec "$HERE/../../tools/check-lean.sh" "$HERE" Rescue.lean Shadow.lean Archimedean.lean Symbol.lean Limit.lean Weil.lean Hadamard.lean Rectangle.lean ExplicitFormula.lean TailBound.lean ZetaStrip.lean
