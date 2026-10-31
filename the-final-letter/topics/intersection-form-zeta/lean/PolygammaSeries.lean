/-
  Rh45/PolygammaSeries.lean — the polygamma series for the logarithmic derivative
  of the Euler product term, and its limit.

  This module completes the second half of the round begun in
  `Rh45/GammaProduct.lean`: that file upgraded the pointwise Euler limit formula
  `Complex.GammaSeq_tendsto_Gamma` to locally uniform convergence on the right
  half-plane and differentiated it with Weierstrass' theorem, obtaining locally
  uniform convergence of `logDeriv (GammaSeq · n)` to `logDeriv Γ`.  Here the
  *explicit* formula

  `logDeriv (GammaSeq · n) s = log n - ∑_{j≤n} (s+j)⁻¹`

  is differentiated `k` times, and the limit `n → ∞` is taken, giving the
  classical Gauss/Hurwitz series for the polygamma functions

  `ψ^{(k)}(s) = (-1)^{k+1} k! ∑_{j≥0} (s+j)^{-k-1}`   (`k ≥ 1`, `0 < re s`).

  What is proved here:

  * `logDeriv_GammaSeq_of_ne` — the explicit formula with the *minimal*
    hypothesis `∀ j ≤ n, s + j ≠ 0` (the landed `logDeriv_GammaSeq` assumes
    `0 < re s`), used to turn the identity into a *local* one;
  * `iteratedDeriv_logDeriv_GammaSeq` — the `k`-th derivative of the finite
    log-derivative: the constant `log n` dies for `k ≥ 1` and each summand
    contributes `(-1)^{k+1} k! (s+j)^{-k-1}` by `iter_deriv_inv_linear`,
    the finite sum being handled by `iteratedDeriv_fun_sum`;
  * `digamma_polygamma_series` — the Gauss/Hurwitz series as a `HasSum`,
    obtained by applying `TendstoLocallyUniformlyOn.deriv` `k` times to
    `tendstoLocallyUniformlyOn_logDeriv_GammaSeq` and evaluating pointwise;
  * `summable_polygamma_series`, `norm_deriv_digamma_le` — summability of the
    series and the termwise norm bound `‖s+j‖ ≥ re(s+j)`;
  * `Rh45.digamma_series_bound`, `Rh45.archimedean_deriv_bound` — the
    unconditional archimedean derivative budget for `k ≥ 1`, discharging the
    hypothesis of `Rh45.archimedean_deriv_bound_of_digamma_series`;
  * `Rh45.psiSeriesBound_zero`, `Rh45.norm_digamma_le` — the `k = 0` case: the
    bound `psiSeriesBound 0` is the junk value `0` because the series
    `∑ (1/4+j)⁻¹` diverges, and a crude but valid replacement bound for the
    digamma function is given from the Weierstrass partial-sum form.

  There is no `sorry`, no `axiom`, no `admit`, no `native_decide` and no
  `set_option maxHeartbeats`.
-/
import Mathlib
import GammaProduct
import Archimedean

open Filter Set
open scoped Topology BigOperators Real

namespace Rh45RouteBAnalytic

noncomputable section

open Complex Metric

/-! ## 1. The explicit log-derivative with the minimal hypothesis -/

/-- **The explicit logarithmic derivative of the Euler product term**, with the
hypothesis only that the finitely many shifts are non-zero.  This is the landed
`logDeriv_GammaSeq` with `0 < re s` weakened to `∀ j ≤ n, s + j ≠ 0`, which is
what the *local* form of the identity needs. -/
theorem logDeriv_GammaSeq_of_ne (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
  have hnC : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  have hcast : ((n.factorial : ℕ) : ℂ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
  have hterm : ∀ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ≠ 0 := fun j hj =>
    hs j (Nat.lt_succ_iff.mp (Finset.mem_range.mp hj))
  have hPne : (∏ j ∈ Finset.range (n + 1), (s + (j : ℂ))) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr hterm
  have hlin : ∀ j ∈ Finset.range (n + 1),
      DifferentiableAt ℂ (fun w : ℂ => w + (j : ℂ)) s := fun j _ => by fun_prop
  have hnum : DifferentiableAt ℂ
      (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) s :=
    (differentiableAt_id.const_cpow (Or.inl hnC)).mul (differentiableAt_const _)
  have hden : DifferentiableAt ℂ
      (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s := by
    rw [show (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) =
        (∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ))) from by
      funext w
      exact (Finset.prod_apply w (Finset.range (n + 1)) (fun j (w : ℂ) => w + (j : ℂ))).symm]
    exact DifferentiableAt.finsetProd hlin
  have hNne : ((n : ℂ) ^ s * ((n.factorial : ℕ) : ℂ)) ≠ 0 :=
    mul_ne_zero (cpow_ne_zero_iff.mpr (Or.inl hnC)) hcast
  have hfun : (fun w : ℂ => GammaSeq w n) =
      (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) /
        (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) := by
    funext w
    simp only [Pi.div_apply, GammaSeq, div_eq_mul_inv, mul_assoc]
  rw [hfun, show logDeriv ((fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) /
        (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ)))) s =
      logDeriv (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) s -
        logDeriv (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s from
      logDeriv_div s hNne hPne hnum hden,
    logDeriv_mul_const s ((n.factorial : ℕ) : ℂ) hcast,
    Complex.logDeriv_const_cpow hnC]
  have hP : logDeriv (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s
      = ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
    rw [show (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) =
        (∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ))) from by
      funext w
      exact (Finset.prod_apply w (Finset.range (n + 1)) (fun j (w : ℂ) => w + (j : ℂ))).symm]
    rw [logDeriv_prod (fun j hj => hterm j hj) (fun j hj => hlin j hj)]
    refine Finset.sum_congr rfl fun j _ => ?_
    have hd : HasDerivAt (fun w : ℂ => w + (j : ℂ)) 1 s := (hasDerivAt_id s).add_const (j : ℂ)
    rw [logDeriv_apply, hd.deriv, one_div]
  rw [hP]

