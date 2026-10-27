# `Rh45/PolygammaSeries.lean` — the polygamma series

## What landed

Module `Rh45/PolygammaSeries.lean`.  Items 1–3 live in namespace
**`Rh45RouteBAnalytic`** (the routing namespace already used by
`Rh45/GammaProduct.lean`); the archimedean-facing items 4–5 and the `k = 0` bound
live in namespace **`Rh45`** because they mention `digammaLine`, `Psi` and
`psiSeriesBound`.

`./check.sh --all` is green: **13/13** modules, including `Rh45.lean`.  No
`sorry`, no `axiom`, no `admit`, no `native_decide`, no
`set_option maxHeartbeats`.  `#print axioms` on every headline theorem below is
exactly `[propext, Classical.choice, Quot.sound]`.

### 1. The iterated derivative of the finite log-derivative

```lean
theorem logDeriv_GammaSeq_of_ne (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹

theorem eventuallyEq_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) =ᶠ[𝓝 s]
      fun w : ℂ => Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (w + (j : ℂ))⁻¹

theorem iteratedDeriv_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) (k : ℕ) :
    deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s
      = if k = 0 then Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
        else (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
          ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1)
```

The landed `Rh45RouteBAnalytic.logDeriv_GammaSeq` (in `Rh45/GammaProduct.lean`)
assumes `0 < re s`; the *local* form of the identity needs the weaker hypothesis
`∀ j ≤ n, s + j ≠ 0`, so `logDeriv_GammaSeq_of_ne` re-runs the same computation
with that hypothesis, and `eventuallyEq_logDeriv_GammaSeq` records the resulting
`=ᶠ[𝓝 s]` statement (the set `{w | ∀ j ≤ n, w + j ≠ 0}` is open and contains
`s`).  `deriv^[k]` is local (`Filter.EventuallyEq.iteratedDeriv_eq`, through
`iteratedDeriv`), so item 1 reduces to the derivative of the *closed form*
`w ↦ log n - ∑_{j≤n} (w+j)⁻¹`:

* the constant `log n` is killed for `k ≥ 1` (`iteratedDeriv_const_sub`,
  `iteratedDeriv_neg`);
* the finite sum is differentiated term by term
  (`iteratedDeriv_fun_sum`, the `ContDiffAt` side conditions coming from
  `s + j ≠ 0`);
* each summand is `iter_deriv_inv_linear` with `c = 1`, `d = j`:
  `deriv^[k] (w ↦ (w+j)⁻¹) = (-1)^k k! (· + j)^{-1-k}`;
* the outer minus sign turns `(-1)^k` into `(-1)^{k+1}`.

### 2. The Gauss/Hurwitz polygamma series

```lean
theorem tendstoLocallyUniformlyOn_deriv_logDeriv_GammaSeq (k : ℕ) :
    TendstoLocallyUniformlyOn
      (fun n : ℕ => fun s : ℂ => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s)
      (fun s : ℂ => deriv^[k] (logDeriv Gamma) s) atTop {s : ℂ | 0 < s.re}

theorem digamma_polygamma_series (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    HasSum (fun j : ℕ => (s + (j : ℂ)) ^ (-(k : ℤ) - 1))
      (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹ * deriv^[k] (logDeriv Gamma) s)
```

`TendstoLocallyUniformlyOn.deriv` is applied `k` times to the landed
`tendstoLocallyUniformlyOn_logDeriv_GammaSeq`; the differentiability hypothesis
at each step is `differentiableOn_deriv_logDeriv_GammaSeq`, proved by induction
from `analyticAt_GammaSeq`, `GammaSeq_ne_zero_of_re_pos` and
`DifferentiableOn.deriv`.  Evaluating at `s` with item 1 and `k ≥ 1` (so the
constant `log n` is *not* present) gives that the partial sums
`∑_{j≤n} (s+j)^{-k-1}` converge; `hasSum_of_subseq_of_summable` with the
subsequence `n ↦ Finset.range (n+1)` upgrades this to `HasSum`.

### 3. Summability and the norm bound

```lean
theorem summable_polygamma_series (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    Summable (fun j : ℕ => (s + (j : ℂ)) ^ (-(k : ℤ) - 1))

theorem norm_deriv_digamma_le (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    ‖deriv^[k] (logDeriv Gamma) s‖ ≤
      (k.factorial : ℝ) * ∑' j : ℕ, ((s.re + (j : ℝ)) ^ (k + 1))⁻¹
```

The termwise bound `norm_polygamma_term_le` rewrites
`‖(s+j)^{-(k+1)}‖ = ‖s+j‖^{-(k+1)}` (`norm_zpow`) and uses
`Complex.abs_re_le_norm`, `pow_le_pow_left₀`, `inv_le_inv₀`:
`‖s+j‖ ≥ re(s+j) = re s + j > 0`.  The majorant is the shifted `p`-series
`((re s + j)^{k+1})⁻¹` (`summable_nat_add_pow_inv`, from
`Real.summable_nat_pow_inv` plus `summable_nat_add_iff`), so
`Summable.of_nonneg_of_le` gives absolute summability
(`summable_norm_polygamma_series`) and `Summable.of_norm` gives item 3.  The norm
bound is then `‖∑'‖ ≤ ∑' ‖·‖` (`norm_tsum_le_tsum_norm`) followed by
`Summable.tsum_le_tsum`.

