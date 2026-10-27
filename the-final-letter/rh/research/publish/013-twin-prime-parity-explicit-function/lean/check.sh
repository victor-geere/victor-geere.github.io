#!/usr/bin/env bash
# check.sh — elaborate all Lean files of publish/013 against Lean 4 + Mathlib.
#
#   lean/check.sh --all            # every module, in dependency order
#   lean/check.sh DirichletStripBound.lean Rh45/Archimedean.lean   # selected modules
#
# The Lean installation lives outside this package at $LEAN_PREFIX (default
# $HOME/lean): elan at $LEAN_PREFIX/elan (toolchain leanprover/lean4:v4.35.0-rc2)
# and Mathlib4 at $LEAN_PREFIX/mathlib4.  Every module name is preserved by the
# single `-R lean` root, so all internal imports (flat Dirichlet*, dotted
# Rh45.*, Rh43.*, Op56.*, and the namespaced ConeLean.* / TppLean.*) resolve as
# they did in the original per-round developments.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN_PREFIX="${LEAN_PREFIX:-$HOME/lean}"
ELAN_HOME="${ELAN_HOME:-$LEAN_PREFIX/elan}"
MATHLIB="$LEAN_PREFIX/mathlib4"

if [ ! -d "$MATHLIB" ]; then
  echo "check.sh: no Mathlib at $MATHLIB (set LEAN_PREFIX)" >&2
  exit 2
fi

TOOLCHAIN="$(cat "$MATHLIB/lean-toolchain")"
LEAN_BIN="$ELAN_HOME/toolchains/leanprover--lean4---${TOOLCHAIN#leanprover/lean4:}/bin/lean"
if [ ! -x "$LEAN_BIN" ]; then
  echo "check.sh: no lean binary at $LEAN_BIN" >&2
  exit 2
fi

BASE_PATH="$(cd "$MATHLIB" && ELAN_HOME="$ELAN_HOME" "$ELAN_HOME/bin/lake" env printenv LEAN_PATH)"
export LEAN_PATH="$HERE:$BASE_PATH"

if [ "${1:-}" = "--all" ]; then
  set -- ConeLean/ChowlaEquiv.lean ConeLean/LogAverageBarrier.lean ConeLean/ParityObstruction.lean ConeLean/ShiftBarrier.lean ConeLean/SpectralStructure.lean DirichletConj.lean DirichletZeroTail.lean GaussSumComposite.lean Op56/Defs.lean Op57/Defs.lean Op58/Defs.lean Op59/Sparse.lean Rh044/Smoothing.lean Rh41/DigitWord.lean Rh41/GreedyResidual.lean Rh42/Budget.lean Rh42/PrecisionFloor.lean Rh42/Reachable.lean Rh43/Balance.lean Rh45/Explicit.lean Rh45/GammaProduct.lean Rh45/RouteBAnalytic.lean Rh45/Routes.lean Rh45/SimpsonPanel.lean Rh45/VonMangoldtSieve.lean Rh46/Chowla.lean TppLean/Budget.lean TppLean/Core.lean ConeLean/ShiftTwoCore.lean Op56/Exact.lean Op57/Leading.lean Op57/Blocks.lean Op58/Split.lean Op59/Phase.lean Rh044.lean Rh42/Tau.lean Rh41/Impossibility.lean Rh41/WindowCount.lean Rh41/AllZero.lean Rh41/Alphabet.lean Rh43.lean DirichletRightPathLinear.lean Rh45/ArgumentPrinciple.lean Rh45/Archimedean.lean Rh46.lean Rh47/Sparse.lean Rh47/Parity.lean ConeLean/Cone.lean TppLean/ThreeThresholds.lean Op56/Census.lean Op56/FloorAsymptotic.lean Op56/PhiAsymptotic.lean Op57/Obstruction.lean Op58.lean Op59.lean Rh42.lean Rh41.lean Rh45/Weierstrass.lean Rh45/PolygammaSeries.lean Rh47.lean ConeLean/PairThreshold.lean ConeLean/ResidueReduction.lean Op56/PhiThird.lean Op57.lean DirichletWeightedResidue.lean Rh45/RouteBGeneral.lean ConeLean/PairCensus.lean Op56/PhiFourth.lean Op56/Asymptotic.lean DirichletWeightedArgumentPrinciple.lean Generic.lean Rh45/XiEntire.lean Op56/PhiFifth.lean RootNumber.lean DirichletExplicit.lean Axioms.lean Rh45.lean Op56.lean DirichletRouteB.lean DirichletPrimeTail.lean DirichletGammaLogDeriv.lean DirichletLogDeriv.lean DirichletArchimedean.lean DirichletAnalytic.lean DirichletCompletedLogDeriv.lean AxiomsConj.lean DirichletL.lean DirichletCompletedSymmetry.lean CertifiedWindow.lean DirichletExplicitWiring.lean DirichletZeroCounting.lean DirichletMellinPrereq.lean DirichletZeroCount2.lean GammaBounds.lean DirichletExplicitWiring2.lean DirichletStripBound.lean AxiomsL.lean
fi

status=0
for f in "$@"; do
  case "$f" in /*) target="$f" ;; *) target="$HERE/$f" ;; esac
  start=$(date +%s)
  if "$LEAN_BIN" -R "$HERE" -o "${target%.lean}.olean" "$target"; then
    printf '[check] OK   %s (%ss)\n' "$f" "$(( $(date +%s) - start ))"
  else
    printf '[check] FAIL %s\n' "$f" >&2
    status=1
  fi
done
exit "$status"
