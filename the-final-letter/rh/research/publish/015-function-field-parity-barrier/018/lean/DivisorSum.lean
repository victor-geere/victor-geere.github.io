/-
  DivisorSum.lean — round 16 of the new programme (Target C)

  The parity barrier, one algebraic step: a **divisor sum** `ζ * g` with
  multiplicative `g` is multiplicative.  The twin indicator is not, so it is not
  such a divisor sum — no multiplicative sieve weight equals it.
-/
import Mathlib
import Barrier

open ArithmeticFunction

namespace DivisorSum

/-- The twin indicator as an arithmetic function. -/
def twinIndAF : ArithmeticFunction ℕ where
  toFun := Barrier.twinInd
  map_zero' := by decide

/-- A divisor sum `ζ * g` is multiplicative when `g` is. -/
theorem zeta_mul_isMult {g : ArithmeticFunction ℕ} (hg : g.IsMultiplicative) :
    (zeta * g).IsMultiplicative := isMultiplicative_zeta.mul hg

/-- The twin indicator is **not** a divisor sum of a multiplicative function. -/
theorem twinInd_not_zeta_mul {g : ArithmeticFunction ℕ} (hg : g.IsMultiplicative) :
    twinIndAF ≠ zeta * g := by
  intro h
  have hmult : twinIndAF.IsMultiplicative := by
    rw [h]
    exact zeta_mul_isMult hg
  have h35 := hmult.map_mul_of_coprime (by decide : Nat.Coprime 3 5)
  norm_num [twinIndAF, Barrier.twinInd] at h35

end DivisorSum
