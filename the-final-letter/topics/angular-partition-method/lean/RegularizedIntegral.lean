import CriticalStrip

/-!
# The subtracted-kernel integral

This file records the regularized kernel and its elementary bound near zero.
The Mellin convergence and the identification with `regularizedMellin` are the
next formalisation steps.
-/

open Real Set MeasureTheory Filter
open Complex

noncomputable section

namespace AngularPartition

/-- The regularized kernel: subtract `1/t` and add `1/2` below `1`. -/
def regularizedKernel (t : ℝ) : ℂ :=
  if t < 1 then (zetaKernel t - (1 : ℂ) / (t : ℂ) + 1 / 2 : ℂ) else zetaKernel t

/-- Near zero, the real regularized kernel is bounded by `3/2`. -/
theorem abs_regularized_real_le {t : ℝ} (ht0 : 0 < t) (ht1 : t < 1) :
    |1 / (rexp t - 1) - 1 / t| ≤ 1 := by
  have hexp_gt : 0 < rexp t - 1 := by
    linarith [Real.add_one_le_exp t]
  have hden : 0 < t * (rexp t - 1) := mul_pos ht0 hexp_gt
  have hnum : |t - (rexp t - 1)| ≤ t ^ 2 := by
    have h := Real.abs_exp_sub_one_sub_id_le (x := t) (by
      rw [abs_of_pos ht0] at *
      exact ht1.le)
    simpa [abs_sub_comm] using h
  have htle : t ^ 2 ≤ t * (rexp t - 1) := by
    have h := Real.add_one_le_exp t
    nlinarith
  have hfrac : |t - (rexp t - 1)| / (t * (rexp t - 1)) ≤ 1 := by
    rw [div_le_one hden]
    exact le_trans hnum htle
  rw [show 1 / (rexp t - 1) - 1 / t =
      (t - (rexp t - 1)) / (t * (rexp t - 1)) by
    field_simp [ne_of_gt ht0, ne_of_gt hexp_gt]]
  rw [abs_div, abs_of_pos hden]
  exact hfrac

/-- The complex regularized kernel is bounded by `3/2` near zero. -/
theorem norm_regularizedKernel_le {t : ℝ} (ht0 : 0 < t) (ht1 : t < 1) :
    ‖regularizedKernel t‖ ≤ (3 / 2 : ℝ) := by
  have h := abs_regularized_real_le ht0 ht1
  have hsub : zetaKernel t - (1 : ℂ) / (t : ℂ) =
      ((1 / (rexp t - 1) - 1 / t : ℝ) : ℂ) := by
    rw [zetaKernel]
    norm_num [Complex.ofReal_sub, Complex.ofReal_div]
  rw [regularizedKernel, if_pos ht1, hsub]
  calc
    ‖((1 / (rexp t - 1) - 1 / t : ℝ) : ℂ) + (1 / 2 : ℂ)‖
        ≤ ‖((1 / (rexp t - 1) - 1 / t : ℝ) : ℂ)‖ + ‖(1 / 2 : ℂ)‖ :=
          norm_add_le _ _
    _ = |1 / (rexp t - 1) - 1 / t| + 1 / 2 := by
          rw [Complex.norm_real, Real.norm_eq_abs]
          norm_num
    _ ≤ 3 / 2 := by linarith

end AngularPartition

namespace AngularPartition

/-- At infinity the zeta kernel is bounded by `2/t`. -/
theorem norm_zetaKernel_le_two_div {t : ℝ} (ht : 1 ≤ t) :
    ‖zetaKernel t‖ ≤ 2 / t := by
  have ht0 : 0 < t := lt_of_lt_of_le zero_lt_one ht
  have hexp_gt : 0 < rexp t - 1 := by
    linarith [Real.add_one_le_exp t]
  have hexp2 : 2 ≤ rexp t := by
    have h1 : rexp 1 ≤ rexp t := Real.exp_le_exp.mpr ht
    linarith [Real.exp_one_gt_two]
  have hhalf : rexp t / 2 ≤ rexp t - 1 := by linarith
  have hnorm : 1 / (rexp t - 1) ≤ 2 / t := by
    have h1 : 1 / (rexp t - 1) ≤ 1 / (rexp t / 2) :=
      one_div_le_one_div_of_le (by positivity) hhalf
    have h2 : 1 / (rexp t / 2) = 2 / rexp t := by field_simp
    have h3 : 2 / rexp t ≤ 2 / t := by
      apply div_le_div_of_nonneg_left (by norm_num) ht0
      have := Real.add_one_le_exp t
      linarith
    linarith
  rw [zetaKernel, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by positivity : 0 < 1 / (rexp t - 1))]
  exact hnorm

end AngularPartition

namespace AngularPartition

/-- The piecewise regularized kernel is measurable. -/
theorem measurable_regularizedKernel : Measurable regularizedKernel := by
  unfold regularizedKernel
  apply Measurable.ite measurableSet_Iio
  · have hz : Measurable zetaKernel := by
      unfold zetaKernel
      measurability
    have ht : Measurable fun t : ℝ => ((t : ℂ))⁻¹ := measurable_ofReal.inv
    convert (hz.sub ht).add (measurable_const : Measurable fun _ : ℝ => (1 / 2 : ℂ)) using 1
    ext x
    simp [Pi.sub_apply, Pi.add_apply, one_div]
  · unfold zetaKernel
    measurability

