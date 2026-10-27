/-
  Barrier.lean — 018 round 5

  Two finite facts behind the parity barrier.

  1. **No Euler product.**  The twin indicator `n ↦ [n, n+2 both prime]` is not
     multiplicative.  This is the arithmetic reason the twin count is not a
     zeta coefficient: `ζ` is an Euler product, and the twin indicator has none
     (cf. the dictionary's F3/F8).

  2. **The linear bound is trivial.**  For any world `S` and shift `τ`, the twin
     count is at most `|S|`.  The truth is `T(n) ~ S(q)·I(n)/n`, a factor `n`
     below this bound; the parity barrier is the statement that no linear
     (zeta-type) method closes that factor.
-/
import Mathlib
import Separation

namespace Barrier

/-- A plain multiplicativity predicate on `ℕ → ℕ`. -/
def IsMult (f : ℕ → ℕ) : Prop :=
  ∀ m n : ℕ, Nat.Coprime m n → f (m * n) = f m * f n

/-- The twin indicator: `1` if `n` and `n + 2` are both prime, else `0`. -/
def twinInd (n : ℕ) : ℕ := if n.Prime ∧ (n + 2).Prime then 1 else 0

/-- **No Euler product.**  `twinInd 3 = twinInd 5 = 1` but `twinInd 15 = 0`,
while `gcd(3,5) = 1`.  So the twin indicator is not multiplicative and the
associated Dirichlet series has no Euler product. -/
theorem twinInd_not_mult : ¬ IsMult twinInd := by
  intro h
  have h35 : twinInd (3 * 5) = twinInd 3 * twinInd 5 := h 3 5 (by decide)
  norm_num [twinInd] at h35

/-- **The linear bound is trivial.**  The twin count of a world is at most its
cardinality; the asymptotic is a factor `n` smaller. -/
theorem twinCount_le_card {α : Type*} [DecidableEq α] (τ : α → α) (S : Finset α) :
    Separation.twinCount τ S ≤ S.card := by
  unfold Separation.twinCount
  exact Finset.card_filter_le _ _

end Barrier
