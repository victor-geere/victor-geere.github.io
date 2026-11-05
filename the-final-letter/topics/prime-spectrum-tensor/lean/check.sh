#!/usr/bin/env bash
# The analysis library of ../../intersection-form-zeta/lean (the Euler product
# limit, the digamma enclosure machinery and the Simpson panel estimate) is
# reused through LEAN_EXTRA_PATH.  Its modules do not collide with ours:
# `PanelEnclosure` and its import closure contain no `Topic`.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export LEAN_EXTRA_PATH="${LEAN_EXTRA_PATH:-$HERE/../../intersection-form-zeta/lean}"
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
