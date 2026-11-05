#!/usr/bin/env bash
# Rebuild the chunked density certificates, skipping chunks whose .olean is
# newer than their .lean (and than the previous chunk's .olean).  Safe to
# re-run after an interruption.
set -u
cd "$(dirname "$0")/.."
CC="${*:-0 1 2 3}"
for i in $CC; do
  for j in 0 1 2 3 4 5 6 7 8; do
    f="DensityC${i}_${j}.lean"
    o="DensityC${i}_${j}.olean"
    [ -f "$f" ] || { echo "MISSING $f"; continue; }
    if [ -f "$o" ] && [ "$o" -nt "$f" ]; then
      if [ "$j" = 0 ] || [ -f "DensityC${i}_$((j-1)).olean" -a "$o" -nt "DensityC${i}_$((j-1)).olean" ]; then
        echo "SKIP  $f"; continue
      fi
    fi
    echo "BUILD $f  $(date +%H:%M:%S)"
    ./check.sh "$f" 2>&1 | grep -vE "warning: Used|unnecessarySeqFocus|^$|^Note:" || true
    [ -f "$o" ] && echo "OK    $f  $(date +%H:%M:%S)" || echo "FAIL  $f"
  done
done
echo "TRACKDONE $*"
