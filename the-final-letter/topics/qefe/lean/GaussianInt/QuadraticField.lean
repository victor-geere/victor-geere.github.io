import Mathlib
import GaussianInt.Norm

/-!
# The embedding `ℤ[i] → ℚ(i)` and coordinates in `ℚ(i)`

This file fixes a concrete presentation of `ℚ(i)` (as `AdjoinRoot (X² + 1)`
over `ℚ`, so that Mathlib's `NumberField` instance applies), defines the
`ℤ`-algebra map `ℤ[i] → ℚ(i)`, and proves it injective.  It also supplies the
coordinate decomposition `z = a + b·i` with `a b : ℚ` and the fact that
`ℚ(i)` is two-dimensional over `ℚ`.

Together these are the inputs to the ring-of-integers bridge, which is completed
in [`RingOfIntegers.lean`](RingOfIntegers.lean):

```lean
GaussianInt.ringOfIntegersEquiv : NumberField.RingOfIntegers QI ≃+* Zsqrtd (-1)
```

No `sorry`, `axiom` or `admit` is used anywhere in this file.
-/

noncomputable section

open Polynomial

namespace GaussianInt

/-- `X² + 1` is irreducible over `ℚ`. -/
theorem irreducible_X_sq_add_one : Irreducible (X ^ 2 + 1 : Polynomial ℚ) := by
  apply irreducible_of_degree_le_three_of_not_isRoot
  · rw [show (1 : Polynomial ℚ) = C 1 by simp, natDegree_X_pow_add_C]
    simp
  · intro x hx
    rw [IsRoot, eval_add, eval_pow, eval_X, eval_one] at hx
    nlinarith [sq_nonneg x]

/-- `ℚ(i)`, presented as `ℚ[X]/(X² + 1)`. This presentation is what makes
Mathlib's `Field` and `NumberField` instances available. -/
abbrev QI : Type := AdjoinRoot (X ^ 2 + 1 : Polynomial ℚ)

instance : Fact (Irreducible (X ^ 2 + 1 : Polynomial ℚ)) :=
  ⟨irreducible_X_sq_add_one⟩

/-- The class of `X`, i.e. `i`, in `ℚ(i)`. -/
def iRoot : QI := AdjoinRoot.root (X ^ 2 + 1 : Polynomial ℚ)

/-- `i² = -1` in `ℚ(i)`. -/
lemma iRoot_sq_add_one : iRoot ^ 2 + 1 = 0 := by
  have h := AdjoinRoot.eval₂_root (X ^ 2 + 1 : Polynomial ℚ)
  simp only [iRoot, eval₂_add, eval₂_pow, eval₂_X, eval₂_one] at h
  exact h

lemma iRoot_mul_self : iRoot * iRoot = -1 := by
  linear_combination iRoot_sq_add_one

/-- The canonical ring map `ℤ[i] → ℚ(i)` sending `√-1` to `i`. -/
noncomputable def toQI : Zsqrtd (-1) →+* QI :=
  Zsqrtd.lift ⟨iRoot, by rw [iRoot_mul_self]; norm_num⟩

@[simp]
lemma toQI_sqrtd : toQI Zsqrtd.sqrtd = iRoot := by
  simp [toQI]

/-- The embedding `ℤ[i] → ℚ(i)` is injective (this is `Zsqrtd.lift_injective`,
since `-1` is not a square in `ℤ`). -/
lemma toQI_injective : Function.Injective toQI := by
  apply Zsqrtd.lift_injective
  intro n hn
  nlinarith [sq_nonneg n]


/-! ## Coordinates in `ℚ(i)` and `ℚ`-dimension

The bridge proof needs to write an arbitrary `z : ℚ(i)` as `a + b·i` with
`a b : ℚ`, and to know that `ℚ(i)` is two-dimensional over `ℚ`.  Both are
packaged here, together with an explicit `ℚ`-basis `pb2` equal to `{1, i}`.
-/

lemma natDegree_f : (X ^ 2 + 1 : Polynomial ℚ).natDegree = 2 := by
  rw [show (1 : Polynomial ℚ) = C 1 by simp, natDegree_X_pow_add_C]

lemma f_ne_zero : (X ^ 2 + 1 : Polynomial ℚ) ≠ 0 := by
  intro h
  have h0 : (X ^ 2 + 1 : Polynomial ℚ).natDegree = 0 := by rw [h, natDegree_zero]
  rw [natDegree_f] at h0
  exact absurd h0 (by norm_num)

lemma pb_dim :
    (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 1 : Polynomial ℚ)) f_ne_zero).dim = 2 := by
  rw [AdjoinRoot.powerBasis_dim, natDegree_f]

/-- The `ℚ`-basis `{1, i}` of `ℚ(i)`, as a basis indexed by `Fin 2`. -/
noncomputable def pb2 : Module.Basis (Fin 2) ℚ QI :=
  ((AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 1 : Polynomial ℚ)) f_ne_zero).basis).reindex
    (finCongr pb_dim)

lemma pb2_zero : pb2 0 = 1 := by
  rw [pb2, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [finCongr, AdjoinRoot.powerBasis_gen]

lemma pb2_one : pb2 1 = iRoot := by
  rw [pb2, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [iRoot, finCongr, AdjoinRoot.powerBasis_gen]

/-- Every element of `ℚ(i)` is `a + b·i` with `a`, `b` rational. -/
lemma coord_eq (z : QI) :
    z = algebraMap ℚ QI (pb2.repr z 0) + algebraMap ℚ QI (pb2.repr z 1) * iRoot := by
  have h := pb2.sum_repr z
  rw [Fin.sum_univ_two] at h
  conv_lhs => rw [← h]
  conv_lhs => rw [pb2_zero, pb2_one]
  rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one, smul_mul_assoc, one_mul]

/-- `ℚ(i)` is two-dimensional over `ℚ`. -/
lemma finrank_QI : Module.finrank ℚ QI = 2 := by
  rw [PowerBasis.finrank
      (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 1 : Polynomial ℚ)) f_ne_zero),
    AdjoinRoot.powerBasis_dim, natDegree_f]

end GaussianInt
