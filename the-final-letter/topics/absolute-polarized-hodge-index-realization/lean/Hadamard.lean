import Mathlib

/-!
# Weierstrass elementary factors and finite canonical products

This is milestone 1 of the Hadamard/Weierstrass project needed for the
zero-side explicit formula.  It defines the elementary factor

`E_p(z) = (1 - z) * exp (∑_{k=1}^{p} z^k / k)`

and the finite canonical product over a finite set of zeros, and proves that
the finite product has exactly the prescribed zeros (when `0` is not among
them).  The infinite product, its convergence, and the Hadamard factorisation
of entire functions are later milestones.
-/

open Complex
open scoped BigOperators

namespace AbsoluteHodgeHadamard

/-- The Weierstrass elementary factor `E_p(z) = (1 - z) exp(∑_{k=1}^p z^k/k)`. -/
noncomputable def weierstrassFactor (p : ℕ) (z : ℂ) : ℂ :=
  (1 - z) * cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))

@[simp]
theorem weierstrassFactor_zero (p : ℕ) : weierstrassFactor p 0 = 1 := by
  simp [weierstrassFactor]

theorem weierstrassFactor_one (p : ℕ) : weierstrassFactor p 1 = 0 := by
  simp [weierstrassFactor]

/-- The elementary factor vanishes exactly at `z = 1`. -/
theorem weierstrassFactor_eq_zero_iff (p : ℕ) (z : ℂ) :
    weierstrassFactor p z = 0 ↔ z = 1 := by
  unfold weierstrassFactor
  rw [mul_eq_zero]
  constructor
  · rintro (h | h)
    · linear_combination -h
    · exact absurd h (Complex.exp_ne_zero _)
  · intro h
    subst h
    simp

@[fun_prop]
theorem differentiable_weierstrassFactor (p : ℕ) :
    Differentiable ℂ (weierstrassFactor p) := by
  unfold weierstrassFactor
  fun_prop

/-- The finite canonical product over a finite set of zeros. -/
noncomputable def finiteCanonicalProduct (p : ℕ) (S : Finset ℂ) (z : ℂ) : ℂ :=
  ∏ w ∈ S, weierstrassFactor p (z / w)

/-- The finite canonical product has exactly the prescribed nonzero zeros. -/
theorem finiteCanonicalProduct_eq_zero_iff (p : ℕ) (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) (z : ℂ) :
    finiteCanonicalProduct p S z = 0 ↔ z ∈ S := by
  unfold finiteCanonicalProduct
  rw [Finset.prod_eq_zero_iff]
  constructor
  · rintro ⟨w, hw, hzw⟩
    rw [weierstrassFactor_eq_zero_iff] at hzw
    have hw0 : w ≠ 0 := by
      intro h
      exact h0 (h ▸ hw)
    have hz : z = w := by
      rw [div_eq_iff hw0] at hzw
      simpa using hzw
    rw [hz]
    exact hw
  · intro hz
    refine ⟨z, hz, ?_⟩
    have hz0 : z ≠ 0 := by
      intro h
      exact h0 (h ▸ hz)
    rw [div_self hz0, weierstrassFactor_one]

theorem finiteCanonicalProduct_zero (p : ℕ) (S : Finset ℂ) :
    finiteCanonicalProduct p S 0 = 1 := by
  unfold finiteCanonicalProduct
  simp

theorem differentiable_finiteCanonicalProduct (p : ℕ) (S : Finset ℂ) :
    Differentiable ℂ (finiteCanonicalProduct p S) := by
  unfold finiteCanonicalProduct
  fun_prop


set_option maxHeartbeats 1000000 in
/-- The derivative of the elementary factor. -/
theorem hasDerivAt_weierstrassFactor (p : ℕ) (z : ℂ) :
    HasDerivAt (weierstrassFactor p)
      ((-1) * cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))
        + (1 - z) * (cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))
          * (∑ k ∈ Finset.range p, z ^ k))) z := by
  unfold weierstrassFactor
  have hS : HasDerivAt (fun z : ℂ => ∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))
      (∑ k ∈ Finset.range p, z ^ k) z := by
    apply HasDerivAt.fun_sum
    intro k _
    have hk : HasDerivAt (fun z : ℂ => z ^ (k + 1) / ((k : ℂ) + 1))
        (((k : ℂ) + 1) * z ^ k / ((k : ℂ) + 1)) z := by
      simpa [Nat.cast_add_one, Nat.add_sub_cancel] using
        (hasDerivAt_pow (k + 1) z).div_const ((k : ℂ) + 1)
    have hk1 : ((k : ℂ) + 1) ≠ 0 := by
      have h : (((k + 1 : ℕ) : ℂ)) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero k
      simpa [Nat.cast_add_one] using h
    have hdiv : (((k : ℂ) + 1) * z ^ k / ((k : ℂ) + 1)) = z ^ k := by
      field_simp [hk1]
    rw [hdiv] at hk
    exact hk
  have hlin : HasDerivAt (fun z : ℂ => 1 - z) (-1) z := by
    simpa using (hasDerivAt_id z).const_sub (1 : ℂ)
  have h := hlin.mul hS.cexp
  exact h

/-- The derivative of the elementary factor, as a `deriv`. -/
theorem deriv_weierstrassFactor (p : ℕ) (z : ℂ) :
    deriv (weierstrassFactor p) z
      = (-1) * cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))
        + (1 - z) * (cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))
          * (∑ k ∈ Finset.range p, z ^ k)) :=
  (hasDerivAt_weierstrassFactor p z).deriv

/-- The log-derivative of the elementary factor. -/
theorem logDeriv_weierstrassFactor (p : ℕ) (z : ℂ) (hz : z ≠ 1) :
    logDeriv (weierstrassFactor p) z
      = -1 / (1 - z) + ∑ k ∈ Finset.range p, z ^ k := by
  rw [logDeriv_apply, deriv_weierstrassFactor]
  have h1z : (1 - z) ≠ 0 := by
    intro h
    apply hz
    linear_combination -h
  unfold weierstrassFactor
  field_simp [h1z, Complex.exp_ne_zero]


/-- Telescoping: `(1 - z) * ∑_{k<p} z^k = 1 - z^p`. -/
theorem one_sub_mul_sum_range_pow (p : ℕ) (z : ℂ) :
    (1 - z) * (∑ k ∈ Finset.range p, z ^ k) = 1 - z ^ p := by
  induction p with
  | zero => simp
  | succ p ih =>
    rw [Finset.sum_range_succ, mul_add, ih, pow_succ]
    ring

/-- The compact derivative form `E_p'(z) = -z^p exp(S_p(z))`. -/
theorem deriv_weierstrassFactor' (p : ℕ) (z : ℂ) :
    deriv (weierstrassFactor p) z
      = -z ^ p * cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1)) := by
  rw [deriv_weierstrassFactor]
  set e := cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1)) with he
  set S := ∑ k ∈ Finset.range p, z ^ k with hS
  have htel : (1 - z) * S = 1 - z ^ p := one_sub_mul_sum_range_pow p z
  calc (-1) * e + (1 - z) * (e * S)
      = e * (-1 + (1 - z) * S) := by ring
    _ = e * (-1 + (1 - z ^ p)) := by rw [htel]
    _ = -z ^ p * e := by ring


/-- For `‖w‖ ≤ 1/2`, the exponent sum `S_p(w)` has norm at most `1`. -/
theorem norm_weierstrassSum_le_one (p : ℕ) (w : ℂ) (hw : ‖w‖ ≤ 1 / 2) :
    ‖∑ k ∈ Finset.range p, w ^ (k + 1) / ((k : ℂ) + 1)‖ ≤ 1 := by
  set r := ‖w‖ with hr
  have hr0 : 0 ≤ r := norm_nonneg w
  have hr1 : r < 1 := by linarith
  have hstep : ‖∑ k ∈ Finset.range p, w ^ (k + 1) / ((k : ℂ) + 1)‖
      ≤ ∑ k ∈ Finset.range p, r ^ (k + 1) := by
    calc ‖∑ k ∈ Finset.range p, w ^ (k + 1) / ((k : ℂ) + 1)‖
        ≤ ∑ k ∈ Finset.range p, ‖w ^ (k + 1) / ((k : ℂ) + 1)‖ :=
          norm_sum_le _ _
      _ ≤ ∑ k ∈ Finset.range p, r ^ (k + 1) := by
          apply Finset.sum_le_sum
          intro k _
          rw [norm_div, norm_pow]
          have hden : ‖((k : ℂ) + 1)‖ = (k + 1 : ℝ) := by
            simpa using Complex.norm_natCast (k + 1)
          rw [hden]
          apply div_le_self (pow_nonneg hr0 _)
          exact_mod_cast Nat.succ_le_succ (Nat.zero_le k)
  have hgeom : ∑ k ∈ Finset.range p, r ^ (k + 1) ≤ 1 := by
    have htsum : ∑' k : ℕ, r ^ k = (1 - r)⁻¹ := tsum_geometric_of_lt_one hr0 hr1
    have hsum_le : ∑ k ∈ Finset.range p, r ^ k ≤ (1 - r)⁻¹ := by
      rw [← htsum]
      exact Summable.sum_le_tsum _ (fun i _ => pow_nonneg hr0 i)
        (summable_geometric_of_lt_one hr0 hr1)
    have hfac : ∑ k ∈ Finset.range p, r ^ (k + 1)
        = r * ∑ k ∈ Finset.range p, r ^ k := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k _
      rw [pow_succ]
      ring
    rw [hfac]
    have hdenpos : 0 < 1 - r := by linarith
    have hdiv : r * (1 - r)⁻¹ ≤ 1 := by
      rw [← div_eq_mul_inv, div_le_iff₀ hdenpos]
      linarith
    exact le_trans (mul_le_mul_of_nonneg_left hsum_le hr0) hdiv
  exact le_trans hstep hgeom


/-- On the path `t ↦ t z` with `t ∈ [0,1]`, the exponential factor is at most `e`. -/
theorem norm_cexp_weierstrassSum_le_exp_one (p : ℕ) {t : ℝ} (ht0 : 0 ≤ t)
    (ht1 : t ≤ 1) (z : ℂ) (hz : ‖z‖ ≤ 1 / 2) :
    ‖cexp (∑ k ∈ Finset.range p, ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1))‖
      ≤ Real.exp 1 := by
  rw [Complex.norm_exp]
  apply Real.exp_le_exp.mpr
  calc (∑ k ∈ Finset.range p, ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1)).re
      ≤ ‖∑ k ∈ Finset.range p, ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1)‖ :=
        Complex.re_le_norm _
    _ ≤ 1 := by
        apply norm_weierstrassSum_le_one
        rw [norm_mul]
        have ht : ‖(t : ℂ)‖ = t := by
          simp [abs_of_nonneg ht0]
        rw [ht]
        nlinarith [norm_nonneg z]

/-- The derivative of the path `t ↦ E_p(t z)` along the real line. -/
theorem hasDerivAt_weierstrassPath (p : ℕ) (z : ℂ) (t : ℝ) :
    HasDerivAt (fun s : ℝ => weierstrassFactor p ((s : ℂ) * z))
      (z * deriv (weierstrassFactor p) ((t : ℂ) * z)) t := by
  have hpath : HasDerivAt (fun s : ℝ => (s : ℂ) * z) ((1 : ℂ) * z) t :=
    Complex.ofRealCLM.hasDerivAt.mul_const z
  have h := (hasDerivAt_weierstrassFactor p ((t : ℂ) * z)).scomp t hpath
  convert h using 1
  · ext s
    rfl
  · rw [deriv_weierstrassFactor]
    ring


