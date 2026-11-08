# The `Z'/Z` growth bound — research programme

**Status:** the vertical input is **proved unconditionally on the library's
contour** `Re s = 2` and `Re s = −1`: the Gamma lower bound is a theorem at
`Re s = 2`, and the functional-equation transfer covers the left line.  The
programme is complete for the explicit-formula vertical sides.
**Part of:** [weil-positivity](../weil-positivity/README.md) · [execution handoff](../weil-positivity/HANDOFF.md) · [O2 handoff](../angular-partition-method/HANDOFF-O2.md) · [topic index](../README.md).

## What the programme is

`VerticalLogDerivIntegrable` is the remaining integrability input on the
vertical sides of the explicit formula.  `verticalLogDerivIntegrable_of_linear_bound`
already reduces it to the standard bound

`‖(Z'/Z)(x+iy)‖ ≤ M (1+|y|)`

plus measurability.  This programme supplies that bound.  The pointwise core
is elementary: separate upper and lower bounds on `Z'` and `Z` give a bound
on `Z'/Z`.

The core now also proves that **any polynomial growth bound suffices**:

`‖(Z'/Z)(x+iy)‖ ≤ M (1+|y|)^k`

implies `VerticalLogDerivIntegrable`, because every polynomial is dominated by
the Gaussian test function.  Since Stirling estimates naturally produce
polynomial (not necessarily linear) bounds, this widens the usable interface.
The linear theorem is recovered as the case `k = 1`.

Measurability is no longer a hypothesis.  The core proves that `ζ`, the
completed zeta `Z` and `Z'/Z` are measurable, and that the vertical-line
product `(Z'/Z)·H_c` is `AEStronglyMeasurable`.

The growth interface is wider still: any bound `‖Z'/Z‖ ≤ M exp(A y²)` with
`A < σ²` also gives `VerticalLogDerivIntegrable`, because the Gaussian test
function dominates it.  This matters because Stirling/Gamma estimates
naturally produce exponential-in-`y²` (or `y log y`) bounds, not just
polynomials.

The consumer is [weil-positivity](../weil-positivity/README.md); the programme order and acceptance criteria are in [its execution handoff](../weil-positivity/HANDOFF.md).

## Ledger

