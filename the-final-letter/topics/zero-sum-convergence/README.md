# Convergence of the zero sum

**Status:** the trivial zeros are infinite, the Gaussian series over them is
summable and has a `HasSum`, and `ζ` has no zeros on `Re s > 1`. The
nontrivial-zero counting bound is recorded as the named input
`ZeroCountingBound`; the reduction from it to the summability of the zero sum is
open. Nothing here proves the Riemann hypothesis.

This is **direction 2** of the two repairs identified in
[`archimedean-prime-evaluation`](../archimedean-prime-evaluation/README.md) as
O4: the explicit formula needs `HasSum (fun ρ ↦ (H_c ρ).re) Zsum` over the
nontrivial zeros. See also
[`zeta-functional-equation`](../zeta-functional-equation/README.md) (direction
1, O3).

## Provenance

Imports Mathlib and the sibling module `FunctionalEquation` from
[`zeta-functional-equation/lean`](../zeta-functional-equation/lean/FunctionalEquation.lean)
for the `ζ ↔ Λ` zero correspondence.

**Theta-side cross-check (I7).**  With D5 of
[`zeta-from-theta`](../zeta-from-theta/README.md) in place,
`ZetaFromTheta.zetaTheta s = riemannZeta s` off `{0,1}` and
`ZetaFromTheta.LambdaTheta s = completedRiemannZeta s` off `{0,1}`.  The T5
correspondence can therefore be cross-checked against the theta-side object:
where `Gammaℝ s ≠ 0`, `zetaTheta s = 0 ↔ LambdaTheta s = 0`.  This is a
cross-reference only — T5's own proof is unchanged, and no zero-counting input
is weakened.

## Objects

* `zeroStrip T` — the zeros of `Λ` with `0 < Re ρ < 1` and `|Im ρ| ≤ T`;
* `ZeroCountingBound` — the Riemann–von Mangoldt input, including finiteness in
  each horizontal strip;
* `H_c(s) = 2πσ² exp(σ²(s − 1/2)²) exp(−c(s − 1/2))` — the Gaussian test
  (computed numerically in `python/programme.py`).

## Theorem ledger

