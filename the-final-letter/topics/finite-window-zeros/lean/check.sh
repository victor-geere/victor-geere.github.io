#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export LEAN_EXTRA_PATH="$(cd "$HERE/../../partial-sum-plus-tail/lean" && pwd)"
if [ "$#" -eq 0 ]; then
  exec "$HERE/../../tools/check-lean.sh" "$HERE" Topic.lean Cert.lean Seg.lean Krawczyk.lean EulerMaclaurin.lean ZetaBox14.lean BoxNorm.lean FixedBox.lean BlockCert.lean EtaEM.lean
fi
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
