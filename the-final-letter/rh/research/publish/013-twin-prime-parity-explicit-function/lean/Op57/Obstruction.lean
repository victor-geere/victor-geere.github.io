/-
  Op57/Obstruction.lean — non-principal characters can destroy the threshold.

  In OP-5 the leading equation is `F_0(x) = x/(1−x) = 1`; because `F_0 → +∞`
  as `x → 1⁻`, a leading root is *always* present.  That is a property of the
  trivial coefficient `c ≡ 1` (positive mean over the period).

  For a non-principal Dirichlet character the coefficient has **zero mean** over
  its period, and the regrouped `F_r(x) = f_r(x)/(1−x^q)` is *bounded* on
  `[0,1]`.  Here we prove that for the two smallest real non-principal
  characters, `χ₃ (mod 3)` and `χ₄ (mod 4)`, one has

      F_r(x) < 1      for every r and every x ∈ [0,1) .

  Hence the leading threshold equation `F_r(x) = 1` has **no solution**: the
  OP-5 second-order expansion, whose leading order is fixed by that equation,
  does not survive this twist.  (The numerical scan `../verify/03_character_scan.py`
  shows the phenomenon is not universal: characters mod 11, 13, 23, … *do* admit
  a root, and then the expansion survives with character-determined constants.)
-/

import Op57.Blocks

namespace Op57

noncomputable section

open scoped BigOperators Topology

/-- The real non-principal character mod 3: `χ(1)=1`, `χ(2)=−1`, `χ(0)=0`. -/
def chi3 : ℕ → ℝ := fun m => if m % 3 = 1 then 1 else if m % 3 = 2 then -1 else 0

/-- The real non-principal character mod 4: `χ(1)=1`, `χ(3)=−1`, even `0`. -/
def chi4 : ℕ → ℝ := fun m => if m % 4 = 1 then 1 else if m % 4 = 3 then -1 else 0

theorem chi3_period : ∀ m, chi3 (m + 3) = chi3 m := by
  intro m
  have h : (m + 3) % 3 = m % 3 := by
    rw [Nat.add_mod, Nat.mod_self, Nat.add_zero, Nat.mod_mod]
  simp only [chi3, h]

theorem chi4_period : ∀ m, chi4 (m + 4) = chi4 m := by
  intro m
  have h : (m + 4) % 4 = m % 4 := by
    rw [Nat.add_mod, Nat.mod_self, Nat.add_zero, Nat.mod_mod]
  simp only [chi4, h]

theorem one_sub_pow_pos {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) {q : ℕ} (hq : 0 < q) :
    (0 : ℝ) < 1 - x ^ q := by
  have h := geom_norm_lt_one hx0 hx1 hq
  rw [Real.norm_eq_abs, abs_of_nonneg (pow_nonneg hx0 q)] at h
  linarith

