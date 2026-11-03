import Mathlib

/-!
# Finite Gram positivity for angular/annular test vectors

This file formalises the finite-dimensional positivity certificate used by the
angular/annular method.  It is deliberately independent of any particular
partition: the annular or sectorial vectors are an instance of the general
inner-product Gram matrix.

For a finite family of real vectors `v i` in an inner-product space, the Gram
matrix is

`G i j = ⟪v i, v j⟫`.

The associated quadratic form is the squared norm of the corresponding
weighted sum:

`∑ i, ∑ j, c i * G i j * c j = ‖∑ i, c i • v i‖ ^ 2 ≥ 0`.

This is the finite PSD statement.  It is not the analytic Weil positivity
statement; it is the exact finite algebra that any annular test-vector model
must satisfy.
-/

namespace AngularPartition

open scoped BigOperators

variable {ι E : Type*} [Fintype ι]
variable [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- The Gram matrix of a finite family of real vectors. -/
noncomputable def gramMatrix (v : ι → E) : Matrix ι ι ℝ :=
  Matrix.gram ℝ v

/-- The quadratic form of a Gram matrix. -/
noncomputable def gramQuad (v : ι → E) (c : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, c i * inner ℝ (v i) (v j) * c j

/-- **Gram quadratic form is a squared norm.**
`∑ᵢⱼ cᵢ cⱼ ⟪vᵢ,vⱼ⟫ = ‖∑ᵢ cᵢ • vᵢ‖²`.
-/
theorem gramQuad_eq_norm_sq (v : ι → E) (c : ι → ℝ) :
    gramQuad v c = ‖∑ i, c i • v i‖ ^ 2 := by
  rw [gramQuad, ← real_inner_self_eq_norm_sq]
  simp only [sum_inner, inner_sum, real_inner_smul_left, real_inner_smul_right]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  rw [real_inner_comm (v j) (v i)]
  ring

/-- **Finite Gram positivity.**
Every finite Gram matrix of an inner product is positive semidefinite:
the quadratic form is a squared norm.
-/
theorem gramQuad_nonneg (v : ι → E) (c : ι → ℝ) :
    0 ≤ gramQuad v c := by
  rw [gramQuad_eq_norm_sq]
  exact sq_nonneg _

/-- The matrix form of finite Gram positivity. -/
theorem gramMatrix_posSemidef (v : ι → E) :
    (gramMatrix v).PosSemidef := by
  simpa [gramMatrix] using Matrix.posSemidef_gram ℝ v

/-- **Annular specialization.**
If the vectors are the indicator functions of a finite measurable partition,
the Gram entry is the measure of the overlap.  This theorem records the
abstract form; the inner-product model is the content. -/
theorem gramMatrix_quadForm_nonneg (v : ι → E) (c : ι → ℝ) :
    0 ≤ ∑ i, ∑ j, c i * gramMatrix v i j * c j := by
  simpa [gramMatrix, Matrix.gram, gramQuad] using gramQuad_nonneg v c

end AngularPartition