/-- On `(0,1)`, the Mellin integrand of the regularized kernel is dominated
by `(3/2) t^(re s - 1)`, hence integrable for `0 < re s`. -/
theorem integrableOn_regularizedKernel_Ioo {s : ℂ} (hs0 : 0 < s.re) :
    IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t) (Ioo 0 1) := by
  have hbase : IntegrableOn (fun t : ℝ => (3 / 2 : ℝ) * t ^ (s.re - 1)) (Ioo 0 1) := by
    have h := (intervalIntegral.integrableOn_Ioo_rpow_iff (show (0 : ℝ) < 1 by norm_num)).2
      (by linarith : -1 < s.re - 1)
    simpa [IntegrableOn, mul_comm] using h.const_mul (3 / 2 : ℝ)
  have hcpow : ContinuousOn (fun t : ℝ => (t : ℂ) ^ (s - 1)) (Ioo 0 1) :=
    (continuous_ofReal.continuousOn).cpow_const
      (fun a ha => Complex.ofReal_mem_slitPlane.2 (by linarith [ha.1]))
  have hmeas1 : AEStronglyMeasurable (fun t : ℝ => (t : ℂ) ^ (s - 1))
      (volume.restrict (Ioo 0 1)) := hcpow.aestronglyMeasurable measurableSet_Ioo
  have hmeas2 : AEStronglyMeasurable regularizedKernel (volume.restrict (Ioo 0 1)) :=
    measurable_regularizedKernel.aestronglyMeasurable
  have hmeas : AEStronglyMeasurable
      (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
      (volume.restrict (Ioo 0 1)) := hmeas1.smul hmeas2
  have hle : ∀ᵐ t : ℝ ∂(volume.restrict (Ioo 0 1)),
      ‖(t : ℂ) ^ (s - 1) • regularizedKernel t‖ ≤
        ‖(3 / 2 : ℝ) * t ^ (s.re - 1)‖ := by
    filter_upwards [ae_restrict_mem measurableSet_Ioo] with t ht
    have ht0 : 0 < t := ht.1
    have ht1 : t < 1 := ht.2
    have hnorm : ‖regularizedKernel t‖ ≤ (3 / 2 : ℝ) := norm_regularizedKernel_le ht0 ht1
    have hpow : 0 ≤ t ^ (s.re - 1) := by positivity
    calc
      ‖(t : ℂ) ^ (s - 1) • regularizedKernel t‖
          = t ^ (s.re - 1) * ‖regularizedKernel t‖ := by
            rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
            simp only [sub_re, one_re]
      _ ≤ t ^ (s.re - 1) * (3 / 2) := mul_le_mul_of_nonneg_left hnorm hpow
      _ = (3 / 2) * t ^ (s.re - 1) := by ring
      _ = ‖(3 / 2 : ℝ) * t ^ (s.re - 1)‖ := by
            rw [Real.norm_eq_abs, abs_of_pos (by positivity)]
  change Integrable (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
    (volume.restrict (Ioo 0 1))
  exact Integrable.mono hbase hmeas hle


end AngularPartition

namespace AngularPartition

/-- On `(1,∞)`, the Mellin integrand is dominated by `2 t^(re s - 2)`, hence
integrable for `re s < 1`. -/
theorem integrableOn_regularizedKernel_Ioi {s : ℂ} (hs1 : s.re < 1) :
    IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t) (Ioi 1) := by
  have hbase : IntegrableOn (fun t : ℝ => (2 : ℝ) * t ^ (s.re - 2)) (Ioi 1) := by
    have h := integrableOn_Ioi_rpow_of_lt (show s.re - 2 < -1 by linarith)
      (show (0 : ℝ) < 1 by norm_num)
    simpa [IntegrableOn, mul_comm] using h.const_mul (2 : ℝ)
  have hcpow : ContinuousOn (fun t : ℝ => (t : ℂ) ^ (s - 1)) (Ioi 1) :=
    (continuous_ofReal.continuousOn).cpow_const
      (fun a ha => Complex.ofReal_mem_slitPlane.2 (by linarith [show (1 : ℝ) < a from ha]))
  have hmeas1 : AEStronglyMeasurable (fun t : ℝ => (t : ℂ) ^ (s - 1))
      (volume.restrict (Ioi 1)) := hcpow.aestronglyMeasurable measurableSet_Ioi
  have hmeas2 : AEStronglyMeasurable regularizedKernel (volume.restrict (Ioi 1)) :=
    measurable_regularizedKernel.aestronglyMeasurable
  have hmeas : AEStronglyMeasurable
      (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
      (volume.restrict (Ioi 1)) := hmeas1.smul hmeas2
  have hle : ∀ᵐ t : ℝ ∂(volume.restrict (Ioi 1)),
      ‖(t : ℂ) ^ (s - 1) • regularizedKernel t‖ ≤
        ‖(2 : ℝ) * t ^ (s.re - 2)‖ := by
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    have ht0 : 0 < t := lt_trans zero_lt_one ht
    have hker : regularizedKernel t = zetaKernel t := by
      rw [regularizedKernel, if_neg (not_lt.mpr ht.le)]
    have hnorm : ‖regularizedKernel t‖ ≤ 2 / t := by
      rw [hker]
      exact norm_zetaKernel_le_two_div ht.le
    have hpow : 0 ≤ t ^ (s.re - 1) := by positivity
    have hEq : t ^ (s.re - 1) * (2 / t) = 2 * t ^ (s.re - 2) := by
      calc
        t ^ (s.re - 1) * (2 / t) = 2 * (t ^ (s.re - 1) * t⁻¹) := by
          field_simp [ne_of_gt ht0]
        _ = 2 * t ^ (s.re - 2) := by
          rw [show s.re - 2 = (s.re - 1) + (-1) by ring, Real.rpow_add ht0, Real.rpow_neg_one]
    calc
      ‖(t : ℂ) ^ (s - 1) • regularizedKernel t‖
          = t ^ (s.re - 1) * ‖regularizedKernel t‖ := by
            rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
            simp only [sub_re, one_re]
      _ ≤ t ^ (s.re - 1) * (2 / t) := mul_le_mul_of_nonneg_left hnorm hpow
      _ = 2 * t ^ (s.re - 2) := hEq
      _ = ‖(2 : ℝ) * t ^ (s.re - 2)‖ := by
            rw [Real.norm_eq_abs, abs_of_pos (by positivity)]
  change Integrable (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
    (volume.restrict (Ioi 1))
  exact Integrable.mono hbase hmeas hle

end AngularPartition

namespace AngularPartition

/-- **Convergence of the subtracted-kernel Mellin integral.**
For `0 < re s < 1`, the regularized kernel is Mellin-convergent. -/
theorem mellinConvergent_regularizedKernel {s : ℂ}
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent regularizedKernel s := by
  rw [MellinConvergent]
  have hlow := integrableOn_regularizedKernel_Ioo hs0
  have hhigh := integrableOn_regularizedKernel_Ioi hs1
  have hsingle : IntegrableOn
      (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t) ({1} : Set ℝ) :=
    integrableOn_singleton (f := fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
      (x := 1) (by simp) (by simp)
  have hunion : IntegrableOn
      (fun t : ℝ => (t : ℂ) ^ (s - 1) • regularizedKernel t)
      (Ioo 0 1 ∪ ({1} : Set ℝ) ∪ Ioi 1) :=
    (hlow.union hsingle).union hhigh
  have hset : Ioo (0 : ℝ) 1 ∪ ({1} : Set ℝ) ∪ Ioi 1 = Ioi 0 := by
    ext t
    constructor
    · intro ht
      rcases ht with (ht | ht) | ht
      · exact ht.1
      · rw [mem_singleton_iff] at ht
        rw [ht]
        norm_num
      · exact lt_trans zero_lt_one (show (1 : ℝ) < t from ht)
    · intro ht
      rcases lt_trichotomy t 1 with h | h | h
      · exact Or.inl (Or.inl ⟨ht, h⟩)
      · exact Or.inl (Or.inr h)
      · exact Or.inr h
  simpa [hset] using hunion

end AngularPartition

namespace AngularPartition

/-- The regularized kernel is locally integrable on `(0,∞)`. -/
theorem locallyIntegrableOn_regularizedKernel :
    LocallyIntegrableOn regularizedKernel (Ioi 0) := by
  intro x hx
  have hx0 : 0 < x := hx
  let a : ℝ := x / 2
  let b : ℝ := 2 * x
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : a ≤ b := by dsimp [a, b]; linarith
  have hbound : ∀ t ∈ Icc a b, ‖regularizedKernel t‖ ≤ max (3 / 2 : ℝ) (2 / a) := by
    intro t ht
    by_cases ht1 : t < 1
    · exact le_trans (norm_regularizedKernel_le (lt_of_lt_of_le ha ht.1) ht1)
        (le_max_left _ _)
    · rw [regularizedKernel, if_neg ht1]
      have ht0 : 0 < t := lt_of_lt_of_le ha ht.1
      have hle : ‖zetaKernel t‖ ≤ 2 / t :=
        norm_zetaKernel_le_two_div (le_of_not_gt ht1)
      have h2 : 2 / t ≤ 2 / a :=
        div_le_div_of_nonneg_left (by norm_num) ha ht.1
      exact le_trans (le_trans hle h2) (le_max_right _ _)
  have hint : IntegrableOn regularizedKernel (Icc a b) := by
    refine IntegrableOn.of_bound measure_Icc_lt_top ?_ (max (3 / 2 : ℝ) (2 / a)) ?_
    · exact measurable_regularizedKernel.aestronglyMeasurable
    · filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
      exact hbound t ht
  refine ⟨Icc a b, ?_, hint⟩
  apply mem_nhdsWithin_of_mem_nhds
  have hIoo : Ioo a b ∈ nhds x := Ioo_mem_nhds (by show x / 2 < x; linarith) (by show x < 2 * x; linarith)
  exact Filter.mem_of_superset hIoo Ioo_subset_Icc_self

end AngularPartition

namespace AngularPartition

/-- At infinity the zeta kernel is exponentially small: `≤ 2 e^{-t}`. -/
theorem norm_zetaKernel_le_two_exp_neg {t : ℝ} (ht : 1 ≤ t) :
    ‖zetaKernel t‖ ≤ 2 * Real.exp (-t) := by
  have ht0 : 0 < t := lt_of_lt_of_le zero_lt_one ht
  have hexp_gt : 0 < rexp t - 1 := by
    linarith [Real.add_one_le_exp t]
  have hexp2 : 2 ≤ rexp t := by
    have h1 : rexp 1 ≤ rexp t := Real.exp_le_exp.mpr ht
    linarith [Real.exp_one_gt_two]
  have hhalf : rexp t / 2 ≤ rexp t - 1 := by linarith
  have hnorm : 1 / (rexp t - 1) ≤ 2 * Real.exp (-t) := by
    calc
      1 / (rexp t - 1) ≤ 1 / (rexp t / 2) :=
        one_div_le_one_div_of_le (by positivity) hhalf
      _ = 2 / rexp t := by field_simp
      _ = 2 * Real.exp (-t) := by
        rw [Real.exp_neg]
        field_simp
  rw [zetaKernel, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (by positivity : 0 < 1 / (rexp t - 1))]
  exact hnorm

/-- `regularizedKernel` is `O(e^{-t})` at infinity. -/
theorem regularizedKernel_isBigO_exp :
    regularizedKernel =O[atTop] (fun t : ℝ => Real.exp (-1 * t)) := by
  refine Asymptotics.IsBigO.of_bound (2 : ℝ) ?_
  filter_upwards [Filter.eventually_ge_atTop (1 : ℝ)] with t ht
  have hker : regularizedKernel t = zetaKernel t := by
    rw [regularizedKernel, if_neg (not_lt.mpr ht)]
  rw [hker]
  have hle := norm_zetaKernel_le_two_exp_neg ht
  simpa [Real.exp_neg, mul_comm, mul_left_comm, mul_assoc] using hle

/-- `regularizedKernel` is `O(1)` near zero. -/
theorem regularizedKernel_isBigO_one :
    regularizedKernel =O[nhdsWithin (0 : ℝ) (Ioi 0)] (fun t : ℝ => t ^ (-(0 : ℝ))) := by
  refine Asymptotics.IsBigO.of_bound (3 / 2 : ℝ) ?_
  rw [eventually_nhdsWithin_iff]
  filter_upwards [Iio_mem_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht hpos
  have hnorm : ‖regularizedKernel t‖ ≤ (3 / 2 : ℝ) :=
    norm_regularizedKernel_le hpos ht
  simpa using hnorm

/-- The Mellin transform of the regularized kernel is holomorphic in the
right half-plane `0 < re s`. -/
theorem differentiableAt_mellin_regularizedKernel {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ (mellin regularizedKernel) s := by
  refine mellin_differentiableAt_of_isBigO_rpow_exp (a := 1) (b := 0) one_pos
    locallyIntegrableOn_regularizedKernel regularizedKernel_isBigO_exp
    regularizedKernel_isBigO_one ?_
  simpa using hs

end AngularPartition

namespace AngularPartition

/-- The regularized Mellin integral converges on the whole right half-plane. -/
theorem mellinConvergent_regularizedKernel_of_pos {s : ℂ} (hs : 0 < s.re) :
    MellinConvergent regularizedKernel s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := 0) one_pos
    locallyIntegrableOn_regularizedKernel regularizedKernel_isBigO_exp
    regularizedKernel_isBigO_one ?_
  simpa using hs

end AngularPartition

namespace AngularPartition

/-- The cutoff kernel `-1/t + 1/2` below `1` and `0` above. -/
def cutoff (t : ℝ) : ℂ := if t < 1 then (-(1 : ℂ) / (t : ℂ) + 1 / 2) else 0

/-- Pointwise decomposition of the regularized kernel. -/
theorem regularizedKernel_eq_zetaKernel_add_cutoff (t : ℝ) :
    regularizedKernel t = zetaKernel t + cutoff t := by
  by_cases h : t < 1
  · simp [regularizedKernel, cutoff, h]
    ring
  · simp [regularizedKernel, cutoff, h]

/-- Linearity of the Mellin transform for two convergent pieces. -/
theorem mellin_add {f g : ℝ → ℂ} {s : ℂ}
    (hf : MellinConvergent f s) (hg : MellinConvergent g s) :
    mellin (f + g) s = mellin f s + mellin g s := by
  rw [mellin, mellin, mellin]
  simp only [Pi.add_apply, smul_add]
  rw [integral_add]
  · exact hf
  · exact hg

end AngularPartition

namespace AngularPartition

lemma measurable_zetaKernel : Measurable zetaKernel := by
  unfold zetaKernel
  measurability

/-- The zeta kernel is locally integrable on `(0,∞)`. -/
theorem locallyIntegrableOn_zetaKernel : LocallyIntegrableOn zetaKernel (Ioi 0) := by
  intro x hx
  have hx0 : 0 < x := hx
  let a : ℝ := x / 2
  let b : ℝ := 2 * x
  have ha : 0 < a := by dsimp [a]; positivity
  have hbound : ∀ t ∈ Icc a b, ‖zetaKernel t‖ ≤ 2 / a := by
    intro t ht
    have ht0 : 0 < t := lt_of_lt_of_le ha ht.1
    have hden : 0 < 1 / (rexp t - 1) :=
      div_pos one_pos (by linarith [Real.add_one_le_exp t])
    by_cases ht1 : t < 1
    · have hle : ‖zetaKernel t‖ ≤ 1 / t := by
        rw [zetaKernel, Complex.norm_real, Real.norm_eq_abs,
          abs_of_pos (by positivity : 0 < 1 / (rexp t - 1))]
        apply one_div_le_one_div_of_le ht0
        linarith [Real.add_one_le_exp t]
      have h1t : 1 / t ≤ 1 / a := one_div_le_one_div_of_le ha ht.1
      have h1a : 1 / a ≤ 2 / a := by
        rw [div_le_div_iff_of_pos_right ha]
        norm_num
      linarith
    · have hle : ‖zetaKernel t‖ ≤ 2 / t :=
        norm_zetaKernel_le_two_div (le_of_not_gt ht1)
      have h2 : 2 / t ≤ 2 / a := div_le_div_of_nonneg_left (by norm_num) ha ht.1
      linarith
  have hint : IntegrableOn zetaKernel (Icc a b) := by
    refine IntegrableOn.of_bound measure_Icc_lt_top ?_ (2 / a) ?_
    · exact measurable_zetaKernel.aestronglyMeasurable
    · filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
      exact hbound t ht
  refine ⟨Icc a b, ?_, hint⟩
  apply mem_nhdsWithin_of_mem_nhds
  have hIoo : Ioo a b ∈ nhds x := Ioo_mem_nhds (by show x / 2 < x; linarith) (by show x < 2 * x; linarith)
  exact Filter.mem_of_superset hIoo Ioo_subset_Icc_self

/-- The zeta kernel is Mellin-convergent for `1 < re s`. -/
theorem mellinConvergent_zetaKernel {s : ℂ} (hs : 1 < s.re) :
    MellinConvergent zetaKernel s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := 1) one_pos
    locallyIntegrableOn_zetaKernel ?_ ?_ ?_
  · -- top: zetaKernel = O(exp (-t))
    refine Asymptotics.IsBigO.of_bound (2 : ℝ) ?_
    filter_upwards [Filter.eventually_ge_atTop (1 : ℝ)] with t ht
    have hle := norm_zetaKernel_le_two_exp_neg ht
    simpa [Real.exp_neg, mul_comm, mul_left_comm, mul_assoc] using hle
  · -- bottom: zetaKernel = O(t⁻¹)
    refine Asymptotics.IsBigO.of_bound (1 : ℝ) ?_
    rw [eventually_nhdsWithin_iff]
    filter_upwards [Iio_mem_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht hpos
    have hpos' : 0 < t := hpos
    have hden : 0 < 1 / (rexp t - 1) :=
      div_pos one_pos (by linarith [Real.add_one_le_exp t])
    have hle : ‖zetaKernel t‖ ≤ 1 / t := by
      rw [zetaKernel, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by positivity : 0 < 1 / (rexp t - 1))]
      apply one_div_le_one_div_of_le hpos'
      linarith [Real.add_one_le_exp t]
    simpa [Real.rpow_neg_one, Real.norm_eq_abs, abs_of_pos hpos'] using hle
  · linarith

end AngularPartition

namespace AngularPartition

lemma measurable_cutoff : Measurable cutoff := by
  unfold cutoff
  apply Measurable.ite measurableSet_Iio
  · have hdiv : Measurable fun t : ℝ => (-(1 : ℂ)) / (t : ℂ) :=
      measurable_const.div measurable_ofReal
    convert hdiv.add (measurable_const : Measurable fun _ : ℝ => (1 / 2 : ℂ)) using 1
  · exact measurable_const

/-- The cutoff kernel is locally integrable. -/
theorem locallyIntegrableOn_cutoff : LocallyIntegrableOn cutoff (Ioi 0) := by
  intro x hx
  have hx0 : 0 < x := hx
  let a : ℝ := x / 2
  let b : ℝ := 2 * x
  have ha : 0 < a := by dsimp [a]; positivity
  have hbound : ∀ t ∈ Icc a b, ‖cutoff t‖ ≤ 1 / a + 1 / 2 := by
    intro t ht
    by_cases ht1 : t < 1
    · have ht0 : 0 < t := lt_of_lt_of_le ha ht.1
      have hc : cutoff t = (-(1 : ℂ) / (t : ℂ) + 1 / 2) := by simp [cutoff, ht1]
      rw [hc]
      calc
        ‖-(1 : ℂ) / (t : ℂ) + 1 / 2‖ ≤ ‖-(1 : ℂ) / (t : ℂ)‖ + ‖(1 / 2 : ℂ)‖ := norm_add_le _ _
        _ = 1 / t + 1 / 2 := by
          rw [norm_div, norm_neg, norm_one, Complex.norm_real, Real.norm_eq_abs,
            abs_of_pos ht0]
          norm_num
        _ ≤ 1 / a + 1 / 2 := by
          have : 1 / t ≤ 1 / a := one_div_le_one_div_of_le ha ht.1
          linarith
    · have hc : cutoff t = 0 := by simp [cutoff, ht1]
      rw [hc, norm_zero]
      positivity
  have hint : IntegrableOn cutoff (Icc a b) := by
    refine IntegrableOn.of_bound measure_Icc_lt_top ?_ (1 / a + 1 / 2) ?_
    · exact measurable_cutoff.aestronglyMeasurable
    · filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
      exact hbound t ht
  refine ⟨Icc a b, ?_, hint⟩
  apply mem_nhdsWithin_of_mem_nhds
  have hIoo : Ioo a b ∈ nhds x := Ioo_mem_nhds (by show x / 2 < x; linarith) (by show x < 2 * x; linarith)
  exact Filter.mem_of_superset hIoo Ioo_subset_Icc_self

/-- The cutoff is Mellin-convergent for `1 < re s`. -/
theorem mellinConvergent_cutoff {s : ℂ} (hs : 1 < s.re) :
    MellinConvergent cutoff s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := 1) one_pos
    locallyIntegrableOn_cutoff ?_ ?_ ?_
  · -- top: cutoff is eventually zero
    refine Asymptotics.IsBigO.of_bound (0 : ℝ) ?_
    filter_upwards [Filter.eventually_ge_atTop (1 : ℝ)] with t ht
    have hc : cutoff t = 0 := by simp [cutoff, not_lt.mpr ht]
    rw [hc, norm_zero]
    simp
  · -- bottom: cutoff = O(t⁻¹)
    refine Asymptotics.IsBigO.of_bound (3 / 2 : ℝ) ?_
    rw [eventually_nhdsWithin_iff]
    filter_upwards [Iio_mem_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht hpos
    have ht0 : 0 < t := hpos
    have hc : cutoff t = (-(1 : ℂ) / (t : ℂ) + 1 / 2) := by
      rw [cutoff, if_pos (show t < 1 from ht)]
    rw [hc]
    have hnorm : ‖-(1 : ℂ) / (t : ℂ) + 1 / 2‖ ≤ 1 / t + 1 / 2 := by
      calc
        ‖-(1 : ℂ) / (t : ℂ) + 1 / 2‖ ≤ ‖-(1 : ℂ) / (t : ℂ)‖ + ‖(1 / 2 : ℂ)‖ := norm_add_le _ _
        _ = 1 / t + 1 / 2 := by
          rw [norm_div, norm_neg, norm_one, Complex.norm_real, Real.norm_eq_abs,
            abs_of_pos ht0]
          norm_num
    have hle : 1 / t + 1 / 2 ≤ (3 / 2) * ‖(t : ℝ) ^ (-1 : ℝ)‖ := by
      rw [Real.norm_eq_abs, abs_of_pos (by positivity : 0 < t ^ (-1 : ℝ)), Real.rpow_neg_one]
      have htlt : t < 1 := ht
      have htle : 1 ≤ 1 / t := by
        rw [le_div_iff₀ ht0]
        linarith
      have h1 : 1 / t + 1 / 2 ≤ (3 / 2) * (1 / t) := by nlinarith
      simpa [one_div] using h1
    linarith
  · linarith

end AngularPartition

namespace AngularPartition

/-- The cutoff Mellin integral reduces to the interval `(0,1)`. -/
theorem mellin_cutoff_eq_setIntegral {s : ℂ} (hs : 1 < s.re) :
    mellin cutoff s = ∫ t in Ioc (0 : ℝ) 1, (t : ℂ) ^ (s - 1) • cutoff t := by
  have hconv := mellinConvergent_cutoff hs
  have hIoc : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) • cutoff t) (Ioc 0 1) :=
    hconv.mono_set Ioc_subset_Ioi_self
  have hIoi : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) • cutoff t) (Ioi 1) :=
    hconv.mono_set (fun t ht => by
      show t ∈ Ioi (0 : ℝ)
      exact lt_trans zero_lt_one (show (1 : ℝ) < t from ht))
  rw [mellin]
  rw [← Ioc_union_Ioi_eq_Ioi (show (0 : ℝ) ≤ 1 by norm_num)]
  rw [setIntegral_union (Set.Ioc_disjoint_Ioi_same) measurableSet_Ioi hIoc hIoi]
  have hzero : (∫ t in Ioi (1 : ℝ), (t : ℂ) ^ (s - 1) • cutoff t) = 0 := by
    apply setIntegral_eq_zero_of_forall_eq_zero
    intro t ht
    have ht1 : ¬ t < 1 := not_lt.mpr (le_of_lt ht)
    simp [cutoff, ht1]
  rw [hzero, add_zero]

end AngularPartition

namespace AngularPartition

/-- Integral of `t^r` over `[0,1]` for `re r > -1`. -/
theorem integral_cpow_zero_one {r : ℂ} (hr : -1 < r.re) :
    (∫ t in (0 : ℝ)..1, (t : ℂ) ^ r) = 1 / (r + 1) := by
  rw [integral_cpow (a := (0 : ℝ)) (b := 1) (Or.inl hr)]
  have hrne : r + 1 ≠ 0 := by
    intro h
    have hre : (r + 1).re = 0 := by rw [h]; simp
    simp [Complex.add_re, Complex.one_re] at hre
    linarith
  simp [Complex.zero_cpow hrne]

end AngularPartition

namespace AngularPartition

/-- The cutoff Mellin integral equals `-1/(s-1)+1/(2s)`. -/
theorem mellin_cutoff_eq {s : ℂ} (hs : 1 < s.re) :
    mellin cutoff s = -1 / (s - 1) + 1 / (2 * s) := by
  rw [mellin_cutoff_eq_setIntegral hs]
  rw [← intervalIntegral.integral_of_le (show (0 : ℝ) ≤ 1 by norm_num)]
  have hcongr : (∫ t in (0 : ℝ)..1, (t : ℂ) ^ (s - 1) • cutoff t)
      = ∫ t in (0 : ℝ)..1,
          (-((t : ℂ) ^ (s - 2)) + (1 / 2 : ℂ) * (t : ℂ) ^ (s - 1)) := by
    apply intervalIntegral.integral_congr_Ioo_of_le (show (0 : ℝ) ≤ 1 by norm_num)
    intro t ht
    have ht0 : 0 < t := ht.1
    have hne : (t : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt ht0
    have hc : cutoff t = (-(1 : ℂ) / (t : ℂ) + 1 / 2) := by
      rw [cutoff, if_pos ht.2]
    change (t : ℂ) ^ (s - 1) • cutoff t =
      -((t : ℂ) ^ (s - 2)) + (1 / 2 : ℂ) * (t : ℂ) ^ (s - 1)
    rw [hc]
    have hpow : (t : ℂ) ^ (s - 2) = (t : ℂ) ^ (s - 1) * (t : ℂ)⁻¹ := by
      rw [show s - 2 = (s - 1) + (-1) by ring, Complex.cpow_add _ _ hne,
        Complex.cpow_neg, Complex.cpow_one]
    rw [hpow]
    simp only [smul_eq_mul]
    ring
  rw [hcongr]
  have h1 : (∫ t in (0 : ℝ)..1, (t : ℂ) ^ (s - 2)) = 1 / (s - 1) := by
    have := integral_cpow_zero_one (r := s - 2) (by
      rw [Complex.sub_re]
      norm_num
      linarith)
    convert this using 2
    ring
  have h2 : (∫ t in (0 : ℝ)..1, (t : ℂ) ^ (s - 1)) = 1 / s := by
    have := integral_cpow_zero_one (r := s - 1) (by
      rw [Complex.sub_re]
      norm_num
      linarith)
    convert this using 2
    ring
  have hf : IntervalIntegrable (fun t : ℝ => (t : ℂ) ^ (s - 2)) volume 0 1 :=
    intervalIntegral.intervalIntegrable_cpow' (by rw [Complex.sub_re]; norm_num; linarith)
  have hg : IntervalIntegrable (fun t : ℝ => (t : ℂ) ^ (s - 1)) volume 0 1 :=
    intervalIntegral.intervalIntegrable_cpow' (by rw [Complex.sub_re]; norm_num; linarith)
  have hsplit : (∫ t in (0 : ℝ)..1,
        -((t : ℂ) ^ (s - 2)) + (1 / 2 : ℂ) * (t : ℂ) ^ (s - 1))
      = (∫ t in (0 : ℝ)..1, -((t : ℂ) ^ (s - 2)))
        + (∫ t in (0 : ℝ)..1, (1 / 2 : ℂ) * (t : ℂ) ^ (s - 1)) := by
    simpa [Pi.add_apply] using
      intervalIntegral.integral_add (hf.neg) (hg.const_mul (1 / 2 : ℂ))
  rw [hsplit, intervalIntegral.integral_neg, intervalIntegral.integral_const_mul, h1, h2]
  ring

end AngularPartition

namespace AngularPartition

/-- **Integral splitting at 1.**
For `1 < re s`, the regularized-kernel Mellin transform equals
`Γ(s)ζ(s) - 1/(s-1) + 1/(2s)`.
-/
theorem mellin_regularizedKernel_eq_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    mellin regularizedKernel s = regularizedMellin s := by
  have hf : MellinConvergent zetaKernel s := mellinConvergent_zetaKernel hs
  have hc : MellinConvergent cutoff s := mellinConvergent_cutoff hs
  rw [show regularizedKernel = zetaKernel + cutoff by
    funext t
    exact regularizedKernel_eq_zetaKernel_add_cutoff t]
  rw [mellin_add hf hc, mellin_zetaKernel_eq_Gamma_mul_zeta hs, mellin_cutoff_eq hs]
  rw [regularizedMellin]
  ring

end AngularPartition

namespace AngularPartition

/-- The identity holds on the upper half of the critical strip. -/
theorem mellin_regularizedKernel_eqOn_upper :
    EqOn (mellin regularizedKernel) regularizedMellin
      {s : ℂ | 0 < s.re ∧ 0 < s.im} := by
  let U : Set ℂ := {s : ℂ | 0 < s.re ∧ 0 < s.im}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := 0)).inter (convex_halfSpace_im_gt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | 0 < s.re} ∩ {s : ℂ | 0 < s.im})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_const continuous_im)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel) U :=
    fun z hz => (differentiableAt_mellin_regularizedKernel hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin U :=
    fun z hz => (regularizedMellin_differentiableAt_of_ne hz.1 (by
      intro h
      have hz2 : 0 < (1 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel) regularizedMellin U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) + Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) + Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) + Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel_eq_of_one_lt_re hz
