/-
  Gap.lean — round 1 of the new programme (Target C: the ℚ barrier)

  The individual twin count at `h = 2` differs from the average over `h`:
  over `F_7` the six nonzero shifts give `35, 35, 28, 28, 28, 21` (sum `168`),
  so `T(3;7,2) = 35` while the average is `28`.  This is the smallest concrete
  instance of the one-point/two-point gap: the average is the second moment of
  the one-point distribution, the individual is not.
-/
import Cubic

namespace Gap

/-- `6 * T(3;7,2) != sum_h T(3;7,h)`: the individual count is not the average. -/
theorem individual_ne_average :
    6 * CubicSeven.cubicTwin7h 2 ≠
      (Finset.univ.filter (fun h : ZMod 7 => h ≠ 0)).sum CubicSeven.cubicTwin7h := by
  rw [CubicSeven.sum_cubicTwin7]
  have h2 : CubicSeven.cubicTwin7h 2 = 35 := by decide
  rw [h2]
  norm_num

end Gap
