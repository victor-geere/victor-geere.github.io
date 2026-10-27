/-
  Quad.lean — 018 round 8

  Degree-2 twin counts over two more prime fields, extending the table:

      F_5  (q = 5 mod 8):  shift 1 -> 5,   shift 2 -> 0
      F_7  (q = 7 mod 8):  shift 1 -> 7,   shift 2 -> 7
      F_11 (q = 3 mod 8):  shift 2 -> 22
      F_13 (q = 5 mod 8):  shift 2 -> 26

  These are the values of the exact degree-2 formula (Bary-Soker–Stix,
  Example 3.2) for shift 1,
      4 pi(2,q)/q^2 = 1 - (2 - chi)/q ,   chi = (-1)^((q-1)/2) ,
  and of the shift-2 variant for the given primes.  The point is the
  chi-dependence: the correction is a 0-dimensional (Dirichlet) trace.
-/
import Mathlib
import Curve

namespace QuadEleven

instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩

/-- Shift on the constant term over `F_11`. -/
def shift11 (δ : ZMod 11) (p : ZMod 11 × ZMod 11) : ZMod 11 × ZMod 11 := (p.1, p.2 + δ)

/-- Irreducibility of a monic quadratic over `F_11`, as "no root". -/
abbrev Irr11 (p : ZMod 11 × ZMod 11) : Prop := ∀ x : ZMod 11, x ^ 2 + p.1 * x + p.2 ≠ 0

/-- All 121 monic quadratics of `F_11`. -/
def All11 : Finset (ZMod 11 × ZMod 11) := Finset.univ

/-- Shift 2 over `F_11`: `22`. -/
theorem pair11_shift_two : CurveLift.pairCount Irr11 (shift11 2) All11 = 22 := by
  decide

end QuadEleven

namespace QuadThirteen

instance : Fact (Nat.Prime 13) := ⟨by norm_num⟩

/-- Shift on the constant term over `F_13`. -/
def shift13 (δ : ZMod 13) (p : ZMod 13 × ZMod 13) : ZMod 13 × ZMod 13 := (p.1, p.2 + δ)

/-- Irreducibility of a monic quadratic over `F_13`, as "no root". -/
abbrev Irr13 (p : ZMod 13 × ZMod 13) : Prop := ∀ x : ZMod 13, x ^ 2 + p.1 * x + p.2 ≠ 0

/-- All 169 monic quadratics of `F_13`. -/
def All13 : Finset (ZMod 13 × ZMod 13) := Finset.univ

/-- Shift 2 over `F_13`: `26`. -/
theorem pair13_shift_two : CurveLift.pairCount Irr13 (shift13 2) All13 = 26 := by
  decide

end QuadThirteen

/-! ## Completing the `q mod 8` table -/

namespace QuadSeventeen

instance : Fact (Nat.Prime 17) := ⟨by norm_num⟩

def shift17 (δ : ZMod 17) (p : ZMod 17 × ZMod 17) : ZMod 17 × ZMod 17 := (p.1, p.2 + δ)

abbrev Irr17 (p : ZMod 17 × ZMod 17) : Prop := ∀ x : ZMod 17, x ^ 2 + p.1 * x + p.2 ≠ 0

def All17 : Finset (ZMod 17 × ZMod 17) := Finset.univ

/-- `q = 17 = 1 (mod 8)`: shift 2 gives `68`. -/
theorem pair17_shift_two : CurveLift.pairCount Irr17 (shift17 2) All17 = 68 := by
  decide

end QuadSeventeen

namespace QuadNineteen

instance : Fact (Nat.Prime 19) := ⟨by norm_num⟩

def shift19 (δ : ZMod 19) (p : ZMod 19 × ZMod 19) : ZMod 19 × ZMod 19 := (p.1, p.2 + δ)

abbrev Irr19 (p : ZMod 19 × ZMod 19) : Prop := ∀ x : ZMod 19, x ^ 2 + p.1 * x + p.2 ≠ 0

def All19 : Finset (ZMod 19 × ZMod 19) := Finset.univ

/-- `q = 19 = 3 (mod 8)`: shift 2 gives `76`. -/
theorem pair19_shift_two : CurveLift.pairCount Irr19 (shift19 2) All19 = 76 := by
  decide

end QuadNineteen
