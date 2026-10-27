import Mathlib

/-!
# The tent test function and its autocorrelation

This file fixes the test function used by the P4 dossier and proves the
elementary properties of its autocorrelation.  It does **not** prove that
`tentAutocorr` is the convolution of `tent` with itself, nor the explicit
formula; those are source claims recorded in the README.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteExplicitFormula
open MeasureTheory

/-- The tent function `max 0 (1 - |x|)`. -/
def tent (x : ℝ) : ℝ := max 0 (1 - |x|)

/-- The autocorrelation of the tent function, in closed form. -/
def tentAutocorr (x : ℝ) : ℝ :=
  if |x| ≤ 1 then |x| ^ 3 / 2 - |x| ^ 2 + 2 / 3
  else if |x| ≤ 2 then -|x| ^ 3 / 6 + |x| ^ 2 - 2 * |x| + 4 / 3
  else 0

theorem tent_nonneg (x : ℝ) : 0 ≤ tent x := le_max_left _ _

theorem tent_continuous : Continuous tent := by
  unfold tent
  exact continuous_const.max (continuous_const.sub continuous_abs)

theorem tentAutocorr_even (x : ℝ) : tentAutocorr (-x) = tentAutocorr x := by
  simp [tentAutocorr, abs_neg]

theorem tentAutocorr_nonneg (x : ℝ) : 0 ≤ tentAutocorr x := by
  unfold tentAutocorr
  by_cases h1 : |x| ≤ 1
  · rw [if_pos h1]
    have hx0 : 0 ≤ |x| := abs_nonneg x
    have hx1 : |x| ≤ 1 := h1
    set u := |x| with hu
    have hv0 : 0 ≤ 1 - u := by linarith
    have hmain : 0 ≤ 1 + 3 * (1 - u) + 3 * (1 - u) ^ 2 * u := by
      nlinarith [sq_nonneg (1 - u), mul_nonneg (sq_nonneg (1 - u)) hv0]
    have hpoly : 6 * (u ^ 3 / 2 - u ^ 2 + 2 / 3) =
        1 + 3 * (1 - u) + 3 * (1 - u) ^ 2 * u := by ring
    nlinarith
  · rw [if_neg h1]
    by_cases h2 : |x| ≤ 2
    · rw [if_pos h2]
      have hx0 : 0 ≤ |x| := abs_nonneg x
      set u := |x| with hu
      have hu2 : u ≤ 2 := h2
      have hcube : (u - 2) ^ 3 ≤ 0 := by
        have hle : u - 2 ≤ 0 := by linarith
        have hnn : 0 ≤ -(u - 2) := by linarith
        nlinarith [mul_nonneg (mul_nonneg hnn hnn) hnn]
      have hpoly : -u ^ 3 / 6 + u ^ 2 - 2 * u + 4 / 3 = -(u - 2) ^ 3 / 6 := by ring
      nlinarith
    · rw [if_neg h2]

/-- Strict positivity of the autocorrelation inside its support.  This is the
finite cone-positivity fact for the fixed test function. -/
theorem tentAutocorr_pos {x : ℝ} (h : |x| < 2) : 0 < tentAutocorr x := by
  unfold tentAutocorr
  by_cases h1 : |x| ≤ 1
  · rw [if_pos h1]
    have hx0 : 0 ≤ |x| := abs_nonneg x
    set u := |x| with hu
    have hu1 : u ≤ 1 := h1
    have hv0 : 0 ≤ 1 - u := by linarith
    have hpoly : 6 * (u ^ 3 / 2 - u ^ 2 + 2 / 3) =
        1 + 3 * (1 - u) + 3 * (1 - u) ^ 2 * u := by ring
    have hpos : 0 < 1 + 3 * (1 - u) + 3 * (1 - u) ^ 2 * u := by
      nlinarith [sq_nonneg (1 - u), mul_nonneg (sq_nonneg (1 - u)) hv0,
        mul_nonneg hv0 (abs_nonneg x)]
    nlinarith
  · rw [if_neg h1]
    have h2 : |x| ≤ 2 := le_of_lt h
    rw [if_pos h2]
    set u := |x| with hu
    have hu1 : 1 < u := lt_of_not_ge h1
    have hu2 : u < 2 := h
    have hcube : (u - 2) ^ 3 < 0 := by
      have hlt : u - 2 < 0 := by linarith
      have hnn : 0 < -(u - 2) := by linarith
      nlinarith [mul_pos (mul_pos hnn hnn) hnn]
    have hpoly : -u ^ 3 / 6 + u ^ 2 - 2 * u + 4 / 3 = -(u - 2) ^ 3 / 6 := by ring
    nlinarith

