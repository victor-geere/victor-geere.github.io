import Mathlib

/-!
# Greedy Dirichlet Sub-Sum Transform — formal core

This file reconstructs the finite, elementary part of the GDST source
(`archive/maths/rh/research/gdst/rh-proof/proof.html`, Part I and the
selected/rejected split of Part III).

The archived source claims a proof of the Riemann Hypothesis through
transfer operators, Fredholm determinants, Jacobi matrices and a list of
axioms (AX1–AX6).  None of that global argument is formalised here.  What
is formalised is the finite greedy harmonic recursion on `[0,1]`:

* `α n = 1 / (n + 2)`;
* the digit/remainder recursion `δ_n`, `r_n`;
* the finite partial-sum identity `x = Σ_{k≤N} δ_k/(k+2) + r_N`;
* the remainder bounds `0 ≤ r_N ≤ 1/(N+2)` and the post-selection bound;
* the finite selected/rejected partition of a Dirichlet prefix.

The global RH claim, the analytic convergence theorem, and the operator
axioms remain source claims in the dossier.
-/

noncomputable section

open scoped BigOperators

namespace GDST

/-- The greedy harmonic fraction `α_n = 1/(n+2)` on the unit interval. -/
def alpha (n : ℕ) : ℝ := ((n : ℝ) + 2)⁻¹

/-- The digit selected by the initial threshold `α_0 = 1/2`. -/
def digit0 (x : ℝ) : ℕ := if (1 / 2 : ℝ) ≤ x then 1 else 0

/-- The digit selected at index `n+1` from remainder `r`, using the
threshold `α_{n+1} = 1/(n+3)`. -/
def nextDigit (n : ℕ) (r : ℝ) : ℕ := if ((n : ℝ) + 3)⁻¹ ≤ r then 1 else 0

/-- State `(δ_n(x), r_n(x))` of the greedy recursion.

`δ_0(x) = 1` iff `x ≥ 1/2 = α_0`, and `r_0(x) = x - δ_0(x)/2`.  At index
`n+1` the threshold is `α_{n+1} = 1/(n+3)`. -/
def state (x : ℝ) : ℕ → ℕ × ℝ
  | 0 => (digit0 x, x - (digit0 x : ℝ) / 2)
  | n + 1 =>
      let r := (state x n).2
      let d := nextDigit n r
      (d, r - (d : ℝ) * ((n : ℝ) + 3)⁻¹)

/-- The greedy digit `δ_n(x) ∈ {0,1}`. -/
def delta (x : ℝ) (n : ℕ) : ℕ := (state x n).1

/-- The greedy remainder `r_n(x) ≥ 0`. -/
def rem (x : ℝ) (n : ℕ) : ℝ := (state x n).2

