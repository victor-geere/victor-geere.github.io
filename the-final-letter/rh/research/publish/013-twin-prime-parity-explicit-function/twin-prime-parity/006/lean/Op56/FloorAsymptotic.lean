/-
  Op56/FloorAsymptotic.lean — the floor/Diophantine meta-theorem behind OP-5 (TODO O11).

  The OP-5 index asymptotic `nmin p = p / log 2 - 5 / 2 + O(1)` is *sharp*: the error
  term cannot be improved to `O(1/p)`.  This module isolates the general reason, which
  has nothing to do with `Phi` or the census law:

  > **Meta-theorem.**  If `α` is irrational, then no integer-valued sequence `n` can
  > satisfy `|n p - (α p + β)| ≤ C / p` for all large `p`.

  In other words, an *integer* index cannot track an irrational affine function of the
  parameter to within `O(1/p)`: the rounding error `‖α p + β‖` is bounded below by a
  positive constant along every large-`p` tail (and, by Weyl equidistribution, has
  limsup at least `1/4`), so an `O(1/p)` bound is impossible.

  The proof is completely elementary and needs **no** density or equidistribution input.
  Comparing the hypothesis at `p` and at `p + 1` gives

      |(n (p+1) - n p) - α| ≤ C/(p+1) + C/p ≤ 2|C|/p ,

  and the left-hand quantity is `|z - α|` for the integer `z = n (p+1) - n p`.  Since the
  right-hand side is `o(1)`, the integers `n (p+1) - n p` are eventually constant, equal
  to some `z`; squeezing the same bound then forces `α = z`, so `α` is rational — a
  contradiction.

  ## Contents

  * `no_index_asymptotic_error` — the general theorem, `ℤ`-valued index, `False` conclusion;
  * `no_index_asymptotic_error_nat` — the `ℕ`-valued specialisation;
  * `irrational_not_eventually_error_inv` — the existential (packaged) form;
  * `log_two_inv_no_index_asymptotic` — the concrete instance `α = 1 / log 2`, any `β`;
  * `nmin_error_not_bigO_inv` — the OP-5 instance `α = 1 / log 2`, `β = -5/2`, against
    `nmin p` and `nminAsym p`.

  ## Hypothesis kept explicit

  `Real.log 2` (equivalently `(Real.log 2)⁻¹`) is **irrational**, and Mathlib has no such
  theorem: it is the Lindemann–Weierstrass consequence of `exp (log 2) = 2` (algebraic
  `2 ≠ 0`, so `log 2` cannot be algebraic) and Mathlib at `v4.35.0-rc2` only formalises the
  *analytic part* of Lindemann–Weierstrass
  (`Mathlib/NumberTheory/Transcendental/Lindemann/AnalyticalPart.lean`), not the
  transcendence conclusion.  The irrationality of `1 / Real.log 2` is therefore carried as
  an explicit hypothesis `hlog : Irrational (Real.log 2)` (turned into
  `Irrational ((Real.log 2)⁻¹)` with `Irrational.inv`) in the concrete theorems; the general
  meta-theorem is unconditional.
-/

import Op56.Exact

namespace Op56

open Filter

/-- **The floor-asymptotic meta-theorem (O11).**

If `α` is irrational and `n : ℕ → ℤ` is an integer-valued index sequence whose distance
from the affine function `α p + β` is bounded by `C / p` for all `p ≥ P`, then `False`:
`α` would be forced to be an integer (take `p`, `p+1` consecutive; the integer
`n (p+1) - n p` is within `2|C|/p` of `α`, hence eventually constant, and the squeezing
argument gives `α = n (p+1) - n p`).

