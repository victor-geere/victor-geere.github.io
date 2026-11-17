#!/usr/bin/env bash
# Build the shared, chain-independent Omega bracket module for a partition.
#
#   ./build_omega.sh <edges> <M> [chunk-size]
#
# Writes DensitySO_<j>.lean in namespace PrimeSpectrumTensor.SO.  Every density
# chain imports the last chunk and references `PrimeSpectrumTensor.SO.om<p>`,
# so the (expensive) `norm_num` evaluation of the digamma series is paid once
# instead of once per separation.  Kernel-checked: no `native_decide`.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
LEAN="$HERE/.."
EDGES="$1"; M="${2:-20}"; SIZE="${3:-160}"
OTAG="${OTAG:-SO}"
P=$(python3 -c "import sys;print(len([l for l in open('$EDGES') if l.strip()])-1)")
N=$(( (P + SIZE - 1) / SIZE ))
for j in $(seq 0 $((N - 1))); do
  f="Density${OTAG}_${j}.lean"
  s=$(( j * SIZE )); e=$(( s + SIZE ))
  [ "$e" -gt "$P" ] && e="$P"
  flags="--omega-only --omega-norm-num --omega-m $M"
  [ "$j" -gt 0 ] && flags="$flags --import Density${OTAG}_$((j-1))"
  ( cd "$HERE" && python3 panels.py --c 0 --edges "$EDGES" --out "../$f" --ns "${OTAG}" \
      --start "$s" --end "$e" $flags >/dev/null ) || { echo "EMIT-FAIL $f"; exit 1; }
  if [ -f "$LEAN/${f%.lean}.olean" ] && [ "$LEAN/${f%.lean}.olean" -nt "$LEAN/$f" ]; then
    echo "SKIP  $f"; continue
  fi
  echo "BUILD $f  $(date +%H:%M:%S)"
  ( cd "$LEAN" && ./check.sh "$f" 2>&1 | grep -E "^\[check\]|error:" | head -10 )
  [ -f "$LEAN/${f%.lean}.olean" ] || { echo "FAIL  $f"; exit 1; }
done
echo "OMEGA-DONE chunks=$N panels=$P  $(date +%H:%M:%S)"
