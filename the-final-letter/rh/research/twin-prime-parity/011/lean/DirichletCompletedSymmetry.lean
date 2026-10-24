/-
  DirichletCompletedSymmetry.lean — the two symmetries of `logDeriv (dirichletCompleted χ)`.

  These are the inputs the contour evaluation of the explicit formula consumes:

  * self-duality of the logarithmic derivative under `s ↦ 1 − s`
    (`logDeriv_dirichletCompleted_one_sub`), inherited from the functional equation
    `Λ_χ(1−s) = ε·Λ_χ(s)` with `ε = rootNumber χ = ±1` — the sign cancels in `logDeriv`
    (`logDeriv_one_sub_of_const_mul`);
  * conjugation symmetry on the real axis (`logDeriv_dirichletCompleted_conj`), inherited from
    reality of `Λ_χ` (`Rh45RouteBAnalytic.logDeriv_conj`).

  Together they are the `hrefl`/(Route B) reflection hypotheses, now in the completed,
  normalised variable used by the explicit formula.
-/
import DirichletCompletedLogDeriv
import DirichletWeightedArgumentPrinciple
import Rh45.RouteBAnalytic

namespace RouteABC

noncomputable section

open scoped BigOperators
open scoped Interval
open DirichletCharacter
open Rh45RouteBAnalytic
open MeasureTheory

/-- **Self-duality of the logarithmic derivative.**  From the functional equation
`Λ_χ(1−s) = ε·Λ_χ(s)` with `ε = rootNumber χ = ±1`, the sign cancels in the logarithmic
derivative: `logDeriv (dirichletCompleted χ) (1 − s) = −logDeriv (dirichletCompleted χ) s`. -/
theorem logDeriv_dirichletCompleted_one_sub {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ) (s : ℂ) :
    logDeriv (dirichletCompleted χ) (1 - s)
      = -logDeriv (dirichletCompleted χ) s := by
  have hε : rootNumber χ ≠ 0 := by
    rcases hsign with h | h <;> rw [h] <;> norm_num
  exact logDeriv_one_sub_of_const_mul (dirichletCompleted χ) (rootNumber χ) hε
    (fun s => dirichletCompleted_selfDual χ hχ hχinv s) s

/-- **Conjugation symmetry of the logarithmic derivative.**  From reality of the completed
L-function, `logDeriv (dirichletCompleted χ) (starRingEnd ℂ s) = starRingEnd ℂ (logDeriv (dirichletCompleted χ) s)`. -/
theorem logDeriv_dirichletCompleted_conj {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hreal : CompletedLFunctionConj χ) (s : ℂ) :
    logDeriv (dirichletCompleted χ) (starRingEnd ℂ s)
      = starRingEnd ℂ (logDeriv (dirichletCompleted χ) s) :=
  Rh45RouteBAnalytic.logDeriv_conj (dirichletCompleted χ) (dirichletCompleted_conj χ hreal) s