| ID | Kind | Statement | Lean |
|---|---|---|---|
| T1 | Theorem | `0 < a ≤ ‖f s‖` and `‖deriv f s‖ ≤ b` imply `‖logDeriv f s‖ ≤ b/a`. | `norm_logDeriv_le_of_bounds` |
| T2 | Theorem | A linear `Z'/Z` bound plus measurability gives `VerticalLogDerivIntegrable`. | `verticalLogDerivIntegrable_of_linear_bound` (harvested) |
| T3 | Theorem | `(1+|y|)exp(−σ²y²/2)` is integrable. | `integrable_one_add_abs_mul_exp_neg_sq` (harvested) |
| T4 | Theorem | `|y|^k exp(−b y²)` is integrable for every `k` and `b > 0`. | `integrable_abs_pow_mul_exp_neg_mul_sq` |
| T5 | Theorem | `(1+|y|)^k exp(−σ²y²/2)` is integrable for every `k`. | `integrable_one_add_abs_pow_mul_exp_neg_sq` |
| T6 | Theorem | A polynomial `Z'/Z` bound plus measurability gives `VerticalLogDerivIntegrable`. | `verticalLogDerivIntegrable_of_polynomial_bound` |
| T7 | Theorem | The polynomial theorem specialises to the harvested linear bound. | `verticalLogDerivIntegrable_of_linear_bound'` |
| T8 | Theorem | `ζ`, `Z` and `Z'/Z` are measurable. | `measurable_riemannZeta`, `measurable_completedZeta`, `measurable_logDeriv_completedZeta` |
| T9 | Theorem | The vertical-line product `(Z'/Z)·H_c` is `AEStronglyMeasurable`. | `aestronglyMeasurable_logDeriv_mul_gaussian` |
| T10 | Theorem | A polynomial bound alone gives `VerticalLogDerivIntegrable` (no measurability hypothesis). | `verticalLogDerivIntegrable_of_polynomial_bound'` |
| T11 | Theorem | The linear case also needs no measurability hypothesis. | `verticalLogDerivIntegrable_of_linear_bound''` |
| T12 | Theorem | A circle bound `M` at radius `R` and a lower bound `a ≤ ‖f s‖` give `‖f'/f s‖ ≤ M/(R a)`. | `norm_logDeriv_le_of_sphere_bound` |
| T13 | Theorem | The same bound for the completed zeta, from explicitness on the closed ball. | `norm_logDeriv_completedZeta_le_of_sphere` |
| T14 | Theorem | A bound `M exp(A y²)` with `A < σ²` plus measurability gives `VerticalLogDerivIntegrable`. | `verticalLogDerivIntegrable_of_exp_bound` |
| T15 | Theorem | The same with no measurability hypothesis. | `verticalLogDerivIntegrable_of_exp_bound'` |
| T16 | Theorem | A point on a circle/closed ball of radius `R` around `x+iy` has real part at least `x−R`. | `re_ge_of_mem_sphere_sub`, `re_ge_of_mem_closedBall_sub` |
| T17 | Theorem | On any circle with `x−R > 1`, `Z` satisfies `‖Z z‖ ≤ M exp(A y²)`; the Gaussian upper half of Stirling is proved from the `ξ₀` growth. | `exists_circle_growth_completedZeta_right` |
| T18 | Theorem | Upper bound `M exp(A y²)` plus lower bound `a exp(−B|y|)` with `A+B/2 < σ²` gives `VerticalLogDerivIntegrable`. | `verticalLogDerivIntegrable_of_right_growth_lower` |
| T19 | Theorem | Given only the exponential lower bound `a exp(−B|y|) ≤ ‖Z(x+iy)‖`, there is a width `σ > 0` with `VerticalLogDerivIntegrable`. | `exists_positive_verticalLogDerivIntegrable_of_right_lower` |
| T20 | Theorem | For `Re s ≥ 2`, `‖ζ(s)‖ ≥ 1/4`; this is the zeta half of the right-line lower bound. | `exists_zeta_lower_bound_right` |
| T21 | Theorem | If `VerticalLogDerivIntegrable` holds on `Re s = 2`, it holds on `Re s = −1` (functional equation and `‖H_c(−1+iy)‖ = e^{3c}‖H_c(2−iy)‖`). | `verticalLogDerivIntegrable_left_of_right` |
| T22 | Theorem | `GammaRLowerBound` plus the zeta lower bound yields a width `σ > 0` with `VerticalLogDerivIntegrable` on `Re s = 21/10`. | `exists_verticalLogDerivIntegrable_right_of_gammaR_lower` |
| T23 | Theorem | `|sinh x| ≤ e^{|x|}`. | `abs_sinh_le_exp` |
| T24 | Theorem | `‖sin(π(u+iv))‖ ≤ 2 e^{π|v|}`. | `norm_sin_pi_mul_le` |
| T25 | Theorem | `Γ(1−w) = Γ(2−w)/(1−w)` for `0 < Re w < 1`. | `Gamma_one_sub_eq` |
| T26 | Theorem | `‖Γ(1−w)‖ ≤ Γ(2−Re w)/‖1−w‖` for `0 < Re w < 1`. | `Gamma_one_sub_norm_le` |
| T27 | Theorem | Reflection lower bound: for `0 < u < 1`, `π|v|/(2Γ(2−u)e^{π|v|}) ≤ ‖Γ(u+iv)‖`. | `Gamma_lower_reflection` |
| T28 | Theorem | Shifted Gamma lower bound: `min m (π/(2Γ(39/20))) e^{−(π+1)|v|} ≤ ‖Γ(21/20+iv)‖`. | `exists_Gamma_lower_shift` |
| T29 | Theorem | `GammaRLowerBound` is proved. | `gammaR_lower_bound` |
| T30 | Theorem | For every `c` there is `σ > 0` with `VerticalLogDerivIntegrable` on `Re s = 21/10`. | `exists_verticalLogDerivIntegrable_right` |
| T31 | Theorem | Transfer `21/10 → −11/10` by the functional equation. | `verticalLogDerivIntegrable_left_of_right_2110` |
| T32 | Theorem | For every `c` there is `σ > 0` with vertical integrability on `Re s = −11/10`. | `exists_verticalLogDerivIntegrable_left_2110` |
| T33 | Theorem | Reflection lower bound at `Re z = 1`: `‖Γ(1+iy)‖ ≥ π|y|/(2e^{π|y|})`. | `Gamma_one_add_I_lower` |
| T34 | Theorem | Gamma lower bound at `Re s = 2`: `∃ a B, a e^{−B|y|} ≤ ‖Γℝ(2+iy)‖`. | `gammaR_lower_bound_two` |
| T35 | Theorem | For every `c` there is `σ > 0` with vertical integrability on `Re s = 2`. | `exists_verticalLogDerivIntegrable_two` |
| T36 | Theorem | For every `c` there is `σ > 0` with vertical integrability on `Re s = −1`. | `exists_verticalLogDerivIntegrable_neg_one` |
| C1 | Computation | `|ζ'/ζ(σ+it)|/(1+|t|)` is finite on a sampled grid away from zeros. | `tests/test_programme.py` |
| C2 | Computation | The sampled ratio is small for `σ ≥ 3/2`, and positive. | `tests/test_programme.py` |
| C3 | Computation | The polynomial majorant ratio is at most one, the Gaussian polynomial moments are finite with the correct recurrence, and a polynomial bound holds on the sampled grid. | `tests/test_programme.py` |

