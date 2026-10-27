/-
  Impossibility.lean — the mathematical core of Theorem 12 of `TRUTHS.md`:
  exact termination and linear complexity growth are incompatible.

  A terminating process has a *finite* support `S` (finitely many ones), and for
  every finite support the complexity `p(L) = complexity S N L` is bounded by
  the constant `a_m + 2` (`Rh41.DigitWord.complexity_le_max_add_two`).  An
  unbounded profile such as `p(L) = c·L` (or the Sturmian profile `p(L) = L+1`)
  therefore cannot be realised.  That is what is proved here, with no reference
  to the alphabet or to the process.
-/
import Rh41.DigitWord

namespace Rh41

open Finset

/-- **Theorem 12 (impossibility half), quantitative form.**  For every finite
support `S` and every `c > 0` there are `N`, `L` with `1 ≤ L ≤ N` and
`p(L) < c·L`: a linear profile is impossible. -/
theorem no_linear_growth (S : Finset ℕ) (c : ℚ) (hc : 0 < c) :
    ∃ N L : ℕ, 1 ≤ L ∧ L ≤ N ∧ (complexity S N L : ℚ) < c * L := by
  rcases S.eq_empty_or_nonempty with hS | hne
  · -- empty support: one factor of each length
    have hbound : ∀ N L : ℕ, complexity S N L ≤ 1 := by
      intro N L
      rw [complexity]
      refine card_le_one.mpr ?_
      intro x hx y hy
      rw [mem_image] at hx hy
      obtain ⟨t, -, rfl⟩ := hx
      obtain ⟨u, -, rfl⟩ := hy
      rw [hS]
      simp [factor]
    obtain ⟨L, hL⟩ := exists_nat_gt (1 / c)
    have hcast : ((L + 1 : ℕ) : ℚ) = (L : ℚ) + 1 := by push_cast; ring
    have hlt : (1 : ℚ) < c * ((L + 1 : ℕ) : ℚ) := by
      have := (div_lt_iff₀ hc).mp hL
      rw [hcast]
      nlinarith
    refine ⟨L + 1, L + 1, by omega, le_rfl, ?_⟩
    have hb : (complexity S (L + 1) (L + 1) : ℚ) ≤ 1 := by
      exact_mod_cast hbound (L + 1) (L + 1)
    linarith
  · -- nonempty support: the bound `p ≤ a_m + 2`
    obtain ⟨L, hL⟩ := exists_nat_gt (((S.max' hne : ℕ) + 2 : ℚ) / c)
    have hcast : ((L + 1 : ℕ) : ℚ) = (L : ℚ) + 1 := by push_cast; ring
    have hlt : ((S.max' hne : ℕ) + 2 : ℚ) < c * ((L + 1 : ℕ) : ℚ) := by
      have := (div_lt_iff₀ hc).mp hL
      rw [hcast]
      nlinarith
    have hbound : (complexity S (L + 1) (L + 1) : ℚ)
        ≤ ((S.max' hne : ℕ) + 2 : ℚ) := by
      exact_mod_cast complexity_le_max_add_two S (L + 1) (L + 1) hne
    exact ⟨L + 1, L + 1, by omega, le_rfl, lt_of_le_of_lt hbound hlt⟩

/-- **Theorem 12 (impossibility half).**  No finite support has an affine
complexity profile `p(L) = a·L + b` with `a > 0`. -/
theorem no_affine_profile (S : Finset ℕ) (a b : ℚ) (ha : 0 < a) :
    ¬ (∀ N L : ℕ, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = a * L + b) := by
  intro h
  have hcast : ∀ L : ℕ, ((L + 1 : ℕ) : ℚ) = (L : ℚ) + 1 := by
    intro L; push_cast; ring
  rcases S.eq_empty_or_nonempty with hS | hne
  · have hbound : ∀ N L : ℕ, complexity S N L ≤ 1 := by
      intro N L
      rw [complexity]
      refine card_le_one.mpr ?_
      intro x hx y hy
      rw [mem_image] at hx hy
      obtain ⟨t, -, rfl⟩ := hx
      obtain ⟨u, -, rfl⟩ := hy
      rw [hS]
      simp [factor]
    obtain ⟨L, hL⟩ := exists_nat_gt ((1 - b) / a)
    have hlt : (1 : ℚ) < a * ((L + 1 : ℕ) : ℚ) + b := by
      have := (div_lt_iff₀ ha).mp hL
      rw [hcast]
      nlinarith
    have hp : (complexity S (L + 1) (L + 1) : ℚ) ≤ 1 := by
      exact_mod_cast hbound (L + 1) (L + 1)
    have heq := h (L + 1) (L + 1) (by omega) le_rfl
    linarith
  · obtain ⟨L, hL⟩ := exists_nat_gt ((((S.max' hne : ℕ) + 2 : ℚ) - b) / a)
    have hlt : ((S.max' hne : ℕ) + 2 : ℚ) < a * ((L + 1 : ℕ) : ℚ) + b := by
      have := (div_lt_iff₀ ha).mp hL
      rw [hcast]
      nlinarith
    have hp : (complexity S (L + 1) (L + 1) : ℚ)
        ≤ ((S.max' hne : ℕ) + 2 : ℚ) := by
      exact_mod_cast complexity_le_max_add_two S (L + 1) (L + 1) hne
    have heq := h (L + 1) (L + 1) (by omega) le_rfl
    linarith

/-- In particular the Sturmian profile `p(L) = L + 1` is not realised by any
finite support (i.e. by any terminating process). -/
theorem no_sturmian_profile (S : Finset ℕ) :
    ¬ (∀ N L : ℕ, 1 ≤ L → L ≤ N → (complexity S N L : ℚ) = L + 1) := by
  intro h
  refine no_affine_profile S 1 1 (by norm_num) fun N L h1 h2 => ?_
  rw [h N L h1 h2]
  ring

end Rh41
