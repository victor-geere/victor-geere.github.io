#!/usr/bin/env bash
# check-lean.sh <lean-root> [file.lean ...]
# Elaborate topic Lean files against the local Mathlib installation.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: check-lean.sh <lean-root> [file.lean ...]" >&2
  exit 2
fi
HERE="$(cd "$1" && pwd)"; shift || true
LEAN_PREFIX="${LEAN_PREFIX:-$HOME/lean}"
ELAN_HOME="${ELAN_HOME:-$LEAN_PREFIX/elan}"
MATHLIB="$LEAN_PREFIX/mathlib4"

if [ ! -d "$MATHLIB" ]; then
  echo "check-lean.sh: no Mathlib at $MATHLIB (set LEAN_PREFIX)" >&2
  exit 2
fi

TOOLCHAIN="$(cat "$MATHLIB/lean-toolchain")"
LEAN_BIN="$ELAN_HOME/toolchains/leanprover--lean4---${TOOLCHAIN#leanprover/lean4:}/bin/lean"
if [ ! -x "$LEAN_BIN" ]; then
  echo "check-lean.sh: no lean binary at $LEAN_BIN" >&2
  exit 2
fi

BASE_PATH="$(cd "$MATHLIB" && ELAN_HOME="$ELAN_HOME" "$ELAN_HOME/bin/lake" env printenv LEAN_PATH)"
export LEAN_PATH="$HERE:$BASE_PATH"

if [ $# -eq 0 ]; then
  FILES=()
  while IFS= read -r f; do FILES+=("$f"); done < <(find "$HERE" -maxdepth 2 -name '*.lean' -type f | sort)
else
  FILES=("$@")
fi

status=0
for f in "${FILES[@]}"; do
  case "$f" in /*) target="$f" ;; *) target="$HERE/$f" ;; esac
  [ -f "$target" ] || { echo "[check] MISS $f" >&2; status=1; continue; }
  start=$(date +%s)
  if "$LEAN_BIN" -R "$HERE" -o "${target%.lean}.olean" "$target"; then
    printf '[check] OK   %s (%ss)\n' "${f#"$HERE"/}" "$(( $(date +%s) - start ))"
  else
    printf '[check] FAIL %s\n' "${f#"$HERE"/}" >&2
    status=1
  fi
done
exit "$status"
