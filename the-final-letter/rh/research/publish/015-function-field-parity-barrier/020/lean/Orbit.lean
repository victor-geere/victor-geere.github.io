/-
  Orbit.lean — 020 round 116.

  The `h ~ -h` symmetry acts with orbits of size two on nonzero shifts in odd
  characteristic.  Together with the scaling law `h ~ a^n h` (018) this gives
  the complete orbit law observed in round 113/116.
-/
import Mathlib

namespace Orbit

variable {F : Type*} [Field F] [DecidableEq F]

/-- In odd characteristic, a nonzero element is not its own negative. -/
theorem ne_neg_self (h2 : (2 : F) ≠ 0) {h : F} (hh : h ≠ 0) : h ≠ -h := by
  intro he
  have hsum : h + h = 0 := eq_neg_iff_add_eq_zero.mp he
  have hmul : (2 : F) * h = 0 := by rw [two_mul]; exact hsum
  have hzero : h = 0 := by
    rcases mul_eq_zero.mp hmul with h' | h'
    · exact absurd h' h2
    · exact h'
  exact hh hzero

/-- Hence the two-element orbit `{h, -h}` is genuine for `h ≠ 0`. -/
theorem card_orbit (h2 : (2 : F) ≠ 0) {h : F} (hh : h ≠ 0) :
    ({h, -h} : Finset F).card = 2 :=
  Finset.card_pair (ne_neg_self h2 hh)

end Orbit