## Harvested proofs

| Theorem | Where | Use |
|---|---|---|
| `verticalLogDerivIntegrable_of_linear_bound` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | integrability reduction |
| `integrable_one_add_abs_mul_exp_neg_sq` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | majorant integrability |
| `tendsto_vertical_integral_logDeriv` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | consumes the integrability |
| `continuousOn_logDeriv_completedZeta` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | continuity on `Re s > 1` |
| `exists_bound_norm_zeta_strip_polefree` | [`ZetaStrip.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZetaStrip.lean.md) | polynomial growth of `ζ` |
| `xigrowth_norm_riemannZeta_le_quadratic` | [`ZetaStrip.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZetaStrip.lean.md) | quadratic bound for `ζ` |
| `norm_riemannZeta_le_one_add_inv_sub_one` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | `Re s > 1` bound |
| `digamma_conj`, `continuousAt_digamma_of_re_pos` | [`Archimedean.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Archimedean.lean.md) | archimedean factor |

## Open items and plan

1. **Upper bound on `Z'`.**  A Cauchy/Stirling estimate on a vertical line,
   from the polynomial growth of `Z` on a surrounding disk.  The Cauchy step
   is now T12/T13: a circle bound `M` at radius `R` and a lower bound
   `a ≤ ‖Z s‖` give `‖Z'/Z s‖ ≤ M/(R a)`.  What remains is supplying the circle
   bound from Stirling.  The upper half is now **proved** on any line with
   `x − R > 1` (T17).  T18 reduces the remaining input to the exponential lower
   bound `a exp(−B|y|) ≤ ‖Z(x+iy)‖` with `A + B/2 < σ²`, and T20 proves the
   zeta half `‖ζ‖ ≥ 1/4` on `Re ≥ 2`, leaving only the Gamma factor.  T6 and T14 mean a
   polynomial or `exp(A y²)` upper bound is enough.
2. **Lower bound on `Z`.**  A zero-free region, or a Jensen-type lower bound
   away from the zeros.
3. **Assemble** T1 into a polynomial bound `‖Z'/Z‖ ≤ M(1+|y|)^k`.
4. ~~**Measurability.**~~  Discharged as T8–T9.
5. **Feed** T10/T11 to obtain `VerticalLogDerivIntegrable`; these take only
   the polynomial bound and `σ > 0`.

## Objects and notation

The objects are the completed zeta `Z`, its logarithmic derivative `Z'/Z`, the vertical line `Re s = x`, and the Gaussian test function `H_c` on that line.

## Python layer

`python/programme.py` provides `zeta_log_derivative`, `linear_ratio`, `max_ratio`, `sample_heights`, the polynomial majorant ratio `polynomial_majorant_ratio`, the Gaussian moments `gaussian_polynomial_moment`, and `polynomial_bound_holding`.  Run `python3 -m pytest the-final-letter/topics/log-derivative-growth/tests -q`.

## Lean layer

`lean/Topic.lean` proves T1–T36.  The Gaussian upper bound on the right is
proved (T17), the Cauchy step (T12–T13) and measurability (T8–T9) are proved,
and T18 isolates the remaining input: the exponential lower bound on `Z`.  The
assembled polynomial `Z'/Z` bound is not claimed without that lower bound.

## Provenance and source

- [O2 handoff](../angular-partition-method/HANDOFF-O2.md) — the reduction that consumes this programme.
- [`index-lean/index.md`](../index-lean/index.md) — the harvested proof pages.
- [`scraps.html`](../../scraps.html) — the site's claim inventory.
- [`topics/README.md`](../README.md) — all topic folders.

## Build and test

```bash
the-final-letter/topics/log-derivative-growth/lean/check.sh
python3 -m pytest the-final-letter/topics/log-derivative-growth/tests -q
```
