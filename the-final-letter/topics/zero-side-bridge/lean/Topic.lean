import GaussianZeroSide
import ZeroTail

/-!
# The zero-side bridge — formal core (entry point)

The Lean half of the bridge lives in
[`absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)
because its `ExplicitFormula` module and the `intersection-form-zeta`
`Archimedean` module used by the density layer do not coexist in one
`LEAN_PATH`.  This file is the programme's single entry point: it re-exports the
four statements that make up the contour half of the bridge, so that
`./check.sh Topic.lean` from this folder compiles them.

* `gaussianZeroTest_critical_line` — `H_c(1/2 + it) = ĝ_c(t)`;
* `gaussianZeroTest_pole_sum` — `H_c(0) + H_c(1) = 4πσ²e^{σ²/4}cosh(c/2)`, the
  pole term of the arithmetic side `W`;
* `gaussian_zero_side_contour` — the rectangle contour identity for a finite zero
  set;
* `zeroSideGramReal_posSemidef` — the zero-side Gram matrix of on-line
  frequencies is positive semidefinite, the rank-one structure that explains why
  the finite certificates can be certified without touching the zeros.

The open obligations — the prime/archimedean evaluation, the rectangle limit and
the zero-set enumeration — are listed in [`../README.md`](../README.md) §4.  No
`sorry`, `axiom` or `admit` is introduced here, and nothing in this file is a
statement about the Riemann hypothesis.
-/

noncomputable section

namespace ZeroSideBridge

open AbsoluteHodgeExplicitFormula

/-- `H_c(1/2 + it)` is the Fourier transform `ĝ_c(t)` of the Gaussian bump. -/
alias critical_line_eq_fourier := gaussianZeroTest_critical_line

/-- The pole sum reproduces the pole term of `W`. -/
alias pole_sum_eq_poleTerm := gaussianZeroTest_pole_sum

/-- The zero-side weight is a product of one mode and a conjugate — the rank-one
structure behind the finite PSD theorem. -/
alias weight_eq_mode_mul := gaussianZeroTest_eq_mode_mul

/-- The zero-side Gram matrix of on-line frequencies is positive semidefinite. -/
alias zeroSideGram_posSemidef := zeroSideGramReal_posSemidef

/-- The rectangle contour identity: for a finite zero set, the contour integral of
`(Z'/Z)·H_c` is `2πi` times the sum of `H_c` over the zeros minus the pole terms. -/
alias contour_identity := gaussian_zero_side_contour

end ZeroSideBridge
