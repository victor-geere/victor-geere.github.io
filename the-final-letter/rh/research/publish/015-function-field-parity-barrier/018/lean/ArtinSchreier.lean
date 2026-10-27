/-
  ArtinSchreier.lean — 018 round 15

  The value-set collapse behind the `d = 5` failure of the sieve-union bound:
  over `F_5`, `x^5 - x = 0` for every `x` (Fermat), so the constant family
  `x^5 - x + b` has value `b` at every point.  Hence for `b != 0` it has no
  root, and `|Im(x^5 - x)| = 1`.
-/
import Mathlib

namespace ArtinSchreier

/-- Fermat over `F_5`: every element satisfies `x^5 = x`. -/
theorem pow_five_eq_self : ∀ x : ZMod 5, x ^ 5 = x := by
  decide

/-- The Artin-Schreier family evaluates to `b` at every point. -/
theorem eval_artin_schreier (b x : ZMod 5) :
    x ^ 5 - x + b = b := by
  rw [pow_five_eq_self x]
  ring

/-- For `b != 0`, `x^5 - x + b` has no root. -/
theorem artin_schreier_no_root (b : ZMod 5) (hb : b ≠ 0) (x : ZMod 5) :
    x ^ 5 - x + b ≠ 0 := by
  rw [eval_artin_schreier b x]
  exact hb



/-- The derivative of `x^5 - x` is the nonzero constant `-1` in `F_5`, so
`x^5 - x` is squarefree.  The value-set collapse is *not* a multiple-root
phenomenon: it is because the degree equals the field size and the polynomial
is the product of all linear factors. -/
theorem derivative_X_pow_five_sub_X :
    Polynomial.derivative (Polynomial.X ^ 5 - Polynomial.X : Polynomial (ZMod 5)) = -1 := by
  have h5 : (5 : ZMod 5) = 0 := by decide
  simp [Polynomial.derivative_pow, Polynomial.derivative_X, h5]

end ArtinSchreier