/-- The set where all the finitely many shifts are non-zero is open, so the
explicit formula holds *locally* around `s`. -/
theorem eventuallyEq_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) =ᶠ[𝓝 s]
      fun w : ℂ => Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (w + (j : ℂ))⁻¹ := by
  have hopen : IsOpen {w : ℂ | ∀ j ∈ Finset.range (n + 1), w + (j : ℂ) ≠ 0} := by
    rw [show {w : ℂ | ∀ j ∈ Finset.range (n + 1), w + (j : ℂ) ≠ 0}
        = ⋂ j ∈ Finset.range (n + 1), {w : ℂ | w + (j : ℂ) ≠ 0} by
      ext w; simp]
    exact isOpen_biInter_finset fun j _ =>
      (isOpen_ne (x := (0 : ℂ))).preimage (by fun_prop)
  have hmem : s ∈ {w : ℂ | ∀ j ∈ Finset.range (n + 1), w + (j : ℂ) ≠ 0} :=
    fun j hj => hs j (Nat.lt_succ_iff.mp (Finset.mem_range.mp hj))
  filter_upwards [hopen.mem_nhds hmem] with w hw
  exact logDeriv_GammaSeq_of_ne n hn fun j hj =>
    hw j (Finset.mem_range.mpr (Nat.lt_succ_of_le hj))

/-! ## 2. The iterated derivative of the finite log-derivative -/

/-- The `k`-th derivative of the *closed form* `w ↦ log n - ∑_{j≤n} (w+j)⁻¹`. -/
private theorem iteratedDeriv_closedForm (n : ℕ) (_hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) (k : ℕ) :
    iteratedDeriv k (fun w : ℂ => Complex.log (n : ℂ)
        - ∑ j ∈ Finset.range (n + 1), (w + (j : ℂ))⁻¹) s
      = if k = 0 then Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
        else (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
          ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1) := by
  rcases k with _ | m
  · simp
  · rw [ite_eq_right (Nat.succ_ne_zero m)]
    rw [iteratedDeriv_const_sub
      (f := fun z : ℂ => ∑ j ∈ Finset.range (n + 1), (z + (j : ℂ))⁻¹)
      (Nat.succ_pos m) (Complex.log (n : ℂ))]
    rw [iteratedDeriv_neg
      (f := fun z : ℂ => ∑ j ∈ Finset.range (n + 1), (z + (j : ℂ))⁻¹)]
    have hcd : ∀ j ∈ Finset.range (n + 1),
        ContDiffAt ℂ (m + 1) (fun w : ℂ => (w + (j : ℂ))⁻¹) s := by
      intro j hj
      exact ContDiffAt.inv (by fun_prop)
        (hs j (Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)))
    rw [iteratedDeriv_fun_sum (I := Finset.range (n + 1)) (x := s) (n := m + 1)
      (f := fun (j : ℕ) (w : ℂ) => (w + (j : ℂ))⁻¹) hcd]
    have hterm : ∀ j ∈ Finset.range (n + 1),
        iteratedDeriv (m + 1) (fun w : ℂ => (w + (j : ℂ))⁻¹) s
          = (-1 : ℂ) ^ (m + 1) * ((m + 1).factorial : ℂ) *
              (s + (j : ℂ)) ^ (-(((m + 1 : ℕ)) : ℤ) - 1) := by
      intro j _
      rw [iteratedDeriv_eq_iterate]
      have h := congr_fun (iter_deriv_inv_linear (m + 1) (1 : ℂ) (j : ℂ)) s
      simp only [one_mul, one_pow, mul_one] at h
      rw [h, show (-1 - (((m + 1 : ℕ)) : ℤ)) = -(((m + 1 : ℕ)) : ℤ) - 1 by ring]
    rw [Finset.sum_congr rfl hterm]
    rw [← Finset.mul_sum]
    rw [show m + 2 = (m + 1) + 1 by omega, pow_succ]
    ring

