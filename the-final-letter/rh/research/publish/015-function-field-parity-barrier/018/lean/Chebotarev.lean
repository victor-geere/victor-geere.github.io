/-
  Chebotarev.lean — round 14 of the new programme (Target A)

  The Chebotarev route to (V'): if the value set is `5q/8 - O(sqrt q)` and the
  error `C sqrt q` is smaller than the margin `q/8 - 1/2`, then
  `|Im| > (q+1)/2`.

  We record (a) the rational `S4` densities and (b) the elementary implication
  from the main-term bound to the cap.
-/
import Mathlib

namespace Chebotarev

/-- The `S4` splitting-type densities sum to one. -/
theorem s4_density : (3 / 8 : ℚ) + 1 / 3 + 1 / 4 + 1 / 24 = 1 := by norm_num

/-- The `S4` value-set ratio is `5/8`. -/
theorem s4_ratio : (1 : ℚ) - 3 / 8 = 5 / 8 := by norm_num

/-- The margin over the cap is `1/8`. -/
theorem s4_margin : (5 / 8 : ℚ) - 1 / 2 = 1 / 8 := by norm_num

/-- Main term + error bound ⇒ value-set bound:
if `m ≥ 5q/8 - C√q` and `C√q + 1/2 < q/8`, then `(q+1)/2 < m`. -/
theorem cap_from_main_term {q m C : ℝ} (hm : 5 * q / 8 - C * Real.sqrt q ≤ m)
    (h : C * Real.sqrt q + 1 / 2 < q / 8) : (q + 1) / 2 < m := by
  linarith

/-- At `q = 25` the main term clears the cap: `5·25/8 − 5/2 = 105/8 > 13`. -/
theorem threshold_25 : (5 * 25 / 8 : ℚ) - 1 / 2 * 5 = 105 / 8 := by norm_num

/-- `105/8 > (25+1)/2 = 13`. -/
theorem threshold_25_gt : (105 / 8 : ℚ) > (25 + 1) / 2 := by norm_num

end Chebotarev
