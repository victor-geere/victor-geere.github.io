import Mathlib

/-!
# QEFE research notes — finite Egyptian/fractional core

This file reconstructs the only part of the QEFE *working notes*
(`archive/quantum-egyptian-functional-equation/research-deepseek-8.md`)
that is both finite and unconditional: the arithmetic of the Egyptian
denominators `m_i = D² / d_i²` and the unit-fraction mass they carry.

The general Quantum–Egyptian functional equation is **not** formalised
here. The archived derivation has a documented gap (the notes reproduce
the first half of a Mellin split and then change normalisation by hand),
and the primary reconstruction lives in the duplicate topic
`../qefe/`. The facts below are the adapted finite core, not a second
proof of Theorem 3.1.
-/

noncomputable section

namespace QEFENotes

/-- The Egyptian denominator `m = D² / d²` attached to an object of
squared quantum dimension `d²`. -/
def egyptianDenom (D2 d2 : ℚ) : ℚ := D2 / d2

/-- The unit-fraction mass `1/m` carried by one Egyptian denominator. -/
def unitFraction (m : ℚ) : ℚ := 1 / m

/-- The non-unit Egyptian mass `1 - 1/D²` of Lemma 2.2. -/
def nonunitMass (D2 : ℚ) : ℚ := 1 - 1 / D2

/-- Every Egyptian denominator is at least `1`: the partition
`Σ d_i² = D²` forces `d_i² ≤ D²`, and the dimensions are positive. -/
theorem egyptianDenom_one_le {D2 d2 : ℚ} (hd : 0 < d2) (hle : d2 ≤ D2) :
    1 ≤ egyptianDenom D2 d2 := by
  unfold egyptianDenom
  rw [le_div_iff₀ hd]
  linarith

/-- Each unit fraction is positive. -/
theorem unitFraction_pos {m : ℚ} (hm : 0 < m) : 0 < unitFraction m := by
  unfold unitFraction
  positivity

/-- Larger Egyptian denominators carry strictly less unit-fraction mass:
`1/b < 1/a` for `0 < a < b`. This is the monotonicity behind the notes'
observation that a growing total dimension gives better approximations
of `1` by the non-unit Egyptian fractions. -/
theorem unitFraction_strictAnti {a b : ℚ} (ha : 0 < a) (hab : a < b) :
    unitFraction b < unitFraction a := by
  unfold unitFraction
  exact one_div_lt_one_div_of_lt ha hab

/-- Once the total squared dimension exceeds `1`, the non-unit Egyptian
mass `1 - 1/D²` is positive. -/
theorem nonunitMass_pos {D2 : ℚ} (h : 1 < D2) : 0 < nonunitMass D2 := by
  unfold nonunitMass
  have h0 : 0 < D2 := by linarith
  rw [sub_pos, div_lt_one h0]
  exact h

/-- The non-unit Egyptian mass is strictly below `1`: a finite integral
category always leaves the unit object's share `1/D²` outside the
non-unit sum. -/
theorem nonunitMass_lt_one {D2 : ℚ} (h : 0 < D2) : nonunitMass D2 < 1 := by
  unfold nonunitMass
  have h1 : 0 < 1 / D2 := by positivity
  linarith

/-- On the range `D² > 1`, the non-unit Egyptian mass is strictly
increasing in `D²`: larger total dimension gives a better Egyptian
approximation of `1`. -/
theorem nonunitMass_strictMono : StrictMonoOn nonunitMass (Set.Ioi 1) := by
  intro a ha b hb hab
  simp only [Set.mem_Ioi] at ha hb
  unfold nonunitMass
  have ha0 : 0 < a := by linarith
  have h1 : 1 / b < 1 / a := one_div_lt_one_div_of_lt ha0 hab
  linarith

/-- Lemma 2.2 on the Ising example: the non-unit denominators `2` and `4`
carry exactly the non-unit mass `1 - 1/4`. -/
theorem ising_nonunit_identity :
    unitFraction 2 + unitFraction 4 = nonunitMass 4 := by
  unfold unitFraction nonunitMass
  norm_num

end QEFENotes
