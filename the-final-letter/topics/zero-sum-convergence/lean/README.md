# Lean layer — zero-sum-convergence

`ZeroSum.lean` (namespace `ZeroSumConvergence`) is imported by the thin
`Topic.lean`; the file name is unique so other topics can `import ZeroSum`.

## Imports

`Mathlib`, plus `FunctionalEquation` from
[`zeta-functional-equation`](../../zeta-functional-equation/lean/FunctionalEquation.lean)
for the `ζ ↔ Λ` zero correspondence (T5).

## Proved here

* T1 — `Set.Infinite` of the trivial zeros, via injectivity of
  `n ↦ −2(n+1)` and `Set.infinite_of_injective_forall_mem`;
* T2 — summability of `Σ exp(−σ²(2(n+1))²)` for `σ > 0`, by comparison with the
  geometric series `r^{n+1}`, `r = exp(−4σ²) < 1`
  (`Summable.of_nonneg_of_le`);
* T3 — the resulting `HasSum`;
* T4/T5 — re-exports of `riemannZeta_ne_zero_of_one_lt_re` and of the
  correspondence from the sibling module.

* T6–T8 — `zeroStrip_mono`, `ncard_zeroStrip_le`, `annulus_bound`: the
  counting function is monotone in `T`, and the counting bound gives the
  dyadic annulus estimate used by the summability criterion.

* T9–T12 — `summable_pow_mul_exp_neg_pow` and its ingredients: `k+1 ≤ 4^k`,
  `4^k e^{−c4^k} → 0` (power times exponential), `(k+1)4^k e^{−σ²4^k} → 0`
  (squeezed between `0` and `(4^k e^{−σ²4^k/2})²`), and the eventual comparison
  with `(1/2)^k` giving summability of the dyadic majorant.

* T13 — `summable_gaussian_of_no_clustering`: if `t k ≥ 1` and
  `k ≤ C·t_k·log t_k`, then `Σ_k e^{−σ²t_k²}` is summable: `log t ≤ t` gives
  `t_k² ≥ k/C`, and comparison with the geometric series `(e^{−σ²/C})^k`
  finishes.

* T14/T15 — `no_clustering_of_counting` and `summable_gaussian_of_counting`:
  the counting bound `ncard {k | t k ≤ T} ≤ C·T·log T` for a monotone
  enumeration with `t k → ∞` gives `k ≤ C·t_k·log t_k`, hence (T13) summability
  of the Gaussian zero series.

* T16 — `sum_le_card_mul_exp`: the per-annulus Gaussian sum is at most
  `card · e^{−σ²T²}` when every point has `|Im ρ| ≥ T`.

* T17 — `exists_dyadic_annulus`: the dyadic covering of `[1, ∞)`, by
  `Nat.find` on `t < 2^(n+1)`.

* T18/T19 — `annulus_ncard_le` and `annulus_sum_le`: the counting bound and the
  Gaussian sum bound on a dyadic annulus, in the exact form T9 sums.

* T20 — `zeroStrip_one_eq_empty`: the counting bound at `T = 1` gives
  `ncard ≤ C·1·log 1 = 0`, hence the strip `|Im ρ| ≤ 1` is empty.

* D3/T21–T23 — `annulusIndex`, its specification
  (`annulusIndex_spec`) and uniqueness (`annulusIndex_unique`), and
  `annulus_zeros_finite`: the zeros in a dyadic annulus are finite.

* T24 — `tsum_le_card_mul_exp`: the `tsum` over a finite set with `|Im| ≥ T`
  is at most `ncard · e^{−σ²T²}` (via `Set.Finite.summable`, `tsum_const` and
  `Nat.card_coe_set_eq`).

* T25/T26 — `zeros_im_ge_one` and `annulus_zeros_finite'`: under the counting
  bound, every nontrivial zero has `1 ≤ |Im ρ|`, and each annulus of zeros is
  finite (as a subset of the zero subtype).

* T27/T28 — `tsum_le_card_mul_of_bound` (the finite-set `tsum` bound for an
  arbitrary index type) and `annulus_zeros_tsum_le`: the Gaussian `tsum` over a
  dyadic annulus of nontrivial zeros is bounded by the counting bound times the
  decay at the inner radius.

* T29/T30 — `summable_annulus_majorant` and `summable_zeros_of_counting`:
  **O4's main theorem**.  The partition `S ≃ Σ_k (S ∩ annulus_k)` is built from
  `Set.sigmaEquiv` and the uniqueness of the annulus index; the fibers are
  finite and bounded by T28; the majorant is summable by T9.

## Defined, not proved

`zeroStrip T` and `ZeroCountingBound` record the Riemann–von Mangoldt input
(finiteness in each strip plus `ncard ≤ C·T·log T`). The reduction from it to the
summability of the zero sum is the open O4b target.
