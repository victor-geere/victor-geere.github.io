#!/usr/bin/env bash
# check.sh — elaborate the-final-letter Lean layer against the same local
# Lean 4 + Mathlib installation used by ~/workspace/rh.
#
#   lean/check.sh FinalLetter/Synthesis.lean
#   lean/check.sh --all
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
  set -- FinalLetter/Chowla.lean FinalLetter/Synthesis.lean FinalLetter.lean
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
