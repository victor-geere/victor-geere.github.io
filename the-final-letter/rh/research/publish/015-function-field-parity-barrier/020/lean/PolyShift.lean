/-
  PolyShift.lean — 020 round 121.

  Local factors for polynomial shifts.  When the shift `h` vanishes at a prime
  `Q` (i.e. `Q | h`), the two conditions `f ≢ 0` and `f + h ≢ 0` coincide, so
  the admissible residue count is `Q - 1` instead of `Q - 2`.  This is the
  `(Q-1)/(Q-2)` correction verified numerically in round 121.
-/
import Mathlib
import SieveLocal

open Finset

namespace PolyShift

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- Degenerate local factor: avoiding only `0` leaves `|F| - 1` residues. -/
theorem card_nonzero :
    (univ.filter (fun a : F => a ≠ 0)).card = Fintype.card F - 1 := by
  have hset : (univ.filter (fun a : F => a ≠ 0)) = univ \ ({0} : Finset F) := by
    ext a
    simp
  rw [hset, card_sdiff]
  simp

/-- The two counts differ by exactly one: `(Q-1) - (Q-2) = 1`, which is the
source of the local factor ratio `(Q-1)/(Q-2)`. -/
theorem factor_gap (Q : ℕ) (hQ : 2 ≤ Q) :
    (Q - 1) - (Q - 2) = 1 := by
  omega

end PolyShift

namespace PolyShift

/-- The correction ratio `(Q-1)/(Q-2)` is strictly bigger than one: a polynomial
shift with prime factors *raises* the singular series, which is why its twin
counts are larger. -/
theorem ratio_gt_one (Q : ℕ) (hQ : 2 < Q) :
    (1 : ℚ) < ((Q : ℚ) - 1) / ((Q : ℚ) - 2) := by
  have h2 : (2 : ℚ) < (Q : ℚ) := by exact_mod_cast hQ
  have hpos : (0 : ℚ) < (Q : ℚ) - 2 := by linarith
  have h : ((Q : ℚ) - 1) / ((Q : ℚ) - 2) = 1 + 1 / ((Q : ℚ) - 2) := by
    field_simp
    ring
  rw [h]
  have hpos1 : (0 : ℚ) < 1 / ((Q : ℚ) - 2) := by positivity
  linarith

end PolyShift

namespace PolyShift

/-- The ratio of the two local factors is exactly `(Q-1)/(Q-2)`. -/
theorem local_factor_ratio (Q : ℚ) (hQ : 2 < Q) :
    (1 / (1 - 1 / Q)) / ((1 - 2 / Q) / (1 - 1 / Q) ^ 2) = (Q - 1) / (Q - 2) := by
  have hQ0 : Q ≠ 0 := by linarith
  have h1 : (1 : ℚ) - 1 / Q ≠ 0 := by
    have : (1 : ℚ) / Q < 1 := by
      rw [div_lt_one (by linarith : (0:ℚ) < Q)]
      linarith
    linarith
  have h2 : (1 : ℚ) - 2 / Q ≠ 0 := by
    have : (2 : ℚ) / Q < 1 := by
      rw [div_lt_one (by linarith : (0:ℚ) < Q)]
      linarith
    linarith
  field_simp

end PolyShift
