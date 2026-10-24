/-
  DirichletRouteB.lean — Route B for Dirichlet L-functions with the conjugation gap discharged.

  `Generic.lean` states `routeB_for_dirichletL` conditional on two `Prop`s that Mathlib did not
  supply:

    * `RootNumberSign χ`            — `rootNumber χ = 1 ∨ rootNumber χ = -1`
    * `CompletedLFunctionConj χ`    — `∀ s, Λ_χ(conj s) = conj (Λ_χ s)`

  `DirichletConj.lean` *proves* the second one, for every character with real values
  (`DirichletCharacter.completedLFunction_conj`).  `RootNumber.lean` *proves* the first one, for
  every nontrivial quadratic primitive character (`rootNumberSign_of_isQuadratic`).  This file
  discharges both, leaving no hypothesis beyond the shared analytic data.
-/
import Mathlib.NumberTheory.LSeries.DirichletContinuation
import DirichletConj
import RootNumber
import Generic

open MeasureTheory intervalIntegral
open scoped Topology ComplexConjugate
open DirichletCharacter
open Complex
open Rh45RouteBAnalytic

namespace RouteABC

/-- **The conjugation `Prop` of `Generic.lean` is a theorem.**  For a character with real values,
`CompletedLFunctionConj χ` holds — it is `DirichletCharacter.completedLFunction_conj`. -/
theorem completedLFunctionConj_of_real {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) : CompletedLFunctionConj χ :=
  fun s => DirichletCharacter.completedLFunction_conj χ hreal s

/-- **Route B for Dirichlet L-functions, with the conjugation gap discharged.**

Identical to `routeB_for_dirichletL`, except that the conjugation `Prop` `CompletedLFunctionConj χ`
is no longer a hypothesis: it is derived from the reality of the character,
`hreal : ∀ n, conj (χ n) = χ n`.  The single remaining hypothesis beyond the shared analytic data
is `RootNumberSign χ`. -/
theorem routeB_for_dirichletL_of_real {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hε : RootNumberSign χ) (hreal : ∀ n : ℕ, conj (χ n) = χ n)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  routeB_for_dirichletL χ t0 t1 Z m hχ hχinv hε
    (completedLFunctionConj_of_real χ hreal) ht han hmem hm hno hint₀ hint₁

/-- **Route B for Dirichlet L-functions, with every named hypothesis discharged.**

Both `Prop`s of `Generic.lean` are now theorems: `RootNumberSign χ` from
`rootNumberSign_of_isQuadratic` (`RootNumber.lean`) and `CompletedLFunctionConj χ` from the
reality of a quadratic character.  The only inputs beyond the shared analytic data are
`χ` primitive, `χ⁻¹ = χ`, `χ ≠ 1` and `χ` quadratic.  (The hypothesis `hχinv : χ⁻¹ = χ` is
redundant — `hχ2.inv` supplies it — but is kept for interface stability with
`routeB_for_dirichletL_of_real`.) -/
theorem routeB_for_dirichletL_unconditional {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) :=
  routeB_for_dirichletL_of_real χ t0 t1 Z m hχ hχinv
    (rootNumberSign_of_isQuadratic χ hχ hχ1 hχ2)
    (conj_eq_self_of_isQuadratic χ hχ2) ht han hmem hm hno hint₀ hint₁

end RouteABC
