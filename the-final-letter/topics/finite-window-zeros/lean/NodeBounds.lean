import LSeriesTaylor
import LSeriesBound
import LSeriesAnchor

noncomputable section
open Complex MeasureTheory

namespace FiniteWindowZeros

/-- Coarse absolute node bound for `LSeries Λ (2+iy)` on `|y| ≤ 1/2`. -/
theorem norm_LSeries_two_node_le {y : ℝ} (hy : |y| ≤ (1 / 2 : ℝ)) :
    ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)‖ ≤ 124 := by
  have h0 : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ ≤ 24 := by
    simpa using norm_LSeries_vonMangoldt_two_le (y := 0)
  have hdiff : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)
      - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ ≤ 200 * |y| :=
    norm_LSeries_vonMangoldt_sub_two_le hy
  have htri : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)‖ ≤
      ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ +
        ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)
          - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ := by
    have h := norm_add_le
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2)
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (2 + (y : ℂ) * Complex.I)
        - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2)
    have heq : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2 +
        (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)
          - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2) =
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I) := by ring
    rwa [heq] at h
  have hy2 : 200 * |y| ≤ 100 := by nlinarith [abs_nonneg y, hy]
  linarith

/-- **Absolute `LSeries` node enclosure with rational anchor.**  For
`|y| ≤ 1/2`, the value is bounded by the anchor radius plus `200|y|`. -/
theorem norm_LSeries_two_node_le_anchor {y : ℝ} (hy : |y| ≤ (1 / 2 : ℝ)) :
    ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)‖ ≤
      max |(anchorLo : ℝ)| |(anchorHi : ℝ)| + 200 * |y| := by
  have hmem := LSeries_two_anchor
  have him := LSeries_two_anchor_im
  set x : ℝ := (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2).re with hx
  have hxmem : (anchorLo : ℝ) ≤ x ∧ x ≤ (anchorHi : ℝ) := hmem
  have hnorm2 : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ = |x| := by
    have hz : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2 = (x : ℂ) := by
      apply Complex.ext
      · simp [hx]
      · simpa [hx] using him
    rw [hz, Complex.norm_real, Real.norm_eq_abs]
  have hxabs : |x| ≤ max |(anchorLo : ℝ)| |(anchorHi : ℝ)| := by
    rcases le_total 0 x with hx0 | hx0
    · rw [abs_of_nonneg hx0]
      exact hxmem.2.trans (le_abs_self _ |>.trans (le_max_right _ _))
    · rw [abs_of_nonpos hx0]
      have h1 : -x ≤ -(anchorLo : ℝ) := by linarith [hxmem.1]
      exact h1.trans (neg_le_abs _ |>.trans (le_max_left _ _))
  have hdiff := norm_LSeries_vonMangoldt_sub_two_le hy
  have htri : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)‖ ≤
      ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ +
        ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)
          - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ := by
    have h := norm_add_le
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2)
      (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (2 + (y : ℂ) * Complex.I)
        - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2)
    have heq : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2 +
        (LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)
          - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2) =
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I) := by ring
    rwa [heq] at h
  calc ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
        (2 + (y : ℂ) * Complex.I)‖
      ≤ ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ +
        ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)
          - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ := htri
    _ ≤ max |(anchorLo : ℝ)| |(anchorHi : ℝ)| + 200 * |y| := by
        rw [hnorm2]
        linarith [hxabs, hdiff]


end FiniteWindowZeros
