/-
  DirichletExplicitWiring.lean — **wiring the proved zero side into `DirichletExplicitData`**.

  `DirichletExplicitData` (`DirichletExplicit.lean`) carries the explicit-formula identity as a
  *field* `h_identity`.  With the weighted zero side now proved
  (`dirichletCompleted_zeroSum`), that field can be *discharged* rather than hypothesised: the
  identity `lhs = rhsTrue` becomes the theorem

    `Im (rightPath (F·Λ_χ'/Λ_χ) t₀ t₁) = π · Re (∑_{z∈Z} m z · F z)`.

  Only the truncation split `h_split` (the finite certified zero sum plus the three tail bounds)
  remains an input — it is the numerical content.  The pay-off is
  `routeC_residual_bound_of_zeroSum`: the Route-C residual bound with the identity proved.
-/
import DirichletExplicit
import DirichletCompletedSymmetry

open MeasureTheory intervalIntegral
open scoped Interval
open Rh45RouteBAnalytic
open DirichletCharacter

namespace RouteABC

noncomputable section

/-- A `DirichletExplicitData` instance whose **identity is proved** (the weighted zero side,
`dirichletCompleted_zeroSum`), with only the truncation split left as numerical input. -/
noncomputable def dirichletExplicitDataOfZeroSum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (F : ℂ → ℂ)
    (hF : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (rhsComputed zeroTail primeTail archTail : ℝ)
    (h_split : Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
      = rhsComputed + (zeroTail + primeTail + archTail)) :
    DirichletExplicitData χ where
  lhs := (rightPath (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1).im
  rhsTrue := Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
  rhsComputed := rhsComputed
  zeroTail := zeroTail
  primeTail := primeTail
  archTail := archTail
  h_identity := dirichletCompleted_zeroSum χ hχ hχinv hsign hreal F hF t0 t1 Z m ht hAn hF_an
    hZ hm hno hint₀ hint₁
  h_split := h_split

/-- **The Route-C residual bound with the explicit-formula identity proved.**  The zero side is
`dirichletCompleted_zeroSum`; the truncation split is the numerical input. -/
theorem routeC_residual_bound_of_zeroSum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (F : ℂ → ℂ)
    (hF : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (rhsComputed zeroTail primeTail archTail : ℝ)
    (h_split : Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
      = rhsComputed + (zeroTail + primeTail + archTail)) :
    |(rightPath (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1).im - rhsComputed|
      ≤ |zeroTail| + |primeTail| + |archTail| :=
  (dirichletExplicitDataOfZeroSum χ hχ hχinv hsign hreal F hF t0 t1 Z m ht hAn hF_an hZ hm hno
    hint₀ hint₁ rhsComputed zeroTail primeTail archTail h_split).validated

end

end RouteABC