theorem integral_sq_zero_one : (∫ x in (0:ℝ)..1, x ^ 2) = 1 / 3 := by
  rw [intervalIntegral.integral_deriv_eq_sub' (f := fun x : ℝ => x ^ 3 / 3)
    (f' := fun x : ℝ => x ^ 2)]
  · norm_num
  · funext x
    simp [deriv_pow]
  · intro x _
    fun_prop
  · fun_prop

theorem integral_tent_sq : ∫ x in (-1:ℝ)..1, tent x ^ 2 = 2 / 3 := by
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun x => tent x ^ 2) (a := -1) (b := 0) (c := 1)
    ((tent_continuous.pow 2).intervalIntegrable _ _) ((tent_continuous.pow 2).intervalIntegrable _ _)]
  have h1 : ∫ x in (-1:ℝ)..0, tent x ^ 2 = ∫ x in (-1:ℝ)..0, (1 + x) ^ 2 := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : x ≤ 0 := by simpa using hx.2
    have hx1 : -1 ≤ x := by simpa using hx.1
    have hnn : (0:ℝ) ≤ 1 + x := by linarith
    simp [tent, abs_of_nonpos hx', max_eq_right hnn]
  have h2 : ∫ x in (0:ℝ)..1, tent x ^ 2 = ∫ x in (0:ℝ)..1, (1 - x) ^ 2 := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : 0 ≤ x := by simpa using hx.1
    have hx2 : x ≤ 1 := by simpa using hx.2
    have hnn : (0:ℝ) ≤ 1 - x := by linarith
    simp [tent, abs_of_nonneg hx', max_eq_right hnn]
  rw [h1, h2]
  have e1 : ∫ x in (-1:ℝ)..0, (1 + x) ^ 2 = 1 / 3 := by
    rw [show (∫ x in (-1:ℝ)..0, (1 + x) ^ 2) = ∫ x in (-1:ℝ)..0, (x + 1) ^ 2 by
      apply intervalIntegral.integral_congr
      intro x _
      ring]
    rw [intervalIntegral.integral_comp_add_right (f := fun x : ℝ => x ^ 2) (a := -1) (b := 0) (d := 1)]
    norm_num
  have e2 : ∫ x in (0:ℝ)..1, (1 - x) ^ 2 = 1 / 3 := by
    rw [intervalIntegral.integral_comp_sub_left (f := fun x : ℝ => x ^ 2) (a := 0) (b := 1) (d := 1)]
    norm_num
  rw [e1, e2]
  norm_num


theorem integral_id_zero_one : (∫ x in (0:ℝ)..1, x) = 1 / 2 := by
  rw [intervalIntegral.integral_deriv_eq_sub' (f := fun x : ℝ => x ^ 2 / 2)
    (f' := fun x : ℝ => x)]
  · norm_num
  · funext x
    simp [deriv_pow]
  · intro x _; fun_prop
  · fun_prop

theorem integral_tent : ∫ x in (-1:ℝ)..1, tent x = 1 := by
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun x => tent x) (a := -1) (b := 0) (c := 1)
    (tent_continuous.intervalIntegrable _ _) (tent_continuous.intervalIntegrable _ _)]
  have h1 : ∫ x in (-1:ℝ)..0, tent x = ∫ x in (-1:ℝ)..0, (1 + x) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : x ≤ 0 := by simpa using hx.2
    have hx1 : -1 ≤ x := by simpa using hx.1
    have hnn : (0:ℝ) ≤ 1 + x := by linarith
    simp [tent, abs_of_nonpos hx', max_eq_right hnn]
  have h2 : ∫ x in (0:ℝ)..1, tent x = ∫ x in (0:ℝ)..1, (1 - x) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : 0 ≤ x := by simpa using hx.1
    have hx2 : x ≤ 1 := by simpa using hx.2
    have hnn : (0:ℝ) ≤ 1 - x := by linarith
    simp [tent, abs_of_nonneg hx', max_eq_right hnn]
  rw [h1, h2]
  have e1 : ∫ x in (-1:ℝ)..0, (1 + x) = 1 / 2 := by
    rw [show (∫ x in (-1:ℝ)..0, (1 + x)) = ∫ x in (-1:ℝ)..0, (x + 1) by
      apply intervalIntegral.integral_congr
      intro x _
      ring]
    rw [intervalIntegral.integral_comp_add_right (f := fun x : ℝ => x) (a := -1) (b := 0) (d := 1)]
    norm_num
  have e2 : ∫ x in (0:ℝ)..1, (1 - x) = 1 / 2 := by
    rw [intervalIntegral.integral_comp_sub_left (f := fun x : ℝ => x) (a := 0) (b := 1) (d := 1)]
    norm_num
  rw [e1, e2]
  norm_num



theorem hasDeriv_g01 (x : ℝ) :
    HasDerivAt (fun y : ℝ => y ^ 4 / 8 - y ^ 3 / 3 + 2 * y / 3)
      (x ^ 3 / 2 - x ^ 2 + 2 / 3) x := by
  have h1 : HasDerivAt (fun y : ℝ => y ^ 4 / 8) (x ^ 3 / 2) x := by
    have h := (hasDerivAt_pow 4 x).div_const 8
    convert h using 1 <;> ring
  have h2 : HasDerivAt (fun y : ℝ => y ^ 3 / 3) (x ^ 2) x := by
    have h := (hasDerivAt_pow 3 x).div_const 3
    convert h using 1 <;> ring
  have h3 : HasDerivAt (fun y : ℝ => 2 * y / 3) (2 / 3) x := by
    have h := ((hasDerivAt_id x).const_mul (2 : ℝ)).div_const 3
    convert h using 1
    · funext y; simp
    · norm_num
  exact (h1.sub h2).add h3

theorem integral_g01 : ∫ x in (0:ℝ)..1, tentAutocorr x = 11 / 24 := by
  have hg : ∫ x in (0:ℝ)..1, tentAutocorr x =
      ∫ x in (0:ℝ)..1, (x ^ 3 / 2 - x ^ 2 + 2 / 3) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx0 : 0 ≤ x := by simpa using hx.1
    have hx1 : x ≤ 1 := by simpa using hx.2
    unfold tentAutocorr
    rw [abs_of_nonneg hx0, if_pos hx1]
  rw [hg]
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := fun y : ℝ => y ^ 4 / 8 - y ^ 3 / 3 + 2 * y / 3)
    (f' := fun x : ℝ => x ^ 3 / 2 - x ^ 2 + 2 / 3)
    (fun x _ => hasDeriv_g01 x)
    ((by fun_prop : Continuous fun x : ℝ => x ^ 3 / 2 - x ^ 2 + 2 / 3).intervalIntegrable _ _)]
  norm_num




theorem tentAutocorr_one : tentAutocorr 1 = 1 / 6 := by
  norm_num [tentAutocorr]

theorem tentAutocorr_two : tentAutocorr 2 = 0 := by
  norm_num [tentAutocorr]


def F2 (y : ℝ) : ℝ := -(y ^ 4 / 24) + y ^ 3 / 3 - y ^ 2 + 4 * y / 3

theorem hasDeriv_g12 (x : ℝ) :
    HasDerivAt F2 (-x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3) x := by
  have h1 : HasDerivAt (fun y : ℝ => -(y ^ 4 / 24)) (-x ^ 3 / 6) x := by
    have h := ((hasDerivAt_pow 4 x).div_const 24).neg
    convert h using 1 <;> ring
  have h2 : HasDerivAt (fun y : ℝ => y ^ 3 / 3) (x ^ 2) x := by
    have h := (hasDerivAt_pow 3 x).div_const 3
    convert h using 1 <;> ring
  have h3 : HasDerivAt (fun y : ℝ => y ^ 2) (2 * x) x := by
    have h := hasDerivAt_pow 2 x
    convert h using 1 <;> ring
  have h4 : HasDerivAt (fun y : ℝ => 4 * y / 3) (4 / 3) x := by
    have h := ((hasDerivAt_id x).const_mul (4 : ℝ)).div_const 3
    convert h using 1
    · funext y; simp
    · norm_num
  have h := ((h1.add h2).sub h3).add h4
  convert h using 1
  · funext y
    unfold F2
    simp only [Pi.add_apply, Pi.sub_apply]

theorem integral_g12 : ∫ x in (1:ℝ)..2, tentAutocorr x = 1 / 24 := by
  have hg : ∫ x in (1:ℝ)..2, tentAutocorr x =
      ∫ x in (1:ℝ)..2, (-x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx0 : 0 ≤ x := le_trans (by norm_num : (0:ℝ) ≤ 1) (by simpa using hx.1)
    have hx2 : x ≤ 2 := by simpa using hx.2
    unfold tentAutocorr
    by_cases hx1 : x ≤ 1
    · have hx1' : 1 ≤ x := by simpa using hx.1
      have hxeq : x = 1 := le_antisymm hx1 hx1' 
      subst hxeq
      norm_num
    · rw [abs_of_nonneg hx0, if_neg hx1, if_pos hx2]
  rw [hg]
  have hcont : Continuous fun x : ℝ => -x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3 := by
    continuity
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := F2) (f' := fun x : ℝ => -x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3)
    (fun x _ => hasDeriv_g12 x) (hcont.intervalIntegrable _ _)]
  norm_num [F2]

theorem contOn_g01 : ContinuousOn tentAutocorr (Set.Icc (0:ℝ) 1) := by
  apply ContinuousOn.congr (by fun_prop : ContinuousOn (fun x : ℝ => x ^ 3 / 2 - x ^ 2 + 2 / 3) (Set.Icc (0:ℝ) 1))
  intro x hx
  unfold tentAutocorr
  rw [abs_of_nonneg hx.1, if_pos hx.2]

theorem contOn_g12 : ContinuousOn tentAutocorr (Set.Icc (1:ℝ) 2) := by
  apply ContinuousOn.congr (by fun_prop : ContinuousOn (fun x : ℝ => -x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3) (Set.Icc (1:ℝ) 2))
  intro x hx
  have hx0 : 0 ≤ x := le_trans (by norm_num : (0:ℝ) ≤ 1) hx.1
  have hx1 : 1 ≤ x := hx.1
  have hx2 : x ≤ 2 := hx.2
  unfold tentAutocorr
  by_cases hle : x ≤ 1
  · have hxeq : x = 1 := le_antisymm hle hx1
    subst hxeq
    norm_num
  · rw [abs_of_nonneg hx0, if_neg hle, if_pos hx2]

theorem integral_g02 : ∫ x in (0:ℝ)..2, tentAutocorr x = 1 / 2 := by
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := tentAutocorr) (a := 0) (b := 1) (c := 2)
    (contOn_g01.intervalIntegrable_of_Icc (by norm_num)) (contOn_g12.intervalIntegrable_of_Icc (by norm_num))]
  rw [integral_g01, integral_g12]
  norm_num


theorem integral_tentAutocorr : ∫ x in (-2:ℝ)..2, tentAutocorr x = 1 := by
  have h02 : IntervalIntegrable tentAutocorr volume 0 2 :=
    (contOn_g01.intervalIntegrable_of_Icc (by norm_num)).trans
      (contOn_g12.intervalIntegrable_of_Icc (by norm_num))
  have hneg : IntervalIntegrable tentAutocorr volume (-2) 0 := by
    have h := (IntervalIntegrable.iff_comp_neg (f := tentAutocorr) (a := 0) (b := 2) (by simp)).mp h02
    simpa [tentAutocorr_even] using h.symm
  have hneg_eq : ∫ x in (-2:ℝ)..0, tentAutocorr x = 1 / 2 := by
    calc
      ∫ x in (-2:ℝ)..0, tentAutocorr x = ∫ x in (-2:ℝ)..0, tentAutocorr (-x) := by
        apply intervalIntegral.integral_congr
        intro x _
        simp [tentAutocorr_even]
      _ = ∫ x in (0:ℝ)..2, tentAutocorr x := by
        rw [intervalIntegral.integral_comp_neg]
        norm_num
      _ = 1 / 2 := integral_g02
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := tentAutocorr) (a := -2) (b := 0) (c := 2) hneg h02]
  rw [hneg_eq, integral_g02]
  norm_num