/-- **The iterated derivative of the finite log-derivative.**  For `n ≠ 0` and
`s` avoiding the poles `-j` (`j ≤ n`), the `k`-th derivative of
`logDeriv (GammaSeq · n)` is `log n - ∑_{j≤n} (s+j)⁻¹` for `k = 0` and
`(-1)^{k+1} k! ∑_{j≤n} (s+j)^{-k-1}` otherwise. -/
theorem iteratedDeriv_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) (k : ℕ) :
    deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s
      = if k = 0 then Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
        else (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
          ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1) := by
  rw [← iteratedDeriv_eq_iterate]
  rw [Filter.EventuallyEq.iteratedDeriv_eq k (eventuallyEq_logDeriv_GammaSeq n hn hs)]
  exact iteratedDeriv_closedForm n hn hs k

/-! ## 3. Analyticity, differentiability and the series limit -/

/-- `GammaSeq · n` never vanishes on the right half-plane when `n ≠ 0`. -/
theorem GammaSeq_ne_zero_of_re_pos (n : ℕ) (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) :
    GammaSeq s n ≠ 0 := by
  rw [GammaSeq]
  refine div_ne_zero (mul_ne_zero (cpow_ne_zero_iff.mpr (Or.inl (Nat.cast_ne_zero.mpr hn)))
    (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n))) ?_
  exact Finset.prod_ne_zero_iff.mpr fun j _ => by
    have hpos : 0 < (s + (j : ℂ)).re := by
      have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
      rw [hre]
      have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith only [hs, hj]
    exact fun h => hpos.ne' (by simp [h])

/-- `logDeriv (GammaSeq · n)` is analytic, hence differentiable, on the right
half-plane for `n ≠ 0`. -/
theorem differentiableOn_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) :
    DifferentiableOn ℂ (logDeriv (fun w : ℂ => GammaSeq w n)) {s : ℂ | 0 < s.re} := by
  intro s hs
  have han : AnalyticAt ℂ (fun w : ℂ => GammaSeq w n) s := analyticAt_GammaSeq n hs
  have hquot : AnalyticAt ℂ
      (fun z => deriv (fun w : ℂ => GammaSeq w n) z / GammaSeq z n) s :=
    han.deriv.div han (GammaSeq_ne_zero_of_re_pos n hn hs)
  have hfun : logDeriv (fun w : ℂ => GammaSeq w n) =
      fun z => deriv (fun w : ℂ => GammaSeq w n) z / GammaSeq z n := by
    funext z; rw [logDeriv_apply]
  rw [hfun]
  exact hquot.differentiableAt.differentiableWithinAt