/-- **Convergence bound for the elementary factor.**  For `‖z‖ ≤ 1/2`,
`‖E_p(z) - 1‖ ≤ e * ‖z‖^(p+1)`. -/
theorem norm_weierstrassFactor_sub_one_le (p : ℕ) (z : ℂ) (hz : ‖z‖ ≤ 1 / 2) :
    ‖weierstrassFactor p z - 1‖ ≤ Real.exp 1 * ‖z‖ ^ (p + 1) := by
  let f' : ℝ → ℂ := fun t =>
    z * (-(((t : ℂ) * z) ^ p)
      * cexp (∑ k ∈ Finset.range p, ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1)))
  have hderiv : ∀ t ∈ Set.uIcc (0 : ℝ) 1,
      HasDerivAt (fun s : ℝ => weierstrassFactor p ((s : ℂ) * z)) (f' t) t := by
    intro t _
    have h := hasDerivAt_weierstrassPath p z t
    rw [deriv_weierstrassFactor'] at h
    simpa [f'] using h
  have hint : IntervalIntegrable f' MeasureTheory.volume 0 1 := by
    apply Continuous.intervalIntegrable
    unfold f'
    fun_prop
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  have hval : (∫ t in (0 : ℝ)..1, f' t) = weierstrassFactor p z - 1 := by
    rw [hFTC]
    simp
  have hbound : ∀ t ∈ Set.uIoc (0 : ℝ) 1, ‖f' t‖ ≤ Real.exp 1 * ‖z‖ ^ (p + 1) := by
    intro t ht
    have ht' : t ∈ Set.Ioc (0 : ℝ) 1 := by
      simpa [Set.uIoc_of_le (by norm_num : (0 : ℝ) ≤ 1)] using ht
    have ht0 : 0 ≤ t := le_of_lt ht'.1
    have ht1 : t ≤ 1 := ht'.2
    have htz : ‖((t : ℂ) * z)‖ = t * ‖z‖ := by
      rw [norm_mul]
      have : ‖(t : ℂ)‖ = t := by simp [abs_of_nonneg ht0]
      rw [this]
    have hS : ‖cexp (∑ k ∈ Finset.range p,
        ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1))‖ ≤ Real.exp 1 :=
      norm_cexp_weierstrassSum_le_exp_one p ht0 ht1 z hz
    have hnorm : ‖f' t‖ = ‖z‖ * (‖((t : ℂ) * z)‖ ^ p
        * ‖cexp (∑ k ∈ Finset.range p,
            ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1))‖) := by
      simp [f', norm_pow]
    rw [hnorm, htz]
    calc ‖z‖ * ((t * ‖z‖) ^ p * ‖cexp (∑ k ∈ Finset.range p,
            ((t : ℂ) * z) ^ (k + 1) / ((k : ℂ) + 1))‖)
        ≤ ‖z‖ * ((t * ‖z‖) ^ p * Real.exp 1) := by
          gcongr
      _ ≤ ‖z‖ * (‖z‖ ^ p * Real.exp 1) := by
          gcongr
          nlinarith [norm_nonneg z]
      _ = Real.exp 1 * ‖z‖ ^ (p + 1) := by
          rw [pow_succ]
          ring
  calc ‖weierstrassFactor p z - 1‖ = ‖∫ t in (0 : ℝ)..1, f' t‖ := by rw [hval]
    _ ≤ Real.exp 1 * ‖z‖ ^ (p + 1) := by
        simpa using (intervalIntegral.norm_integral_le_of_norm_le_const
          (a := (0 : ℝ)) (b := 1) (C := Real.exp 1 * ‖z‖ ^ (p + 1)) hbound)


/-- The factor bound in terms of the zero `a`: for `‖z/a‖ ≤ 1/2`,
`‖E_p(z/a) - 1‖ ≤ e * ‖z‖^(p+1) / ‖a‖^(p+1)`. -/
theorem norm_weierstrassFactor_div_sub_one_le (p : ℕ) (z a : ℂ) (_ha : a ≠ 0)
    (h : ‖z / a‖ ≤ 1 / 2) :
    ‖weierstrassFactor p (z / a) - 1‖
      ≤ Real.exp 1 * ‖z‖ ^ (p + 1) / ‖a‖ ^ (p + 1) := by
  have hb := norm_weierstrassFactor_sub_one_le p (z / a) h
  rw [norm_div, div_pow] at hb
  calc ‖weierstrassFactor p (z / a) - 1‖
      ≤ Real.exp 1 * (‖z‖ ^ (p + 1) / ‖a‖ ^ (p + 1)) := hb
    _ = Real.exp 1 * ‖z‖ ^ (p + 1) / ‖a‖ ^ (p + 1) := by ring


/-- Summability of the factor perturbations: if the zeros grow at least like
`2‖z‖` and `∑ ‖z‖^(p+1)/‖a n‖^(p+1)` converges, then
`∑ (E_p(z/a n) - 1)` converges. -/
theorem summable_weierstrassFactor_sub_one {ι : Type*} {a : ι → ℂ} {p : ℕ} {z : ℂ}
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    Summable (fun n => weierstrassFactor p (z / a n) - 1) := by
  have hzpos : 0 < ‖z‖ := norm_pos_iff.mpr hz
  have hbound : ∀ n, ‖weierstrassFactor p (z / a n) - 1‖
      ≤ Real.exp 1 * (‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    intro n
    have ha0 : a n ≠ 0 := by
      intro h0
      have hn := ha n
      rw [h0] at hn
      simp at hn
      linarith
    have hanorm : 0 < ‖a n‖ := norm_pos_iff.mpr ha0
    have hratio : ‖z / a n‖ ≤ 1 / 2 := by
      rw [norm_div, div_le_iff₀ hanorm]
      nlinarith [ha n]
    have := norm_weierstrassFactor_div_sub_one_le p z (a n) ha0 hratio
    simpa [mul_div_assoc] using this
  exact Summable.of_norm_bounded (h.mul_left (Real.exp 1)) hbound


/-- Norm-summability of the factor perturbations. -/
theorem summable_norm_weierstrassFactor_sub_one {ι : Type*} {a : ι → ℂ} {p : ℕ} {z : ℂ}
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    Summable (fun n => ‖weierstrassFactor p (z / a n) - 1‖) := by
  have hzpos : 0 < ‖z‖ := norm_pos_iff.mpr hz
  apply Summable.of_nonneg_of_le (fun n => norm_nonneg _) ?_
    (h.mul_left (Real.exp 1))
  intro n
  have ha0 : a n ≠ 0 := by
    intro h0
    have hn := ha n
    rw [h0] at hn
    simp at hn
    linarith
  have hanorm : 0 < ‖a n‖ := norm_pos_iff.mpr ha0
  have hratio : ‖z / a n‖ ≤ 1 / 2 := by
    rw [norm_div, div_le_iff₀ hanorm]
    nlinarith [ha n]
  have := norm_weierstrassFactor_div_sub_one_le p z (a n) ha0 hratio
  simpa [mul_div_assoc] using this

/-- **Convergence of the infinite canonical product.**  Under the zero growth
and the summability of `‖z‖^(p+1)/‖a n‖^(p+1)`, the product
`∏ₙ E_p(z/aₙ)` is multipliable. -/
theorem multipliable_weierstrassFactor {ι : Type*} {a : ι → ℂ} {p : ℕ} {z : ℂ}
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    Multipliable (fun n => weierstrassFactor p (z / a n)) := by
  have hnorm := summable_norm_weierstrassFactor_sub_one hz ha h
  have h' := multipliable_one_add_of_summable
    (f := fun n => weierstrassFactor p (z / a n) - 1) hnorm
  simpa [add_sub_cancel] using h'

/-- The `HasProd` form of the canonical-product convergence. -/
theorem hasProd_weierstrassFactor {a : ℕ → ℂ} {p : ℕ} {z : ℂ}
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    HasProd (fun n => weierstrassFactor p (z / a n))
      (∏' n, weierstrassFactor p (z / a n)) :=
  (multipliable_weierstrassFactor hz ha h).hasProd


/-- The log-derivative of the finite canonical product. -/
theorem logDeriv_finiteCanonicalProduct (p : ℕ) (S : Finset ℂ) (z : ℂ)
    (h0 : (0 : ℂ) ∉ S) (hz : ∀ w ∈ S, z ≠ w) :
    logDeriv (finiteCanonicalProduct p S) z
      = ∑ w ∈ S, (1 / w) * logDeriv (weierstrassFactor p) (z / w) := by
  unfold finiteCanonicalProduct
  have hfun : (fun z : ℂ => ∏ w ∈ S, weierstrassFactor p (z / w))
      = ∏ w ∈ S, fun z : ℂ => weierstrassFactor p (z / w) := by
    funext z
    simp
  rw [hfun, logDeriv_prod]
  · apply Finset.sum_congr rfl
    intro w hw
    have hw0 : w ≠ 0 := fun h => h0 (h ▸ hw)
    have hzw : z / w ≠ 1 := by
      intro h
      apply hz w hw
      rw [div_eq_one_iff_eq hw0] at h
      exact h
    rw [show (fun z : ℂ => weierstrassFactor p (z / w))
        = weierstrassFactor p ∘ fun z : ℂ => z / w from rfl]
    rw [logDeriv_comp]
    · rw [deriv_div_const]
      simp
      ring
    · exact (differentiable_weierstrassFactor p).differentiableAt
    · fun_prop
  · intro w hw
    have hw0 : w ≠ 0 := fun h => h0 (h ▸ hw)
    have hzw : z / w ≠ 1 := by
      intro h
      apply hz w hw
      rw [div_eq_one_iff_eq hw0] at h
      exact h
    intro h
    apply hzw
    exact (weierstrassFactor_eq_zero_iff p (z / w)).mp h
  · intro w hw
    exact (differentiable_weierstrassFactor p).differentiableAt.comp z (by fun_prop)


/-- The canonical product takes the value `1` at `z = 0`. -/
theorem hasProd_weierstrassFactor_zero (p : ℕ) (a : ℕ → ℂ) :
    HasProd (fun n => weierstrassFactor p (0 / a n)) 1 := by
  simp [weierstrassFactor_zero]

/-- The canonical product vanishes at each prescribed zero `a k`. -/
theorem hasProd_weierstrassFactor_at_zero (p : ℕ) (a : ℕ → ℂ)
    (ha0 : ∀ n, a n ≠ 0) (k : ℕ) :
    HasProd (fun n => weierstrassFactor p (a k / a n)) 0 := by
  apply hasProd_zero_of_exists_eq_zero
  exact ⟨k, by rw [div_self (ha0 k), weierstrassFactor_one]⟩

/-- Off the prescribed zeros, the infinite canonical product is nonzero. -/
theorem tprod_weierstrassFactor_ne_zero {ι : Type*} {a : ι → ℂ} {p : ℕ} {z : ℂ}
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hzne : ∀ n, z ≠ a n) :
    (∏' n, weierstrassFactor p (z / a n)) ≠ 0 := by
  have hzpos : 0 < ‖z‖ := norm_pos_iff.mpr hz
  have hfac : ∀ n, weierstrassFactor p (z / a n) ≠ 0 := by
    intro n h
    rw [weierstrassFactor_eq_zero_iff] at h
    have ha0 : a n ≠ 0 := by
      intro h0
      have hn := ha n
      rw [h0] at hn
      simp at hn
      linarith
    apply hzne n
    rw [div_eq_iff ha0] at h
    simpa using h
  have hu : Summable (fun n => weierstrassFactor p (z / a n) - 1) :=
    summable_weierstrassFactor_sub_one hz ha h
  have hlog : Summable (fun n => Complex.log (weierstrassFactor p (z / a n))) := by
    have := Complex.summable_log_one_add_of_summable
      (f := fun n => weierstrassFactor p (z / a n) - 1) hu
    simpa [add_sub_cancel] using this
  have hprod := Complex.hasProd_of_hasSum_log hfac hlog.hasSum
  have hval : (∏' n, weierstrassFactor p (z / a n))
      = Complex.exp (∑' n, Complex.log (weierstrassFactor p (z / a n))) :=
    hprod.tprod_eq
  rw [hval]
  exact Complex.exp_ne_zero _


/-- **Uniform convergence of the canonical product on a compact set.** -/
theorem hasProdUniformlyOn_weierstrassFactor {ι : Type*} {a : ι → ℂ} {p : ℕ} {K : Set ℂ}
    (hK : IsCompact K) {R : ℝ} (_hR0 : 0 ≤ R) (hR : ∀ z ∈ K, ‖z‖ ≤ R)
    (ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    HasProdUniformlyOn (fun n z => weierstrassFactor p (z / a n))
      (fun z => ∏' n, weierstrassFactor p (z / a n)) K := by
  have hcts : ∀ n, ContinuousOn (fun z : ℂ => weierstrassFactor p (z / a n) - 1) K := by
    intro n
    exact ((differentiable_weierstrassFactor p).continuous.comp
      (continuous_id.div_const (a n))).continuousOn.sub continuousOn_const
  have hbound : ∀ n, ∀ z ∈ K,
      ‖weierstrassFactor p (z / a n) - 1‖
        ≤ Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1) := by
    intro n z hz
    have hanorm : 0 < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
    have hRz : ‖z‖ ≤ R := hR z hz
    have hratio : ‖z / a n‖ ≤ 1 / 2 := by
      rw [norm_div, div_le_iff₀ hanorm]
      nlinarith [ha n]
    have hmain := norm_weierstrassFactor_div_sub_one_le p z (a n) (ha0 n) hratio
    have hzpow : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
      pow_le_pow_left₀ (norm_nonneg z) hRz (p + 1)
    have hden : 0 ≤ ‖a n‖ ^ (p + 1) := pow_nonneg (norm_nonneg _) _
    calc ‖weierstrassFactor p (z / a n) - 1‖
        ≤ Real.exp 1 * ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1) := hmain
      _ ≤ Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1) := by
          gcongr
  have hmain := Summable.hasProdUniformlyOn_one_add
    (f := fun n z => weierstrassFactor p (z / a n) - 1) hK h
    (Filter.Eventually.of_forall hbound) hcts
  simpa [add_sub_cancel] using hmain


/-- If the canonical product is a locally uniform limit of its partial products,
it is analytic.  (The locally uniform convergence itself is the remaining
bridge; this records the analyticity step.) -/
theorem analyticOnNhd_tprod_weierstrassFactor {ι : Type*} {a : ι → ℂ} {p : ℕ} {U : Set ℂ}
    (hU : IsOpen U)
    (h : TendstoLocallyUniformlyOn
      (fun s : Finset ι => fun z => ∏ n ∈ s, weierstrassFactor p (z / a n))
      (fun z => ∏' n, weierstrassFactor p (z / a n)) Filter.atTop U) :
    AnalyticOnNhd ℂ (fun z => ∏' n, weierstrassFactor p (z / a n)) U := by
  apply DifferentiableOn.analyticOnNhd _ hU
  apply h.differentiableOn
  · exact Filter.Eventually.of_forall (fun s => by
      apply Differentiable.differentiableOn
      fun_prop)
  · exact hU


/-- Uniform convergence on a closed ball. -/
theorem tendstoUniformlyOn_weierstrassFactor_closedBall {ι : Type*} {a : ι → ℂ} {p : ℕ} {R : ℝ}
    (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    TendstoUniformlyOn (fun s : Finset ι => fun z => ∏ n ∈ s, weierstrassFactor p (z / a n))
      (fun z => ∏' n, weierstrassFactor p (z / a n)) Filter.atTop
      (Metric.closedBall (0 : ℂ) R) := by
  have hK : IsCompact (Metric.closedBall (0 : ℂ) R) := isCompact_closedBall 0 R
  have hRle : ∀ z ∈ Metric.closedBall (0 : ℂ) R, ‖z‖ ≤ R := by
    intro z hz
    have := Metric.mem_closedBall.mp hz
    simpa [dist_eq_norm] using this
  have := hasProdUniformlyOn_weierstrassFactor hK (le_of_lt hR) hRle ha0 ha h
  exact hasProdUniformlyOn_iff_tendstoUniformlyOn.mp this

/-- Local uniform convergence on the open ball. -/
theorem tendstoLocallyUniformlyOn_weierstrassFactor_ball {ι : Type*} {a : ι → ℂ} {p : ℕ} {R : ℝ}
    (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    TendstoLocallyUniformlyOn
      (fun s : Finset ι => fun z => ∏ n ∈ s, weierstrassFactor p (z / a n))
      (fun z => ∏' n, weierstrassFactor p (z / a n)) Filter.atTop
      (Metric.ball (0 : ℂ) R) :=
  (tendstoUniformlyOn_weierstrassFactor_closedBall hR ha0 ha h).tendstoLocallyUniformlyOn.mono
    Metric.ball_subset_closedBall

/-- **The infinite canonical product is analytic** on the ball of radius `R`
where the zeros satisfy `2R ≤ ‖a n‖`. -/
theorem analyticOnNhd_tprod_weierstrassFactor_ball {ι : Type*} {a : ι → ℂ} {p : ℕ} {R : ℝ}
    (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    AnalyticOnNhd ℂ (fun z => ∏' n, weierstrassFactor p (z / a n))
      (Metric.ball (0 : ℂ) R) :=
  analyticOnNhd_tprod_weierstrassFactor Metric.isOpen_ball
    (tendstoLocallyUniformlyOn_weierstrassFactor_ball hR ha0 ha h)


/-- **Jensen's formula for the finite canonical product.**  With the divisor on
the closed ball, the circle average of `log ‖P_S‖` equals the divisor sum plus
`log ‖P_S 0‖`. -/
theorem Jensen_finiteCanonicalProduct (p : ℕ) (S : Finset ℂ) (_h0 : (0 : ℂ) ∉ S)
    {R : ℝ} (hR : R ≠ 0) :
    Real.circleAverage (fun z => Real.log ‖finiteCanonicalProduct p S z‖) 0 R
      = ∑ᶠ u : ℂ,
          (MeromorphicOn.divisor (finiteCanonicalProduct p S)
            (Metric.closedBall 0 |R|)) u * Real.log (R * ‖(0 : ℂ) - u‖⁻¹)
        + Real.log ‖finiteCanonicalProduct p S 0‖ := by
  apply AnalyticOnNhd.circleAverage_log_norm hR
  · intro z _
    exact (differentiable_finiteCanonicalProduct p S).analyticAt z
  · rw [finiteCanonicalProduct_zero]
    norm_num


/-- **Jensen's inequality (zero counting) for the finite canonical product.** -/
theorem sum_divisor_finiteCanonicalProduct_le (p : ℕ) (S : Finset ℂ)
    {r R M : ℝ} (hr : 0 < |r|) (hrR : |r| < |R|) (hM : 1 ≤ M)
    (hbound : ∀ z ∈ Metric.sphere (0 : ℂ) |R|,
      ‖finiteCanonicalProduct p S z‖ ≤ M) :
    (∑ᶠ u : ℂ,
        (MeromorphicOn.divisor (finiteCanonicalProduct p S)
          (Metric.closedBall 0 |r|)) u)
      ≤ Real.log (M / ‖finiteCanonicalProduct p S 0‖) / Real.log (R / r) := by
  apply AnalyticOnNhd.sum_divisor_le (c := 0) (f := finiteCanonicalProduct p S)
    hr hrR hM
  · intro z _
    exact (differentiable_finiteCanonicalProduct p S).analyticAt z
  · rw [finiteCanonicalProduct_zero]
    norm_num
  · exact hbound


/-- A holomorphic function on a ball with zero derivative is constant. -/
theorem eq_const_of_deriv_eq_zero_ball {f : ℂ → ℂ} {c : ℂ} {r : ℝ} (hr : 0 < r)
    (hf : DifferentiableOn ℂ f (Metric.ball c r))
    (h0 : Set.EqOn (deriv f) 0 (Metric.ball c r)) :
    ∀ x ∈ Metric.ball c r, f x = f c := by
  intro x hx
  exact Metric.isOpen_ball.is_const_of_deriv_eq_zero
    (convex_ball c r).isPreconnected hf h0 hx (Metric.mem_ball_self hr)


/-- If `G' = f'/f` and `f ≠ 0`, then `f * exp(-G)` has zero derivative. -/
theorem hasDerivAt_mul_cexp_neg_of_logDeriv {f G : ℂ → ℂ} {z : ℂ}
    (hf : HasDerivAt f (deriv f z) z)
    (hG : HasDerivAt G (deriv f z / f z) z)
    (hne : f z ≠ 0) :
    HasDerivAt (fun w => f w * cexp (-(G w))) 0 z := by
  have h1 : HasDerivAt (fun w => cexp (-(G w)))
      (cexp (-(G z)) * (-(deriv f z / f z))) z := by
    have := hG.neg.cexp
    simpa using this
  have h := hf.mul h1
  convert h using 1
  field_simp [hne]
  ring


/-- **The quotient `f * exp(-G)` is constant** when `G' = f'/f` on a ball and
`f` is zero-free there. -/
theorem const_mul_cexp_neg_of_primitive {f G : ℂ → ℂ} {c : ℂ} {r : ℝ} (hr : 0 < r)
    (hf : DifferentiableOn ℂ f (Metric.ball c r))
    (hG : DifferentiableOn ℂ G (Metric.ball c r))
    (hG' : ∀ z ∈ Metric.ball c r, deriv G z = deriv f z / f z)
    (hne : ∀ z ∈ Metric.ball c r, f z ≠ 0) :
    ∀ z ∈ Metric.ball c r,
      f z * cexp (-(G z)) = f c * cexp (-(G c)) := by
  apply eq_const_of_deriv_eq_zero_ball hr
  · exact hf.mul (hG.neg.cexp)
  · intro z hz
    have hfz : HasDerivAt f (deriv f z) z :=
      (hf.differentiableAt (Metric.isOpen_ball.mem_nhds hz)).hasDerivAt
    have hGz : HasDerivAt G (deriv f z / f z) z := by
      have h := (hG.differentiableAt (Metric.isOpen_ball.mem_nhds hz)).hasDerivAt
      rwa [hG' z hz] at h
    exact (hasDerivAt_mul_cexp_neg_of_logDeriv hfz hGz (hne z hz)).deriv


/-- **The zero-free differentiable logarithm on a ball**, given a primitive of
`f'/f`: `f = exp (G + c₀)` on the ball. -/
theorem exists_cexp_of_primitive {f G : ℂ → ℂ} {c : ℂ} {r : ℝ} (hr : 0 < r)
    (hf : DifferentiableOn ℂ f (Metric.ball c r))
    (hG : DifferentiableOn ℂ G (Metric.ball c r))
    (hG' : ∀ z ∈ Metric.ball c r, deriv G z = deriv f z / f z)
    (hne : ∀ z ∈ Metric.ball c r, f z ≠ 0) :
    ∃ c₀ : ℂ, ∀ z ∈ Metric.ball c r, cexp (G z + c₀) = f z := by
  have hc : c ∈ Metric.ball c r := Metric.mem_ball_self hr
  have hC : f c * cexp (-(G c)) ≠ 0 :=
    mul_ne_zero (hne c hc) (Complex.exp_ne_zero _)
  refine ⟨Complex.log (f c * cexp (-(G c))), ?_⟩
  intro z hz
  have h := const_mul_cexp_neg_of_primitive hr hf hG hG' hne z hz
  have hlog : cexp (Complex.log (f c * cexp (-(G c)))) = f c * cexp (-(G c)) :=
    Complex.exp_log hC
  calc cexp (G z + Complex.log (f c * cexp (-(G c))))
      = cexp (G z) * cexp (Complex.log (f c * cexp (-(G c)))) := by
        rw [Complex.exp_add]
    _ = cexp (G z) * (f c * cexp (-(G c))) := by rw [hlog]
    _ = cexp (G z) * (f z * cexp (-(G z))) := by rw [h]
    _ = f z := by
        rw [mul_comm (f z) (cexp (-(G z))), ← mul_assoc, ← Complex.exp_add,
          add_neg_cancel, Complex.exp_zero, one_mul]


/-- **The zero-free differentiable logarithm on a ball**, unconditionally for
a holomorphic zero-free function. -/
theorem exists_differentiable_cexp_ball {f : ℂ → ℂ} {c : ℂ} {r : ℝ} (hr : 0 < r)
    (hf : DifferentiableOn ℂ f (Metric.ball c r))
    (hne : ∀ z ∈ Metric.ball c r, f z ≠ 0) :
    ∃ g : ℂ → ℂ, DifferentiableOn ℂ g (Metric.ball c r) ∧
      ∀ z ∈ Metric.ball c r, cexp (g z) = f z := by
  have hlog : DifferentiableOn ℂ (logDeriv f) (Metric.ball c r) := by
    have hfun : logDeriv f = deriv f / f := by
      funext z
      rw [logDeriv_apply]
      rfl
    rw [hfun]
    exact (hf.deriv Metric.isOpen_ball).div hf hne
  rcases DifferentiableOn.isExactOn_ball hlog with ⟨G, hG⟩
  have hGdiff : DifferentiableOn ℂ G (Metric.ball c r) :=
    fun z hz => (hG z hz).differentiableAt.differentiableWithinAt
  have hG' : ∀ z ∈ Metric.ball c r, deriv G z = deriv f z / f z := by
    intro z hz
    rw [(hG z hz).deriv, logDeriv_apply]
  obtain ⟨c₀, hc₀⟩ := exists_cexp_of_primitive hr hf hGdiff hG' hne
  refine ⟨fun z => G z + c₀, hGdiff.add_const c₀, ?_⟩
  intro z hz
  exact hc₀ z hz


/-- **Zero-counting from Jensen's inequality**: the divisor sum in the ball of
radius `r` is at most `log (M / ‖f 0‖) / log 2`, where `M` bounds `f` on the
sphere of radius `2r`. -/
theorem sum_divisor_le_two_mul {f : ℂ → ℂ} {r M : ℝ} (hr : 0 < r) (hM : 1 ≤ M)
    (hf : AnalyticOnNhd ℂ f (Metric.closedBall (0 : ℂ) (2 * r)))
    (h0 : f 0 ≠ 0)
    (hbound : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * r), ‖f z‖ ≤ M) :
    (∑ᶠ u : ℂ, (MeromorphicOn.divisor f (Metric.closedBall 0 r)) u)
      ≤ Real.log (M / ‖f 0‖) / Real.log 2 := by
  have hRpos : (0 : ℝ) < 2 * r := by linarith
  have h := AnalyticOnNhd.sum_divisor_le (c := 0) (r := r) (R := 2 * r) (M := M)
    (by simpa [abs_of_pos hr] using hr)
    (by rw [abs_of_pos hr, abs_of_pos hRpos]; nlinarith)
    hM (by simpa [abs_of_pos hRpos] using hf) h0
      (by simpa [abs_of_pos hRpos] using hbound)
  have hratio : (2 * r) / r = 2 := by field_simp
  rw [abs_of_pos hr] at h
  simpa [hratio] using h


/-- **Bounded real part implies constant** (the simplest Borel–Carathéodory
step): an entire function whose real part is bounded above is constant. -/
theorem exists_const_of_re_le {g : ℂ → ℂ} (hg : Differentiable ℂ g) {M : ℝ}
    (hM : ∀ z, (g z).re ≤ M) : ∃ c, ∀ z, g z = c := by
  have hb : ∀ z, ‖cexp (g z)‖ ≤ Real.exp M := by
    intro z
    rw [Complex.norm_exp]
    exact Real.exp_le_exp.mpr (hM z)
  have hbdd : Bornology.IsBounded (Set.range (fun z => cexp (g z))) := by
    apply Metric.isBounded_iff.mpr
    refine ⟨2 * Real.exp M, ?_⟩
    rintro x ⟨z, rfl⟩ y ⟨w, rfl⟩
    calc dist (cexp (g z)) (cexp (g w))
        ≤ ‖cexp (g z)‖ + ‖cexp (g w)‖ := dist_le_norm_add_norm _ _
      _ ≤ Real.exp M + Real.exp M := by
          have h1 := hb z
          have h2 := hb w
          linarith
      _ = 2 * Real.exp M := by ring
  obtain ⟨C, hC⟩ := hg.cexp.exists_const_forall_eq_of_bounded hbdd
  have hderiv : ∀ z, deriv g z = 0 := by
    intro z
    have hconst : deriv (fun w => cexp (g w)) z = 0 := by
      have hfun : (fun w => cexp (g w)) = fun _ => C := funext hC
      rw [hfun]
      simp
    have hchain : deriv (fun w => cexp (g w)) z = cexp (g z) * deriv g z := by
      have hd : DifferentiableAt ℂ g z := hg.differentiableAt
      have := hd.hasDerivAt.cexp
      simpa using this.deriv
    rw [hchain] at hconst
    exact (mul_eq_zero.mp hconst).resolve_left (Complex.exp_ne_zero _)
  exact ⟨g 0, fun z => is_const_of_deriv_eq_zero hg hderiv z 0⟩


/-- **Bounded derivative implies affine**: the final linearity step for the
order-1 Hadamard exponential factor. -/
theorem eq_affine_of_deriv_bounded {g : ℂ → ℂ} (hg : Differentiable ℂ g) {K : ℝ}
    (hK : ∀ z, ‖deriv g z‖ ≤ K) :
    ∃ a b : ℂ, ∀ z, g z = a + b * z := by
  have hbdd : Bornology.IsBounded (Set.range (deriv g)) := by
    apply Metric.isBounded_iff.mpr
    refine ⟨2 * K, ?_⟩
    rintro x ⟨z, rfl⟩ y ⟨w, rfl⟩
    calc dist (deriv g z) (deriv g w) ≤ ‖deriv g z‖ + ‖deriv g w‖ :=
          dist_le_norm_add_norm _ _
      _ ≤ K + K := by linarith [hK z, hK w]
      _ = 2 * K := by ring
  obtain ⟨b, hb⟩ := hg.deriv.exists_const_forall_eq_of_bounded hbdd
  have h0 : ∀ z, deriv (fun z : ℂ => g z - b * z) z = 0 := by
    intro z
    have hdg : DifferentiableAt ℂ g z := hg.differentiableAt
    have hmul : HasDerivAt (fun y : ℂ => b * y) b z := by
      simpa using HasDerivAt.const_mul b (hasDerivAt_id z)
    have hd : HasDerivAt (fun z : ℂ => g z - b * z) (deriv g z - b) z :=
      hdg.hasDerivAt.sub hmul
    rw [hd.deriv, hb z]
    ring
  have hh : Differentiable ℂ (fun z : ℂ => g z - b * z) := by fun_prop
  refine ⟨g 0, b, fun z => ?_⟩
  have hz := is_const_of_deriv_eq_zero hh h0 z 0
  linear_combination hz


/-- **Linear real-part growth implies affine** (the order-1 Hadamard
exponential step), combining Borel–Carathéodory with the Cauchy estimate. -/
theorem eq_affine_of_re_le_linear {g : ℂ → ℂ} (hg : Differentiable ℂ g) {A B : ℝ}
    (hA : 0 ≤ A) (hre : ∀ z, (g z).re ≤ A * ‖z‖ + B) :
    ∃ a b : ℂ, ∀ z, g z = a + b * z := by
  have hlin : ∀ z, ‖g z‖ ≤ 4 * A * ‖z‖ + (2 * |B| + 2 + 3 * ‖g 0‖) := by
    intro z
    by_cases hz : z = 0
    · subst hz
      simp only [norm_zero, mul_zero]
      have : 0 ≤ 2 * |B| + 2 := by positivity
      linarith [norm_nonneg (g 0)]
    · have hzpos : 0 < ‖z‖ := norm_pos_iff.mpr hz
      set r := ‖z‖ with hr
      have hR : 0 < 2 * r := by linarith
      set M := max (2 * A * r + B) 1 with hMdef
      have hM : 0 < M := lt_of_lt_of_le zero_lt_one (le_max_right _ _)
      have hmaps : Set.MapsTo g (Metric.ball (0 : ℂ) (2 * r)) {w | w.re ≤ M} := by
        intro w hw
        have hwr : ‖w‖ < 2 * r := by
          have := Metric.mem_ball.mp hw
          simpa [dist_eq_norm] using this
        calc (g w).re ≤ A * ‖w‖ + B := hre w
          _ ≤ A * (2 * r) + B := by
              have := mul_le_mul_of_nonneg_left (le_of_lt hwr) hA
              linarith
          _ ≤ M := by
              rw [hMdef]
              have hEq : A * (2 * r) + B = 2 * A * r + B := by ring
              rw [hEq]
              exact le_max_left (2 * A * r + B) 1
      have hzball : z ∈ Metric.ball (0 : ℂ) (2 * r) := by
        rw [Metric.mem_ball, dist_eq_norm]
        simp only [sub_zero]
        rw [← hr]
        linarith
      have hBC := Complex.borelCaratheodory hM hg.differentiableOn hmaps hR hzball
      have hBC' : ‖g z‖ ≤ 2 * M + 3 * ‖g 0‖ := by
        calc ‖g z‖ ≤ 2 * M * r / (2 * r - r) + ‖g 0‖ * (2 * r + r) / (2 * r - r) := hBC
          _ = 2 * M + 3 * ‖g 0‖ := by
              field_simp [hzpos.ne']
              ring
      have hMle : M ≤ 2 * A * r + |B| + 1 := by
        rw [hMdef]
        apply max_le
        · nlinarith [le_abs_self B]
        · nlinarith [abs_nonneg B]
      calc ‖g z‖ ≤ 2 * M + 3 * ‖g 0‖ := hBC'
        _ ≤ 2 * (2 * A * r + |B| + 1) + 3 * ‖g 0‖ := by linarith
        _ = 4 * A * ‖z‖ + (2 * |B| + 2 + 3 * ‖g 0‖) := by rw [hr]; ring
  have hK : ∀ z, ‖deriv g z‖ ≤ 8 * A + (2 * |B| + 2 + 3 * ‖g 0‖) := by
    intro z
    set r := ‖z‖ with hr
    set R := r + 1 with hRdef
    have hR : 0 < R := by positivity
    have hC : ∀ w ∈ Metric.sphere z R,
        ‖g w‖ ≤ 4 * A * (r + R) + (2 * |B| + 2 + 3 * ‖g 0‖) := by
      intro w hw
      have hwdist : ‖w - z‖ = R := by
        have := Metric.mem_sphere.mp hw
        simpa [dist_eq_norm] using this
      have hwr : ‖w‖ ≤ r + R := by
        calc ‖w‖ = ‖(w - z) + z‖ := by ring_nf
          _ ≤ ‖w - z‖ + ‖z‖ := norm_add_le _ _
          _ = r + R := by rw [hwdist, hr]; ring
      have hlinw := hlin w
      have hmul : 4 * A * ‖w‖ ≤ 4 * A * (r + R) := by
        have := mul_le_mul_of_nonneg_left hwr (by positivity : (0:ℝ) ≤ 4 * A)
        linarith
      linarith
    have hd : DiffContOnCl ℂ g (Metric.ball z R) := hg.diffContOnCl
    have hcauchy := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le hR hd hC
    have hbound : (4 * A * (r + R) + (2 * |B| + 2 + 3 * ‖g 0‖)) / R
        ≤ 8 * A + (2 * |B| + 2 + 3 * ‖g 0‖) := by
      rw [hRdef, div_le_iff₀ hR]
      have hC2 : 0 ≤ 2 * |B| + 2 + 3 * ‖g 0‖ := by positivity
      nlinarith [hA, hC2, norm_nonneg z]
    linarith
  exact eq_affine_of_deriv_bounded hg hK


/-- **Global zero-free logarithm**: an entire function with no zeros is
`exp g` for an entire `g`. -/
theorem exists_differentiable_cexp_univ {Q : ℂ → ℂ} (hQ : Differentiable ℂ Q)
    (hne : ∀ z, Q z ≠ 0) :
    ∃ g : ℂ → ℂ, Differentiable ℂ g ∧ ∀ z, cexp (g z) = Q z := by
  have hlog : Differentiable ℂ (logDeriv Q) := by
    have hfun : logDeriv Q = deriv Q / Q := by
      funext z
      rw [logDeriv_apply]
      rfl
    rw [hfun]
    exact hQ.deriv.div hQ hne
  rcases Differentiable.isExactOn_univ hlog with ⟨G, hG⟩
  have hGdiff : Differentiable ℂ G := fun z => (hG z (Set.mem_univ z)).differentiableAt
  have hH : Differentiable ℂ (fun z => Q z * cexp (-(G z))) := by fun_prop
  have hderiv0 : ∀ z, deriv (fun z => Q z * cexp (-(G z))) z = 0 := by
    intro z
    have hQz : HasDerivAt Q (deriv Q z) z := hQ.differentiableAt.hasDerivAt
    have hGz : HasDerivAt G (deriv Q z / Q z) z := by
      have := hG z (Set.mem_univ z)
      rwa [logDeriv_apply] at this
    exact (hasDerivAt_mul_cexp_neg_of_logDeriv hQz hGz (hne z)).deriv
  have hconst : ∀ z w,
      Q z * cexp (-(G z)) = Q w * cexp (-(G w)) :=
    is_const_of_deriv_eq_zero hH hderiv0
  have hC : Q 0 * cexp (-(G 0)) ≠ 0 :=
    mul_ne_zero (hne 0) (Complex.exp_ne_zero _)
  refine ⟨fun z => G z + Complex.log (Q 0 * cexp (-(G 0))), hGdiff.add_const _, ?_⟩
  intro z
  have h := hconst z 0
  have hlogC : cexp (Complex.log (Q 0 * cexp (-(G 0)))) = Q 0 * cexp (-(G 0)) :=
    Complex.exp_log hC
  calc cexp (G z + Complex.log (Q 0 * cexp (-(G 0))))
      = cexp (G z) * cexp (Complex.log (Q 0 * cexp (-(G 0)))) := by
        rw [Complex.exp_add]
    _ = cexp (G z) * (Q 0 * cexp (-(G 0))) := by rw [hlogC]
    _ = cexp (G z) * (Q z * cexp (-(G z))) := by rw [h]
    _ = Q z := by
        rw [mul_comm (Q z) (cexp (-(G z))), ← mul_assoc, ← Complex.exp_add,
          add_neg_cancel, Complex.exp_zero, one_mul]


/-- The elementary factor has a **simple zero** at `1`:
`meromorphicOrderAt E_p 1 = 1`. -/
theorem meromorphicOrderAt_weierstrassFactor_one (p : ℕ) :
    meromorphicOrderAt (weierstrassFactor p) 1 = 1 := by
  have hfac : weierstrassFactor p
      = (fun z : ℂ => 1 - z)
        * (fun z : ℂ => cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))) := by
    funext z
    rfl
  have hexp_an : AnalyticAt ℂ
      (fun z : ℂ => cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))) 1 := by
    apply AnalyticAt.cexp
    fun_prop
  have hlin_an : AnalyticAt ℂ (fun z : ℂ => 1 - z) 1 := by fun_prop
  rw [hfac, meromorphicOrderAt_mul]
  · have h1 : meromorphicOrderAt (fun z : ℂ => 1 - z) 1 = 1 := by
      rw [show (fun z : ℂ => 1 - z) = -(fun z : ℂ => z - 1) by
        funext z
        simp]
      rw [← meromorphicOrderAt_neg]
      exact meromorphicOrderAt_id_sub_const
    rw [h1]
    have h2 : meromorphicOrderAt
        (fun z : ℂ => cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))) 1 = 0 := by
      rw [hexp_an.meromorphicOrderAt_eq]
      rw [show analyticOrderAt
          (fun z : ℂ => cexp (∑ k ∈ Finset.range p, z ^ (k + 1) / ((k : ℂ) + 1))) 1 = 0 by
        rw [hexp_an.analyticOrderAt_eq_zero]
        exact Complex.exp_ne_zero _]
      simp
    rw [h2, add_zero]
  · exact hlin_an.meromorphicAt
  · exact hexp_an.meromorphicAt


/-- Away from `1`, the elementary factor has order `0`. -/
theorem meromorphicOrderAt_weierstrassFactor_of_ne_one (p : ℕ) {z : ℂ} (hz : z ≠ 1) :
    meromorphicOrderAt (weierstrassFactor p) z = 0 := by
  have ha : AnalyticAt ℂ (weierstrassFactor p) z :=
    (differentiable_weierstrassFactor p).analyticAt z
  rw [ha.meromorphicOrderAt_eq]
  rw [show analyticOrderAt (weierstrassFactor p) z = 0 by
    rw [ha.analyticOrderAt_eq_zero]
    intro h
    exact hz ((weierstrassFactor_eq_zero_iff p z).mp h)]
  simp

/-- The full divisor of the elementary factor: order `1` at `1`, `0` elsewhere. -/
theorem meromorphicOrderAt_weierstrassFactor (p : ℕ) (z : ℂ) :
    meromorphicOrderAt (weierstrassFactor p) z = if z = 1 then 1 else 0 := by
  by_cases hz : z = 1
  · subst hz
    rw [ite_eq_left rfl, meromorphicOrderAt_weierstrassFactor_one]
  · rw [ite_eq_right hz, meromorphicOrderAt_weierstrassFactor_of_ne_one p hz]


/-- The divisor of the scaled factor `z ↦ E_p(z/w)`: order `1` at `w`, `0`
elsewhere. -/
theorem meromorphicOrderAt_weierstrassFactor_div (p : ℕ) {w : ℂ} (hw : w ≠ 0)
    (u : ℂ) :
    meromorphicOrderAt (fun z : ℂ => weierstrassFactor p (z / w)) u
      = if u = w then 1 else 0 := by
  have hg : AnalyticAt ℂ (fun z : ℂ => z / w) u := by fun_prop
  have hg' : deriv (fun z : ℂ => z / w) u ≠ 0 := by
    rw [deriv_div_const]
    simp [hw]
  change meromorphicOrderAt (weierstrassFactor p ∘ fun z : ℂ => z / w) u
      = if u = w then 1 else 0
  rw [meromorphicOrderAt_comp_of_deriv_ne_zero hg hg']
  rw [meromorphicOrderAt_weierstrassFactor]
  by_cases h : u = w
  · subst h
    rw [ite_eq_left (div_self hw), ite_eq_left rfl]
  · have hdiv : u / w ≠ 1 := by
      intro h1
      exact h ((div_eq_one_iff_eq hw).mp h1)
    rw [ite_eq_right hdiv, ite_eq_right h]


/-- **The divisor of the finite canonical product.**  The order at `u` is the
number of prescribed zeros equal to `u`. -/
theorem meromorphicOrderAt_finiteCanonicalProduct (p : ℕ) (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) (u : ℂ) :
    meromorphicOrderAt (finiteCanonicalProduct p S) u =
      (S.filter (fun w => w = u)).card := by
  classical
  induction S using Finset.induction_on with
  | empty =>
    have h1 : finiteCanonicalProduct p ∅ = fun _ => (1 : ℂ) := by
      funext z
      simp [finiteCanonicalProduct]
    rw [h1, meromorphicOrderAt_const]
    simp
  | insert a S ha ih =>
    have h0' : (0 : ℂ) ∉ S := fun h => h0 (Finset.mem_insert_of_mem h)
    have ha0 : a ≠ 0 := fun h => h0 (h ▸ Finset.mem_insert_self a S)
    have hprod : finiteCanonicalProduct p (insert a S)
        = (fun z : ℂ => weierstrassFactor p (z / a))
          * finiteCanonicalProduct p S := by
      funext z
      simp only [finiteCanonicalProduct, Pi.mul_apply]
      rw [Finset.prod_insert ha]
    rw [hprod, meromorphicOrderAt_mul]
    · rw [meromorphicOrderAt_weierstrassFactor_div p ha0 u, ih h0']
      rw [Finset.filter_insert]
      by_cases hau : a = u
      · have hua : u = a := hau.symm
        rw [ite_eq_left hua, ite_eq_left hau]
        have hnot : a ∉ S.filter (fun w => w = u) := by
          simp [Finset.mem_filter, ha]
        rw [Finset.card_insert_of_notMem hnot]
        push_cast
        exact add_comm 1 _
      · have hua : ¬u = a := fun h => hau h.symm
        rw [ite_eq_right hua, ite_eq_right hau]
        simp
    · exact ((differentiable_weierstrassFactor p).comp
        (differentiable_id.div_const a)).analyticAt u |>.meromorphicAt
    · exact (differentiable_finiteCanonicalProduct p S).analyticAt u |>.meromorphicAt


/-- At a prescribed zero, the finite canonical product has a simple zero. -/
theorem meromorphicOrderAt_finiteCanonicalProduct_self (p : ℕ) (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) {w : ℂ} (hw : w ∈ S) :
    meromorphicOrderAt (finiteCanonicalProduct p S) w = 1 := by
  rw [meromorphicOrderAt_finiteCanonicalProduct p S h0 w]
  have hfilter : S.filter (fun u => u = w) = {w} := by
    ext u
    simp only [Finset.mem_filter, Finset.mem_singleton]
    constructor
    · rintro ⟨_, rfl⟩
      rfl
    · intro h
      subst h
      exact ⟨hw, rfl⟩
  rw [hfilter]
  simp

/-- Away from the prescribed zeros, the finite canonical product has order zero. -/
theorem meromorphicOrderAt_finiteCanonicalProduct_of_not_mem (p : ℕ) (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) {u : ℂ} (hu : u ∉ S) :
    meromorphicOrderAt (finiteCanonicalProduct p S) u = 0 := by
  rw [meromorphicOrderAt_finiteCanonicalProduct p S h0 u]
  rw [Finset.filter_eq_empty_iff.mpr ?_]
  · simp
  · intro x hx hxu
    exact hu (hxu ▸ hx)


/-- An analytic function with nonzero value has meromorphic order `0`. -/
theorem meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero {f : ℂ → ℂ} {u : ℂ}
    (hf : AnalyticAt ℂ f u) (hne : f u ≠ 0) :
    meromorphicOrderAt f u = 0 := by
  rw [hf.meromorphicOrderAt_eq]
  rw [show analyticOrderAt f u = 0 by
    rw [hf.analyticOrderAt_eq_zero]
    exact hne]
  simp


/-- **The tail product at a zero converges**: with the factor at `k` removed,
the remaining product over `{n // n ≠ k}` is multipliable. -/
theorem multipliable_tail_weierstrassFactor {a : ℕ → ℂ} {p : ℕ} (k : ℕ)
    (hk : a k ≠ 0) (hsep : ∀ n, n ≠ k → 2 * ‖a k‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖a k‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    Multipliable (fun n : {n // n ≠ k} =>
      weierstrassFactor p (a k / a n)) := by
  apply multipliable_weierstrassFactor
    (a := fun n : {n // n ≠ k} => a n) hk
  · intro n
    exact hsep n n.2
  · exact h.subtype _

/-- **The tail product is nonzero at the zero**: removing the factor at `k`,
the remaining product does not vanish at `a k`. -/
theorem tprod_tail_weierstrassFactor_ne_zero {a : ℕ → ℂ} {p : ℕ} (k : ℕ)
    (hk : a k ≠ 0) (hsep : ∀ n, n ≠ k → 2 * ‖a k‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖a k‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hdistinct : ∀ n, n ≠ k → a k ≠ a n) :
    (∏' n : {n // n ≠ k}, weierstrassFactor p (a k / a n)) ≠ 0 := by
  apply tprod_weierstrassFactor_ne_zero
    (a := fun n : {n // n ≠ k} => a n) hk
  · intro n
    exact hsep n n.2
  · exact h.subtype _
  · intro n
    exact hdistinct n n.2


/-- **The tail product is analytic on a ball** around the removed zero. -/
theorem analyticOnNhd_tprod_tail_weierstrassFactor {a : ℕ → ℂ} {p : ℕ} (k : ℕ)
    {R : ℝ} (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0)
    (ha : ∀ n, n ≠ k → 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    AnalyticOnNhd ℂ
      (fun z => ∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n))
      (Metric.ball 0 R) := by
  apply analyticOnNhd_tprod_weierstrassFactor_ball
    (a := fun n : {n // n ≠ k} => a n) hR
  · intro n
    exact ha0 n
  · intro n
    exact ha n n.2
  · exact h.subtype _



set_option maxHeartbeats 1000000 in
/-- **Splitting the infinite product at one factor.**  At a point where the
product converges and the factors satisfy the decay bound, the full product is
the factor at `k` times the product over the remaining indices. -/
theorem tprod_weierstrassFactor_eq_mul_tail {a : ℕ → ℂ} {p : ℕ} {z : ℂ} (k : ℕ)
    (hz : z ≠ 0) (ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    (∏' n, weierstrassFactor p (z / a n))
      = weierstrassFactor p (z / a k)
        * (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
  have hfull : HasProd (fun n => weierstrassFactor p (z / a n))
      (∏' n, weierstrassFactor p (z / a n)) :=
    (multipliable_weierstrassFactor (a := a) hz ha h).hasProd
  have htail : HasProd (fun n : {n // n ≠ k} =>
      weierstrassFactor p (z / a n))
      (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) :=
    (multipliable_weierstrassFactor (a := fun n : {n // n ≠ k} => a n) hz
      (fun n => ha n) (h.subtype _)).hasProd
  let e : {n // n ∈ (({k} : Set ℕ))ᶜ} ≃ {n // n ≠ k} :=
    Equiv.subtypeEquivRight (fun n => by
      simp)
  have htail' : HasProd
      (fun n : {n // n ∈ (({k} : Set ℕ))ᶜ} => weierstrassFactor p (z / a n))
      (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
    have hcomp := (Equiv.hasProd_iff e).mpr htail
    have hfun : ((fun n : {n // n ≠ k} => weierstrassFactor p (z / a n)) ∘ e)
        = fun n : {n // n ∈ (({k} : Set ℕ))ᶜ} =>
            weierstrassFactor p (z / a n) := by
      funext n
      rfl
    rw [hfun] at hcomp
    exact hcomp
  have hsingle : HasProd
      (fun n : {n // n ∈ ({k} : Set ℕ)} => weierstrassFactor p (z / a n))
      (weierstrassFactor p (z / a k)) :=
    hasProd_singleton k (fun n => weierstrassFactor p (z / a n))
  have hsplit := HasProd.mul_compl (s := ({k} : Set ℕ))
    (f := fun n => weierstrassFactor p (z / a n)) hsingle htail'
  exact hfull.unique hsplit


/-- The pointwise split holds on the disk where `2‖z‖ ≤ ‖a n‖`. -/
theorem tprod_weierstrassFactor_eq_mul_tail_on_ball {a : ℕ → ℂ} {p : ℕ} {R : ℝ}
    (hR : 0 < R) (_ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (k : ℕ) :
    ∀ z ∈ Metric.ball (0 : ℂ) R,
      (∏' n, weierstrassFactor p (z / a n))
        = weierstrassFactor p (z / a k)
          * (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
  intro z hz
  by_cases hz0 : z = 0
  · subst hz0
    simp [weierstrassFactor_zero]
  · have hzR : ‖z‖ < R := by
      have := Metric.mem_ball.mp hz
      simpa [dist_eq_norm] using this
    have ha' : ∀ n, 2 * ‖z‖ ≤ ‖a n‖ := by
      intro n
      have := ha n
      nlinarith
    have hRsum : Summable (fun n => R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      have := h.mul_left (Real.exp 1)⁻¹
      refine this.congr (fun n => ?_)
      field_simp
    have hsum : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
      intro n
      have hzle : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
        pow_le_pow_left₀ (norm_nonneg z) (le_of_lt hzR) (p + 1)
      have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
      gcongr
    exact tprod_weierstrassFactor_eq_mul_tail k hz0 ha' hsum


set_option maxHeartbeats 1000000 in
/-- **Splitting at a factor without a bound at `k`.**  If the decay bound holds
for every `n ≠ k`, the full product is the factor at `k` times the tail.  This
version reaches the zero `a k`. -/
theorem tprod_weierstrassFactor_eq_mul_tail_of_ne {a : ℕ → ℂ} {p : ℕ} {z : ℂ}
    (k : ℕ) (hz : z ≠ 0) (ha : ∀ n, n ≠ k → 2 * ‖z‖ ≤ ‖a n‖)
    (h : Summable (fun n : {n // n ≠ k} =>
      ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    (∏' n, weierstrassFactor p (z / a n))
      = weierstrassFactor p (z / a k)
        * (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
  have htail : HasProd (fun n : {n // n ≠ k} =>
      weierstrassFactor p (z / a n))
      (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) :=
    (multipliable_weierstrassFactor (a := fun n : {n // n ≠ k} => a n) hz
      (fun n => ha n n.2) h).hasProd
  let e : {n // n ∈ (({k} : Set ℕ))ᶜ} ≃ {n // n ≠ k} :=
    Equiv.subtypeEquivRight (fun n => by simp)
  have htail' : HasProd
      (fun n : {n // n ∈ (({k} : Set ℕ))ᶜ} => weierstrassFactor p (z / a n))
      (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
    have hcomp := (Equiv.hasProd_iff e).mpr htail
    have hfun : ((fun n : {n // n ≠ k} => weierstrassFactor p (z / a n)) ∘ e)
        = fun n : {n // n ∈ (({k} : Set ℕ))ᶜ} =>
            weierstrassFactor p (z / a n) := by
      funext n
      rfl
    rw [hfun] at hcomp
    exact hcomp
  have hsingle : HasProd
      (fun n : {n // n ∈ ({k} : Set ℕ)} => weierstrassFactor p (z / a n))
      (weierstrassFactor p (z / a k)) :=
    hasProd_singleton k (fun n => weierstrassFactor p (z / a n))
  have hfull := HasProd.mul_compl (s := ({k} : Set ℕ))
    (f := fun n => weierstrassFactor p (z / a n)) hsingle htail'
  exact hfull.tprod_eq


/-- The split holds on the **tail ball** (bound only off `k`), which contains
the zero `a k`. -/
theorem tprod_weierstrassFactor_eq_mul_tail_on_tailBall {a : ℕ → ℂ} {p : ℕ} {R : ℝ}
    (k : ℕ) (hR : 0 < R) (ha : ∀ n, n ≠ k → 2 * R ≤ ‖a n‖)
    (h : Summable (fun n : {n // n ≠ k} =>
      Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    ∀ z ∈ Metric.ball (0 : ℂ) R,
      (∏' n, weierstrassFactor p (z / a n))
        = weierstrassFactor p (z / a k)
          * (∏' n : {n // n ≠ k}, weierstrassFactor p (z / a n)) := by
  intro z hz
  by_cases hz0 : z = 0
  · subst hz0
    simp [weierstrassFactor_zero]
  · have hzR : ‖z‖ < R := by
      have := Metric.mem_ball.mp hz
      simpa [dist_eq_norm] using this
    have ha' : ∀ n, n ≠ k → 2 * ‖z‖ ≤ ‖a n‖ := by
      intro n hn
      have := ha n hn
      nlinarith
    have hRsum : Summable (fun n : {n // n ≠ k} =>
        R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      have := h.mul_left (Real.exp 1)⁻¹
      refine this.congr (fun n => ?_)
      field_simp
    have hsum : Summable (fun n : {n // n ≠ k} =>
        ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
      intro n
      have hzle : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
        pow_le_pow_left₀ (norm_nonneg z) (le_of_lt hzR) (p + 1)
      have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
      gcongr
    exact tprod_weierstrassFactor_eq_mul_tail_of_ne k hz0 ha' hsum


set_option maxHeartbeats 1000000 in
/-- **The infinite canonical product has a simple zero at each prescribed
zero** (under separation and distinctness). -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_at_zero {a : ℕ → ℂ} {p : ℕ}
    (k : ℕ) {R : ℝ} (hR : 0 < R) (hkR : ‖a k‖ < R)
    (ha0 : ∀ n, a n ≠ 0) (ha : ∀ n, n ≠ k → 2 * R ≤ ‖a n‖)
    (h : Summable (fun n : ℕ =>
      Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hdistinct : ∀ n, n ≠ k → a k ≠ a n) :
    meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) (a k) = 1 := by
  set Q : ℂ → ℂ := fun z => ∏' n : {n // n ≠ k},
    weierstrassFactor p (z / a n) with hQ
  set F : ℂ → ℂ := fun z => weierstrassFactor p (z / a k) * Q z with hF
  have hQan : AnalyticOnNhd ℂ Q (Metric.ball 0 R) :=
    analyticOnNhd_tprod_tail_weierstrassFactor k hR ha0 ha h
  have hkball : a k ∈ Metric.ball (0 : ℂ) R := by
    rw [Metric.mem_ball, dist_eq_norm]
    simpa using hkR
  have hQat : AnalyticAt ℂ Q (a k) := hQan (a k) hkball
  have hEat : AnalyticAt ℂ (fun z : ℂ => weierstrassFactor p (z / a k)) (a k) :=
    ((differentiable_weierstrassFactor p).comp
      (differentiable_id.div_const (a k))).analyticAt (a k)
  have hsep' : ∀ n, n ≠ k → 2 * ‖a k‖ ≤ ‖a n‖ := by
    intro n hn
    have := ha n hn
    nlinarith
  have hRsum : Summable (fun n : ℕ =>
      R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    have := h.mul_left (Real.exp 1)⁻¹
    refine this.congr (fun n => ?_)
    field_simp
  have hsum' : Summable (fun n : ℕ =>
      ‖a k‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
    intro n
    have hle : ‖a k‖ ^ (p + 1) ≤ R ^ (p + 1) :=
      pow_le_pow_left₀ (norm_nonneg _) (le_of_lt hkR) (p + 1)
    have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
    gcongr
  have hQne : Q (a k) ≠ 0 :=
    tprod_tail_weierstrassFactor_ne_zero k (ha0 k) hsep' hsum' hdistinct
  have hQorder : meromorphicOrderAt Q (a k) = 0 :=
    meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero hQat hQne
  have hEorder : meromorphicOrderAt
      (fun z : ℂ => weierstrassFactor p (z / a k)) (a k) = 1 := by
    rw [meromorphicOrderAt_weierstrassFactor_div p (ha0 k) (a k)]
    rw [ite_eq_left rfl]
  have hForder : meromorphicOrderAt F (a k) = 1 := by
    have hmul := meromorphicOrderAt_mul
      (f := fun z : ℂ => weierstrassFactor p (z / a k)) (g := Q) (x := a k)
      hEat.meromorphicAt hQat.meromorphicAt
    change meromorphicOrderAt
      ((fun z : ℂ => weierstrassFactor p (z / a k)) * Q) (a k) = 1
    rw [hmul, hEorder, hQorder]
    norm_num
  have heq : ∀ z ∈ Metric.ball 0 R,
      (∏' n, weierstrassFactor p (z / a n)) = F z := by
    intro z hz
    exact tprod_weierstrassFactor_eq_mul_tail_on_tailBall k hR ha (h.subtype _) z hz
  have hcongr : meromorphicOrderAt
      (fun z => ∏' n, weierstrassFactor p (z / a n)) (a k)
      = meromorphicOrderAt F (a k) := by
    apply meromorphicOrderAt_congr
    have hev : ∀ᶠ z in nhds (a k),
        (∏' n, weierstrassFactor p (z / a n)) = F z := by
      filter_upwards [Metric.isOpen_ball.mem_nhds hkball] with z hz
      exact heq z hz
    exact hev.filter_mono nhdsWithin_le_nhds
  rw [hcongr, hForder]


/-- If two meromorphic functions have the same order at a point, their quotient
has order `0` there.  This is the first step in showing `f / P` is analytic and
zero-free when the divisors match. -/
theorem meromorphicOrderAt_div_eq_zero_of_eq {f g : ℂ → ℂ} {u : ℂ}
    (hf : MeromorphicAt f u) (hg : MeromorphicAt g u)
    (h : meromorphicOrderAt f u = meromorphicOrderAt g u)
    (hfin : meromorphicOrderAt g u ≠ ⊤) :
    meromorphicOrderAt (f / g) u = 0 := by
  rw [meromorphicOrderAt_div hf hg, h]
  cases hg' : meromorphicOrderAt g u with
  | top => exact absurd hg' hfin
  | coe n => simp


/-- A meromorphic function in normal form with nonnegative order is analytic. -/
theorem analyticAt_of_meromorphicNFAt_order_nonneg {f : ℂ → ℂ} {u : ℂ}
    (hnf : MeromorphicNFAt f u) (h : 0 ≤ meromorphicOrderAt f u) :
    AnalyticAt ℂ f u :=
  hnf.meromorphicOrderAt_nonneg_iff_analyticAt.mp h

/-- A meromorphic function in normal form with order `0` is nonzero at the
point. -/
theorem ne_zero_of_meromorphicNFAt_order_eq_zero {f : ℂ → ℂ} {u : ℂ}
    (hnf : MeromorphicNFAt f u) (h : meromorphicOrderAt f u = 0) :
    f u ≠ 0 :=
  hnf.meromorphicOrderAt_eq_zero_iff.mp h


set_option maxHeartbeats 1000000 in
/-- **The quotient normal form is entire and zero-free**, given that `f` and
`P` are meromorphic everywhere, have the same finite orders, and therefore the
quotient has order `0` everywhere. -/
theorem exists_entire_zeroFree_quotient {f P : ℂ → ℂ}
    (hf : MeromorphicOn f Set.univ) (hP : MeromorphicOn P Set.univ)
    (hmatch : ∀ u, meromorphicOrderAt f u = meromorphicOrderAt P u)
    (hfin : ∀ u, meromorphicOrderAt f u ≠ ⊤) :
    ∃ Q : ℂ → ℂ,
      Q = toMeromorphicNFOn (fun z => f z / P z) Set.univ ∧
      Differentiable ℂ Q ∧ ∀ z, Q z ≠ 0 := by
  let G : ℂ → ℂ := fun z => f z / P z
  have hG : MeromorphicOn G Set.univ := hf.div hP
  let Q : ℂ → ℂ := toMeromorphicNFOn G Set.univ
  have hQnf : MeromorphicNFOn Q Set.univ :=
    meromorphicNFOn_toMeromorphicNFOn G Set.univ
  have horder : ∀ z, meromorphicOrderAt Q z = 0 := by
    intro z
    change meromorphicOrderAt (toMeromorphicNFOn G Set.univ) z = 0
    rw [meromorphicOrderAt_toMeromorphicNFOn hG (Set.mem_univ z)]
    exact meromorphicOrderAt_div_eq_zero_of_eq (hf z (Set.mem_univ z))
      (hP z (Set.mem_univ z)) (hmatch z) (hmatch z ▸ hfin z)
  have hQdiff : Differentiable ℂ Q := by
    intro z
    exact (analyticAt_of_meromorphicNFAt_order_nonneg
      (hQnf (Set.mem_univ z)) (le_of_eq (horder z).symm)).differentiableAt
  have hQne : ∀ z, Q z ≠ 0 := by
    intro z
    exact ne_zero_of_meromorphicNFAt_order_eq_zero
      (hQnf (Set.mem_univ z)) (horder z)
  exact ⟨Q, rfl, hQdiff, hQne⟩


/-- If the reciprocal-power majorant is summable, the zeros eventually leave
any fixed ball: `2R ≤ ‖a n‖` eventually. -/
theorem eventually_two_mul_le_norm {a : ℕ → ℂ} {p : ℕ} {R : ℝ} (hR : 0 < R)
    (ha0 : ∀ n, a n ≠ 0)
    (h : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1))) :
    ∀ᶠ n in Filter.atTop, 2 * R ≤ ‖a n‖ := by
  have h0 : Filter.Tendsto (fun n => (‖a n‖)⁻¹ ^ (p + 1)) Filter.atTop (nhds 0) :=
    h.tendsto_atTop_zero
  have hpos : 0 < (2 * R)⁻¹ ^ (p + 1) := by positivity
  filter_upwards [h0.eventually (eventually_lt_nhds hpos)] with n hn
  by_contra hle
  push Not at hle
  have ha_pos : 0 < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
  have hinv : (2 * R)⁻¹ < (‖a n‖)⁻¹ := by
    rw [inv_lt_inv₀ (by positivity) ha_pos]
    linarith
  have hpow : (2 * R)⁻¹ ^ (p + 1) < (‖a n‖)⁻¹ ^ (p + 1) :=
    pow_lt_pow_left₀ hinv (le_of_lt (by positivity)) (Nat.succ_ne_zero p)
  linarith


/-- The finite initial product as a `HasProd`. -/
theorem hasProd_range {f : ℕ → ℂ} (N : ℕ) :
    HasProd (fun n : {n // n ∈ Finset.range N} => f n) (∏ n ∈ Finset.range N, f n) :=
  Finset.hasProd (Finset.range N) f

/-- The complement of `range N` is `{n // N ≤ n}`, and it is equivalent to `ℕ`
by `m ↦ N + m`. -/
def complRangeEquiv (N : ℕ) :
    ℕ ≃ {n : ℕ // n ∈ ((Finset.range N : Set ℕ))ᶜ} where
  toFun m := ⟨N + m, by
    show N + m ∉ Finset.range N
    rw [Finset.mem_range]
    omega⟩
  invFun n := n.1 - N
  left_inv m := by
    show (N + m) - N = m
    omega
  right_inv n := by
    apply Subtype.ext
    show N + (n.1 - N) = n.1
    have hN : N ≤ n.1 := by
      have h : ¬ n.1 < N := by
        intro hlt
        exact n.2 (Finset.mem_range.mpr hlt)
      omega
    omega

set_option maxHeartbeats 1000000 in
/-- **Split at a finite initial segment**: the full product is the initial
product times the reindexed tail. -/
theorem tprod_eq_prod_range_mul_tprod_shift {f : ℕ → ℂ} {N : ℕ}
    (h : Multipliable (fun m => f (N + m))) :
    (∏' n, f n) = (∏ n ∈ Finset.range N, f n) * (∏' m, f (N + m)) := by
  have hfin : HasProd (f ∘ Subtype.val) (∏ n ∈ Finset.range N, f n) :=
    Finset.hasProd (Finset.range N) f
  have htailN : HasProd (fun m => f (N + m)) (∏' m, f (N + m)) := h.hasProd
  let e := complRangeEquiv N
  have hfun : ((fun n : {n : ℕ // n ∈ ((Finset.range N : Set ℕ))ᶜ} => f n) ∘ e)
      = fun m => f (N + m) := by
    funext m
    rfl
  have hcomp : HasProd
      ((fun n : {n : ℕ // n ∈ ((Finset.range N : Set ℕ))ᶜ} => f n) ∘ e)
      (∏' m, f (N + m)) := by
    rw [hfun]
    exact htailN
  have htail' : HasProd
      (fun n : {n : ℕ // n ∈ ((Finset.range N : Set ℕ))ᶜ} => f n)
      (∏' m, f (N + m)) :=
    (Equiv.hasProd_iff e).mp hcomp
  have hfull := HasProd.mul_compl
    (s := (Finset.range N : Set ℕ)) (f := f) hfin htail'
  exact hfull.tprod_eq


/-- The reindexed tail product is analytic on the ball when the tail satisfies
the global decay bound. -/
theorem analyticOnNhd_tprod_weierstrassFactor_ball_shift {a : ℕ → ℂ} {p : ℕ}
    {R : ℝ} (N : ℕ) (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0)
    (hN : ∀ m, 2 * R ≤ ‖a (N + m)‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    AnalyticOnNhd ℂ (fun z => ∏' m, weierstrassFactor p (z / a (N + m)))
      (Metric.ball 0 R) := by
  apply analyticOnNhd_tprod_weierstrassFactor_ball (a := fun m => a (N + m)) hR
  · intro m
    exact ha0 (N + m)
  · intro m
    exact hN m
  · have := (summable_nat_add_iff N).mpr h
    simpa [Nat.add_comm] using this


set_option maxHeartbeats 1000000 in
/-- **Global analyticity of the canonical product** (eventual decay version):
if the zeros eventually satisfy `2R ≤ ‖a n‖`, the product is analytic on the
ball of radius `R`. -/
theorem analyticOnNhd_tprod_weierstrassFactor_of_eventually {a : ℕ → ℂ} {p : ℕ}
    {R : ℝ} (hR : 0 < R) (ha0 : ∀ n, a n ≠ 0)
    (hevent : ∀ᶠ n in Filter.atTop, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1))) :
    AnalyticOnNhd ℂ (fun z => ∏' n, weierstrassFactor p (z / a n))
      (Metric.ball 0 R) := by
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp hevent
  have htail := analyticOnNhd_tprod_weierstrassFactor_ball_shift N hR ha0
    (fun m => hN (N + m) (Nat.le_add_right N m)) h
  have hfin : AnalyticOnNhd ℂ
      (fun z => ∏ n ∈ Finset.range N, weierstrassFactor p (z / a n))
      (Metric.ball 0 R) := by
    apply DifferentiableOn.analyticOnNhd _ Metric.isOpen_ball
    fun_prop
  refine AnalyticOnNhd.congr Metric.isOpen_ball (hfin.mul htail) ?_
  intro z hz
  have hzR : ‖z‖ < R := by
    have := Metric.mem_ball.mp hz
    simpa [dist_eq_norm] using this
  by_cases hz0 : z = 0
  · subst hz0
    simp [weierstrassFactor_zero]
  · have hRsum : Summable (fun n => R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      have := h.mul_left (Real.exp 1)⁻¹
      refine this.congr (fun n => ?_)
      field_simp
    have hzsum : Summable (fun n => ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
      apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
      intro n
      have hzle : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
        pow_le_pow_left₀ (norm_nonneg z) (le_of_lt hzR) (p + 1)
      have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
      gcongr
    have hmult : Multipliable (fun m => weierstrassFactor p (z / a (N + m))) := by
      apply multipliable_weierstrassFactor (z := z) hz0 ?_ ?_
      · intro m
        have := hN (N + m) (Nat.le_add_right N m)
        nlinarith
      · have := (summable_nat_add_iff N).mpr hzsum
        simpa [Nat.add_comm] using this
    have hsplit := tprod_eq_prod_range_mul_tprod_shift
      (f := fun n => weierstrassFactor p (z / a n)) (N := N) hmult
    exact hsplit.symm


set_option maxHeartbeats 1000000 in
/-- **The canonical product is entire**: under nonzero zeros and summability of
the reciprocal-power majorant, `z ↦ ∏' n, E_p(z / a n)` is complex
differentiable everywhere. -/
theorem differentiable_tprod_weierstrassFactor {a : ℕ → ℂ} {p : ℕ}
    (ha0 : ∀ n, a n ≠ 0)
    (h : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1))) :
    Differentiable ℂ (fun z => ∏' n, weierstrassFactor p (z / a n)) := by
  intro z
  have hR : 0 < ‖z‖ + 1 := by positivity
  have hzmem : z ∈ Metric.ball (0 : ℂ) (‖z‖ + 1) := by
    simp [Metric.mem_ball, dist_eq_norm]
  have hevent : ∀ᶠ n in Filter.atTop, 2 * (‖z‖ + 1) ≤ ‖a n‖ :=
    eventually_two_mul_le_norm hR ha0 h
  have hsum : Summable (fun n =>
      Real.exp 1 * (‖z‖ + 1) ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    have := h.mul_left (Real.exp 1 * (‖z‖ + 1) ^ (p + 1))
    refine this.congr (fun n => ?_)
    rw [div_eq_mul_inv, inv_pow]
  have han := analyticOnNhd_tprod_weierstrassFactor_of_eventually hR ha0 hevent hsum
  exact (han z hzmem).differentiableAt


/-- The quotient normal form agrees with `f / P` on the punctured
neighbourhood of `0`. -/
theorem quotient_nf_eventuallyEq {f P : ℂ → ℂ}
    (hG : MeromorphicOn (fun z => f z / P z) Set.univ) :
    (toMeromorphicNFOn (fun z => f z / P z) Set.univ)
      =ᶠ[nhdsWithin (0 : ℂ) {0}ᶜ] (fun z => f z / P z) :=
  MeromorphicOn.toMeromorphicNFOn_eq_self_on_nhdsNE hG (Set.mem_univ 0)


set_option maxHeartbeats 1000000 in
/-- **Eventual identity `P · Q = f` at `0`**: with `P` entire, `P(0)=1`, and
`Q` the (entire) normal form of `f/P`, the product `P·Q` agrees with `f`
eventually at `0`. -/
theorem eventual_eq_mul_quotientNF {f P : ℂ → ℂ}
    (hf : Differentiable ℂ f) (hP : Differentiable ℂ P)
    (hP0 : P 0 = 1)
    (hQdiff : Differentiable ℂ (toMeromorphicNFOn (fun z => f z / P z) Set.univ)) :
    (fun z => P z * (toMeromorphicNFOn (fun z => f z / P z) Set.univ) z)
      =ᶠ[nhds (0 : ℂ)] f := by
  let G : ℂ → ℂ := fun z => f z / P z
  let Q : ℂ → ℂ := toMeromorphicNFOn G Set.univ
  have hfM : MeromorphicOn f Set.univ := fun z _ => (hf.analyticAt z).meromorphicAt
  have hPM : MeromorphicOn P Set.univ := fun z _ => (hP.analyticAt z).meromorphicAt
  have hG : MeromorphicOn G Set.univ := hfM.div hPM
  have hQeq : Q =ᶠ[nhdsWithin (0 : ℂ) {0}ᶜ] G := quotient_nf_eventuallyEq hG
  have h0 : P 0 ≠ 0 := by rw [hP0]; exact one_ne_zero
  have hPne_nhds : ∀ᶠ z in nhds (0 : ℂ), P z ≠ 0 :=
    hP.continuous.continuousAt.tendsto.eventually (isOpen_ne.mem_nhds h0)
  have hPne : ∀ᶠ z in nhdsWithin (0 : ℂ) {0}ᶜ, P z ≠ 0 :=
    hPne_nhds.filter_mono nhdsWithin_le_nhds
  have hprod : (fun z => P z * Q z) =ᶠ[nhdsWithin (0 : ℂ) {0}ᶜ] f := by
    filter_upwards [hQeq, hPne] with z hzQ hzP
    rw [hzQ]
    exact mul_div_cancel₀ (f z) hzP
  set H : ℂ → ℂ := fun z => P z * Q z - f z with hH
  have hHdiff : Differentiable ℂ H := (hP.mul hQdiff).sub hf
  have hHpunct : ∀ᶠ z in nhdsWithin (0 : ℂ) {0}ᶜ, H z = 0 := by
    filter_upwards [hprod] with z hz
    simp [hH, hz]
  obtain ⟨s, hs_mem, hs_sub⟩ := Filter.eventually_iff_exists_mem.mp hHpunct
  obtain ⟨r, hrpos, hrsub⟩ := Metric.mem_nhdsWithin_iff.mp hs_mem
  have hball : ∀ z ∈ Metric.ball (0 : ℂ) r, z ≠ 0 → H z = 0 := by
    intro z hz hz0
    exact hs_sub z (hrsub ⟨hz, hz0⟩)
  have hlim : Filter.Tendsto H (nhdsWithin (0 : ℂ) {0}ᶜ) (nhds (H 0)) :=
    hHdiff.continuous.continuousAt.tendsto.mono_left nhdsWithin_le_nhds
  have hlim0 : Filter.Tendsto H (nhdsWithin (0 : ℂ) {0}ᶜ) (nhds 0) := by
    apply tendsto_const_nhds.congr'
    filter_upwards [hHpunct] with z hz
    exact hz.symm
  have hH0 : H 0 = 0 := tendsto_nhds_unique hlim hlim0
  have hHev : ∀ᶠ z in nhds (0 : ℂ), H z = 0 := by
    filter_upwards [Metric.isOpen_ball.mem_nhds (Metric.mem_ball_self hrpos)] with z hz
    by_cases hz0 : z = 0
    · subst hz0
      exact hH0
    · exact hball z hz hz0
  filter_upwards [hHev] with z hz
  exact sub_eq_zero.mp (by simpa [hH] using hz)


set_option maxHeartbeats 1000000 in
/-- **The global identity `f = P · Q`**, where `Q` is the entire normal form of
`f / P`: with `P` entire and `P(0) = 1`, `f` is `P` times the quotient normal
form everywhere. -/
theorem eq_mul_quotientNF {f P : ℂ → ℂ}
    (hf : Differentiable ℂ f) (hP : Differentiable ℂ P)
    (hP0 : P 0 = 1)
    (hQdiff : Differentiable ℂ (toMeromorphicNFOn (fun z => f z / P z) Set.univ)) :
    ∀ z, f z = P z * (toMeromorphicNFOn (fun z => f z / P z) Set.univ) z := by
  let Q : ℂ → ℂ := toMeromorphicNFOn (fun z => f z / P z) Set.univ
  have hev : (fun z => P z * Q z) =ᶠ[nhds (0 : ℂ)] f :=
    eventual_eq_mul_quotientNF hf hP hP0 hQdiff
  have hH : Differentiable ℂ (fun z => P z * Q z - f z) := (hP.mul hQdiff).sub hf
  have hH0 : (fun z => P z * Q z - f z) =ᶠ[nhds (0 : ℂ)] (fun _ => 0) := by
    filter_upwards [hev] with z hz
    simp [hz]
  have hzero : (fun z => P z * Q z - f z) = fun _ => (0 : ℂ) :=
    AnalyticOnNhd.eq_of_eventuallyEq
      (DifferentiableOn.analyticOnNhd hH.differentiableOn isOpen_univ)
      (analyticOnNhd_const (v := (0 : ℂ))) hH0
  intro z
  have hz := congrFun hzero z
  exact (sub_eq_zero.mp hz).symm


set_option maxHeartbeats 1000000 in
/-- **Hadamard factorisation, quotient form.**  If the canonical product's
divisor matches the finite-order divisor of the entire function `f`, then
`f` is the canonical product times an exponential of an entire function. -/
theorem exists_factorization_of_divisor_match {f : ℂ → ℂ} {a : ℕ → ℂ} {p : ℕ}
    (hf : Differentiable ℂ f) (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt f u = meromorphicOrderAt
      (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt f u ≠ ⊤) :
    ∃ g : ℂ → ℂ, Differentiable ℂ g ∧
      ∀ z, f z = (∏' n, weierstrassFactor p (z / a n)) * cexp (g z) := by
  set P : ℂ → ℂ := fun z => ∏' n, weierstrassFactor p (z / a n) with hPdef
  have hP : Differentiable ℂ P := differentiable_tprod_weierstrassFactor ha0 hsum
  have hP0 : P 0 = 1 := by
    rw [hPdef]
    exact (hasProd_weierstrassFactor_zero p a).tprod_eq
  have hfM : MeromorphicOn f Set.univ := fun z _ => (hf.analyticAt z).meromorphicAt
  have hPM : MeromorphicOn P Set.univ := fun z _ => (hP.analyticAt z).meromorphicAt
  obtain ⟨Q, hQeq, hQdiff, hQne⟩ :=
    exists_entire_zeroFree_quotient hfM hPM hmatch hfin
  have hQdiff' : Differentiable ℂ
      (toMeromorphicNFOn (fun z => f z / P z) Set.univ) := by
    rw [← hQeq]
    exact hQdiff
  have hQne' : ∀ z, toMeromorphicNFOn (fun z => f z / P z) Set.univ z ≠ 0 := by
    intro z
    rw [← hQeq]
    exact hQne z
  obtain ⟨g, hgdiff, hgce⟩ := exists_differentiable_cexp_univ hQdiff' hQne'
  refine ⟨g, hgdiff, fun z => ?_⟩
  have hid := eq_mul_quotientNF hf hP hP0 hQdiff' z
  rw [hid, hgce z]


/-- The real part of the logarithm is the log of the modulus. -/
theorem re_eq_log_norm_of_cexp {g Q : ℂ → ℂ} (hQ : ∀ z, cexp (g z) = Q z)
    (z : ℂ) : (g z).re = Real.log ‖Q z‖ := by
  rw [← hQ z, Complex.norm_exp, Real.log_exp]

/-- **Affine form of the factorisation**: given `f = P · exp g` and a linear
bound on `Re g`, the exponent is affine. -/
theorem exists_affine_factorization {f P g : ℂ → ℂ} (hg : Differentiable ℂ g)
    (hfac : ∀ z, f z = P z * cexp (g z))
    {A B : ℝ} (hA : 0 ≤ A) (hbound : ∀ z, (g z).re ≤ A * ‖z‖ + B) :
    ∃ a b : ℂ, ∀ z, f z = P z * cexp (a + b * z) := by
  obtain ⟨a, b, hab⟩ := eq_affine_of_re_le_linear hg hA hbound
  refine ⟨a, b, fun z => ?_⟩
  rw [hfac z, hab z]


/-- **Affine exponent from log-growth of the quotient.** -/
theorem exists_affine_factorization_of_log_growth {f P Q g : ℂ → ℂ}
    (hg : Differentiable ℂ g) (hQ : ∀ z, cexp (g z) = Q z)
    (hfac : ∀ z, f z = P z * Q z)
    {A B : ℝ} (hA : 0 ≤ A) (h : ∀ z, Real.log ‖Q z‖ ≤ A * ‖z‖ + B) :
    ∃ a b : ℂ, ∀ z, f z = P z * cexp (a + b * z) := by
  have hbound : ∀ z, (g z).re ≤ A * ‖z‖ + B := by
    intro z
    rw [re_eq_log_norm_of_cexp hQ z]
    exact h z
  obtain ⟨a, b, hab⟩ := eq_affine_of_re_le_linear hg hA hbound
  exact ⟨a, b, fun z => by rw [hfac z, ← hab z, hQ z]⟩


set_option maxHeartbeats 1000000 in
/-- **Order-1 Hadamard factorisation (conditional on the log-growth of the
quotient)**: if the canonical product's divisor matches the finite-order
divisor of `f` and the quotient has at most linear log-growth, then
`f = P · exp (a + bz)`. -/
theorem exists_affine_factorization_of_divisor_match {f : ℂ → ℂ} {a : ℕ → ℂ} {p : ℕ}
    (hf : Differentiable ℂ f) (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt f u = meromorphicOrderAt
      (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt f u ≠ ⊤)
    (hgrowth : ∃ A B : ℝ, 0 ≤ A ∧ ∀ z,
      Real.log ‖toMeromorphicNFOn
        (fun w => f w / (∏' n, weierstrassFactor p (w / a n))) Set.univ z‖
        ≤ A * ‖z‖ + B) :
    ∃ a₀ b₀ : ℂ, ∀ z,
      f z = (∏' n, weierstrassFactor p (z / a n)) * cexp (a₀ + b₀ * z) := by
  set P : ℂ → ℂ := fun z => ∏' n, weierstrassFactor p (z / a n) with hPdef
  have hP : Differentiable ℂ P := differentiable_tprod_weierstrassFactor ha0 hsum
  have hP0 : P 0 = 1 := by
    rw [hPdef]
    exact (hasProd_weierstrassFactor_zero p a).tprod_eq
  have hfM : MeromorphicOn f Set.univ := fun z _ => (hf.analyticAt z).meromorphicAt
  have hPM : MeromorphicOn P Set.univ := fun z _ => (hP.analyticAt z).meromorphicAt
  obtain ⟨Q, hQeq, hQdiff, hQne⟩ :=
    exists_entire_zeroFree_quotient hfM hPM hmatch hfin
  have hQdiff' : Differentiable ℂ
      (toMeromorphicNFOn (fun z => f z / P z) Set.univ) := by
    rw [← hQeq]
    exact hQdiff
  have hQne' : ∀ z, toMeromorphicNFOn (fun z => f z / P z) Set.univ z ≠ 0 := by
    intro z
    rw [← hQeq]
    exact hQne z
  obtain ⟨g, hgdiff, hgce⟩ := exists_differentiable_cexp_univ hQdiff' hQne'
  have hfac : ∀ z, f z = P z * toMeromorphicNFOn (fun w => f w / P w) Set.univ z :=
    fun z => eq_mul_quotientNF hf hP hP0 hQdiff' z
  obtain ⟨A, B, hA, hlog⟩ := hgrowth
  have hlog' : ∀ z, Real.log ‖toMeromorphicNFOn (fun w => f w / P w) Set.univ z‖
      ≤ A * ‖z‖ + B := by
    intro z
    simpa [P] using hlog z
  obtain ⟨a₀, b₀, hab⟩ :=
    exists_affine_factorization_of_log_growth hgdiff hgce hfac hA hlog'
  exact ⟨a₀, b₀, hab⟩


/-- **Order-at-most-one, log-growth form**: `log ‖f z‖ ≤ A‖z‖ + B` with
`A ≥ 0`. -/
def HasLogGrowthOne (f : ℂ → ℂ) : Prop :=
  ∃ A B : ℝ, 0 ≤ A ∧ ∀ z, Real.log ‖f z‖ ≤ A * ‖z‖ + B

/-- A nonzero constant has log-growth at most one. -/
theorem hasLogGrowthOne_const (c : ℂ) : HasLogGrowthOne (fun _ => c) := by
  refine ⟨0, Real.log ‖c‖, le_rfl, fun z => ?_⟩
  simp

/-- The exponential of an affine function has log-growth at most one. -/
theorem hasLogGrowthOne_cexp_affine (a b : ℂ) :
    HasLogGrowthOne (fun z => cexp (a + b * z)) := by
  refine ⟨‖b‖, a.re, norm_nonneg b, fun z => ?_⟩
  rw [← re_eq_log_norm_of_cexp (g := fun z => a + b * z)
    (Q := fun z => cexp (a + b * z)) (fun z => rfl) z]
  calc (a + b * z).re = a.re + (b * z).re := by rw [Complex.add_re]
    _ ≤ a.re + ‖b * z‖ := by
        have := Complex.re_le_norm (b * z)
        linarith
    _ = a.re + ‖b‖ * ‖z‖ := by rw [norm_mul]
    _ = ‖b‖ * ‖z‖ + a.re := by ring


/-- The order-1 Hadamard factorisation with the log-growth hypothesis named. -/
theorem exists_affine_factorization_of_logGrowthOne {f : ℂ → ℂ} {a : ℕ → ℂ} {p : ℕ}
    (hf : Differentiable ℂ f) (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt f u = meromorphicOrderAt
      (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt f u ≠ ⊤)
    (hQ : HasLogGrowthOne (toMeromorphicNFOn
      (fun w => f w / (∏' n, weierstrassFactor p (w / a n))) Set.univ)) :
    ∃ a₀ b₀ : ℂ, ∀ z,
      f z = (∏' n, weierstrassFactor p (z / a n)) * cexp (a₀ + b₀ * z) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  exact exists_affine_factorization_of_divisor_match hf ha0 hsum hmatch hfin
    ⟨A, B, hA, h⟩


/-- Multiplying a zero-free order-1 function by an affine exponential preserves
the order-1 log-growth. -/
theorem hasLogGrowthOne_mul_cexp_affine {Q : ℂ → ℂ} {a b : ℂ}
    (hQne : ∀ z, Q z ≠ 0) (hQ : HasLogGrowthOne Q) :
    HasLogGrowthOne (fun z => Q z * cexp (a + b * z)) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  refine ⟨A + ‖b‖, B + a.re, by positivity, fun z => ?_⟩
  rw [norm_mul, Real.log_mul (norm_ne_zero_iff.mpr (hQne z)) (norm_ne_zero_iff.mpr (Complex.exp_ne_zero _)),
    Complex.norm_exp, Real.log_exp]
  have h3 : (a + b * z).re ≤ a.re + ‖b‖ * ‖z‖ := by
    rw [Complex.add_re]
    have := Complex.re_le_norm (b * z)
    rw [norm_mul] at this
    linarith
  have := h z
  linarith


/-- If `Re g` has linear growth, then `exp g` has order-1 log-growth. -/
theorem hasLogGrowthOne_cexp_of_re_le {g : ℂ → ℂ} {A B : ℝ} (hA : 0 ≤ A)
    (h : ∀ z, (g z).re ≤ A * ‖z‖ + B) :
    HasLogGrowthOne (fun z => cexp (g z)) := by
  refine ⟨A, B, hA, fun z => ?_⟩
  rw [Complex.norm_exp, Real.log_exp]
  exact h z

/-- The product of two zero-free order-1 functions has order-1 log-growth. -/
theorem hasLogGrowthOne_mul {Q R : ℂ → ℂ} (hQne : ∀ z, Q z ≠ 0)
    (hRne : ∀ z, R z ≠ 0) (hQ : HasLogGrowthOne Q) (hR : HasLogGrowthOne R) :
    HasLogGrowthOne (fun z => Q z * R z) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  obtain ⟨A', B', hA', h'⟩ := hR
  refine ⟨A + A', B + B', by positivity, fun z => ?_⟩
  rw [norm_mul, Real.log_mul (norm_ne_zero_iff.mpr (hQne z)) (norm_ne_zero_iff.mpr (hRne z))]
  have h1 := h z
  have h2 := h' z
  linarith


/-- A finite product of zero-free order-1 functions is order-1. -/
theorem hasLogGrowthOne_finset_prod {ι : Type*} (s : Finset ι) (Q : ι → ℂ → ℂ)
    (hne : ∀ i ∈ s, ∀ z, Q i z ≠ 0)
    (h : ∀ i ∈ s, HasLogGrowthOne (Q i)) :
    HasLogGrowthOne (fun z => ∏ i ∈ s, Q i z) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
    have h1 : (fun z : ℂ => ∏ i ∈ (∅ : Finset ι), Q i z) = fun _ => (1 : ℂ) := by
      funext z
      simp
    rw [h1]
    exact hasLogGrowthOne_const 1
  | insert a s ha ih =>
    have hprod : (fun z : ℂ => ∏ i ∈ insert a s, Q i z)
        = fun z => Q a z * (∏ i ∈ s, Q i z) := by
      funext z
      rw [Finset.prod_insert ha]
    rw [hprod]
    apply hasLogGrowthOne_mul
    · intro z
      exact hne a (Finset.mem_insert_self a s) z
    · intro z
      exact Finset.prod_ne_zero_iff.mpr
        (fun i hi => hne i (Finset.mem_insert_of_mem hi) z)
    · exact h a (Finset.mem_insert_self a s)
    · exact ih (fun i hi => hne i (Finset.mem_insert_of_mem hi))
        (fun i hi => h i (Finset.mem_insert_of_mem hi))


/-- The identity function has order-1 log-growth. -/
theorem hasLogGrowthOne_id : HasLogGrowthOne (fun z : ℂ => z) := by
  refine ⟨1, 0, zero_le_one, fun z => ?_⟩
  have := Real.log_le_self (norm_nonneg z)
  simpa using this


/-- Affine functions have order-1 log-growth. -/
theorem hasLogGrowthOne_affine (a b : ℂ) :
    HasLogGrowthOne (fun z => a + b * z) := by
  set C := ‖a‖ + ‖b‖ + 1 with hCdef
  have hC : 0 < C := by positivity
  refine ⟨1, max (Real.log C) 0, zero_le_one, fun z => ?_⟩
  by_cases hz : a + b * z = 0
  · rw [show Real.log ‖a + b * z‖ = 0 by simp [hz]]
    have h1 : (0 : ℝ) ≤ max (Real.log C) 0 := le_max_right _ _
    have h2 : (0 : ℝ) ≤ ‖z‖ := norm_nonneg z
    linarith
  · have hpos : 0 < ‖a + b * z‖ := norm_pos_iff.mpr hz
    have hnorm : ‖a + b * z‖ ≤ C * (1 + ‖z‖) := by
      calc ‖a + b * z‖ ≤ ‖a‖ + ‖b * z‖ := norm_add_le _ _
        _ = ‖a‖ + ‖b‖ * ‖z‖ := by rw [norm_mul]
        _ ≤ C * (1 + ‖z‖) := by
            have h1 : ‖a‖ ≤ C := by rw [hCdef]; linarith [norm_nonneg b]
            have h2 : ‖b‖ * ‖z‖ ≤ C * ‖z‖ :=
              mul_le_mul_of_nonneg_right (by rw [hCdef]; linarith [norm_nonneg a]) (norm_nonneg z)
            nlinarith
    have hlog_le : Real.log ‖a + b * z‖ ≤ Real.log C + Real.log (1 + ‖z‖) := by
      rw [← Real.log_mul (ne_of_gt hC) (ne_of_gt (by positivity : (0:ℝ) < 1 + ‖z‖))]
      exact Real.log_le_log hpos hnorm
    have hlog1 : Real.log (1 + ‖z‖) ≤ ‖z‖ := by
      have := Real.log_le_sub_one_of_pos (by positivity : (0 : ℝ) < 1 + ‖z‖)
      linarith
    have hlogC : Real.log C ≤ max (Real.log C) 0 := le_max_left _ _
    linarith


set_option maxHeartbeats 1000000 in
/-- **Borel–Carathéodory, linear bound**: if `Re g(z) ≤ A‖z‖+B`, then
`‖g z‖ ≤ C(1 + ‖z‖)`. -/
theorem exists_norm_le_of_re_le_linear {g : ℂ → ℂ} (hg : Differentiable ℂ g)
    {A B : ℝ} (hA : 0 ≤ A) (h : ∀ z, (g z).re ≤ A * ‖z‖ + B) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ z, ‖g z‖ ≤ C * (1 + ‖z‖) := by
  refine ⟨4 * A + 2 * |B| + 2 + 3 * ‖g 0‖, by positivity, fun z => ?_⟩
  set r := ‖z‖ with hr
  have hr0 : 0 ≤ r := norm_nonneg z
  set R := 2 * (1 + r) with hRdef
  have hR : 0 < R := by positivity
  set M := max (A * R + B) 1 with hMdef
  have hM : 0 < M := lt_of_lt_of_le zero_lt_one (le_max_right _ _)
  have hmaps : Set.MapsTo g (Metric.ball (0 : ℂ) R) {w | w.re ≤ M} := by
    intro w hw
    have hwr : ‖w‖ < R := by
      have := Metric.mem_ball.mp hw
      simpa [dist_eq_norm] using this
    have h1 : A * ‖w‖ ≤ A * R := mul_le_mul_of_nonneg_left (le_of_lt hwr) hA
    calc (g w).re ≤ A * ‖w‖ + B := h w
      _ ≤ A * R + B := by linarith
      _ ≤ M := le_max_left _ _
  have hzball : z ∈ Metric.ball (0 : ℂ) R := by
    rw [Metric.mem_ball, dist_eq_norm]
    have : r < R := by rw [hRdef]; nlinarith
    simpa using this
  have hBC := Complex.borelCaratheodory hM hg.differentiableOn hmaps hR hzball
  have hden : R - r = 2 + r := by rw [hRdef]; ring
  have h1 : 2 * M * r / (R - r) ≤ 2 * M := by
    rw [hden, div_le_iff₀ (by linarith)]
    nlinarith [hM.le, mul_nonneg hM.le hr0]
  have h2 : (R + r) / (R - r) ≤ 3 := by
    rw [hden, hRdef, div_le_iff₀ (by linarith)]
    have : (0:ℝ) ≤ r := hr0
    nlinarith
  have hg0 : 0 ≤ ‖g 0‖ := norm_nonneg _
  have h4 : ‖g z‖ ≤ 2 * M + 3 * ‖g 0‖ := by
    have h2' : ‖g 0‖ * (R + r) / (R - r) ≤ 3 * ‖g 0‖ := by
      rw [show ‖g 0‖ * (R + r) / (R - r) = ‖g 0‖ * ((R + r) / (R - r)) by ring]
      have := mul_le_mul_of_nonneg_left h2 hg0
      linarith
    calc ‖g z‖ ≤ 2 * M * r / (R - r) + ‖g 0‖ * (R + r) / (R - r) := hBC
      _ ≤ 2 * M + 3 * ‖g 0‖ := by linarith
  have hMle : M ≤ (2 * A + |B| + 1) * (1 + r) := by
    rw [hMdef]
    apply max_le
    · have h1 : A * R + B ≤ A * (2 * (1 + r)) + |B| := by
        rw [hRdef]
        nlinarith [le_abs_self B]
      have h2 : A * (2 * (1 + r)) + |B| ≤ (2 * A + |B| + 1) * (1 + r) := by
        have : (0:ℝ) ≤ 1 + r := by linarith
        have hab : (0:ℝ) ≤ |B| := abs_nonneg B
        nlinarith
      linarith
    · have : (1:ℝ) ≤ 1 + r := by linarith
      have hab : (0:ℝ) ≤ |B| := abs_nonneg B
      nlinarith [hA]
  have hC : 2 * M + 3 * ‖g 0‖ ≤ (4 * A + 2 * |B| + 2 + 3 * ‖g 0‖) * (1 + r) := by
    have hbase : (1:ℝ) ≤ 1 + r := by linarith
    have h1 : 2 * M ≤ 2 * ((2 * A + |B| + 1) * (1 + r)) := by linarith
    have h2 : 3 * ‖g 0‖ ≤ 3 * ‖g 0‖ * (1 + r) := by
      have := mul_le_mul_of_nonneg_left hbase (by positivity : (0:ℝ) ≤ 3 * ‖g 0‖)
      linarith
    nlinarith
  linarith


/-- **Zero-free entire functions of order at most one are affine
exponentials**: `Q = exp (a + bz)`. -/
theorem exists_affine_cexp_of_zeroFree_logGrowth {Q : ℂ → ℂ}
    (hQ : Differentiable ℂ Q) (hne : ∀ z, Q z ≠ 0) (h : HasLogGrowthOne Q) :
    ∃ a b : ℂ, ∀ z, Q z = cexp (a + b * z) := by
  obtain ⟨A, B, hA, hlog⟩ := h
  obtain ⟨g, hg, hgce⟩ := exists_differentiable_cexp_univ hQ hne
  have hbound : ∀ z, (g z).re ≤ A * ‖z‖ + B := by
    intro z
    rw [re_eq_log_norm_of_cexp hgce z]
    exact hlog z
  obtain ⟨a, b, hab⟩ := eq_affine_of_re_le_linear hg hA hbound
  exact ⟨a, b, fun z => by rw [← hgce z, hab z]⟩


/-- **Affine factorisation from a zero-free order-1 quotient**: if
`f = P · Q` with `Q` entire, zero-free and order-1, then
`f = P · exp (a + bz)`. -/
theorem exists_affine_factorization_of_zeroFree_quotient {f P Q : ℂ → ℂ}
    (hQ : Differentiable ℂ Q) (hQne : ∀ z, Q z ≠ 0) (hlog : HasLogGrowthOne Q)
    (hfac : ∀ z, f z = P z * Q z) :
    ∃ a b : ℂ, ∀ z, f z = P z * cexp (a + b * z) := by
  obtain ⟨a, b, hab⟩ := exists_affine_cexp_of_zeroFree_logGrowth hQ hQne hlog
  exact ⟨a, b, fun z => by rw [hfac z, hab z]⟩


/-- Every power `z ↦ z^n` has order-1 log-growth. -/
theorem hasLogGrowthOne_pow (n : ℕ) :
    HasLogGrowthOne (fun z : ℂ => z ^ n) := by
  refine ⟨(n : ℝ), 0, by positivity, fun z => ?_⟩
  rw [norm_pow, Real.log_pow]
  have h := Real.log_le_self (norm_nonneg z)
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  nlinarith


/-- Multiplying an order-1 function by a nonzero constant preserves the
property (the constant is absorbed into `B`, with a `max` to handle zeros). -/
theorem hasLogGrowthOne_const_mul {Q : ℂ → ℂ} (c : ℂ) (hc : c ≠ 0)
    (hQ : HasLogGrowthOne Q) :
    HasLogGrowthOne (fun z => c * Q z) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  refine ⟨A, max (B + Real.log ‖c‖) 0, hA, fun z => ?_⟩
  by_cases hz : Q z = 0
  · simp [hz]
    have h1 : (0 : ℝ) ≤ max (B + Real.log ‖c‖) 0 := le_max_right _ _
    have h2 : (0 : ℝ) ≤ A * ‖z‖ := mul_nonneg hA (norm_nonneg z)
    linarith
  · rw [norm_mul, Real.log_mul (norm_ne_zero_iff.mpr hc) (norm_ne_zero_iff.mpr hz)]
    have hzle := h z
    have hmax : B + Real.log ‖c‖ ≤ max (B + Real.log ‖c‖) 0 := le_max_left _ _
    linarith


/-- The sum of two zero-free order-1 functions (itself zero-free) is order-1. -/
theorem hasLogGrowthOne_add_of_ne_zero {Q R : ℂ → ℂ}
    (hQne : ∀ z, Q z ≠ 0) (hRne : ∀ z, R z ≠ 0)
    (hsumne : ∀ z, Q z + R z ≠ 0)
    (hQ : HasLogGrowthOne Q) (hR : HasLogGrowthOne R) :
    HasLogGrowthOne (fun z => Q z + R z) := by
  obtain ⟨A1, B1, hA1, h1⟩ := hQ
  obtain ⟨A2, B2, hA2, h2⟩ := hR
  refine ⟨max A1 A2, max B1 B2 + Real.log 2, ?_, fun z => ?_⟩
  · exact le_trans hA1 (le_max_left A1 A2)
  · have hpos : 0 < ‖Q z + R z‖ := norm_pos_iff.mpr (hsumne z)
    have hsum : ‖Q z + R z‖ ≤ 2 * max ‖Q z‖ ‖R z‖ := by
      have h1' : ‖Q z‖ ≤ max ‖Q z‖ ‖R z‖ := le_max_left _ _
      have h2' : ‖R z‖ ≤ max ‖Q z‖ ‖R z‖ := le_max_right _ _
      calc ‖Q z + R z‖ ≤ ‖Q z‖ + ‖R z‖ := norm_add_le _ _
        _ ≤ 2 * max ‖Q z‖ ‖R z‖ := by linarith
    have hMpos : 0 < max ‖Q z‖ ‖R z‖ :=
      lt_of_lt_of_le (norm_pos_iff.mpr (hQne z)) (le_max_left _ _)
    have hlog : Real.log ‖Q z + R z‖ ≤ Real.log 2 + Real.log (max ‖Q z‖ ‖R z‖) := by
      rw [← Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) (ne_of_gt hMpos)]
      exact Real.log_le_log hpos hsum
    have hlogmax : Real.log (max ‖Q z‖ ‖R z‖)
        ≤ max (Real.log ‖Q z‖) (Real.log ‖R z‖) := by
      rcases le_total ‖Q z‖ ‖R z‖ with h | h
      · rw [max_eq_right h, max_eq_right (Real.log_le_log (norm_pos_iff.mpr (hQne z)) h)]
      · rw [max_eq_left h, max_eq_left (Real.log_le_log (norm_pos_iff.mpr (hRne z)) h)]
    have hb1 : Real.log ‖Q z‖ ≤ max A1 A2 * ‖z‖ + max B1 B2 := by
      have h := h1 z
      have hA : A1 ≤ max A1 A2 := le_max_left A1 A2
      have hB : B1 ≤ max B1 B2 := le_max_left B1 B2
      nlinarith [norm_nonneg z]
    have hb2 : Real.log ‖R z‖ ≤ max A1 A2 * ‖z‖ + max B1 B2 := by
      have h := h2 z
      have hA : A2 ≤ max A1 A2 := le_max_right A1 A2
      have hB : B2 ≤ max B1 B2 := le_max_right B1 B2
      nlinarith [norm_nonneg z]
    have hmaxb : max (Real.log ‖Q z‖) (Real.log ‖R z‖)
        ≤ max A1 A2 * ‖z‖ + max B1 B2 := max_le hb1 hb2
    linarith


/-- Affine reparametrisation preserves order-1 log-growth. -/
theorem hasLogGrowthOne_comp_affine {Q : ℂ → ℂ} (hQ : HasLogGrowthOne Q)
    (a b : ℂ) :
    HasLogGrowthOne (fun z => Q (a + b * z)) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  refine ⟨A * ‖b‖, B + A * ‖a‖, mul_nonneg hA (norm_nonneg b), fun z => ?_⟩
  have hz : ‖a + b * z‖ ≤ ‖a‖ + ‖b‖ * ‖z‖ := by
    calc ‖a + b * z‖ ≤ ‖a‖ + ‖b * z‖ := norm_add_le _ _
      _ = ‖a‖ + ‖b‖ * ‖z‖ := by rw [norm_mul]
  have hAz : A * ‖a + b * z‖ ≤ A * (‖a‖ + ‖b‖ * ‖z‖) :=
    mul_le_mul_of_nonneg_left hz hA
  have h := h (a + b * z)
  nlinarith [norm_nonneg z]


/-- Order-1 log-growth with a nonnegative constant, which makes the property
closed under products without zero-freeness. -/
def HasLogGrowthOneNonneg (f : ℂ → ℂ) : Prop :=
  ∃ A B : ℝ, 0 ≤ A ∧ 0 ≤ B ∧ ∀ z, Real.log ‖f z‖ ≤ A * ‖z‖ + B

/-- Every `HasLogGrowthOne` function is `HasLogGrowthOneNonneg` (replace `B` by
`max B 0`). -/
theorem HasLogGrowthOne.toNonneg {f : ℂ → ℂ} (h : HasLogGrowthOne f) :
    HasLogGrowthOneNonneg f := by
  obtain ⟨A, B, hA, h⟩ := h
  refine ⟨A, max B 0, hA, le_max_right B 0, fun z => ?_⟩
  have hB : B ≤ max B 0 := le_max_left B 0
  have := h z
  linarith

/-- The product of two `HasLogGrowthOneNonneg` functions is
`HasLogGrowthOneNonneg` (zeros are harmless because `B ≥ 0`). -/
theorem HasLogGrowthOneNonneg.mul {Q R : ℂ → ℂ}
    (hQ : HasLogGrowthOneNonneg Q) (hR : HasLogGrowthOneNonneg R) :
    HasLogGrowthOneNonneg (fun z => Q z * R z) := by
  obtain ⟨A1, B1, hA1, hB1, h1⟩ := hQ
  obtain ⟨A2, B2, hA2, hB2, h2⟩ := hR
  refine ⟨A1 + A2, B1 + B2, by positivity, by positivity, fun z => ?_⟩
  by_cases hzQ : Q z = 0
  · have hzero : ‖Q z * R z‖ = 0 := by simp [hzQ]
    rw [hzero]
    have h1' : (0 : ℝ) ≤ (A1 + A2) * ‖z‖ + (B1 + B2) := by
      have := norm_nonneg z
      positivity
    simpa using h1'
  · by_cases hzR : R z = 0
    · have hzero : ‖Q z * R z‖ = 0 := by simp [hzR]
      rw [hzero]
      have h1' : (0 : ℝ) ≤ (A1 + A2) * ‖z‖ + (B1 + B2) := by
        have := norm_nonneg z
        positivity
      simpa using h1'
    · rw [norm_mul, Real.log_mul (norm_ne_zero_iff.mpr hzQ) (norm_ne_zero_iff.mpr hzR)]
      have h1' := h1 z
      have h2' := h2 z
      linarith


/-- `HasLogGrowthOneNonneg` implies `HasLogGrowthOne`. -/
theorem HasLogGrowthOneNonneg.toHasLogGrowthOne {f : ℂ → ℂ}
    (h : HasLogGrowthOneNonneg f) : HasLogGrowthOne f := by
  obtain ⟨A, B, hA, _, h⟩ := h
  exact ⟨A, B, hA, h⟩

/-- Finite products of `HasLogGrowthOneNonneg` functions are
`HasLogGrowthOneNonneg`. -/
theorem HasLogGrowthOneNonneg.finset_prod {ι : Type*} (s : Finset ι)
    (Q : ι → ℂ → ℂ) (h : ∀ i ∈ s, HasLogGrowthOneNonneg (Q i)) :
    HasLogGrowthOneNonneg (fun z => ∏ i ∈ s, Q i z) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
    have h1 : (fun z : ℂ => ∏ i ∈ (∅ : Finset ι), Q i z) = fun _ => (1 : ℂ) := by
      funext z
      simp
    rw [h1]
    exact (hasLogGrowthOne_const 1).toNonneg
  | insert a s ha ih =>
    have hprod : (fun z : ℂ => ∏ i ∈ insert a s, Q i z)
        = fun z => Q a z * (∏ i ∈ s, Q i z) := by
      funext z
      rw [Finset.prod_insert ha]
    rw [hprod]
    exact (h a (Finset.mem_insert_self a s)).mul
      (ih (fun i hi => h i (Finset.mem_insert_of_mem hi)))

/-- **The genus-0 finite canonical product is order-1**: a finite product of
linear factors. -/
theorem hasLogGrowthOne_finiteCanonicalProduct_zero (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) :
    HasLogGrowthOne (finiteCanonicalProduct 0 S) := by
  have hfac : ∀ w ∈ S, HasLogGrowthOneNonneg
      (fun z : ℂ => weierstrassFactor 0 (z / w)) := by
    intro w hw
    have hw0 : w ≠ 0 := fun h => h0 (h ▸ hw)
    have hfun : (fun z : ℂ => weierstrassFactor 0 (z / w))
        = fun z => 1 + (-(w⁻¹)) * z := by
      funext z
      simp [weierstrassFactor, div_eq_mul_inv]
      ring
    rw [hfun]
    exact (hasLogGrowthOne_affine 1 (-(w⁻¹))).toNonneg
  have hprod := HasLogGrowthOneNonneg.finset_prod S
    (fun w z => weierstrassFactor 0 (z / w)) hfac
  exact hprod.toHasLogGrowthOne


/-- Powers of an order-1 function are order-1. -/
theorem HasLogGrowthOne.pow {Q : ℂ → ℂ} (hQ : HasLogGrowthOne Q) (n : ℕ) :
    HasLogGrowthOne (fun z => Q z ^ n) := by
  obtain ⟨A, B, hA, h⟩ := hQ
  refine ⟨(n : ℝ) * A, (n : ℝ) * B, by positivity, fun z => ?_⟩
  rw [norm_pow, Real.log_pow]
  have hz := h z
  have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  nlinarith


/-- Dividing an order-1 function by a bounded-below function preserves the
property. -/
theorem hasLogGrowthOne_div_of_lower_bound {R Q : ℂ → ℂ} {c : ℝ} (hc : 0 < c)
    (hQlb : ∀ z, c ≤ ‖Q z‖) (hR : HasLogGrowthOne R) :
    HasLogGrowthOne (fun z => R z / Q z) := by
  obtain ⟨A, B, hA, h⟩ := hR
  refine ⟨A, max (B - Real.log c) 0, hA, fun z => ?_⟩
  have hQpos : 0 < ‖Q z‖ := lt_of_lt_of_le hc (hQlb z)
  by_cases hzR : R z = 0
  · have hzero : ‖R z / Q z‖ = 0 := by simp [hzR]
    rw [hzero, Real.log_zero]
    have h1 : (0 : ℝ) ≤ max (B - Real.log c) 0 := le_max_right _ _
    have h2 : (0 : ℝ) ≤ A * ‖z‖ := mul_nonneg hA (norm_nonneg z)
    linarith
  · rw [norm_div, Real.log_div (norm_ne_zero_iff.mpr hzR) (ne_of_gt hQpos)]
    have hRle := h z
    have hQlog : Real.log c ≤ Real.log ‖Q z‖ := Real.log_le_log hc (hQlb z)
    have hmax : B - Real.log c ≤ max (B - Real.log c) 0 := le_max_left _ _
    linarith


/-- Adding a constant preserves order-1 log-growth. -/
theorem hasLogGrowthOne_add_const {Q : ℂ → ℂ} (hQ : HasLogGrowthOne Q) (c : ℂ) :
    HasLogGrowthOne (fun z => Q z + c) := by
  by_cases hc : c = 0
  · simpa [hc] using hQ
  · obtain ⟨A, B, hA, _hB, h⟩ := hQ.toNonneg
    refine ⟨A, max B (Real.log ‖c‖) + Real.log 2, hA, fun z => ?_⟩
    by_cases hz : Q z + c = 0
    · rw [show Real.log ‖Q z + c‖ = 0 by simp [hz]]
      have h1 : (0 : ℝ) ≤ max B (Real.log ‖c‖) + Real.log 2 := by
        have hB' := le_max_left B (Real.log ‖c‖)
        have hlog2 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
        linarith
      have h2 : (0 : ℝ) ≤ A * ‖z‖ := mul_nonneg hA (norm_nonneg z)
      linarith
    · have hpos : 0 < ‖Q z + c‖ := norm_pos_iff.mpr hz
      have hsum : ‖Q z + c‖ ≤ 2 * max ‖Q z‖ ‖c‖ := by
        have h1 : ‖Q z‖ ≤ max ‖Q z‖ ‖c‖ := le_max_left _ _
        have h2 : ‖c‖ ≤ max ‖Q z‖ ‖c‖ := le_max_right _ _
        calc ‖Q z + c‖ ≤ ‖Q z‖ + ‖c‖ := norm_add_le _ _
          _ ≤ 2 * max ‖Q z‖ ‖c‖ := by linarith
      have hMpos : 0 < max ‖Q z‖ ‖c‖ :=
        lt_of_lt_of_le (norm_pos_iff.mpr hc) (le_max_right _ _)
      have hlog : Real.log ‖Q z + c‖
          ≤ Real.log 2 + Real.log (max ‖Q z‖ ‖c‖) := by
        rw [← Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) (ne_of_gt hMpos)]
        exact Real.log_le_log hpos hsum
      have hlogmax : Real.log (max ‖Q z‖ ‖c‖)
          ≤ max (Real.log ‖Q z‖) (Real.log ‖c‖) := by
        have hMpos' : 0 < max ‖Q z‖ ‖c‖ := hMpos
        have hexp : max ‖Q z‖ ‖c‖
            ≤ Real.exp (max (Real.log ‖Q z‖) (Real.log ‖c‖)) := by
          apply max_le
          · by_cases h0 : ‖Q z‖ = 0
            · rw [h0]
              positivity
            · have hlt : 0 < ‖Q z‖ := lt_of_le_of_ne (norm_nonneg (Q z)) (Ne.symm h0)
              calc ‖Q z‖ = Real.exp (Real.log ‖Q z‖) :=
                    (Real.exp_log hlt).symm
                _ ≤ Real.exp (max (Real.log ‖Q z‖) (Real.log ‖c‖)) :=
                    Real.exp_le_exp.mpr (le_max_left _ _)
          · by_cases h0 : ‖c‖ = 0
            · rw [h0]
              positivity
            · have hlt : 0 < ‖c‖ := lt_of_le_of_ne (norm_nonneg c) (Ne.symm h0)
              calc ‖c‖ = Real.exp (Real.log ‖c‖) :=
                    (Real.exp_log hlt).symm
                _ ≤ Real.exp (max (Real.log ‖Q z‖) (Real.log ‖c‖)) :=
                    Real.exp_le_exp.mpr (le_max_right _ _)
        have := Real.log_le_log hMpos' hexp
        rwa [Real.log_exp] at this
      have hQle : Real.log ‖Q z‖ ≤ A * ‖z‖ + max B (Real.log ‖c‖) := by
        have hQz := h z
        have hBle : B ≤ max B (Real.log ‖c‖) := le_max_left B (Real.log ‖c‖)
        linarith
      have hCle : Real.log ‖c‖ ≤ A * ‖z‖ + max B (Real.log ‖c‖) := by
        have hBle : Real.log ‖c‖ ≤ max B (Real.log ‖c‖) := le_max_right B (Real.log ‖c‖)
        have hAz : 0 ≤ A * ‖z‖ := mul_nonneg hA (norm_nonneg z)
        linarith
      have hmaxb : max (Real.log ‖Q z‖) (Real.log ‖c‖)
          ≤ A * ‖z‖ + max B (Real.log ‖c‖) := max_le hQle hCle
      linarith


/-- Constants times genus-0 finite canonical products are order-1. -/
theorem hasLogGrowthOne_const_mul_finiteCanonicalProduct_zero (c : ℂ)
    (S : Finset ℂ) (h0 : (0 : ℂ) ∉ S) :
    HasLogGrowthOne (fun z => c * finiteCanonicalProduct 0 S z) := by
  by_cases hc : c = 0
  · subst hc
    refine ⟨0, 0, le_rfl, fun z => ?_⟩
    simp
  · exact hasLogGrowthOne_const_mul c hc
      (hasLogGrowthOne_finiteCanonicalProduct_zero S h0)


/-- Transport of `HasLogGrowthOne` along a pointwise equality. -/
theorem HasLogGrowthOne.congr {f g : ℂ → ℂ} (h : HasLogGrowthOne f)
    (hfg : ∀ z, f z = g z) : HasLogGrowthOne g := by
  obtain ⟨A, B, hA, h⟩ := h
  exact ⟨A, B, hA, fun z => by rw [← hfg z]; exact h z⟩

/-- A multiset product of linear factors `z ↦ z - a` has order-1 log-growth. -/
theorem multiset_prod_linear_hasLogGrowthOneNonneg (S : Multiset ℂ) :
    HasLogGrowthOneNonneg (fun z => (S.map (fun r => z - r)).prod) := by
  induction S using Multiset.induction_on with
  | empty =>
    have h1 : (fun z : ℂ => (Multiset.map (fun r => z - r) (0 : Multiset ℂ)).prod)
        = fun _ => (1 : ℂ) := by
      funext z
      simp
    rw [h1]
    exact (hasLogGrowthOne_const 1).toNonneg
  | cons a s ih =>
    have hfun : (fun z : ℂ => ((a ::ₘ s).map (fun r => z - r)).prod)
        = fun z => (z - a) * (s.map (fun r => z - r)).prod := by
      funext z
      simp
    rw [hfun]
    have haff : HasLogGrowthOneNonneg (fun z : ℂ => z - a) := by
      have h0 : HasLogGrowthOneNonneg (fun z : ℂ => (-a) + 1 * z) :=
        (hasLogGrowthOne_affine (-a) 1).toNonneg
      have hfun2 : (fun z : ℂ => z - a) = fun z => (-a) + 1 * z := by
        funext z
        ring
      rw [hfun2]
      exact h0
    exact haff.mul ih

/-- **Every complex polynomial has order-1 log-growth.** -/
theorem polynomial_hasLogGrowthOne (P : Polynomial ℂ) :
    HasLogGrowthOne (fun z => P.eval z) := by
  by_cases hP : P = 0
  · subst hP
    refine ⟨0, 0, le_rfl, fun z => ?_⟩
    simp
  · have hroots : P.roots.card = P.natDegree :=
      Polynomial.splits_iff_card_roots.mp (IsAlgClosed.splits P)
    have hfac := Polynomial.C_leadingCoeff_mul_prod_multiset_X_sub_C hroots
    have heval : ∀ z, P.eval z
        = P.leadingCoeff * (P.roots.map (fun r => z - r)).prod := by
      intro z
      have := congrArg (Polynomial.eval z) hfac
      simpa [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_multiset_prod,
        Polynomial.eval_sub, Polynomial.eval_X] using this.symm
    have hprod : HasLogGrowthOne
        (fun z => (P.roots.map (fun r => z - r)).prod) :=
      (multiset_prod_linear_hasLogGrowthOneNonneg P.roots).toHasLogGrowthOne
    have hlc : P.leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr hP
    have hfinal : HasLogGrowthOne
        (fun z => P.leadingCoeff * (P.roots.map (fun r => z - r)).prod) :=
      hasLogGrowthOne_const_mul P.leadingCoeff hlc hprod
    exact hfinal.congr (fun z => (heval z).symm)


/-- A polynomial times an affine exponential is order-1. -/
theorem polynomial_mul_cexp_affine_hasLogGrowthOne (P : Polynomial ℂ) (a b : ℂ) :
    HasLogGrowthOne (fun z => P.eval z * cexp (a + b * z)) := by
  have hP : HasLogGrowthOneNonneg (fun z => P.eval z) :=
    (polynomial_hasLogGrowthOne P).toNonneg
  have hE : HasLogGrowthOneNonneg (fun z => cexp (a + b * z)) :=
    (hasLogGrowthOne_cexp_affine a b).toNonneg
  exact (hP.mul hE).toHasLogGrowthOne


/-- Transport of `HasLogGrowthOneNonneg` along a pointwise equality. -/
theorem HasLogGrowthOneNonneg.congr {f g : ℂ → ℂ} (h : HasLogGrowthOneNonneg f)
    (hfg : ∀ z, f z = g z) : HasLogGrowthOneNonneg g := by
  obtain ⟨A, B, hA, hB, h⟩ := h
  exact ⟨A, B, hA, hB, fun z => by rw [← hfg z]; exact h z⟩

/-- **The genus-1 finite canonical product is order-1**: each factor is
`(1 - z/w)·exp(z/w)`, a product of an affine function and an affine
exponential. -/
theorem hasLogGrowthOne_finiteCanonicalProduct_one (S : Finset ℂ)
    (h0 : (0 : ℂ) ∉ S) :
    HasLogGrowthOne (finiteCanonicalProduct 1 S) := by
  have hfac : ∀ w ∈ S, HasLogGrowthOneNonneg
      (fun z : ℂ => weierstrassFactor 1 (z / w)) := by
    intro w hw
    have hw0 : w ≠ 0 := fun h => h0 (h ▸ hw)
    have hfun : (fun z : ℂ => weierstrassFactor 1 (z / w))
        = fun z => (1 - z / w) * cexp (z / w) := by
      funext z
      rw [weierstrassFactor]
      simp
    rw [hfun]
    have h1 : HasLogGrowthOneNonneg (fun z : ℂ => 1 - z / w) := by
      have h := (hasLogGrowthOne_affine 1 (-(w⁻¹))).toNonneg
      exact h.congr (by
        intro z
        rw [div_eq_mul_inv]
        ring)
    have h2 : HasLogGrowthOneNonneg (fun z : ℂ => cexp (z / w)) := by
      have h := (hasLogGrowthOne_cexp_affine 0 (w⁻¹)).toNonneg
      exact h.congr (by
        intro z
        congr 1
        rw [div_eq_mul_inv]
        ring)
    exact h1.mul h2
  have hprod := HasLogGrowthOneNonneg.finset_prod S
    (fun w z => weierstrassFactor 1 (z / w)) hfac
  exact hprod.toHasLogGrowthOne

end AbsoluteHodgeHadamard














































































