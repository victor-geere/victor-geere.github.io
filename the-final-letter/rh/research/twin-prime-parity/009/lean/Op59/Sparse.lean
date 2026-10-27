/-
  Op59/Sparse.lean — the sparse-pair bound for the angle-sign twist.

  For a pair weight `w` taking values in `{+1, -1}`, the symmetric twist of the
  shift-2 correlation is

      C_w(N) = Σ_{n<N} a_n w(n) w(n+2) ,      a_n = λ(n) λ(n+2) ,

  and it differs from the untwisted `Σ a_n` only at the *crossing* indices where
  `w(n) w(n+2) ≠ 1`.  Each such index contributes at most `2`:

      | C_w(N) - Σ_{n<N} a_n |  ≤  2 · #{ n < N : w(n) w(n+2) ≠ 1 } .

  This is the "sparse modification" mechanism (006 dictionary F5): the twist is
  invisible to the pair correlation up to the size of its crossing set.
-/

import Mathlib

namespace Op59

noncomputable section

open scoped BigOperators

open Finset

/-- The indices `n < N` at which the pair weight `w n * w (n+2)` differs from `1`. -/
def crossingSet (w : ℕ → ℤ) (N : ℕ) : Finset ℕ :=
  (Finset.range N).filter (fun n => w n * w (n + 2) ≠ 1)

/-- A `±1`-valued weight has pair products in `{1, -1}`. -/
theorem pair_prod_eq (w : ℕ → ℤ) (hw : ∀ n, w n = 1 ∨ w n = -1) (n : ℕ) :
    w n * w (n + 2) = 1 ∨ w n * w (n + 2) = -1 := by
  rcases hw n with h | h <;> rcases hw (n + 2) with h' | h' <;> rw [h, h'] <;> norm_num

/-- **Sparse-pair bound.** For `|a n| ≤ 1` and `w` taking values in `{+1,-1}`,

    `|Σ_{n<N} a n (w n * w (n+2) - 1)| ≤ 2 * #(crossingSet w N)`.

The left side is exactly `|C_w(N) - Σ a_n|`. -/
theorem sparse_pair_bound (a w : ℕ → ℤ) (N : ℕ)
    (ha : ∀ n, |a n| ≤ 1) (hw : ∀ n, w n = 1 ∨ w n = -1) :
    |∑ n ∈ Finset.range N, a n * (w n * w (n + 2) - 1)|
      ≤ 2 * ((crossingSet w N).card : ℤ) := by
  have hterm : ∀ n, |a n * (w n * w (n + 2) - 1)|
      ≤ if w n * w (n + 2) ≠ 1 then (2 : ℤ) else 0 := by
    intro n
    have hp := pair_prod_eq w hw n
    split_ifs with hc
    · rcases hp with h | h
      · exact absurd h hc
      · rw [h]
        have hb : |a n * ((-1 : ℤ) - 1)| = |a n| * 2 := by rw [abs_mul]; norm_num
        rw [hb]
        nlinarith [ha n, abs_nonneg (a n)]
    · rcases hp with h | h
      · rw [h]; norm_num
      · exfalso; exact hc (by rw [h]; norm_num)
  calc |∑ n ∈ Finset.range N, a n * (w n * w (n + 2) - 1)|
      ≤ ∑ n ∈ Finset.range N, |a n * (w n * w (n + 2) - 1)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ n ∈ Finset.range N, (if w n * w (n + 2) ≠ 1 then (2 : ℤ) else 0) :=
        Finset.sum_le_sum (fun n _ => hterm n)
    _ = ∑ n ∈ crossingSet w N, (2 : ℤ) := by
        rw [crossingSet, Finset.sum_filter]
    _ = 2 * ((crossingSet w N).card : ℤ) := by
        rw [Finset.sum_const, nsmul_eq_mul]; ring

end

end Op59
