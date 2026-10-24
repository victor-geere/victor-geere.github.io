import Mathlib

/-!
# General nonnegative matrix-product no-go

A finite matrix product of entrywise nonnegative matrices is entrywise
nonnegative. Consequently any contraction with nonnegative boundary vectors is
nonnegative. This rules out the entire nonnegative transfer-matrix class as a
representation of the `N = 2` polygon at `s = -1`, where the value is `-2`.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Product of a list of matrices, in list order. -/
def matProd : List (Matrix ι ι ℝ) → Matrix ι ι ℝ
  | [] => 1
  | A :: As => A * matProd As

/-- A product of entrywise nonnegative matrices is entrywise nonnegative. -/
theorem matProd_nonneg (L : List (Matrix ι ι ℝ))
    (h : ∀ A ∈ L, ∀ i j, 0 ≤ A i j) :
    ∀ i j, 0 ≤ matProd L i j := by
  induction L with
  | nil =>
      intro i j
      rw [matProd, Matrix.one_apply]
      by_cases hij : i = j <;> simp [hij]
  | cons A As ih =>
      intro i j
      rw [matProd, Matrix.mul_apply]
      exact Finset.sum_nonneg fun k _ =>
        mul_nonneg (h A (by simp) i k)
          (ih (fun B hB => h B (by simp [hB])) k j)

/-- Contraction of a matrix with two boundary vectors. -/
def contraction (u w : ι → ℝ) (P : Matrix ι ι ℝ) : ℝ :=
  ∑ i, ∑ j, u i * P i j * w j

/-- A nonnegative matrix product contracted with nonnegative boundary vectors
is nonnegative. -/
theorem contraction_nonneg (L : List (Matrix ι ι ℝ)) (u w : ι → ℝ)
    (hL : ∀ A ∈ L, ∀ i j, 0 ≤ A i j)
    (hu : ∀ i, 0 ≤ u i) (hw : ∀ j, 0 ≤ w j) :
    0 ≤ contraction u w (matProd L) := by
  unfold contraction
  exact Finset.sum_nonneg fun i _ =>
    Finset.sum_nonneg fun j _ =>
      mul_nonneg (mul_nonneg (hu i) (matProd_nonneg L hL i j)) (hw j)

/-- No nonnegative matrix-product contraction can represent a negative value. -/
theorem no_nonneg_matrix_product_rep_of_neg {v : ℝ} (hv : v < 0) :
    ¬ ∃ (L : List (Matrix ι ι ℝ)) (u w : ι → ℝ),
      (∀ A ∈ L, ∀ i j, 0 ≤ A i j) ∧
      (∀ i, 0 ≤ u i) ∧ (∀ j, 0 ≤ w j) ∧
      contraction u w (matProd L) = v := by
  rintro ⟨L, u, w, hL, hu, hw, hrep⟩
  have hnonneg : 0 ≤ contraction u w (matProd L) :=
    contraction_nonneg L u w hL hu hw
  linarith

/-- The `N = 2` polygon at `s = -1`, written out from the filter coefficients
`(1, -1, 1, -1)`: `1 - 2 + 3 - 4 = -2`. -/
def etaTwoNegOne : ℝ := (1 : ℝ) * 1 + (-1) * 2 + 1 * 3 + (-1) * 4

theorem etaTwoNegOne_eq : etaTwoNegOne = -2 := by
  unfold etaTwoNegOne
  norm_num

/-- No nonnegative matrix product of any finite bond dimension, contracted with
nonnegative boundary vectors, can represent the `N = 2` polygon at `s = -1`. -/
theorem no_nonneg_matrix_product_rep_eta_two :
    ¬ ∃ (L : List (Matrix ι ι ℝ)) (u w : ι → ℝ),
      (∀ A ∈ L, ∀ i j, 0 ≤ A i j) ∧
      (∀ i, 0 ≤ u i) ∧ (∀ j, 0 ≤ w j) ∧
      contraction u w (matProd L) = etaTwoNegOne := by
  rw [etaTwoNegOne_eq]
  exact no_nonneg_matrix_product_rep_of_neg (by norm_num)

end GeoDQPT
