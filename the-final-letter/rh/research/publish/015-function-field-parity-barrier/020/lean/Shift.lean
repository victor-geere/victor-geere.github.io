/-
  Shift.lean — 020 round 113.

  The singular series for the pair (f, f+h) does not depend on the shift when h
  is a nonzero constant: no irreducible polynomial of positive degree divides a
  nonzero constant.  Hence every local factor is (1 - 2/Q)/(1 - 1/Q)^2 and the
  product is h-independent -- even though the finite-n counts are not (they
  depend on the n-th power class of h).
-/
import Mathlib

open Polynomial

namespace Shift

variable {F : Type*} [Field F]

/-- A nonconstant polynomial does not divide a nonzero constant. -/
theorem not_dvd_C {p : F[X]} (hp : 0 < p.natDegree) {h : F} (hh : h ≠ 0) :
    ¬ p ∣ Polynomial.C h := by
  intro hd
  have hne : (Polynomial.C h : F[X]) ≠ 0 := by simpa using hh
  have hle := Polynomial.natDegree_le_of_dvd hd hne
  rw [Polynomial.natDegree_C] at hle
  omega

/-- Consequently the local factor at every prime is the standard one, so the
Euler product for `(f, f+h)` is the same for all `h ≠ 0`. -/
theorem local_factor_uniform {p : F[X]} (hp : 0 < p.natDegree) (h : F) (hh : h ≠ 0) :
    ¬ p ∣ Polynomial.C h := not_dvd_C hp hh

end Shift
