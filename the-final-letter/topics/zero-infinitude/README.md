# Infinitude of the nontrivial zeros — research programme

**Status:** **done** — infinitude of the nontrivial zero set is Lean-proved
(`infinite_nontrivialZeros`, T42).  With it, `ZeroTailSummable` is
**unconditional** (T43); the log-growth and ordinate-growth inputs were
already discharged.
**Part of:** [weil-positivity](../weil-positivity/README.md) · [execution handoff](../weil-positivity/HANDOFF.md) · [O2 handoff](../angular-partition-method/HANDOFF-O2.md) · [topic index](../README.md).

## What the programme is

`ZeroTailSummable` — the convergence of the Gaussian-weighted zero tail —
needs an enumeration of the nontrivial zeros.  The library already has:

- countability (`xi₀_zeros_countable`),
- isolatedness and local finiteness (`xi₀_zero_isolated`,
  `xi₀_zeros_finite_in_closedBall`),
- the zero-count bound (`xi₀_zero_count_bound`, `xi₀_zero_count_bound_of_log_le`),
- inverse-square summability (`xi₀_zeros_inv_sq_summable`),
- the enumeration interface (`exists_nontrivial_xi₀_enumeration`).

What it does **not** have is **infinitude** of the nontrivial zero set.  That
is the missing fact needed to turn countability into a `Denumerable` instance
and hence into an injective enumeration.

Earlier revisions of this programme also carried the linear log-growth
hypothesis and the ordinate growth `|Im(a n)| → ∞` as open inputs.  Both are
now discharged:

- the unconditional order-one growth bound `exists_bound_log_norm_xi₀`
  (`log‖ξ₀ z‖ ≤ A‖z‖log(‖z‖+2)+B`) feeds
  `xi₀_zeros_inv_sq_summable_of_log_growth`, so the inverse-square zero weight
  is summable without hypothesis;
- summability forces the inverse-square terms to zero, hence `|Im(a n)| → ∞`
  (`tendsto_abs_atTop_of_summable_inv_sq`), so ordinate growth is automatic.

The resulting capstone
`exists_enumeration_and_zeroTailSummable_of_infinite` takes **only**
`Infinite {z // ξ₀ z = 0 ∧ 0 < Re z}` and a width `σ > 0` as hypotheses.

The consumer is [weil-positivity](../weil-positivity/README.md); the programme order and acceptance criteria are in [its execution handoff](../weil-positivity/HANDOFF.md).

## Ledger