/-- The truncated Dirichlet prefix `Σ_{k=0}^{N} (k+2)^{-s}`. -/
def dirichletPrefix (s : ℝ) (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (N + 1), ((k : ℝ) + 2) ^ (-s)

/-- The selected sub-series `E_N(x,s) = Σ_{k≤N, δ_k(x)=1} (k+2)^{-s}`. -/
def selectedWeight (x : ℝ) (s : ℝ) (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (N + 1),
    if delta x k = 1 then ((k : ℝ) + 2) ^ (-s) else 0

/-- The rejected complement series `Ω_N(x,s) = Σ_{k≤N, δ_k(x)=0} (k+2)^{-s}`. -/
def rejectedWeight (x : ℝ) (s : ℝ) (N : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (N + 1),
    if delta x k = 0 then ((k : ℝ) + 2) ^ (-s) else 0

/-- T1: every greedy digit is either `0` or `1`. -/
theorem delta_zero_or_one (x : ℝ) (n : ℕ) : delta x n = 0 ∨ delta x n = 1 := by
  induction n with
  | zero =>
      simp only [delta, state, digit0]
      split <;> simp
  | succ n _ =>
      simp only [delta, state, nextDigit]
      split <;> simp

/-- T2: the remainder stays non-negative when started from `x ≥ 0`. -/
theorem rem_nonneg {x : ℝ} (hx : 0 ≤ x) (n : ℕ) : 0 ≤ rem x n := by
  induction n with
  | zero =>
      simp only [rem, state, digit0]
      split
      · norm_num
        linarith
      · simpa using hx
  | succ n ih =>
      by_cases h : ((n : ℝ) + 3)⁻¹ ≤ (state x n).2
      · -- a selection was made, and the remainder was at least the threshold
        simp [rem, state, nextDigit, h]
      · -- no selection: the previous remainder is non-negative
        simp [rem, state, nextDigit, h]
        simpa only [rem] using ih

/-- T3: on `[0,1]` the remainder is bounded by the current harmonic term,
`r_n(x) ≤ 1/(n+2)`. -/
theorem rem_bound {x : ℝ} (hx1 : x ≤ 1) (n : ℕ) :
    rem x n ≤ ((n : ℝ) + 2)⁻¹ := by
  induction n with
  | zero =>
      simp only [rem, state, digit0]
      split
      · norm_num
        linarith
      · norm_num
        linarith
  | succ n ih =>
      have hb : (state x n).2 ≤ ((n : ℝ) + 2)⁻¹ := by simpa only [rem] using ih
      have hcast : ((n : ℝ) + 1 + 2)⁻¹ = ((n : ℝ) + 3)⁻¹ := by
        congr 1
        ring
      by_cases h : ((n : ℝ) + 3)⁻¹ ≤ (state x n).2
      · -- a selection was made: subtract `1/(n+3)` from the previous remainder
        simp [rem, state, nextDigit, h]
        rw [hcast]
        have hstep : ((n : ℝ) + 2)⁻¹ - ((n : ℝ) + 3)⁻¹
            = (((n : ℝ) + 2) * ((n : ℝ) + 3))⁻¹ := by
          field_simp
          ring
        have hle : (((n : ℝ) + 2) * ((n : ℝ) + 3))⁻¹
            ≤ ((n : ℝ) + 3)⁻¹ := by
          have hle' : 1 / (((n : ℝ) + 2) * ((n : ℝ) + 3))
              ≤ 1 / ((n : ℝ) + 3) := by
            apply one_div_le_one_div_of_le (by positivity)
            nlinarith [show (0 : ℝ) ≤ (n : ℝ) + 3 by positivity]
          simpa only [one_div] using hle' 
        linarith
      · -- no selection: the previous remainder is already below `1/(n+3)`
        simp [rem, state, nextDigit, h]
        rw [hcast]
        have hlt : (state x n).2 < ((n : ℝ) + 3)⁻¹ := lt_of_not_ge h
        linarith

/-- T4: the finite greedy partial-sum identity
`x = Σ_{k=0}^{N} δ_k(x)/(k+2) + r_N(x)`. -/
theorem finite_identity (x : ℝ) (N : ℕ) :
    x = (∑ k ∈ Finset.range (N + 1), (delta x k : ℝ) / ((k : ℝ) + 2)) + rem x N := by
  induction N with
  | zero =>
      rw [Finset.sum_range_one]
      simp only [delta, rem, state, digit0]
      split <;> norm_num
  | succ n ih =>
      have hstep : rem x (n + 1)
          = rem x n - (delta x (n + 1) : ℝ) * ((n : ℝ) + 3)⁻¹ := by
        by_cases h : ((n : ℝ) + 3)⁻¹ ≤ (state x n).2 <;>
          simp [rem, delta, state, nextDigit, h]
      rw [Finset.sum_range_succ, hstep]
      have hcast : (((n + 1 : ℕ) : ℝ) + 2) = (n : ℝ) + 3 := by
        push_cast
        ring
      rw [hcast]
      have hdiv : (delta x (n + 1) : ℝ) / ((n : ℝ) + 3)
          = (delta x (n + 1) : ℝ) * ((n : ℝ) + 3)⁻¹ := by ring
      rw [hdiv]
      linarith [ih]

/-- T5: after a selection at index `n+1` the remainder satisfies the
quadratic bound `r_{n+1}(x) ≤ 1/((n+2)(n+3))`. -/
theorem rem_after_selection {x : ℝ} (hx1 : x ≤ 1) (n : ℕ)
    (hsel : delta x (n + 1) = 1) :
    rem x (n + 1) ≤ (((n : ℝ) + 2) * ((n : ℝ) + 3))⁻¹ := by
  have hstep : rem x (n + 1)
      = rem x n - (delta x (n + 1) : ℝ) * ((n : ℝ) + 3)⁻¹ := by
    by_cases h : ((n : ℝ) + 3)⁻¹ ≤ (state x n).2 <;>
      simp [rem, delta, state, nextDigit, h]
  have hb : (state x n).2 ≤ ((n : ℝ) + 2)⁻¹ := by
    simpa only [rem] using rem_bound hx1 n
  rw [hstep, hsel]
  simp only [rem] at hb ⊢
  have heq : ((n : ℝ) + 2)⁻¹ - ((n : ℝ) + 3)⁻¹
      = (((n : ℝ) + 2) * ((n : ℝ) + 3))⁻¹ := by
    field_simp
    ring
  linarith

/-- T6: the selected and rejected finite series partition the Dirichlet
prefix: `E_N(x,s) + Ω_N(x,s) = Σ_{k≤N} (k+2)^{-s}`. -/
theorem selected_add_rejected (x : ℝ) (s : ℝ) (N : ℕ) :
    selectedWeight x s N + rejectedWeight x s N = dirichletPrefix s N := by
  unfold selectedWeight rejectedWeight dirichletPrefix
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl ?_
  intro k _
  rcases delta_zero_or_one x k with h | h <;> simp [h]

/-- T7: both finite series are non-negative. -/
theorem selected_rejected_nonneg (x : ℝ) (s : ℝ) (N : ℕ) :
    0 ≤ selectedWeight x s N ∧ 0 ≤ rejectedWeight x s N := by
  constructor
  · unfold selectedWeight
    refine Finset.sum_nonneg ?_
    intro k _
    split
    · exact Real.rpow_nonneg (by positivity) _
    · exact le_refl (0 : ℝ)
  · unfold rejectedWeight
    refine Finset.sum_nonneg ?_
    intro k _
    split
    · exact Real.rpow_nonneg (by positivity) _
    · exact le_refl (0 : ℝ)

end GDST
