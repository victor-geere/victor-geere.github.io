import Mathlib
import DensityEnclosure

/-!
# Elementary facts about the density weight

`IntersectionForm.densityWeight σ c t = σ²·exp(−σ²t²)·cos(ct)`.  The panel
estimate needs `|w| ≤ Sw = σ²` and continuity.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem abs_densityWeight_le {c : ℝ} (t : ℝ) :
    |IntersectionForm.densityWeight (1 / 20) c t| ≤ 1 / 400 := by
  unfold IntersectionForm.densityWeight
  rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (1 / 20 : ℝ) ^ 2),
    abs_of_pos (Real.exp_pos _)]
  have h1 : Real.exp (-((1 / 20 : ℝ) ^ 2 * t ^ 2)) ≤ 1 := by
    rw [Real.exp_le_one_iff]
    nlinarith [sq_nonneg t]
  have h2 : |Real.cos (c * t)| ≤ 1 := Real.abs_cos_le_one _
  calc (1 / 20 : ℝ) ^ 2 * Real.exp (-((1 / 20 : ℝ) ^ 2 * t ^ 2)) * |Real.cos (c * t)|
      ≤ (1 / 20 : ℝ) ^ 2 * 1 * 1 := by
        apply mul_le_mul (mul_le_mul (le_refl _) h1 (Real.exp_pos _).le (by norm_num)) h2
          (abs_nonneg _) (by positivity)
    _ = 1 / 400 := by norm_num

theorem continuous_densityWeight (c : ℝ) :
    Continuous (fun t => IntersectionForm.densityWeight (1 / 20) c t) := by
  unfold IntersectionForm.densityWeight
  fun_prop

theorem densityWeight_nonneg {c : ℝ} (t : ℝ) (ht : Real.cos (c * t) ≥ 0) :
    0 ≤ IntersectionForm.densityWeight (1 / 20) c t := by
  unfold IntersectionForm.densityWeight
  have h1 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) ^ 2 * t ^ 2)) := Real.exp_pos _
  have h2 : (0 : ℝ) ≤ (1 / 20 : ℝ) ^ 2 := sq_nonneg _
  nlinarith

end PrimeSpectrumTensor