| ID | Kind | Statement | Lean |
|---|---|---|---|
| T1 | Theorem | The nontrivial zero set `{z | ξ₀ z = 0 ∧ 0 < Re z}` is countable. | `nontrivialZeros_countable` |
| T2 | Theorem | The nontrivial-zero subtype is `Countable`. | `nontrivialZeros_subtype_countable` |
| T3 | Theorem | A nontrivial `ξ₀` zero is a zero of `completedZeta`. | `completedZeta_zero_of_xi₀_zero` |
| T4 | Theorem | Summability of the inverse-square ordinate weight forces `|γ n| → ∞`. | `tendsto_abs_atTop_of_summable_inv_sq` |
| T5 | Theorem | Any injective enumeration of nontrivial zeros has a summable Gaussian zero tail (no growth hypotheses). | `zeroTailSummable_of_nontrivial_xi₀_enumeration'` |
| T6 | Theorem | Infinitude makes the nontrivial-zero subtype `Denumerable`. | `nontrivialZeros_denumerable_of_infinite` |
| T7 | Theorem | Infinitude yields an injective enumeration with range the nontrivial zero set. | `exists_nontrivial_xi₀_enumeration_of_infinite` |
| T8 | Theorem | Infinitude yields an enumeration together with `ZeroTailSummable`. | `exists_enumeration_and_zeroTailSummable_of_infinite` |
| T9 | Theorem | The nontrivial-zero subtype is `Denumerable` iff it is infinite. | `nontrivialZeros_denumerable_iff_infinite` |
| T10 | Theorem | The Gaussian zero tail is monotone in the width `σ`. | `zeroTailSummable_mono` |
| T11 | Theorem | Infinitude makes the nontrivial zeros unbounded in ordinate. | `exists_zero_abs_im_gt` |
| T12 | Theorem | The multiplicity-aware finite zero product is entire. | `differentiable_finiteZeroProduct` |
| T13 | Theorem | The finite zero product is nonzero away from its zero set. | `finiteZeroProduct_ne_zero` |
| T14 | Theorem | At a prescribed zero the finite product has order exactly the multiplicity `m u`. | `meromorphicOrderAt_finiteZeroProduct_of_mem` |
| T15 | Theorem | Away from the zero set the finite product has order zero. | `meromorphicOrderAt_finiteZeroProduct_of_not_mem` |
| T16 | Theorem | Away from a finite set containing all zeros, `ξ₀` has order zero. | `meromorphicOrderAt_xi₀_of_not_mem` |
| T17 | Theorem | The analytic order of `ξ₀` is finite everywhere. | `analyticOrderAt_xi₀_ne_top` |
| T18 | Theorem | At a zero, the meromorphic order of `ξ₀` is its analytic multiplicity. | `meromorphicOrderAt_xi₀_of_mem` |
| T19 | Theorem | If the zero set is finite, the quotient by the finite zero product has an entire zero-free representative. | `exists_entire_zeroFree_quotient_of_finite_zeros` |
| T20 | Theorem | The finite zero product times the quotient representative recovers `ξ₀`. | `finiteZeroProduct_mul_quotient_eq` |
| T21 | Theorem | If the zero set is finite, `ξ₀` is the finite product times `exp` of an entire function. | `exists_entire_log_factorization_of_finite_zeros` |
| T22 | Theorem | If the entire exponent has linear real growth, the finite-zero factorization is affine. | `exists_affine_factorization_of_finite_zeros_of_growth` |
| T23 | Theorem | A nonconstant complex polynomial is at least `1` in modulus on every sufficiently large circle. | `exists_norm_eval_ge_one_on_sphere` |
| T24 | Theorem | Maximum-modulus corollary: an entire function bounded on a circle is bounded by the same constant on the closed disk. | `norm_le_of_forall_sphere_norm_le` |
| T25 | Theorem | The zero-free quotient is bounded on a disk by the `ξ₀` growth when `‖P‖ ≥ 1` on the boundary circle. | `norm_quotient_le_on_ball` |
| T26 | Theorem | A subquadratic bound `O(‖z‖^{3/2})` on the entire exponent makes the finite-zero factorization affine. | `exists_affine_factorization_of_finite_zeros_of_subquadratic` |
| T27 | Theorem | `log(1+x) ≤ 2√(1+x)` for `x ≥ 0`, the logarithmic input to the subquadratic estimate. | `log_one_add_le_two_sqrt` |
| T28 | Theorem | The named subquadratic input `FiniteZeroSubquadraticBound` makes the finite-zero factorization affine. | `exists_affine_factorization_of_finite_zeros_of_bound` |
| T29 | Theorem | For `r ≥ 0`, `1 + r ≤ (1 + r)^{3/2}`. | `one_add_le_rpow_three_halves` |
| T30 | Theorem | `max R0 (r+1) · log(max R0 (r+1) + 2) ≤ C (1+r)^{3/2}` for `r ≥ 0`. | `rlog_bound` |
| T31 | Theorem | `(1+r)^{3/2} ≤ 2^{3/2}(1+r^{3/2})` for `r ≥ 0`. | `one_add_rpow_three_halves_le` |
| T32 | Theorem | The quotient estimate, `r log r` bound and subquadratic comparison assemble into `FiniteZeroSubquadraticBound g`. | `finiteZeroSubquadraticBound_of_quotient` |
| T33 | Theorem | `logDeriv P z = ∑_{w∈S} m_w/(z−w)` for the finite zero product, `z ∉ S`. | `logDeriv_finiteZeroProduct` |
| T34 | Theorem | `logDeriv P` is bounded along the large real axis. | `exists_norm_logDeriv_finiteZeroProduct_le` |
| T35 | Theorem | `logDeriv Λ x = logDeriv P x + b − 1/x − 1/(x−1)` under the finite affine factorization. | `logDeriv_completedRiemannZeta_eq_of_finite_factorization` |
| T36 | Theorem | On `Re s > 1`, the log-derivatives of the two completed zeta functions agree. | `logDeriv_completedZeta_eq_completedRiemannZeta` |
| T37 | Theorem | Real-part bound `Re logDeriv Λ s ≤ M + Re b` under the finite affine factorization. | `re_logDeriv_completedRiemannZeta_le` |
| T38 | Theorem | Finite zeros together with the affine factorization are contradictory. | `false_of_affine_factorization` |
| T39 | Theorem | Every zero of `ξ₀` has positive real part. | `xi₀_zero_re_pos` |
| T40 | Theorem | Every zero of `ξ₀` has real part below `1`. | `xi₀_zero_re_lt_one` |
| T41 | Theorem | The finite zero product is at least `1` in modulus outside a large ball. | `exists_finiteZeroProduct_norm_ge_one` |
| T42 | Theorem | **The nontrivial zero set is infinite.** | `infinite_nontrivialZeros` |
| T43 | Theorem | **The zero tail is unconditional**: an injective enumeration with summable inverse-square tail exists for every `σ > 0`. | `exists_enumeration_and_zeroTailSummable` |
| T44 | Theorem | The same enumeration makes the Gaussian weight series summable. | `exists_enumeration_and_gaussian_summable` |
| T45 | Theorem | Under RH, the maximal-distance-zero precondition of the full-block route holds. | `MaximalDistanceZero`, `maximalDistanceZero_of_riemannHypothesis` |
| T46 | Theorem | If the maximal-distance zero lies on the critical line, RH follows. | `riemannHypothesis_of_maximalDistanceZero_witness_onLine` |
| T47 | Theorem | **RH is equivalent** to the existence of an on-line maximal-distance zero witness. | `riemannHypothesis_iff_exists_onLine_maximalDistanceZero` |
| C1 | Computation | The first ten tabulated ordinates are strictly increasing. | `tests/test_programme.py` |
| C2 | Computation | The tabulated zero count is monotone and exact on the table. | `tests/test_programme.py` |
| C3 | Computation | The `n/log n` model weights are positive, decaying, and have bounded partial sums. | `tests/test_programme.py` |
| C4 | Computation | The inverse-square weights are positive and decreasing, and their `ε`-threshold is consistent with every tabulated ordinate. | `tests/test_programme.py` |

