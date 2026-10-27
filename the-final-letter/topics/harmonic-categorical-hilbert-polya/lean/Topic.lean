import Mathlib

/-!
# Harmonic–categorical Hilbert–Pólya — finite operator core

The archived source (`archive/maths/rh/research/harmonic-categorical-hilbert-polya/rh-proof.md`)
claims a Hilbert–Pólya proof of the Riemann Hypothesis.  This file does **not** formalise
that claim.  It formalises only the finite operator/spectral algebra on which the claimed
argument rests:

* the truncated greedy transfer operator of source equation (2),
* its upper-triangular structure and constant diagonal,
* the resulting finite determinant identities `det A_k = c^{k+1}` and
  `det (I - A_k) = (1 - c)^{k+1}`,
* the real splitting of the characteristic polynomial of a `2 × 2` real symmetric
  (Hermitian) matrix.

The infinite operator, its Fredholm determinant, the Hurwitz limit and RH itself are
recorded as source claims / open items in the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace HCHP

/-- The truncated diagonal weight
`c_σ(N) = ∑_{j=0}^{N-1} (j+1) / (j+2)^σ`. -/
def weight (σ : ℝ) (N : ℕ) : ℝ :=
  Finset.sum (Finset.range N) fun j => ((j : ℝ) + 1) / ((j : ℝ) + 2) ^ σ

/-- Source equation (2), truncated at `N` terms in the `j`-series.

`entry s N m n = binom(n,m) * c_{s+1+n-m}(N)` for `m ≤ n`, and `0` below the diagonal. -/
def entry (s : ℝ) (N m n : ℕ) : ℝ :=
  if m ≤ n then (Nat.choose n m : ℝ) * weight (s + 1 + (n - m)) N else 0

/-- The `(k+1) × (k+1)` truncation `A_k` of the greedy transfer operator. -/
def A (s : ℝ) (N k : ℕ) : Matrix (Fin (k + 1)) (Fin (k + 1)) ℝ :=
  fun i j => entry s N (i : ℕ) (j : ℕ)

/-- The truncated diagonal weight is positive whenever at least one term is present. -/
theorem weight_pos {σ : ℝ} {N : ℕ} (hN : 0 < N) : 0 < weight σ N := by
  unfold weight
  apply Finset.sum_pos
  · intro j _
    have h₁ : (0 : ℝ) < (j : ℝ) + 1 := by positivity
    have h₂ : (0 : ℝ) < (j : ℝ) + 2 := by positivity
    exact div_pos h₁ (Real.rpow_pos_of_pos h₂ σ)
  · exact ⟨0, Finset.mem_range.mpr hN⟩

/-- Below-diagonal entries of source equation (2) vanish: the truncation is upper triangular. -/
theorem entry_eq_zero_of_lt {s : ℝ} {N m n : ℕ} (h : n < m) : entry s N m n = 0 := by
  simp [entry, not_le.mpr h]

/-- The truncation `A_k` is upper triangular. -/
theorem A_upperTriangular (s : ℝ) (N k : ℕ) : (A s N k).IsUpperTriangular := by
  intro i j hij
  exact entry_eq_zero_of_lt (show (j : ℕ) < (i : ℕ) from hij)

/-- Every diagonal entry of `A_k` equals the same truncated weight `c_{s+1}(N)`;
the diagonal of source equation (2) does not depend on the row index. -/
theorem A_diag (s : ℝ) (N k : ℕ) (i : Fin (k + 1)) :
    A s N k i i = weight (s + 1) N := by
  have hle : (i : ℕ) ≤ (i : ℕ) := le_rfl
  have hsub : ((i : ℝ) - (i : ℝ)) = 0 := sub_self _
  have hchoose : ((Nat.choose (i : ℕ) (i : ℕ) : ℕ) : ℝ) = 1 := by simp
  unfold A entry
  rw [ite_eq_left hle, hsub, hchoose]
  norm_num

/-- Finite Fredholm determinant: `det A_k = c_{s+1}(N)^{k+1}`. -/
theorem det_A (s : ℝ) (N k : ℕ) :
    (A s N k).det = (weight (s + 1) N) ^ (k + 1) := by
  rw [Matrix.det_of_isUpperTriangular (A_upperTriangular s N k)]
  simp [A_diag, Finset.prod_const]

/-- The finite determinant of Lemma 4.1: `det (I - A_k) = (1 - c_{s+1}(N))^{k+1}`.
The upper-triangularity of `I - A_k` is proved inside the argument. -/
theorem det_one_sub_A (s : ℝ) (N k : ℕ) :
    (1 - A s N k).det = (1 - weight (s + 1) N) ^ (k + 1) := by
  have htri : (1 - A s N k).IsUpperTriangular := by
    intro i j hij
    have hji : (j : ℕ) < (i : ℕ) := hij
    have hne : i ≠ j := ne_of_gt hij
    have hzero : A s N k i j = 0 := entry_eq_zero_of_lt hji
    simp [Matrix.sub_apply, hne, hzero]
  rw [Matrix.det_of_isUpperTriangular htri]
  have hdiag : ∀ i : Fin (k + 1), (1 - A s N k) i i = 1 - weight (s + 1) N := by
    intro i
    simp [Matrix.sub_apply, A_diag]
  simp [hdiag, Finset.prod_const]

/-- The discriminant `(a-d)^2 + 4b^2` of a real symmetric `2 × 2` matrix. -/
def disc2 (a b d : ℝ) : ℝ := (a - d) ^ 2 + 4 * b ^ 2

/-- The characteristic polynomial of a real symmetric `2 × 2` matrix factors over `ℝ`
with the two real roots `(a+d ± √disc)/2`.  The non-negativity of the discriminant
`(a-d)^2 + 4b^2` is proved inside the argument. -/
theorem hermitian2_charpoly_splits (a b d : ℝ) :
    ∃ l₁ l₂ : ℝ, ∀ x : ℝ,
      (x - l₁) * (x - l₂) = x ^ 2 - (a + d) * x + (a * d - b ^ 2) := by
  have hnonneg : 0 ≤ disc2 a b d := by
    unfold disc2
    nlinarith [sq_nonneg (a - d), sq_nonneg b]
  refine ⟨(a + d + Real.sqrt (disc2 a b d)) / 2,
          (a + d - Real.sqrt (disc2 a b d)) / 2, ?_⟩
  intro x
  set r := Real.sqrt (disc2 a b d) with hr
  have hsq : r ^ 2 = (a - d) ^ 2 + 4 * b ^ 2 := by
    rw [hr, Real.sq_sqrt hnonneg]
    unfold disc2
    rfl
  have h1 : (x - (a + d + r) / 2) * (x - (a + d - r) / 2)
      = (x - (a + d) / 2) ^ 2 - (r / 2) ^ 2 := by ring
  have h2 : (r / 2) ^ 2 = ((a - d) ^ 2 + 4 * b ^ 2) / 4 := by
    rw [div_pow, hsq]
    norm_num
  rw [h1, h2]
  ring

end HCHP
