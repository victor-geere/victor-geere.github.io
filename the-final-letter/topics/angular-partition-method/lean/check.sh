#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/../../tools/check-lean.sh" "$HERE" Topic.lean Mellin.lean CriticalStrip.lean RegularizedIntegral.lean Continuation.lean EulerProduct.lean VectorArea.lean ExplicitFormula.lean BostConnes.lean Gram.lean ContinuousCoil.lean
