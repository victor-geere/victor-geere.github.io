#!/usr/bin/env bash
# check.sh — elaborate the Lean layer of this publication against Lean 4 + Mathlib.
#
#   ./check.sh              # every module of 018, 019 and 020
#   ./check.sh 020          # one phase
#   ./check.sh --list       # list the modules
#
# The only external dependency is a Lean 4 toolchain with Mathlib at
# $LEAN_PREFIX (default $HOME/lean): elan at $LEAN_PREFIX/elan, Mathlib4 at
# $LEAN_PREFIX/mathlib4.  Nothing outside this folder is referenced otherwise.
#
# A module is rebuilt when its .olean is missing or older than its source, and
# a few files import siblings, so the script makes up to five passes and stops
# when a pass compiles everything.  Safe on bash 3.2 (no empty-array tricks).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN_PREFIX="${LEAN_PREFIX:-$HOME/lean}"
ELAN_HOME="${ELAN_HOME:-$LEAN_PREFIX/elan}"
MATHLIB="$LEAN_PREFIX/mathlib4"

[ -d "$MATHLIB" ] || { echo "check.sh: no Mathlib at $MATHLIB (set LEAN_PREFIX)" >&2; exit 2; }
TOOLCHAIN="$(cat "$MATHLIB/lean-toolchain")"
LEAN_BIN="$ELAN_HOME/toolchains/leanprover--lean4---${TOOLCHAIN#leanprover/lean4:}/bin/lean"
[ -x "$LEAN_BIN" ] || { echo "check.sh: no lean binary at $LEAN_BIN" >&2; exit 2; }
BASE_PATH="$(cd "$MATHLIB" && ELAN_HOME="$ELAN_HOME" "$ELAN_HOME/bin/lake" env printenv LEAN_PATH)"
export LEAN_PATH="$HERE/018/lean:$HERE/019/lean:$HERE/020/lean:$BASE_PATH"

list_modules() {
  for p in 018 019 020; do
    for f in "$HERE/$p"/lean/*.lean; do [ -e "$f" ] && echo "${f#$HERE/}"; done
  done
}

if [ "${1:-}" = "--list" ]; then list_modules; exit 0; fi

phases=("$@")
if [ ${#phases[@]} -eq 0 ]; then phases=(018 019 020); fi

FAILLIST="$(mktemp)"
trap 'rm -f "$FAILLIST"' EXIT
status=0

for p in "${phases[@]}"; do
  dir="$HERE/$p/lean"
  if [ ! -d "$dir" ]; then echo "check.sh: no Lean directory for $p" >&2; status=1; continue; fi
  pass=1
  while [ "$pass" -le 5 ]; do
    : > "$FAILLIST"
    for f in "$dir"/*.lean; do
      target="$f"
      olean="${f%.lean}.olean"
      if [ -f "$olean" ] && [ "$olean" -nt "$f" ]; then
        [ "$pass" -eq 1 ] && printf '[check] OK   %s/%s\n' "$p" "$(basename "$f")"
        continue
      fi
      if "$LEAN_BIN" -R "$dir" -o "$olean" "$target" >/dev/null 2>&1; then
        printf '[check] OK   %s/%s\n' "$p" "$(basename "$f")"
      else
        echo "$(basename "$f")" >> "$FAILLIST"
      fi
    done
    if [ ! -s "$FAILLIST" ]; then pass=6; break; fi
    pass=$((pass + 1))
  done
  if [ -s "$FAILLIST" ]; then
    while read -r f; do printf '[check] FAIL %s/%s\n' "$p" "$f" >&2; done < "$FAILLIST"
    status=1
  fi
done
exit "$status"
