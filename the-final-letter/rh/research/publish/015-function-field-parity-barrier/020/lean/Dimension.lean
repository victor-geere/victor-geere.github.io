/-
  Dimension.lean — 020 round 118.

  The local factor of a `k`-condition sieve is `2^k`: the count of residue
  `k`-tuples with `a_i (a_i + h) = 0` in every coordinate.  For `k = 1` this is
  the parity factor 2 (qrimes), for `k = 2` the factor 4 (twins).
-/
import Mathlib
import SieveLocal

open Finset

namespace Dimension

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- The `k`-dimensional local factor is `2^k`. -/
theorem card_roots_fun {k : ℕ} {h : F} (hh : h ≠ 0) :
    Fintype.card {v : Fin k → F // ∀ i, v i * (v i + h) = 0} = 2 ^ k := by
  have hfib : Fintype.card {b : F // b = 0 ∨ b + h = 0} = 2 := by
    rw [Fintype.card_subtype]
    have hset : (univ.filter (fun b : F => b = 0 ∨ b + h = 0)) = ({0, -h} : Finset F) := by
      ext b
      simp [eq_neg_iff_add_eq_zero]
    rw [hset]
    exact Finset.card_pair (Ne.symm (neg_ne_zero.mpr hh))
  rw [Fintype.card_congr (Equiv.subtypePiEquivPi (p := fun _ a => a * (a + h) = 0))]
  rw [Fintype.card_pi]
  simp [hfib]

end Dimension
