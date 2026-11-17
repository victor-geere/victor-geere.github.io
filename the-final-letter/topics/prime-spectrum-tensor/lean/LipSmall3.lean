import Mathlib
import LipSmall2
import DensityPanel

/-!
# A sharper Lipschitz bound for `Ω`

[`LipSmall2.lean`](LipSmall2.lean) proves `|Ω′(t)| ≤ 6/t` for `t ≥ 1` from
`Σ_j ((j+1/4)²+a²)⁻¹ ≤ 6/a` at `a = t/2`.  The true constant is
`sup_{a ≥ 1/2} a·Σ_j ((j+1/4)²+a²)⁻¹ = 2.148…` (at `a = 1/2`), approaching
`π/2` as `a → ∞`, so `6/a` is losable by a factor three.

This file proves `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 5/(2a)`, hence

```lean
theorem deriv_Omega_abs_le_five_halves {t : ℝ} (ht : 1 ≤ t) :
    |deriv IntersectionForm.Omega t| ≤ 5 / (2 * t)
```

i.e. `|Ω′| ≤ 2.5/t` against the previous `6/t`.  Every panel error of the
density certificate is linear in the Lipschitz constant, so this is a factor
`12/5 = 2.4` fewer panels at the same certified width.

## How the bound is proved

For `a ≥ 4` the existing head/tail estimate (`sum_range_shifted_inv_le`)
already gives `(a+2)/a² + 1/a ≤ 5/(2a)`.

For `1/2 ≤ a ≤ 4` four explicit head terms are used, and the tail is compared
with `Σ_{j ≥ 0} (j+4)⁻² ≤ 1/3` (the existing `sum_range_tail_le`), which leaves
the purely rational inequality `headFour a + 1/3 ≤ 5/(2a)`.  `headFour` is
antitone and `5/(2a)` is decreasing, so the inequality is checked on a ladder of
16 rational sub-intervals: on each, the left side is bounded at the left
endpoint and the right side at the right endpoint, and the resulting rational
comparison is `norm_num`.  The worst sub-interval has an 8% margin.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

set_option maxHeartbeats 1200000

