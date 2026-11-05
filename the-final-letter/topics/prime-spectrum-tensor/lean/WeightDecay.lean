import Mathlib
import WeightBound
import DensityWeight

/-!
# The weight's decay, rationally

`|w(t)| ≤ (1/400)·exp(−t²/400) ≤ (1/400)/(1 + a²/400)` for `t ≥ a ≥ 0`.

The right-hand side is **rational**, so the generator can use a panel-local `Sw`
without any exp bound: `exp(−u) ≤ 1/(1+u)` follows from `1 + u ≤ exp u`.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem exp_neg_le_inv_one_add {u : ℝ} (hu : 0 ≤ u) : Real.exp (-u) ≤ 1 / (1 + u) := by
  have h : 1 + u ≤ Real.exp u := by
    have := Real.add_one_le_exp u
    linarith
  have hpos : (0 : ℝ) < 1 + u := by linarith
  rw [Real.exp_neg]
  simpa [one_div] using one_div_le_one_div_of_le hpos h

theorem abs_weight_le_exp {c t : ℝ} :
    |weight c t| ≤ (1 / 400 : ℝ) * Real.exp (-(t ^ 2 / 400)) := by
  unfold weight
  rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400),
    abs_of_pos (Real.exp_pos _)]
  have h1 : |Real.cos (c * t)| ≤ 1 := Real.abs_cos_le_one _
  have h2 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) * t) ^ 2) := Real.exp_pos _
  have h3 : -((1 / 20 : ℝ) * t) ^ 2 = -(t ^ 2 / 400) := by ring
  rw [h3]
  nlinarith [h1, h2, Real.exp_pos (-(t ^ 2 / 400)),
    mul_nonneg (le_of_lt h2) (abs_nonneg (Real.cos (c * t)))]

/-- **The rational panel-local weight bound.** -/
theorem abs_weight_le_div {c : ℝ} {a t : ℝ} (ha : 0 ≤ a) (hat : a ≤ t) :
    |weight c t| ≤ (1 / 400 : ℝ) / (1 + a ^ 2 / 400) := by
  have h1 := abs_weight_le_exp (c := c) (t := t)
  have h2 : a ^ 2 / 400 ≤ t ^ 2 / 400 := by nlinarith
  have h3 : Real.exp (-(t ^ 2 / 400)) ≤ Real.exp (-(a ^ 2 / 400)) := by
    apply Real.exp_le_exp.mpr
    linarith
  have h4 : Real.exp (-(a ^ 2 / 400)) ≤ 1 / (1 + a ^ 2 / 400) :=
    exp_neg_le_inv_one_add (by positivity)
  have h5 : (0 : ℝ) < Real.exp (-(t ^ 2 / 400)) := Real.exp_pos _
  calc |weight c t| ≤ (1 / 400) * Real.exp (-(t ^ 2 / 400)) := h1
    _ ≤ (1 / 400) * (1 / (1 + a ^ 2 / 400)) := by
        apply mul_le_mul_of_nonneg_left (le_trans h3 h4) (by norm_num)
    _ = (1 / 400) / (1 + a ^ 2 / 400) := by ring

end PrimeSpectrumTensor