end AngularPartition

namespace AngularPartition

/-- The identity holds on the lower half of the critical strip. -/
theorem mellin_regularizedKernel_eqOn_lower :
    EqOn (mellin regularizedKernel) regularizedMellin
      {s : ℂ | 0 < s.re ∧ s.im < 0} := by
  let U : Set ℂ := {s : ℂ | 0 < s.re ∧ s.im < 0}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := 0)).inter (convex_halfSpace_im_lt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | 0 < s.re} ∩ {s : ℂ | s.im < 0})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_im continuous_const)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel) U :=
    fun z hz => (differentiableAt_mellin_regularizedKernel hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin U :=
    fun z hz => (regularizedMellin_differentiableAt_of_ne hz.1 (by
      intro h
      have hz2 : (1 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel) regularizedMellin U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) - Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) - Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) - Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel_eq_of_one_lt_re hz

end AngularPartition

namespace AngularPartition

/-- The identity holds throughout the critical strip away from its real axis. -/
theorem mellin_regularizedKernel_eq_of_re_pos_of_im_ne {s : ℂ}
    (hs0 : 0 < s.re) (him : s.im ≠ 0) :
    mellin regularizedKernel s = regularizedMellin s := by
  rcases lt_or_gt_of_ne (Ne.symm him) with h | h
  · exact mellin_regularizedKernel_eqOn_upper ⟨hs0, h⟩
  · exact mellin_regularizedKernel_eqOn_lower ⟨hs0, h⟩
