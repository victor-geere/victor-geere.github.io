#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export LEAN_EXTRA_PATH="${LEAN_EXTRA_PATH:-$HERE/../../absolute-polarized-hodge-index-realization/lean:$HERE/../../finite-window-zeros/lean:$HERE/../../prime-spectrum-tensor/lean:$HERE/../../intersection-form-zeta/lean}"
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