### 4. The unconditional archimedean budget (`k ≥ 1`)

```lean
theorem Rh45.digamma_series_bound (k : ℕ) (hk : 1 ≤ k) (t : ℝ) :
    ‖iteratedDeriv k Complex.digamma (digammaLine t)‖ ≤
      (k.factorial : ℝ) * ∑' j : ℕ, ((1 / 4 + (j : ℝ)) ^ (k + 1))⁻¹

theorem Rh45.archimedean_deriv_bound (k : ℕ) (hk : 1 ≤ k) (t : ℝ) :
    ‖iteratedDeriv k Psi t‖ ≤ psiSeriesBound k
```

`digamma_series_bound` is `norm_deriv_digamma_le` at `digammaLine t`, read
through `digammaLine_re` (`(digammaLine t).re = 1/4`),
`Complex.digamma_def` and `iteratedDeriv_eq_iterate`; `archimedean_deriv_bound`
discharges the hypothesis of the compatibility theorem
`Rh45.archimedean_deriv_bound_of_digamma_series` (kept unchanged).  This makes
the round's derivative budget for the archimedean kernel **unconditional for
`k ≥ 1`**.

### 5. The `k = 0` case

```lean
theorem Rh45.not_summable_quarter_add_inv :
    ¬ Summable (fun j : ℕ => ((1 / 4 + (j : ℝ)) ^ (0 + 1))⁻¹)

theorem Rh45.psiSeriesBound_zero : psiSeriesBound 0 = 0

theorem Rh45.norm_digamma_le (t : ℝ) :
    ‖Psi t‖ ≤ Real.eulerMascheroniConstant
      + (3 / 4 + |t| / 2) * (∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹) + 4
```

(a) **`psiSeriesBound 0 = 0`.**  The `k = 0` series is the (shifted) harmonic
series, so it is not summable: `not_summable_quarter_add_inv` compares it with
`Real.summable_one_div_nat_add_rpow (1/4) 1`, whose right-hand side is the false
`1 < 1`.  Hence `tsum` returns the junk value `0`
(`tsum_eq_zero_of_not_summable`) and `psiSeriesBound 0 = 0`; the `k = 0` instance
of `archimedean_deriv_bound_of_digamma_series` is vacuous, exactly as the README
said.

(b) **A valid `k = 0` bound.**  `norm_digamma_le` gives an explicit valid constant.
The route is the Weierstrass partial-sum form

`log n - ∑_{j≤n} (s+j)⁻¹ = T_n - ((harmonic n) - log n) - (s+n)⁻¹`,
`T_n = ∑_{j<n} (1/(j+1) - (s+j)⁻¹)`,

proved as `digamma_partial_identity` from `Complex.ofReal_log`,
`Finset.sum_range_succ` and `harmonic_cast_complex`
(`(harmonic n : ℂ) = ∑_{j<n} 1/(j+1)`).  Passing to the limit `n → ∞`
(`tendsto_digamma_partial`, from the locally uniform convergence of
`logDeriv (GammaSeq · n)`, together with `Real.tendsto_harmonic_sub_log` and the
constants `‖s-1‖ ∑_j ((j+1)(re s+j))⁻¹`, `γ`, `4`) via
`le_of_tendsto_of_tendsto` bounds `‖ψ(s)‖`.  The summand identity
`1/(j+1) - 1/(s+j) = (s-1)/((j+1)(s+j))` (`norm_diff_term_le`) gives the
cancellation that makes the majorant summable (`summable_shift_inv_mul`, by
comparison with the `p`-series with `p = 2`), and `‖(s+n)⁻¹‖ ≤ 4` on
`re s = 1/4` bounds the remainder.  Specialising to `s = digammaLine t` and using
`‖digammaLine t - 1‖ ≤ 3/4 + |t|/2` (`Complex.norm_le_abs_re_add_abs_im`)
finishes the proof.

## Exact route (summary)

```
Complex.GammaSeq_tendsto_Gamma (pointwise, Mathlib)
   └─ Rh45/GammaProduct.lean : locally uniform convergence + derivatives + logDeriv
        └─ logDeriv_GammaSeq_of_ne : explicit finite identity, minimal hypothesis
             └─ iteratedDeriv_logDeriv_GammaSeq : k-fold differentiation
                  + iterated TendstoLocallyUniformlyOn.deriv
                       └─ digamma_polygamma_series : HasSum, k ≥ 1
                            └─ norm_deriv_digamma_le : real-axis norm bound
                                 └─ Rh45.archimedean_deriv_bound : unconditional, k ≥ 1
```

## Not landed / not attempted

* Nothing is left open inside this module.
* The `k = 0` bound `Rh45.norm_digamma_le` is deliberately **crude** (it carries
  the additive constant `4` and the factor `3/4 + |t|/2`); the exact `k = 0`
  statement `ψ(s) = -γ + ∑'_j (1/(j+1) - (s+j)⁻¹)` is *not* exported as a
  `HasSum` theorem, only used through its partial sums.  A sharper `k = 0`
  estimate is not needed for the round (all uses are `k ≥ 1`).
* No formal Weierstrass product for `Γ` is built; the development deliberately
  goes through the pointwise Euler limit `Complex.GammaSeq_tendsto_Gamma` and
  locally uniform convergence instead.
