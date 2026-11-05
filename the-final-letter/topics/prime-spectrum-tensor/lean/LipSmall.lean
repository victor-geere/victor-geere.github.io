import Mathlib
import DensityPanel

/-!
# The global Lipschitz bound for `Ω`

`deriv_Omega_abs_le` gives `|Ω′| ≤ 6/t` only for `t ≥ 4`.  Here we prove
`Σ_j ((j+1/4)² + a²)⁻¹ ≤ 18`, hence (with `DensityPanel.deriv_Omega_abs_le_tsum`)
`|Ω′| ≤ 10` for **all** `t`.

The comparison is telescoping: `j = 0` contributes `16`, and for `j ≥ 1` the term
is at most `2/(j(j+1)) = 2(1/j − 1/(j+1))`, whose total is `2`.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

theorem sum_telescope_inv : ∀ m : ℕ,
    ∑ i ∈ Finset.range m, ((1 : ℝ) / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) =
      1 - 1 / ((m : ℝ) + 1) := by
  intro m
  induction m with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      have h1 : (0 : ℝ) < (m : ℝ) + 1 := by positivity
      have h2 : (0 : ℝ) < (m : ℝ) + 2 := by positivity
      field_simp
      ring

theorem tsum_inv_shift_add_sq_le {a : ℝ} :
    ∑' j : ℕ, ((((j : ℝ) + 1 / 4) ^ 2 + a ^ 2))⁻¹ ≤ 18 := by
  refine Real.tsum_le_of_sum_range_le (fun j => by positivity) (fun N => ?_)
  match N with
  | 0 => simp
  | m + 1 =>
    rw [Finset.sum_range_succ']
    have h0 : ((((0 : ℝ) + 1 / 4) ^ 2 + a ^ 2))⁻¹ ≤ 16 := by
      rw [inv_le_iff_one_le_mul₀ (by positivity)]
      nlinarith [sq_nonneg a]
    have hstep : ∀ i : ℕ, ((((i + 1 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤
        2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) := by
      intro i
      have hcast : (((i + 1 : ℕ)) : ℝ) = (i : ℝ) + 1 := by push_cast; ring
      have hprod2 : 2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) =
          2 / (((i : ℝ) + 1) * ((i : ℝ) + 2)) := by
        have h1 : (0 : ℝ) < (i : ℝ) + 1 := by positivity
        have h2 : (0 : ℝ) < (i : ℝ) + 2 := by positivity
        field_simp
        ring
      rw [hcast, hprod2]
      have hX : (0 : ℝ) < ((i : ℝ) + 1 + 1 / 4) ^ 2 + a ^ 2 := by positivity
      have hY : (0 : ℝ) < ((i : ℝ) + 1) * ((i : ℝ) + 2) := by positivity
      rw [le_div_iff₀ hY]
      rw [show ((((i : ℝ) + 1 + 1 / 4) ^ 2 + a ^ 2))⁻¹ * (((i : ℝ) + 1) * ((i : ℝ) + 2)) =
          (((i : ℝ) + 1) * ((i : ℝ) + 2)) / ((((i : ℝ) + 1 + 1 / 4) ^ 2 + a ^ 2)) by ring]
      rw [div_le_iff₀ hX]
      nlinarith [sq_nonneg a, Nat.cast_nonneg (α := ℝ) i]
    have hsum : ∑ i ∈ Finset.range m,
        2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) ≤ 2 := by
      rw [← Finset.mul_sum, sum_telescope_inv]
      have hm : (0 : ℝ) ≤ 1 / ((m : ℝ) + 1) := by positivity
      nlinarith
    have hmono : ∑ i ∈ Finset.range m, ((((i + 1 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤
        ∑ i ∈ Finset.range m, 2 * (1 / ((i : ℝ) + 1) - 1 / ((i : ℝ) + 2)) :=
      Finset.sum_le_sum fun i _ => hstep i
    linarith

/-- **The global Lipschitz bound.** `|Ω′(t)| ≤ 10` for all `t`. -/
theorem deriv_Omega_abs_le_ten (t : ℝ) :
    |deriv IntersectionForm.Omega t| ≤ 10 := by
  have h1 := deriv_Omega_abs_le_tsum t
  have h2 := tsum_inv_shift_add_sq_le (a := t / 2)
  linarith

end PrimeSpectrumTensor
