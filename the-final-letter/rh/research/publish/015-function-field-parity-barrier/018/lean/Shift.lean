/-
  Shift.lean — round 2 of the new programme (Target A)

  The translation `f(X) ↦ f(X + t)` preserves irreducibility: it is the
  algebra automorphism `algEquivAevalXAddC t` of `R[X]`.
-/
import Mathlib

open Polynomial

namespace Shift

/-- `f(X) ↦ f(X + t)` preserves irreducibility. -/
theorem irreducible_shift {R : Type*} [CommRing R] (t : R) (f : R[X]) :
    Irreducible (f.comp (X + C t)) ↔ Irreducible f := by
  have h : algEquivAevalXAddC t f = f.comp (X + C t) := by
    simp [comp_eq_aeval]
  rw [← h]
  exact MulEquiv.irreducible_iff (algEquivAevalXAddC t).toMulEquiv

end Shift
