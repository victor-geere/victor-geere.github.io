import ExplicitFormula
import Rectangle

/-!
# Tail bounds for the finite zero sum

The finite zero side of the explicit formula is Lean-proved in
`ExplicitFormula.lean`:

`∮ (Z'/Z)·h = 2πi·(∑_{ρ∈S} h(ρ) − h(0) − h(1))`

for a finite zero set `S` in a rectangle (the theorem
`test_function_explicit_formula`).  This file adds the **tail bound**: the
difference between the zero sums of two nested rectangles is a difference of
boundary integrals, hence bounded by the boundary suprema of `(Z'/Z)·h` times
the perimeters.

The pole terms `−h(0)−h(1)` are the same two residues formalised in the
angular-partition method as T51–T52.
-/

open Complex MeasureTheory Set intervalIntegral
open scoped Topology Interval

namespace AbsoluteHodgeRectangle

/-- **Boundary norm bound.** If `‖f‖ ≤ M` on the boundary of the rectangle,
then the oriented boundary integral is bounded by `M` times the perimeter. -/
theorem norm_rectIntegral_le {f : ℂ → ℂ} {x₁ x₂ y₁ y₂ M : ℝ}
    (hx : x₁ ≤ x₂) (hy : y₁ ≤ y₂)
    (h : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, ‖f z‖ ≤ M) :
    ‖rectIntegral f x₁ x₂ y₁ y₂‖ ≤ M * (2 * (x₂ - x₁) + 2 * (y₂ - y₁)) := by
  unfold rectIntegral
  have hxI : ∀ x ∈ Ι x₁ x₂, x ∈ [[x₁, x₂]] := by
    intro x hx'
    rw [uIcc_of_le hx]
    exact Ioc_subset_Icc_self (by simpa [uIoc_of_le hx] using hx')
  have hyI : ∀ y ∈ Ι y₁ y₂, y ∈ [[y₁, y₂]] := by
    intro y hy'
    rw [uIcc_of_le hy]
    exact Ioc_subset_Icc_self (by simpa [uIoc_of_le hy] using hy')
  have hb : ‖∫ x in x₁..x₂, f (x + y₁ * I)‖ ≤ M * (x₂ - x₁) := by
    have := intervalIntegral.norm_integral_le_of_norm_le_const
      (f := fun x : ℝ => f (x + y₁ * I)) fun x hx' =>
        h _ (mem_rectBoundarySet_horizontal (hxI x hx'))
    rwa [abs_of_nonneg (sub_nonneg.mpr hx)] at this
  have ht : ‖∫ x in x₁..x₂, f (x + y₂ * I)‖ ≤ M * (x₂ - x₁) := by
    have := intervalIntegral.norm_integral_le_of_norm_le_const
      (f := fun x : ℝ => f (x + y₂ * I)) fun x hx' =>
        h _ (mem_rectBoundarySet_horizontal' (hxI x hx'))
    rwa [abs_of_nonneg (sub_nonneg.mpr hx)] at this
  have hr : ‖I * ∫ y in y₁..y₂, f (x₂ + y * I)‖ ≤ M * (y₂ - y₁) := by
    rw [norm_mul, norm_I, one_mul]
    have := intervalIntegral.norm_integral_le_of_norm_le_const
      (f := fun y : ℝ => f (x₂ + y * I)) fun y hy' =>
        h _ (mem_rectBoundarySet_vertical (hyI y hy'))
    rwa [abs_of_nonneg (sub_nonneg.mpr hy)] at this
  have hl : ‖I * ∫ y in y₁..y₂, f (x₁ + y * I)‖ ≤ M * (y₂ - y₁) := by
    rw [norm_mul, norm_I, one_mul]
    have := intervalIntegral.norm_integral_le_of_norm_le_const
      (f := fun y : ℝ => f (x₁ + y * I)) fun y hy' =>
        h _ (mem_rectBoundarySet_vertical' (hyI y hy'))
    rwa [abs_of_nonneg (sub_nonneg.mpr hy)] at this
  have h1 : ∀ A B C D : ℂ, ‖A - B + C - D‖ ≤ ‖A‖ + ‖B‖ + ‖C‖ + ‖D‖ := by
    intro A B C D
    calc
      ‖A - B + C - D‖ ≤ ‖A - B + C‖ + ‖D‖ := norm_sub_le _ _
      _ ≤ (‖A - B‖ + ‖C‖) + ‖D‖ := by
            gcongr
            exact norm_add_le _ _
      _ ≤ ((‖A‖ + ‖B‖) + ‖C‖) + ‖D‖ := by
            gcongr
            exact norm_sub_le _ _
  have h1' := h1 (∫ x in x₁..x₂, f (x + y₁ * I))
    (∫ x in x₁..x₂, f (x + y₂ * I))
    (I * (∫ y in y₁..y₂, f (x₂ + y * I)))
    (I * (∫ y in y₁..y₂, f (x₁ + y * I)))
  have hsum : M * (x₂ - x₁) + M * (x₂ - x₁) + M * (y₂ - y₁) + M * (y₂ - y₁)
      = M * (2 * (x₂ - x₁) + 2 * (y₂ - y₁)) := by ring
  linarith [hb, ht, hr, hl, h1', hsum]

end AbsoluteHodgeRectangle

namespace AbsoluteHodgeExplicitFormula

open AbsoluteHodgeSymbol AbsoluteHodgeRectangle

/-- **Tail bound for the finite zero sum.** For two rectangles with zero sets
`S` and `S'` (nested, `S ⊆ S'`, when this is read as a tail), the zero sum in
`S'` differs from that in `S` by the difference of the two boundary integrals.
If `‖(Z'/Z)·h‖ ≤ M` on both boundaries, then

`‖∑_{ρ∈S'} h(ρ) − ∑_{ρ∈S} h(ρ)‖ ≤ (M/2π)·(perimeter' + perimeter)`.

The two explicit-formula identities are the finite zero-sum + pole-term
statement (`test_function_explicit_formula`), with the T51–T52 pole residues
`−h(0)−h(1)`. -/
theorem zero_sum_tail_bound
    (h : ℂ → ℂ) (S S' : Finset ℂ)
    (x₁ x₂ y₁ y₂ x₁' x₂' y₁' y₂' M : ℝ)
    (hEF : rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I))
    (hEF' : rectIntegral (fun z => logDeriv completedZeta z * h z) x₁' x₂' y₁' y₂'
      = ((∑ ρ ∈ S', h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * I))
    (hx₁ : x₁' ≤ x₂') (hy₁ : y₁' ≤ y₂')
    (hx₂ : x₁ ≤ x₂) (hy₂ : y₁ ≤ y₂)
    (hbound : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      ‖logDeriv completedZeta z * h z‖ ≤ M)
    (hbound' : ∀ z ∈ rectBoundarySet x₁' x₂' y₁' y₂',
      ‖logDeriv completedZeta z * h z‖ ≤ M) :
    ‖(∑ ρ ∈ S', h ρ) - (∑ ρ ∈ S, h ρ)‖ ≤
      M / (2 * Real.pi) *
        ((2 * (x₂' - x₁') + 2 * (y₂' - y₁')) +
         (2 * (x₂ - x₁) + 2 * (y₂ - y₁))) := by
  have hdiff : (∑ ρ ∈ S', h ρ) - (∑ ρ ∈ S, h ρ) =
      (rectIntegral (fun z => logDeriv completedZeta z * h z) x₁' x₂' y₁' y₂' -
        rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂) /
        (2 * (Real.pi : ℂ) * I) := by
    rw [hEF, hEF']
    field_simp
    ring
  rw [hdiff]
  have hI : ‖rectIntegral (fun z => logDeriv completedZeta z * h z) x₁' x₂' y₁' y₂' -
        rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂‖ ≤
      M * (2 * (x₂' - x₁') + 2 * (y₂' - y₁')) +
      M * (2 * (x₂ - x₁) + 2 * (y₂ - y₁)) := by
    refine (norm_sub_le _ _).trans ?_
    have h1 := norm_rectIntegral_le (f := fun z => logDeriv completedZeta z * h z)
      hx₁ hy₁ hbound'
    have h2 := norm_rectIntegral_le (f := fun z => logDeriv completedZeta z * h z)
      hx₂ hy₂ hbound
    linarith
  have hnorm : ‖(2 * (Real.pi : ℂ) * I)‖ = 2 * Real.pi := by
    rw [norm_mul, norm_mul]
    norm_num [Complex.norm_I, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
  calc
    ‖(rectIntegral (fun z => logDeriv completedZeta z * h z) x₁' x₂' y₁' y₂' -
        rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂) /
        (2 * (Real.pi : ℂ) * I)‖
        ≤ (M * (2 * (x₂' - x₁') + 2 * (y₂' - y₁')) +
            M * (2 * (x₂ - x₁) + 2 * (y₂ - y₁))) / (2 * Real.pi) := by
          rw [norm_div, hnorm]
          gcongr
    _ = M / (2 * Real.pi) *
        ((2 * (x₂' - x₁') + 2 * (y₂' - y₁')) +
         (2 * (x₂ - x₁) + 2 * (y₂ - y₁))) := by
          field_simp

end AbsoluteHodgeExplicitFormula
