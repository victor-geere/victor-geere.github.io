import Mathlib
import QuadraticInt.ZsqrtdTwo

/-!
# The ring of integers of `ℚ(√−2)` is `ℤ[√−2]`

The `d = 2` analogue of [`../GaussianInt/RingOfIntegers.lean`](../GaussianInt/RingOfIntegers.lean),
using the same route:

* `ℚ(√−2) = AdjoinRoot (X² + 2)`;
* `ℤ[√−2] ↪ ℚ(√−2)` is injective, and `ℚ(√−2)` is its fraction field (rational
  coordinates plus a common denominator);
* `ℤ[√−2]` is integrally closed (`QuadraticInt.ZsqrtdTwo.instIsIntegrallyClosed`,
  from the norm-Euclidean structure) and module-finite over `ℤ`.

Hence `IsIntegralClosure (Zsqrtd (-2)) ℤ QS2`, and
`NumberField.RingOfIntegers.equiv` gives the bridge

`ringOfIntegersEquiv_two : 𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open Polynomial

namespace ZsqrtdTwo

/-- `X² + 2` is irreducible over `ℚ`. -/
theorem irreducible_X_sq_add_two : Irreducible (X ^ 2 + 2 : Polynomial ℚ) := by
  apply irreducible_of_degree_le_three_of_not_isRoot
  · rw [show (2 : Polynomial ℚ) = C 2 from (Polynomial.C_eq_natCast 2).symm,
      natDegree_X_pow_add_C]
    simp
  · intro x hx
    rw [IsRoot, eval_add, eval_pow, eval_X] at hx
    norm_num at hx
    nlinarith [sq_nonneg x]

/-- `ℚ(√−2) = ℚ[X]/(X² + 2)`. -/
abbrev QS2 : Type := AdjoinRoot (X ^ 2 + 2 : Polynomial ℚ)

instance : Fact (Irreducible (X ^ 2 + 2 : Polynomial ℚ)) :=
  ⟨irreducible_X_sq_add_two⟩

/-- The class of `X`, i.e. `√−2`, in `ℚ(√−2)`. -/
def sqrt2 : QS2 := AdjoinRoot.root (X ^ 2 + 2 : Polynomial ℚ)

lemma sqrt2_sq_add_two : sqrt2 ^ 2 + 2 = 0 := by
  have h := AdjoinRoot.eval₂_root (X ^ 2 + 2 : Polynomial ℚ)
  simpa [sqrt2] using h

lemma sqrt2_mul_self : sqrt2 * sqrt2 = -2 := by
  linear_combination sqrt2_sq_add_two

lemma natDegree_f2 : (X ^ 2 + 2 : Polynomial ℚ).natDegree = 2 := by
  rw [show (2 : Polynomial ℚ) = C 2 from (Polynomial.C_eq_natCast 2).symm,
    natDegree_X_pow_add_C]

lemma f2_ne_zero : (X ^ 2 + 2 : Polynomial ℚ) ≠ 0 := by
  intro h
  have h0 : (X ^ 2 + 2 : Polynomial ℚ).natDegree = 0 := by rw [h, natDegree_zero]
  rw [natDegree_f2] at h0
  exact absurd h0 (by norm_num)

lemma pb_dim2 :
    (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 2 : Polynomial ℚ)) f2_ne_zero).dim = 2 := by
  rw [AdjoinRoot.powerBasis_dim, natDegree_f2]

/-- The `ℚ`-basis `{1, √−2}` of `ℚ(√−2)`. -/
noncomputable def pb2b : Module.Basis (Fin 2) ℚ QS2 :=
  ((AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 2 : Polynomial ℚ)) f2_ne_zero).basis).reindex
    (finCongr pb_dim2)

lemma pb2b_zero : pb2b 0 = 1 := by
  rw [pb2b, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [finCongr, AdjoinRoot.powerBasis_gen]

lemma pb2b_one : pb2b 1 = sqrt2 := by
  rw [pb2b, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [sqrt2, finCongr, AdjoinRoot.powerBasis_gen]

/-- Every element of `ℚ(√−2)` is `a + b·√−2` with `a`, `b` rational. -/
lemma coord_eq2 (z : QS2) :
    z = algebraMap ℚ QS2 (pb2b.repr z 0) + algebraMap ℚ QS2 (pb2b.repr z 1) * sqrt2 := by
  have h := pb2b.sum_repr z
  rw [Fin.sum_univ_two] at h
  conv_lhs => rw [← h]
  conv_lhs => rw [pb2b_zero, pb2b_one]
  rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one, smul_mul_assoc, one_mul]

/-- `ℚ(√−2)` is two-dimensional over `ℚ`. -/
lemma finrank_QS2 : Module.finrank ℚ QS2 = 2 := by
  rw [PowerBasis.finrank
      (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + 2 : Polynomial ℚ)) f2_ne_zero),
    AdjoinRoot.powerBasis_dim, natDegree_f2]

/-- The canonical ring map `ℤ[√−2] → ℚ(√−2)`. -/
noncomputable def toQS2 : R2 →+* QS2 :=
  Zsqrtd.lift ⟨sqrt2, by rw [sqrt2_mul_self]; norm_num⟩

/-- `toQS2` on coordinates: `m + n·√−2`. -/
@[simp]
lemma toQS2_mk (m n : ℤ) : toQS2 (⟨m, n⟩ : R2) = (m : QS2) + (n : QS2) * sqrt2 := by
  simp [toQS2]

lemma toQS2_injective : Function.Injective toQS2 := by
  apply Zsqrtd.lift_injective
  intro n hn
  nlinarith [sq_nonneg n]

instance instAlgebraQS2 : Algebra R2 QS2 := toQS2.toAlgebra

lemma algebraMap_QS2_eq_toQS2 : (algebraMap R2 QS2) = toQS2 := rfl

instance : FaithfulSMul R2 QS2 :=
  (faithfulSMul_iff_algebraMap_injective _ _).mpr toQS2_injective

instance : IsScalarTower ℤ R2 QS2 := by
  refine IsScalarTower.of_algebraMap_eq (fun r => ?_)
  show (algebraMap ℤ QS2) r = (algebraMap R2 QS2) ((algebraMap ℤ R2) r)
  simp

lemma algebraMap_eq_div_den2 (q : ℚ) :
    algebraMap ℚ QS2 q = ((q.num : ℤ) : QS2) / ((q.den : ℤ) : QS2) := by
  conv_lhs => rw [← Rat.num_div_den q]
  rw [map_div₀]
  push_cast
  rfl

lemma exists_div2 (z : QS2) : ∃ x y : R2, z = toQS2 x / toQS2 y := by
  set a := pb2b.repr z 0
  set b := pb2b.repr z 1
  refine ⟨⟨(a.num : ℤ) * (b.den : ℤ), (b.num : ℤ) * (a.den : ℤ)⟩,
    ⟨(a.den : ℤ) * (b.den : ℤ), 0⟩, ?_⟩
  have hy : toQS2 (⟨(a.den : ℤ) * (b.den : ℤ), 0⟩ : R2) ≠ 0 := by
    rw [toQS2_mk]
    norm_num
  rw [eq_div_iff hy, coord_eq2 z, algebraMap_eq_div_den2 a, algebraMap_eq_div_den2 b]
  rw [toQS2_mk, toQS2_mk]
  push_cast
  field_simp
  ring

/-- **`ℚ(√−2)` is the fraction field of `ℤ[√−2]`.** -/
instance : IsFractionRing R2 QS2 :=
  IsFractionRing.of_field (R := R2) (K := QS2) exists_div2

/-- **`ℤ[√−2]` is integrally closed in `ℚ(√−2)`.** -/
instance instIsIntegralClosure2 : IsIntegralClosure R2 ℤ QS2 :=
  haveI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  haveI : Algebra.IsIntegral ℤ R2 := Algebra.IsIntegral.of_finite ℤ R2
  IsIntegralClosure.of_isIntegrallyClosed R2 ℤ QS2

/-- **The `d = 2` bridge:** the ring of integers of `ℚ(√−2)` is `ℤ[√−2]`. -/
noncomputable def ringOfIntegersEquiv_two : NumberField.RingOfIntegers QS2 ≃+* R2 :=
  @NumberField.RingOfIntegers.equiv QS2 _ R2 _ instAlgebraQS2 instIsIntegralClosure2

end ZsqrtdTwo
