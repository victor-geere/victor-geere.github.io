/-
  CertifiedWindow.lean — the Route-B zero-data obligation, named as one structure.

  `routeB_for_dirichletL_of_zeros` (and its `chi3` instance in `DirichletL.lean`) takes the
  numerical zero data as three separate hypotheses: a finite set `Z`, its orders `m`, and
  zero-freeness off `Z` on the rectangle `[0,1] × [t0,t1]`.  This file bundles them into
  `CertifiedWindow`, so the exact remaining obligation is a single object, and derives the
  Route-B conclusion from it.

  **What is not formalised here.**  Producing a `CertifiedWindow` for a concrete window is a
  *numerical* statement: it is what `011/rigorous/certify_dirichlet_routeB.py` certifies
  computationally for `chi3` on `(1/2, 10)` (count `N = 1` by rigorous argument tracking plus
  one certified on-line simple zero; see `../verify/certify_dirichlet_routeB_chi3.log` and
  `../rigorous/certify_dirichlet_routeB_chi_3_T10.json`).  Formalising that certificate in Lean
  would require a verified numerical evaluator for `dirichletCompleted chi3` on the critical
  line (interval arithmetic plus a tail bound for the Dirichlet series / Hurwitz-zeta
  representation) and a formalised argument-principle count; neither exists in Mathlib, and
  building them is out of scope for this round.  The computational certificate is therefore the
  substantive input, and this file is the precise interface it must inhabit.

  Contrast with the parts that *are* formalised: the character theory (`chi3_isPrimitive`,
  `chi3_isQuadratic`, `chi3_ne_one`), the functional equation and reality
  (`dirichletCompleted_selfDual`, `dirichletCompleted_conj`), the analyticity and interval
  integrability (`DirichletAnalytic.lean`), the argument-principle reduction
  (`routeB_reduction_general`), and the combinatorial Turing step
  (`Rh45Routes.turing_reduction` / `all_zeros_are_certified`).
-/
import DirichletL

open MeasureTheory intervalIntegral
open scoped Topology ComplexConjugate
open DirichletCharacter
open Rh45RouteBAnalytic

namespace RouteABC

/-- **The Route-B zero-data obligation.**  A finite zero set `Z` inside the rectangle
`[0,1] × [t0,t1]`, its orders `m`, and zero-freeness off `Z`.  Supplying one is exactly the
numerical certificate; consuming it closes Route B. -/
structure CertifiedWindow {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (t0 t1 : ℝ) where
  Z : Finset ℂ
  m : ℂ → ℕ
  hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1
  hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z
  hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
    u ∉ Z → dirichletCompleted χ u ≠ 0

/-- Route B from a certified window: the logarithmic-derivative contour integral counts the
window zeros.  All analytic hypotheses are discharged by `DirichletAnalytic.lean`. -/
theorem CertifiedWindow.routeB {N : ℕ} [NeZero N] {χ : DirichletCharacter ℂ N}
    {t0 t1 : ℝ} (W : CertifiedWindow χ t0 t1)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic)
    (ht : t0 < t1) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ W.Z, (W.m z : ℝ)) :=
  routeB_for_dirichletL_of_zeros χ t0 t1 W.Z W.m
    hχ hχinv hχ1 hχ2 ht W.hmem W.hm W.hno

/-- **Route B for χ₃ on the certified window `(1/2, 10)`**, conditional only on the numerical
window `W`.  The numerics supply five disjoint facts for this window in
`011/rigorous/certify_dirichlet_routeB_chi_3_T10.json` (one zero, order 1, no others); they are
not formalised here — see the file header. -/
theorem routeB_for_chi3_of_window (W : CertifiedWindow chi3 (1 / 2) 10) :
    (rightPath (logDeriv (dirichletCompleted chi3)) (1 / 2) 10).im
      = Real.pi * (∑ z ∈ W.Z, (W.m z : ℝ)) :=
  W.routeB chi3_isPrimitive chi3_isQuadratic.inv chi3_ne_one chi3_isQuadratic
    (by norm_num)

end RouteABC
