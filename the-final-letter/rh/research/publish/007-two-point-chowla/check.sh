#!/usr/bin/env bash
# check.sh — elaborate the Lean development of this folder against Lean 4 + Mathlib.
#
#   ./check.sh <Module>/X.lean [more.lean ...]
#   ./check.sh --all
#
# Everything needed is in this folder; the only external dependency is Mathlib.
# The Lean installation lives outside this folder at $LEAN_PREFIX (default
# $HOME/lean): elan at $LEAN_PREFIX/elan and Mathlib4 at $LEAN_PREFIX/mathlib4.
# `ELAN_HOME` must be set for the elan shims, so this script never relies on the
# shims: it calls the toolchain binary directly and reconstructs LEAN_PATH from
# `lake env` inside Mathlib.
#
# Files are elaborated in place; `.olean` files are written next to the sources,
# and this directory is prepended to LEAN_PATH so that `import Rh46.X` works.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN_PREFIX="${LEAN_PREFIX:-$HOME/lean}"
ELAN_HOME="${ELAN_HOME:-$LEAN_PREFIX/elan}"
MATHLIB="$LEAN_PREFIX/mathlib4"

if [ ! -d "$MATHLIB" ]; then
  echo "check.sh: no Mathlib at $MATHLIB (set LEAN_PREFIX)" >&2
  exit 2
fi

TOOLCHAIN="$(cat "$MATHLIB/lean-toolchain")"
LEAN_BIN="$ELAN_HOME/toolchains/leanprover--lean4---${TOOLCHAIN#leanprover/lean4:}/bin/lean"
if [ ! -x "$LEAN_BIN" ]; then
  echo "check.sh: no lean binary at $LEAN_BIN" >&2
  exit 2
fi

BASE_PATH="$(cd "$MATHLIB" && ELAN_HOME="$ELAN_HOME" "$ELAN_HOME/bin/lake" env printenv LEAN_PATH)"
export LEAN_PATH="$HERE:$BASE_PATH"

if [ "${1:-}" = "--all" ]; then
  set -- Rh46/Chowla.lean Rh46.lean
fi
[ $# -gt 0 ] || { echo "usage: check.sh [--all] <file.lean> ..." >&2; exit 2; }

status=0
for f in "$@"; do
  case "$f" in /*) target="$f" ;; *) target="$HERE/$f" ;; esac
  start=$(date +%s)
  if "$LEAN_BIN" -R "$HERE" -o "${target%.lean}.olean" "$target"; then
    printf '[check] OK   %s (%ss)\n' "$f" "$(( $(date +%s) - start ))"
  else
    printf '[check] FAIL %s\n' "$f" >&2
    status=1
  fi
done
exit "$status"
