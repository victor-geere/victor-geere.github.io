/-
  Sparse.lean — OP-12: the corrected sparse-modification bound of rh47.

  Round rh46 quoted the bound

      |S_A(x) − S(x)| ≤ 2 · #{n ≤ x + 2 : n ∈ A}          (rh46 form)

  for the effect of flipping the Liouville sign on a set `A` of indices.  That
  statement is **false**.  The witness is `A = {5}`, `x = 5`: the two summands
  containing the flipped value are `n = 3` (`λ(3)λ(5)`) and `n = 5`
  (`λ(5)λ(7)`), and both change `+1 → −1`, so `|ΔS| = 4 > 2`.

  The correct statement, proved here, is

      |S_A(x) − S(x)| ≤ 2 · #{n ≤ x : n ∈ A ∨ n + h ∈ A}
                      ≤ 4 · #{m ≤ x + h : m ∈ A},                    (rh47 form)

  the first inequality being sharp at the witness (`A = {5}`, `x = 5`, `h = 2`,
  both sides equal to `4`).  The `o(x)` conclusion of rh46 is unaffected, since
  the corrected right-hand side is still `≤ 4·|A ∩ [1, x + h]|`.

  The development imports the whole certified `Rh46.Chowla` slice layer; there is
  no `sorry`, no `axiom` and no `native_decide`.
-/
import Rh46.Chowla

namespace Rh47

open scoped BigOperators

noncomputable section

/-- **The sparse sign modification of `λ`.**  `sparseLiouville A n` is `λ n` with
the sign flipped at the indices in the finite set `A` (and unchanged elsewhere). -/
def sparseLiouville (A : Finset ℕ) (n : ℕ) : ℤ :=
  if n ∈ A then -Rh46.liouville n else Rh46.liouville n

