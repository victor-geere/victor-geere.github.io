#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export LEAN_EXTRA_PATH="$(cd "$HERE/../../partial-sum-plus-tail/lean" && pwd):$(cd "$HERE/../../absolute-polarized-hodge-index-realization/lean" && pwd):$(cd "$HERE/../../digamma-contour-shift/lean" && pwd):$(cd "$HERE/../../intersection-form-zeta/lean" && pwd)"
if [ "$#" -eq 0 ]; then
  exec "$HERE/../../tools/check-lean.sh" "$HERE" Topic.lean Cert.lean Seg.lean Krawczyk.lean EulerMaclaurin.lean ZetaBox14.lean BoxNorm.lean FixedBox.lean BlockCert.lean EtaEM.lean EMCritical.lean EMBox14.lean EMDeriv.lean EMTaylor.lean EMTaylorCert.lean EMTaylorH2.lean EMTaylorStep.lean EMOnLine.lean Wide.lean WidthCert.lean P4.lean RealAxis.lean LSeriesBound.lean LSeriesTaylor.lean LSeriesAnchor.lean NodeBounds.lean DigammaNode.lean ParametricExp.lean ParametricIter.lean TentBound.lean TentArchBound.lean TentEnclosure.lean
fi
exec "$HERE/../../tools/check-lean.sh" "$HERE" "$@"
