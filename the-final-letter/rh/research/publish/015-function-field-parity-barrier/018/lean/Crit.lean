/-
  Crit.lean — round 12 of the new programme (Target A)

  A quartic has at most three critical points: `g'` is a cubic.
-/
import Mathlib
import DerivativeQ

open Polynomial

namespace Crit

/-- The critical points of `x^4 + a2 x^2 + a1 x` number at most three. -/
theorem crit_le_three {K : Type*} [Field K] (a2 a1 : K) :
    (derivative (X ^ 4 + C a2 * X ^ 2 + C a1 * X : K[X])).roots.card ≤ 3 := by
  calc (derivative (X ^ 4 + C a2 * X ^ 2 + C a1 * X : K[X])).roots.card
      ≤ (derivative (X ^ 4 + C a2 * X ^ 2 + C a1 * X : K[X])).natDegree :=
        Polynomial.card_roots' _
    _ ≤ 3 := by
        rw [DerivativeQ.deriv_quartic]
        compute_degree

end Crit
