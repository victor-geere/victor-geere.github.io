/-
  SmallCap.lean — round 17-18 of the new programme (Target A)

  The finite base of the Chebotarev route: for `q = 5,7,11,13,17,19,23`, every
  quartic `x^4 + a2 x^2 + a1 x` with `a1 != 0` has a value set of size at least
  `(q+1)/2`.  All seven are `decide` theorems on `Finset.image`.
-/
import Mathlib

namespace SmallCap

open ZMod

theorem cap_five :
    ∀ a2 a1 : ZMod 5, a1 ≠ 0 →
      3 ≤ (Finset.univ.image (fun x : ZMod 5 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_seven :
    ∀ a2 a1 : ZMod 7, a1 ≠ 0 →
      4 ≤ (Finset.univ.image (fun x : ZMod 7 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_eleven :
    ∀ a2 a1 : ZMod 11, a1 ≠ 0 →
      6 ≤ (Finset.univ.image (fun x : ZMod 11 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_thirteen :
    ∀ a2 a1 : ZMod 13, a1 ≠ 0 →
      7 ≤ (Finset.univ.image (fun x : ZMod 13 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_seventeen :
    ∀ a2 a1 : ZMod 17, a1 ≠ 0 →
      9 ≤ (Finset.univ.image (fun x : ZMod 17 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_nineteen :
    ∀ a2 a1 : ZMod 19, a1 ≠ 0 →
      10 ≤ (Finset.univ.image (fun x : ZMod 19 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

theorem cap_twentythree :
    ∀ a2 a1 : ZMod 23, a1 ≠ 0 →
      12 ≤ (Finset.univ.image (fun x : ZMod 23 => x ^ 4 + a2 * x ^ 2 + a1 * x)).card := by
  decide

end SmallCap
