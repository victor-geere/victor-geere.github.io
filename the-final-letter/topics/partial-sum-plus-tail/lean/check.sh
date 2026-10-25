#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
if [ "$#" -eq 0 ]; then
  exec "$HERE/../../tools/check-lean.sh" "$HERE" IBox.lean Expr.lean Transcend.lean Replay.lean ReplayAtoms.lean Topic.lean SourceClaims.lean EulerMaclaurin.lean
fi
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
