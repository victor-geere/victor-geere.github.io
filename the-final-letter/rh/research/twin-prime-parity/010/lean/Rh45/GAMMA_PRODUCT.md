# `Rh45/GammaProduct.lean` — locally uniform Euler product limit

## What landed

Module `Rh45/GammaProduct.lean`, namespace **`Rh45RouteBAnalytic`** (the round's
routing namespace; no new namespace was introduced).

Headline signatures (all unconditional, no `sorry`/`axiom`/`admit`/`native_decide`,
no `set_option maxHeartbeats`):

```lean
theorem analyticAt_GammaSeq (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    AnalyticAt ℂ (fun w : ℂ => GammaSeq w n) s

theorem norm_GammaSeq_le (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    ‖GammaSeq s n‖ ≤ Real.Gamma s.re

theorem tendstoLocallyUniformlyOn_GammaSeq :
    TendstoLocallyUniformlyOn (fun n : ℕ => fun s : ℂ => GammaSeq s n) Gamma atTop
      {s : ℂ | 0 < s.re}

theorem tendstoLocallyUniformlyOn_deriv_GammaSeq (k : ℕ) :
    TendstoLocallyUniformlyOn
      (fun n : ℕ => fun s : ℂ => deriv^[k] (fun w => GammaSeq w n) s)
      (fun s : ℂ => deriv^[k] Gamma s) atTop {s : ℂ | 0 < s.re}

theorem tendstoLocallyUniformlyOn_logDeriv_GammaSeq :
    TendstoLocallyUniformlyOn (fun n : ℕ => logDeriv (fun w => GammaSeq w n))
      (logDeriv Gamma) atTop {s : ℂ | 0 < s.re}
```

Auxiliary (also public):

```lean
theorem differentiableAt_GammaSeq (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ (fun w : ℂ => GammaSeq w n) s

theorem tendstoUniformlyOn_GammaSeq_closedBall (c : ℂ) {r ρ : ℝ} (hρ : 0 < ρ)
    (hrρ : r < ρ) (hsub : closedBall c ρ ⊆ {s : ℂ | 0 < s.re}) :
    TendstoUniformlyOn (fun n : ℕ => fun s : ℂ => GammaSeq s n) Gamma atTop (closedBall c r)

theorem logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
```

`#print axioms` on the five headline theorems is
`[propext, Classical.choice, Quot.sound]` in every case.

## Route taken (item 2)

The suggested **circle Cauchy route** was taken, not the uniform-in-`s` dominated
convergence on the integral representation.

For `closedBall c ρ ⊆ {0 < re ·}` and `r < ρ`:

1. `Complex.Gamma` and `GammaSeq · n` are differentiable on `closedBall c ρ`
   (item 1), so `F n := GammaSeq · n - Γ` is `DiffContOnCl` on `ball c ρ`.
2. A uniform bound `‖F n z‖ ≤ C` on `sphere c ρ` is produced by compactness of the
   sphere applied to the continuous function `z ↦ Real.Gamma z.re + ‖Γ z‖`, using
   the integral bound `norm_GammaSeq_le`.
3. Cauchy's formula `DiffContOnCl.two_pi_i_inv_smul_circleIntegral_sub_inv_smul`
   writes `F n s` as a contour integral over `C(c, ρ)` for `s ∈ closedBall c r`.
4. `norm_circleIntegral_inv_smul_le` bounds its norm by
   `(2π)⁻¹ · ρ · (ρ - r)⁻¹ · A n`, where `A n = ∫ θ in 0..2π, ‖F n (circleMap c ρ θ)‖`
   is a *scalar*.
5. `A n → 0` by dominated convergence on the finite-measure interval
   (`MeasureTheory.tendsto_integral_filter_of_norm_le_const`): pointwise convergence
   of the integrand is Mathlib's pointwise `Complex.GammaSeq_tendsto_Gamma`, and the
   dominating constant `C` is uniform in `n` and `θ`.
