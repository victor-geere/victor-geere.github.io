/-
  Scale.lean — round 4 of the new programme (Target A)

  The scaling `f(X) ↦ f(cX)` (c ≠ 0) preserves irreducibility.  This is the
  algebraic core of the `a2`-independence in the even slice: `x ↦ cx` maps
  `x^4 + a2 x^2` to `x^4 + (a2/c^2) x^2`, so the count depends only on the
  scaling class of `a2`.
-/
import Mathlib

open Polynomial

namespace Scale

/-- `f(X) ↦ f(cX)` preserves irreducibility (over a field, `c ≠ 0`). -/
theorem irreducible_scale {K : Type*} [Field K] (c : K) (hc : c ≠ 0) (f : K[X]) :
    Irreducible (f.comp (C c * X)) ↔ Irreducible f := by
  haveI : Invertible c := invertibleOfNonzero hc
  have h : algEquivCMulXAddC c 0 f = f.comp (C c * X) := by
    simp [algEquivCMulXAddC_apply, add_zero, comp_eq_aeval]
  rw [← h]
  exact MulEquiv.irreducible_iff (algEquivCMulXAddC c 0).toMulEquiv

end Scale
