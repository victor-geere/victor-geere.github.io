#!/usr/bin/env bash
# check.sh — elaborate the Lean files of rh044 against the local Lean 4 + Mathlib.
#
#   rh044/lean/check.sh Rh044/Smoothing.lean [more.lean ...]
#   rh044/lean/check.sh --all
#
# The Lean installation lives outside this repository at $LEAN_PREFIX (default
# $HOME/lean): elan at $LEAN_PREFIX/elan (toolchain leanprover/lean4:v4.35.0-rc2)
# and Mathlib4 at $LEAN_PREFIX/mathlib4.  `ELAN_HOME` must be set for the elan
# shims, so this script never relies on the shims: it calls the toolchain binary
# directly and reconstructs LEAN_PATH from `lake env` inside Mathlib.
#
# Files are elaborated in place; `.olean` files are written next to the sources,
# and this directory is prepended to LEAN_PATH so that `import Rh044.X` works.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN_PREFIX="${LEAN_PREFIX:-$HOME/lean}"
ELAN_HOME="${ELAN_HOME:-$LEAN_PREFIX/elan}"
MATHLIB="$LEAN_PREFIX/mathlib4"

if [ ! -d "$MATHLIB" ]; then
  echo "check.sh: no Mathlib at $MATHLIB (set LEAN_PREFIX)" >&2
  exit 2
fi

TOOLCHAIN="$(cat "$MATHLIB/lean-toolchain")"          # e.g. leanprover/lean4:v4.35.0-rc2
LEAN_BIN="$ELAN_HOME/toolchains/leanprover--lean4---${TOOLCHAIN#leanprover/lean4:}/bin/lean"
if [ ! -x "$LEAN_BIN" ]; then
  echo "check.sh: no lean binary at $LEAN_BIN" >&2
  exit 2
fi

BASE_PATH="$(cd "$MATHLIB" && ELAN_HOME="$ELAN_HOME" "$ELAN_HOME/bin/lake" env printenv LEAN_PATH)"
export LEAN_PATH="$HERE:$(cd "$(dirname "$HERE")/../rh43/lean" && pwd):$BASE_PATH"

if [ "${1:-}" = "--all" ]; then
  # Dependency order (Rh044/Smoothing is self-contained, importing only Mathlib),
  # then the root module that imports everything.
  set -- Rh044/Smoothing.lean Rh044.lean
fi
[ $# -gt 0 ] || { echo "usage: check.sh [--all] <file.lean> ..." >&2; exit 2; }

status=0
for f in "$@"; do
  case "$f" in /*) target="$f" ;; *) target="$HERE/$f" ;; esac
  start=$(date +%s)
  # `-R` makes the module name of the input file relative to this directory, and
  # `-o` writes the `.olean`, so that `import Rh044.X` works from the other files.
  if "$LEAN_BIN" -R "$HERE" -o "${target%.lean}.olean" "$target"; then
    printf '[check] OK   %s (%ss)\n' "$f" "$(( $(date +%s) - start ))"
  else
    printf '[check] FAIL %s\n' "$f" >&2
    status=1
  fi
done
exit "$status"
