import Mathlib

/-!
# GDST paper series — finite formal core

The archived paper `archive/maths/theorems/paper.md` develops the greedy
Dirichlet sub-sum transform (GDST) and claims a proof of the Riemann
hypothesis.  The global claim is an archived claim, not a theorem: the
paper's own appendix lists the analytic inputs (trace-class transfer
operator, Mayer--Efrat determinant, telescoping trace sum, Jacobi-matrix
spectral theory) as unproved.

What is genuinely finite, and what this file formalises, is the greedy
recursion of §1.1 and the selected/rejected split of §2.1.  With the
normalised target `x = θ/π` the harmonic fractions are `α n = 1/(n+2)`.
`run x N` is the remainder after the greedy pass over indices `0, …, N-1`;
`selectedWeight` and `rejectedWeight` are the truncated GDST series and
its complement.

The main results are the finite greedy invariant
`run x N = x - selectedWeight α x N` and the finite complement identity
`selectedWeight w x N + rejectedWeight w x N = totalWeight w N`.
Every declaration below is fully proved.
-/

noncomputable section

open scoped BigOperators

namespace GDST

/-- The `n`-th harmonic fraction `α n = 1 / (n + 2)`, for the normalised
target `x = θ/π`. -/
def alpha (n : ℕ) : ℚ := 1 / ((n : ℚ) + 2)

/-- The greedy remainder after processing indices `0, …, N-1`: subtract
`α k` at step `k` exactly when it fits in the current remainder. -/
def run (x : ℚ) : ℕ → ℚ
  | 0 => x
  | n + 1 => if alpha n ≤ run x n then run x n - alpha n else run x n

/-- The selected prefix `E_N = Σ_{k<N, δ_k=1} w k`.  The digit at index
`k` is the greedy one, `δ_k = 1` iff `α k ≤ run x k`. -/
def selectedWeight (w : ℕ → ℚ) (x : ℚ) (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range N, if alpha k ≤ run x k then w k else 0

/-- The rejected prefix `Ω_N = Σ_{k<N, δ_k=0} w k`. -/
def rejectedWeight (w : ℕ → ℚ) (x : ℚ) (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range N, if alpha k ≤ run x k then 0 else w k

/-- The full prefix `H_N = Σ_{k<N} w k`. -/
def totalWeight (w : ℕ → ℚ) (N : ℕ) : ℚ :=
  ∑ k ∈ Finset.range N, w k

/-- `α n` is positive. -/
theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

/-- The harmonic fractions strictly decrease. -/
theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have hcast : (a : ℚ) < (b : ℚ) := by exact_mod_cast hab
  have h1 : (0 : ℚ) < (a : ℚ) + 2 := by positivity
  have h2 : (a : ℚ) + 2 < (b : ℚ) + 2 := by linarith
  exact one_div_lt_one_div_of_lt h1 h2

/-- The greedy remainder never exceeds the target (Lemma 1.2's
non-increasing companion). -/
theorem run_le_self (x : ℚ) (N : ℕ) : run x N ≤ x := by
  induction N with
  | zero => simp [run]
  | succ n ih =>
      change (if alpha n ≤ run x n then run x n - alpha n else run x n) ≤ x
      split_ifs with h
      · have hp := alpha_pos n
        linarith
      · exact ih

/-- If the target is non-negative, every greedy remainder is
non-negative (Lemma 1.2). -/
theorem run_nonneg {x : ℚ} (hx : 0 ≤ x) (N : ℕ) : 0 ≤ run x N := by
  induction N with
  | zero => simpa [run] using hx
  | succ n ih =>
      change 0 ≤ (if alpha n ≤ run x n then run x n - alpha n else run x n)
      split_ifs with h
      · have hp := alpha_pos n
        linarith
      · exact ih

/-- The finite greedy invariant (equation (1.1) of the source):
`x = selected sum + remainder`. -/
theorem run_eq_sub_selected (x : ℚ) (N : ℕ) :
    run x N = x - selectedWeight alpha x N := by
  induction N with
  | zero => simp [run, selectedWeight]
  | succ n ih =>
      change (if alpha n ≤ run x n then run x n - alpha n else run x n)
        = x - selectedWeight alpha x (n + 1)
      split_ifs with h
      · have hsplit :
            selectedWeight alpha x (n + 1) = selectedWeight alpha x n + alpha n := by
          unfold selectedWeight
          rw [Finset.sum_range_succ, ite_eq_left h]
        rw [ih, hsplit]
        ring
      · have hsplit :
            selectedWeight alpha x (n + 1) = selectedWeight alpha x n + 0 := by
          unfold selectedWeight
          rw [Finset.sum_range_succ, ite_eq_right h]
        rw [ih, hsplit]
        ring

/-- The finite selected/rejected split used in §2.1:
`E_N + Ω_N = H_N`, for an arbitrary weight `w`. -/
theorem selected_add_rejected (w : ℕ → ℚ) (x : ℚ) (N : ℕ) :
    selectedWeight w x N + rejectedWeight w x N = totalWeight w N := by
  unfold selectedWeight rejectedWeight totalWeight
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl (fun k _ => by split_ifs <;> ring)

/-- The source's own example at `θ = π` (`x = 1`): the greedy word selects
indices `0, 1, 4`, the expansion terminates, and the selected sum is
`1 = 1/2 + 1/3 + 1/6`. -/
theorem gdst_pi_example : run 1 5 = 0 ∧ selectedWeight alpha 1 5 = 1 := by
  have hrun : run 1 5 = 0 := by
    norm_num [run, alpha]
  have hsum : selectedWeight alpha 1 5 = 1 := by
    have h := run_eq_sub_selected 1 5
    rw [hrun] at h
    linarith
  exact ⟨hrun, hsum⟩

end GDST