No density, equidistribution or Diophantine-approximation input is used; `C` is *not*
required to be nonnegative (the bound `2|C|/p` is what is proved internally). -/
theorem no_index_asymptotic_error
    {α β : ℝ} {n : ℕ → ℤ} {C : ℝ} {P : ℕ}
    (hα : Irrational α)
    (h : ∀ p : ℕ, P ≤ p → |(n p : ℝ) - (α * (p : ℝ) + β)| ≤ C / (p : ℝ)) :
    False := by
  -- Work with `D = |C| ≥ 0`; `C` itself need not be nonnegative.
  set D : ℝ := |C| with hDdef
  have hD : 0 ≤ D := by rw [hDdef]; positivity
  have hCle : C ≤ D := by rw [hDdef]; exact le_abs_self C
  -- The difference at consecutive indices is within `2 D / p` of `α`.
  have key : ∀ p : ℕ, P ≤ p → 1 ≤ p →
      |((n (p + 1) - n p : ℤ) : ℝ) - α| ≤ 2 * D / p := by
    intro p hp hp1
    have hp_pos : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp1
    have h1 := h (p + 1) (le_trans hp (Nat.le_succ p))
    have h2 := h p hp
    have hsum : |((n (p + 1) - n p : ℤ) : ℝ) - α|
        ≤ C / ((p + 1 : ℕ) : ℝ) + C / (p : ℝ) := by
      have hcast : ((n (p + 1) - n p : ℤ) : ℝ) - α
          = ((n (p + 1) : ℝ) - (α * ((p + 1 : ℕ) : ℝ) + β))
            - ((n p : ℝ) - (α * (p : ℝ) + β)) := by
        push_cast
        ring
      rw [hcast]
      exact le_trans (abs_sub _ _) (add_le_add h1 h2)
    refine le_trans hsum ?_
    have h3 : C / ((p + 1 : ℕ) : ℝ) ≤ D / ((p + 1 : ℕ) : ℝ) :=
      div_le_div_of_nonneg_right hCle (by positivity)
    have h4 : D / ((p + 1 : ℕ) : ℝ) ≤ D / (p : ℝ) := by
      have hle : (p : ℝ) ≤ ((p + 1 : ℕ) : ℝ) := by push_cast; linarith
      exact div_le_div_of_nonneg_left hD hp_pos hle
    have h5 : C / (p : ℝ) ≤ D / (p : ℝ) :=
      div_le_div_of_nonneg_right hCle (le_of_lt hp_pos)
    have h6 : 2 * D / (p : ℝ) = D / (p : ℝ) + D / (p : ℝ) := by ring
    rw [h6]
    linarith
  -- Pick `p₁ ≥ P`, `p₁ ≥ 1` with `2 D / p₁ < 1/2`, i.e. `p₁ > 4 D`.
  obtain ⟨p₁, hp₁⟩ := exists_nat_gt (max (4 * D) (max (P : ℝ) 1))
  have hp₁D : 4 * D < (p₁ : ℝ) := lt_of_le_of_lt (le_max_left _ _) hp₁
  have hp₁P : (P : ℝ) < (p₁ : ℝ) :=
    lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_right _ _)) hp₁
  have hp₁1 : (1 : ℝ) < (p₁ : ℝ) :=
    lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_right _ _)) hp₁
  have hPp₁ : P ≤ p₁ := by exact_mod_cast (le_of_lt hp₁P)
  have h1p₁ : 1 ≤ p₁ := by exact_mod_cast (le_of_lt hp₁1)
  have hp₁pos : (0 : ℝ) < (p₁ : ℝ) := by exact_mod_cast h1p₁
  have hsmall : 2 * D / (p₁ : ℝ) < 1 / 2 := by
    rw [div_lt_iff₀ hp₁pos]
    linarith
  -- The integers `n (p+1) - n p` do not move for `p ≥ p₁`.
  have hconst : ∀ p : ℕ, p₁ ≤ p → n (p + 1) - n p = n (p₁ + 1) - n p₁ := by
    intro p hp
    have hpP : P ≤ p := le_trans hPp₁ hp
    have h1p : 1 ≤ p := le_trans h1p₁ hp
    have hmono : 2 * D / (p : ℝ) ≤ 2 * D / (p₁ : ℝ) :=
      div_le_div_of_nonneg_left (by positivity) hp₁pos (by exact_mod_cast hp)
    have hb := key p hpP h1p
    have hb₁ := key p₁ hPp₁ h1p₁
    set k : ℤ := (n (p + 1) - n p) - (n (p₁ + 1) - n p₁) with hk
    have hkcast : (k : ℝ) = ((n (p + 1) - n p : ℤ) : ℝ) - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ) := by
      rw [hk]
      push_cast
      ring
    have hlt : |(k : ℝ)| < 1 := by
      rw [hkcast]
      have hdecomp : ((n (p + 1) - n p : ℤ) : ℝ) - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ)
          = (((n (p + 1) - n p : ℤ) : ℝ) - α) + (α - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ)) := by
        ring
      calc |((n (p + 1) - n p : ℤ) : ℝ) - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ)|
          = |(((n (p + 1) - n p : ℤ) : ℝ) - α) + (α - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ))| := by
            rw [hdecomp]
        _ ≤ |((n (p + 1) - n p : ℤ) : ℝ) - α| + |α - ((n (p₁ + 1) - n p₁ : ℤ) : ℝ)| :=
            abs_add_le _ _
        _ ≤ 2 * D / (p : ℝ) + 2 * D / (p₁ : ℝ) :=
            add_le_add hb (by simpa [abs_sub_comm] using hb₁)
        _ < 1 / 2 + 1 / 2 := add_lt_add (lt_of_le_of_lt hmono hsmall) hsmall
        _ = 1 := by norm_num
    have hlt' := abs_lt.mp hlt
    have h1' : ((-1 : ℤ) : ℝ) < (k : ℝ) := by
      simpa using hlt'.1
    have h2' : (k : ℝ) < ((1 : ℤ) : ℝ) := by
      simpa using hlt'.2
    have h1'' : (-1 : ℤ) < k := by exact_mod_cast h1'
    have h2'' : k < 1 := by exact_mod_cast h2'
    have hzero : k = 0 := by omega
    rw [hk] at hzero
    exact sub_eq_zero.mp hzero
  -- Squeeze: the fixed integer `z = n (p₁+1) - n p₁` is within `2 D / p` of `α` for all
  -- `p ≥ p₁`, so `α = z`.
  have hzf : |((n (p₁ + 1) - n p₁ : ℤ) : ℝ) - α| ≤ 0 := by
    apply le_of_forall_pos_lt_add
    intro ε hε
    obtain ⟨p, hp⟩ := exists_nat_gt (max (2 * D / ε) (p₁ : ℝ))
    have hp₁p : p₁ ≤ p := by exact_mod_cast (le_of_lt (lt_of_le_of_lt (le_max_right _ _) hp))
    have hpD : 2 * D / ε < (p : ℝ) := lt_of_le_of_lt (le_max_left _ _) hp
    have hppos : (0 : ℝ) < (p : ℝ) := lt_of_lt_of_le hp₁pos (by exact_mod_cast hp₁p)
    have hb := key p (le_trans hPp₁ hp₁p) (le_trans h1p₁ hp₁p)
    rw [hconst p hp₁p] at hb
    have hεp : 2 * D / (p : ℝ) < ε := by
      rw [div_lt_iff₀ hε] at hpD
      rw [div_lt_iff₀ hppos]
      linarith
    linarith
  have hαz : α = ((n (p₁ + 1) - n p₁ : ℤ) : ℝ) := by
    have h0 : |((n (p₁ + 1) - n p₁ : ℤ) : ℝ) - α| = 0 :=
      le_antisymm hzf (abs_nonneg _)
    have := abs_eq_zero.mp h0
    linarith
  exact hα ⟨((n (p₁ + 1) - n p₁ : ℤ) : ℚ), by rw [hαz]; push_cast; ring⟩