theorem autocorr_at_zero :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - 0) = tentAutocorr 0 := by
  have h : (fun t : ℝ => tent t * tent (t - 0)) = fun t => tent t ^ 2 := by
    funext t; ring
  rw [h, integral_tent_sq]
  norm_num [tentAutocorr]


theorem tent_zero : tent 0 = 1 := by
  norm_num [tent]

theorem tent_one : tent 1 = 0 := by
  norm_num [tent]

theorem autocorr_at_one :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - 1) = tentAutocorr 1 := by
  have hcont : Continuous fun t : ℝ => tent t * tent (t - 1) :=
    tent_continuous.mul (tent_continuous.comp (continuous_id.sub continuous_const))
  have hleft : ∫ t in (-1:ℝ)..0, tent t * tent (t - 1) = 0 := by
    calc
      ∫ t in (-1:ℝ)..0, tent t * tent (t - 1) = ∫ t in (-1:ℝ)..0, (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht0 : t ≤ 0 := by simpa using ht.2
        have hz : tent (t - 1) = 0 := by
          simp only [tent]
          rw [abs_of_nonpos (by linarith : t - 1 ≤ 0)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  have hright : ∫ t in (0:ℝ)..1, tent t * tent (t - 1) = ∫ t in (0:ℝ)..1, t * (1 - t) := by
    apply intervalIntegral.integral_congr
    intro t ht
    have ht0 : 0 ≤ t := by simpa using ht.1
    have ht1 : t ≤ 1 := by simpa using ht.2
    simp only [tent]
    rw [abs_of_nonneg ht0, abs_of_nonpos (by linarith : t - 1 ≤ 0)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - t)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - (-(t - 1)))]
    ring
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun t : ℝ => tent t * tent (t - 1)) (a := -1) (b := 0) (c := 1)
    (hcont.intervalIntegrable _ _) (hcont.intervalIntegrable _ _)]
  rw [hleft, hright]
  have hcalc : ∫ t in (0:ℝ)..1, t * (1 - t) = 1 / 6 := by
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun x : ℝ => x ^ 2 / 2 - x ^ 3 / 3) (f' := fun x : ℝ => x * (1 - x))]
    · norm_num
    · intro x _
      have h1 : HasDerivAt (fun y : ℝ => y ^ 2 / 2) x x := by
        have h := (hasDerivAt_pow 2 x).div_const 2
        convert h using 1 <;> ring
      have h2 : HasDerivAt (fun y : ℝ => y ^ 3 / 3) (x ^ 2) x := by
        have h := (hasDerivAt_pow 3 x).div_const 3
        convert h using 1 <;> ring
      have h := h1.sub h2
      convert h using 1 <;> ring
    · exact (by continuity : Continuous fun x : ℝ => x * (1 - x)).intervalIntegrable _ _
  rw [hcalc, tentAutocorr_one]
  norm_num


theorem autocorr_at_three_halves :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - 3 / 2) = tentAutocorr (3 / 2) := by
  have hcont : Continuous fun t : ℝ => tent t * tent (t - 3 / 2) :=
    tent_continuous.mul (tent_continuous.comp (continuous_id.sub continuous_const))
  have hleft : ∫ t in (-1:ℝ)..(1 / 2), tent t * tent (t - 3 / 2) = 0 := by
    calc
      ∫ t in (-1:ℝ)..(1 / 2), tent t * tent (t - 3 / 2) =
          ∫ t in (-1:ℝ)..(1 / 2), (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht1 : t ≤ 1 / 2 := by
          have h := ht.2
          norm_num at h
          exact h
        have hz : tent (t - 3 / 2) = 0 := by
          simp only [tent]
          rw [abs_of_nonpos (by linarith : t - 3 / 2 ≤ 0)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  have hright : ∫ t in (1 / 2:ℝ)..1, tent t * tent (t - 3 / 2) =
      ∫ t in (1 / 2:ℝ)..1, (1 - t) * (t - 1 / 2) := by
    apply intervalIntegral.integral_congr
    intro t ht
    have ht0 : 1 / 2 ≤ t := by
      have h := ht.1
      norm_num at h
      exact h
    have ht1 : t ≤ 1 := by
      have h := ht.2
      norm_num at h
      exact h
    simp only [tent]
    rw [abs_of_nonneg (by linarith : 0 ≤ t),
      abs_of_nonpos (by linarith : t - 3 / 2 ≤ 0)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - t)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - (-(t - 3 / 2)))]
    ring
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun t : ℝ => tent t * tent (t - 3 / 2)) (a := -1) (b := 1 / 2) (c := 1)
    (hcont.intervalIntegrable _ _) (hcont.intervalIntegrable _ _)]
  rw [hleft, hright]
  have hcalc : ∫ t in (1 / 2:ℝ)..1, (1 - t) * (t - 1 / 2) = 1 / 48 := by
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun x : ℝ => -x ^ 3 / 3 + (3 / 4) * x ^ 2 - x / 2)
      (f' := fun x : ℝ => (1 - x) * (x - 1 / 2))]
    · norm_num
    · intro x _
      have h1 : HasDerivAt (fun y : ℝ => -y ^ 3 / 3) (-x ^ 2) x := by
        have h := ((hasDerivAt_pow 3 x).div_const 3).neg
        convert h using 1
        · funext y
          simp only [Pi.neg_apply]
          ring
        · ring
      have h2 : HasDerivAt (fun y : ℝ => (3 / 4) * y ^ 2) ((3 / 2) * x) x := by
        have h := (hasDerivAt_pow 2 x).const_mul (3 / 4 : ℝ)
        convert h using 1 <;> ring
      have h3 : HasDerivAt (fun y : ℝ => y / 2) (1 / 2) x := by
        have h := (hasDerivAt_id x).div_const 2
        convert h using 1
        · funext y; simp
      have h := (h1.add h2).sub h3
      convert h using 1 <;> ring
    · exact (by continuity : Continuous fun x : ℝ => (1 - x) * (x - 1 / 2)).intervalIntegrable _ _
  rw [hcalc]
  norm_num [tentAutocorr]



theorem autocorr_at_five_halves :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - 5 / 2) = tentAutocorr (5 / 2) := by
  have hzero : ∫ t in (-1:ℝ)..1, tent t * tent (t - 5 / 2) = 0 := by
    calc
      ∫ t in (-1:ℝ)..1, tent t * tent (t - 5 / 2) =
          ∫ t in (-1:ℝ)..1, (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht1 : t ≤ 1 := by simpa using ht.2
        have hz : tent (t - 5 / 2) = 0 := by
          simp only [tent]
          rw [abs_of_nonpos (by linarith : t - 5 / 2 ≤ 0)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  rw [hzero]
  norm_num [tentAutocorr]

theorem autocorr_at_two :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - 2) = tentAutocorr 2 := by
  have hzero : ∫ t in (-1:ℝ)..1, tent t * tent (t - 2) = 0 := by
    calc
      ∫ t in (-1:ℝ)..1, tent t * tent (t - 2) =
          ∫ t in (-1:ℝ)..1, (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht1 : t ≤ 1 := by simpa using ht.2
        have hz : tent (t - 2) = 0 := by
          simp only [tent]
          rw [abs_of_nonpos (by linarith : t - 2 ≤ 0)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  rw [hzero]
  norm_num [tentAutocorr]

theorem tentAutocorr_eq_zero_of_two_le {x : ℝ} (hx : 2 ≤ |x|) : tentAutocorr x = 0 := by
  unfold tentAutocorr
  have h1 : ¬ |x| ≤ 1 := by linarith
  rw [if_neg h1]
  by_cases h2 : |x| ≤ 2
  · rw [if_pos h2]
    have hx2 : |x| = 2 := le_antisymm h2 hx
    rw [hx2]
    norm_num
  · rw [if_neg h2]

theorem autocorr_eq_zero_of_two_le {x : ℝ} (hx : 2 ≤ |x|) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = 0 := by
  calc
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = ∫ t in (-1:ℝ)..1, (0:ℝ) := by
      apply intervalIntegral.integral_congr
      intro t ht
      have ht_lo : -1 ≤ t := by simpa using ht.1
      have ht_hi : t ≤ 1 := by simpa using ht.2
      have htabs : |t| ≤ 1 := abs_le.mpr ⟨ht_lo, ht_hi⟩
      have hz : tent (t - x) = 0 := by
        unfold tent
        have hrev : |x| - |t| ≤ |x - t| :=
          (le_abs_self (|x| - |t|)).trans (abs_abs_sub_abs_le_abs_sub x t)
        have hrev' : |x| - |t| ≤ |t - x| := by
          simpa [abs_sub_comm] using hrev
        have hone : (1:ℝ) ≤ |t - x| := by linarith
        rw [max_eq_left (by linarith)]
      simp [hz]
    _ = 0 := by simp


theorem autocorr_outside_support {x : ℝ} (hx : 2 ≤ |x|) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = tentAutocorr x := by
  rw [autocorr_eq_zero_of_two_le hx, tentAutocorr_eq_zero_of_two_le hx]

theorem autocorr_between_one_two {x : ℝ} (hx1 : 1 ≤ x) (hx2 : x ≤ 2) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = tentAutocorr x := by
  have hcont : Continuous fun t : ℝ => tent t * tent (t - x) :=
    tent_continuous.mul (tent_continuous.comp (continuous_id.sub continuous_const))
  have hx0 : 0 ≤ x := by linarith
  have hxm1_lo : -1 ≤ x - 1 := by linarith
  have hxm1_hi : x - 1 ≤ 1 := by linarith
  have hleft : ∫ t in (-1:ℝ)..(x - 1), tent t * tent (t - x) = 0 := by
    calc
      ∫ t in (-1:ℝ)..(x - 1), tent t * tent (t - x) =
          ∫ t in (-1:ℝ)..(x - 1), (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht_hi : t ≤ x - 1 := by
          have h := ht.2
          rwa [max_eq_right (by linarith : (-1:ℝ) ≤ x - 1)] at h
        have hz : tent (t - x) = 0 := by
          simp only [tent]
          rw [abs_of_nonpos (by linarith : t - x ≤ 0)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  have hright : ∫ t in (x - 1:ℝ)..1, tent t * tent (t - x) =
      ∫ t in (x - 1:ℝ)..1, (1 - t) * (1 - x + t) := by
    apply intervalIntegral.integral_congr
    intro t ht
    have ht_lo : x - 1 ≤ t := by
      have h := ht.1
      rwa [min_eq_left (by linarith : x - 1 ≤ (1:ℝ))] at h
    have ht_hi : t ≤ 1 := by
      have h := ht.2
      rwa [max_eq_right (by linarith : x - 1 ≤ (1:ℝ))] at h
    simp only [tent]
    rw [abs_of_nonneg (by linarith : 0 ≤ t),
      abs_of_nonpos (by linarith : t - x ≤ 0)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - t)]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 - (-(t - x)))]
    ring
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun t : ℝ => tent t * tent (t - x)) (a := -1) (b := x - 1) (c := 1)
    (hcont.intervalIntegrable _ _) (hcont.intervalIntegrable _ _)]
  rw [hleft, hright]
  have hcalc : ∫ t in (x - 1:ℝ)..1, (1 - t) * (1 - x + t) =
      tentAutocorr x := by
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun t : ℝ => (1 - x) * t + (x / 2) * t ^ 2 - t ^ 3 / 3)
      (f' := fun t : ℝ => (1 - t) * (1 - x + t))]
    · unfold tentAutocorr
      rw [abs_of_nonneg hx0]
      by_cases hxle : x ≤ 1
      · have hxeq : x = 1 := le_antisymm hxle hx1
        subst hxeq
        norm_num
      · rw [if_neg hxle, if_pos (by linarith : x ≤ 2)]
        ring
    · intro t _
      have h1 : HasDerivAt (fun y : ℝ => (1 - x) * y) (1 - x) t := by
        simpa using (hasDerivAt_id t).const_mul (1 - x)
      have h2 : HasDerivAt (fun y : ℝ => (x / 2) * y ^ 2) (x * t) t := by
        have h := (hasDerivAt_pow 2 t).const_mul (x / 2)
        convert h using 1 <;> ring
      have h3 : HasDerivAt (fun y : ℝ => y ^ 3 / 3) (t ^ 2) t := by
        have h := (hasDerivAt_pow 3 t).div_const 3
        convert h using 1 <;> ring
      have h := (h1.add h2).sub h3
      convert h using 1 <;> ring
    · exact (by continuity : Continuous fun t : ℝ => (1 - t) * (1 - x + t)).intervalIntegrable _ _
  rw [hcalc]
  simp


theorem autocorr_between_neg_two_neg_one {x : ℝ} (hx1 : -2 ≤ x) (hx2 : x ≤ -1) :
    ∫ t in (-1:ℝ)..1, tent t * tent (t - x) = tentAutocorr x := by
  have hcont : Continuous fun t : ℝ => tent t * tent (t - x) :=
    tent_continuous.mul (tent_continuous.comp (continuous_id.sub continuous_const))
  have hxle : x ≤ 0 := by linarith
  have hxp1_lo : -1 ≤ x + 1 := by linarith
  have hxp1_hi : x + 1 ≤ 1 := by linarith
  have hright : ∫ t in (x + 1:ℝ)..1, tent t * tent (t - x) = 0 := by
    calc
      ∫ t in (x + 1:ℝ)..1, tent t * tent (t - x) =
          ∫ t in (x + 1:ℝ)..1, (0:ℝ) := by
        apply intervalIntegral.integral_congr
        intro t ht
        have ht_lo : x + 1 ≤ t := by
          have h := ht.1
          rwa [min_eq_left (by linarith : x + 1 ≤ (1:ℝ))] at h
        have hz : tent (t - x) = 0 := by
          simp only [tent]
          rw [abs_of_nonneg (by linarith : 0 ≤ t - x)]
          rw [max_eq_left (by linarith)]
        simp [hz]
      _ = 0 := by simp
  have hleft : ∫ t in (-1:ℝ)..(x + 1), tent t * tent (t - x) =
      ∫ t in (-1:ℝ)..(x + 1), (1 + t) * (1 + x - t) := by
    apply intervalIntegral.integral_congr
    intro t ht
    have ht_lo : -1 ≤ t := by
      have h := ht.1
      rwa [min_eq_left (by linarith : (-1:ℝ) ≤ x + 1)] at h
    have ht_hi : t ≤ x + 1 := by
      have h := ht.2
      rwa [max_eq_right (by linarith : (-1:ℝ) ≤ x + 1)] at h
    simp only [tent]
    rw [abs_of_nonpos (by linarith : t ≤ 0),
      abs_of_nonneg (by linarith : 0 ≤ t - x)]
    rw [show (1:ℝ) - -t = 1 + t by ring]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 + t)]
    rw [show (1:ℝ) - (t - x) = 1 + x - t by ring]
    rw [max_eq_right (by linarith : (0:ℝ) ≤ 1 + x - t)]
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (f := fun t : ℝ => tent t * tent (t - x)) (a := -1) (b := x + 1) (c := 1)
    (hcont.intervalIntegrable _ _) (hcont.intervalIntegrable _ _)]
  rw [hleft, hright]
  have hcalc : ∫ t in (-1:ℝ)..(x + 1), (1 + t) * (1 + x - t) = tentAutocorr x := by
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun t : ℝ => (1 + x) * t + (x / 2) * t ^ 2 - t ^ 3 / 3)
      (f' := fun t : ℝ => (1 + t) * (1 + x - t))]
    · unfold tentAutocorr
      rw [abs_of_nonpos hxle]
      by_cases hxle1 : -x ≤ 1
      · have hxeq : x = -1 := by linarith
        subst hxeq
        norm_num
      · rw [if_neg hxle1, if_pos (by linarith : -x ≤ 2)]
        ring
    · intro t _
      have h1 : HasDerivAt (fun y : ℝ => (1 + x) * y) (1 + x) t := by
        simpa using (hasDerivAt_id t).const_mul (1 + x)
      have h2 : HasDerivAt (fun y : ℝ => (x / 2) * y ^ 2) (x * t) t := by
        have h := (hasDerivAt_pow 2 t).const_mul (x / 2)
        convert h using 1 <;> ring
      have h3 : HasDerivAt (fun y : ℝ => y ^ 3 / 3) (t ^ 2) t := by
        have h := (hasDerivAt_pow 3 t).div_const 3
        convert h using 1 <;> ring
      have h := (h1.add h2).sub h3
      convert h using 1 <;> ring
    · exact (by continuity : Continuous fun t : ℝ => (1 + t) * (1 + x - t)).intervalIntegrable _ _
  rw [hcalc]
  norm_num


end FiniteExplicitFormula