## Harvested proofs

From [`index-lean/index.md`](../index-lean/index.md) and the topic pages:

| Theorem | Where | Use |
|---|---|---|
| `xi₀_zeros_countable` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | countability input |
| `xi₀_zero_isolated` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | discreteness |
| `xi₀_zeros_finite_in_closedBall` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | local finiteness |
| `xi₀_zero_count_bound` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | Riemann–von Mangoldt input |
| `xi₀_zeros_inv_sq_summable` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | tame-case tail summability |
| `exists_nontrivial_xi₀_enumeration` | [`ZeroTail.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZeroTail.lean.md) | enumeration packaging |
| `xi₀_eq_mul_completedZeta` | [`ZeroTail.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZeroTail.lean.md) | zero-set identification |
| `xi₀_zero_re_open_strip` | [`ZeroTail.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZeroTail.lean.md) | strip bound |
| `exists_bound_log_norm_xi₀` | [`ZetaStrip.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZetaStrip.lean.md) | unconditional log growth |
| `xi₀_zeros_inv_sq_summable_of_log_growth` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | summability from log growth |
| `summable_inv_sq_of_injective_enumeration` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | transfer to an enumeration |
| `summable_inv_sq_im_of_strip` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | imaginary-part weight |
| `zeroTailSummable_of_inv_sq` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | tail from inverse-square weight |
| `tendsto_digamma_nat_re_atTop` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | analytic input for infinitude |

## Open items and plan

1. **Infinitude (the only open item).**  Show the nontrivial zero set is
   infinite.  The library's `tendsto_digamma_nat_re_atTop` is recorded as the
   analytic input; the argument-principle route needs a growth estimate on a
   large rectangle, and the finite-zero Hadamard factorisation route needs a
   multiplicity-aware finite canonical product.
2. ~~**`Denumerable`.**~~  Discharged as T6 from T2 plus infinitude.
3. ~~**Ordinate growth.**~~  Discharged as T4 from inverse-square summability;
   no separability or ordering input is needed.
4. ~~**Tail capstone.**~~  Discharged as T5 and T8; the capstone now needs only
   infinitude and `σ > 0`.

### Route to infinitude: the finite-zero contradiction

> **Clarification (2026-11-07).**  `completedZeta_trivial_zero` concerns the
> **junk value** of `completedZeta` at the Gamma poles, not the meromorphic
> `completedRiemannZeta` used by `xi₀`.  The functional equation gives
> `Λ(-2(n+1)) = Λ(2n+3) ≠ 0`, so these points are **not** zeros of `ξ₀`.  The
> finite-zero route is therefore not obstructed by trivial zeros.  What remains
> is to prove that every zero of `ξ₀` lies in `0 < Re < 1` (the `Re ≤ 0` and
> `Re ≥ 1` cases follow from the functional equation and ζ nonvanishing), so
> that the finite nontrivial zero set is the full zero set.  **This is now
> Lean-proved:** T39–T40 show every zero of `ξ₀` lies in the open critical
> strip.

A concrete route to the only open item is the following.

1. **Finite zeros give a finite canonical product with multiplicities.**
   If the zero set is finite, let `P(z) = ∏_{ξ₀(w)=0} (z − w)^{m_w}`, where
   `m_w = analyticOrderNatAt ξ₀ w`.  **Lean-proved:** `finiteZeroProduct`
   (T12–T13), its divisor (T14–T15), the off-zero-set order of `ξ₀` (T16),
   finiteness of the analytic order (T17) and the on-zero multiplicity match
   (T18).
