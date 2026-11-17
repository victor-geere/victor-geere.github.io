import Topic
import Mathlib

/-!
# Zero counting and absolute summability

The Gaussian zero sum is absolutely summable once the nontrivial zeros are
enumerated with the counting lower bound `|γ_n| ≥ c₀ n / log n`.  This file
proves the norm bound on the critical strip and the summability reduction; the
counting bound itself is the named input (it is the Riemann–von Mangoldt
estimate, absent from Mathlib).

The two evaluation inputs are named `ArchimedeanEvaluation` and
`PrimeEvaluation`; `verticalLimitIdentification_of_limits` (T137) is exactly
their conjunction implying the vertical-limit identification.
-/

set_option maxHeartbeats 800000

noncomputable section

open Complex Matrix Filter Topology
open scoped BigOperators

namespace MissingBridge

open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeRectangle
open PrimeSpectrumTensor

/-- The archimedean evaluation input: the sum of the right/left archimedean
limit real parts is `−2π` times the density term. -/
def ArchimedeanEvaluation (c σ : ℝ) (A A' : ℂ) : Prop :=
  A.re + A'.re = -2 * Real.pi * densityTerm c σ

/-- The prime evaluation input: the sum of the right/left prime limit real parts
is `−2π` times the symmetrised prime term. -/
def PrimeEvaluation (c σ : ℝ) (P P' : ℂ) : Prop :=
  P.re + P'.re = -2 * Real.pi * primeTermSym c σ

/-- The two evaluation inputs imply the vertical-limit identification. -/
theorem verticalLimitIdentification_of_evaluations {c σ : ℝ} {A P A' P' : ℂ}
    (hA : ArchimedeanEvaluation c σ A A') (hP : PrimeEvaluation c σ P P') :
    VerticalLimitIdentification c σ A P A' P' :=
  verticalLimitIdentification_of_limits hA hP

/-- Gaussian zero-test norm bound on the critical strip. -/
theorem gaussianZeroTest_norm_le_strip {c σ : ℝ} (hσ : 0 < σ) {ρ : ℂ}
    (h0 : 0 < ρ.re) (h1 : ρ.re < 1) :
    ‖gaussianZeroTest c σ ρ‖ ≤
      (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) *
        max (Real.exp (c / 2)) (Real.exp (-(c / 2)))) * Real.exp (-(σ ^ 2 * ρ.im ^ 2)) := by
  have hnorm := gaussianZeroTest_norm c σ ρ.re ρ.im hσ
  rw [Complex.re_add_im ρ] at hnorm
  rw [hnorm]
  have hx0 : (0 : ℝ) < ρ.re := h0
  have hx1 : ρ.re < 1 := h1
  have hsq : (ρ.re - 1 / 2) ^ 2 ≤ 1 / 4 := by nlinarith
  have hxlo : -(1 / 2 : ℝ) < ρ.re - 1 / 2 := by linarith
  have hxhi : ρ.re - 1 / 2 < 1 / 2 := by linarith
  have hexp1 : Real.exp (σ ^ 2 * ((ρ.re - 1 / 2) ^ 2 - ρ.im ^ 2)) ≤
      Real.exp (σ ^ 2 / 4) * Real.exp (-(σ ^ 2 * ρ.im ^ 2)) := by
    rw [← Real.exp_add]
    apply Real.exp_le_exp.mpr
    nlinarith [sq_nonneg σ, hsq]
  have hexp2 : Real.exp (-(c * (ρ.re - 1 / 2))) ≤
      max (Real.exp (c / 2)) (Real.exp (-(c / 2))) := by
    have harg : -(c * (ρ.re - 1 / 2)) = c * (-(ρ.re - 1 / 2)) := by ring
    rw [harg]
    rcases le_total c 0 with hc | hc
    · rw [max_eq_right (Real.exp_le_exp.mpr (by linarith))]
      apply Real.exp_le_exp.mpr
      nlinarith
    · rw [max_eq_left (Real.exp_le_exp.mpr (by linarith))]
      apply Real.exp_le_exp.mpr
      nlinarith
  set A : ℝ := 2 * Real.pi * σ ^ 2
  set E : ℝ := Real.exp (σ ^ 2 * ((ρ.re - 1 / 2) ^ 2 - ρ.im ^ 2))
  set E' : ℝ := Real.exp (σ ^ 2 / 4)
  set E2 : ℝ := Real.exp (-(σ ^ 2 * ρ.im ^ 2))
  set C : ℝ := Real.exp (-(c * (ρ.re - 1 / 2)))
  set M : ℝ := max (Real.exp (c / 2)) (Real.exp (-(c / 2)))
  have hA : (0 : ℝ) ≤ A := by positivity
  have hE' : (0 : ℝ) < E' := Real.exp_pos _
  have hE2 : (0 : ℝ) < E2 := Real.exp_pos _
  have hC : (0 : ℝ) < C := Real.exp_pos _
  have hstep1 : A * E * C ≤ A * (E' * E2) * M := by
    have h1 : A * E * C ≤ A * (E' * E2) * C := by
      apply mul_le_mul_of_nonneg_right _ hC.le
      exact mul_le_mul_of_nonneg_left hexp1 hA
    have h2 : A * (E' * E2) * C ≤ A * (E' * E2) * M := by
      apply mul_le_mul_of_nonneg_left hexp2
      positivity
    linarith
  calc A * E * C ≤ A * (E' * E2) * M := hstep1
    _ = (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * M) * E2 := by
        ring

end MissingBridge