| Kind | Item | Statement | Lean |
|---|---|---|---|
| Theorem | T1 | **The trivial zeros are infinite.** | `trivialZeros_infinite` |
| Theorem | T2 | **The Gaussian series over the trivial zeros is summable.** | `summable_trivialZero_gaussian` |
| Theorem | T3 | **It has a `HasSum`** (the trivial part of the zero sum). | `hasSum_trivialZero_gaussian` |
| Theorem | T4 | `ζ` has no zeros on `Re s > 1` (re-export). | `zeta_ne_zero_of_one_lt_re` |
| Theorem | T5 | The `ζ ↔ Λ` zero correspondence (re-export). | `zeta_zero_iff_completed_zero` |
| Theorem | T6 | The zero strip is monotone in `T`. | `zeroStrip_mono` |
| Theorem | T7 | The counting bound `ncard (zeroStrip T) ≤ C·T·log T` for `T ≥ 1`. | `ncard_zeroStrip_le` |
| Theorem | T8 | **Dyadic annulus bound** `ncard (zeroStrip 2^(k+1)) ≤ C·2^(k+1)·log(2^(k+1))`. | `annulus_bound` |
| Theorem | T9 | **The dyadic majorant is summable:** `Σ_k (k+1)·2^k·e^{−σ²·4^k} < ∞`. | `summable_pow_mul_exp_neg_pow` |
| Theorem | T10 | `(k+1)·4^k·e^{−σ²·4^k} → 0`. | `tendsto_ratio` |
| Theorem | T11 | `4^k·e^{−c·4^k} → 0`. | `tendsto_four_pow_mul_exp` |
| Theorem | T12 | `k+1 ≤ 4^k`. | `succ_le_four_pow` |
| Open | O4a | **`ZeroCountingBound`** — finiteness in each strip and `ncard ≤ C·T·log T`. | `ZeroCountingBound` |
| Theorem | T13 | **O4b (sequence form): summability from the no-clustering bound.** If `t k ≥ 1` and `k ≤ C·t_k·log t_k`, then `Σ_k e^{−σ²t_k²} < ∞` (geometric decay after `t_k² ≥ k/C`). | `summable_gaussian_of_no_clustering` |
| Theorem | T14 | **O4c: the counting bound gives no-clustering.** For a monotone enumeration with `t k → ∞`, `k ≤ C·t_k·log t_k`. | `no_clustering_of_counting` |
| Theorem | T15 | **O4 complete (sequence form): the counting bound implies summability** of the Gaussian zero series. | `summable_gaussian_of_counting` |
| Theorem | T16 | **Annulus sum bound:** a finite set with `|Im ρ| ≥ T` has Gaussian sum at most `card · e^{−σ²T²}`. | `sum_le_card_mul_exp` |
| Theorem | T17 | **Dyadic annulus covering:** every `t ≥ 1` lies in `[2^k, 2^(k+1))` for a unique `k`. | `exists_dyadic_annulus` |
| Theorem | T18 | **Annulus counting bound** from `ZeroCountingBound`. | `annulus_ncard_le` |
| Theorem | T19 | **Per-annulus Gaussian sum bound:** `∑ ≤ C·2^(k+1)·log(2^(k+1))·e^{−σ²4^k}`. | `annulus_sum_le` |
| Theorem | T20 | **The counting bound forces the strip `|Im ρ| ≤ 1` to be empty** — so the zero-sum partition has no "unit ball" part. | `zeroStrip_one_eq_empty` |
| Definition | D3 | The dyadic annulus index of a point with `1 ≤ |Im|`. | `annulusIndex` |
| Theorem | T21–T22 | The index lands in the annulus, and is unique. | `annulusIndex_unique` |
| Theorem | T23 | **The zeros in an annulus form a finite set.** | `annulus_zeros_finite` |
| Theorem | T24 | **Finite-set `tsum` bound:** `∑'_{ρ∈S} e^{−σ²im²} ≤ ncard(S)·e^{−σ²T²}` for finite `S` with `|Im| ≥ T`. | `tsum_le_card_mul_exp` |
| Theorem | T25 | **Every nontrivial zero has `1 ≤ |Im|`** under the counting bound. | `zeros_im_ge_one` |
| Theorem | T26 | Each dyadic annulus of nontrivial zeros is finite (as a subset of the zero subtype). | `annulus_zeros_finite'` |
| Theorem | T27 | **Finite-set `tsum` bound (general type).** | `tsum_le_card_mul_of_bound` |
| Theorem | T28 | **Annulus `tsum` bound** over the nontrivial zeros: `≤ C·2^(k+1)·log(2^(k+1))·e^{−σ²4^k}`. | `annulus_zeros_tsum_le` |
| Theorem | T29 | The annulus majorant is summable. | `summable_annulus_majorant` |
| Theorem | T30 | **O4 main theorem: the counting bound implies summability of the Gaussian over the nontrivial zeros.** | `summable_zeros_of_counting` |
| Theorem | T30 | **O4 closed:** the counting bound implies `Summable` of `e^{−σ²·Im²}` over the nontrivial zeros (via the `Σ`-type partition with `Set.sigmaEquiv` and `summable_sigma_of_nonneg`). | `summable_zeros_of_counting` |

## Computations

| Kind | Item | Statement | Test |
|---|---|---|---|
| Computation | C1 | The zero count is non-decreasing in `T`. | `test_zero_count_monotone` |
| Computation | C2 | `N(T)/(T log T) < 1` for `T = 20, 50, 100`. | `test_counting_ratio_bounded` |
| Computation | C3 | The Gaussian zero sums stabilise as `T` grows. | `test_gaussian_zero_partial_sums_converge` |
| Computation | C4 | The trivial-zero Gaussian sum has a limit. | `test_trivial_gaussian_sum_converges` |

## Honest scope

T1–T3 settle the **trivial** part of the zero sum. The nontrivial part needs
the counting bound (O4a, the Riemann–von Mangoldt formula) and the comparison
argument (O4b). Neither is asserted here; both are recorded so that the
obstruction in `archimedean-prime-evaluation` has a concrete home.

## Reproduce

```bash
cd topics/zero-sum-convergence/lean && ./check.sh ZeroSum.lean
cd topics/zero-sum-convergence && python3 -m pytest -q tests
```
