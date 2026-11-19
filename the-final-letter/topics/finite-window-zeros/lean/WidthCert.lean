import Wide
import Width
import EMBox14

/-!
# Width certification for segment boxes

The segment certificates use `Cx.width`, the `ℓ∞` coordinate width.  This file
records the exact width of every segment box and a first width-to-radius bound.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-- The coordinate width of a height-5 segment box. -/
theorem width_segBox {a b : ℚ} (h : a ≤ b) : (segBox a b).width = b - a := by
  unfold Cx.width segBox
  rw [show (1 / 2 : ℚ) - 1 / 2 = 0 by norm_num]
  exact max_eq_right (by linarith)

/-- The certified boxes all have width `3/1000000`. -/
theorem width_S1 : S1.width = (3 / 1000000 : ℚ) := by
  rw [S1, width_segBox (by norm_num : (5000003 / 1000000 : ℚ) ≤ 5000006 / 1000000)]; norm_num

theorem width_S11 : S11.width = (3 / 1000000 : ℚ) := by
  rw [S11, width_segBox (by norm_num : (5000033 / 1000000 : ℚ) ≤ 5000036 / 1000000)]; norm_num

/-- The width of the whole certified segment is `36/1000000`. -/
theorem width_segment : (segBox (5 : ℚ) (5000036 / 1000000)).width
    = (36 / 1000000 : ℚ) := by
  rw [width_segBox (by norm_num : (5 : ℚ) ≤ 5000036 / 1000000)]; norm_num


/-- **The actual zeta-box width.**  The folded enclosure `Bzeta` of
`zetaEMGen 1 20 s14` has coordinate width at most `1/2`. -/
theorem width_Bzeta_le_half : Bzeta.width ≤ (1 / 2 : ℚ) := by
  native_decide

end FiniteWindowZeros
