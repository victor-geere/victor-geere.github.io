import Mathlib
import Symbol

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



/-- The **entire completed zeta with the correct zeros**:
`ξ₀(s) = s(s−1)·Λ₀(s) + 1`, where `Λ₀ = completedRiemannZeta₀` is Mathlib's
entire model. Away from the junk points `0, 1` it equals `s(s−1)·Λ(s)`, so its
zeros are exactly the nontrivial zeros of `ζ`. (The literal function
`s ↦ s(s−1)Λ(s)` is *not* entire in Lean's total-function semantics: its junk
values at the poles are `0`, while the limit is `1`.) -/
noncomputable def xi₀ (s : ℂ) : ℂ := s * (s - 1) * completedRiemannZeta₀ s + 1

/-- `ξ₀` is entire. -/
theorem differentiable_xi₀ : Differentiable ℂ xi₀ := by
  unfold xi₀
  exact ((differentiable_id.mul (differentiable_id.sub (differentiable_const 1))).mul
    differentiable_completedZeta₀).add (differentiable_const 1)

/-- Away from `0` and `1`, `ξ₀` is `s(s−1)·Λ(s)`. -/
theorem xi₀_eq_weighted (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    xi₀ s = s * (s - 1) * completedRiemannZeta s := by
  unfold xi₀
  rw [completedRiemannZeta_eq]
  field_simp
  ring

/-- **The Hadamard factorisation of `ξ₀`, conditionally on its zero data.** If the
zeros of `ξ₀` are enumerated by `a` with the canonical-product divisor match,
the summability condition and the log-growth-one condition, then
`ξ₀(z) = ∏_n E_p(z/a_n)·e^{a₀+b₀z}`. -/
theorem factorization_of_xi₀ (a : ℕ → ℂ) (p : ℕ)
    (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt xi₀ u
      = meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt xi₀ u ≠ ⊤)
    (hQ : HasLogGrowthOne (toMeromorphicNFOn
      (fun w : ℂ => xi₀ w / (∏' n, weierstrassFactor p (w / a n))) Set.univ)) :
    ∃ a₀ b₀ : ℂ, ∀ z,
      xi₀ z = (∏' n, weierstrassFactor p (z / a n)) * cexp (a₀ + b₀ * z) :=
  exists_affine_factorization_of_logGrowthOne
    (f := xi₀) differentiable_xi₀ ha0 hsum hmatch hfin hQ


/-- **`ξ₀` has exactly the nontrivial zeros of `Λ`**: away from `0, 1`,
`ξ₀(s) = 0 ↔ Λ(s) = 0`. -/
theorem xi₀_eq_zero_iff (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    xi₀ s = 0 ↔ completedRiemannZeta s = 0 := by
  rw [xi₀_eq_weighted s hs0 hs1]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h' | h'
    · exact absurd h' (mul_ne_zero hs0 (sub_ne_zero.mpr hs1))
    · exact h'
  · intro h
    rw [h, mul_zero]

open Filter in
open scoped Topology in
/-- **Logarithmic derivative of `Λ` as a sum over the zeros.**

Given a zero sequence `a` with the Hadamard data assumed by
`factorization_of_xi₀`, at a point `x` off `{0, 1}` and off the zero set,
the logarithmic derivative of the completed zeta function splits as a
constant (the linear coefficient `b₀` of the exponential factor) minus the
two pole terms `1/x` and `1/(x-1)`, plus the sum of the logarithmic
derivatives of the Weierstrass factors. -/
theorem logDeriv_completedRiemannZeta_eq_tsum_of_zeros (a : ℕ → ℂ) (p : ℕ)
    (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt xi₀ u
      = meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt xi₀ u ≠ ⊤)
    (hQ : HasLogGrowthOne (toMeromorphicNFOn
      (fun w : ℂ => xi₀ w / (∏' n, weierstrassFactor p (w / a n))) Set.univ))
    {x : ℂ} (hx0 : x ≠ 0) (hx1 : x ≠ 1)
    (hxa : ∀ n, x ≠ a n) (hΛ : completedRiemannZeta x ≠ 0)
    (hd : ∀ n, DifferentiableOn ℂ (fun z : ℂ => weierstrassFactor p (z / a n)) Set.univ)
    (hlogsum : Summable (fun n => logDeriv (fun z : ℂ => weierstrassFactor p (z / a n)) x))
    (htend : MultipliableLocallyUniformlyOn (fun n z => weierstrassFactor p (z / a n)) Set.univ) :
    ∃ b : ℂ, logDeriv completedRiemannZeta x
      = b - 1 / x - 1 / (x - 1)
        + ∑' n, logDeriv (fun z : ℂ => weierstrassFactor p (z / a n)) x := by
  -- Step 1: Hadamard factorisation of ξ₀.
  obtain ⟨a₀, b₀, hfac⟩ := factorization_of_xi₀ a p ha0 hsum hmatch hfin hQ
  let P : ℂ → ℂ := fun z => ∏' n, weierstrassFactor p (z / a n)
  have hPfac : ∀ z, xi₀ z = P z * cexp (a₀ + b₀ * z) := hfac
  -- Step 2: `P x ≠ 0`.
  have hPx : P x ≠ 0 := by
    intro hP0
    have hxiz : xi₀ x = 0 := by rw [hPfac x, hP0, zero_mul]
    rw [xi₀_eq_weighted x hx0 hx1] at hxiz
    rcases mul_eq_zero.mp hxiz with h | h
    · exact (mul_ne_zero hx0 (sub_ne_zero.mpr hx1)) h
    · exact hΛ h
  -- `P` is entire.
  have hPdiff : Differentiable ℂ P := differentiable_tprod_weierstrassFactor ha0 hsum
  -- Step 3: logarithmic derivative of the factorisation.
  have hlogcexp : logDeriv (fun z : ℂ => cexp (a₀ + b₀ * z)) x = b₀ := by
    rw [logDeriv_apply, deriv_cexp (by fun_prop)]
    have hd1 : deriv (fun z : ℂ => a₀ + b₀ * z) x = b₀ := by
      simp
    rw [hd1]
    have hexp : cexp (a₀ + b₀ * x) ≠ 0 := Complex.exp_ne_zero _
    field_simp
  have hlogfac : logDeriv xi₀ x = logDeriv P x + b₀ := by
    have hxi : xi₀ = fun z => P z * cexp (a₀ + b₀ * z) := funext hPfac
    have hmul : logDeriv (fun z => P z * cexp (a₀ + b₀ * z)) x
        = logDeriv P x + logDeriv (fun z : ℂ => cexp (a₀ + b₀ * z)) x :=
      logDeriv_mul x hPx (Complex.exp_ne_zero _) (hPdiff x) (by fun_prop)
    rw [hxi, hmul, hlogcexp]
  -- Step 4: logarithmic derivative of the canonical product.
  have hne : ∀ n, weierstrassFactor p (x / a n) ≠ 0 := by
    intro n h
    rw [weierstrassFactor_eq_zero_iff] at h
    exact hxa n ((div_eq_one_iff_eq (ha0 n)).mp h)
  have hPlog : logDeriv P x
      = ∑' n, logDeriv (fun z : ℂ => weierstrassFactor p (z / a n)) x :=
    logDeriv_tprod_eq_tsum (s := Set.univ) isOpen_univ (Set.mem_univ x)
      hne hd hlogsum htend hPx
  -- Step 5: relate `logDeriv ξ₀ x` to `logDeriv Λ x`.
  have hev : xi₀ =ᶠ[𝓝 x] (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) := by
    filter_upwards [eventually_ne_nhds hx0, eventually_ne_nhds hx1] with z hz0 hz1
    exact xi₀_eq_weighted z hz0 hz1
  have hxi_eq : logDeriv xi₀ x
      = logDeriv (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) x := by
    rw [logDeriv_apply, logDeriv_apply, hev.deriv_eq, xi₀_eq_weighted x hx0 hx1]
  have hlogmul1 : logDeriv (fun z : ℂ => z * (z - 1) * completedRiemannZeta z) x
      = logDeriv (fun z : ℂ => z * (z - 1)) x + logDeriv completedRiemannZeta x :=
    logDeriv_mul x (mul_ne_zero hx0 (sub_ne_zero.mpr hx1)) hΛ (by fun_prop)
      (differentiableAt_completedZeta hx0 hx1)
  have hlogmul2 : logDeriv (fun z : ℂ => z * (z - 1)) x = 1 / x + 1 / (x - 1) := by
    have h1 : (fun z : ℂ => z * (z - 1)) = id * (fun z : ℂ => z - 1) := rfl
    have hg : (fun z : ℂ => z - 1) x ≠ 0 := by simpa using sub_ne_zero.mpr hx1
    rw [h1, logDeriv_mul (f := id) (g := fun z : ℂ => z - 1) x hx0 hg
      (by fun_prop) (by fun_prop), logDeriv_id]
    congr 1
    rw [logDeriv_apply]
    simp
  have hxilog : logDeriv xi₀ x = 1 / x + 1 / (x - 1) + logDeriv completedRiemannZeta x := by
    rw [hxi_eq, hlogmul1, hlogmul2]
  -- Step 6: assemble.
  refine ⟨b₀, ?_⟩
  have hsub : logDeriv completedRiemannZeta x = logDeriv xi₀ x - 1 / x - 1 / (x - 1) := by
    rw [hxilog]
    ring
  rw [hsub, hlogfac, hPlog]
  ring

/-- Transfer the Hadamard-product expansion of the log-derivative of Mathlib's
completed Riemann zeta to `AbsoluteHodgeSymbol.completedZeta`, which agrees with
it on a neighbourhood of any point where `s ≠ 0`, `s ≠ 1` and `Gammaℝ s ≠ 0`. -/
theorem logDeriv_completedZeta_eq_tsum_of_zeros (a : ℕ → ℂ) (p : ℕ)
    (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖a n‖)⁻¹ ^ (p + 1)))
    (hmatch : ∀ u, meromorphicOrderAt xi₀ u
      = meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) u)
    (hfin : ∀ u, meromorphicOrderAt xi₀ u ≠ ⊤)
    (hQ : HasLogGrowthOne (toMeromorphicNFOn
      (fun w : ℂ => xi₀ w / (∏' n, weierstrassFactor p (w / a n))) Set.univ))
    {x : ℂ} (hx0 : x ≠ 0) (hx1 : x ≠ 1) (hΓ : x.Gammaℝ ≠ 0)
    (hΛ : completedRiemannZeta x ≠ 0)
    (hxa : ∀ n, x ≠ a n)
    (hd : ∀ n, DifferentiableOn ℂ (fun z : ℂ => weierstrassFactor p (z / a n)) Set.univ)
    (hlogsum : Summable (fun n => logDeriv (fun z : ℂ => weierstrassFactor p (z / a n)) x))
    (htend : MultipliableLocallyUniformlyOn (fun n z => weierstrassFactor p (z / a n)) Set.univ) :
    ∃ b : ℂ, logDeriv AbsoluteHodgeSymbol.completedZeta x
      = b - 1 / x - 1 / (x - 1)
        + ∑' n, logDeriv (fun z : ℂ => weierstrassFactor p (z / a n)) x := by
  -- Step 1: the Hadamard-side expansion for Mathlib's completed zeta.
  obtain ⟨b, hb⟩ :=
    AbsoluteHodgeHadamard.logDeriv_completedRiemannZeta_eq_tsum_of_zeros
      a p ha0 hsum hmatch hfin hQ hx0 hx1 hxa hΛ hd hlogsum htend
  -- Step 2: the two completed zetas agree near `x`.
  have hx0' : ∀ᶠ z in nhds x, z ≠ 0 := eventually_ne_nhds hx0
  have hx1' : ∀ᶠ z in nhds x, z ≠ 1 := eventually_ne_nhds hx1
  have hΓ' : ∀ᶠ z in nhds x, z.Gammaℝ ≠ 0 :=
    AbsoluteHodgeSymbol.eventually_Gammaℝ_ne_zero hΓ
  have hcongr : AbsoluteHodgeSymbol.completedZeta =ᶠ[nhds x] completedRiemannZeta := by
    filter_upwards [hx0', hx1', hΓ'] with z hz0 hz1 hzΓ
    exact AbsoluteHodgeSymbol.completedZeta_eq_completedRiemannZeta hz0 hz1 hzΓ
  -- Step 3: hence their logarithmic derivatives agree at `x`.
  have hlog : logDeriv AbsoluteHodgeSymbol.completedZeta x
      = logDeriv completedRiemannZeta x :=
    (logDeriv_congr_nhds hcongr).eq_of_nhds
  -- Step 4: transport the expansion.
  exact ⟨b, by rw [hlog]; exact hb⟩


open Filter in open scoped Topology in
/-- **The zeros of `ξ₀` are isolated** (the zero set is discrete): at any zero,
`ξ₀` is nonzero on a punctured neighbourhood. This is the first piece of the
zero data needed to enumerate the nontrivial zeros. -/
theorem xi₀_zero_isolated {w : ℂ} (hw : xi₀ w = 0) :
    ∀ᶠ z : ℂ in 𝓝[≠] w, xi₀ z ≠ 0 := by
  have hana : AnalyticOnNhd ℂ xi₀ Set.univ :=
    (differentiable_xi₀.differentiableOn).analyticOnNhd isOpen_univ
  have hzero : AnalyticOnNhd ℂ (fun _ : ℂ => (0 : ℂ)) Set.univ := analyticOnNhd_const
  by_contra h
  rw [Filter.not_eventually] at h
  have hfreq : ∃ᶠ z : ℂ in 𝓝[≠] w, xi₀ z = (fun _ : ℂ => (0 : ℂ)) z :=
    h.mono (fun z hz => by simpa using hz)
  have hEqOn : Set.EqOn xi₀ (fun _ : ℂ => (0 : ℂ)) Set.univ :=
    AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq hana hzero isPreconnected_univ
      (Set.mem_univ w) hfreq
  have h0 : xi₀ 0 = 0 := hEqOn (Set.mem_univ 0)
  have h1 : xi₀ 0 = 1 := by
    unfold xi₀
    ring
  rw [h1] at h0
  exact one_ne_zero h0

open Filter in open scoped Topology in
/-- The zeros of `ξ₀` in a closed ball are finite. -/
theorem xi₀_zeros_finite_in_closedBall (r : ℝ) :
    {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 r}.Finite := by
  -- A. `ξ₀` is meromorphic on all of `ℂ`.
  have hMero : MeromorphicOn xi₀ Set.univ := fun z _ =>
    (differentiable_xi₀.analyticAt z).meromorphicAt
  -- B. The divisor of `ξ₀` has locally finite support.
  have hLFS : LocallyFiniteSupport
      (fun z => (MeromorphicOn.divisor xi₀ Set.univ) z) := by
    intro z
    exact Function.locallyFinsuppWithin.supportLocallyFiniteWithinDomain
      (MeromorphicOn.divisor xi₀ Set.univ) z (Set.mem_univ z)
  -- C. Hence only finitely many points of the closed ball lie in the support.
  have hfin : (Metric.closedBall 0 r ∩
      Function.support (fun z => (MeromorphicOn.divisor xi₀ Set.univ) z)).Finite :=
    LocallyFiniteSupport.finite_inter_support_of_isCompact hLFS (isCompact_closedBall 0 r)
  -- D. Every zero in the ball belongs to that finite support.
  refine hfin.subset ?_
  rintro z ⟨hz, hzr⟩
  -- the divisor does not vanish at a zero of `ξ₀`
  have hDz : (MeromorphicOn.divisor xi₀ Set.univ) z ≠ 0 := by
    have hdiv : (MeromorphicOn.divisor xi₀ Set.univ) z
        = (meromorphicOrderAt xi₀ z).untop₀ :=
      MeromorphicOn.divisor_apply hMero (Set.mem_univ z)
    rw [hdiv, ne_eq, WithTop.untop₀_eq_zero]
    rintro (hzero | htop)
    · -- order zero would force `ξ₀ z ≠ 0`
      have hNF : MeromorphicNFAt xi₀ z := (differentiable_xi₀.analyticAt z).meromorphicNFAt
      exact ((MeromorphicNFAt.meromorphicOrderAt_eq_zero_iff hNF).1 hzero) hz
    · -- order `⊤` would force `ξ₀` to vanish on a punctured neighbourhood
      have hzero_ev : ∀ᶠ w : ℂ in 𝓝[≠] z, xi₀ w = 0 :=
        meromorphicOrderAt_eq_top_iff.1 htop
      have hne_ev : ∀ᶠ w : ℂ in 𝓝[≠] z, xi₀ w ≠ 0 := xi₀_zero_isolated hz
      obtain ⟨w, hw1, hw2⟩ := (hzero_ev.and hne_ev).exists
      exact hw2 hw1
  exact ⟨hzr, hDz⟩


/-- **The zero set of `ξ₀` is countable** (a countable union of finite sets,
one per ball of integer radius). This supplies the enumeration required by the
Hadamard factorisation hypotheses. -/
theorem xi₀_zeros_countable : {z : ℂ | xi₀ z = 0}.Countable := by
  have h : {z : ℂ | xi₀ z = 0}
      = ⋃ n : ℕ, ({z : ℂ | xi₀ z = 0} ∩ Metric.closedBall (0 : ℂ) (n : ℝ)) := by
    ext z
    simp only [Set.mem_iUnion, Set.mem_inter_iff, Set.mem_setOf_eq, Metric.mem_closedBall,
      dist_zero_right]
    constructor
    · rintro hz
      obtain ⟨n, hn⟩ := exists_nat_ge ‖z‖
      exact ⟨n, hz, by simpa using hn⟩
    · rintro ⟨n, hz, _⟩
      exact hz
  rw [h]
  exact Set.countable_iUnion (fun n => (xi₀_zeros_finite_in_closedBall (n : ℝ)).countable)

open Filter in
/-- **(1) `ξ₀` has meromorphic order zero wherever it does not vanish.** -/
theorem meromorphicOrderAt_xi₀_eq_zero_of_ne_zero {u : ℂ} (hu : xi₀ u ≠ 0) :
    meromorphicOrderAt xi₀ u = 0 :=
  meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero
    (differentiable_xi₀.analyticAt u) hu

/-- **(2) The canonical product has order zero at a point which is neither one
of its zeros nor `0`.**  The infinitude of the product is harmless here: the
summability hypothesis at `u` converts (by homogeneity) into summability of the
reciprocal powers `Σ ‖a n‖^{-(p+1)}`, which makes the product entire, and the
product is nonzero at `u` because `u` is separated from every `a n`. -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_eq_zero {a : ℕ → ℂ} {p : ℕ}
    {u : ℂ} (ha0 : ∀ n, a n ≠ 0)
    (hsum : Summable (fun n => (‖u‖) ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (ha : ∀ n, 2 * ‖u‖ ≤ ‖a n‖) (hu : ∀ n, u ≠ a n) (hu0 : u ≠ 0) :
    meromorphicOrderAt (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) u = 0 := by
  have hc : (0 : ℝ) < ‖u‖ ^ (p + 1) := by positivity
  have hsumInv : Summable (fun n : ℕ => (‖a n‖)⁻¹ ^ (p + 1)) := by
    have h := hsum.mul_left ((‖u‖ ^ (p + 1))⁻¹)
    refine h.congr (fun n => ?_)
    have h1 : (‖a n‖)⁻¹ ^ (p + 1) = (‖a n‖ ^ (p + 1))⁻¹ := inv_pow _ _
    rw [h1, div_eq_mul_inv, ← mul_assoc, inv_mul_cancel₀ (ne_of_gt hc), one_mul]
  have hdiff : Differentiable ℂ
      (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) :=
    differentiable_tprod_weierstrassFactor ha0 hsumInv
  have hne : (∏' n, weierstrassFactor p (u / a n)) ≠ 0 :=
    tprod_weierstrassFactor_ne_zero hu0 ha hsum hu
  exact meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero (hdiff.analyticAt u) hne

/-- **(2') The same conclusion with the summability hypothesis in its global
form `Σ ‖a n‖^{-(p+1)} < ∞`.**  This version makes no assumption on `u` other
than that it is not a zero, and in particular covers `u = 0` (where the
hypotheses stated at `‖u‖` are vacuous). -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_eq_zero_of_summable {a : ℕ → ℂ}
    {p : ℕ} {u : ℂ} (ha0 : ∀ n, a n ≠ 0)
    (hsumInv : Summable (fun n : ℕ => (‖a n‖)⁻¹ ^ (p + 1)))
    (ha : ∀ n, 2 * ‖u‖ ≤ ‖a n‖) (hu : ∀ n, u ≠ a n) :
    meromorphicOrderAt (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) u = 0 := by
  have hdiff : Differentiable ℂ
      (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) :=
    differentiable_tprod_weierstrassFactor ha0 hsumInv
  have hsum : Summable (fun n : ℕ => ‖u‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    have h := hsumInv.mul_left (‖u‖ ^ (p + 1))
    refine h.congr (fun n => ?_)
    rw [div_eq_mul_inv, inv_pow]
  have hne : (∏' n, weierstrassFactor p (u / a n)) ≠ 0 := by
    by_cases hu0 : u = 0
    · subst hu0
      have hfun : (fun n : ℕ => weierstrassFactor p ((0 : ℂ) / a n)) = fun _ => (1 : ℂ) := by
        funext n
        rw [zero_div, weierstrassFactor_zero]
      rw [hfun, tprod_one]
      exact one_ne_zero
    · exact tprod_weierstrassFactor_ne_zero hu0 ha hsum hu
  exact meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero (hdiff.analyticAt u) hne

/-- **(2'') Ball form: the canonical product has order zero at every non-zero of
the product inside the ball where it is analytic.**  This is the counterpart of
`meromorphicOrderAt_tprod_weierstrassFactor_at_zero` (which treats the zeros)
and, unlike the `‖u‖`-form of the hypotheses, it also covers `u = 0`. -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_of_lt {a : ℕ → ℂ} {p : ℕ} {u : ℂ}
    {R : ℝ} (hR : 0 < R) (huR : ‖u‖ < R) (ha0 : ∀ n, a n ≠ 0)
    (ha : ∀ n, 2 * R ≤ ‖a n‖)
    (h : Summable (fun n => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hu : ∀ n, u ≠ a n) :
    meromorphicOrderAt (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) u = 0 := by
  have hmem : u ∈ Metric.ball (0 : ℂ) R := by
    rw [Metric.mem_ball, dist_eq_norm]
    simpa using huR
  have han : AnalyticOnNhd ℂ
      (fun z : ℂ => ∏' n, weierstrassFactor p (z / a n)) (Metric.ball 0 R) :=
    analyticOnNhd_tprod_weierstrassFactor_ball hR ha0 ha h
  have hne : (∏' n, weierstrassFactor p (u / a n)) ≠ 0 := by
    by_cases hu0 : u = 0
    · subst hu0
      have hfun : (fun n : ℕ => weierstrassFactor p ((0 : ℂ) / a n)) = fun _ => (1 : ℂ) := by
        funext n
        rw [zero_div, weierstrassFactor_zero]
      rw [hfun, tprod_one]
      exact one_ne_zero
    · have ha' : ∀ n, 2 * ‖u‖ ≤ ‖a n‖ := by
        intro n
        have := ha n
        nlinarith
      have hsum' : Summable (fun n : ℕ => ‖u‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
        have hexp : (1 : ℝ) ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
        refine Summable.of_nonneg_of_le (fun n => by positivity) ?_ h
        intro n
        have hle : ‖u‖ ^ (p + 1) ≤ R ^ (p + 1) :=
          pow_le_pow_left₀ (norm_nonneg _) (le_of_lt huR) (p + 1)
        calc ‖u‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)
            ≤ R ^ (p + 1) / ‖a n‖ ^ (p + 1) := by gcongr
          _ = 1 * (R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by ring
          _ ≤ Real.exp 1 * (R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by gcongr
          _ = Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1) := by ring
      exact tprod_weierstrassFactor_ne_zero hu0 ha' hsum' hu
  exact meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero (han u hmem) hne

/-- `ξ₀` does not vanish at the origin (`ξ₀ 0 = 1`). -/
theorem xi₀_zero_ne_zero_of_count : xi₀ (0 : ℂ) ≠ 0 := by
  have h1 : xi₀ 0 = 1 := by unfold xi₀; ring
  rw [h1]; exact one_ne_zero

/-- **Step A**: at every zero of `ξ₀` inside the closed ball of radius `r`, the divisor of
`ξ₀` on that ball is at least `1` (the order of vanishing at a zero is a positive integer). -/
theorem one_le_divisor_of_xi₀_eq_zero (r : ℝ) (hr : 0 < r) {z : ℂ}
    (hzball : z ∈ Metric.closedBall (0 : ℂ) r) (hz : xi₀ z = 0) :
    (1 : ℤ) ≤ MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) z := by
  have hana : AnalyticOnNhd ℂ xi₀ (Metric.closedBall (0 : ℂ) r) :=
    fun w _ => differentiable_xi₀.analyticAt w
  have hz_an : AnalyticAt ℂ xi₀ z := differentiable_xi₀.analyticAt z
  -- The order at the origin is finite (indeed zero, since `ξ₀ 0 = 1`).
  have h0ord : analyticOrderAt xi₀ (0 : ℂ) ≠ ⊤ := by
    have h : analyticOrderAt xi₀ (0 : ℂ) = 0 :=
      (differentiable_xi₀.analyticAt 0).analyticOrderAt_eq_zero.mpr xi₀_zero_ne_zero_of_count
    rw [h]
    exact ENat.zero_ne_top
  -- Hence the order at `z` is finite.
  have htop : analyticOrderAt xi₀ z ≠ ⊤ :=
    AnalyticOnNhd.analyticOrderAt_ne_top_of_isPreconnected hana
      (convex_closedBall (0 : ℂ) r).isPreconnected
      (Metric.mem_closedBall_self hr.le) hzball h0ord
  -- At a zero the order is nonzero, so as a natural number it is at least one.
  have hnat : analyticOrderNatAt xi₀ z ≠ 0 := by
    intro h
    have hcast : analyticOrderAt xi₀ z = (analyticOrderNatAt xi₀ z : ℕ∞) :=
      (Nat.cast_analyticOrderNatAt htop).symm
    rw [h, Nat.cast_zero] at hcast
    exact (hz_an.analyticOrderAt_ne_zero.mpr hz) hcast
  -- Rewrite the divisor as that natural order.
  have hDz : MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) z
      = (analyticOrderNatAt xi₀ z : ℤ) := by
    rw [MeromorphicOn.AnalyticOnNhd.divisor_apply hana hzball]
    rw [← Nat.cast_analyticOrderNatAt htop]
    rw [ENat.map_natCast, WithTop.untop₀_coe]
  rw [hDz]
  have h1 : (1 : ℤ) ≤ (analyticOrderNatAt xi₀ z : ℤ) := by
    have h := Nat.one_le_iff_ne_zero.mpr hnat
    exact_mod_cast h
  exact h1

/-- **Step B**: the number of zeros of `ξ₀` in the closed ball is at most the divisor sum. -/
theorem ncard_xi₀_zeros_le_divisor_sum (r : ℝ) (hr : 0 < r) :
    ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall (0 : ℂ) r}.ncard : ℝ)
      ≤ ((∑ᶠ u : ℂ, MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u : ℤ) : ℝ) := by
  have hana : AnalyticOnNhd ℂ xi₀ (Metric.closedBall (0 : ℂ) r) :=
    fun w _ => differentiable_xi₀.analyticAt w
  set S : Set ℂ := {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall (0 : ℂ) r} with hSdef
  have hSfin : S.Finite := xi₀_zeros_finite_in_closedBall r
  have hDfin : (Function.support
      (fun u : ℂ => MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u)).Finite :=
    (MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r)).finiteSupport
      (isCompact_closedBall (0 : ℂ) r)
  -- Cardinality as a sum of ones, in `ℤ`.
  have hcard : ((hSfin.toFinset.card : ℕ) : ℤ) = ∑ u ∈ hSfin.toFinset, (1 : ℤ) := by
    rw [Finset.sum_const, nsmul_eq_mul, mul_one]
  -- Each zero contributes at least one.
  have hterm : ∀ u ∈ hSfin.toFinset,
      (1 : ℤ) ≤ MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u := by
    intro u hu
    have huS : u ∈ S := by
      rw [← Set.Finite.coe_toFinset hSfin]
      exact hu
    obtain ⟨hz, hzb⟩ := huS
    exact one_le_divisor_of_xi₀_eq_zero r hr hzb hz
  -- The zero set is contained in the (finite) support of the divisor.
  have hsub : hSfin.toFinset ⊆ hDfin.toFinset := by
    intro u hu
    have huS : u ∈ S := by
      rw [← Set.Finite.coe_toFinset hSfin]
      exact hu
    rw [Set.Finite.mem_toFinset, Function.mem_support]
    intro hD0
    obtain ⟨hz, hzb⟩ := huS
    have h1 := one_le_divisor_of_xi₀_eq_zero r hr hzb hz
    omega
  have hnonneg : ∀ u ∈ hDfin.toFinset, u ∉ hSfin.toFinset →
      (0 : ℤ) ≤ MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u := by
    intro u _ _
    exact MeromorphicOn.AnalyticOnNhd.divisor_nonneg hana u
  have hsupp : Function.support
      (fun u : ℂ => MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u)
        ⊆ ↑hDfin.toFinset := by
    rw [Set.Finite.coe_toFinset]
  have hchain : ((S.ncard : ℕ) : ℤ) ≤
      ∑ᶠ u : ℂ, MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u := by
    rw [Set.ncard_eq_toFinset_card _ hSfin, hcard]
    calc ∑ u ∈ hSfin.toFinset, (1 : ℤ)
        ≤ ∑ u ∈ hSfin.toFinset,
            MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u :=
          Finset.sum_le_sum hterm
      _ ≤ ∑ u ∈ hDfin.toFinset,
            MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u :=
          Finset.sum_le_sum_of_subset_of_nonneg hsub hnonneg
      _ = ∑ᶠ u : ℂ, MeromorphicOn.divisor xi₀ (Metric.closedBall (0 : ℂ) r) u :=
          (finsum_eq_sum_of_support_subset _ hsupp).symm
  exact_mod_cast hchain

/-- **The zero-count bound**: Jensen's inequality bounds the number of zeros of `ξ₀` in the
closed ball of radius `r` by the logarithmic growth constant. -/
theorem xi₀_zero_count_bound (r : ℝ) (hr : 0 < r) {A B : ℝ} (hA : 0 ≤ A)
    (hAB : 0 ≤ 2 * A * r + B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B) :
    ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 r}.ncard : ℝ)
      ≤ (2 * A * r + B) / Real.log 2 := by
  -- The growth bound on the sphere of radius `2r`.
  have hbound : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * r),
      ‖xi₀ z‖ ≤ Real.exp (2 * A * r + B) := by
    intro z hz
    have hz2 : ‖z‖ = 2 * r := by
      rw [Metric.mem_sphere, dist_zero_right] at hz
      exact hz
    have hle : Real.log ‖xi₀ z‖ ≤ 2 * A * r + B := by
      have h := hgrowth z
      rw [hz2] at h
      linarith
    by_cases hzi : ‖xi₀ z‖ = 0
    · rw [hzi]
      exact (Real.exp_pos _).le
    · have hpos : 0 < ‖xi₀ z‖ := lt_of_le_of_ne (norm_nonneg _) (Ne.symm hzi)
      calc ‖xi₀ z‖ = Real.exp (Real.log ‖xi₀ z‖) := (Real.exp_log hpos).symm
        _ ≤ Real.exp (2 * A * r + B) := Real.exp_le_exp.mpr hle
  have hf : AnalyticOnNhd ℂ xi₀ (Metric.closedBall (0 : ℂ) (2 * r)) :=
    fun w _ => differentiable_xi₀.analyticAt w
  have hM : (1 : ℝ) ≤ Real.exp (2 * A * r + B) := Real.one_le_exp hAB
  have h0 : xi₀ (0 : ℂ) ≠ 0 := xi₀_zero_ne_zero_of_count
  have hJ := sum_divisor_le_two_mul hr hM hf h0 hbound
  have hcard := ncard_xi₀_zeros_le_divisor_sum r hr
  have hlogM : Real.log (Real.exp (2 * A * r + B) / ‖xi₀ 0‖) / Real.log 2
      = (2 * A * r + B) / Real.log 2 := by
    have h1 : xi₀ 0 = 1 := by unfold xi₀; ring
    rw [h1, norm_one, div_one, Real.log_exp]
  rw [← hlogM]
  exact le_trans hcard hJ

set_option maxHeartbeats 2000000 in
/-- **The zeros of `ξ₀` are square-summable in the `(‖z‖+1)⁻²` weight.**

This is the summability half of the Hadamard product input: it says that the
multiset of zeros of `ξ₀` is thin enough that `∑_ρ (‖ρ‖+1)⁻² < ∞`.  The proof
is a dyadic shell decomposition: the counting bound `xi₀_zero_count_bound`
controls the number of zeros in a ball of radius `2^{k+1}` by `O(2^k)`, and the
weight on the corresponding shell is `O(4^{-k})`, so the shell sums are bounded
by a geometric series. -/
theorem xi₀_zeros_inv_sq_summable {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B) :
    Summable (fun w : {z : ℂ // xi₀ z = 0} => (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹) := by
  classical
  set α : Type := {z : ℂ // xi₀ z = 0} with hα
  -- the majorant, summable geometric-type series
  set g : ℕ → ℝ := fun j => ((2 * A * (2:ℝ)^(j+1) + B) / Real.log 2) * (1/4)^j with hg
  have hlogpos : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hAB : ∀ j : ℕ, (0:ℝ) ≤ 2 * A * (2:ℝ)^(j+1) + B := by
    intro j
    have hp : (0:ℝ) ≤ (2:ℝ)^(j+1) := by positivity
    have h1 : 0 ≤ 2 * A * (2:ℝ)^(j+1) := by
      have h2 : 0 ≤ 2 * A := by linarith
      exact mul_nonneg h2 hp
    linarith
  -- the shell index
  have hr1 : ∀ w : α, (1:ℝ) ≤ ‖(w:ℂ)‖ + 1 := by
    intro w
    have := norm_nonneg (w : ℂ)
    linarith
  have hex : ∀ w : α, ∃ n : ℕ, ‖(w:ℂ)‖ + 1 < (2:ℝ)^(n+1) := by
    intro w
    obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (R := ℝ) (‖(w:ℂ)‖ + 1) (show (1:ℝ) < 2 by norm_num)
    cases n with
    | zero =>
        simp only [pow_zero] at hn
        exact absurd hn (not_lt.mpr (hr1 w))
    | succ m => exact ⟨m, by simpa using hn⟩
  let k : α → ℕ := fun w => Nat.find (hex w)
  have hk_lt : ∀ w : α, ‖(w:ℂ)‖ + 1 < (2:ℝ)^(k w + 1) := by
    intro w
    exact Nat.find_spec (hex w)
  have hk_ge : ∀ w : α, (2:ℝ)^(k w) ≤ ‖(w:ℂ)‖ + 1 := by
    intro w
    by_cases h0 : k w = 0
    · rw [h0]
      simpa using hr1 w
    · obtain ⟨m, hm⟩ : ∃ m, k w = m + 1 := ⟨k w - 1, by omega⟩
      have hnot : ¬ (‖(w:ℂ)‖ + 1 < (2:ℝ)^(m+1)) := by
        intro hlt
        have hle := Nat.find_min' (hex w) hlt
        have hkm : Nat.find (hex w) = m + 1 := hm
        omega
      rw [hm]
      exact not_lt.mp hnot
  -- pointwise bound by the shell weight
  have hf_le : ∀ w : α, ((‖(w:ℂ)‖ + 1)^2)⁻¹ ≤ ((1/4:ℝ)^(k w)) := by
    intro w
    set r : ℝ := ‖(w:ℂ)‖ + 1 with hr
    have hrpos : 0 < r := by
      have := norm_nonneg (w : ℂ)
      rw [hr]; linarith
    have h4 : ((4:ℝ)^(k w)) = ((2:ℝ)^(k w))^2 := by
      have h22 : (4:ℝ) = 2^2 := by norm_num
      rw [h22, ← pow_mul, ← pow_mul, mul_comm]
    have hsq : ((4:ℝ)^(k w)) ≤ r^2 := by
      rw [h4]
      exact pow_le_pow_left₀ (pow_pos (by norm_num) _).le (hk_ge w) 2
    have hpos4 : (0:ℝ) < (4:ℝ)^(k w) := pow_pos (by norm_num) _
    have hposr : (0:ℝ) < r^2 := pow_pos hrpos 2
    have hinv : (r^2)⁻¹ ≤ ((4:ℝ)^(k w))⁻¹ := (inv_le_inv₀ hposr hpos4).mpr hsq
    have h14 : ((4:ℝ)^(k w))⁻¹ = (1/4:ℝ)^(k w) := by
      rw [← inv_pow]
      norm_num
    rw [h14] at hinv
    simpa [hr] using hinv
  have hg_nonneg : ∀ j : ℕ, (0:ℝ) ≤ g j := by
    intro j
    simp only [hg]
    exact mul_nonneg (div_nonneg (hAB j) hlogpos.le) (by positivity)
  -- summability of the majorant
  have hg_summable : Summable g := by
    have h2 : Summable (fun j : ℕ => (1/2:ℝ)^j) :=
      summable_geometric_of_lt_one (by norm_num) (by norm_num)
    have h4s : Summable (fun j : ℕ => (1/4:ℝ)^j) :=
      summable_geometric_of_lt_one (by norm_num) (by norm_num)
    have hcomb : Summable
        (fun j : ℕ => (4*A/Real.log 2) * (1/2)^j + (B/Real.log 2) * (1/4)^j) :=
      (h2.mul_left _).add (h4s.mul_left _)
    refine hcomb.congr (fun j => ?_)
    have hpow : (1/4:ℝ)^j * (2:ℝ)^j = (1/2:ℝ)^j := by
      rw [← mul_pow]; norm_num
    have hL : Real.log 2 ≠ 0 := ne_of_gt hlogpos
    show (4*A/Real.log 2) * (1/2)^j + (B/Real.log 2) * (1/4)^j = g j
    simp only [hg]
    have h2j : (2:ℝ)^(j+1) = 2 * 2^j := by rw [pow_succ]; ring
    rw [h2j, ← hpow]
    field_simp
    ring
  -- the cardinality bound for a single shell
  have hcard : ∀ (s : Finset α) (j : ℕ),
      (((s.filter (fun w => k w = j)).card : ℕ) : ℝ) ≤
        (2 * A * (2:ℝ)^(j+1) + B) / Real.log 2 := by
    intro s j
    have hrjpos : (0:ℝ) < (2:ℝ)^(j+1) := by positivity
    have hSfin : {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.Finite :=
      xi₀_zeros_finite_in_closedBall _
    have hsub : ∀ z ∈ (s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ),
        z ∈ {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))} := by
      intro z hz
      obtain ⟨w, hw, rfl⟩ := Finset.mem_image.mp hz
      obtain ⟨-, hkj⟩ := Finset.mem_filter.mp hw
      refine ⟨w.2, ?_⟩
      rw [Metric.mem_closedBall, dist_zero_right]
      have hlt := hk_lt w
      rw [hkj] at hlt
      linarith
    have hcardle : ((s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ)).card
        ≤ {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.ncard :=
      Finset.card_le_ncard hSfin hsub
    have himgcard : ((s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ)).card
        = (s.filter (fun w => k w = j)).card :=
      Finset.card_image_of_injective _ Subtype.coe_injective
    rw [himgcard] at hcardle
    have hcount := xi₀_zero_count_bound ((2:ℝ)^(j+1)) hrjpos hA (hAB j) hgrowth
    have hcast : (((s.filter (fun w => k w = j)).card : ℕ) : ℝ)
        ≤ ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.ncard : ℝ) := by
      exact_mod_cast hcardle
    exact le_trans hcast hcount
  -- uniform bound on finite sums
  have hbound : ∀ s : Finset α, ∑ w ∈ s, ((‖(w:ℂ)‖ + 1)^2)⁻¹ ≤ ∑' j, g j := by
    intro s
    have hgroup : ∑ j ∈ s.image k, ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w)
        = ∑ w ∈ s, (1/4:ℝ)^(k w) :=
      Finset.sum_fiberwise_of_maps_to
        (fun w hw => Finset.mem_image.mpr ⟨w, hw, rfl⟩) _
    calc ∑ w ∈ s, ((‖(w:ℂ)‖ + 1)^2)⁻¹
        ≤ ∑ w ∈ s, (1/4:ℝ)^(k w) := Finset.sum_le_sum (fun w _ => hf_le w)
      _ = ∑ j ∈ s.image k, ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w) := hgroup.symm
      _ = ∑ j ∈ s.image k, ((s.filter (fun w => k w = j)).card : ℝ) * (1/4)^j := by
          apply Finset.sum_congr rfl
          intro j _
          have h1 : ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w)
              = ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^j := by
            apply Finset.sum_congr rfl
            intro w hw
            rw [(Finset.mem_filter.mp hw).2]
          rw [h1, Finset.sum_const, nsmul_eq_mul]
      _ ≤ ∑ j ∈ s.image k, ((2 * A * (2:ℝ)^(j+1) + B) / Real.log 2) * (1/4)^j := by
          apply Finset.sum_le_sum
          intro j _
          exact mul_le_mul_of_nonneg_right (hcard s j) (by positivity)
      _ = ∑ j ∈ s.image k, g j := by simp only [hg]
      _ ≤ ∑' j, g j :=
          Summable.sum_le_tsum _ (fun j _ => hg_nonneg j) hg_summable
  -- ENNReal assembly
  have hf_nonneg : ∀ w : α, (0:ℝ) ≤ ((‖(w:ℂ)‖ + 1)^2)⁻¹ := by
    intro w
    positivity
  have hfinite : ∀ s : Finset α,
      ∑ w ∈ s, ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)
        ≤ ENNReal.ofReal (∑' j, g j) := by
    intro s
    rw [← ENNReal.ofReal_sum_of_nonneg (fun w _ => hf_nonneg w)]
    exact ENNReal.ofReal_le_ofReal (hbound s)
  have htsum_ne_top : ∑' w : α, ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹) ≠ ⊤ := by
    rw [ENNReal.tsum_eq_iSup_sum]
    refine ne_of_lt (lt_of_le_of_lt (iSup_le hfinite) ?_)
    exact ENNReal.ofReal_lt_top
  -- descend to NNReal and then to ℝ
  have hnn : Summable (fun w : α =>
      (ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)).toNNReal) := by
    rw [← ENNReal.tsum_coe_ne_top_iff_summable]
    simpa using htsum_ne_top
  have hreal : Summable (fun w : α =>
      ((ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)).toNNReal : ℝ)) :=
    NNReal.summable_coe.mpr hnn
  refine hreal.congr (fun w => ?_)
  show ((Real.toNNReal (((‖(w:ℂ)‖ + 1)^2)⁻¹) : NNReal) : ℝ) = ((‖(w:ℂ)‖ + 1)^2)⁻¹
  exact Real.coe_toNNReal _ (hf_nonneg w)


/-- **Summability transfers from the zero subtype to any injective enumeration**
of the zero set. This converts the subtype-form summability
(`xi₀_zeros_inv_sq_summable`) into the enumerated form required by the
Hadamard factorisation hypotheses. -/
theorem summable_inv_sq_of_injective_enumeration {a : ℕ → ℂ}
    (hinj : Function.Injective a)
    (hrange : ∀ n, xi₀ (a n) = 0)
    (hsum : Summable (fun w : {z : ℂ // xi₀ z = 0} => (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹)) :
    Summable (fun n : ℕ => (((‖a n‖ + 1) ^ 2 : ℝ))⁻¹) := by
  have hcomp : Summable ((fun w : {z : ℂ // xi₀ z = 0} => (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹)
      ∘ (fun n : ℕ => (⟨a n, hrange n⟩ : {z : ℂ // xi₀ z = 0}))) :=
    hsum.comp_injective (i := fun n : ℕ => (⟨a n, hrange n⟩ : {z : ℂ // xi₀ z = 0}))
      (fun _ _ h => hinj (Subtype.mk.inj h))
  simpa [Function.comp_def] using hcomp


/-- **General zero-counting bound via a bound on `log ‖ξ₀‖` on a sphere.**
If `log ‖ξ₀‖ ≤ L` on the sphere of radius `2r` (and `L ≥ 0`), then the number
of zeros in the closed ball of radius `r` is at most `L / log 2`. Taking
`L = A·(2r)·log(2r) + B` (the correct order-1 growth of `ξ`) gives
`N(r) = O(r log r)`, which is what Riemann–von Mangoldt asymptotics require;
the linear-growth case `L = 2Ar + B` is the special case
`xi₀_zero_count_bound`. -/
theorem xi₀_zero_count_bound_of_log_le (r : ℝ) (hr : 0 < r) {L : ℝ} (hL : 0 ≤ L)
    (hbound : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * r), Real.log ‖xi₀ z‖ ≤ L) :
    ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 r}.ncard : ℝ)
      ≤ L / Real.log 2 := by
  have hRpos : (0 : ℝ) < 2 * r := by linarith
  have hf : AnalyticOnNhd ℂ xi₀ (Metric.closedBall (0 : ℂ) (2 * r)) :=
    fun w _ => differentiable_xi₀.analyticAt w
  have h0 : xi₀ 0 ≠ 0 := by
    have : xi₀ 0 = 1 := by unfold xi₀; ring
    rw [this]; exact one_ne_zero
  have hM : (1 : ℝ) ≤ Real.exp L := Real.one_le_exp hL
  have hb : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * r), ‖xi₀ z‖ ≤ Real.exp L := by
    intro z hz
    by_cases hz0 : xi₀ z = 0
    · rw [hz0, norm_zero]
      exact zero_le_one.trans hM
    · have hpos : 0 < ‖xi₀ z‖ := norm_pos_iff.mpr hz0
      calc ‖xi₀ z‖ = Real.exp (Real.log ‖xi₀ z‖) := (Real.exp_log hpos).symm
        _ ≤ Real.exp L := Real.exp_le_exp.mpr (hbound z hz)
  have h := sum_divisor_le_two_mul hr hM hf h0 hb
  have hlog : Real.log (Real.exp L / ‖xi₀ 0‖) / Real.log 2 = L / Real.log 2 := by
    have h0norm : ‖xi₀ 0‖ = 1 := by
      have : xi₀ 0 = 1 := by unfold xi₀; ring
      rw [this, norm_one]
    rw [h0norm, div_one, Real.log_exp]
  rw [hlog] at h
  have hcard := ncard_xi₀_zeros_le_divisor_sum r hr
  have hdiv := h
  exact le_trans hcard hdiv


set_option maxHeartbeats 2000000 in
/-- Summability of the zeros of `ξ₀` in the `(‖z‖+1)⁻²` weight, from the order-one
logarithmic growth bound `log ‖ξ₀ z‖ ≤ A‖z‖ log(‖z‖+2) + B`. -/
theorem xi₀_zeros_inv_sq_summable_of_log_growth {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B) :
    Summable (fun w : {z : ℂ // xi₀ z = 0} => (((‖(w : ℂ)‖ + 1) ^ 2 : ℝ))⁻¹) := by
  classical
  set α : Type := {z : ℂ // xi₀ z = 0} with hα
  have hlogpos : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  -- the shell majorant: `L_j / log 2 * 4^{-j}`, with `L_j` the log bound at radius `2^{j+2}`
  set g : ℕ → ℝ :=
    fun j => ((A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B) / Real.log 2) * (1/4)^j
    with hg
  have harg1 : ∀ j : ℕ, (1:ℝ) < (2:ℝ)^(j+2) + 2 := by
    intro j
    have hp : (0:ℝ) < (2:ℝ)^(j+2) := by positivity
    linarith
  -- nonnegativity of the log bound
  have hL_nonneg : ∀ j : ℕ,
      (0:ℝ) ≤ A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B := by
    intro j
    have hp : (0:ℝ) ≤ (2:ℝ)^(j+2) := by positivity
    have hl : (0:ℝ) ≤ Real.log ((2:ℝ)^(j+2) + 2) := (Real.log_pos (harg1 j)).le
    have h1 : (0:ℝ) ≤ A * (2:ℝ)^(j+2) := mul_nonneg hA hp
    have h2 : (0:ℝ) ≤ A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) :=
      mul_nonneg h1 hl
    linarith
  -- the shell index
  have hr1 : ∀ w : α, (1:ℝ) ≤ ‖(w:ℂ)‖ + 1 := by
    intro w
    have := norm_nonneg (w : ℂ)
    linarith
  have hex : ∀ w : α, ∃ n : ℕ, ‖(w:ℂ)‖ + 1 < (2:ℝ)^(n+1) := by
    intro w
    obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (R := ℝ) (‖(w:ℂ)‖ + 1) (show (1:ℝ) < 2 by norm_num)
    cases n with
    | zero =>
        simp only [pow_zero] at hn
        exact absurd hn (not_lt.mpr (hr1 w))
    | succ m => exact ⟨m, by simpa using hn⟩
  let k : α → ℕ := fun w => Nat.find (hex w)
  have hk_lt : ∀ w : α, ‖(w:ℂ)‖ + 1 < (2:ℝ)^(k w + 1) := by
    intro w
    exact Nat.find_spec (hex w)
  have hk_ge : ∀ w : α, (2:ℝ)^(k w) ≤ ‖(w:ℂ)‖ + 1 := by
    intro w
    by_cases h0 : k w = 0
    · rw [h0]
      simpa using hr1 w
    · obtain ⟨m, hm⟩ : ∃ m, k w = m + 1 := ⟨k w - 1, by omega⟩
      have hnot : ¬ (‖(w:ℂ)‖ + 1 < (2:ℝ)^(m+1)) := by
        intro hlt
        have hle := Nat.find_min' (hex w) hlt
        have hkm : Nat.find (hex w) = m + 1 := hm
        omega
      rw [hm]
      exact not_lt.mp hnot
  -- pointwise bound by the shell weight
  have hf_le : ∀ w : α, ((‖(w:ℂ)‖ + 1)^2)⁻¹ ≤ ((1/4:ℝ)^(k w)) := by
    intro w
    set r : ℝ := ‖(w:ℂ)‖ + 1 with hr
    have hrpos : 0 < r := by
      have := norm_nonneg (w : ℂ)
      rw [hr]; linarith
    have h4 : ((4:ℝ)^(k w)) = ((2:ℝ)^(k w))^2 := by
      have h22 : (4:ℝ) = 2^2 := by norm_num
      rw [h22, ← pow_mul, ← pow_mul, mul_comm]
    have hsq : ((4:ℝ)^(k w)) ≤ r^2 := by
      rw [h4]
      exact pow_le_pow_left₀ (pow_pos (by norm_num) _).le (hk_ge w) 2
    have hpos4 : (0:ℝ) < (4:ℝ)^(k w) := pow_pos (by norm_num) _
    have hposr : (0:ℝ) < r^2 := pow_pos hrpos 2
    have hinv : (r^2)⁻¹ ≤ ((4:ℝ)^(k w))⁻¹ := (inv_le_inv₀ hposr hpos4).mpr hsq
    have h14 : ((4:ℝ)^(k w))⁻¹ = (1/4:ℝ)^(k w) := by
      rw [← inv_pow]
      norm_num
    rw [h14] at hinv
    simpa [hr] using hinv
  have hg_nonneg : ∀ j : ℕ, (0:ℝ) ≤ g j := by
    intro j
    simp only [hg]
    exact mul_nonneg (div_nonneg (hL_nonneg j) hlogpos.le) (by positivity)
  -- summability of the majorant `k ↦ C (k+3) 2^{-k}`
  have hlin : Summable (fun j : ℕ => (j:ℝ) * (1/2:ℝ)^j) := by
    have h := summable_norm_pow_mul_geometric_of_norm_lt_one (k := 1) (r := (1/2:ℝ))
      (by norm_num)
    simpa using h
  have hgeo : Summable (fun j : ℕ => (1/2:ℝ)^j) :=
    summable_geometric_of_lt_one (by norm_num) (by norm_num)
  have hmaj : Summable (fun j : ℕ =>
      ((4*A*Real.log 2 + B)/Real.log 2) * ((j:ℝ)+3) * (1/2:ℝ)^j) := by
    have hsum : Summable (fun j : ℕ => (j:ℝ)*(1/2:ℝ)^j + 3*(1/2:ℝ)^j) :=
      hlin.add (hgeo.mul_left 3)
    have hm := hsum.mul_left ((4*A*Real.log 2 + B)/Real.log 2)
    refine hm.congr (fun j => ?_)
    ring
  -- comparison of `g` with the majorant
  have hg_le : ∀ j : ℕ, g j ≤
      ((4*A*Real.log 2 + B)/Real.log 2) * ((j:ℝ)+3) * (1/2:ℝ)^j := by
    intro j
    have hlog_le : Real.log ((2:ℝ)^(j+2) + 2) ≤ ((j:ℝ)+3) * Real.log 2 := by
      have hpowle : (2:ℝ)^(j+2) + 2 ≤ (2:ℝ)^(j+3) := by
        have h2 : (2:ℝ) ≤ (2:ℝ)^(j+2) := by
          have h1 : (2:ℝ)^1 ≤ (2:ℝ)^(j+2) :=
            pow_le_pow_right₀ (by norm_num) (by omega)
          simpa using h1
        have h3 : (2:ℝ)^(j+3) = (2:ℝ)^(j+2) + (2:ℝ)^(j+2) := by
          rw [pow_succ]
          ring
        rw [h3]
        linarith
      have hlog := Real.log_le_log (by positivity : (0:ℝ) < (2:ℝ)^(j+2) + 2) hpowle
      have hlogpow : Real.log ((2:ℝ)^(j+3)) = ((j:ℝ)+3) * Real.log 2 := by
        rw [Real.log_pow]
        push_cast
        ring
      rw [hlogpow] at hlog
      exact hlog
    have hpow : (2:ℝ)^(j+2) = 4 * (2:ℝ)^j := by
      rw [show j+2 = j+1+1 from rfl, pow_succ, pow_succ]
      ring
    have hLle : A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B ≤
        (4*A*Real.log 2 + B) * ((j:ℝ)+3) * (2:ℝ)^j := by
      have hA2 : (0:ℝ) ≤ A * (2:ℝ)^(j+2) := mul_nonneg hA (by positivity)
      have hmul : A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) ≤
          A * (2:ℝ)^(j+2) * (((j:ℝ)+3) * Real.log 2) :=
        mul_le_mul_of_nonneg_left hlog_le hA2
      have hBle : B ≤ B * ((j:ℝ)+3) * (2:ℝ)^j := by
        have h1 : (1:ℝ) ≤ ((j:ℝ)+3) * (2:ℝ)^j := by
          have hp : (1:ℝ) ≤ (2:ℝ)^j := one_le_pow₀ (by norm_num)
          have hj : (0:ℝ) ≤ (j:ℝ) := Nat.cast_nonneg j
          nlinarith
        calc B = B * 1 := by ring
          _ ≤ B * (((j:ℝ)+3) * (2:ℝ)^j) := mul_le_mul_of_nonneg_left h1 hB
          _ = B * ((j:ℝ)+3) * (2:ℝ)^j := by ring
      calc A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B
          ≤ A * (2:ℝ)^(j+2) * (((j:ℝ)+3) * Real.log 2)
              + B * ((j:ℝ)+3) * (2:ℝ)^j := add_le_add hmul hBle
        _ = (4*A*Real.log 2 + B) * ((j:ℝ)+3) * (2:ℝ)^j := by
            rw [hpow]; ring
    have h1 := div_le_div_of_nonneg_right hLle hlogpos.le
    have h2 : (0:ℝ) ≤ (1/4:ℝ)^j := by positivity
    have h3 := mul_le_mul_of_nonneg_right h1 h2
    simp only [hg]
    refine le_trans h3 (le_of_eq ?_)
    have hpow2 : ((2:ℝ)^j * (1/4:ℝ)^j) = (1/2:ℝ)^j := by
      rw [← mul_pow]
      norm_num
    calc (((4*A*Real.log 2 + B) * ((j:ℝ)+3) * (2:ℝ)^j) / Real.log 2) * (1/4:ℝ)^j
        = ((4*A*Real.log 2 + B) * ((j:ℝ)+3) / Real.log 2)
            * ((2:ℝ)^j * (1/4:ℝ)^j) := by ring
      _ = ((4*A*Real.log 2 + B) * ((j:ℝ)+3) / Real.log 2) * (1/2:ℝ)^j := by
          rw [hpow2]
      _ = ((4*A*Real.log 2 + B)/Real.log 2) * ((j:ℝ)+3) * (1/2:ℝ)^j := by ring
  have hg_summable : Summable g := hmaj.of_nonneg_of_le hg_nonneg hg_le
  -- the cardinality bound for a single shell
  have hcard : ∀ (s : Finset α) (j : ℕ),
      (((s.filter (fun w => k w = j)).card : ℕ) : ℝ) ≤
        (A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B) / Real.log 2 := by
    intro s j
    have hrjpos : (0:ℝ) < (2:ℝ)^(j+1) := by positivity
    have hSfin : {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.Finite :=
      xi₀_zeros_finite_in_closedBall _
    have hsub : ∀ z ∈ (s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ),
        z ∈ {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))} := by
      intro z hz
      obtain ⟨w, hw, rfl⟩ := Finset.mem_image.mp hz
      obtain ⟨-, hkj⟩ := Finset.mem_filter.mp hw
      refine ⟨w.2, ?_⟩
      rw [Metric.mem_closedBall, dist_zero_right]
      have hlt := hk_lt w
      rw [hkj] at hlt
      linarith
    have hcardle : ((s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ)).card
        ≤ {z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.ncard :=
      Finset.card_le_ncard hSfin hsub
    have himgcard : ((s.filter (fun w => k w = j)).image (Subtype.val : α → ℂ)).card
        = (s.filter (fun w => k w = j)).card :=
      Finset.card_image_of_injective _ Subtype.coe_injective
    rw [himgcard] at hcardle
    have hbnd : ∀ z ∈ Metric.sphere (0 : ℂ) (2 * (2:ℝ)^(j+1)),
        Real.log ‖xi₀ z‖ ≤ A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B := by
      intro z hz
      have hz2 : ‖z‖ = (2:ℝ)^(j+2) := by
        rw [Metric.mem_sphere, dist_zero_right] at hz
        rw [hz]
        rw [show (2:ℝ) * (2:ℝ)^(j+1) = (2:ℝ)^(j+2) from by
          rw [← pow_succ']]
      have h := hgrowth z
      rw [hz2] at h
      exact h
    have hcount := xi₀_zero_count_bound_of_log_le ((2:ℝ)^(j+1)) hrjpos
      (L := A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B) (hL_nonneg j) hbnd
    have hcast : (((s.filter (fun w => k w = j)).card : ℕ) : ℝ)
        ≤ ({z : ℂ | xi₀ z = 0 ∧ z ∈ Metric.closedBall 0 ((2:ℝ)^(j+1))}.ncard : ℝ) := by
      exact_mod_cast hcardle
    exact le_trans hcast hcount
  -- uniform bound on finite sums
  have hbound : ∀ s : Finset α, ∑ w ∈ s, ((‖(w:ℂ)‖ + 1)^2)⁻¹ ≤ ∑' j, g j := by
    intro s
    have hgroup : ∑ j ∈ s.image k, ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w)
        = ∑ w ∈ s, (1/4:ℝ)^(k w) :=
      Finset.sum_fiberwise_of_maps_to
        (fun w hw => Finset.mem_image.mpr ⟨w, hw, rfl⟩) _
    calc ∑ w ∈ s, ((‖(w:ℂ)‖ + 1)^2)⁻¹
        ≤ ∑ w ∈ s, (1/4:ℝ)^(k w) := Finset.sum_le_sum (fun w _ => hf_le w)
      _ = ∑ j ∈ s.image k, ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w) := hgroup.symm
      _ = ∑ j ∈ s.image k, ((s.filter (fun w => k w = j)).card : ℝ) * (1/4)^j := by
          apply Finset.sum_congr rfl
          intro j _
          have h1 : ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^(k w)
              = ∑ w ∈ s.filter (fun w => k w = j), (1/4:ℝ)^j := by
            apply Finset.sum_congr rfl
            intro w hw
            rw [(Finset.mem_filter.mp hw).2]
          rw [h1, Finset.sum_const, nsmul_eq_mul]
      _ ≤ ∑ j ∈ s.image k,
            ((A * (2:ℝ)^(j+2) * Real.log ((2:ℝ)^(j+2) + 2) + B) / Real.log 2) * (1/4)^j := by
          apply Finset.sum_le_sum
          intro j _
          exact mul_le_mul_of_nonneg_right (hcard s j) (by positivity)
      _ = ∑ j ∈ s.image k, g j := by simp only [hg]
      _ ≤ ∑' j, g j :=
          Summable.sum_le_tsum _ (fun j _ => hg_nonneg j) hg_summable
  -- ENNReal assembly
  have hf_nonneg : ∀ w : α, (0:ℝ) ≤ ((‖(w:ℂ)‖ + 1)^2)⁻¹ := by
    intro w
    positivity
  have hfinite : ∀ s : Finset α,
      ∑ w ∈ s, ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)
        ≤ ENNReal.ofReal (∑' j, g j) := by
    intro s
    rw [← ENNReal.ofReal_sum_of_nonneg (fun w _ => hf_nonneg w)]
    exact ENNReal.ofReal_le_ofReal (hbound s)
  have htsum_ne_top : ∑' w : α, ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹) ≠ ⊤ := by
    rw [ENNReal.tsum_eq_iSup_sum]
    refine ne_of_lt (lt_of_le_of_lt (iSup_le hfinite) ?_)
    exact ENNReal.ofReal_lt_top
  -- descend to NNReal and then to ℝ
  have hnn : Summable (fun w : α =>
      (ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)).toNNReal) := by
    rw [← ENNReal.tsum_coe_ne_top_iff_summable]
    simpa using htsum_ne_top
  have hreal : Summable (fun w : α =>
      ((ENNReal.ofReal (((‖(w:ℂ)‖ + 1)^2)⁻¹)).toNNReal : ℝ)) :=
    NNReal.summable_coe.mpr hnn
  refine hreal.congr (fun w => ?_)
  show ((Real.toNNReal (((‖(w:ℂ)‖ + 1)^2)⁻¹) : NNReal) : ℝ) = ((‖(w:ℂ)‖ + 1)^2)⁻¹
  exact Real.coe_toNNReal _ (hf_nonneg w)


open Filter in open scoped Topology in
/-- **Local factorisation gives order one**: if `F` agrees near `a` with
`E_1(·/a)·G` where `G` is analytic and nonzero at `a ≠ 0`, then
`meromorphicOrderAt F a = 1`. This is the local step for computing the order of
an infinite canonical product at one of its zeros. -/
theorem meromorphicOrderAt_eq_one_of_local_factor {F G : ℂ → ℂ} {a : ℂ} (ha : a ≠ 0)
    (hG : AnalyticAt ℂ G a) (hGne : G a ≠ 0)
    (hF : F =ᶠ[𝓝[≠] a] fun z => weierstrassFactor 1 (z / a) * G z) :
    meromorphicOrderAt F a = 1 := by
  rw [meromorphicOrderAt_congr hF]
  have hfac : meromorphicOrderAt (fun z : ℂ => weierstrassFactor 1 (z / a)) a = 1 := by
    have := meromorphicOrderAt_weierstrassFactor_div 1 ha a
    simpa using this
  have hGm : MeromorphicAt G a := hG.meromorphicAt
  have hdiff : Differentiable ℂ (fun z : ℂ => weierstrassFactor 1 (z / a)) :=
    (differentiable_weierstrassFactor 1).comp (by fun_prop)
  have hfacM : MeromorphicAt (fun z : ℂ => weierstrassFactor 1 (z / a)) a :=
    (hdiff.analyticAt a).meromorphicAt
  have hprod : meromorphicOrderAt (fun z : ℂ => weierstrassFactor 1 (z / a) * G z) a
      = meromorphicOrderAt (fun z : ℂ => weierstrassFactor 1 (z / a)) a
        + meromorphicOrderAt G a :=
    meromorphicOrderAt_mul hfacM hGm
  rw [hprod, hfac]
  have hG0 : meromorphicOrderAt G a = 0 := by
    have := hG.meromorphicOrderAt_eq
    rw [this]
    have h0 : analyticOrderAt G a = 0 := (analyticOrderAt_eq_zero).mpr (Or.inr hGne)
    rw [h0]
    rfl
  rw [hG0, add_zero]

/-- **Splitting an infinite product at a finite set of indices.**  If `f` is
multipliable and the finite product over `s` is nonzero, then the full product
is the product over `s` times the product over the complement of `s`. -/
theorem tprod_eq_prod_mul_tprod_compl {f : ℕ → ℂ} (s : Finset ℕ)
    (hfull : Multipliable f) (hne : ∏ n ∈ s, f n ≠ 0) :
    (∏' n, f n) = (∏ n ∈ s, f n) * (∏' n : {n // n ∉ s}, f n) := by
  -- The finite product over `s` is a `HasProd` for the indicator of `s`.
  have hPsub : HasProd (fun n : ↑(s : Set ℕ) => f ↑n) (∏ n ∈ s, f n) :=
    Finset.hasProd s f
  have hPind : HasProd ((s : Set ℕ).mulIndicator f) (∏ n ∈ s, f n) :=
    hasProd_subtype_iff_mulIndicator.mp hPsub
  -- Divide the full product by the indicator: the quotient is the indicator
  -- of the complement.
  have hdiv : HasProd (fun n => f n / ((s : Set ℕ).mulIndicator f) n)
      ((∏' n, f n) / (∏ n ∈ s, f n)) :=
    hfull.hasProd.div₀ hPind hne
  have hfun : (fun n => f n / ((s : Set ℕ).mulIndicator f) n)
      = ((s : Set ℕ)ᶜ.mulIndicator f) := by
    funext n
    by_cases hn : n ∈ (s : Set ℕ)
    · rw [Set.mulIndicator_of_mem hn, Set.mulIndicator_of_notMem (by simpa using hn)]
      exact div_self (Finset.prod_ne_zero_iff.mp hne n (by simpa using hn))
    · rw [Set.mulIndicator_of_notMem hn, Set.mulIndicator_of_mem hn]
      simp
  have hind : HasProd (((s : Set ℕ)ᶜ).mulIndicator f)
      ((∏' n, f n) / (∏ n ∈ s, f n)) := by
    rw [← hfun]
    exact hdiv
  -- Transport back to the subtype of the complement.
  have hcomp : HasProd (f ∘ (↑) : ↑((s : Set ℕ)ᶜ) → ℂ)
      ((∏' n, f n) / (∏ n ∈ s, f n)) :=
    hasProd_subtype_iff_mulIndicator.mpr hind
  have hQ : (∏' n : ↑((s : Set ℕ))ᶜ, f ↑n)
      = (∏' n, f n) / (∏ n ∈ s, f n) := hcomp.tprod_eq
  have hQ' : (∏' n : {n // n ∉ s}, f n)
      = (∏' n, f n) / (∏ n ∈ s, f n) := hQ
  calc (∏' n, f n)
      = (∏ n ∈ s, f n) * ((∏' n, f n) / (∏ n ∈ s, f n)) :=
        (mul_div_cancel₀ _ hne).symm
    _ = (∏ n ∈ s, f n) * (∏' n : {n // n ∉ s}, f n) := by rw [← hQ']


set_option maxHeartbeats 2000000 in
/-- **The infinite canonical product has a simple zero at each prescribed
zero**, with the separation hypothesis only required off a finite set `s`
containing `k`. -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_at_zero_of_finset {a : ℕ → ℂ} {p : ℕ}
    {k : ℕ} {R : ℝ} (hR : 0 < R) (hkR : ‖a k‖ < R)
    (ha0 : ∀ n, a n ≠ 0)
    (s : Finset ℕ) (hk : k ∈ s)
    (hsep : ∀ n, n ∉ s → 2 * R ≤ ‖a n‖)
    (h : Summable (fun n : ℕ => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hdistinct : ∀ n, n ≠ k → a k ≠ a n) :
    meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) (a k) = 1 := by
  classical
  set Q : ℂ → ℂ := fun z => ∏' n : {n // n ∉ s}, weierstrassFactor p (z / a n) with hQ
  set G : ℂ → ℂ := fun z => ∏ n ∈ s, weierstrassFactor p (z / a n) with hG
  set H : ℂ → ℂ := fun z => ∏ n ∈ s.erase k, weierstrassFactor p (z / a n) with hH
  set F : ℂ → ℂ := G * Q with hF
  -- Analyticity of the complement product.
  have hQan : AnalyticOnNhd ℂ Q (Metric.ball 0 R) :=
    analyticOnNhd_tprod_weierstrassFactor_ball
      (a := fun n : {n // n ∉ s} => a n) (p := p) hR
      (fun n => ha0 n) (fun n => hsep n n.2) (h.subtype _)
  have hkball : a k ∈ Metric.ball (0 : ℂ) R := by
    rw [Metric.mem_ball, dist_eq_norm]
    simpa using hkR
  have hQat : AnalyticAt ℂ Q (a k) := hQan (a k) hkball
  -- Summability helpers.
  have hRsum : Summable (fun n : ℕ => R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    have := h.mul_left (Real.exp 1)⁻¹
    refine this.congr (fun n => ?_)
    field_simp
  have hsumk : Summable (fun n : ℕ => ‖a k‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
    intro n
    have hle : ‖a k‖ ^ (p + 1) ≤ R ^ (p + 1) :=
      pow_le_pow_left₀ (norm_nonneg _) (le_of_lt hkR) (p + 1)
    have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
    gcongr
  -- The complement product does not vanish at `a k`.
  have hQne : Q (a k) ≠ 0 := by
    have h1 : ∀ n : {n // n ∉ s}, 2 * ‖a k‖ ≤ ‖a n‖ := by
      intro n
      have := hsep n n.2
      nlinarith
    have h2 : ∀ n : {n // n ∉ s}, a k ≠ a n := by
      intro n
      exact hdistinct n (fun hnk => n.2 (hnk ▸ hk))
    exact tprod_weierstrassFactor_ne_zero
      (a := fun n : {n // n ∉ s} => a n) (p := p) (z := a k)
      (ha0 k) h1 (hsumk.subtype _) h2
  have hQorder : meromorphicOrderAt Q (a k) = 0 :=
    meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero hQat hQne
  -- The finite product over `s` is differentiable.
  have hGdiff : Differentiable ℂ G := by
    rw [hG]
    fun_prop
  have hHdiff : Differentiable ℂ H := by
    rw [hH]
    fun_prop
  have hHat : AnalyticAt ℂ H (a k) := hHdiff.analyticAt (a k)
  have hHne : H (a k) ≠ 0 := by
    rw [hH]
    apply Finset.prod_ne_zero_iff.mpr
    intro n hn
    have hnk : n ≠ k := Finset.ne_of_mem_erase hn
    have hane : a n ≠ 0 := ha0 n
    intro hfac
    apply hdistinct n hnk
    exact (div_eq_one_iff_eq hane).mp ((weierstrassFactor_eq_zero_iff p (a k / a n)).mp hfac)
  have hHorder : meromorphicOrderAt H (a k) = 0 :=
    meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero hHat hHne
  have hEorder : meromorphicOrderAt
      (fun z : ℂ => weierstrassFactor p (z / a k)) (a k) = 1 := by
    rw [meromorphicOrderAt_weierstrassFactor_div p (ha0 k) (a k)]
    rw [ite_eq_left rfl]
  have hGsplit : G = (fun z : ℂ => weierstrassFactor p (z / a k)) * H := by
    funext z
    simp only [hG, hH, Pi.mul_apply]
    exact (Finset.mul_prod_erase s (fun n => weierstrassFactor p (z / a n)) hk).symm
  have hGorder : meromorphicOrderAt G (a k) = 1 := by
    have hEat : AnalyticAt ℂ (fun z : ℂ => weierstrassFactor p (z / a k)) (a k) :=
      ((differentiable_weierstrassFactor p).comp
        (differentiable_id.div_const (a k))).analyticAt (a k)
    rw [hGsplit]
    have hmul := meromorphicOrderAt_mul
      (f := fun z : ℂ => weierstrassFactor p (z / a k)) (g := H) (x := a k)
      hEat.meromorphicAt hHat.meromorphicAt
    rw [hmul, hEorder, hHorder]
    norm_num
  have hForder : meromorphicOrderAt F (a k) = 1 := by
    rw [hF]
    have hmul := meromorphicOrderAt_mul
      (f := G) (g := Q) (x := a k)
      (hGdiff.analyticAt (a k)).meromorphicAt hQat.meromorphicAt
    rw [hmul, hGorder, hQorder]
    norm_num
  -- Pointwise splitting identity on the ball.
  have heq : ∀ z ∈ Metric.ball 0 R,
      (∏' n, weierstrassFactor p (z / a n)) = F z := by
    intro z hz
    by_cases hz0 : z = 0
    · subst hz0
      simp [hF, hG, hQ, weierstrassFactor_zero]
    · have hzR : ‖z‖ < R := by
        have := Metric.mem_ball.mp hz
        simpa [dist_eq_norm] using this
      have hsepz : ∀ n : {n // n ∉ s}, 2 * ‖z‖ ≤ ‖a n‖ := by
        intro n
        have := hsep n n.2
        nlinarith
      have hsumz : Summable (fun n : {n // n ∉ s} =>
          ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
        have hRsum' : Summable (fun n : {n // n ∉ s} =>
            R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := hRsum.subtype _
        apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum'
        intro n
        have hzle : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
          pow_le_pow_left₀ (norm_nonneg z) (le_of_lt hzR) (p + 1)
        have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
        gcongr
      have hcomp : HasProd
          (fun n : {n // n ∉ s} => weierstrassFactor p (z / a n)) (Q z) :=
        (multipliable_weierstrassFactor
          (a := fun n : {n // n ∉ s} => a n) hz0 hsepz hsumz).hasProd
      let e : {n // n ∈ ((s : Set ℕ))ᶜ} ≃ {n // n ∉ s} :=
        Equiv.subtypeEquivRight (fun n => by simp)
      have hcomp' : HasProd
          (fun n : {n // n ∈ ((s : Set ℕ))ᶜ} => weierstrassFactor p (z / a n)) (Q z) := by
        have hh := (Equiv.hasProd_iff e).mpr hcomp
        have hfun : ((fun n : {n // n ∉ s} => weierstrassFactor p (z / a n)) ∘ e)
            = fun n : {n // n ∈ ((s : Set ℕ))ᶜ} =>
                weierstrassFactor p (z / a n) := by
          funext n
          rfl
        rwa [hfun] at hh
      have hfin : HasProd (fun n : (s : Set ℕ) => weierstrassFactor p (z / a n)) (G z) := by
        rw [hG]
        exact Finset.hasProd s (fun n => weierstrassFactor p (z / a n))
      have hfull : HasProd (fun n => weierstrassFactor p (z / a n)) (G z * Q z) :=
        hfin.mul_compl hcomp'
      have hval : (∏' n, weierstrassFactor p (z / a n)) = G z * Q z :=
        hfull.multipliable.hasProd.unique hfull
      exact hval
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


/-- **The divisor of a finite product of elementary factors.**  The order at `a k`
of `∏_{n ∈ s} E_p(z / a n)` counts the multiplicity of the value `a k` among the
`a n` with `n ∈ s`. -/
theorem meromorphicOrderAt_finset_prod_weierstrassFactor_aux {a : ℕ → ℂ} {p : ℕ}
    (ha0 : ∀ n, a n ≠ 0) (s : Finset ℕ) (k : ℕ) :
    meromorphicOrderAt (fun z => ∏ n ∈ s, weierstrassFactor p (z / a n)) (a k)
      = (((s.filter (fun n => a n = a k)).card : ℕ) : ℤ) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
    have h1 : (fun z : ℂ => ∏ n ∈ (∅ : Finset ℕ), weierstrassFactor p (z / a n))
        = fun _ => (1 : ℂ) := by
      funext z
      simp
    rw [h1, meromorphicOrderAt_const]
    simp
  | insert m s hm ih =>
    have hSdiff : Differentiable ℂ
        (fun z : ℂ => ∏ n ∈ s, weierstrassFactor p (z / a n)) := by
      fun_prop
    have hsplit : (fun z : ℂ => ∏ n ∈ insert m s, weierstrassFactor p (z / a n))
        = (fun z : ℂ => weierstrassFactor p (z / a m))
          * (fun z : ℂ => ∏ n ∈ s, weierstrassFactor p (z / a n)) := by
      funext z
      simp only [Pi.mul_apply]
      rw [Finset.prod_insert hm]
    rw [hsplit, meromorphicOrderAt_mul]
    · rw [meromorphicOrderAt_weierstrassFactor_div p (ha0 m) (a k), ih,
        Finset.filter_insert]
      by_cases ham : a m = a k
      · rw [ite_eq_left ham.symm, ite_eq_left ham]
        have hnot : m ∉ s.filter (fun n => a n = a k) := by
          simp [Finset.mem_filter, hm]
        rw [Finset.card_insert_of_notMem hnot]
        have hcast : (1 : ℤ) + ((s.filter (fun n => a n = a k)).card : ℤ)
            = (((s.filter (fun n => a n = a k)).card + 1 : ℕ) : ℤ) := by
          push_cast
          ring
        rw [← WithTop.coe_one, ← WithTop.coe_add]
        exact congrArg (fun t : ℤ => (t : WithTop ℤ)) hcast
      · rw [ite_eq_right (fun h => ham h.symm), ite_eq_right ham]
        simp
    · exact ((differentiable_weierstrassFactor p).comp
        (differentiable_id.div_const (a m))).analyticAt (a k) |>.meromorphicAt
    · exact hSdiff.analyticAt (a k) |>.meromorphicAt

/-- **Order at a zero of the canonical product, with multiplicity.**  Off a finite
set `s` the zeros `a n` are distinct from `a k`, so only the finite product
contributes; its order is the multiplicity of `a k` among `{a n : n ∈ s}`. -/
theorem meromorphicOrderAt_tprod_weierstrassFactor_at_zero_of_finset_multiplicity
    {a : ℕ → ℂ} {p : ℕ} {k : ℕ} {R : ℝ} (hR : 0 < R) (hkR : ‖a k‖ < R)
    (ha0 : ∀ n, a n ≠ 0)
    (s : Finset ℕ) (hk : k ∈ s)
    (hsep : ∀ n, n ∉ s → 2 * R ≤ ‖a n‖)
    (h : Summable (fun n : ℕ => Real.exp 1 * R ^ (p + 1) / ‖a n‖ ^ (p + 1)))
    (hEk : ∀ n, n ∉ s → a k ≠ a n) :
    meromorphicOrderAt (fun z => ∏' n, weierstrassFactor p (z / a n)) (a k)
      = (((s.filter (fun n => a n = a k)).card : ℕ) : ℤ) := by
  classical
  have hkmem : k ∈ s.filter (fun n => a n = a k) := by
    simp [hk]
  set Q : ℂ → ℂ := fun z => ∏' n : {n // n ∉ s}, weierstrassFactor p (z / a n) with hQ
  set G : ℂ → ℂ := fun z => ∏ n ∈ s, weierstrassFactor p (z / a n) with hG
  set F : ℂ → ℂ := G * Q with hF
  -- Analyticity of the complement product.
  have hQan : AnalyticOnNhd ℂ Q (Metric.ball 0 R) :=
    analyticOnNhd_tprod_weierstrassFactor_ball
      (a := fun n : {n // n ∉ s} => a n) (p := p) hR
      (fun n => ha0 n) (fun n => hsep n n.2) (h.subtype _)
  have hkball : a k ∈ Metric.ball (0 : ℂ) R := by
    rw [Metric.mem_ball, dist_eq_norm]
    simpa using hkR
  have hQat : AnalyticAt ℂ Q (a k) := hQan (a k) hkball
  -- Summability helpers.
  have hRsum : Summable (fun n : ℕ => R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    have := h.mul_left (Real.exp 1)⁻¹
    refine this.congr (fun n => ?_)
    field_simp
  have hsumk : Summable (fun n : ℕ => ‖a k‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
    apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum
    intro n
    have hle : ‖a k‖ ^ (p + 1) ≤ R ^ (p + 1) :=
      pow_le_pow_left₀ (norm_nonneg _) (le_of_lt hkR) (p + 1)
    have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
    gcongr
  -- The complement product does not vanish at `a k`.
  have hQne : Q (a k) ≠ 0 := by
    have h1 : ∀ n : {n // n ∉ s}, 2 * ‖a k‖ ≤ ‖a n‖ := by
      intro n
      have := hsep n n.2
      nlinarith
    have h2 : ∀ n : {n // n ∉ s}, a k ≠ a n := by
      intro n
      exact hEk n n.2
    exact tprod_weierstrassFactor_ne_zero
      (a := fun n : {n // n ∉ s} => a n) (p := p) (z := a k)
      (ha0 k) h1 (hsumk.subtype _) h2
  have hQorder : meromorphicOrderAt Q (a k) = 0 :=
    meromorphicOrderAt_eq_zero_of_analyticAt_ne_zero hQat hQne
  -- The finite product over `s` is differentiable.
  have hGdiff : Differentiable ℂ G := by
    rw [hG]
    fun_prop
  -- Its order at `a k` is the multiplicity of the value `a k`.
  have hGorder : meromorphicOrderAt G (a k)
      = (((s.filter (fun n => a n = a k)).card : ℕ) : ℤ) := by
    rw [hG]
    exact meromorphicOrderAt_finset_prod_weierstrassFactor_aux ha0 s k
  have hForder : meromorphicOrderAt F (a k)
      = (((s.filter (fun n => a n = a k)).card : ℕ) : ℤ) := by
    rw [hF]
    have hmul := meromorphicOrderAt_mul
      (f := G) (g := Q) (x := a k)
      (hGdiff.analyticAt (a k)).meromorphicAt hQat.meromorphicAt
    rw [hmul, hGorder, hQorder]
    simp
  -- Pointwise splitting identity on the ball.
  have heq : ∀ z ∈ Metric.ball 0 R,
      (∏' n, weierstrassFactor p (z / a n)) = F z := by
    intro z hz
    by_cases hz0 : z = 0
    · subst hz0
      simp [hF, hG, hQ, weierstrassFactor_zero]
    · have hzR : ‖z‖ < R := by
        have := Metric.mem_ball.mp hz
        simpa [dist_eq_norm] using this
      have hsepz : ∀ n : {n // n ∉ s}, 2 * ‖z‖ ≤ ‖a n‖ := by
        intro n
        have := hsep n n.2
        nlinarith
      have hsumz : Summable (fun n : {n // n ∉ s} =>
          ‖z‖ ^ (p + 1) / ‖a n‖ ^ (p + 1)) := by
        have hRsum' : Summable (fun n : {n // n ∉ s} =>
            R ^ (p + 1) / ‖a n‖ ^ (p + 1)) := hRsum.subtype _
        apply Summable.of_nonneg_of_le (fun n => by positivity) ?_ hRsum'
        intro n
        have hzle : ‖z‖ ^ (p + 1) ≤ R ^ (p + 1) :=
          pow_le_pow_left₀ (norm_nonneg z) (le_of_lt hzR) (p + 1)
        have hden : (0 : ℝ) ≤ ‖a n‖ ^ (p + 1) := by positivity
        gcongr
      have hcomp : HasProd
          (fun n : {n // n ∉ s} => weierstrassFactor p (z / a n)) (Q z) :=
        (multipliable_weierstrassFactor
          (a := fun n : {n // n ∉ s} => a n) hz0 hsepz hsumz).hasProd
      let e : {n // n ∈ ((s : Set ℕ))ᶜ} ≃ {n // n ∉ s} :=
        Equiv.subtypeEquivRight (fun n => by simp)
      have hcomp' : HasProd
          (fun n : {n // n ∈ ((s : Set ℕ))ᶜ} => weierstrassFactor p (z / a n)) (Q z) := by
        have hh := (Equiv.hasProd_iff e).mpr hcomp
        have hfun : ((fun n : {n // n ∉ s} => weierstrassFactor p (z / a n)) ∘ e)
            = fun n : {n // n ∈ ((s : Set ℕ))ᶜ} =>
                weierstrassFactor p (z / a n) := by
          funext n
          rfl
        rwa [hfun] at hh
      have hfin : HasProd (fun n : (s : Set ℕ) => weierstrassFactor p (z / a n)) (G z) := by
        rw [hG]
        exact Finset.hasProd s (fun n => weierstrassFactor p (z / a n))
      have hfull : HasProd (fun n => weierstrassFactor p (z / a n)) (G z * Q z) :=
        hfin.mul_compl hcomp'
      have hval : (∏' n, weierstrassFactor p (z / a n)) = G z * Q z :=
        hfull.multipliable.hasProd.unique hfull
      exact hval
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


/-- **The log-growth hypothesis of the Hadamard factorisation is automatic once
the factorisation holds**: if `ξ₀ = P·e^{a+bz}` with `P` zero-free, then the
quotient `ξ₀/P = e^{a+bz}` has order-1 log-growth. So the only non-automatic
input of `factorization_of_xi₀` is the enumeration and the divisor match. -/
theorem hasLogGrowthOne_quotient_of_factorization {P : ℂ → ℂ} {a b : ℂ}
    (hP : ∀ z, P z ≠ 0)
    (hfac : ∀ z, xi₀ z = P z * cexp (a + b * z)) :
    HasLogGrowthOne (fun z : ℂ => xi₀ z / P z) := by
  have hEq : (fun z : ℂ => xi₀ z / P z) = fun z => cexp (a + b * z) := by
    funext z
    rw [hfac z]
    field_simp [hP z]
  rw [hEq]
  exact hasLogGrowthOne_cexp_affine a b


/-- **An enumeration of the zero set of `ξ₀` by `ℕ`**, with all terms nonzero
(no zero of `ξ₀` is `0`, since `ξ₀ 0 = 1`). Conditional on the zero set being
nonempty (which is a numerical fact about the actual zeros, not yet
formalised). -/
theorem exists_enumeration_zeros (hne : ({z : ℂ | xi₀ z = 0} : Set ℂ).Nonempty) :
    ∃ a : ℕ → ℂ, (∀ n, a n ≠ 0) ∧ Set.range a = {z : ℂ | xi₀ z = 0} := by
  obtain ⟨a, ha⟩ := Set.Countable.exists_eq_range xi₀_zeros_countable hne
  refine ⟨a, fun n => ?_, ha.symm⟩
  intro h0
  have hmem : (0 : ℂ) ∈ Set.range a := h0 ▸ Set.mem_range_self n
  rw [← ha] at hmem
  simp only [Set.mem_setOf_eq] at hmem
  have h1 : xi₀ 0 = 1 := by
    unfold xi₀
    ring
  rw [h1] at hmem
  exact one_ne_zero hmem


open Filter in open scoped Topology in
/-- **Digamma growth along the naturals**: `Re ψ(n+1) = H_n − γ → ∞`. This is
the analytic input for showing that `ξ₀` has infinitely many zeros (note 68):
along the real axis `−arch(σ) = −(1/2)log π + (1/2)ψ(σ/2) → ∞`. -/
theorem tendsto_digamma_nat_re_atTop :
    Tendsto (fun n : ℕ => (Complex.digamma ((n : ℂ) + 1)).re) atTop atTop := by
  have hval : ∀ n : ℕ, (Complex.digamma ((n : ℂ) + 1)).re
      = (harmonic n : ℝ) - Real.eulerMascheroniConstant := by
    intro n
    rw [Complex.digamma_nat_add_one n]
    simp
  simp_rw [hval]
  have hlog : Tendsto (fun n : ℕ => Real.log (n : ℝ)) atTop atTop :=
    Real.tendsto_log_atTop.comp tendsto_natCast_atTop_atTop
  have hsub : Tendsto (fun n : ℕ => (harmonic n : ℝ) - Real.log (n : ℝ)) atTop
      (𝓝 Real.eulerMascheroniConstant) :=
    Real.tendsto_harmonic_sub_log
  have hH : Tendsto (fun n : ℕ => (harmonic n : ℝ)) atTop atTop := by
    have h' : Tendsto (fun n : ℕ => ((harmonic n : ℝ) - Real.log (n : ℝ))
        + Real.log (n : ℝ)) atTop atTop := hsub.add_atTop hlog
    refine h'.congr (fun n => ?_)
    ring
  have hH2 : Tendsto (fun n : ℕ => (harmonic n : ℝ) + (-Real.eulerMascheroniConstant))
      atTop atTop :=
    tendsto_atTop_add_const_right atTop (-Real.eulerMascheroniConstant) hH
  simpa [sub_eq_add_neg] using hH2



/-- **The scaled elementary factor has order-1 log-growth**:
`log ‖E_1(z/a)‖ ≤ (2/‖a‖)‖z‖ + log 2`. This is a component estimate for the
canonical-product side of the Hadamard factorisation. -/
theorem hasLogGrowthOne_weierstrassFactor_one_div {a : ℂ} (ha : a ≠ 0) :
    HasLogGrowthOne (fun z : ℂ => weierstrassFactor 1 (z / a)) := by
  have hanorm : 0 < ‖a‖ := norm_pos_iff.mpr ha
  refine ⟨2 / ‖a‖, Real.log 2, by positivity, fun z => ?_⟩
  beta_reduce
  have hfac : weierstrassFactor 1 (z / a) = (1 - z / a) * cexp (z / a) := by
    simp [weierstrassFactor, Finset.sum_range_one]
  rw [hfac]
  by_cases hzero : (1 - z / a) * cexp (z / a) = 0
  · rw [hzero, norm_zero, Real.log_zero]
    have h2 : (0 : ℝ) ≤ 2 / ‖a‖ * ‖z‖ := by positivity
    have h3 : (0 : ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
    linarith
  · have hnorm : ‖(1 - z / a) * cexp (z / a)‖
        = ‖1 - z / a‖ * Real.exp (z / a).re := by
      rw [norm_mul, Complex.norm_exp]
    rw [hnorm]
    have h1w : ‖1 - z / a‖ ≤ 1 + ‖z / a‖ := by
      calc ‖1 - z / a‖ ≤ ‖(1 : ℂ)‖ + ‖z / a‖ := norm_sub_le _ _
        _ = 1 + ‖z / a‖ := by rw [norm_one]
    have hpos1 : (0 : ℝ) < ‖1 - z / a‖ := by
      have h1 : (0 : ℝ) ≤ ‖1 - z / a‖ := norm_nonneg _
      rcases h1.eq_or_lt with h | h'
      · exfalso
        apply hzero
        have hzero1 : (1 - z / a) = 0 := norm_eq_zero.mp h.symm
        rw [hzero1, zero_mul]
      · exact h' 
    have hlog : Real.log (‖1 - z / a‖ * Real.exp (z / a).re)
        = Real.log ‖1 - z / a‖ + (z / a).re := by
      rw [Real.log_mul (ne_of_gt hpos1) (Real.exp_ne_zero _), Real.log_exp]
    rw [hlog]
    have hlog1 : Real.log ‖1 - z / a‖ ≤ ‖z / a‖ := by
      have h2 : Real.log ‖1 - z / a‖ ≤ Real.log (1 + ‖z / a‖) :=
        Real.log_le_log hpos1 h1w
      have h3 : Real.log (1 + ‖z / a‖) ≤ ‖z / a‖ := by
        have := Real.log_le_sub_one_of_pos (by linarith : (0:ℝ) < 1 + ‖z / a‖)
        linarith
      linarith
    have hza : ‖z / a‖ = ‖z‖ / ‖a‖ := norm_div _ _
    have h2 : 2 / ‖a‖ * ‖z‖ = 2 * (‖z‖ / ‖a‖) := by ring
    rw [h2]
    have hre' : (z / a).re ≤ ‖z‖ / ‖a‖ := by
      rw [← hza]
      exact Complex.re_le_norm _
    have hlog1' : Real.log ‖1 - z / a‖ ≤ ‖z‖ / ‖a‖ := by
      rw [← hza]
      exact hlog1
    have hlog2 : (0 : ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
    linarith


/-- **Products of order-1 log-growth functions have order-1 log-growth**, with no
zero-free hypothesis (at a zero the bound is trivial since `log 0 = 0`). This
generalises `hasLogGrowthOne_finset_prod` to factors with zeros, which is what
the canonical products need. -/
theorem hasLogGrowthOne_mul_of_logGrowth {f g : ℂ → ℂ}
    (hf : HasLogGrowthOne f) (hg : HasLogGrowthOne g) :
    HasLogGrowthOne (fun z => f z * g z) := by
  obtain ⟨A1, B1, hA1, h1⟩ := hf
  obtain ⟨A2, B2, hA2, h2⟩ := hg
  refine ⟨A1 + A2, max B1 0 + max B2 0, by positivity, fun z => ?_⟩
  beta_reduce
  have h1' : Real.log ‖f z‖ ≤ A1 * ‖z‖ + max B1 0 :=
    le_trans (h1 z) (by linarith [le_max_left B1 (0 : ℝ)])
  have h2' : Real.log ‖g z‖ ≤ A2 * ‖z‖ + max B2 0 :=
    le_trans (h2 z) (by linarith [le_max_left B2 (0 : ℝ)])
  have hB : (0 : ℝ) ≤ max B1 0 + max B2 0 := by positivity
  by_cases hz : f z * g z = 0
  · rw [hz, norm_zero, Real.log_zero]
    nlinarith [norm_nonneg z]
  · have hfz : f z ≠ 0 := fun h => hz (by rw [h, zero_mul])
    have hgz : g z ≠ 0 := fun h => hz (by rw [h, mul_zero])
    rw [norm_mul, Real.log_mul (norm_ne_zero_iff.mpr hfz) (norm_ne_zero_iff.mpr hgz)]
    nlinarith

/-- Finite products of order-1 log-growth functions. -/
theorem hasLogGrowthOne_finset_prod_of_logGrowth {ι : Type*} (s : Finset ι) (Q : ι → ℂ → ℂ)
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
    have h1 : (fun z : ℂ => ∏ i ∈ insert a s, Q i z)
        = fun z => Q a z * ∏ i ∈ s, Q i z := by
      funext z
      rw [Finset.prod_insert ha]
    rw [h1]
    exact hasLogGrowthOne_mul_of_logGrowth (h a (Finset.mem_insert_self a s))
      (ih (fun i hi => h i (Finset.mem_insert_of_mem hi)))



/-- **The log-derivative of `e^g` is `g'`** — the elementary identity underlying
the zero-free-function step of the Hadamard factorisation. -/
theorem logDeriv_cexp_comp {g : ℂ → ℂ} {z : ℂ} (hg : DifferentiableAt ℂ g z) :
    logDeriv (fun w : ℂ => cexp (g w)) z = deriv g z := by
  rw [logDeriv_apply, deriv_cexp hg]
  field_simp


/-- **`z ↦ z(z−1)` has order-1 log-growth** — the polynomial prefactor of the
completed zeta satisfies the log-growth hypothesis. -/
theorem hasLogGrowthOne_mul_sub_one : HasLogGrowthOne (fun z : ℂ => z * (z - 1)) := by
  have h1 : HasLogGrowthOne (fun z : ℂ => z) := hasLogGrowthOne_id
  have h2 : HasLogGrowthOne (fun z : ℂ => (-1 : ℂ) + 1 * z) := hasLogGrowthOne_affine (-1) 1
  have h := hasLogGrowthOne_mul_of_logGrowth h1 h2
  convert h using 1
  · ext z
    ring


/-- **A bound on the log-derivative of the scaled elementary factor**:
`‖(E_1(·/a))'/(E_1(·/a))‖(z) ≤ 1/‖a‖ + 1/‖z−a‖`. This is the estimate used
when bounding `P'/P` for a finite canonical product on a region away from the
prescribed zeros. -/
theorem norm_logDeriv_weierstrassFactor_one_div_le {a z : ℂ} (ha : a ≠ 0) (hz : z ≠ a) :
    ‖logDeriv (fun w : ℂ => weierstrassFactor 1 (w / a)) z‖
      ≤ 1 / ‖a‖ + 1 / ‖z - a‖ := by
  have hw : DifferentiableAt ℂ (fun w : ℂ => w / a) z := by fun_prop
  have hE : DifferentiableAt ℂ (weierstrassFactor 1) (z / a) :=
    (differentiable_weierstrassFactor 1).differentiableAt
  have hcomp : logDeriv (fun w : ℂ => weierstrassFactor 1 (w / a)) z
      = logDeriv (weierstrassFactor 1) (z / a) * deriv (fun w : ℂ => w / a) z := by
    have h := logDeriv_comp (f := weierstrassFactor 1) (g := fun w : ℂ => w / a) (x := z) hE hw
    have heq : (weierstrassFactor 1 ∘ fun w : ℂ => w / a)
        = fun w => weierstrassFactor 1 (w / a) := rfl
    rw [heq] at h
    exact h
  rw [hcomp]
  have hderiv : deriv (fun w : ℂ => w / a) z = 1 / a := by
    have h := deriv_div_const (c := fun w : ℂ => w) (x := z) a
    simpa using h
  rw [hderiv]
  have hzag : z / a ≠ 1 := by
    intro h
    apply hz
    have h2 : z = 1 * a := (div_eq_iff ha).mp h
    simpa [one_mul] using h2
  have hlogder : logDeriv (weierstrassFactor 1) (z / a) = -(z / a) / (1 - z / a) := by
    rw [logDeriv_weierstrassFactor 1 (z / a) hzag]
    simp only [Finset.sum_range_one]
    have h1mz : (1 : ℂ) - z / a ≠ 0 := sub_ne_zero.mpr (Ne.symm hzag)
    field_simp [h1mz]
    ring
  rw [hlogder]
  have hapos : (0 : ℝ) < ‖a‖ := norm_pos_iff.mpr ha
  have hzapos : (0 : ℝ) < ‖z - a‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hz)
  have hnorm1 : ‖(1 : ℂ) - z / a‖ = ‖z - a‖ / ‖a‖ := by
    have h1mz : (1 : ℂ) - z / a = (a - z) / a := by field_simp
    rw [h1mz, norm_div, norm_sub_rev a z]
  have hnz : ‖z / a‖ = ‖z‖ / ‖a‖ := norm_div _ _
  have hnorm_inv : ‖(1 : ℂ) / a‖ = 1 / ‖a‖ := by
    rw [norm_div, norm_one]
  rw [norm_mul, norm_div, norm_neg, hnz, hnorm1, hnorm_inv]
  have hsimplify : ‖z‖ / ‖a‖ / (‖z - a‖ / ‖a‖) * (1 / ‖a‖)
      = ‖z‖ / (‖a‖ * ‖z - a‖) := by
    field_simp [ne_of_gt hapos, ne_of_gt hzapos]
  rw [hsimplify]
  have hza : ‖z‖ ≤ ‖z - a‖ + ‖a‖ := by
    have h := norm_add_le (z - a) a
    simpa using h
  have hden : (0 : ℝ) < ‖a‖ * ‖z - a‖ := mul_pos hapos hzapos
  have hstep2 : (‖z - a‖ + ‖a‖) / (‖a‖ * ‖z - a‖) = 1 / ‖a‖ + 1 / ‖z - a‖ := by
    field_simp
  calc ‖z‖ / (‖a‖ * ‖z - a‖)
      ≤ (‖z - a‖ + ‖a‖) / (‖a‖ * ‖z - a‖) :=
        div_le_div_of_nonneg_right hza (le_of_lt hden)
    _ = 1 / ‖a‖ + 1 / ‖z - a‖ := hstep2


/-- **A `P'/P` bound for the finite canonical product of genus 1**: away from the
prescribed zeros, the log-derivative is dominated by the sum of the individual
factor bounds. -/
theorem norm_logDeriv_finiteCanonicalProduct_one_le (S : Finset ℂ)
    (h0 : ∀ a ∈ S, a ≠ 0) {z : ℂ} (hz : ∀ a ∈ S, z ≠ a) :
    ‖logDeriv (finiteCanonicalProduct 1 S) z‖
      ≤ ∑ a ∈ S, (1 / ‖a‖ + 1 / ‖z - a‖) := by
  have hfun : finiteCanonicalProduct 1 S
      = fun w => ∏ a ∈ S, weierstrassFactor 1 (w / a) := rfl
  rw [hfun]
  have hne : ∀ a ∈ S, weierstrassFactor 1 (z / a) ≠ 0 := by
    intro a ha
    have hza : z / a ≠ 1 := by
      intro h
      apply hz a ha
      have h2 : z = 1 * a := (div_eq_iff (h0 a ha)).mp h
      simpa [one_mul] using h2
    have hfac : weierstrassFactor 1 (z / a) = (1 - z / a) * cexp (z / a) := by
      simp [weierstrassFactor]
    rw [hfac]
    refine mul_ne_zero ?_ (Complex.exp_ne_zero _)
    intro h
    apply hza
    linear_combination -h
  have hdiff : ∀ a ∈ S, DifferentiableAt ℂ (fun w : ℂ => weierstrassFactor 1 (w / a)) z := by
    intro a ha
    exact ((differentiable_weierstrassFactor 1).comp
      (differentiable_id.div_const a)).differentiableAt
  have hprod : (fun w : ℂ => ∏ a ∈ S, weierstrassFactor 1 (w / a))
      = ∏ a ∈ S, fun w : ℂ => weierstrassFactor 1 (w / a) := by
    funext w
    simp
  rw [hprod, logDeriv_prod hne hdiff]
  calc ‖∑ a ∈ S, logDeriv (fun w : ℂ => weierstrassFactor 1 (w / a)) z‖
      ≤ ∑ a ∈ S, ‖logDeriv (fun w : ℂ => weierstrassFactor 1 (w / a)) z‖ :=
        norm_sum_le S _
    _ ≤ ∑ a ∈ S, (1 / ‖a‖ + 1 / ‖z - a‖) :=
        Finset.sum_le_sum (fun a ha =>
          norm_logDeriv_weierstrassFactor_one_div_le (h0 a ha) (hz a ha))


/-- **`P'/P` is bounded away from the prescribed zeros**: if `z` is at distance at
least `δ` from every zero in the finite set `S`, the log-derivative of the
finite canonical product is bounded by `∑_{a∈S}(1/‖a‖ + 1/δ)`. -/
theorem norm_logDeriv_finiteCanonicalProduct_one_le_of_dist (S : Finset ℂ)
    (h0 : ∀ a ∈ S, a ≠ 0) {δ : ℝ} (hδ : 0 < δ) {z : ℂ}
    (hz : ∀ a ∈ S, δ ≤ ‖z - a‖) :
    ‖logDeriv (finiteCanonicalProduct 1 S) z‖
      ≤ ∑ a ∈ S, (1 / ‖a‖ + 1 / δ) := by
  refine (norm_logDeriv_finiteCanonicalProduct_one_le S h0
    (fun a ha h => ?_)).trans (Finset.sum_le_sum (fun a ha => ?_))
  · have := hz a ha
    simp [h] at this
    linarith
  · have h1 : (0 : ℝ) < ‖z - a‖ := norm_pos_iff.mpr (fun h => by
      have := hz a ha
      simp [h] at this
      linarith)
    have : 1 / ‖z - a‖ ≤ 1 / δ := by
      apply one_div_le_one_div_of_le hδ (hz a ha)
    linarith

/-!
## Growth of `Re (Z'/Z)` along the even integers

The symbol identity gives, for `s = 2m+2`,

`Re (Z'/Z) = -(1/2) log π + (1/2) Re ψ(s/2) - Re (L_Λ s)`,

and `Re (L_Λ s)` is bounded independently of `m` by the absolutely convergent
majorant at `s = 2`.  Since `Re ψ(m+1) → +∞`, the real part of the logarithmic
derivative of the completed zeta function tends to `+∞` along `2m+2`.
-/

open Filter

open AbsoluteHodgeSymbol

/-- A uniform upper bound for the von Mangoldt L-series along the real points
`2m+2`. -/
noncomputable def vonMangoldtBound : ℝ :=
  ∑' n, ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 : ℂ) n‖

lemma vonMangoldtBound_nonneg : 0 ≤ vonMangoldtBound := tsum_nonneg (fun _ => norm_nonneg _)

lemma vonMangoldtBound_bound (m : ℕ) :
    ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 * m + 2 : ℕ) : ℂ))‖
      ≤ vonMangoldtBound := by
  have hsumm2 : LSeriesSummable (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 : ℂ) :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt (by norm_num)
  have h2 : ((2 : ℂ)).re = 2 := by
    rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num]
    simp
  have hre : ((2 : ℂ)).re ≤ (((2 * m + 2 : ℕ) : ℂ)).re := by
    rw [h2]
    simp only [Complex.natCast_re]
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    push_cast
    linarith
  have hsumm : LSeriesSummable (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (((2 * m + 2 : ℕ) : ℂ)) := hsumm2.of_re_le_re hre
  calc ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (((2 * m + 2 : ℕ) : ℂ))‖
      = ‖∑' n, LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (((2 * m + 2 : ℕ) : ℂ)) n‖ := rfl
    _ ≤ ∑' n, ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (((2 * m + 2 : ℕ) : ℂ)) n‖ := norm_tsum_le_tsum_norm hsumm.norm
    _ ≤ ∑' n, ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 : ℂ) n‖ := by
        refine Summable.tsum_le_tsum (fun n => ?_) hsumm.norm hsumm2.norm
        exact LSeries.norm_term_le_of_re_le_re _ hre n
    _ = vonMangoldtBound := rfl

/-- The real part of `logDeriv Z s` at `s = 2m+2`, with the L-series isolated. -/
lemma re_logDeriv_completedZeta_even (m : ℕ) :
    (logDeriv completedZeta (((2 * m + 2 : ℕ) : ℂ))).re
      = -(1 / 2) * Real.log Real.pi
        + (1 / 2) * (Complex.digamma ((((2 * m + 2 : ℕ) : ℂ)) / 2)).re
        - (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
            (((2 * m + 2 : ℕ) : ℂ))).re := by
  set s : ℂ := ((2 * m + 2 : ℕ) : ℂ) with hsdef
  have hs : 1 < s.re := by
    rw [hsdef]
    simp only [Complex.natCast_re]
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    push_cast
    linarith
  have h := congrArg Complex.re (symbol_identity (s := s) hs)
  have hhalf : (1 / 2 : ℂ) = ((1 / 2 : ℝ) : ℂ) := by norm_num
  simp only [Complex.neg_re, Complex.add_re, Complex.sub_re, Complex.mul_re,
    hhalf, Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero,
    Complex.log_ofReal_re] at h
  linarith

/-- The pointwise lower bound: the (negated) L-series term is uniformly bounded
below by `-vonMangoldtBound`. -/
lemma lower_bound_logDeriv_completedZeta_even (m : ℕ) :
    -(1 / 2) * Real.log Real.pi
        + (1 / 2) * (Complex.digamma (((m : ℂ) + 1))).re - vonMangoldtBound
      ≤ (logDeriv completedZeta (((2 * m + 2 : ℕ) : ℂ))).re := by
  set s : ℂ := ((2 * m + 2 : ℕ) : ℂ) with hsdef
  have hs2 : s / 2 = ((m : ℂ) + 1) := by
    rw [hsdef]
    push_cast
    ring
  have hb : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s‖ ≤ vonMangoldtBound := vonMangoldtBound_bound m
  have h1 : (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s).re
      ≤ ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s‖ :=
    (abs_le.mp (Complex.abs_re_le_norm _)).2
  have h := re_logDeriv_completedZeta_even m
  rw [hs2] at h
  rw [← hsdef] at h
  linarith

/-- **The growth theorem**: `Re (Z'/Z)` tends to `+∞` along the even integers. -/
theorem tendsto_logDeriv_completedZeta_re_atTop :
    Tendsto (fun m : ℕ => (logDeriv AbsoluteHodgeSymbol.completedZeta
      ((2 * m + 2 : ℕ) : ℂ)).re) atTop atTop := by
  have hd : Tendsto (fun m : ℕ => (Complex.digamma ((m : ℂ) + 1)).re) atTop atTop :=
    tendsto_digamma_nat_re_atTop
  have hmul : Tendsto (fun m : ℕ => (1 / 2 : ℝ) * (Complex.digamma ((m : ℂ) + 1)).re)
      atTop atTop := by
    rw [tendsto_atTop]
    intro b
    filter_upwards [tendsto_atTop.1 hd (2 * b)] with m hm
    linarith
  have hshift : Tendsto (fun y : ℝ => y - (vonMangoldtBound + (1 / 2 : ℝ) * Real.log Real.pi))
      atTop atTop := by
    rw [tendsto_atTop]
    intro b
    filter_upwards [tendsto_atTop.1 (tendsto_id : Tendsto (fun y : ℝ => y) atTop atTop)
      (b + (vonMangoldtBound + (1 / 2 : ℝ) * Real.log Real.pi))] with y hy
    have hy' : b + (vonMangoldtBound + (1 / 2 : ℝ) * Real.log Real.pi) ≤ y := by
      simpa only [id_eq] using hy
    linarith
  have hcomp : Tendsto (fun m : ℕ => (1 / 2 : ℝ) * (Complex.digamma ((m : ℂ) + 1)).re
      - (vonMangoldtBound + (1 / 2 : ℝ) * Real.log Real.pi)) atTop atTop :=
    hshift.comp hmul
  refine tendsto_atTop_mono (fun m => ?_) hcomp
  have hk := lower_bound_logDeriv_completedZeta_even m
  linarith


/-- **Bounded real part forces constancy** (`e^g` bounded ⇒ `g' = 0` ⇒ `g`
constant). This is the order-0 case of the zero-free fine-order theorem: it is
the statement that a zero-free entire function with bounded logarithmic growth
(log `‖h‖ ≤ B`, i.e. `Re log h` bounded above) is `e^constant`. -/
theorem eq_const_of_bddAbove_re {g : ℂ → ℂ} (hg : Differentiable ℂ g)
    (hb : BddAbove (Set.range (fun z => (g z).re))) :
    ∃ c : ℂ, ∀ z, g z = c := by
  obtain ⟨M, hM⟩ := hb
  have hbdd : Bornology.IsBounded (Set.range (fun z => cexp (g z))) := by
    rw [Metric.isBounded_iff_subset_closedBall (0 : ℂ)]
    refine ⟨Real.exp M, ?_⟩
    rintro _ ⟨z, rfl⟩
    rw [Metric.mem_closedBall, dist_zero_right, Complex.norm_exp]
    exact Real.exp_le_exp.mpr (hM ⟨z, rfl⟩)
  have hdiff : Differentiable ℂ (fun z => cexp (g z)) := Complex.differentiable_exp.comp hg
  obtain ⟨c, hc⟩ := hdiff.exists_eq_const_of_bounded hbdd
  have hderiv0 : ∀ z, deriv g z = 0 := by
    intro z
    have hconst : (fun w : ℂ => cexp (g w)) = fun _ => c := hc
    have hd : deriv (fun w : ℂ => cexp (g w)) z = 0 := by
      rw [hconst]
      simp
    rw [deriv_cexp (hg z)] at hd
    rcases mul_eq_zero.mp hd with h | h
    · exact absurd h (Complex.exp_ne_zero (g z))
    · exact h
  refine ⟨g 0, fun z => ?_⟩
  exact is_const_of_deriv_eq_zero hg hderiv0 z 0

open Filter in
open scoped Topology in
/-- **Sub-quadratic real-part growth forces affinity** (Borel–Carathéodory plus
Cauchy estimates): an entire function whose real part grows at most like
`A * ‖z‖ ^ p + B` with `1 < p < 2` is affine. -/
theorem subquadratic_eq_affine_of_re_le_rpow {g : ℂ → ℂ} (hg : Differentiable ℂ g)
    {A B p : ℝ} (hA : 0 ≤ A) (hp1 : 1 < p) (hp2 : p < 2)
    (h : ∀ z, (g z).re ≤ A * ‖z‖ ^ p + B) :
    ∃ a b : ℂ, ∀ z, g z = a + b * z := by
  have hp0 : (0 : ℝ) ≤ p := by linarith
  -- Step 1: all higher derivatives at 0 vanish.
  have hzero : ∀ k : ℕ, 2 ≤ k → iteratedDeriv k g 0 = 0 := by
    intro k hk
    have hk2 : (2 : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
    -- (i) Borel–Carathéodory bound on the closed ball of radius R/2.
    have hbound : ∀ R : ℝ, 0 < R → ∀ z : ℂ, ‖z‖ ≤ R / 2 →
        ‖g z‖ ≤ 2 * A * R ^ p + (2 * |B| + 2 + 3 * ‖g 0‖) := by
      intro R hR z hz
      set M := max (A * R ^ p + B) 1 with hMdef
      have hM : 0 < M := lt_of_lt_of_le zero_lt_one (le_max_right _ _)
      have hmaps : Set.MapsTo g (Metric.ball 0 R) {w : ℂ | w.re ≤ M} := by
        intro w hw
        have hwR : ‖w‖ < R := by
          have := Metric.mem_ball.mp hw
          simpa [dist_eq_norm] using this
        have hwle : ‖w‖ ^ p ≤ R ^ p :=
          Real.rpow_le_rpow (norm_nonneg w) hwR.le hp0
        calc (g w).re ≤ A * ‖w‖ ^ p + B := h w
          _ ≤ A * R ^ p + B := by nlinarith [hA, hwle]
          _ ≤ M := le_max_left _ _
      have hzball : z ∈ Metric.ball (0 : ℂ) R := by
        rw [Metric.mem_ball, dist_eq_norm]
        simpa using lt_of_le_of_lt hz (by linarith : R / 2 < R)
      have hBC := Complex.borelCaratheodory hM hg.differentiableOn hmaps hR hzball
      have hden : 0 < R - ‖z‖ := by linarith [norm_nonneg z]
      have h1 : ‖z‖ / (R - ‖z‖) ≤ 1 := by
        rw [div_le_one hden]; linarith
      have h2 : (R + ‖z‖) / (R - ‖z‖) ≤ 3 := by
        rw [div_le_iff₀ hden]; linarith [norm_nonneg z]
      have h3 : 2 * M * ‖z‖ / (R - ‖z‖) ≤ 2 * M := by
        have he : 2 * M * ‖z‖ / (R - ‖z‖) = 2 * M * (‖z‖ / (R - ‖z‖)) := by
          field_simp
        rw [he]
        simpa using mul_le_mul_of_nonneg_left h1 (by linarith : (0 : ℝ) ≤ 2 * M)
      have h4 : ‖g 0‖ * (R + ‖z‖) / (R - ‖z‖) ≤ 3 * ‖g 0‖ := by
        have he : ‖g 0‖ * (R + ‖z‖) / (R - ‖z‖)
            = ‖g 0‖ * ((R + ‖z‖) / (R - ‖z‖)) := by field_simp
        rw [he]
        simpa [mul_comm] using mul_le_mul_of_nonneg_left h2 (norm_nonneg (g 0))
      have hMle : M ≤ A * R ^ p + |B| + 1 := by
        rw [hMdef]
        apply max_le
        · nlinarith [le_abs_self B]
        · have hRp : (0 : ℝ) < R ^ p := Real.rpow_pos_of_pos hR p
          nlinarith [abs_nonneg B]
      calc ‖g z‖
          ≤ 2 * M * ‖z‖ / (R - ‖z‖) + ‖g 0‖ * (R + ‖z‖) / (R - ‖z‖) := hBC
        _ ≤ 2 * M + 3 * ‖g 0‖ := by linarith
        _ ≤ 2 * (A * R ^ p + |B| + 1) + 3 * ‖g 0‖ := by linarith
        _ = 2 * A * R ^ p + (2 * |B| + 2 + 3 * ‖g 0‖) := by ring
    -- (ii) Cauchy's estimate.
    have hcauchy : ∀ R : ℝ, 0 < R → ‖iteratedDeriv k g 0‖ ≤
        (k.factorial : ℝ) * (2 * A * R ^ p + (2 * |B| + 2 + 3 * ‖g 0‖)) / (R / 2) ^ k := by
      intro R hR
      have hR2 : (0 : ℝ) < R / 2 := by linarith
      have hsphere : ∀ w ∈ Metric.sphere (0 : ℂ) (R / 2),
          ‖g w‖ ≤ 2 * A * R ^ p + (2 * |B| + 2 + 3 * ‖g 0‖) := by
        intro w hw
        have hw' : ‖w‖ = R / 2 := by
          have := Metric.mem_sphere.mp hw
          simpa [dist_eq_norm] using this
        exact hbound R hR w (le_of_eq hw')
      have hd : DiffContOnCl ℂ g (Metric.ball (0 : ℂ) (R / 2)) := hg.diffContOnCl
      exact Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le k hR2 hd hsphere
    -- (iii) the resulting bound tends to zero.
    set q := (p + 2) / 2 with hq
    have hpq : p < q := by rw [hq]; linarith
    have hq2 : q < 2 := by rw [hq]; linarith
    have hq0 : (0 : ℝ) ≤ q := by linarith
    have hkq : 0 < (k : ℝ) - q := by linarith
    have hC0 : (0 : ℝ) ≤ 2 * |B| + 2 + 3 * ‖g 0‖ := by positivity
    set C0 := 2 * |B| + 2 + 3 * ‖g 0‖ with hC0def
    have htend : Tendsto (fun R : ℝ =>
        (k.factorial : ℝ) * 2 ^ k * (2 * A + C0) * R ^ (q - k)) atTop (𝓝 0) := by
      have h1 : Tendsto (fun R : ℝ => R ^ (-((k : ℝ) - q))) atTop (𝓝 0) :=
        tendsto_rpow_neg_atTop hkq
      have h2 : Tendsto (fun R : ℝ => R ^ (q - (k : ℝ))) atTop (𝓝 0) := by
        have he : q - (k : ℝ) = -((k : ℝ) - q) := by ring
        rw [he]; exact h1
      have h3 := h2.const_mul ((k.factorial : ℝ) * 2 ^ k * (2 * A + C0))
      simpa [mul_assoc] using h3
    have hev : ∀ᶠ R : ℝ in atTop, ‖iteratedDeriv k g 0‖ ≤
        (k.factorial : ℝ) * 2 ^ k * (2 * A + C0) * R ^ (q - (k : ℝ)) := by
      filter_upwards [eventually_ge_atTop (1 : ℝ)] with R hR1
      have hR : (0 : ℝ) < R := by linarith
      have hp_le : R ^ p ≤ R ^ q := Real.rpow_le_rpow_of_exponent_le hR1 hpq.le
      have hRq1 : (1 : ℝ) ≤ R ^ q := Real.one_le_rpow hR1 hq0
      have hstep2 : 2 * A * R ^ p + C0 ≤ (2 * A + C0) * R ^ q := by
        have h1 : 2 * A * R ^ p ≤ 2 * A * R ^ q :=
          mul_le_mul_of_nonneg_left hp_le (by linarith : (0 : ℝ) ≤ 2 * A)
        have h2 : C0 ≤ C0 * R ^ q := by nlinarith
        nlinarith
      calc ‖iteratedDeriv k g 0‖
          ≤ (k.factorial : ℝ) * (2 * A * R ^ p + C0) / (R / 2) ^ k := hcauchy R hR
        _ = (k.factorial : ℝ) * 2 ^ k * (2 * A * R ^ p + C0) / R ^ k := by
              rw [div_pow]; ring_nf; simp only [inv_inv]
        _ ≤ (k.factorial : ℝ) * 2 ^ k * ((2 * A + C0) * R ^ q) / R ^ k := by
              apply div_le_div_of_nonneg_right _ (by positivity)
              exact mul_le_mul_of_nonneg_left hstep2 (by positivity)
        _ = (k.factorial : ℝ) * 2 ^ k * (2 * A + C0) * R ^ (q - (k : ℝ)) := by
              rw [Real.rpow_sub hR, Real.rpow_natCast]; ring
    have hconst : Tendsto (fun _ : ℝ => ‖iteratedDeriv k g 0‖) atTop
        (𝓝 ‖iteratedDeriv k g 0‖) := tendsto_const_nhds
    have hle := le_of_tendsto_of_tendsto hconst htend hev
    exact norm_eq_zero.mp (le_antisymm hle (norm_nonneg _))
  -- Step 2: the Taylor series at 0 truncates at degree one.
  refine ⟨g 0, iteratedDeriv 1 g 0, fun z => ?_⟩
  have hTS := Complex.taylorSeries_eq_of_entire' hg (c := 0) (z := z)
  have hsupp : ∀ n : ℕ, n ∉ ({0, 1} : Finset ℕ) →
      (n.factorial : ℂ)⁻¹ * iteratedDeriv n g 0 * (z - 0) ^ n = 0 := by
    intro n hn
    have hn2 : 2 ≤ n := by
      simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hn
      omega
    rw [hzero n hn2]; ring
  rw [tsum_eq_sum (s := ({0, 1} : Finset ℕ)) hsupp] at hTS
  have htwo : ∑ n ∈ ({0, 1} : Finset ℕ),
      (n.factorial : ℂ)⁻¹ * iteratedDeriv n g 0 * (z - 0) ^ n
      = g 0 + iteratedDeriv 1 g 0 * z := by
    simp [iteratedDeriv_one]
  rw [htwo] at hTS
  exact hTS.symm



/-- **A lower bound for the scaled elementary factor** on the disc
`‖z‖ ≤ ‖a‖/2`: `-3‖z‖/‖a‖ ≤ log ‖E_1(z/a)‖`. This is the per-factor estimate
needed for lower bounds on `|P|` in the factorisation route. -/
theorem log_norm_weierstrassFactor_one_div_lower {a z : ℂ} (ha : a ≠ 0)
    (hz : ‖z‖ ≤ ‖a‖ / 2) :
    -3 * ‖z‖ / ‖a‖ ≤ Real.log ‖weierstrassFactor 1 (z / a)‖ := by
  have hanorm : 0 < ‖a‖ := norm_pos_iff.mpr ha
  set w : ℂ := z / a with hw
  have hwnorm : ‖w‖ = ‖z‖ / ‖a‖ := by rw [hw, norm_div]
  have hwle : ‖w‖ ≤ 1 / 2 := by
    rw [hwnorm, div_le_iff₀ hanorm]
    nlinarith
  have hfac : weierstrassFactor 1 (z / a) = (1 - w) * cexp w := by
    simp [weierstrassFactor, hw]
  rw [hfac]
  have hne1 : (1 : ℂ) - w ≠ 0 := by
    intro h
    have h1 : (1 : ℂ) = w := sub_eq_zero.mp h
    have h2 : ‖w‖ = 1 := by
      rw [← h1]
      simp
    rw [h2] at hwle
    norm_num at hwle
  have hnorm : ‖(1 - w) * cexp w‖ = ‖1 - w‖ * Real.exp w.re := by
    rw [norm_mul, Complex.norm_exp]
  rw [hnorm]
  have hpos : (0 : ℝ) < ‖1 - w‖ := norm_pos_iff.mpr hne1
  have hlog : Real.log (‖1 - w‖ * Real.exp w.re) = Real.log ‖1 - w‖ + w.re := by
    rw [Real.log_mul (ne_of_gt hpos) (Real.exp_ne_zero w.re), Real.log_exp]
  rw [hlog]
  -- three lower bounds
  have h1mw_pos : (0 : ℝ) < 1 - ‖w‖ := by linarith
  have hnorm_ge : 1 - ‖w‖ ≤ ‖1 - w‖ := by
    have h := norm_sub_norm_le (1 : ℂ) w
    rw [norm_one] at h
    linarith
  have hlog_lb : -2 * ‖w‖ ≤ Real.log ‖1 - w‖ := by
    have h2 : Real.log (1 - ‖w‖) ≤ Real.log ‖1 - w‖ :=
      Real.log_le_log h1mw_pos hnorm_ge
    have h3 : -2 * ‖w‖ ≤ Real.log (1 - ‖w‖) := by
      have h4 : Real.log (1 / (1 - ‖w‖)) ≤ 2 * ‖w‖ := by
        have h5 : Real.log (1 / (1 - ‖w‖)) ≤ 1 / (1 - ‖w‖) - 1 :=
          Real.log_le_sub_one_of_pos (by positivity)
        have h6 : 1 / (1 - ‖w‖) - 1 = ‖w‖ / (1 - ‖w‖) := by
          field_simp
          ring
        have h7 : ‖w‖ / (1 - ‖w‖) ≤ 2 * ‖w‖ := by
          rw [div_le_iff₀ h1mw_pos]
          nlinarith [hwle, norm_nonneg w]
        linarith
      have h8 : Real.log (1 / (1 - ‖w‖)) = -Real.log (1 - ‖w‖) := by
        rw [one_div, Real.log_inv]
      rw [h8] at h4
      linarith
    linarith
  have hre_lb : -‖w‖ ≤ w.re := by
    have h := Complex.abs_re_le_norm w
    have h2 := (abs_le.mp h).1
    linarith
  have hw2 : ‖z‖ / ‖a‖ ≤ 1 / 2 := by
    rw [← hwnorm]
    exact hwle
  have hsum : -2 * (‖z‖ / ‖a‖) - ‖z‖ / ‖a‖ ≤ Real.log ‖1 - w‖ + w.re := by
    nlinarith
  calc -3 * ‖z‖ / ‖a‖ = -2 * (‖z‖ / ‖a‖) - ‖z‖ / ‖a‖ := by ring
    _ ≤ Real.log ‖1 - w‖ + w.re := hsum


/-- **A lower bound for the finite canonical product** on the disc where every
prescribed zero is at least twice as far from the origin as `z`:
`log ‖finiteCanonicalProduct 1 S z‖ ≥ −3‖z‖·∑_{a∈S} 1/‖a‖`. -/
theorem log_norm_finiteCanonicalProduct_one_lower (S : Finset ℂ)
    (h0 : ∀ a ∈ S, a ≠ 0) {z : ℂ} (hz : ∀ a ∈ S, ‖z‖ ≤ ‖a‖ / 2) :
    -3 * ‖z‖ * ∑ a ∈ S, (1 / ‖a‖)
      ≤ Real.log ‖finiteCanonicalProduct 1 S z‖ := by
  have hne : ∀ a ∈ S, weierstrassFactor 1 (z / a) ≠ 0 := by
    intro a ha h
    have hzw : z / a = 1 := (weierstrassFactor_eq_zero_iff 1 (z / a)).mp h
    have h1 : z = a := by
      rw [div_eq_one_iff_eq (h0 a ha)] at hzw
      simpa using hzw
    have h2 : ‖z‖ = ‖a‖ := by rw [h1]
    have h3 := hz a ha
    rw [h2] at h3
    have hapos : (0 : ℝ) < ‖a‖ := norm_pos_iff.mpr (h0 a ha)
    linarith
  have hnorm_prod : ‖finiteCanonicalProduct 1 S z‖
      = ∏ a ∈ S, ‖weierstrassFactor 1 (z / a)‖ := by
    simp only [finiteCanonicalProduct]
    rw [norm_prod]
  rw [hnorm_prod, Real.log_prod (fun a ha => norm_ne_zero_iff.mpr (hne a ha))]
  have hsum : ∑ a ∈ S, (-3 * ‖z‖ / ‖a‖)
      ≤ ∑ a ∈ S, Real.log ‖weierstrassFactor 1 (z / a)‖ :=
    Finset.sum_le_sum (fun a ha =>
      log_norm_weierstrassFactor_one_div_lower (h0 a ha) (hz a ha))
  have hconst : ∑ a ∈ S, (-3 * ‖z‖ / ‖a‖)
      = -3 * ‖z‖ * ∑ a ∈ S, (1 / ‖a‖) := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl (fun a ha => ?_)
    ring
  linarith [hconst]

open scoped Topology
open Filter

/-- **Lower bound for the logarithm of the norm of the infinite canonical
product** (in the case `p = 1`), on the disc where every prescribed zero is at
least twice as far from the origin as `z`:
`log ‖∏' n, E₁(z/a n)‖ ≥ −3‖z‖·∑' n, 1/‖a n‖`. -/
theorem log_norm_tprod_weierstrassFactor_one_lower {a : ℕ → ℂ} {z : ℂ}
    (ha0 : ∀ n, a n ≠ 0) (hsep : ∀ n, ‖z‖ ≤ ‖a n‖ / 2)
    (hsum : Summable (fun n => 1 / ‖a n‖))
    (hconv : Multipliable (fun n => weierstrassFactor 1 (z / a n))) :
    -3 * ‖z‖ * (∑' n, 1 / ‖a n‖)
      ≤ Real.log ‖∏' n, weierstrassFactor 1 (z / a n)‖ := by
  by_cases hz : z = 0
  · subst hz
    have hfun : (fun n : ℕ => weierstrassFactor 1 ((0 : ℂ) / a n)) = fun _ => (1 : ℂ) := by
      funext n
      rw [zero_div, weierstrassFactor_zero]
    rw [hfun, tprod_one, norm_one, Real.log_one, norm_zero]
    simp
  · -- each factor is nonzero
    have hfac : ∀ n : ℕ, weierstrassFactor 1 (z / a n) ≠ 0 := by
      intro n h
      have hzw : z / a n = 1 := (weierstrassFactor_eq_zero_iff 1 (z / a n)).mp h
      have h1 : z = a n := by
        rw [div_eq_one_iff_eq (ha0 n)] at hzw
        exact hzw
      have h2 : ‖z‖ = ‖a n‖ := by rw [h1]
      have h3 := hsep n
      rw [h2] at h3
      have hapos : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
      linarith
    -- the finite lower bound
    have hstep : ∀ N : ℕ, -3 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖)
        ≤ Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖ := by
      intro N
      have hne : ∀ n ∈ Finset.range N, ‖weierstrassFactor 1 (z / a n)‖ ≠ 0 :=
        fun n _ => norm_ne_zero_iff.mpr (hfac n)
      have hlog : Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖
          = ∑ n ∈ Finset.range N, Real.log ‖weierstrassFactor 1 (z / a n)‖ := by
        rw [norm_prod]
        exact Real.log_prod (s := Finset.range N)
          (f := fun n => ‖weierstrassFactor 1 (z / a n)‖) hne
      rw [hlog]
      have hle : ∑ n ∈ Finset.range N, (-3 * ‖z‖ / ‖a n‖)
          ≤ ∑ n ∈ Finset.range N, Real.log ‖weierstrassFactor 1 (z / a n)‖ :=
        Finset.sum_le_sum (fun n _ =>
          log_norm_weierstrassFactor_one_div_lower (ha0 n) (hsep n))
      have hconst : ∑ n ∈ Finset.range N, (-3 * ‖z‖ / ‖a n‖)
          = -3 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖) := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl (fun n _ => by ring)
      linarith
    -- summability of the quadratic terms, by comparison with `∑ 1/‖a n‖`
    have hsum2 : Summable (fun n : ℕ => ‖z‖ ^ (1 + 1) / ‖a n‖ ^ (1 + 1)) := by
      have hbase : Summable (fun n : ℕ => (‖z‖ / 2) * (1 / ‖a n‖)) :=
        hsum.mul_left (‖z‖ / 2)
      refine Summable.of_nonneg_of_le (fun n => ?_) (fun n => ?_) hbase
      · positivity
      · have han : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
        have h1 : ‖z‖ / ‖a n‖ ≤ 1 / 2 := by
          rw [div_le_iff₀ han]
          linarith [hsep n]
        have h2 : 0 ≤ ‖z‖ / ‖a n‖ := by positivity
        have h3 : (‖z‖ / ‖a n‖) ^ 2 ≤ (‖z‖ / 2) * (1 / ‖a n‖) := by
          have h4 : (‖z‖ / ‖a n‖) ^ 2 ≤ (1 / 2) * (‖z‖ / ‖a n‖) := by
            nlinarith [mul_le_mul_of_nonneg_left h1 h2]
          have h5 : (1 / 2) * (‖z‖ / ‖a n‖) = (‖z‖ / 2) * (1 / ‖a n‖) := by ring
          linarith
        calc ‖z‖ ^ (1 + 1) / ‖a n‖ ^ (1 + 1) = (‖z‖ / ‖a n‖) ^ 2 := by
              rw [show (1 + 1 : ℕ) = 2 from by norm_num, div_pow]
          _ ≤ (‖z‖ / 2) * (1 / ‖a n‖) := h3
    -- the infinite product does not vanish
    have hne_tprod : (∏' n, weierstrassFactor 1 (z / a n)) ≠ 0 := by
      have ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖ := by
        intro n
        linarith [hsep n]
      have hzne : ∀ n, z ≠ a n := by
        intro n h
        have h2 : ‖z‖ = ‖a n‖ := by rw [h]
        have h3 := hsep n
        rw [h2] at h3
        have hapos : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
        linarith
      exact tprod_weierstrassFactor_ne_zero hz ha hsum2 hzne
    -- passage to the limit
    have hL : Tendsto (fun N : ℕ => -3 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖))
        atTop (𝓝 (-3 * ‖z‖ * ∑' n, 1 / ‖a n‖)) :=
      (hsum.hasSum.tendsto_sum_nat).const_mul (-3 * ‖z‖)
    have hR : Tendsto
        (fun N : ℕ => Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖)
        atTop (𝓝 (Real.log ‖∏' n, weierstrassFactor 1 (z / a n)‖)) := by
      have hprod := hconv.hasProd.tendsto_prod_nat
      have hnorm := hprod.norm
      exact (Real.continuousAt_log (norm_ne_zero_iff.mpr hne_tprod)).tendsto.comp hnorm
    exact le_of_tendsto_of_tendsto' hL hR hstep


open MeasureTheory Filter
open scoped Topology

/-! ### Step 1: the integral bound `‖Γ s‖ ≤ Γ (re s)` for `0 < re s` -/

theorem norm_Gamma_le_Gamma_re {s : ℂ} (hs : 0 < s.re) :
    ‖Complex.Gamma s‖ ≤ Real.Gamma s.re := by
  rw [Complex.Gamma_eq_integral hs, Complex.GammaIntegral, Real.Gamma_eq_integral hs]
  calc ‖∫ x in Set.Ioi 0, (Real.exp (-x) : ℂ) * (x : ℂ) ^ (s - 1)‖
      ≤ ∫ x in Set.Ioi 0, ‖(Real.exp (-x) : ℂ) * (x : ℂ) ^ (s - 1)‖ :=
        norm_integral_le_integral_norm _
    _ = ∫ x in Set.Ioi 0, Real.exp (-x) * x ^ (s.re - 1) := by
        refine setIntegral_congr_fun measurableSet_Ioi (fun x hx => ?_)
        rw [norm_mul, Complex.norm_of_nonneg (Real.exp_pos (-x)).le,
          Complex.norm_cpow_eq_rpow_re_of_pos hx]
        simp

/-! ### Step 2: log-convexity bounds for `Real.Gamma` -/

/-- For `σ ≥ 1`, `log Γ(σ) ≤ σ log σ`.  This is log-convexity plus
`log n! ≤ n log n`. -/
theorem log_Gamma_le_mul_log {σ : ℝ} (hσ : 1 ≤ σ) :
    Real.log (Real.Gamma σ) ≤ σ * Real.log σ := by
  have hσ0 : 0 < σ := lt_of_lt_of_le zero_lt_one hσ
  have hn1 : 1 ≤ ⌊σ⌋₊ := by
    rw [Nat.le_floor_iff (le_of_lt hσ0)]
    exact_mod_cast hσ
  have hnpos : (0 : ℝ) < (⌊σ⌋₊ : ℝ) := by exact_mod_cast hn1
  have hle : (⌊σ⌋₊ : ℝ) ≤ σ := Nat.floor_le (le_of_lt hσ0)
  have hlt : σ < (⌊σ⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one σ
  have hseg := Real.convexOn_log_Gamma.le_on_segment'
      (x := (⌊σ⌋₊ : ℝ)) (y := (⌊σ⌋₊ : ℝ) + 1)
      (Set.mem_Ioi.mpr hnpos) (Set.mem_Ioi.mpr (by linarith))
      (a := (⌊σ⌋₊ : ℝ) + 1 - σ) (b := σ - (⌊σ⌋₊ : ℝ))
      (by linarith) (by linarith) (by ring)
  have havg : ((⌊σ⌋₊ : ℝ) + 1 - σ) • (⌊σ⌋₊ : ℝ) + (σ - (⌊σ⌋₊ : ℝ)) • ((⌊σ⌋₊ : ℝ) + 1)
      = σ := by
    simp only [smul_eq_mul]; ring
  rw [havg] at hseg
  simp only [Function.comp_apply] at hseg
  have hGn : Real.Gamma (⌊σ⌋₊ : ℝ) = ((⌊σ⌋₊ - 1).factorial : ℝ) := by
    have hcast : (⌊σ⌋₊ : ℝ) = ((⌊σ⌋₊ - 1 : ℕ) : ℝ) + 1 := by
      calc (⌊σ⌋₊ : ℝ) = ((⌊σ⌋₊ - 1 + 1 : ℕ) : ℝ) := by rw [Nat.sub_add_cancel hn1]
        _ = ((⌊σ⌋₊ - 1 : ℕ) : ℝ) + 1 := by push_cast; ring
    rw [hcast, Real.Gamma_nat_eq_factorial]
  have hGn1 : Real.Gamma ((⌊σ⌋₊ : ℝ) + 1) = ((⌊σ⌋₊).factorial : ℝ) :=
    Real.Gamma_nat_eq_factorial ⌊σ⌋₊
  have hmax :
      max (Real.log (Real.Gamma (⌊σ⌋₊ : ℝ)))
        (Real.log (Real.Gamma ((⌊σ⌋₊ : ℝ) + 1))) ≤ Real.log ((⌊σ⌋₊).factorial : ℝ) := by
    apply max_le
    · rw [hGn]
      exact Real.log_le_log (by positivity) (by exact_mod_cast Nat.factorial_le (Nat.sub_le ⌊σ⌋₊ 1))
    · rw [hGn1]
  have hpow : Real.log ((⌊σ⌋₊).factorial : ℝ) ≤ (⌊σ⌋₊ : ℝ) * Real.log (⌊σ⌋₊ : ℝ) := by
    have h1 : ((⌊σ⌋₊).factorial : ℝ) ≤ (⌊σ⌋₊ : ℝ) ^ ⌊σ⌋₊ := by
      exact_mod_cast Nat.factorial_le_pow ⌊σ⌋₊
    have h2 : Real.log ((⌊σ⌋₊).factorial : ℝ) ≤ Real.log ((⌊σ⌋₊ : ℝ) ^ ⌊σ⌋₊) :=
      Real.log_le_log (by positivity) h1
    rw [Real.log_pow] at h2
    simpa using h2
  have hmono : (⌊σ⌋₊ : ℝ) * Real.log (⌊σ⌋₊ : ℝ) ≤ σ * Real.log σ := by
    apply mul_le_mul hle (Real.log_le_log hnpos hle) (Real.log_nonneg (by exact_mod_cast hn1))
      (le_of_lt hσ0)
  linarith

/-- For `0 < σ < 1`, `log Γ(σ) ≤ - log σ`.  From `Γ(σ+1) = σ Γ(σ)` and log-convexity
on `[1,2]`, where `log Γ ≤ 0`. -/
theorem log_Gamma_le_neg_log {σ : ℝ} (h0 : 0 < σ) (h1 : σ < 1) :
    Real.log (Real.Gamma σ) ≤ -Real.log σ := by
  have hseg := Real.convexOn_log_Gamma.le_on_segment'
      (x := (1 : ℝ)) (y := (2 : ℝ)) (Set.mem_Ioi.mpr zero_lt_one)
      (Set.mem_Ioi.mpr (by norm_num))
      (a := 1 - σ) (b := σ) (by linarith) (le_of_lt h0) (by ring)
  have havg : (1 - σ) • (1 : ℝ) + σ • (2 : ℝ) = 1 + σ := by
    simp only [smul_eq_mul]; ring
  rw [havg] at hseg
  simp only [Function.comp_apply, Real.Gamma_one, Real.Gamma_two, Real.log_one, max_self] at hseg
  have hlog : Real.log (Real.Gamma (1 + σ)) = Real.log σ + Real.log (Real.Gamma σ) := by
    have h : Real.Gamma (1 + σ) = σ * Real.Gamma σ := by
      rw [show (1 : ℝ) + σ = σ + 1 by ring, Real.Gamma_add_one (ne_of_gt h0)]
    rw [h, Real.log_mul (ne_of_gt h0) (ne_of_gt (Real.Gamma_pos_of_pos h0))]
  rw [hlog] at hseg
  linarith

/-! ### Step 3: the complex bound, on `1 ≤ re s` -/

theorem log_norm_Gamma_le_of_one_le_re {s : ℂ} (hs : 1 ≤ s.re) :
    Real.log ‖Complex.Gamma s‖ ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
  have hσ0 : 0 < s.re := lt_of_lt_of_le zero_lt_one hs
  have hpos : 0 < ‖Complex.Gamma s‖ :=
    norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos hσ0)
  have h1 : Real.log ‖Complex.Gamma s‖ ≤ Real.log (Real.Gamma s.re) :=
    Real.log_le_log hpos (norm_Gamma_le_Gamma_re hσ0)
  have h2 : Real.log (Real.Gamma s.re) ≤ s.re * Real.log s.re := log_Gamma_le_mul_log hs
  have h3 : s.re * Real.log s.re ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
    apply mul_le_mul (Complex.re_le_norm s) _ (Real.log_nonneg hs) (norm_nonneg s)
    exact Real.log_le_log hσ0 (by linarith [Complex.re_le_norm s, norm_nonneg s])
  linarith

/-- The `1 ≤ re s` form of the target, with explicit constants `A = 1`, `B = 0`. -/
theorem exists_bound_log_norm_Gamma_right_of_one_le_re :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, 1 ≤ s.re →
      Real.log ‖Complex.Gamma s‖ ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B := by
  exact ⟨1, 0, by norm_num, fun s hs => by simpa using log_norm_Gamma_le_of_one_le_re hs⟩

/-! ### Step 3b: the bound on the half-plane `re s ≥ 1/2` -/

theorem log_norm_Gamma_le_of_half_le_re {s : ℂ} (hs : (1 / 2 : ℝ) ≤ s.re) :
    Real.log ‖Complex.Gamma s‖ ≤ ‖s‖ * Real.log (‖s‖ + 2) + Real.log 2 := by
  have hσpos : 0 < s.re := lt_of_lt_of_le (by norm_num) hs
  have hpos : 0 < ‖Complex.Gamma s‖ :=
    norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos hσpos)
  have h1 : Real.log ‖Complex.Gamma s‖ ≤ Real.log (Real.Gamma s.re) :=
    Real.log_le_log hpos (norm_Gamma_le_Gamma_re hσpos)
  have hnorm : 0 ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
    have : 0 < Real.log (‖s‖ + 2) := Real.log_pos (by linarith [norm_nonneg s])
    positivity
  by_cases hle : 1 ≤ s.re
  · have h2 : Real.log (Real.Gamma s.re) ≤ s.re * Real.log s.re := log_Gamma_le_mul_log hle
    have h3 : s.re * Real.log s.re ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
      apply mul_le_mul (Complex.re_le_norm s) _ (Real.log_nonneg hle) (norm_nonneg s)
      exact Real.log_le_log (by linarith) (by linarith [Complex.re_le_norm s, norm_nonneg s])
    have hlog2 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
    linarith
  · have hlt : s.re < 1 := not_le.mp hle
    have h2 : Real.log (Real.Gamma s.re) ≤ -Real.log s.re := log_Gamma_le_neg_log hσpos hlt
    have hlog : -Real.log s.re ≤ Real.log 2 := by
      have h : Real.log (1 / 2) ≤ Real.log s.re := Real.log_le_log (by norm_num) hs
      rw [Real.log_div one_ne_zero two_ne_zero] at h
      simp only [Real.log_one, zero_sub] at h
      linarith
    linarith

/-- Explicit constants `A = 1`, `B = log 2` for the half-plane `re s ≥ 1/2`. -/
theorem exists_bound_log_norm_Gamma_right_of_half_le_re :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re →
      Real.log ‖Complex.Gamma s‖ ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B :=
  ⟨1, Real.log 2, by norm_num, fun s hs => by
    simpa using log_norm_Gamma_le_of_half_le_re hs⟩

/-! ### Step 4: the corrected global form on `0 < re s`

The literal target of the brief (with no `- log (re s)` term) is **false**: as
`σ = s.re → 0⁺` along the real axis, `Γ σ ~ 1/σ` so `log ‖Γ σ‖ → +∞`, while
`A * ‖σ‖ * log (‖σ‖ + 2) + B → B` is bounded.  The correct statement needs the
`- log (re s)` term that records the pole at `0`. -/

theorem exists_bound_log_norm_Gamma_right_corrected :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, 0 < s.re →
      Real.log ‖Complex.Gamma s‖ ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B - Real.log s.re := by
  refine ⟨2, 0, by norm_num, fun s hs => ?_⟩
  have hpos : 0 < ‖Complex.Gamma s‖ :=
    norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos hs)
  have h1 : Real.log ‖Complex.Gamma s‖ ≤ Real.log (Real.Gamma s.re) :=
    Real.log_le_log hpos (norm_Gamma_le_Gamma_re hs)
  have hnorm : 0 ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
    have : 0 < Real.log (‖s‖ + 2) := Real.log_pos (by linarith [norm_nonneg s])
    positivity
  by_cases hle : 1 ≤ s.re
  · have h2 : Real.log (Real.Gamma s.re) ≤ s.re * Real.log s.re := log_Gamma_le_mul_log hle
    have h3 : s.re * Real.log s.re + Real.log s.re ≤ 2 * ‖s‖ * Real.log (‖s‖ + 2) := by
      have hlog2 : 0 ≤ Real.log (s.re + 2) := Real.log_nonneg (by linarith)
      have hA : Real.log s.re ≤ s.re * Real.log (s.re + 2) := by
        calc Real.log s.re ≤ Real.log (s.re + 2) := Real.log_le_log (by linarith) (by linarith)
          _ = 1 * Real.log (s.re + 2) := (one_mul _).symm
          _ ≤ s.re * Real.log (s.re + 2) := mul_le_mul_of_nonneg_right hle hlog2
      have hB : s.re * Real.log (s.re + 2) ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
        apply mul_le_mul (Complex.re_le_norm s) _ hlog2 (norm_nonneg s)
        exact Real.log_le_log (by linarith) (by linarith [Complex.re_le_norm s])
      have hC : s.re * Real.log s.re ≤ s.re * Real.log (s.re + 2) := by
        apply mul_le_mul_of_nonneg_left _ (le_trans zero_le_one hle)
        exact Real.log_le_log (by linarith) (by linarith)
      linarith
    linarith
  · have hlt : s.re < 1 := not_le.mp hle
    have h2 : Real.log (Real.Gamma s.re) ≤ -Real.log s.re := log_Gamma_le_neg_log hs hlt
    linarith


/-! ### Step 5: the literal target is refutable

Along the real axis, `Γ σ ~ 1/σ` as `σ → 0⁺`, so `log ‖Γ σ‖ → +∞` while the
purported bound `A‖σ‖log(‖σ‖+2)+B` stays bounded.  This is the rigorous
negation of the literal statement of the brief. -/

theorem not_exists_bound_log_norm_Gamma_right :
    ¬ ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, 0 < s.re →
      Real.log ‖Complex.Gamma s‖ ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B := by
  rintro ⟨A, B, hA, hbound⟩
  -- `Γ` is continuous at `1`, hence `Γ (σ+1) > 1/2` for `σ` near `0`.
  have hcont : ContinuousAt Real.Gamma 1 :=
    (Real.differentiableAt_Gamma (fun m => by
      have h : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith)).continuousAt
  have hhalfmem : (1 / 2 : ℝ) < Real.Gamma 1 := by
    rw [Real.Gamma_one]; norm_num
  have hev : ∀ᶠ σ : ℝ in 𝓝 (0 : ℝ), (1 / 2 : ℝ) < Real.Gamma (σ + 1) := by
    have h1 : Tendsto (fun σ : ℝ => σ + 1) (𝓝 0) (𝓝 1) := by
      simpa using (Filter.tendsto_id (x := 𝓝 (0 : ℝ))).add_const (1 : ℝ)
    have hc : Tendsto Real.Gamma (𝓝 1) (𝓝 (Real.Gamma 1)) := hcont
    exact (hc.comp h1).eventually (isOpen_Ioi.mem_nhds hhalfmem)
  rcases Metric.mem_nhds_iff.mp hev with ⟨δ, hδ, hδlem⟩
  have hδpos : 0 < δ := hδ
  have h2δpos : 0 < 2 / δ := by positivity
  -- choose a large `N` and put `σ = exp (-N)`
  set N : ℝ := max 1 (max (|A| * Real.log 3 + B + Real.log 2 + 1) (Real.log (2 / δ)))
    with hN
  have hN1 : 1 ≤ N := le_max_left _ _
  have hN2 : |A| * Real.log 3 + B + Real.log 2 + 1 ≤ N :=
    le_trans (le_max_left _ _) (le_max_right _ _)
  have hN3 : Real.log (2 / δ) ≤ N :=
    le_trans (le_max_right _ _) (le_max_right _ _)
  set σ : ℝ := Real.exp (-N) with hσdef
  have hσpos : 0 < σ := Real.exp_pos _
  have hσlt1 : σ < 1 := by
    rw [hσdef, ← Real.exp_zero]
    exact Real.exp_lt_exp.mpr (by linarith)
  have hσδ : σ < δ := by
    have hle : σ ≤ Real.exp (-(Real.log (2 / δ))) := by
      rw [hσdef]
      exact Real.exp_le_exp.mpr (by linarith)
    have heq : Real.exp (-(Real.log (2 / δ))) = δ / 2 := by
      rw [Real.exp_neg, Real.exp_log h2δpos]
      field_simp
    rw [heq] at hle
    linarith
  have hΓhalf : (1 / 2 : ℝ) < Real.Gamma (σ + 1) :=
    hδlem (by rw [Metric.mem_ball, Real.dist_eq, sub_zero, abs_of_pos hσpos]; exact hσδ)
  -- the assumed bound, evaluated at the real point `σ`
  have hb' : Real.log (Real.Gamma σ) ≤ A * σ * Real.log (σ + 2) + B := by
    have h := hbound (σ : ℂ) (by simpa using hσpos)
    simpa [Complex.Gamma_ofReal, RCLike.norm_ofReal, abs_of_pos hσpos,
      abs_of_pos (Real.Gamma_pos_of_pos hσpos)] using h
  -- the lower bound `log Γ σ ≥ log (1/2) - log σ`
  have hlow : Real.log (1 / 2) - Real.log σ ≤ Real.log (Real.Gamma σ) := by
    have hstep : Real.Gamma (σ + 1) = σ * Real.Gamma σ := Real.Gamma_add_one (ne_of_gt hσpos)
    have hlog : Real.log (Real.Gamma (σ + 1)) = Real.log σ + Real.log (Real.Gamma σ) := by
      rw [hstep, Real.log_mul (ne_of_gt hσpos) (ne_of_gt (Real.Gamma_pos_of_pos hσpos))]
    have hlt : Real.log (1 / 2) < Real.log (Real.Gamma (σ + 1)) :=
      Real.log_lt_log (by norm_num) hΓhalf
    linarith
  -- and the upper bound on the right-hand side
  have hub : A * σ * Real.log (σ + 2) + B ≤ |A| * Real.log 3 + B := by
    have hx0 : 0 ≤ σ * Real.log (σ + 2) := by
      have hlog2 : 0 ≤ Real.log (σ + 2) := Real.log_nonneg (by linarith)
      positivity
    have hx3 : σ * Real.log (σ + 2) ≤ Real.log 3 := by
      have hlog3 : Real.log (σ + 2) ≤ Real.log 3 :=
        Real.log_le_log (by linarith) (by linarith)
      calc σ * Real.log (σ + 2) ≤ 1 * Real.log (σ + 2) := by
            apply mul_le_mul_of_nonneg_right (le_of_lt hσlt1)
            exact Real.log_nonneg (by linarith)
        _ = Real.log (σ + 2) := one_mul _
        _ ≤ Real.log 3 := hlog3
    have hA' : A * (σ * Real.log (σ + 2)) ≤ |A| * (σ * Real.log (σ + 2)) :=
      mul_le_mul_of_nonneg_right (le_abs_self A) hx0
    have hA'' : |A| * (σ * Real.log (σ + 2)) ≤ |A| * Real.log 3 :=
      mul_le_mul_of_nonneg_left hx3 (abs_nonneg A)
    calc A * σ * Real.log (σ + 2) + B = A * (σ * Real.log (σ + 2)) + B := by ring
      _ ≤ |A| * Real.log 3 + B := by linarith
  have hfin : Real.log (1 / 2) - Real.log σ ≤ |A| * Real.log 3 + B :=
    le_trans hlow (le_trans hb' hub)
  have hloghalf : Real.log (1 / 2) = -Real.log 2 := by
    rw [Real.log_div one_ne_zero two_ne_zero]; simp
  have hlogσ : Real.log σ = -N := by
    rw [hσdef, Real.log_exp]
  rw [hloghalf, hlogσ] at hfin
  linarith


/-! ### Step 6: the growth bound for `Gammaℝ` on `re s ≥ 1/2`

`Gammaℝ s = π^(-s/2) * Γ(s/2)`; on this half-plane `re (s/2) ≥ 1/4`, so the
corrected `Γ` bound applies and the archimedean prefactor contributes a term of
the same shape `‖s‖ log (‖s‖ + 2)`. -/

set_option maxHeartbeats 2000000 in
/-- Growth bound for `log ‖Gammaℝ s‖` on the half-plane `re s ≥ 1/2`.

Since `Gammaℝ s = π^(-s/2) * Γ(s/2)` and `re (s/2) ≥ 1/4`, the corrected
bound for `Γ` together with `‖π^(-s/2)‖ = π^((-s/2).re)` gives the claim. -/
theorem gammaR_growth_exists_bound_log_norm_half_le :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re →
      Real.log ‖Complex.Gammaℝ s‖
        ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B := by
  obtain ⟨A₀, B₀, hA₀, hbound⟩ := exists_bound_log_norm_Gamma_right_corrected
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlogpi : 0 < Real.log Real.pi := Real.log_pos (by linarith [Real.pi_gt_three])
  refine ⟨A₀ / 2 + Real.log Real.pi / (2 * Real.log 2), B₀ + Real.log 4, ?_, ?_⟩
  · have h1 : 0 ≤ A₀ / 2 := by linarith
    have h2 : 0 ≤ Real.log Real.pi / (2 * Real.log 2) := by
      apply div_nonneg (le_of_lt hlogpi)
      linarith
    linarith
  · intro s hs
    have hre : (s / 2).re = s.re / 2 := by simp
    have hs2pos : 0 < (s / 2).re := by rw [hre]; linarith
    have hquarter : (1 / 4 : ℝ) ≤ (s / 2).re := by rw [hre]; linarith
    have hnr : -s.re ≤ ‖s‖ := (neg_le_abs s.re).trans (Complex.abs_re_le_norm s)
    -- the archimedean factor
    have hpi_norm : ‖(Real.pi : ℂ) ^ (-s / 2)‖ = Real.pi ^ ((-s / 2).re) :=
      Complex.norm_cpow_eq_rpow_re_of_pos Real.pi_pos _
    have hpi_re : (-s / 2).re = -(s.re) / 2 := by simp
    have hpi_pos : 0 < ‖(Real.pi : ℂ) ^ (-s / 2)‖ := by
      rw [hpi_norm]
      exact Real.rpow_pos_of_pos Real.pi_pos _
    have hCnn : 0 ≤ Real.log Real.pi / (2 * Real.log 2) := by
      apply div_nonneg (le_of_lt hlogpi)
      linarith
    have hpi_bound :
        Real.log ‖(Real.pi : ℂ) ^ (-s / 2)‖
          ≤ (Real.log Real.pi / (2 * Real.log 2)) * ‖s‖ * Real.log (‖s‖ + 2) := by
      rw [hpi_norm, Real.log_rpow Real.pi_pos, hpi_re]
      have hlogmono : Real.log 2 ≤ Real.log (‖s‖ + 2) :=
        Real.log_le_log (by norm_num) (by linarith [norm_nonneg s])
      have hmono2 : (Real.log Real.pi / (2 * Real.log 2)) * ‖s‖ * Real.log 2
          ≤ (Real.log Real.pi / (2 * Real.log 2)) * ‖s‖ * Real.log (‖s‖ + 2) := by
        apply mul_le_mul_of_nonneg_left hlogmono
        exact mul_nonneg hCnn (norm_nonneg s)
      have hmul : -(s.re) / 2 * Real.log Real.pi ≤ ‖s‖ / 2 * Real.log Real.pi := by
        apply mul_le_mul_of_nonneg_right _ (le_of_lt hlogpi)
        linarith
      have hCeq : (Real.log Real.pi / (2 * Real.log 2)) * ‖s‖ * Real.log 2
          = ‖s‖ / 2 * Real.log Real.pi := by
        field_simp
        try ring
      linarith [hmono2, hmul, hCeq]
    -- the Gamma factor
    have hnorm_half : ‖s / 2‖ = ‖s‖ / 2 := by simp
    have hG := hbound (s / 2) hs2pos
    rw [hnorm_half] at hG
    have hlogmono2 : Real.log (‖s‖ / 2 + 2) ≤ Real.log (‖s‖ + 2) :=
      Real.log_le_log (by positivity) (by linarith [norm_nonneg s])
    have hstep2 : A₀ * (‖s‖ / 2) * Real.log (‖s‖ / 2 + 2)
        ≤ (A₀ / 2) * ‖s‖ * Real.log (‖s‖ + 2) := by
      have hnn : 0 ≤ A₀ * (‖s‖ / 2) := mul_nonneg hA₀ (by positivity)
      have hthis := mul_le_mul_of_nonneg_left hlogmono2 hnn
      nlinarith [hthis]
    have hneglog : -Real.log ((s / 2).re) ≤ Real.log 4 := by
      have h : Real.log (1 / 4 : ℝ) ≤ Real.log ((s / 2).re) :=
        Real.log_le_log (by norm_num) hquarter
      have h14 : Real.log (1 / 4 : ℝ) = -Real.log 4 := by
        rw [show (1 / 4 : ℝ) = (4 : ℝ)⁻¹ by norm_num, Real.log_inv]
      linarith
    have hGamma_bound : Real.log ‖Complex.Gamma (s / 2)‖
        ≤ (A₀ / 2) * ‖s‖ * Real.log (‖s‖ + 2) + B₀ + Real.log 4 := by
      linarith [hG, hstep2, hneglog]
    -- put the two factors together
    have hG_pos : 0 < ‖Complex.Gamma (s / 2)‖ :=
      norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos hs2pos)
    have hfac : ‖Complex.Gammaℝ s‖
        = ‖(Real.pi : ℂ) ^ (-s / 2)‖ * ‖Complex.Gamma (s / 2)‖ := by
      rw [Complex.Gammaℝ_def, Complex.norm_mul]
    have hlog_mul : Real.log ‖Complex.Gammaℝ s‖
        = Real.log ‖(Real.pi : ℂ) ^ (-s / 2)‖ + Real.log ‖Complex.Gamma (s / 2)‖ := by
      rw [hfac, Real.log_mul (ne_of_gt hpi_pos) (ne_of_gt hG_pos)]
    have hfinal :
        (Real.log Real.pi / (2 * Real.log 2)) * ‖s‖ * Real.log (‖s‖ + 2)
          + ((A₀ / 2) * ‖s‖ * Real.log (‖s‖ + 2) + B₀ + Real.log 4)
        = (A₀ / 2 + Real.log Real.pi / (2 * Real.log 2)) * ‖s‖
            * Real.log (‖s‖ + 2) + (B₀ + Real.log 4) := by
      ring
    linarith [hlog_mul, hpi_bound, hGamma_bound, hfinal]

/-! ## A uniform bound for the Riemann zeta function on `re s ≥ 2` -/

/-- The norm of each `LSeries` term for `re s ≥ 2` is dominated by `1 / n ^ 2`. -/
theorem zeta_bound_norm_lseries_term_le_inv_sq {s : ℂ} (hs : 2 ≤ s.re) (n : ℕ) :
    ‖LSeries.term (1 : ℕ → ℂ) s n‖ ≤ 1 / (n : ℝ) ^ 2 := by
  rcases Nat.eq_zero_or_pos n with h | h
  · subst h
    simp [LSeries.term_def]
  · obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero h.ne'
    have hpos : (0 : ℝ) < ((k + 1 : ℕ) : ℝ) := by positivity
    rw [LSeries.term_def]
    simp only [Nat.succ_ne_zero, ↓reduceIte, Pi.one_apply, norm_div, norm_one,
      Complex.norm_natCast_cpow_of_pos (Nat.succ_pos k)]
    rw [one_div, one_div]
    rw [inv_le_inv₀ (Real.rpow_pos_of_pos hpos _) (by positivity)]
    have h1 : (1 : ℝ) ≤ ((k + 1 : ℕ) : ℝ) := by
      exact_mod_cast Nat.succ_le_succ (Nat.zero_le k)
    calc ((k + 1 : ℕ) : ℝ) ^ 2 = ((k + 1 : ℕ) : ℝ) ^ (2 : ℝ) := (Real.rpow_natCast _ 2).symm
      _ ≤ ((k + 1 : ℕ) : ℝ) ^ s.re := Real.rpow_le_rpow_of_exponent_le h1 hs

/-- The sum of `1 / n ^ 2` over the naturals is at most `2`. -/
theorem zeta_bound_tsum_one_div_sq_le_two : (∑' n : ℕ, 1 / (n : ℝ) ^ 2) ≤ 2 := by
  have hzeta : (∑' n : ℕ, 1 / (n : ℝ) ^ 2) = Real.pi ^ 2 / 6 := hasSum_zeta_two.tsum_eq
  have hpos := Real.pi_pos
  have h2 : Real.pi ^ 2 < (3.14159265358979323847 : ℝ) ^ 2 :=
    pow_lt_pow_left₀ Real.pi_lt_d20 hpos.le (by norm_num : (2 : ℕ) ≠ 0)
  have h3 : (3.14159265358979323847 : ℝ) ^ 2 < 12 := by norm_num
  rw [hzeta]
  linarith

/-- The Riemann zeta function is bounded by `2` on the half-plane `re s ≥ 2`. -/
theorem norm_riemannZeta_le_two {s : ℂ} (hs : 2 ≤ s.re) :
    ‖riemannZeta s‖ ≤ 2 := by
  have hs1 : 1 < s.re := by linarith
  have hzeta : LSeries (1 : ℕ → ℂ) s = riemannZeta s := LSeries_one_eq_riemannZeta hs1
  have hGsumm : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) :=
    (Real.summable_one_div_nat_pow (p := 2)).mpr (by norm_num)
  have hterm : ∀ n : ℕ, ‖LSeries.term (1 : ℕ → ℂ) s n‖ ≤ 1 / (n : ℝ) ^ 2 :=
    zeta_bound_norm_lseries_term_le_inv_sq hs
  have hsumm : Summable (fun n : ℕ => ‖LSeries.term (1 : ℕ → ℂ) s n‖) :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hterm hGsumm
  have hmain : ‖∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n‖ ≤
      ∑' n : ℕ, 1 / (n : ℝ) ^ 2 :=
    (norm_tsum_le_tsum_norm hsumm).trans (Summable.tsum_le_tsum hterm hsumm hGsumm)
  have hL : LSeries (1 : ℕ → ℂ) s = ∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n := rfl
  rw [← hzeta, hL]
  refine hmain.trans ?_
  exact zeta_bound_tsum_one_div_sq_le_two

/-! ## A uniform bound for the Riemann zeta function on `re s ≥ 3/2`

Adapts `norm_riemannZeta_le_two` to the half-plane `re s ≥ 3/2`, using the
integral test to bound `∑ n^{-3/2} ≤ 3`. -/

/-- For `re s ≥ 3/2` each `LSeries` term is dominated by `n^{-3/2}`. -/
theorem zeta32_norm_lseries_term_le_rpow {s : ℂ} (hs : (3 / 2 : ℝ) ≤ s.re) (n : ℕ) :
    ‖LSeries.term (1 : ℕ → ℂ) s n‖ ≤ (n : ℝ) ^ (-(3 / 2) : ℝ) := by
  rcases Nat.eq_zero_or_pos n with h | h
  · subst h
    have h0 : ((0 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) = 0 := by
      rw [Nat.cast_zero, Real.zero_rpow (by norm_num)]
    rw [h0]
    simp [LSeries.term_def]
  · obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero h.ne'
    have hpos : (0 : ℝ) < ((k + 1 : ℕ) : ℝ) := by positivity
    rw [LSeries.term_def]
    simp only [Nat.succ_ne_zero, ↓reduceIte, Pi.one_apply, norm_div, norm_one,
      Complex.norm_natCast_cpow_of_pos (Nat.succ_pos k)]
    rw [one_div, Real.rpow_neg hpos.le]
    rw [inv_le_inv₀ (Real.rpow_pos_of_pos hpos _) (Real.rpow_pos_of_pos hpos _)]
    have h1 : (1 : ℝ) ≤ ((k + 1 : ℕ) : ℝ) := by
      exact_mod_cast Nat.succ_le_succ (Nat.zero_le k)
    exact Real.rpow_le_rpow_of_exponent_le h1 hs

/-- The sum `∑ n^{-3/2}` is at most `3`. -/
theorem zeta32_tsum_rpow_le_three :
    (∑' n : ℕ, (n : ℝ) ^ (-(3 / 2) : ℝ)) ≤ 3 := by
  have hf0 : ((0 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) = 0 := by
    rw [Nat.cast_zero, Real.zero_rpow (by norm_num)]
  have hf1 : ((1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) = 1 := by
    rw [Nat.cast_one, Real.one_rpow]
  have hsumm : Summable (fun n : ℕ => (n : ℝ) ^ (-(3 / 2) : ℝ)) :=
    (Real.summable_nat_rpow (p := -(3 / 2))).mpr (by norm_num)
  have hshift : Summable (fun n : ℕ => ((n + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)) :=
    hsumm.comp_injective (i := Nat.succ) Nat.succ_injective
  have hstep1 : (∑' n : ℕ, (n : ℝ) ^ (-(3 / 2) : ℝ))
      = ((0 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)
        + ∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) := by
    simpa using hsumm.tsum_eq_zero_add
  have hstep2 : (∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ))
      = ((1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)
        + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) := by
    simpa using hshift.tsum_eq_zero_add
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-(3 / 2) : ℝ)) (Set.Ici ((1 : ℕ) : ℝ)) := by
    intro x hx y hy hxy
    refine Real.rpow_le_rpow_of_nonpos ?_ hxy (by norm_num)
    have hx1 : (1 : ℝ) ≤ x := by exact_mod_cast hx
    linarith
  have hc1 : (0 : ℝ) < ((1 : ℕ) : ℝ) := by norm_num
  have hint : IntegrableOn (fun x : ℝ => x ^ (-(3 / 2) : ℝ)) (Set.Ioi ((1 : ℕ) : ℝ)) :=
    integrableOn_Ioi_rpow_of_lt (a := -(3 / 2)) (c := ((1 : ℕ) : ℝ)) (by norm_num) hc1
  have hnonneg : ∀ t ∈ Set.Ioi ((1 : ℕ) : ℝ), 0 ≤ t ^ (-(3 / 2) : ℝ) := by
    intro t ht
    have ht1 : ((1 : ℕ) : ℝ) < t := Set.mem_Ioi.mp ht
    exact Real.rpow_nonneg
      (le_trans (by norm_num : (0 : ℝ) ≤ ((1 : ℕ) : ℝ)) ht1.le) _
  have htail := AntitoneOn.tsum_comp_add_le_integral
    (f := fun x : ℝ => x ^ (-(3 / 2) : ℝ)) 1 hanti hint hnonneg
  have hintval : (∫ x : ℝ in Set.Ioi ((1 : ℕ) : ℝ), x ^ (-(3 / 2) : ℝ)) = 2 := by
    have h := integral_Ioi_rpow_of_lt (a := -(3 / 2)) (c := ((1 : ℕ) : ℝ))
      (by norm_num) hc1
    rw [h]
    norm_num
  have htail2 : (∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)) ≤ 2 := by
    rw [hintval] at htail
    exact htail
  calc (∑' n : ℕ, (n : ℝ) ^ (-(3 / 2) : ℝ))
      = ((0 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)
        + ∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) := hstep1
    _ = ((0 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)
        + (((1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)
          + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ)) := by rw [hstep2]
    _ = 1 + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-(3 / 2) : ℝ) := by
        rw [hf0, hf1]; ring
    _ ≤ 1 + 2 := by linarith
    _ = 3 := by norm_num

/-- The Riemann zeta function is bounded on the half-plane `re s ≥ 3/2`. -/
theorem norm_riemannZeta_le_three_of_three_halves {s : ℂ} (hs : (3 / 2 : ℝ) ≤ s.re) :
    ‖riemannZeta s‖ ≤ 3 := by
  have hs1 : 1 < s.re := by linarith
  have hzeta : LSeries (1 : ℕ → ℂ) s = riemannZeta s := LSeries_one_eq_riemannZeta hs1
  have hGsumm : Summable (fun n : ℕ => (n : ℝ) ^ (-(3 / 2) : ℝ)) :=
    (Real.summable_nat_rpow (p := -(3 / 2))).mpr (by norm_num)
  have hterm : ∀ n : ℕ, ‖LSeries.term (1 : ℕ → ℂ) s n‖ ≤ (n : ℝ) ^ (-(3 / 2) : ℝ) :=
    zeta32_norm_lseries_term_le_rpow hs
  have hsumm : Summable (fun n : ℕ => ‖LSeries.term (1 : ℕ → ℂ) s n‖) :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hterm hGsumm
  have hmain : ‖∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n‖ ≤
      ∑' n : ℕ, (n : ℝ) ^ (-(3 / 2) : ℝ) :=
    (norm_tsum_le_tsum_norm hsumm).trans (Summable.tsum_le_tsum hterm hsumm hGsumm)
  have hL : LSeries (1 : ℕ → ℂ) s = ∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n := rfl
  rw [← hzeta, hL]
  exact hmain.trans zeta32_tsum_rpow_le_three

/-- There is a uniform bound for the Riemann zeta function on `re s ≥ 3/2`. -/
theorem exists_norm_riemannZeta_le_of_three_halves :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, (3 / 2 : ℝ) ≤ s.re → ‖riemannZeta s‖ ≤ C :=
  ⟨3, by norm_num, fun s hs => norm_riemannZeta_le_three_of_three_halves hs⟩


/-!
## Growth of `ζ` on the strip `1/2 ≤ re s ≤ 2`

The literal target

  `∃ A B, 0 ≤ A ∧ ∀ s, 1/2 ≤ re s → re s ≤ 2 → log ‖ζ s‖ ≤ A‖s‖log(‖s‖+2) + B`

is **false**.  `ζ` has a simple pole at `s = 1` with residue `1`, so `‖ζ s‖ → ∞` as
`s → 1` inside the strip, while the right-hand side stays bounded on a neighbourhood
of `1`.  The same obstruction kills the suggested "weaker" polynomial fallback
`‖ζ s‖ ≤ A(‖s‖+2)^2`.

What *is* true, and is proved here:

* `not_exists_uniform_bound_near_one` : no constant bounds `‖ζ‖` on the strip at all
  (the precise obstruction);
* `not_exists_bound_log_norm_zeta_strip` : the literal target is false;
* `not_exists_bound_norm_zeta_strip_poly` : the polynomial fallback is false;
* `norm_riemannZeta_le_one_add_inv_sub_one` : the explicit elementary bound
  `‖ζ s‖ ≤ 1 + 1/(re s - 1)` for `re s > 1` (the `p`-series plus an integral test);
* `exists_bound_log_norm_zeta_right_corrected` : the correct replacement on the
  half-plane `re s > 1`, with the pole subtracted in logarithmic form:
  `log ‖ζ s‖ ≤ A‖s‖log(‖s‖+2) + B - log (re s - 1)`.

The remaining gap -- a polynomial bound for `ζ` on the closed strip
`1/2 ≤ re s ≤ 1` away from `s = 1` -- needs an approximate functional equation
(Euler--Maclaurin / partial summation) or the Mellin integral representation of the
completed zeta function; neither is available in Mathlib, and the three-lines
theorem cannot supply it because its boundedness hypothesis fails for `ζ`.
-/

/-! ### The `p`-series bound `∑ n^{-σ} ≤ 1 + 1/(σ-1)` for `σ > 1` -/

/-- For `σ > 1` the `p`-series is bounded by `1 + 1/(σ-1)`. -/
theorem zeta_strip_tsum_nat_rpow_neg_le_one_add_inv_sub_one {σ : ℝ} (hσ : 1 < σ) :
    (∑' n : ℕ, (n : ℝ) ^ (-σ)) ≤ 1 + 1 / (σ - 1) := by
  have hσ0 : -σ ≠ 0 := by linarith
  have hf0 : ((0 : ℕ) : ℝ) ^ (-σ) = 0 := by
    rw [Nat.cast_zero, Real.zero_rpow hσ0]
  have hf1 : ((1 : ℕ) : ℝ) ^ (-σ) = 1 := by
    rw [Nat.cast_one, Real.one_rpow]
  have hsumm : Summable (fun n : ℕ => (n : ℝ) ^ (-σ)) :=
    (Real.summable_nat_rpow (p := -σ)).mpr (by linarith)
  have hshift : Summable (fun n : ℕ => ((n + 1 : ℕ) : ℝ) ^ (-σ)) :=
    hsumm.comp_injective (i := Nat.succ) Nat.succ_injective
  have hstep1 : (∑' n : ℕ, (n : ℝ) ^ (-σ))
      = ((0 : ℕ) : ℝ) ^ (-σ) + ∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-σ) := by
    simpa using hsumm.tsum_eq_zero_add
  have hstep2 : (∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-σ))
      = ((1 : ℕ) : ℝ) ^ (-σ) + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-σ) := by
    simpa using hshift.tsum_eq_zero_add
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-σ)) (Set.Ici ((1 : ℕ) : ℝ)) := by
    intro x hx y hy hxy
    refine Real.rpow_le_rpow_of_nonpos ?_ hxy (by linarith)
    have hx1 : (1 : ℝ) ≤ x := by exact_mod_cast hx
    linarith
  have hc1 : (0 : ℝ) < ((1 : ℕ) : ℝ) := by norm_num
  have hint : IntegrableOn (fun x : ℝ => x ^ (-σ)) (Set.Ioi ((1 : ℕ) : ℝ)) :=
    integrableOn_Ioi_rpow_of_lt (a := -σ) (c := ((1 : ℕ) : ℝ)) (by linarith) hc1
  have hnonneg : ∀ t ∈ Set.Ioi ((1 : ℕ) : ℝ), 0 ≤ t ^ (-σ) := by
    intro t ht
    have ht1 : ((1 : ℕ) : ℝ) < t := Set.mem_Ioi.mp ht
    exact Real.rpow_nonneg (le_trans (by norm_num : (0 : ℝ) ≤ ((1 : ℕ) : ℝ)) ht1.le) _
  have htail := AntitoneOn.tsum_comp_add_le_integral
    (f := fun x : ℝ => x ^ (-σ)) 1 hanti hint hnonneg
  have hintval : (∫ x : ℝ in Set.Ioi ((1 : ℕ) : ℝ), x ^ (-σ)) = 1 / (σ - 1) := by
    rw [integral_Ioi_rpow_of_lt (a := -σ) (c := ((1 : ℕ) : ℝ)) (by linarith) hc1]
    have h1 : ((1 : ℕ) : ℝ) ^ (-σ + 1) = 1 := by
      rw [Nat.cast_one]
      exact Real.one_rpow _
    rw [h1]
    rw [div_eq_div_iff (by linarith : (-σ + 1) ≠ 0) (by linarith : (σ - 1) ≠ 0)]
    ring
  have htail2 : (∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-σ)) ≤ 1 / (σ - 1) := by
    rw [hintval] at htail
    exact htail
  calc (∑' n : ℕ, (n : ℝ) ^ (-σ))
      = ((0 : ℕ) : ℝ) ^ (-σ) + ∑' n : ℕ, ((n + 1 : ℕ) : ℝ) ^ (-σ) := hstep1
    _ = ((0 : ℕ) : ℝ) ^ (-σ)
        + (((1 : ℕ) : ℝ) ^ (-σ) + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-σ)) := by rw [hstep2]
    _ = 1 + ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ (-σ) := by
        rw [hf0, hf1]; ring
    _ ≤ 1 + 1 / (σ - 1) := by linarith

/-! ### An exact formula for the norm of an `LSeries` term -/

/-- For `re s > 0`, the `n`-th term of the Dirichlet series of `ζ` has norm `n ^ (-re s)`. -/
theorem zeta_strip_norm_lseries_term_one_eq_rpow {s : ℂ} (hs : 0 < s.re) (n : ℕ) :
    ‖LSeries.term (1 : ℕ → ℂ) s n‖ = (n : ℝ) ^ (-s.re) := by
  rcases Nat.eq_zero_or_pos n with h | h
  · subst h
    have hσ0 : -s.re ≠ 0 := by linarith
    simp [LSeries.term_def, Real.zero_rpow hσ0]
  · obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero h.ne'
    rw [LSeries.term_def]
    simp only [Nat.succ_ne_zero, ↓reduceIte, Pi.one_apply, norm_div, norm_one,
      Complex.norm_natCast_cpow_of_pos (Nat.succ_pos k)]
    rw [one_div, Real.rpow_neg (by positivity)]

/-! ### The explicit bound `‖ζ s‖ ≤ 1 + 1/(re s - 1)` on `re s > 1` -/

/-- On the half-plane `re s > 1` we have `‖ζ s‖ ≤ 1 + 1/(re s - 1)`. -/
theorem norm_riemannZeta_le_one_add_inv_sub_one {s : ℂ} (hs : 1 < s.re) :
    ‖riemannZeta s‖ ≤ 1 + 1 / (s.re - 1) := by
  have hzeta : LSeries (1 : ℕ → ℂ) s = riemannZeta s := LSeries_one_eq_riemannZeta hs
  have hGsumm : Summable (fun n : ℕ => (n : ℝ) ^ (-s.re)) :=
    (Real.summable_nat_rpow (p := -s.re)).mpr (by linarith)
  have hterm : ∀ n : ℕ, ‖LSeries.term (1 : ℕ → ℂ) s n‖ ≤ (n : ℝ) ^ (-s.re) :=
    fun n => le_of_eq (zeta_strip_norm_lseries_term_one_eq_rpow (by linarith) n)
  have hsumm : Summable (fun n : ℕ => ‖LSeries.term (1 : ℕ → ℂ) s n‖) :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hterm hGsumm
  have hmain : ‖∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n‖ ≤
      ∑' n : ℕ, (n : ℝ) ^ (-s.re) :=
    (norm_tsum_le_tsum_norm hsumm).trans (Summable.tsum_le_tsum hterm hsumm hGsumm)
  have hL : LSeries (1 : ℕ → ℂ) s = ∑' n : ℕ, LSeries.term (1 : ℕ → ℂ) s n := rfl
  rw [← hzeta, hL]
  exact hmain.trans (zeta_strip_tsum_nat_rpow_neg_le_one_add_inv_sub_one hs)

/-! ### The corrected logarithmic growth bound on `re s > 1` -/

/-- The correct replacement for the (false) strip bound, on the half-plane `re s > 1`:
the pole at `s = 1` is paid for by a `- log (re s - 1)` term. -/
theorem exists_bound_log_norm_zeta_right_corrected :
    ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, 1 < s.re →
      Real.log ‖riemannZeta s‖
        ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B - Real.log (s.re - 1) := by
  refine ⟨1, Real.log 2, by norm_num, fun s hs => ?_⟩
  have hx : 0 < s.re - 1 := by linarith
  have hnorm : 0 ≤ Real.log (‖s‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg s])
  have h1 : ‖riemannZeta s‖ ≤ 1 + 1 / (s.re - 1) := norm_riemannZeta_le_one_add_inv_sub_one hs
  have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  rcases le_or_gt (s.re - 1) 1 with hsmall | hbig
  · have hlog : Real.log ‖riemannZeta s‖ ≤ Real.log 2 - Real.log (s.re - 1) := by
      rcases eq_or_ne ‖riemannZeta s‖ 0 with hzero | hne
      · rw [hzero, Real.log_zero]
        have hle : Real.log (s.re - 1) ≤ 0 := Real.log_nonpos hx.le hsmall
        linarith
      · have hpos : 0 < ‖riemannZeta s‖ := lt_of_le_of_ne (norm_nonneg _) (Ne.symm hne)
        have h2 : 1 + 1 / (s.re - 1) ≤ 2 / (s.re - 1) := by
          rw [le_div_iff₀ hx]
          have heq : (1 + 1 / (s.re - 1)) * (s.re - 1) = (s.re - 1) + 1 := by
            field_simp
          rw [heq]
          linarith
        have h3 : Real.log ‖riemannZeta s‖ ≤ Real.log (2 / (s.re - 1)) :=
          Real.log_le_log hpos (h1.trans h2)
        rwa [Real.log_div (by norm_num) (ne_of_gt hx)] at h3
    calc Real.log ‖riemannZeta s‖ ≤ Real.log 2 - Real.log (s.re - 1) := hlog
      _ ≤ 1 * ‖s‖ * Real.log (‖s‖ + 2) + Real.log 2 - Real.log (s.re - 1) := by
          have hnn : 0 ≤ ‖s‖ * Real.log (‖s‖ + 2) := mul_nonneg (norm_nonneg s) hnorm
          nlinarith
  · have hlt : ‖riemannZeta s‖ ≤ 2 := by
      refine h1.trans ?_
      have h2 : 1 / (s.re - 1) ≤ 1 := by
        rw [div_le_one hx]
        linarith
      linarith
    have hlog : Real.log ‖riemannZeta s‖ ≤ Real.log 2 := by
      rcases eq_or_ne ‖riemannZeta s‖ 0 with hzero | hne
      · rw [hzero, Real.log_zero]
        exact hlog2.le
      · exact Real.log_le_log (lt_of_le_of_ne (norm_nonneg _) (Ne.symm hne)) hlt
    have hnorm1 : (1 : ℝ) ≤ ‖s‖ := by
      have h2 : (1 : ℝ) < s.re := hs
      linarith [Complex.re_le_norm s]
    have hsre : s.re - 1 ≤ ‖s‖ + 2 := by
      have := Complex.re_le_norm s
      linarith
    have hlogbound : Real.log (s.re - 1) ≤ Real.log (‖s‖ + 2) :=
      Real.log_le_log hx hsre
    have hkey : Real.log (‖s‖ + 2) ≤ ‖s‖ * Real.log (‖s‖ + 2) := by
      have := mul_le_mul_of_nonneg_right hnorm1 hnorm
      simpa using this
    have hfinal : Real.log (s.re - 1) ≤ 1 * ‖s‖ * Real.log (‖s‖ + 2) := by
      refine hlogbound.trans ?_
      calc Real.log (‖s‖ + 2) ≤ ‖s‖ * Real.log (‖s‖ + 2) := hkey
        _ = 1 * ‖s‖ * Real.log (‖s‖ + 2) := by ring
    calc Real.log ‖riemannZeta s‖ ≤ Real.log 2 := hlog
      _ ≤ 1 * ‖s‖ * Real.log (‖s‖ + 2) + Real.log 2 - Real.log (s.re - 1) := by
          linarith

/-! ### The obstruction: no uniform bound on the strip -/

/-- No constant bounds `‖ζ‖` on the closed strip `1/2 ≤ re s ≤ 2` near `s = 1`:
the pole at `s = 1` sits inside it. -/
theorem not_exists_uniform_bound_near_one (C : ℝ) :
    ¬ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re → s.re ≤ 2 → ‖s‖ ≤ 2 → ‖riemannZeta s‖ ≤ C := by
  intro hC
  -- `(s - 1) * ζ s → 1` as `s → 1`, so `‖ζ s‖ ≥ 1/(2‖s-1‖)` near `1`.
  have hball : ∀ᶠ s : ℂ in 𝓝[≠] (1 : ℂ), ‖(s - 1) * riemannZeta s - 1‖ < 1 / 2 := by
    have hb : (0 : ℝ) < 1 / 2 := by norm_num
    have h1 := riemannZeta_residue_one.eventually (Metric.ball_mem_nhds (1 : ℂ) hb)
    filter_upwards [h1] with s hs
    rwa [dist_eq_norm] at hs
  have hset : {s : ℂ | ‖(s - 1) * riemannZeta s - 1‖ < 1 / 2} ∈ 𝓝[≠] (1 : ℂ) := hball
  rw [Metric.mem_nhdsWithin_iff] at hset
  obtain ⟨ε, hε, hε'⟩ := hset
  have hCpos : (0 : ℝ) < |C| + 1 := by positivity
  set t : ℝ := min (ε / 2) (min (1 / 2) (1 / (4 * (|C| + 1)))) with ht
  have ht0 : 0 < t := by
    refine lt_min (by linarith) (lt_min (by norm_num) ?_)
    positivity
  have htε : t < ε := lt_of_le_of_lt (min_le_left _ _) (by linarith)
  have ht1 : t ≤ 1 / 2 := (min_le_right _ _).trans (min_le_left _ _)
  have htC : t ≤ 1 / (4 * (|C| + 1)) := (min_le_right _ _).trans (min_le_right _ _)
  set s : ℂ := 1 + (t : ℂ)
  have hsub : s - 1 = (t : ℂ) := by simp [s]
  have hne : s ≠ 1 := by
    intro h
    have h0 : (t : ℂ) = 0 := by rw [← hsub, h]; simp
    have : t = 0 := by exact_mod_cast h0
    linarith
  have hdist : ‖s - 1‖ = t := by
    rw [hsub, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0]
  have hmem : s ∈ Metric.ball (1 : ℂ) ε := by
    rw [Metric.mem_ball, dist_eq_norm, hdist]
    exact htε
  have hclose : ‖(s - 1) * riemannZeta s - 1‖ < 1 / 2 := hε' ⟨hmem, by simpa using hne⟩
  -- hence `1/2 ≤ ‖(s-1) * ζ s‖ = t ‖ζ s‖`
  have hbig : (1 / 2 : ℝ) ≤ t * ‖riemannZeta s‖ := by
    have h3 : ‖(1 : ℂ) - (s - 1) * riemannZeta s‖ < 1 / 2 := by
      rwa [norm_sub_rev]
    have h4 : (1 : ℝ) - ‖(1 : ℂ) - (s - 1) * riemannZeta s‖ ≤
        ‖(s - 1) * riemannZeta s‖ := by
      have h5 := norm_sub_norm_le (1 : ℂ) ((s - 1) * riemannZeta s)
      rw [norm_one] at h5
      linarith
    rw [norm_mul, hdist] at h4
    linarith
  have hlower : 1 / (2 * t) ≤ ‖riemannZeta s‖ := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith [hbig]
  have hupper : 2 * (|C| + 1) ≤ 1 / (2 * t) := by
    rw [le_div_iff₀ (by positivity)]
    have hstep : 2 * (|C| + 1) * (2 * t) ≤
        2 * (|C| + 1) * (2 * (1 / (4 * (|C| + 1)))) := by
      refine mul_le_mul_of_nonneg_left ?_ (by positivity)
      exact mul_le_mul_of_nonneg_left htC (by norm_num)
    have hval : 2 * (|C| + 1) * (2 * (1 / (4 * (|C| + 1)))) = 1 := by
      field_simp
      norm_num
    linarith
  have hnorm_s : ‖s‖ ≤ 2 := by
    have : ‖s‖ ≤ ‖(1 : ℂ)‖ + ‖(t : ℂ)‖ := norm_add_le _ _
    rw [norm_one, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0] at this
    linarith
  have hbound := hC s (by simp [s]; linarith) (by simp [s]; linarith) hnorm_s
  have : C < ‖riemannZeta s‖ := by
    have := le_abs_self C
    linarith
  linarith

/-- The literal target of the brief is **false**. -/
theorem not_exists_bound_log_norm_zeta_strip :
    ¬ ∃ A B : ℝ, 0 ≤ A ∧ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re → s.re ≤ 2 →
      Real.log ‖riemannZeta s‖ ≤ A * ‖s‖ * Real.log (‖s‖ + 2) + B := by
  rintro ⟨A, B, hA, hbound⟩
  refine not_exists_uniform_bound_near_one (Real.exp (A * 2 * Real.log 4 + B)) ?_
  intro s h1 h2 hsn
  have hlog := hbound s h1 h2
  have hnormle : A * ‖s‖ * Real.log (‖s‖ + 2) + B ≤ A * 2 * Real.log 4 + B := by
    have hlog4 : Real.log (‖s‖ + 2) ≤ Real.log 4 :=
      Real.log_le_log (by linarith [norm_nonneg s]) (by linarith)
    have hA2 : 0 ≤ A * 2 := by linarith
    have hstep1 : A * ‖s‖ ≤ A * 2 := by
      have := mul_le_mul_of_nonneg_left hsn hA
      linarith
    have hnonneg : 0 ≤ Real.log (‖s‖ + 2) := Real.log_nonneg (by linarith [norm_nonneg s])
    have hstep2 : A * ‖s‖ * Real.log (‖s‖ + 2) ≤ (A * 2) * Real.log (‖s‖ + 2) := by
      exact mul_le_mul_of_nonneg_right hstep1 hnonneg
    have hstep3 : (A * 2) * Real.log (‖s‖ + 2) ≤ (A * 2) * Real.log 4 :=
      mul_le_mul_of_nonneg_left hlog4 hA2
    have heq : (A * 2) * Real.log 4 = A * 2 * Real.log 4 := by ring
    linarith
  rcases eq_or_ne ‖riemannZeta s‖ 0 with hz | hnz
  · rw [hz]
    exact (Real.exp_pos _).le
  · have hpos : 0 < ‖riemannZeta s‖ := lt_of_le_of_ne (norm_nonneg _) (Ne.symm hnz)
    calc ‖riemannZeta s‖ ≤ Real.exp (A * ‖s‖ * Real.log (‖s‖ + 2) + B) :=
          (Real.log_le_iff_le_exp hpos).mp hlog
      _ ≤ Real.exp (A * 2 * Real.log 4 + B) := Real.exp_le_exp.mpr hnormle

/-- The polynomial fallback `‖ζ s‖ ≤ A(‖s‖+2)^2` on the strip is **also false**. -/
theorem not_exists_bound_norm_zeta_strip_poly :
    ¬ ∃ A : ℝ, 0 ≤ A ∧ ∀ s : ℂ, (1 / 2 : ℝ) ≤ s.re → s.re ≤ 2 →
      ‖riemannZeta s‖ ≤ A * (‖s‖ + 2) ^ 2 := by
  rintro ⟨A, hA, hbound⟩
  refine not_exists_uniform_bound_near_one (A * 16) ?_
  intro s h1 h2 hsn
  refine (hbound s h1 h2).trans ?_
  have h4 : 0 ≤ ‖s‖ + 2 := by positivity
  have hsq : (‖s‖ + 2) ^ 2 ≤ 4 ^ 2 := by
    refine pow_le_pow_left₀ h4 ?_ 2
    linarith
  have h16 : A * (‖s‖ + 2) ^ 2 ≤ A * 16 := by
    have := mul_le_mul_of_nonneg_left hsq hA
    nlinarith
  linarith

/-! ### Upper bounds for the canonical product (`p = 1`)

The mirror images of the `..._lower` estimates above: on the disc where every
prescribed zero is at least twice as far from the origin as `z`, the logarithm
of `‖P(z)‖` is bounded above by `2‖z‖ ∑ 1/‖a‖`. -/

/-- **An upper bound for the scaled elementary factor** on the disc
`‖z‖ ≤ ‖a‖/2`: `log ‖E_1(z/a)‖ ≤ 2‖z‖/‖a‖`. -/
theorem upper_log_norm_weierstrassFactor_one_div {a z : ℂ} (ha : a ≠ 0)
    (hz : ‖z‖ ≤ ‖a‖ / 2) :
    Real.log ‖weierstrassFactor 1 (z / a)‖ ≤ 2 * ‖z‖ / ‖a‖ := by
  have hanorm : 0 < ‖a‖ := norm_pos_iff.mpr ha
  set w : ℂ := z / a with hw
  have hwnorm : ‖w‖ = ‖z‖ / ‖a‖ := by rw [hw, norm_div]
  have hwle : ‖w‖ ≤ 1 / 2 := by
    rw [hwnorm, div_le_iff₀ hanorm]
    nlinarith
  have hfac : weierstrassFactor 1 (z / a) = (1 - w) * cexp w := by
    simp [weierstrassFactor, hw]
  rw [hfac]
  have hne1 : (1 : ℂ) - w ≠ 0 := by
    intro h
    have h1 : (1 : ℂ) = w := sub_eq_zero.mp h
    have h2 : ‖w‖ = 1 := by
      rw [← h1]
      simp
    rw [h2] at hwle
    norm_num at hwle
  have hnorm : ‖(1 - w) * cexp w‖ = ‖1 - w‖ * Real.exp w.re := by
    rw [norm_mul, Complex.norm_exp]
  rw [hnorm]
  have hpos : (0 : ℝ) < ‖1 - w‖ := norm_pos_iff.mpr hne1
  have hlog : Real.log (‖1 - w‖ * Real.exp w.re) = Real.log ‖1 - w‖ + w.re := by
    rw [Real.log_mul (ne_of_gt hpos) (Real.exp_ne_zero w.re), Real.log_exp]
  rw [hlog]
  -- `log ‖1 - w‖ ≤ ‖w‖`
  have hlogle : Real.log ‖1 - w‖ ≤ ‖w‖ := by
    have hle_norm : ‖1 - w‖ ≤ 1 + ‖w‖ := by
      have h := norm_sub_le (1 : ℂ) w
      rw [norm_one] at h
      linarith
    have h1pw : (0 : ℝ) < 1 + ‖w‖ := by positivity
    have h2 : Real.log ‖1 - w‖ ≤ Real.log (1 + ‖w‖) :=
      Real.log_le_log hpos hle_norm
    have h3 : Real.log (1 + ‖w‖) ≤ ‖w‖ := by
      have h4 := Real.log_le_sub_one_of_pos h1pw
      linarith
    linarith
  have hre : w.re ≤ ‖w‖ := by
    have h := Complex.abs_re_le_norm w
    exact le_trans (le_abs_self w.re) h
  have hkey : Real.log ‖1 - w‖ + w.re ≤ 2 * ‖w‖ := by linarith
  calc Real.log ‖1 - w‖ + w.re ≤ 2 * ‖w‖ := hkey
    _ = 2 * ‖z‖ / ‖a‖ := by rw [hwnorm]; ring

/-- **An upper bound for the finite canonical product** on the disc where every
prescribed zero is at least twice as far from the origin as `z`:
`log ‖finiteCanonicalProduct 1 S z‖ ≤ 2‖z‖·∑_{a∈S} 1/‖a‖`. -/
theorem upper_log_norm_finiteCanonicalProduct_one (S : Finset ℂ)
    (h0 : ∀ a ∈ S, a ≠ 0) {z : ℂ} (hz : ∀ a ∈ S, ‖z‖ ≤ ‖a‖ / 2) :
    Real.log ‖finiteCanonicalProduct 1 S z‖
      ≤ 2 * ‖z‖ * ∑ a ∈ S, (1 / ‖a‖) := by
  have hne : ∀ a ∈ S, weierstrassFactor 1 (z / a) ≠ 0 := by
    intro a ha h
    have hzw : z / a = 1 := (weierstrassFactor_eq_zero_iff 1 (z / a)).mp h
    have h1 : z = a := by
      rw [div_eq_one_iff_eq (h0 a ha)] at hzw
      simpa using hzw
    have h2 : ‖z‖ = ‖a‖ := by rw [h1]
    have h3 := hz a ha
    rw [h2] at h3
    have hapos : (0 : ℝ) < ‖a‖ := norm_pos_iff.mpr (h0 a ha)
    linarith
  have hnorm_prod : ‖finiteCanonicalProduct 1 S z‖
      = ∏ a ∈ S, ‖weierstrassFactor 1 (z / a)‖ := by
    simp only [finiteCanonicalProduct]
    rw [norm_prod]
  rw [hnorm_prod, Real.log_prod (fun a ha => norm_ne_zero_iff.mpr (hne a ha))]
  have hsum : ∑ a ∈ S, Real.log ‖weierstrassFactor 1 (z / a)‖
      ≤ ∑ a ∈ S, (2 * ‖z‖ / ‖a‖) :=
    Finset.sum_le_sum (fun a ha =>
      upper_log_norm_weierstrassFactor_one_div (h0 a ha) (hz a ha))
  have hconst : ∑ a ∈ S, (2 * ‖z‖ / ‖a‖)
      = 2 * ‖z‖ * ∑ a ∈ S, (1 / ‖a‖) := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl (fun a ha => ?_)
    ring
  linarith [hconst]

/-- **Upper bound for the logarithm of the norm of the infinite canonical
product** (in the case `p = 1`), on the disc where every prescribed zero is at
least twice as far from the origin as `z`:
`log ‖∏' n, E₁(z/a n)‖ ≤ 2‖z‖·∑' n, 1/‖a n‖`. -/
theorem upper_log_norm_tprod_weierstrassFactor_one {a : ℕ → ℂ} {z : ℂ}
    (ha0 : ∀ n, a n ≠ 0) (hsep : ∀ n, ‖z‖ ≤ ‖a n‖ / 2)
    (hsum : Summable (fun n => 1 / ‖a n‖))
    (hconv : Multipliable (fun n => weierstrassFactor 1 (z / a n))) :
    Real.log ‖∏' n, weierstrassFactor 1 (z / a n)‖
      ≤ 2 * ‖z‖ * (∑' n, 1 / ‖a n‖) := by
  by_cases hz : z = 0
  · subst hz
    have hfun : (fun n : ℕ => weierstrassFactor 1 ((0 : ℂ) / a n)) = fun _ => (1 : ℂ) := by
      funext n
      rw [zero_div, weierstrassFactor_zero]
    rw [hfun, tprod_one, norm_one, Real.log_one, norm_zero]
    simp
  · -- each factor is nonzero
    have hfac : ∀ n : ℕ, weierstrassFactor 1 (z / a n) ≠ 0 := by
      intro n h
      have hzw : z / a n = 1 := (weierstrassFactor_eq_zero_iff 1 (z / a n)).mp h
      have h1 : z = a n := by
        rw [div_eq_one_iff_eq (ha0 n)] at hzw
        exact hzw
      have h2 : ‖z‖ = ‖a n‖ := by rw [h1]
      have h3 := hsep n
      rw [h2] at h3
      have hapos : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
      linarith
    -- the finite upper bound
    have hstep : ∀ N : ℕ, Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖
        ≤ 2 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖) := by
      intro N
      have hne : ∀ n ∈ Finset.range N, ‖weierstrassFactor 1 (z / a n)‖ ≠ 0 :=
        fun n _ => norm_ne_zero_iff.mpr (hfac n)
      have hlog : Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖
          = ∑ n ∈ Finset.range N, Real.log ‖weierstrassFactor 1 (z / a n)‖ := by
        rw [norm_prod]
        exact Real.log_prod (s := Finset.range N)
          (f := fun n => ‖weierstrassFactor 1 (z / a n)‖) hne
      rw [hlog]
      have hle : ∑ n ∈ Finset.range N, Real.log ‖weierstrassFactor 1 (z / a n)‖
          ≤ ∑ n ∈ Finset.range N, (2 * ‖z‖ / ‖a n‖) :=
        Finset.sum_le_sum (fun n _ =>
          upper_log_norm_weierstrassFactor_one_div (ha0 n) (hsep n))
      have hconst : ∑ n ∈ Finset.range N, (2 * ‖z‖ / ‖a n‖)
          = 2 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖) := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl (fun n _ => by ring)
      linarith
    -- summability of the quadratic terms, by comparison with `∑ 1/‖a n‖`
    have hsum2 : Summable (fun n : ℕ => ‖z‖ ^ (1 + 1) / ‖a n‖ ^ (1 + 1)) := by
      have hbase : Summable (fun n : ℕ => (‖z‖ / 2) * (1 / ‖a n‖)) :=
        hsum.mul_left (‖z‖ / 2)
      refine Summable.of_nonneg_of_le (fun n => ?_) (fun n => ?_) hbase
      · positivity
      · have han : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
        have h1 : ‖z‖ / ‖a n‖ ≤ 1 / 2 := by
          rw [div_le_iff₀ han]
          linarith [hsep n]
        have h2 : 0 ≤ ‖z‖ / ‖a n‖ := by positivity
        have h3 : (‖z‖ / ‖a n‖) ^ 2 ≤ (‖z‖ / 2) * (1 / ‖a n‖) := by
          have h4 : (‖z‖ / ‖a n‖) ^ 2 ≤ (1 / 2) * (‖z‖ / ‖a n‖) := by
            nlinarith [mul_le_mul_of_nonneg_left h1 h2]
          have h5 : (1 / 2) * (‖z‖ / ‖a n‖) = (‖z‖ / 2) * (1 / ‖a n‖) := by ring
          linarith
        calc ‖z‖ ^ (1 + 1) / ‖a n‖ ^ (1 + 1) = (‖z‖ / ‖a n‖) ^ 2 := by
              rw [show (1 + 1 : ℕ) = 2 from by norm_num, div_pow]
          _ ≤ (‖z‖ / 2) * (1 / ‖a n‖) := h3
    -- the infinite product does not vanish
    have hne_tprod : (∏' n, weierstrassFactor 1 (z / a n)) ≠ 0 := by
      have ha : ∀ n, 2 * ‖z‖ ≤ ‖a n‖ := by
        intro n
        linarith [hsep n]
      have hzne : ∀ n, z ≠ a n := by
        intro n h
        have h2 : ‖z‖ = ‖a n‖ := by rw [h]
        have h3 := hsep n
        rw [h2] at h3
        have hapos : (0 : ℝ) < ‖a n‖ := norm_pos_iff.mpr (ha0 n)
        linarith
      exact tprod_weierstrassFactor_ne_zero hz ha hsum2 hzne
    -- passage to the limit
    have hL : Tendsto (fun N : ℕ => 2 * ‖z‖ * ∑ n ∈ Finset.range N, (1 / ‖a n‖))
        atTop (𝓝 (2 * ‖z‖ * ∑' n, 1 / ‖a n‖)) :=
      (hsum.hasSum.tendsto_sum_nat).const_mul (2 * ‖z‖)
    have hR : Tendsto
        (fun N : ℕ => Real.log ‖∏ n ∈ Finset.range N, weierstrassFactor 1 (z / a n)‖)
        atTop (𝓝 (Real.log ‖∏' n, weierstrassFactor 1 (z / a n)‖)) := by
      have hprod := hconv.hasProd.tendsto_prod_nat
      have hnorm := hprod.norm
      exact (Real.continuousAt_log (norm_ne_zero_iff.mpr hne_tprod)).tendsto.comp hnorm
    exact le_of_tendsto_of_tendsto' hR hL hstep


/-- **Maximum modulus on a sphere**: an entire function bounded by `M` on the sphere
of radius `R` is bounded by `M` on the closed ball. -/
theorem norm_le_of_forall_mem_sphere_le {f : ℂ → ℂ} (hf : Differentiable ℂ f) {R M : ℝ}
    (hR : 0 < R) (h : ∀ w : ℂ, ‖w‖ = R → ‖f w‖ ≤ M) :
    ∀ z : ℂ, ‖z‖ ≤ R → ‖f z‖ ≤ M := by
  intro z hz
  refine Complex.norm_le_of_forall_mem_frontier_norm_le (U := Metric.ball (0 : ℂ) R)
    Metric.isBounded_ball ?_ ?_ ?_
  · exact hf.diffContOnCl
  · intro w hw
    rw [frontier_ball (0 : ℂ) hR.ne', mem_sphere_iff_norm] at hw
    exact h w (by simpa using hw)
  · rw [closure_ball (0 : ℂ) hR.ne', mem_closedBall_iff_norm]
    simpa [dist_eq_norm] using hz


/-- **Mean value property for a zero-free entire function**: the circle average of
`log ‖h‖` equals `log ‖h c‖`. This is the Jensen/Poisson input of the assembly
(see note 68): it is what turns the divisor cancellation between `ξ₀` and its
canonical product into a statement about the quotient. -/
theorem circleAverage_log_norm_of_forall_ne_zero {h : ℂ → ℂ} (hh : Differentiable ℂ h)
    (hne : ∀ z, h z ≠ 0) (c : ℂ) (R : ℝ) :
    Real.circleAverage (fun z => Real.log ‖h z‖) c R = Real.log ‖h c‖ := by
  have h₁ : AnalyticOnNhd ℂ h (Metric.closedBall c |R|) :=
    fun z _ => hh.analyticAt z
  have h₂ : ∀ u ∈ Metric.closedBall c |R|, h u ≠ 0 := fun u _ => hne u
  exact AnalyticOnNhd.circleAverage_log_norm_of_ne_zero h₁ h₂


/-!
# The Jensen-formula bound on the logarithmic divisor sum

For an entire function `f` with `f 0 ≠ 0` and a global growth bound
`log ‖f z‖ ≤ A ‖z‖ log(‖z‖ + 2) + B`, Jensen's formula gives

`∑ᶠ u, ord_u f * log (R / ‖u‖) = circleAverage (log ‖f ·‖) 0 R - log ‖f 0‖
                              ≤ A R log (R + 2) + B - log ‖f 0‖`.

Note the correction `- log ‖f 0‖`: it cannot be removed.  Indeed the literal
inequality without it is false: take `f ≡ 1/2`, `A = 0`, `B = -log 2`, `R = 1`.
Then the hypothesis holds with equality (`log ‖f z‖ = -log 2 = B` for all `z`),
the divisor sum vanishes because `f` has no zeros and no poles, while the
right-hand side is `B = -log 2 < 0`.  Hence the statements below carry the
extra constant `|log ‖f 0‖|` (which is `0` exactly when `‖f 0‖ = 1`, so the
literal statement does hold whenever `‖f 0‖ = 1`, e.g. for `f 0 = 1`).
-/

open Complex Metric in
set_option maxHeartbeats 2000000 in
set_option linter.unusedVariables false in
/-- Jensen's formula plus a pointwise growth bound for `log ‖f‖` bounds the
divisor sum, up to the unavoidable constant `|log ‖f 0‖|`. -/
theorem divsum_log_le_of_growth {f : ℂ → ℂ} {A B : ℝ} {R : ℝ}
    (hR : 0 < R) (hA : 0 ≤ A) (hf : Differentiable ℂ f)
    (h0 : f 0 ≠ 0)
    (h : ∀ z, Real.log ‖f z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B) :
    (∑ᶠ u, (MeromorphicOn.divisor f (Metric.closedBall 0 R)).toFun u
        * Real.log (R / ‖u‖)) ≤ A * R * Real.log (R + 2) + B + |Real.log ‖f 0‖| := by
  have hana : AnalyticOnNhd ℂ f (Metric.closedBall 0 R) := fun z _ => hf.analyticAt z
  have hana' : AnalyticOnNhd ℂ f (Metric.closedBall 0 |R|) := fun z _ => hf.analyticAt z
  -- Jensen's formula with centre `0`.
  have hJ := hana'.circleAverage_log_norm (c := 0) (R := R) (f := f) hR.ne' h0
  have hJ' : Real.circleAverage (fun z => Real.log ‖f z‖) 0 R
      = (∑ᶠ u, (MeromorphicOn.divisor f (Metric.closedBall 0 R)).toFun u
          * Real.log (R / ‖u‖)) + Real.log ‖f 0‖ := by
    rw [hJ, abs_of_pos hR]
    congr 1
    apply finsum_congr
    intro u
    simp [div_eq_mul_inv]
  -- Bound the circle average by the pointwise growth bound on the sphere.
  have hbdd : Real.circleAverage (fun z => Real.log ‖f z‖) 0 R
      ≤ A * R * Real.log (R + 2) + B := by
    apply Real.circleAverage_mono_on_of_le_circle
    · have hmer : MeromorphicOn f (Metric.sphere (0 : ℂ) |R|) := by
        rw [abs_of_pos hR]
        exact hana.mono Metric.sphere_subset_closedBall |>.meromorphicOn
      exact hmer.circleIntegrable_log_norm
    · intro z hz
      rw [Metric.mem_sphere, dist_eq_norm', zero_sub, norm_neg, abs_of_pos hR] at hz
      have hzR : ‖z‖ = R := hz
      simpa [hzR] using h z
  have habs : -Real.log ‖f 0‖ ≤ |Real.log ‖f 0‖| := neg_le_abs _
  linarith [hJ', hbdd, habs]

open Complex Metric in
set_option maxHeartbeats 2000000 in
set_option linter.unusedVariables false in
/-- The same bound with Jensen's correction term written as the trailing
coefficient at `0`; for an entire `f` with `f 0 ≠ 0` this coefficient is `f 0`. -/
theorem divsum_log_le_of_growth_trailingCoeff {f : ℂ → ℂ} {A B : ℝ} {R : ℝ}
    (hR : 0 < R) (hA : 0 ≤ A) (hf : Differentiable ℂ f)
    (h0 : f 0 ≠ 0)
    (h : ∀ z, Real.log ‖f z‖ ≤ A * ‖z‖ * Real.log (‖z‖ + 2) + B) :
    (∑ᶠ u, (MeromorphicOn.divisor f (Metric.closedBall 0 R)).toFun u
        * Real.log (R / ‖u‖))
      ≤ A * R * Real.log (R + 2) + B + |Real.log ‖meromorphicTrailingCoeffAt f 0‖| := by
  have ht : meromorphicTrailingCoeffAt f 0 = f 0 := by
    simp [hf.analyticAt 0, h0]
  rw [ht]
  exact divsum_log_le_of_growth hR hA hf h0 h

end AbsoluteHodgeHadamard