/-- The two-point correlation built from the modified function. -/
def corrSparse (A : Finset ℕ) (h N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, sparseLiouville A n * sparseLiouville A (n + h)

/-- Off `A`, the modified function is `λ`. -/
theorem sparseLiouville_of_notMem {A : Finset ℕ} {n : ℕ} (hn : n ∉ A) :
    sparseLiouville A n = Rh46.liouville n := by
  rw [sparseLiouville, if_neg hn]

/-- On `A`, the modified function is `−λ`. -/
theorem sparseLiouville_of_mem {A : Finset ℕ} {n : ℕ} (hn : n ∈ A) :
    sparseLiouville A n = -Rh46.liouville n := by
  rw [sparseLiouville, if_pos hn]

/-- The modification preserves the range: it is still a sign. -/
theorem sparseLiouville_abs_le_one (A : Finset ℕ) (n : ℕ) :
    |sparseLiouville A n| ≤ 1 := by
  by_cases h : n ∈ A
  · rw [sparseLiouville_of_mem h, abs_neg]
    exact Rh46.liouville_abs_le_one n
  · rw [sparseLiouville_of_notMem h]
    exact Rh46.liouville_abs_le_one n

/-- `|a - b| ≤ |a| + |b|` for integers (the two-term form, since Mathlib's
`abs_sub_le` is the three-term triangle inequality). -/
theorem abs_sub_le_abs_add (a b : ℤ) : |a - b| ≤ |a| + |b| := by
  rw [sub_eq_add_neg]
  calc |a + -b| ≤ |a| + |-b| := abs_add_le _ _
    _ = |a| + |b| := by rw [abs_neg]

/-- On a singleton, the sparse modification is exactly the rh46 slice. -/
theorem sparseLiouville_singleton (a n : ℕ) :
    sparseLiouville {a} n = Rh46.liouvilleSlice a n := by
  by_cases h : n = a
  · rw [sparseLiouville, if_pos (by rw [Finset.mem_singleton]; exact h),
      Rh46.liouvilleSlice, if_pos h, h]
  · have hmem : n ∉ ({a} : Finset ℕ) := by
      rw [Finset.mem_singleton]
      exact h
    rw [sparseLiouville, if_neg hmem, Rh46.liouvilleSlice, if_neg h]

/-- **The pointwise perturbation bound.**  Flipping the sign at `n` and/or `n + h`
changes the summand by at most `2`, and only when at least one of the two indices
is in `A`. -/
theorem sparse_term_sub_abs_le (A : Finset ℕ) (h n : ℕ) :
    |sparseLiouville A n * sparseLiouville A (n + h) -
        Rh46.liouville n * Rh46.liouville (n + h)| ≤
      (if n ∈ A ∨ n + h ∈ A then (2 : ℤ) else 0) := by
  by_cases hcond : n ∈ A ∨ n + h ∈ A
  · rw [if_pos hcond]
    have ha : |sparseLiouville A n * sparseLiouville A (n + h)| ≤ 1 := by
      rw [abs_mul]
      calc |sparseLiouville A n| * |sparseLiouville A (n + h)| ≤ 1 * 1 :=
            mul_le_mul (sparseLiouville_abs_le_one A n) (sparseLiouville_abs_le_one A (n + h))
              (abs_nonneg _) (by norm_num)
        _ = 1 := by ring
    have hb : |Rh46.liouville n * Rh46.liouville (n + h)| ≤ 1 := by
      rw [abs_mul]
      calc |Rh46.liouville n| * |Rh46.liouville (n + h)| ≤ 1 * 1 :=
            mul_le_mul (Rh46.liouville_abs_le_one n) (Rh46.liouville_abs_le_one (n + h))
              (abs_nonneg _) (by norm_num)
        _ = 1 := by ring
    calc |sparseLiouville A n * sparseLiouville A (n + h) -
            Rh46.liouville n * Rh46.liouville (n + h)|
        ≤ |sparseLiouville A n * sparseLiouville A (n + h)| +
            |Rh46.liouville n * Rh46.liouville (n + h)| := abs_sub_le_abs_add _ _
      _ ≤ 1 + 1 := add_le_add ha hb
      _ = 2 := by norm_num
  · rw [if_neg hcond]
    rw [not_or] at hcond
    rw [sparseLiouville_of_notMem hcond.1, sparseLiouville_of_notMem hcond.2,
      sub_self, abs_zero]

/-- **OP-12, sharp form.**  The effect on `S(x) = Σ_{n≤x} λ(n)λ(n+2)` of flipping
the sign of `λ` on the finite set `A` is bounded by twice the number of summands
that contain a flipped index.  The bound is sharp at `A = {5}`, `h = 2`, `N = 5`. -/
theorem corrSparse_sub_corr_abs_le (A : Finset ℕ) (h N : ℕ) :
    |corrSparse A h N - Rh46.corr h N| ≤
      2 * (((Finset.Icc 1 N).filter (fun n => n ∈ A ∨ n + h ∈ A)).card : ℤ) := by
  rw [corrSparse, Rh46.corr, ← Finset.sum_sub_distrib]
  calc |∑ n ∈ Finset.Icc 1 N, (sparseLiouville A n * sparseLiouville A (n + h) -
          Rh46.liouville n * Rh46.liouville (n + h))|
      ≤ ∑ n ∈ Finset.Icc 1 N,
          |sparseLiouville A n * sparseLiouville A (n + h) -
            Rh46.liouville n * Rh46.liouville (n + h)| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ n ∈ Finset.Icc 1 N, (if n ∈ A ∨ n + h ∈ A then (2 : ℤ) else 0) :=
        Finset.sum_le_sum (fun n _ => sparse_term_sub_abs_le A h n)
    _ = ∑ n ∈ Finset.Icc 1 N, 2 * (if n ∈ A ∨ n + h ∈ A then (1 : ℤ) else 0) := by
        apply Finset.sum_congr rfl
        intro n _
        split <;> ring
    _ = 2 * ∑ n ∈ Finset.Icc 1 N, (if n ∈ A ∨ n + h ∈ A then (1 : ℤ) else 0) := by
        rw [Finset.mul_sum]
    _ = 2 * (((Finset.Icc 1 N).filter (fun n => n ∈ A ∨ n + h ∈ A)).card : ℤ) := by
        rw [Finset.sum_boole]

/-- **OP-12, the registered corollary.**  Since each affected index is either in
`A` or is `h` less than an element of `A`, the sharp bound is at most four times
the number of elements of `A` in `[1, N + h]`.  This is the rh47 form
`≤ 4·#{m ≤ x + h : m ∈ A}` (with `h = 2` for the two-point Chowla shift). -/
theorem corrSparse_sub_corr_abs_le_four (A : Finset ℕ) (h N : ℕ) :
    |corrSparse A h N - Rh46.corr h N| ≤
      4 * (((Finset.Icc 1 (N + h)).filter (fun m => m ∈ A)).card : ℤ) := by
  refine le_trans (corrSparse_sub_corr_abs_le A h N) ?_
  set T : Finset ℕ := (Finset.Icc 1 (N + h)).filter (fun m => m ∈ A) with hT
  have hsplit : (Finset.Icc 1 N).filter (fun n => n ∈ A ∨ n + h ∈ A) =
      ((Finset.Icc 1 N).filter (fun n => n ∈ A)) ∪
        ((Finset.Icc 1 N).filter (fun n => n + h ∈ A)) :=
    Finset.filter_or _ _ _
  have h1 : ((Finset.Icc 1 N).filter (fun n => n ∈ A)).card ≤ T.card := by
    apply Finset.card_le_card
    intro n hn
    rw [hT, Finset.mem_filter, Finset.mem_Icc]
    rw [Finset.mem_filter, Finset.mem_Icc] at hn
    exact ⟨⟨hn.1.1, by omega⟩, hn.2⟩
  have h2 : ((Finset.Icc 1 N).filter (fun n => n + h ∈ A)).card ≤ T.card := by
    apply Finset.card_le_card_of_injOn (fun n => n + h)
    · intro n hn
      rw [Finset.mem_coe, Finset.mem_filter, Finset.mem_Icc] at hn
      rw [Finset.mem_coe, hT, Finset.mem_filter, Finset.mem_Icc]
      dsimp only
      exact ⟨⟨by omega, by omega⟩, hn.2⟩
    · intro x hx y hy hxy
      dsimp only at hxy
      omega
  have hnat : ((Finset.Icc 1 N).filter (fun n => n ∈ A ∨ n + h ∈ A)).card ≤ 2 * T.card := by
    rw [hsplit]
    calc (((Finset.Icc 1 N).filter (fun n => n ∈ A)) ∪
            ((Finset.Icc 1 N).filter (fun n => n + h ∈ A))).card
        ≤ ((Finset.Icc 1 N).filter (fun n => n ∈ A)).card +
            ((Finset.Icc 1 N).filter (fun n => n + h ∈ A)).card := Finset.card_union_le _ _
      _ ≤ T.card + T.card := add_le_add h1 h2
      _ = 2 * T.card := by ring
  have hcard : (((Finset.Icc 1 N).filter (fun n => n ∈ A ∨ n + h ∈ A)).card : ℤ) ≤
      2 * (T.card : ℤ) := by
    exact_mod_cast hnat
  rw [hT]
  nlinarith

/-- The singleton sparse modification is the rh46 slice correlation. -/
theorem corrSparse_singleton (a h N : ℕ) :
    corrSparse {a} h N = Rh46.corrSlice h a N := by
  rw [corrSparse, Rh46.corrSlice]
  apply Finset.sum_congr rfl
  intro n _
  rw [sparseLiouville_singleton a n, sparseLiouville_singleton a (n + h)]

/-- **The rh46 form is false.**  With `A = {5}`, `h = 2`, `N = 5`, the left side is
`4` while the rh46 right side `2·#{n ≤ N + h : n ∈ A}` is `2`.  (Decidable
counterexample: the Finset count is evaluated by `decide`.) -/
theorem rh46_sparse_bound_false :
    ∃ (A : Finset ℕ) (h N : ℕ),
      ¬ (|corrSparse A h N - Rh46.corr h N| ≤
          2 * (((Finset.Icc 1 (N + h)).filter (fun m => m ∈ A)).card : ℤ)) := by
  refine ⟨{5}, 2, 5, ?_⟩
  rw [corrSparse_singleton]
  have hkey := Rh46.corrSlice_sub_corr_self_eq (h := 2) (a := 5)
    (by norm_num) (by norm_num)
  have hval : Rh46.corrSlice 2 5 5 - Rh46.corr 2 5 = -4 := by
    rw [hkey]
    norm_num [Rh46.liouville_three, Rh46.liouville_five, Rh46.liouville_seven]
  have hfour : |Rh46.corrSlice 2 5 5 - Rh46.corr 2 5| = 4 := by
    rw [hval]
    norm_num
  have hcount : ((Finset.Icc 1 (5 + 2)).filter
      (fun m => m ∈ ({5} : Finset ℕ))).card = 1 := by decide
  intro hle
  rw [hfour, hcount] at hle
  norm_num at hle

/-- **The corrected bound is sharp at the witness.**  For `A = {5}`, `h = 2`,
`N = 5` the sharp bound `2·#{n ≤ N : n ∈ A ∨ n + h ∈ A}` equals the true change
`4`, so the factor `2` cannot be lowered. -/
theorem corrSparse_bound_sharp :
    |corrSparse {5} 2 5 - Rh46.corr 2 5| =
      2 * (((Finset.Icc 1 5).filter (fun n => n ∈ ({5} : Finset ℕ) ∨ n + 2 ∈ ({5} : Finset ℕ))).card : ℤ) := by
  rw [corrSparse_singleton]
  have hkey := Rh46.corrSlice_sub_corr_self_eq (h := 2) (a := 5)
    (by norm_num) (by norm_num)
  have hval : Rh46.corrSlice 2 5 5 - Rh46.corr 2 5 = -4 := by
    rw [hkey]
    norm_num [Rh46.liouville_three, Rh46.liouville_five, Rh46.liouville_seven]
  have hcount : ((Finset.Icc 1 5).filter
      (fun n => n ∈ ({5} : Finset ℕ) ∨ n + 2 ∈ ({5} : Finset ℕ))).card = 2 := by decide
  rw [hval, hcount]
  norm_num

end

end Rh47
