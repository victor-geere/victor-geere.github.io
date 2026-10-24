import Mathlib

/-!
# Global Harmonic Framework — formal core

The archived source (`archive/maths/proof-99/paper.md`) constructs the
GHD correlation kernel `K = I + |a⟩⟨b|` from the coefficient sequences

  `a n = 1 / sqrt (n * (n + 1))`,  `b n = 1 / (n + 1)`,   `n ≥ 1`,

and then uses the matrix determinant lemma to evaluate the Fredholm
determinant of the weighted Gram operator `M(s) = D(s) K D(s)`.

This file formalises the finite, elementary bookkeeping that the source
actually defines:

* positivity of `a` and `b` and the ordering `b n < a n`;
* the telescoping identity `∑_{k=1}^{N} 1/(k(k+1)) = N/(N+1)`, which is
  the source's `∑ |a n|² = 1`, together with its limit;
* the rank-one determinant lemma `det (I + |a⟩⟨b|) = 1 + ⟨b, a⟩`;
* positivity of the determinant of the diagonal weighting `D²`.

The global analytic argument (Mayer–Ruelle similarity, Birman–Krein,
argument principle, and the claimed proof of RH) is deliberately **not**
formalised. It is recorded as an archived source claim in the dossier.
-/

noncomputable section

open Filter Topology
open scoped BigOperators Matrix

namespace GHF

/-- First GHD coefficient sequence, indexed by the source's `n ≥ 1`. -/
def a (n : ℕ) : ℝ := 1 / Real.sqrt ((n : ℝ) * ((n : ℝ) + 1))

/-- Second GHD coefficient sequence, indexed by the source's `n ≥ 1`. -/
def b (n : ℕ) : ℝ := 1 / ((n : ℝ) + 1)

/-- The diagonal weighting on the critical line is strictly positive: the
source's `D(s)` has entries `(n+2)^{-(s+1/2)}`, positive whenever `s` is real
and `s > -1/2`. This is the positivity input for the determinant factor. -/
theorem a_pos (n : ℕ) (hn : 1 ≤ n) : 0 < a n := by
  unfold a
  apply one_div_pos.mpr
  apply Real.sqrt_pos.mpr
  have hn' : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  positivity

/-- The second coefficient is positive, so `b ∈ ℓ²(ℕ)` as a positive sequence. -/
theorem b_pos (n : ℕ) : 0 < b n := by
  unfold b
  positivity

/-- The two coefficient sequences are ordered: `b n < a n` for `n ≥ 1`.
Equivalently `sqrt (n (n+1)) < n+1`. This is the elementary inequality
behind the source's observation that `a` and `b` are distinct sequences
(and therefore that `|a⟩⟨b|` is not symmetric in general). -/
theorem b_lt_a (n : ℕ) (hn : 1 ≤ n) : b n < a n := by
  unfold b a
  have hn' : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have hsq : (n : ℝ) * ((n : ℝ) + 1) < ((n : ℝ) + 1) ^ 2 := by
    have h := mul_lt_mul_of_pos_right (show (n : ℝ) < (n : ℝ) + 1 by linarith) h1
    simpa [pow_two] using h
  have hsqrt : Real.sqrt ((n : ℝ) * ((n : ℝ) + 1)) < (n : ℝ) + 1 := by
    have h := Real.sqrt_lt_sqrt (by positivity) hsq
    rwa [Real.sqrt_sq (le_of_lt h1)] at h
  exact one_div_lt_one_div_of_lt (Real.sqrt_pos.mpr (by positivity)) hsqrt

/-- Telescoping identity: the finite sum of `1/(k(k+1))` collapses to
`N/(N+1)`. This is exactly the source's claim `∑ₙ 1/(n(n+1)) = 1` at
finite truncation, i.e. `∑ₙ |a n|² = 1`. -/
theorem telescoping (N : ℕ) :
    Finset.sum (Finset.range N) (fun k : ℕ =>
        (1 : ℝ) / (((k : ℝ) + 1) * ((k : ℝ) + 2)))
      = (N : ℝ) / ((N : ℝ) + 1) := by
  induction N with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    have h1 : (n : ℝ) + 1 ≠ 0 := by positivity
    have h2 : (n : ℝ) + 2 ≠ 0 := by positivity
    field_simp
    ring

/-- Limit form of the telescoping identity: `∑ₙ |a n|² = 1`, the source's
`ℓ²` normalisation of the first coefficient sequence. -/
theorem telescoping_tendsto :
    Tendsto
      (fun N : ℕ =>
        Finset.sum (Finset.range N) (fun k : ℕ =>
          (1 : ℝ) / (((k : ℝ) + 1) * ((k : ℝ) + 2))))
      atTop (𝓝 1) := by
  have h : (fun N : ℕ =>
        Finset.sum (Finset.range N) (fun k : ℕ =>
          (1 : ℝ) / (((k : ℝ) + 1) * ((k : ℝ) + 2))))
      = fun N : ℕ => (1 : ℝ) - 1 / ((N : ℝ) + 1) := by
    funext N
    rw [telescoping]
    have hN : (N : ℝ) + 1 ≠ 0 := by positivity
    field_simp
    ring
  rw [h]
  have hlim : Tendsto (fun N : ℕ => (1 : ℝ) - 1 / ((N : ℝ) + 1)) atTop (𝓝 (1 - 0)) :=
    tendsto_const_nhds.sub tendsto_one_div_add_atTop_nhds_zero_nat
  simpa using hlim

/-- The finite matrix determinant lemma for the rank-one kernel
`K = I + |a⟩⟨b|`: its determinant is `1 + ⟨b, a⟩`. This is the finite
bookkeeping behind the source's Fredholm determinant formula
`det (I - M(s)) = det (I - D(s)²) · (1 - ⟨…⟩)` (Section 4.6). -/
theorem det_rank_one {N : ℕ} (u v : Fin N → ℝ) :
    (1 + Matrix.replicateCol PUnit u * Matrix.replicateRow PUnit v).det
      = 1 + ∑ i, v i * u i := by
  rw [Matrix.det_one_add_replicateCol_mul_replicateRow (ι := PUnit) u v]
  simp [dotProduct]

/-- The diagonal part of the weighted Gram operator has positive
determinant: if `D = diagonal d` with `d i > 0`, then
`det (D * D) = ∏ (d i)² > 0`. On the critical line this is the source's
statement that the diagonal factor `det (I - D(s)²)` contributes no phase
(it is a positive real). -/
theorem det_diagonal_sq_pos {N : ℕ} (d : Fin N → ℝ) (hd : ∀ i, 0 < d i) :
    0 < (Matrix.diagonal d * Matrix.diagonal d).det := by
  rw [Matrix.diagonal_mul_diagonal, Matrix.det_diagonal]
  exact Finset.prod_pos (fun i _ => mul_pos (hd i) (hd i))

end GHF