end AngularPartition

namespace AngularPartition

/-- The identity extends to the real axis by continuity in the imaginary direction. -/
theorem mellin_regularizedKernel_eq_of_re_pos_of_lt_one {s : ℂ}
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin regularizedKernel s = regularizedMellin s := by
  by_cases him : s.im = 0
  · have hs_eq : s = (s.re : ℂ) := by
      apply Complex.ext <;> simp [him]
    let z : ℝ → ℂ := fun y => (s.re : ℂ) + (y : ℂ) * Complex.I
    have hz_im : ∀ y, y ≠ 0 → (z y).im = y := by
      intro y hy
      simp [z, Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
        Complex.I_im, Complex.I_re]
    have hz_tend : Tendsto z (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds s) := by
      rw [hs_eq]
      have hy : Tendsto (fun y : ℝ => (y : ℂ)) (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds 0) := by
        simpa using (continuous_ofReal.tendsto 0).mono_left nhdsWithin_le_nhds
      simpa [z] using tendsto_const_nhds.add (hy.mul tendsto_const_nhds)
    have hcont : ContinuousAt (mellin regularizedKernel) s :=
      (differentiableAt_mellin_regularizedKernel hs0).continuousAt
    have hcontG : ContinuousAt regularizedMellin s :=
      (regularizedMellin_differentiableAt_of_ne hs0 (by
        intro h
        rw [h] at hs1
        norm_num at hs1)).continuousAt
    have hlim1 : Tendsto (fun y => mellin regularizedKernel (z y))
        (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (mellin regularizedKernel s)) :=
      hcont.tendsto.comp hz_tend
    have hlim2 : Tendsto (fun y => regularizedMellin (z y))
        (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin s)) :=
      hcontG.tendsto.comp hz_tend
    have hlim2' : Tendsto (fun y => mellin regularizedKernel (z y))
        (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin s)) := by
      refine hlim2.congr' ?_
      filter_upwards [self_mem_nhdsWithin] with y hy
      exact (mellin_regularizedKernel_eq_of_re_pos_of_im_ne (s := z y)
        (by simpa [z] using hs0) (by rw [hz_im y hy]; exact hy)).symm
    exact tendsto_nhds_unique hlim1 hlim2'
  · exact mellin_regularizedKernel_eq_of_re_pos_of_im_ne hs0 him

end AngularPartition
