#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/../../tools/check-lean.sh" "$HERE" Topic.lean EulerMaclaurin.lean GammaProduct.lean SimpsonPanel.lean Archimedean.lean PolygammaSeries.lean DigammaEnclosure.lean Enclosure.lean PanelEnclosure.lean Certificate.lean
