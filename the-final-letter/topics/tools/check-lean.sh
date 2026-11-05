#!/usr/bin/env bash
# check-lean.sh <lean-root> [--quick] [file.lean ...]
# Elaborate topic Lean files against the local Mathlib installation.
#
# `--quick` skips the machine-generated `DensityC*_*.lean` certificate chunks
# (and `DensityCertificates.lean` when its chunk oleans have not been built), so
# the hand-written core can be checked in minutes instead of hours.  With an
# explicit file list `--quick` is a no-op.
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: check-lean.sh <lean-root> [--quick] [file.lean ...]" >&2
  exit 2
fi
HERE="$(cd "$1" && pwd)"; shift || true

QUICK=0
ARGS=()
for a in "$@"; do
  if [ "$a" = "--quick" ]; then QUICK=1; else ARGS+=("$a"); fi
done
set -- ${ARGS[@]+"${ARGS[@]}"}
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
export LEAN_PATH="$HERE:$BASE_PATH${LEAN_EXTRA_PATH:+:$LEAN_EXTRA_PATH}"

if [ $# -eq 0 ]; then
  FILES=()
  while IFS= read -r f; do FILES+=("$f"); done < <(find "$HERE" -maxdepth 2 -name '*.lean' -type f | sort)
  if [ "$QUICK" = 1 ]; then
    KEPT=()
    skipped=0
    for f in ${FILES[@]+"${FILES[@]}"}; do
      case "$(basename "$f")" in
        DensityC[0-9]*_[0-9]*.lean) skipped=$((skipped + 1)); continue ;;
      esac
      KEPT+=("$f")
    done
    FILES=(${KEPT[@]+"${KEPT[@]}"})
    if [ -f "$HERE/DensityCertificates.lean" ] && ! ls "$HERE"/DensityC*_8.olean >/dev/null 2>&1; then
      KEPT=()
      for f in ${FILES[@]+"${FILES[@]}"}; do
        [ "$(basename "$f")" = "DensityCertificates.lean" ] || KEPT+=("$f")
      done
      FILES=(${KEPT[@]+"${KEPT[@]}"})
      echo "[quick] chunk oleans absent: skipping DensityCertificates.lean" >&2
    fi
    if [ "$skipped" -gt 0 ]; then
      echo "[quick] skipped $skipped generated chunk files" >&2
    fi
  fi
else
  FILES=("$@")
fi

status=0
for f in "${FILES[@]}"; do
  case "$f" in /*) target="$f" ;; *) target="$HERE/$f" ;; esac
  [ -f "$target" ] || { echo "[check] MISS $f" >&2; status=1; continue; }
  start=$(date +%s)
  if [ -n "${LEAN_EXTRA_PATH:-}" ]; then
    if "$LEAN_BIN" -o "${target%.lean}.olean" "$target"; then
      printf '[check] OK   %s (%ss)\n' "${f#"$HERE"/}" "$(( $(date +%s) - start ))"
    else
      printf '[check] FAIL %s\n' "${f#"$HERE"/}" >&2
      status=1
    fi
    continue
  fi
  if "$LEAN_BIN" -R "$HERE" -o "${target%.lean}.olean" "$target"; then
    printf '[check] OK   %s (%ss)\n' "${f#"$HERE"/}" "$(( $(date +%s) - start ))"
  else
    printf '[check] FAIL %s\n' "${f#"$HERE"/}" >&2
    status=1
  fi
done
exit "$status"
