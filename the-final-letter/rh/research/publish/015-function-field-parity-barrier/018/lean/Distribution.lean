/-
  Distribution.lean — 018 round 13

  The constant-shift distribution at degree 2: for every `b`, exactly
  `(q-1)/2` of the quadratics `x^2 + b x + c` are irreducible.  This is the
  uniform base case of the distribution whose second moment is the shift
  average.

  Finite checks over `F_5, F_7, F_11, F_13`; the general statement (as `c`
  varies, `b^2 - 4c` runs over all of `F_q`) is left as a comment.
-/
import Mathlib

namespace QuadDistribution

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩
instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩
instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩
instance : Fact (Nat.Prime 13) := ⟨by norm_num⟩

/-- Over `F_5`, every constant-shift family of quadratics has `2` irreducibles. -/
theorem d2_five :
    ∀ b : ZMod 5,
      (Finset.univ.filter (fun c : ZMod 5 => ∀ x : ZMod 5, x ^ 2 + b * x + c ≠ 0)).card = 2 := by
  decide

/-- Over `F_7`: `3` irreducibles per family. -/
theorem d2_seven :
    ∀ b : ZMod 7,
      (Finset.univ.filter (fun c : ZMod 7 => ∀ x : ZMod 7, x ^ 2 + b * x + c ≠ 0)).card = 3 := by
  decide

/-- Over `F_11`: `5` irreducibles per family. -/
theorem d2_eleven :
    ∀ b : ZMod 11,
      (Finset.univ.filter (fun c : ZMod 11 => ∀ x : ZMod 11, x ^ 2 + b * x + c ≠ 0)).card = 5 := by
  decide

/-- Over `F_13`: `6` irreducibles per family. -/
theorem d2_thirteen :
    ∀ b : ZMod 13,
      (Finset.univ.filter (fun c : ZMod 13 => ∀ x : ZMod 13, x ^ 2 + b * x + c ≠ 0)).card = 6 := by
  decide

end QuadDistribution

/-! ## The degree-3 constant-family distribution over `F₅` -/

namespace CubicDistribution

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- Number of `c` for which `x³ + a x² + b x + c` is irreducible over `F₅`. -/
def cubicFamCount5 (a b : ZMod 5) : ℕ :=
  (Finset.univ.filter (fun c : ZMod 5 =>
    ∀ x : ZMod 5, x ^ 3 + a * x ^ 2 + b * x + c ≠ 0)).card

/-- The distribution is `I = 0` on 5 families and `I = 2` on 20 families. -/
theorem cubic_fam_dist_five :
    (Finset.univ.filter (fun p : ZMod 5 × ZMod 5 =>
        cubicFamCount5 p.1 p.2 = 0)).card = 5 ∧
    (Finset.univ.filter (fun p : ZMod 5 × ZMod 5 =>
        cubicFamCount5 p.1 p.2 = 2)).card = 20 := by
  decide

/-- Second moment: `Σ I(I−1) = 40`, the degree-3 shift average at `q = 5`. -/
theorem sum_cubic_fam_five :
    (Finset.univ.sum (fun p : ZMod 5 × ZMod 5 =>
      cubicFamCount5 p.1 p.2 * (cubicFamCount5 p.1 p.2 - 1))) = 40 := by
  decide

end CubicDistribution

namespace CubicDistributionSeven

instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩

/-- Number of `c` for which `x³ + a x² + b x + c` is irreducible over `F₇`. -/
def cubicFamCount7 (a b : ZMod 7) : ℕ :=
  (Finset.univ.filter (fun c : ZMod 7 =>
    ∀ x : ZMod 7, x ^ 3 + a * x ^ 2 + b * x + c ≠ 0)).card

/-- At `q = 7` the distribution is `I = 2` on 42 families and `I = 4` on 7.
In particular `max I = 4 > (q−1)/2 = 3`: the `d=4` "cap" does **not** extend
to `d = 3`. -/
theorem cubic_fam_dist_seven :
    (Finset.univ.filter (fun p : ZMod 7 × ZMod 7 =>
        cubicFamCount7 p.1 p.2 = 2)).card = 42 ∧
    (Finset.univ.filter (fun p : ZMod 7 × ZMod 7 =>
        cubicFamCount7 p.1 p.2 = 4)).card = 7 := by
  decide

end CubicDistributionSeven