/-- **The reflection hypothesis of Route B**, in the completed variable: combining the two
symmetries, `logDeriv (dirichletCompleted χ) (1 − conj s) = −conj (logDeriv (dirichletCompleted χ) s)`.
This is exactly the `hrefl` input of `routeB_general_of_logDeriv`. -/
theorem logDeriv_dirichletCompleted_reflection {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (s : ℂ) :
    logDeriv (dirichletCompleted χ) (1 - starRingEnd ℂ s)
      = -starRingEnd ℂ (logDeriv (dirichletCompleted χ) s) := by
  rw [logDeriv_dirichletCompleted_one_sub χ hχ hχinv hsign (starRingEnd ℂ s),
    logDeriv_dirichletCompleted_conj χ hreal s]

/-- **The weighted contour bridge.**  For a test function `F` reflecting about the line
`Re s = 1/2` (`F (1 − conj s) = conj (F s)`), the weighted contour integral of the completed
logarithmic derivative is a pure imaginary difference of the three-segment `rightPath`:

    `∮_{∂R} F·Λ_χ'/Λ_χ = rightPath (F·Λ_χ'/Λ_χ) t₀ t₁ − conj (rightPath (F·Λ_χ'/Λ_χ) t₀ t₁)`.

This is `Rh45RouteBAnalytic.rectBoundary_eq_rightPath_sub_conj` applied to the weight, and is the
step that reduces the explicit formula's `2Σ F(ρ)`-count to a single (weighted) edge integral. -/
theorem rectBoundary_F_logDeriv_eq {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (F : ℂ → ℂ) (t0 t1 : ℝ)
    (hF : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    (hint₀ : IntervalIntegrable (fun x : ℝ =>
      F (x + t0 * Complex.I) * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ =>
      F (x + t1 * Complex.I) * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1) :
    rectBoundary (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1
      = rightPath (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1
        - starRingEnd ℂ (rightPath (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1) := by
  have hrefl : ∀ s, (fun s => F s * logDeriv (dirichletCompleted χ) s) (1 - starRingEnd ℂ s)
      = -starRingEnd ℂ ((fun s => F s * logDeriv (dirichletCompleted χ) s) s) := by
    intro s
    simp only
    rw [hF s, logDeriv_dirichletCompleted_reflection χ hχ hχinv hsign hreal s, map_mul]
    ring
  exact rectBoundary_eq_rightPath_sub_conj
    (g := fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1 hrefl hint₀ hint₁

/-- **The weighted explicit formula, zero side, for `dirichletCompleted χ`.**  For a test function
`F` reflecting about `Re s = 1/2`, with `Z` exactly the zeros of `dirichletCompleted χ` in the
rectangle (orders `m`),

    `Im (rightPath (F·Λ_χ'/Λ_χ) t₀ t₁) = π · Re (∑_{z∈Z} m z · F z)`

(`Re` of the complex zero sum; the `Re` is the reflection-cancelled form).  This is the
argument-principle side of the explicit formula, obtained from
`weighted_argument_principle_of_analytic` and the contour bridge. -/
theorem dirichletCompleted_zeroSum {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
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
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (fun s => F s * logDeriv (dirichletCompleted χ) s) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re := by
  set g : ℂ → ℂ := fun s => F s * logDeriv (dirichletCompleted χ) s with hg
  have hrefl : ∀ s, g (1 - starRingEnd ℂ s) = -starRingEnd ℂ (g s) := by
    intro s
    simp only [hg]
    rw [hF s, logDeriv_dirichletCompleted_reflection χ hχ hχinv hsign hreal s, map_mul]
    ring
  have hAP : rectBoundary g t0 t1 = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ) * F z) := by
    rw [hg]
    exact weighted_argument_principle_of_analytic (dirichletCompleted χ) F t0 t1 Z m ht hAn hF_an
      hZ hm hno
  have hsumim : (∑ z ∈ Z, (m z : ℂ) * F z).im = 0 := by
    have hbr := rectBoundary_eq_rightPath_sub_conj g t0 t1 hrefl hint₀ hint₁
    rw [hbr] at hAP
    have hre : (rightPath g t0 t1 - starRingEnd ℂ (rightPath g t0 t1)).re = 0 := by
      rw [Complex.sub_re, Complex.conj_re, sub_self]
    have h := congrArg Complex.re hAP
    rw [hre] at h
    have h2pire : (2 * (Real.pi : ℂ) * Complex.I).re = 0 := by simp
    have h2piim : (2 * (Real.pi : ℂ) * Complex.I).im = 2 * Real.pi := by simp
    rw [Complex.mul_re, h2pire, h2piim] at h
    simp only [zero_mul, zero_sub] at h
    have hpi := Real.pi_pos
    nlinarith [h]
  have hAP' : rectBoundary g t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (((∑ z ∈ Z, (m z : ℂ) * F z).re : ℝ) : ℂ) := by
    rw [hAP]
    congr 1
    apply Complex.ext
    · simp
    · simpa using hsumim
  exact routeB_reduction g t0 t1 hrefl hint₀ hint₁ _ hAP'

end

end RouteABC
