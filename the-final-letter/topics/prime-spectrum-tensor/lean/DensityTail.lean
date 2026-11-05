import Mathlib
import GaussianTail
import OmegaGlobal
import DensityWeight
import OmegaContinuous

/-!
# R2 — the density tail

For `t ≥ 60`, `|w(t)·Ω(t)| ≤ (1/400)·t·exp(−t²/400)`, and the moment integral is
`exp(−T²/400)/2`, so the tail beyond 60 is at most `exp(−9)/2 < 10⁻⁴`.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem log_add_two_le {x : ℝ} (hx : 60 ≤ x) : Real.log (x + 2) + 24 ≤ x := by
  have h1 : Real.log (x + 2) = Real.log 4 + Real.log ((x + 2) / 4) := by
    rw [← Real.log_mul (by norm_num) (by positivity)]
    congr 1
    ring
  have h2 : Real.log ((x + 2) / 4) ≤ (x + 2) / 4 - 1 :=
    Real.log_le_sub_one_of_pos (by positivity)
  have h3 : Real.log 4 ≤ 2 := log_four_le_two
  rw [h1]
  linarith

theorem exp_neg_nine_le : Real.exp (-9) ≤ 1 / 5000 := by
  have hsum := Real.sum_le_exp_of_nonneg (by norm_num : (0 : ℝ) ≤ 9) 12
  have hcomp : (5000 : ℝ) ≤ ∑ k ∈ Finset.range 12, (9 : ℝ) ^ k / k.factorial := by
    norm_num [Finset.sum_range_succ, Nat.factorial]
  have hexp : (5000 : ℝ) ≤ Real.exp 9 := le_trans hcomp hsum
  rw [show (-9 : ℝ) = -(9 : ℝ) by ring, Real.exp_neg]
  simpa [one_div] using one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 5000) hexp

theorem abs_densityWeight_le_exp {c x : ℝ} :
    |IntersectionForm.densityWeight (1 / 20) c x| ≤
      (1 / 400 : ℝ) * Real.exp (-(x ^ 2 / 400)) := by
  unfold IntersectionForm.densityWeight
  have h3 : -((1 / 20 : ℝ) ^ 2 * x ^ 2) = -(x ^ 2 / 400) := by ring
  rw [h3, abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (1 / 20 : ℝ) ^ 2),
    abs_of_pos (Real.exp_pos _)]
  have h1 : |Real.cos (c * x)| ≤ 1 := Real.abs_cos_le_one _
  have h2 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) ^ 2 * x ^ 2)) := Real.exp_pos _
  have h3 : -((1 / 20 : ℝ) ^ 2 * x ^ 2) = -(x ^ 2 / 400) := by ring
  calc (1 / 20 : ℝ) ^ 2 * Real.exp (-(x ^ 2 / 400)) * |Real.cos (c * x)|
      ≤ (1 / 20 : ℝ) ^ 2 * Real.exp (-(x ^ 2 / 400)) * 1 := by
        apply mul_le_mul (le_refl _) h1 (abs_nonneg _) (by positivity)
    _ = (1 / 400 : ℝ) * Real.exp (-(x ^ 2 / 400)) := by norm_num

theorem abs_densityWeight_mul_Omega_le {c x : ℝ} (hx : 60 ≤ x) :
    |IntersectionForm.densityWeight (1 / 20) c x * IntersectionForm.Omega x| ≤
      (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)) := by
  rw [abs_mul]
  have hw := abs_densityWeight_le_exp (c := c) (x := x)
  have hΩ := abs_Omega_le (by linarith : 0 < x)
  have hlog := log_add_two_le hx
  have hexp : (0 : ℝ) < Real.exp (-(x ^ 2 / 400)) := Real.exp_pos _
  calc |IntersectionForm.densityWeight (1 / 20) c x| * |IntersectionForm.Omega x|
      ≤ ((1 / 400) * Real.exp (-(x ^ 2 / 400))) * (Real.log (x + 2) + 24) := by
        apply mul_le_mul hw (le_trans hΩ (by linarith)) (abs_nonneg _) (by positivity)
    _ ≤ ((1 / 400) * Real.exp (-(x ^ 2 / 400))) * x := by
        apply mul_le_mul_of_nonneg_left hlog (by positivity)
    _ = (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)) := by ring

/-- The Gaussian moment integrand is integrable on the half-line. -/
theorem integrableOn_gaussian_moment (T : ℝ) :
    MeasureTheory.IntegrableOn (fun x : ℝ => (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)))
      (Set.Ioi T) := by
  have h := integrable_mul_exp_neg_mul_sq (b := 1 / 400) (by norm_num)
  refine (h.const_mul (1 / 400 : ℝ)).integrableOn.congr_fun ?_ measurableSet_Ioi
  intro x _
  ring_nf

/-- **The density tail.** -/
theorem density_tail_le {c : ℝ} :
    |∫ x in Set.Ioi (60 : ℝ), IntersectionForm.densityWeight (1 / 20) c x *
      IntersectionForm.Omega x| ≤ 1 / 10000 := by
  have habs : |∫ x in Set.Ioi (60 : ℝ), IntersectionForm.densityWeight (1 / 20) c x *
      IntersectionForm.Omega x| ≤
      ∫ x in Set.Ioi (60 : ℝ), |IntersectionForm.densityWeight (1 / 20) c x *
        IntersectionForm.Omega x| :=
    MeasureTheory.abs_integral_le_integral_abs
  have hgm := integrableOn_gaussian_moment (T := 60)
  have hf : MeasureTheory.IntegrableOn
      (fun x : ℝ => |IntersectionForm.densityWeight (1 / 20) c x * IntersectionForm.Omega x|)
      (Set.Ioi 60) := by
    refine MeasureTheory.Integrable.mono' hgm ?_ ?_
    · exact (continuous_abs.comp ((continuous_densityWeight c).mul continuous_Omega)).aestronglyMeasurable
    · filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
      rw [Real.norm_eq_abs, abs_abs]
      exact abs_densityWeight_mul_Omega_le (le_of_lt (Set.mem_Ioi.mp hx))
  have hmono : (∫ x in Set.Ioi (60 : ℝ), |IntersectionForm.densityWeight (1 / 20) c x *
      IntersectionForm.Omega x|) ≤
      ∫ x in Set.Ioi (60 : ℝ), (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)) := by
    exact MeasureTheory.setIntegral_mono_on hf hgm measurableSet_Ioi
      (fun x hx => abs_densityWeight_mul_Omega_le (le_of_lt (Set.mem_Ioi.mp hx)))
  have hval : (∫ x in Set.Ioi (60 : ℝ), (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400))) =
      Real.exp (-9) / 2 := by
    rw [integral_Ioi_gaussian_moment (T := 60)]
    norm_num
  calc |∫ x in Set.Ioi (60 : ℝ), IntersectionForm.densityWeight (1 / 20) c x *
        IntersectionForm.Omega x|
      ≤ ∫ x in Set.Ioi (60 : ℝ), |IntersectionForm.densityWeight (1 / 20) c x *
          IntersectionForm.Omega x| := habs
    _ ≤ ∫ x in Set.Ioi (60 : ℝ), (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)) := hmono
    _ = Real.exp (-9) / 2 := hval
    _ ≤ 1 / 10000 := by
        have h := exp_neg_nine_le
        linarith

end PrimeSpectrumTensor
