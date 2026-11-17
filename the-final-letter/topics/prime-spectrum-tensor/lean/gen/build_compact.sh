#!/usr/bin/env bash
# Compact density chains: emit + build one chain (one separation c).
#
#   ./build_compact.sh <i> <c> <edges> [wden] [extra panels.py flags...]
#
# Chain i writes DensityE<i>_<j>.lean in namespace PrimeSpectrumTensor.E<i>.
# The last chunk emits `density_mem_c<i>`.  Resumable: chunks whose .olean is
# newer than their .lean are skipped (but the build is sequential, because each
# chunk imports its predecessor).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
LEAN="$HERE/.."
i="$1"; c="$2"; EDGES="$3"; wden="$4"; shift 4
EXTRA="$*"
SIZE="${CHUNK:-160}"
TAG="${TAG:-F}"
P=$(python3 -c "import sys;print(len([l for l in open('$EDGES') if l.strip()])-1)")
N=$(( (P + SIZE - 1) / SIZE ))
for j in $(seq 0 $((N - 1))); do
  f="Density${TAG}${i}_${j}.lean"
  s=$(( j * SIZE )); e=$(( s + SIZE ))
  [ "$e" -gt "$P" ] && e="$P"
  flags="--wden $wden $EXTRA"
  [ -n "${OMEGA_NS:-}" ] && flags="$flags --share-omega $OMEGA_NS"
  imp=""
  [ "$j" -gt 0 ] && imp="Density${TAG}${i}_$((j-1))"
  [ -n "${OMEGA_IMPORT:-}" ] && imp="${imp:+$imp,}$OMEGA_IMPORT"
  [ -n "$imp" ] && flags="$flags --import $imp"
  [ "$j" -eq $((N - 1)) ] && flags="$flags --final --name density_mem_c${i}"
  ( cd "$HERE" && python3 panels.py --c "$c" --edges "$EDGES" --out "../$f" --ns "${TAG}${i}" \
      --start "$s" --end "$e" $flags >/dev/null ) || { echo "EMIT-FAIL $f"; exit 1; }
  if [ -f "$LEAN/${f%.lean}.olean" ] && [ "$LEAN/${f%.lean}.olean" -nt "$LEAN/$f" ]; then
    echo "SKIP  $f"; continue
  fi
  echo "BUILD $f  $(date +%H:%M:%S)"
  ( cd "$LEAN" && ./check.sh "$f" 2>&1 | grep -E "^\[check\]|error:" | head -20 )
  [ -f "$LEAN/${f%.lean}.olean" ] || { echo "FAIL  $f"; exit 1; }
done
echo "CHAIN-DONE c=$c i=$i tag=$TAG chunks=$N panels=$P  $(date +%H:%M:%S)"