/-- All iterated derivatives of `logDeriv (GammaSeq · n)` are differentiable on
the right half-plane for `n ≠ 0`. -/
theorem differentiableOn_deriv_logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) (k : ℕ) :
    DifferentiableOn ℂ
      (fun s : ℂ => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s)
      {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const continuous_re
  induction k with
  | zero => simpa using differentiableOn_logDeriv_GammaSeq n hn
  | succ k ih => simpa only [Function.iterate_succ_apply'] using ih.deriv hU

/-- **Iterated Weierstrass differentiation for the log-derivative.**  Every
derivative of `logDeriv (GammaSeq · n)` converges locally uniformly to the
corresponding derivative of `logDeriv Γ` on the right half-plane. -/
theorem tendstoLocallyUniformlyOn_deriv_logDeriv_GammaSeq (k : ℕ) :
    TendstoLocallyUniformlyOn
      (fun n : ℕ => fun s : ℂ => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s)
      (fun s : ℂ => deriv^[k] (logDeriv Gamma) s) atTop {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const continuous_re
  induction k with
  | zero => simpa using tendstoLocallyUniformlyOn_logDeriv_GammaSeq
  | succ k ih =>
    have hF : ∀ᶠ n : ℕ in atTop, DifferentiableOn ℂ
        (fun s : ℂ => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s)
        {s : ℂ | 0 < s.re} :=
      Filter.eventually_atTop.mpr ⟨1, fun n hn =>
        differentiableOn_deriv_logDeriv_GammaSeq n (Nat.one_le_iff_ne_zero.mp hn) k⟩
    have h := ih.deriv hF hU
    rwa [show (deriv ∘ fun n s => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s) =
        (fun n s => deriv^[k+1] (logDeriv (fun w : ℂ => GammaSeq w n)) s) from by
          funext n s; simp [Function.iterate_succ_apply'],
      show (deriv fun s => deriv^[k] (logDeriv Gamma) s) =
        (fun s => deriv^[k+1] (logDeriv Gamma) s) from by
          funext s; simp [Function.iterate_succ_apply']] at h

/-- Pointwise form of the previous statement. -/
theorem tendsto_deriv_logDeriv_GammaSeq (k : ℕ) {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s) atTop
      (𝓝 (deriv^[k] (logDeriv Gamma) s)) :=
  (tendstoLocallyUniformlyOn_deriv_logDeriv_GammaSeq k).tendsto_at hs

/-! ## 4. Summability and the norm bound -/

/-- The `p`-series with an additive shift converges for `a > 0` and `k ≥ 1`. -/
theorem summable_nat_add_pow_inv (k : ℕ) (hk : 1 ≤ k) {a : ℝ} (ha : 0 < a) :
    Summable (fun j : ℕ => ((a + (j : ℝ)) ^ (k + 1))⁻¹) := by
  have hp : 1 < k + 1 := by omega
  have hbase : Summable (fun j : ℕ => (((j : ℝ)) ^ (k + 1))⁻¹) :=
    (Real.summable_nat_pow_inv (p := k + 1)).mpr hp
  have hshift : Summable (fun n : ℕ => ((((n + 1 : ℕ)) : ℝ) ^ (k + 1))⁻¹) :=
    (summable_nat_add_iff 1).mpr hbase
  refine (summable_nat_add_iff (f := fun j : ℕ => ((a + (j : ℝ)) ^ (k + 1))⁻¹) 1).mp ?_
  refine Summable.of_nonneg_of_le (fun n => by positivity) (fun n => ?_) hshift
  have hle : (((n + 1 : ℕ)) : ℝ) ≤ a + ((n + 1 : ℕ) : ℝ) := by
    have h0 : (0 : ℝ) ≤ a := ha.le
    linarith only [h0]
  have hpos1 : 0 < (((n + 1 : ℕ)) : ℝ) := by positivity
  have hpos2 : 0 < a + ((n + 1 : ℕ) : ℝ) := by positivity
  have hpow : ((((n + 1 : ℕ)) : ℝ) ^ (k + 1)) ≤ ((a + ((n + 1 : ℕ) : ℝ)) ^ (k + 1)) :=
    pow_le_pow_left₀ hpos1.le hle (k + 1)
  exact (inv_le_inv₀ (pow_pos hpos2 (k + 1)) (pow_pos hpos1 (k + 1))).mpr hpow

/-- **The termwise norm bound.**  Because `‖s+j‖ ≥ re(s+j) = re s + j > 0`,
the modulus of the `j`-th polygamma term is dominated by the real `p`-series
term `((re s + j)^{k+1})⁻¹`. -/
theorem norm_polygamma_term_le (k : ℕ) {s : ℂ} (hs : 0 < s.re) (j : ℕ) :
    ‖(s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ ≤ ((s.re + (j : ℝ)) ^ (k + 1))⁻¹ := by
  have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
  have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
  have hnonneg : 0 ≤ s.re + (j : ℝ) := by linarith only [hs, hj]
  have hpos : 0 < s.re + (j : ℝ) := by linarith only [hs, hj]
  have hle : s.re + (j : ℝ) ≤ ‖s + (j : ℂ)‖ := by
    have habs := Complex.abs_re_le_norm (s + (j : ℂ))
    rwa [hre, abs_of_nonneg hnonneg] at habs
  have hnormpos : 0 < ‖s + (j : ℂ)‖ := lt_of_lt_of_le hpos hle
  have hexp : (-(k : ℤ) - 1) = -(((k + 1 : ℕ)) : ℤ) := by push_cast; ring
  rw [norm_zpow, hexp, zpow_neg, zpow_natCast]
  exact (inv_le_inv₀ (pow_pos hnormpos (k + 1)) (pow_pos hpos (k + 1))).mpr
    (pow_le_pow_left₀ hnonneg hle (k + 1))

/-- **The polygamma series is absolutely summable** for `k ≥ 1` and `0 < re s`. -/
theorem summable_norm_polygamma_series (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    Summable (fun j : ℕ => ‖(s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖) :=
  Summable.of_nonneg_of_le (fun _ => norm_nonneg _) (fun j => norm_polygamma_term_le k hs j)
    (summable_nat_add_pow_inv k hk hs)

/-- **Summability of the polygamma series** for `k ≥ 1` and `0 < re s`. -/
theorem summable_polygamma_series (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    Summable (fun j : ℕ => (s + (j : ℂ)) ^ (-(k : ℤ) - 1)) :=
  Summable.of_norm (summable_norm_polygamma_series k hk hs)

/-- **The Gauss/Hurwitz polygamma series.**  For `k ≥ 1` and `0 < re s`,
`∑_{j≥0} (s+j)^{-k-1} = ((-1)^{k+1} k!)⁻¹ ψ^{(k)}(s)`, stated in `HasSum` form so
that the series is directly usable. -/
theorem digamma_polygamma_series (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    HasSum (fun j : ℕ => (s + (j : ℂ)) ^ (-(k : ℤ) - 1))
      (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹ * deriv^[k] (logDeriv Gamma) s) := by
  have hC : ((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ)) ≠ 0 :=
    mul_ne_zero (pow_ne_zero _ (by norm_num)) (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k))
  have hzero : ∀ j : ℕ, s + (j : ℂ) ≠ 0 := fun j => by
    have hpos : 0 < (s + (j : ℂ)).re := by
      have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
      rw [hre]
      have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith only [hs, hj]
    exact fun h => hpos.ne' (by simp [h])
  have hterm : ∀ n : ℕ, n ≠ 0 →
      deriv^[k] (logDeriv (fun w : ℂ => GammaSeq w n)) s
        = (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
            ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1) := by
    intro n hn
    rw [iteratedDeriv_logDeriv_GammaSeq n hn (fun j _ => hzero j)]
    exact ite_eq_right (by omega : ¬(k = 0))
  have hlim : Tendsto (fun n : ℕ =>
        (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
          ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1)) atTop
      (𝓝 (deriv^[k] (logDeriv Gamma) s)) := by
    refine (tendsto_deriv_logDeriv_GammaSeq k hs).congr' ?_
    filter_upwards [Filter.eventually_atTop.mpr ⟨1, fun n hn => hn⟩] with n hn
    exact hterm n (Nat.one_le_iff_ne_zero.mp hn)
  have hlim2 : Tendsto (fun n : ℕ =>
        ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1)) atTop
      (𝓝 (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹ *
        deriv^[k] (logDeriv Gamma) s)) := by
    have h := hlim.const_mul (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹)
    have heq : (fun n : ℕ => (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹ *
          ((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
            ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1))))
        = fun n : ℕ => ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ^ (-(k : ℤ) - 1) := by
      funext n
      rw [← mul_assoc, inv_mul_cancel₀ hC, one_mul]
    rw [heq] at h
    exact h
  exact hasSum_of_subseq_of_summable (summable_norm_polygamma_series k hk hs)
    (tendsto_finset_range.comp (tendsto_add_atTop_nat 1)) hlim2

/-- **The norm bound on the derivatives of the digamma function.**  For `k ≥ 1`
and `0 < re s`,
`‖ψ^{(k)}(s)‖ ≤ k! ∑_{j≥0} (re s + j)^{-k-1}`. -/
theorem norm_deriv_digamma_le (k : ℕ) (hk : 1 ≤ k) {s : ℂ} (hs : 0 < s.re) :
    ‖deriv^[k] (logDeriv Gamma) s‖ ≤
      (k.factorial : ℝ) * ∑' j : ℕ, ((s.re + (j : ℝ)) ^ (k + 1))⁻¹ := by
  have hC : ((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ)) ≠ 0 :=
    mul_ne_zero (pow_ne_zero _ (by norm_num)) (Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k))
  have hnorm : ‖(-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
      ∑' j : ℕ, (s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ =
      (k.factorial : ℝ) * ‖∑' j : ℕ, (s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ := by
    rw [norm_mul, norm_mul, norm_pow, norm_neg, norm_one, one_pow, one_mul,
      Complex.norm_natCast]
  have htsum : deriv^[k] (logDeriv Gamma) s =
      (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
        ∑' j : ℕ, (s + (j : ℂ)) ^ (-(k : ℤ) - 1) := by
    have h := (digamma_polygamma_series k hk hs).tsum_eq
    rw [h]
    show deriv^[k] (logDeriv Gamma) s =
      (-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ) *
        (((-1 : ℂ) ^ (k + 1) * (k.factorial : ℂ))⁻¹ * deriv^[k] (logDeriv Gamma) s)
    rw [← mul_assoc, mul_inv_cancel₀ hC, one_mul]
  have hle1 : ‖∑' j : ℕ, (s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ ≤
      ∑' j : ℕ, ‖(s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ :=
    norm_tsum_le_tsum_norm (summable_norm_polygamma_series k hk hs)
  have hle2 : ∑' j : ℕ, ‖(s + (j : ℂ)) ^ (-(k : ℤ) - 1)‖ ≤
      ∑' j : ℕ, ((s.re + (j : ℝ)) ^ (k + 1))⁻¹ :=
    (summable_norm_polygamma_series k hk hs).tsum_le_tsum
      (fun j => norm_polygamma_term_le k hs j) (summable_nat_add_pow_inv k hk hs)
  rw [htsum, hnorm]
  exact mul_le_mul_of_nonneg_left (hle1.trans hle2) (Nat.cast_nonneg k.factorial)

end

end Rh45RouteBAnalytic

namespace Rh45

open scoped BigOperators

/-- **The Gauss/Hurwitz budget on the digamma line**, for `k ≥ 1`: the `k`-th
derivative of `ψ` at `1/4 + i t/2` is bounded by `k! ∑_{j≥0} (1/4+j)^{-k-1}`.
This is `Rh45RouteBAnalytic.norm_deriv_digamma_le` read through
`(digammaLine t).re = 1/4` and `Complex.digamma = logDeriv Γ`. -/
theorem digamma_series_bound (k : ℕ) (hk : 1 ≤ k) (t : ℝ) :
    ‖iteratedDeriv k Complex.digamma (digammaLine t)‖ ≤
      (k.factorial : ℝ) * ∑' j : ℕ, ((1 / 4 + (j : ℝ)) ^ (k + 1))⁻¹ := by
  have hs : 0 < (digammaLine t).re := by rw [digammaLine_re]; norm_num
  have h := Rh45RouteBAnalytic.norm_deriv_digamma_le k hk hs
  rw [digammaLine_re] at h
  simpa only [Complex.digamma_def, iteratedDeriv_eq_iterate] using h

/-- **The archimedean derivative bound, unconditional for `k ≥ 1`.**  The
hypothesis of `archimedean_deriv_bound_of_digamma_series` is now a theorem
(`digamma_series_bound`), so the round's `‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k` holds
without hypothesis for every `k ≥ 1`.  The conditional
`archimedean_deriv_bound_of_digamma_series` is kept for compatibility. -/
theorem archimedean_deriv_bound (k : ℕ) (hk : 1 ≤ k) (t : ℝ) :
    ‖iteratedDeriv k Psi t‖ ≤ psiSeriesBound k :=
  archimedean_deriv_bound_of_digamma_series k t (digamma_series_bound k hk t)

/-- The series `∑_{j≥0} (1/4+j)^{-1}` is not summable (it is the harmonic
series up to a shift); hence `psiSeriesBound 0` is the junk value `0`. -/
theorem not_summable_quarter_add_inv :
    ¬ Summable (fun j : ℕ => ((1 / 4 + (j : ℝ)) ^ (0 + 1))⁻¹) := by
  have heq : (fun j : ℕ => ((1 / 4 + (j : ℝ)) ^ (0 + 1))⁻¹)
      = fun n : ℕ => 1 / |(n : ℝ) + 1 / 4| ^ (1 : ℝ) := by
    funext n
    rw [zero_add, pow_one,
      abs_of_nonneg (by positivity : (0 : ℝ) ≤ (n : ℝ) + 1 / 4), Real.rpow_one]
    simp only [one_div]
    congr 1
    ring
  rw [heq]
  exact (Real.summable_one_div_nat_add_rpow (1 / 4) 1).not.mpr (by norm_num)

/-- **The `k = 0` value of `psiSeriesBound`.**  Because the `k = 0` series
diverges, `tsum` returns `0` and `psiSeriesBound 0 = 0`, so the `k = 0` instance
of `archimedean_deriv_bound_of_digamma_series` carries no information. -/
theorem psiSeriesBound_zero : psiSeriesBound 0 = 0 := by
  rw [psiSeriesBound_def, tsum_eq_zero_of_not_summable not_summable_quarter_add_inv]
  norm_num

/-! ## 6. A valid `k = 0` bound

`psiSeriesBound 0 = 0`, so `archimedean_deriv_bound` says nothing for `k = 0`.
The replacement is the Weierstrass partial-sum form

`ψ(s) = -γ + ∑_j (1/(j+1) - 1/(s+j))`   (`0 < re s`),

obtained as the `n → ∞` limit of `logDeriv_GammaSeq` together with
`Real.tendsto_harmonic_sub_log`; bounding the terms gives a crude but valid
`‖ψ(s)‖ ≤ γ + ‖s-1‖ ∑_j ((j+1)(re s + j))⁻¹ + 1/re s`. -/

open Rh45RouteBAnalytic in
/-- The partial sums of the Gauss series converge to `ψ`. -/
private theorem tendsto_digamma_partial {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => Complex.log (n : ℂ)
        - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹) atTop (𝓝 (Complex.digamma s)) := by
  have hzero : ∀ j : ℕ, s + (j : ℂ) ≠ 0 := fun j => by
    have hpos : 0 < (s + (j : ℂ)).re := by
      have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
      rw [hre]
      linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
    exact fun h => hpos.ne' (by simp [h])
  have h := tendstoLocallyUniformlyOn_logDeriv_GammaSeq.tendsto_at hs
  rw [show (𝓝 (Complex.digamma s)) = (𝓝 (logDeriv Complex.Gamma s)) by rw [Complex.digamma_def]]
  refine h.congr' ?_
  filter_upwards [Filter.eventually_atTop.mpr ⟨1, fun n hn => hn⟩] with n hn
  exact logDeriv_GammaSeq_of_ne n (Nat.one_le_iff_ne_zero.mp hn) (fun j _ => hzero j)

/-- The harmonic numbers as a complex finite sum. -/
private theorem harmonic_cast_complex (n : ℕ) :
    (harmonic n : ℂ) = ∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1)) := by
  rw [harmonic]
  push_cast
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [one_div]

/-- The finite-sum rearrangement behind the Weierstrass form of `ψ`. -/
private theorem digamma_partial_identity {s : ℂ} (n : ℕ) :
    Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹
      = (∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹))
        - ((harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ)) - (s + (n : ℂ))⁻¹ := by
  have hlog : Complex.log (n : ℂ) = (Real.log (n : ℝ) : ℂ) := by
    simp
  rw [hlog, Finset.sum_range_succ, Finset.sum_sub_distrib, harmonic_cast_complex]
  ring

/-- Termwise bound for the summands of the Weierstrass form. -/
private theorem norm_diff_term_le {s : ℂ} (hs : 0 < s.re) (j : ℕ) :
    ‖1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹‖ ≤
      ‖s - 1‖ * (((j : ℝ) + 1) * (s.re + (j : ℝ)))⁻¹ := by
  have hj1 : ((j : ℂ) + 1) ≠ 0 := by
    have hcast : (j : ℂ) + 1 = ((j + 1 : ℕ) : ℂ) := by push_cast; ring
    rw [hcast]
    exact Nat.cast_ne_zero.mpr (Nat.succ_ne_zero j)
  have hsj : s + (j : ℂ) ≠ 0 := by
    have hpos : 0 < (s + (j : ℂ)).re := by
      have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
      rw [hre]; linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
    exact fun h => hpos.ne' (by simp [h])
  have hdecomp : 1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹
      = (s - 1) / (((j : ℂ) + 1) * (s + (j : ℂ))) := by
    rw [← one_div]
    rw [div_sub_div (1 : ℂ) (1 : ℂ) hj1 hsj]
    ring
  rw [hdecomp, norm_div, norm_mul]
  have hnj : ‖(j : ℂ) + 1‖ = (j : ℝ) + 1 := by
    have hcast : (j : ℂ) + 1 = ((j + 1 : ℕ) : ℂ) := by push_cast; ring
    rw [hcast, Complex.norm_natCast]
    push_cast; ring
  rw [hnj]
  have hle : s.re + (j : ℝ) ≤ ‖s + (j : ℂ)‖ := by
    have habs := Complex.abs_re_le_norm (s + (j : ℂ))
    have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
    have hnn : 0 ≤ s.re + (j : ℝ) := by linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
    rwa [hre, abs_of_nonneg hnn] at habs
  have hpos1 : 0 < (j : ℝ) + 1 := by positivity
  have hpos2 : 0 < s.re + (j : ℝ) := by linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
  have hnormpos : 0 < ‖s + (j : ℂ)‖ := lt_of_lt_of_le hpos2 hle
  have hprod : ((j : ℝ) + 1) * (s.re + (j : ℝ)) ≤ ((j : ℝ) + 1) * ‖s + (j : ℂ)‖ :=
    mul_le_mul_of_nonneg_left hle hpos1.le
  rw [div_eq_mul_inv]
  exact mul_le_mul_of_nonneg_left
    ((inv_le_inv₀ (mul_pos hpos1 hnormpos) (mul_pos hpos1 hpos2)).mpr hprod) (norm_nonneg _)

/-- Summability of the majorant `∑_j ((j+1)(1/4+j))⁻¹`. -/
private theorem summable_shift_inv_mul :
    Summable (fun j : ℕ => (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹) := by
  have hbase := Rh45RouteBAnalytic.summable_nat_add_pow_inv 1 (le_refl 1)
    (a := (1 / 4 : ℝ)) (by norm_num)
  refine Summable.of_nonneg_of_le (fun j => by positivity) (fun j => ?_) hbase
  have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
  have h1 : 0 < (j : ℝ) + 1 := by positivity
  have h2 : 0 < 1 / 4 + (j : ℝ) := by linarith only [hj]
  have hle : (1 / 4 + (j : ℝ)) ^ 2 ≤ ((j : ℝ) + 1) * (1 / 4 + (j : ℝ)) := by
    rw [pow_two]
    exact mul_le_mul_of_nonneg_right (by linarith only [hj]) h2.le
  exact (inv_le_inv₀ (mul_pos h1 h2) (pow_pos h2 2)).mpr hle

/-- **A valid bound for `ψ` on the line `re s = 1/4`.** -/
private theorem norm_digamma_le_aux {s : ℂ} (hs : s.re = 1 / 4) :
    ‖Complex.digamma s‖ ≤ ‖s - 1‖ *
      (∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹) + Real.eulerMascheroniConstant + 4 := by
  have hs' : 0 < s.re := by rw [hs]; norm_num
  have hlim := tendsto_digamma_partial hs'
  have hnormlim : Tendsto (fun n : ℕ => ‖Complex.log (n : ℂ)
      - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹‖) atTop (𝓝 ‖Complex.digamma s‖) :=
    hlim.norm
  have hγpos : 0 < Real.eulerMascheroniConstant :=
    lt_trans (by norm_num) Real.one_half_lt_eulerMascheroniConstant
  have hSn : Tendsto (fun n : ℕ => ∑ j ∈ Finset.range n,
        (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹) atTop
      (𝓝 (∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹)) :=
    summable_shift_inv_mul.hasSum.tendsto_sum_nat
  have hharm : Tendsto (fun n : ℕ => |(harmonic n : ℝ) - Real.log (n : ℝ)|) atTop
      (𝓝 Real.eulerMascheroniConstant) := by
    have h := Real.tendsto_harmonic_sub_log.abs
    rwa [abs_of_pos hγpos] at h
  have hg : Tendsto (fun n : ℕ => ‖s - 1‖ *
        (∑ j ∈ Finset.range n, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹)
        + |(harmonic n : ℝ) - Real.log (n : ℝ)| + 4) atTop
      (𝓝 (‖s - 1‖ * (∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹)
        + Real.eulerMascheroniConstant + 4)) :=
    ((hSn.const_mul ‖s - 1‖).add hharm).add tendsto_const_nhds
  refine le_of_tendsto_of_tendsto hnormlim hg ?_
  filter_upwards [Filter.eventually_atTop.mpr ⟨1, fun n hn => hn⟩] with n hn
  have hA : ‖∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹)‖ ≤
      ‖s - 1‖ * ∑ j ∈ Finset.range n, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹ := by
    refine (norm_sum_le _ _).trans ?_
    rw [Finset.mul_sum]
    refine Finset.sum_le_sum fun j _ => ?_
    have hterm := norm_diff_term_le hs' j
    rwa [hs] at hterm
  have hB : ‖(harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ)‖ =
      |(harmonic n : ℝ) - Real.log (n : ℝ)| := by
    have hz : (harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ)
        = (((harmonic n : ℝ) - Real.log (n : ℝ) : ℝ) : ℂ) := by
      push_cast; ring
    rw [hz, Complex.norm_real, Real.norm_eq_abs]
  have hC : ‖(s + (n : ℂ))⁻¹‖ ≤ 4 := by
    rw [norm_inv]
    have hle : (1 / 4 : ℝ) ≤ ‖s + (n : ℂ)‖ := by
      have habs := Complex.abs_re_le_norm (s + (n : ℂ))
      have hre : (s + (n : ℂ)).re = 1 / 4 + (n : ℝ) := by
        rw [Complex.add_re, hs]; simp
      have hnn : 0 ≤ (1 / 4 : ℝ) + (n : ℝ) := by positivity
      rw [hre, abs_of_nonneg hnn] at habs
      linarith only [habs]
    have hpos : 0 < ‖s + (n : ℂ)‖ := lt_of_lt_of_le (by norm_num) hle
    have h := (inv_le_inv₀ hpos (by norm_num : (0 : ℝ) < 1 / 4)).mpr hle
    norm_num at h
    exact h
  rw [digamma_partial_identity n]
  calc ‖(∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹))
        - ((harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ)) - (s + (n : ℂ))⁻¹‖
      ≤ ‖(∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹))
          - ((harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ))‖ + ‖(s + (n : ℂ))⁻¹‖ :=
        norm_sub_le _ _
    _ ≤ (‖∑ j ∈ Finset.range n, (1 / ((j : ℂ) + 1) - (s + (j : ℂ))⁻¹)‖
          + ‖(harmonic n : ℂ) - (Real.log (n : ℝ) : ℂ)‖) + ‖(s + (n : ℂ))⁻¹‖ :=
        add_le_add (norm_sub_le _ _) le_rfl
    _ ≤ ‖s - 1‖ * ∑ j ∈ Finset.range n, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹
          + |(harmonic n : ℝ) - Real.log (n : ℝ)| + 4 :=
        add_le_add (add_le_add hA (le_of_eq hB)) hC

/-- **A valid crude bound for `k = 0`.**  The `k = 0` instance of
`psiSeriesBound` is the junk value `0`, because `∑_j (1/4+j)⁻¹` diverges.  This is
the replacement: the Weierstrass partial-sum form of `ψ` together with the
harmonic limit bounds `‖Ψ(t)‖` by an explicit constant depending on `t`. -/
theorem norm_digamma_le (t : ℝ) :
    ‖Psi t‖ ≤ Real.eulerMascheroniConstant
      + (3 / 4 + |t| / 2) * (∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹) + 4 := by
  have h := norm_digamma_le_aux (s := digammaLine t) (digammaLine_re t)
  have hnorm : ‖digammaLine t - 1‖ ≤ 3 / 4 + |t| / 2 := by
    have habs := Complex.norm_le_abs_re_add_abs_im (digammaLine t - 1)
    have hre : |(digammaLine t - 1).re| = 3 / 4 := by
      rw [Complex.sub_re, digammaLine_re]; norm_num
    have him : |(digammaLine t - 1).im| = |t| / 2 := by
      have h : (digammaLine t - 1).im = t / 2 := by
        rw [Complex.sub_im, digammaLine_im]; simp
      rw [h, abs_div]; norm_num
    rw [hre, him] at habs
    linarith only [habs]
  have hS : 0 ≤ ∑' j : ℕ, (((j : ℝ) + 1) * (1 / 4 + (j : ℝ)))⁻¹ :=
    tsum_nonneg fun j => by positivity
  have hmul := mul_le_mul_of_nonneg_right hnorm hS
  have hpsi : ‖Psi t‖ = ‖Complex.digamma (digammaLine t)‖ := rfl
  rw [hpsi]
  linarith only [h, hmul]

end Rh45
