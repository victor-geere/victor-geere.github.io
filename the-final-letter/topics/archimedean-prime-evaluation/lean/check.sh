#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export LEAN_EXTRA_PATH="${LEAN_EXTRA_PATH:-$HERE/../../digamma-contour-shift/lean:$HERE/../../intersection-form-zeta/lean:$HERE/../../absolute-polarized-hodge-index-realization/lean}"
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