/-- The block polynomial of `χ₃` on the three residues. -/
theorem fblock_chi3_0 (x : ℝ) : fblock chi3 3 0 x = x - x ^ 2 := by
  norm_num [fblock, chi3, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

theorem fblock_chi3_1 (x : ℝ) : fblock chi3 3 1 x = x ^ 3 - x := by
  norm_num [fblock, chi3, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

theorem fblock_chi3_2 (x : ℝ) : fblock chi3 3 2 x = x ^ 2 - x ^ 3 := by
  norm_num [fblock, chi3, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

/-- The block polynomial of `χ₄` on the four residues. -/
theorem fblock_chi4_0 (x : ℝ) : fblock chi4 4 0 x = x - x ^ 3 := by
  norm_num [fblock, chi4, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

theorem fblock_chi4_1 (x : ℝ) : fblock chi4 4 1 x = x ^ 4 - x ^ 2 := by
  norm_num [fblock, chi4, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

theorem fblock_chi4_2 (x : ℝ) : fblock chi4 4 2 x = x ^ 3 - x := by
  norm_num [fblock, chi4, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

theorem fblock_chi4_3 (x : ℝ) : fblock chi4 4 3 x = x ^ 2 - x ^ 4 := by
  norm_num [fblock, chi4, Finset.sum_range_succ, Finset.sum_range_zero]
  ring

/-- **No threshold for `χ₃`.**  `F_r(x) < 1` for all `r` and all `x ∈ [0,1)`. -/
theorem chi3_F_lt_one_residue (x : ℝ) (hx0 : 0 ≤ x) (hx1 : x < 1) :
    ∀ j : Fin 3, F chi3 j.val x < 1 := by
  intro j
  have hden := one_sub_pow_pos hx0 hx1 (q := 3) (by norm_num)
  have h1 : (0 : ℝ) < 1 - x := by linarith
  fin_cases j
  · rw [F_eq_fblock (q := 3) (by norm_num) chi3_period 0 hx0 hx1, fblock_chi3_0,
      div_lt_one hden]
    have hfac : 1 - x ^ 3 - (x - x ^ 2) = (1 - x) * (1 + x ^ 2) := by ring
    have h2 : (0 : ℝ) < 1 + x ^ 2 := by nlinarith [sq_nonneg x]
    nlinarith [hfac, mul_pos h1 h2]
  · rw [F_eq_fblock (q := 3) (by norm_num) chi3_period 1 hx0 hx1, fblock_chi3_1,
      div_lt_one hden]
    have hfac : 1 - x ^ 3 - (x ^ 3 - x) = (1 - x) * (2 * x ^ 2 + 2 * x + 1) := by ring
    have h2 : (0 : ℝ) < 2 * x ^ 2 + 2 * x + 1 := by nlinarith [sq_nonneg x, hx0]
    nlinarith [hfac, mul_pos h1 h2]
  · rw [F_eq_fblock (q := 3) (by norm_num) chi3_period 2 hx0 hx1, fblock_chi3_2,
      div_lt_one hden]
    have h2 : x ^ 2 < 1 := by nlinarith [hx0, hx1]
    linarith

/-- **No threshold for `χ₄`.**  `F_r(x) < 1` for all `r` and all `x ∈ [0,1)`. -/
theorem chi4_F_lt_one_residue (x : ℝ) (hx0 : 0 ≤ x) (hx1 : x < 1) :
    ∀ j : Fin 4, F chi4 j.val x < 1 := by
  intro j
  have hden := one_sub_pow_pos hx0 hx1 (q := 4) (by norm_num)
  have h1 : (0 : ℝ) < 1 - x := by linarith
  have hp1 : (0 : ℝ) < 1 + x := by linarith
  fin_cases j
  · rw [F_eq_fblock (q := 4) (by norm_num) chi4_period 0 hx0 hx1, fblock_chi4_0,
      div_lt_one hden]
    have hfac : 1 - x ^ 4 - (x - x ^ 3) = (1 - x) * (1 + x ^ 3) := by ring
    have h2 : (0 : ℝ) < 1 + x ^ 3 := by nlinarith [sq_nonneg x, hx0]
    nlinarith [hfac, mul_pos h1 h2]
  · rw [F_eq_fblock (q := 4) (by norm_num) chi4_period 1 hx0 hx1, fblock_chi4_1,
      div_lt_one hden]
    have hfac : 1 - x ^ 4 - (x ^ 4 - x ^ 2) = (1 - x) * (1 + x) * (2 * x ^ 2 + 1) := by ring
    have h2 : (0 : ℝ) < 2 * x ^ 2 + 1 := by nlinarith [sq_nonneg x]
    nlinarith [hfac, mul_pos (mul_pos h1 hp1) h2]
  · rw [F_eq_fblock (q := 4) (by norm_num) chi4_period 2 hx0 hx1, fblock_chi4_2,
      div_lt_one hden]
    have hfac : 1 - x ^ 4 - (x ^ 3 - x) = (1 - x) * (1 + x) * (1 + x + x ^ 2) := by ring
    have h2 : (0 : ℝ) < 1 + x + x ^ 2 := by nlinarith [sq_nonneg x, hx0]
    nlinarith [hfac, mul_pos (mul_pos h1 hp1) h2]
  · rw [F_eq_fblock (q := 4) (by norm_num) chi4_period 3 hx0 hx1, fblock_chi4_3,
      div_lt_one hden]
    have h2 : x ^ 2 < 1 := by nlinarith [hx0, hx1]
    linarith

/-- **No threshold for `χ₃`, all residues.** -/
theorem chi3_F_lt_one (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F chi3 r x < 1 := by
  rw [F_mod (q := 3) (by norm_num) chi3_period r hx0 hx1]
  exact chi3_F_lt_one_residue x hx0 hx1 ⟨r % 3, Nat.mod_lt _ (by norm_num)⟩

/-- **No threshold for `χ₄`, all residues.** -/
theorem chi4_F_lt_one (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F chi4 r x < 1 := by
  rw [F_mod (q := 4) (by norm_num) chi4_period r hx0 hx1]
  exact chi4_F_lt_one_residue x hx0 hx1 ⟨r % 4, Nat.mod_lt _ (by norm_num)⟩

/-- The leading equation for `χ₃` has no solution in `[0,1)`. -/
theorem chi3_no_leading_threshold (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F chi3 r x ≠ 1 := by
  have h := chi3_F_lt_one r hx0 hx1
  linarith

/-- The leading equation for `χ₄` has no solution in `[0,1)`. -/
theorem chi4_no_leading_threshold (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F chi4 r x ≠ 1 := by
  have h := chi4_F_lt_one r hx0 hx1
  linarith

end

end Op57