/-- The first four terms of the shifted sum, in the shape in which they appear
in `Finset.range 4`. -/
noncomputable def headFour (a : ℝ) : ℝ :=
  ((((0 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ + ((((1 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
    + ((((2 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ + ((((3 : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹

theorem headFour_eq_sum (a : ℝ) :
    ∑ j ∈ Finset.range 4, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ = headFour a := by
  norm_num [Finset.sum_range_succ, headFour]

/-- `headFour` is antitone on `[0, ∞)`. -/
theorem headFour_antitone {u a : ℝ} (hu : 0 ≤ u) (hau : u ≤ a) : headFour a ≤ headFour u := by
  have h2 : u ^ 2 ≤ a ^ 2 := by
    have h1 : (0 : ℝ) ≤ a - u := by linarith
    have h3 : (0 : ℝ) ≤ a + u := by linarith
    nlinarith [mul_nonneg h1 h3]
  unfold headFour
  refine add_le_add (add_le_add (add_le_add ?_ ?_) ?_) ?_
  · rw [inv_le_inv₀ (by positivity) (by positivity)]; linarith
  · rw [inv_le_inv₀ (by positivity) (by positivity)]; linarith
  · rw [inv_le_inv₀ (by positivity) (by positivity)]; linarith
  · rw [inv_le_inv₀ (by positivity) (by positivity)]; linarith

/-- The rational comparison transported from one sub-interval `[u, v]`. -/
theorem headFour_le_of_interval {u v a : ℝ} (hu : 0 < u)
    (hchk : headFour u + 1 / 3 ≤ 5 / (2 * v))
    (hau : u ≤ a) (hav : a ≤ v) :
    headFour a + 1 / 3 ≤ 5 / (2 * a) := by
  have ha0 : (0 : ℝ) < a := by linarith
  have hv0 : (0 : ℝ) < v := by linarith
  have h1 : headFour a ≤ headFour u := headFour_antitone (le_of_lt hu) hau
  have h2 : 5 / (2 * v) ≤ 5 / (2 * a) := by
    rw [div_le_div_iff₀ (by linarith) (by linarith)]
    nlinarith
  linarith

/-- **The compact-range bound.**  `headFour a + 1/3 ≤ 5/(2a)` for `1/2 ≤ a ≤ 4`. -/
theorem headFour_add_le {a : ℝ} (ha : 1 / 2 ≤ a) (h4 : a ≤ 4) :
    headFour a + 1 / 3 ≤ 5 / (2 * a) := by
  rcases le_total a (13 / 25) with h1 | h1
  · exact headFour_le_of_interval (u := 1 / 2) (v := 13 / 25) (by norm_num)
      (by norm_num [headFour]) ha h1
  rcases le_total a (11 / 20) with h2 | h2
  · exact headFour_le_of_interval (u := 13 / 25) (v := 11 / 20) (by norm_num)
      (by norm_num [headFour]) h1 h2
  rcases le_total a (59 / 100) with h3 | h3
  · exact headFour_le_of_interval (u := 11 / 20) (v := 59 / 100) (by norm_num)
      (by norm_num [headFour]) h2 h3
  rcases le_total a (16 / 25) with h5 | h5
  · exact headFour_le_of_interval (u := 59 / 100) (v := 16 / 25) (by norm_num)
      (by norm_num [headFour]) h3 h5
  rcases le_total a (71 / 100) with h6 | h6
  · exact headFour_le_of_interval (u := 16 / 25) (v := 71 / 100) (by norm_num)
      (by norm_num [headFour]) h5 h6
  rcases le_total a (4 / 5) with h7 | h7
  · exact headFour_le_of_interval (u := 71 / 100) (v := 4 / 5) (by norm_num)
      (by norm_num [headFour]) h6 h7
  rcases le_total a (23 / 25) with h8 | h8
  · exact headFour_le_of_interval (u := 4 / 5) (v := 23 / 25) (by norm_num)
      (by norm_num [headFour]) h7 h8
  rcases le_total a (109 / 100) with h9 | h9
  · exact headFour_le_of_interval (u := 23 / 25) (v := 109 / 100) (by norm_num)
      (by norm_num [headFour]) h8 h9
  rcases le_total a (33 / 25) with h10 | h10
  · exact headFour_le_of_interval (u := 109 / 100) (v := 33 / 25) (by norm_num)
      (by norm_num [headFour]) h9 h10
  rcases le_total a (81 / 50) with h11 | h11
  · exact headFour_le_of_interval (u := 33 / 25) (v := 81 / 50) (by norm_num)
      (by norm_num [headFour]) h10 h11
  rcases le_total a (199 / 100) with h12 | h12
  · exact headFour_le_of_interval (u := 81 / 50) (v := 199 / 100) (by norm_num)
      (by norm_num [headFour]) h11 h12
  rcases le_total a (243 / 100) with h13 | h13
  · exact headFour_le_of_interval (u := 199 / 100) (v := 243 / 100) (by norm_num)
      (by norm_num [headFour]) h12 h13
  rcases le_total a (73 / 25) with h14 | h14
  · exact headFour_le_of_interval (u := 243 / 100) (v := 73 / 25) (by norm_num)
      (by norm_num [headFour]) h13 h14
  rcases le_total a (17 / 5) with h15 | h15
  · exact headFour_le_of_interval (u := 73 / 25) (v := 17 / 5) (by norm_num)
      (by norm_num [headFour]) h14 h15
  rcases le_total a (191 / 50) with h16 | h16
  · exact headFour_le_of_interval (u := 17 / 5) (v := 191 / 50) (by norm_num)
      (by norm_num [headFour]) h15 h16
  · exact headFour_le_of_interval (u := 191 / 50) (v := 4) (by norm_num)
      (by norm_num [headFour]) h16 h4

/-- **The partial-sum bound with four head terms.**  For `a ≥ 1/2` and every
`N`, the first `N` terms are at most `headFour a + 1/3`. -/
theorem sum_range_le_headFour {a : ℝ} (ha : 1 / 2 ≤ a) (N : ℕ) :
    ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ headFour a + 1 / 3 := by
  rcases Nat.lt_or_ge N 4 with hN | hN
  · have hsub : ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
        ≤ ∑ j ∈ Finset.range 4, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.range_mono (by omega))
        (by intro j _ _; positivity)
    rw [headFour_eq_sum] at hsub
    linarith
  · obtain ⟨M, rfl⟩ : ∃ M, N = 4 + M := ⟨N - 4, by omega⟩
    rw [Finset.sum_range_add, headFour_eq_sum]
    have htail : ∑ j ∈ Finset.range M, ((((4 + j : ℕ) : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹
        ≤ 1 / 3 := by
      have hK := sum_range_tail_le (K := 4) (by norm_num) M
      norm_num at hK
      refine le_trans (Finset.sum_le_sum fun j _ => ?_) hK
      rw [inv_le_inv₀ (by positivity) (by positivity)]
      have hcast : ((4 + j : ℕ) : ℝ) = (j : ℝ) + 4 := by push_cast; ring
      rw [hcast]
      nlinarith [Nat.cast_nonneg (α := ℝ) j, sq_nonneg ((j : ℝ) + 4)]
    linarith

/-- **The sharper partial-sum bound.**  Every finite partial sum of
`Σ_j ((j+1/4)²+a²)⁻¹` is at most `5/(2a)` for `a ≥ 1/2`. -/
theorem sum_range_shifted_inv_le_five_halves {a : ℝ} (ha : 1 / 2 ≤ a) (N : ℕ) :
    ∑ j ∈ Finset.range N, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ 5 / (2 * a) := by
  have ha0 : (0 : ℝ) < a := by linarith
  rcases le_total a 4 with h4 | h4
  · have h1 := sum_range_le_headFour ha N
    have h2 := headFour_add_le ha h4
    linarith
  · have h1 := sum_range_shifted_inv_le ha N
    have h2 : (a + 2) / a ^ 2 + 1 / a ≤ 5 / (2 * a) := by
      have h : (a + 2) / a ^ 2 + 1 / a = (2 * a + 2) / a ^ 2 := by
        field_simp
        ring
      rw [h, div_le_div_iff₀ (by positivity) (by positivity)]
      nlinarith [mul_nonneg (le_of_lt ha0) (by linarith : (0 : ℝ) ≤ a - 4)]
    linarith

/-- **The sharper shifted-sum bound.**  `Σ_j ((j+1/4)²+a²)⁻¹ ≤ 5/(2a)` for
`a ≥ 1/2`. -/
theorem tsum_shifted_inv_le_five_halves {a : ℝ} (ha : 1 / 2 ≤ a) :
    ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + a ^ 2)⁻¹ ≤ 5 / (2 * a) :=
  Real.tsum_le_of_sum_range_le (fun j => by positivity)
    (fun N => sum_range_shifted_inv_le_five_halves ha N)

/-- **The sharper Lipschitz bound.**  `|Ω′(t)| ≤ 5/(2t)` for `t ≥ 1`. -/
theorem deriv_Omega_abs_le_five_halves {t : ℝ} (ht : 1 ≤ t) :
    |deriv IntersectionForm.Omega t| ≤ 5 / (2 * t) := by
  have h1 := deriv_Omega_abs_le_tsum t
  have ha : (1 / 2 : ℝ) ≤ t / 2 := by linarith
  have h2 := tsum_shifted_inv_le_five_halves ha
  have h3 : (1 / 2 : ℝ) * (5 / (2 * (t / 2))) = 5 / (2 * t) := by
    field_simp
  calc |deriv IntersectionForm.Omega t|
      ≤ (1 / 2) * ∑' j : ℕ, (((j : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ := h1
    _ ≤ (1 / 2) * (5 / (2 * (t / 2))) := by linarith
    _ = 5 / (2 * t) := h3

end PrimeSpectrumTensor