6. Since the bound in step 4 is uniform over `s ∈ closedBall c r`, this gives
   `TendstoUniformlyOn` on every closed ball contained in the half-plane, and
   `tendstoLocallyUniformlyOn_of_forall_exists_nhds` assembles the locally uniform
   statement.

The key point that makes step 5 work (and that the naive use of the contour bound
would miss) is that the *scalar* `∫ ‖F n‖` over the circle tends to `0` by ordinary
dominated convergence — no uniform convergence on the circle, and hence no
Vitali/Montel theorem, is needed.

Items 3 and 4(a) then follow by plain plumbing:

* Item 3 is the induction `TendstoLocallyUniformlyOn.deriv`, each step discharging
  `DifferentiableOn` of the previous iterate from `analyticAt_GammaSeq` /
  `DifferentiableOn.deriv`.
* Item 4(a) uses a directly proved uniform quotient lemma
  (`tendstoUniformlyOn_div` / `tendstoLocallyUniformlyOn_div`): on a compact set the
  limit denominator is continuous and non-zero, hence bounded below by `c > 0`;
  uniform convergence eventually gives `‖G n s‖ ≥ c/2`; a triangle-inequality split
  of `F n s * g s - f s * G n s` then controls `F n / G n - f / g`. Applied to
  `deriv (GammaSeq · n) → deriv Γ` (item 3) and `GammaSeq · n → Γ` (item 2), with
  `Complex.Gamma_ne_zero_of_re_pos` supplying non-vanishing, this yields the
  logarithmic derivative statement.

## Not landed (exact remaining goal)

The **iterated explicit formula** (item 4 second half) is *not* landed. Its k = 0
case *is* landed as the theorem `logDeriv_GammaSeq` above; what is missing is the
differentiation of that rational function in `k`.

Exact remaining goal:

```lean
theorem deriv_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) (k : ℕ) :
    deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s
      = if k = 0 then Complex.log (n : ℂ)
            - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
        else (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
          ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1)
```

(equivalently with `(Real.log n : ℂ)` in place of `Complex.log (n : ℂ)`, using
`Complex.ofReal_log` and `0 < n`).

Concrete proof ingredients already identified, all present in Mathlib:

* `Complex.iter_deriv_inv_linear (k) (c) (d)` specialises to
  `deriv^[k] (fun w => (w + d)⁻¹) = fun w => (-1)^k · k! · (w + d)^(-1-k)`;
* `Complex.iter_deriv_inv_linear` handles each summand of
  `∑_{j≤n} (w + j)⁻¹`;
* the only missing piece is a finite-sum rule for `deriv^[k]` on the open set
  `{w | ∀ j ≤ n, w + j ≠ 0}` (equivalently, the fact that `deriv^[k]` is a local
  operator so that it commutes with the finite sum there), together with the trivial
  observation that the constant `Complex.log n` is killed by `deriv` for `k ≥ 1`.

With `logDeriv_GammaSeq` in hand this is a bounded computation, but it was not
completed within this session; the `n = 0` case must be excluded (for `n = 0` the
formula is false: `GammaSeq · 0` vanishes on the right half-plane, so its
log-derivative is `0`, while the right-hand side is `-1/s`).

> **Follow-up (landed).**  The gap above is now closed in
> `Rh45/PolygammaSeries.lean` as `Rh45RouteBAnalytic.iteratedDeriv_logDeriv_GammaSeq`
> (with the *weaker* hypothesis `∀ j ≤ n, s + j ≠ 0`, via the local form
> `logDeriv_GammaSeq_of_ne`), together with the Gauss/Hurwitz series
> `digamma_polygamma_series`, its summability and norm bound, and the
> unconditional archimedean budget `Rh45.archimedean_deriv_bound` for `k ≥ 1`.
> See `Rh45/POLYGAMMA.md`.

## Build

`./check.sh --all` is green: 13/13 modules, including `Rh45/GammaProduct.lean`,
`Rh45/PolygammaSeries.lean` and the root `Rh45.lean` which imports them.  No
`sorry`, no `axiom`.