/-- **The meta-theorem for a `ℕ`-valued index.**  Same statement as
`no_index_asymptotic_error` with `n : ℕ → ℕ`, which covers `nmin`. -/
theorem no_index_asymptotic_error_nat
    {α β : ℝ} {n : ℕ → ℕ} {C : ℝ} {P : ℕ}
    (hα : Irrational α)
    (h : ∀ p : ℕ, P ≤ p → |(n p : ℝ) - (α * (p : ℝ) + β)| ≤ C / (p : ℝ)) :
    False := by
  refine no_index_asymptotic_error (n := fun p => (n p : ℤ)) (β := β) (C := C) (P := P) hα ?_
  intro p hp
  simpa using h p hp

/-- **Packaged form.**  For irrational `α` there is *no* constant `C` and threshold `P`
with `|n p - (α p + β)| ≤ C / p` for all `p ≥ P`. -/
theorem irrational_not_eventually_error_inv
    {α β : ℝ} (hα : Irrational α) (n : ℕ → ℤ) :
    ¬ ∃ C : ℝ, ∃ P : ℕ, ∀ p : ℕ, P ≤ p →
      |(n p : ℝ) - (α * (p : ℝ) + β)| ≤ C / (p : ℝ) := by
  rintro ⟨C, P, h⟩
  exact no_index_asymptotic_error hα h

/-- **Concrete instance** with the OP-5 threshold slope `α = 1 / log 2` and an arbitrary
offset `β` (for OP-5, `β = -5/2`; see `nmin_error_not_bigO_inv`).

The irrationality of `Real.log 2` is Lindemann–Weierstrass and is **not** available in
Mathlib `v4.35.0-rc2`; it is carried as the explicit hypothesis `hlog`, and transported to
`1 / log 2` by `Irrational.inv`. -/
theorem log_two_inv_no_index_asymptotic
    (hlog : Irrational (Real.log 2)) (β : ℝ) (n : ℕ → ℤ) (C : ℝ) (P : ℕ)
    (h : ∀ p : ℕ, P ≤ p →
      |(n p : ℝ) - ((Real.log 2)⁻¹ * (p : ℝ) + β)| ≤ C / (p : ℝ)) :
    False :=
  no_index_asymptotic_error hlog.inv h

/-- **OP-5, sharpness of the `O(1)` error term.**  The index asymptotic
`nmin p = p / log 2 - 5/2 + O(1)` (`Op56.nminAsym`, `op5_nmin_asymptotic`) cannot be
improved to `O(1/p)`: for no `C` and `P` does `|nmin p - nminAsym p| ≤ C/p` hold on a
tail.  (Here `nminAsym p = (log 2)⁻¹ * p - 5/2`, so this is the instance `α = (log 2)⁻¹`,
`β = -5/2` of the meta-theorem.)

The irrationality of `Real.log 2` (Lindemann–Weierstrass) is an explicit hypothesis; see
the module docstring. -/
theorem nmin_error_not_bigO_inv
    (hlog : Irrational (Real.log 2)) {C : ℝ} {P : ℕ}
    (h : ∀ p : ℕ, P ≤ p → |(nmin p : ℝ) - nminAsym p| ≤ C / (p : ℝ)) : False := by
  refine no_index_asymptotic_error_nat (n := nmin) (β := -5 / 2) (C := C) (P := P) hlog.inv ?_
  intro p hp
  have heq : (Real.log 2)⁻¹ * (p : ℝ) + (-5 / 2 : ℝ) = nminAsym p := by
    unfold nminAsym
    rw [div_eq_mul_inv]
    ring
  rw [heq]
  exact h p hp

end Op56
