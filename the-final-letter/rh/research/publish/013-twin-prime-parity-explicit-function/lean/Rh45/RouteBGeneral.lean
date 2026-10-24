/-
  Rh45/RouteBGeneral.lean — Route B with the zero count *derived*, not assumed.

  `Rh45/ArgumentPrinciple.lean`'s `routeB_reduction_factorized` still took a
  factorisation hypothesis `f =ᶠ C · ∏ (s − z)^(m z)` (with `C` a constant) in order
  to produce the argument-principle input `hAP`.  `Rh45/Weierstrass.lean` removed that
  hypothesis: `argument_principle_general` proves
  `∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z` from analyticity of `f` plus the zero data alone,
  building the zero-free factor `g` with `f = g · ∏ (s − z)^(m z)`.

  This module feeds that into the Route B reduction.  The result,

      (rightPath (logDeriv f) t₀ t₁).im = π · ∑_{z∈Z} m z,

  is Route B's conclusion with **no factorisation hypothesis and no constant `C`**: the
  only analytic inputs are that `f` is analytic on the closed rectangle, that its zeros
  there are exactly the points of `Z` (each strictly inside) with orders `m`, and the two
  structural identities `f(1 − s) = f(s)`, `f(conj s) = conj (f s)`.
-/
import Rh45.Weierstrass

open MeasureTheory intervalIntegral
open scoped Topology
open scoped ComplexConjugate

namespace Rh45RouteBAnalytic

noncomputable section

/-- **Route B, general form.**  If `f` is analytic on the closed rectangle
`[0,1] × [t₀,t₁]` (`t₀ < t₁`), its only zeros in that rectangle are the points of the
finite set `Z`, each strictly inside and of vanishing order `m`, and `f` satisfies the
functional equation and reality `f(1 − s) = f(s)`, `f(conj s) = conj (f s)`, then

`(rightPath (logDeriv f) t₀ t₁).im = π · ∑_{z∈Z} m z`,

i.e. `N = Im(I₃)/π` with the zero count no longer an assumption and **no factorisation
hypothesis** — the zero-free factor is produced internally by `exists_factorization`. -/
theorem routeB_reduction_general (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ f s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → f u ≠ 0)
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv f) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  have hAP : rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (((∑ z ∈ Z, (m z : ℝ)) : ℝ) : ℂ) := by
    have hcast : (((∑ z ∈ Z, (m z : ℝ)) : ℝ) : ℂ) = ∑ z ∈ Z, (m z : ℂ) := by
      rw [Complex.ofReal_sum]
      exact Finset.sum_congr rfl fun z _ => by simp
    rw [hcast]
    exact argument_principle_general f t0 t1 Z m ht han hmem hm hno
  exact routeB_reduction_of_functional_equation f t0 t1 h1 h2 hint₀ hint₁
    (∑ z ∈ Z, (m z : ℝ)) hAP

end

end Rh45RouteBAnalytic