2. **The quotient is entire and zero-free.**  `Q = ξ₀/P` has no zeros and no
   poles, so `Q = e^{a+bz}` by the order-one/zero-free argument (the library's
   `exists_entire_zeroFree_quotient` plus the `subquadratic` affine route, or
   the existing `HasLogGrowthOne` interface if the quotient growth is
   controlled).  **Lean-proved:** existence of the entire zero-free
   representative (T19) and the factorization identity `ξ₀ = P·Q` (T20).
   **Lean-proved conditionally:** linear real growth of the entire exponent
   gives the affine factorization (T22), and the subquadratic input
   `FiniteZeroSubquadraticBound` suffices (T28).  **Remaining:** prove that growth
   bound.  A concrete route is the maximum-modulus argument: for large
   `R`, `‖P w‖ ≥ 1` on the circle `|w| = R` (`Polynomial.tendsto_norm_atTop`),
   and the maximum-modulus principle for the zero-free `Q = exp(g)` (T24)
   gives
   `Re g z ≤ max_{|w|=R} log‖ξ₀ w‖ ≤ A R log(R+2) + B` for `|z| ≤ R`.
   With `R = |z| + 1` this is `O(‖z‖ log‖z‖)`, hence `O(‖z‖^{3/2})` (the
   circle-to-disk bound is T25), and the
   library's `subquadratic_eq_affine_of_re_le_rpow` makes `g` affine.
3. **Real-axis log-derivative.**  For `s = 2m+2`, `ξ₀(s) = s(s−1)Z(s)`, hence
   `Z(s) = P(s)/(s(s−1))` and
   `logDeriv Z(s) = P'(s)/P(s) − 1/s − 1/(s−1)`.
   **Lean-proved:** the finite-product identity (T33), the real-axis bound on
   `P'/P` (T34) and the full identity
   `logDeriv Λ x = logDeriv P x + b − 1/x − 1/(x−1)` (T35).
4. **Contradiction.**  For large real `s = 2m+2`, T34 keeps `Re(logDeriv P s)`
   bounded and the two `1/s` terms vanish, so `Re logDeriv Z(2m+2)` stays
   bounded.  But the harvested `tendsto_logDeriv_completedZeta_re_atTop` says it
   tends to `+∞`.  Hence the zero set cannot be finite.
   **Lean-proved:** T38 derives the contradiction from finite zeros and the
   affine factorization, using T34–T37 and the harvested real-axis limit.

   **Implementation note.**  The degree-asymptotic lemmas
   `Polynomial.isLittleO_atTop_of_degree_lt` are stated over linearly ordered
   fields and do not apply to `ℂ`.  The practical route is therefore the root
   partial fraction: split `P` over `ℂ` via `Polynomial.Splits.eq_prod_roots`,
   then use the analytic `logDeriv_prod` (or a multiset induction) to obtain
   `P'/P = ∑ 1/(s−r)` and bound each term by `1` for `|s−r| ≥ 1`.

The Lean interfaces needed are `xi₀_eq_weighted`, `analyticOrderNatAt`,
`meromorphicOrderAt`, `exists_entire_zeroFree_quotient`,
`Polynomial.Splits.eq_prod_roots` and the analytic `logDeriv_prod`, and
`tendsto_logDeriv_completedZeta_re_atTop`.

## Objects and notation

The objects are the zero set of `ξ₀` (Hadamard's entire form of the completed zeta), its nontrivial part `{z | ξ₀ z = 0 ∧ 0 < Re z}`, the completed zeta `Z`, and the Gaussian tail weights `exp(−σ²γ²)` over the ordinates.

## Python layer

`python/programme.py` provides the tabulated first ten ordinates, `zero_count_up_to`, `gaussian_weight`, the `n/log n` model `n_log_n_model`, `partial_tail`, and the inverse-square weight `inverse_square_weight` with its `growth_threshold`.  Run `python3 -m pytest the-final-letter/topics/zero-infinitude/tests -q`.

## Lean layer

`lean/Topic.lean` proves T1–T47.  It now proves infinitude as well itself; T6–T8 take `Infinite {z // ξ₀ z = 0 ∧ 0 < Re z}` as an
explicit hypothesis and never axiomatise it.

## Provenance and source

- [O2 handoff](../angular-partition-method/HANDOFF-O2.md) — the reduction that consumes this programme.
- [`index-lean/index.md`](../index-lean/index.md) — the harvested proof pages.
- [`scraps.html`](../../scraps.html) — the site's claim inventory.
- [`topics/README.md`](../README.md) — all topic folders.

## Build and test

```bash
the-final-letter/topics/zero-infinitude/lean/check.sh
python3 -m pytest the-final-letter/topics/zero-infinitude/tests -q
```
