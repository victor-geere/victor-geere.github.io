import Mathlib
import QuadraticInt.Eisenstein

/-!
# The ring of integers of `ℚ(√−3)` is `ℤ[ω]`

The `d = 3` bridge, completing the pair of gates in
[`../../GENERALISATION-QI.md`](../../GENERALISATION-QI.md).  The route is the
same as for `ℚ(i)` and `ℚ(√−2)`:

* `ℚ(ω) = AdjoinRoot (X² + X + 1)`, with `ω² + ω + 1 = 0`;
* `ℤ[ω] ↪ ℚ(ω)` is injective, and `ℚ(ω)` is its fraction field;
* `ℤ[ω]` is integrally closed (`EisensteinInt.instIsIntegrallyClosed`, from the
  Euclidean structure) and module-finite over `ℤ` (basis `{1, ω}`).

Hence `IsIntegralClosure EisensteinInt ℤ QW`, and

`ringOfIntegersEquiv_three : 𝓞 (ℚ(√−3)) ≃+* EisensteinInt`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open Polynomial

namespace EisensteinInt

/-- `X² + X + 1` is irreducible over `ℚ`. -/
theorem irreducible_X_sq_add_X_add_one : Irreducible (X ^ 2 + X + 1 : Polynomial ℚ) := by
  apply irreducible_of_degree_le_three_of_not_isRoot
  · have h : ((X ^ 2 + X + 1 : Polynomial ℚ)).natDegree = 2 := by compute_degree!
    rw [h]; norm_num
  · intro x hx
    rw [IsRoot, eval_add, eval_add, eval_pow, eval_X, eval_one] at hx
    nlinarith [sq_nonneg (x + 1 / 2)]

/-- `ℚ(ω) = ℚ[X]/(X² + X + 1)`. -/
abbrev QW : Type := AdjoinRoot (X ^ 2 + X + 1 : Polynomial ℚ)

instance : Fact (Irreducible (X ^ 2 + X + 1 : Polynomial ℚ)) :=
  ⟨irreducible_X_sq_add_X_add_one⟩

/-- The class of `X`, i.e. `ω`, in `ℚ(ω)`. -/
def omegaK : QW := AdjoinRoot.root (X ^ 2 + X + 1 : Polynomial ℚ)

lemma omegaK_sq_add : omegaK ^ 2 + omegaK + 1 = 0 := by
  have h := AdjoinRoot.eval₂_root (X ^ 2 + X + 1 : Polynomial ℚ)
  simpa [omegaK] using h

lemma omegaK_sq : omegaK ^ 2 = -1 - omegaK := by
  linear_combination omegaK_sq_add

lemma natDegree_g : (X ^ 2 + X + 1 : Polynomial ℚ).natDegree = 2 := by
  compute_degree!

lemma g_ne_zero : (X ^ 2 + X + 1 : Polynomial ℚ) ≠ 0 := by
  intro h
  have h0 : (X ^ 2 + X + 1 : Polynomial ℚ).natDegree = 0 := by rw [h, natDegree_zero]
  rw [natDegree_g] at h0
  exact absurd h0 (by norm_num)

lemma pb_dim3 :
    (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + X + 1 : Polynomial ℚ)) g_ne_zero).dim = 2 := by
  rw [AdjoinRoot.powerBasis_dim, natDegree_g]

/-- The `ℚ`-basis `{1, ω}` of `ℚ(ω)`. -/
noncomputable def pb3 : Module.Basis (Fin 2) ℚ QW :=
  ((AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + X + 1 : Polynomial ℚ)) g_ne_zero).basis).reindex
    (finCongr pb_dim3)

lemma pb3_zero : pb3 0 = 1 := by
  rw [pb3, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [finCongr, AdjoinRoot.powerBasis_gen]

lemma pb3_one : pb3 1 = omegaK := by
  rw [pb3, Module.Basis.reindex_apply, PowerBasis.basis_eq_pow]
  simp [omegaK, finCongr, AdjoinRoot.powerBasis_gen]

/-- Every element of `ℚ(ω)` is `a + b·ω` with `a`, `b` rational. -/
lemma coord_eq3 (z : QW) :
    z = algebraMap ℚ QW (pb3.repr z 0) + algebraMap ℚ QW (pb3.repr z 1) * omegaK := by
  have h := pb3.sum_repr z
  rw [Fin.sum_univ_two] at h
  conv_lhs => rw [← h]
  conv_lhs => rw [pb3_zero, pb3_one]
  rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one, smul_mul_assoc, one_mul]

/-- `ℚ(ω)` is two-dimensional over `ℚ`. -/
lemma finrank_QW : Module.finrank ℚ QW = 2 := by
  rw [PowerBasis.finrank
      (AdjoinRoot.powerBasis (K := ℚ) (f := (X ^ 2 + X + 1 : Polynomial ℚ)) g_ne_zero),
    AdjoinRoot.powerBasis_dim, natDegree_g]

/-- The canonical ring map `ℤ[ω] → ℚ(ω)`. -/
noncomputable def toK : EisensteinInt →+* QW where
  toFun z := (z.re : QW) + (z.im : QW) * omegaK
  map_zero' := by simp
  map_one' := by simp
  map_add' := by intro z w; simp only [re_add, im_add]; push_cast; ring
  map_mul' := by
    intro z w
    simp only [re_mul, im_mul]
    push_cast
    ring_nf
    rw [show omegaK ^ 2 = -1 - omegaK from by linear_combination omegaK_sq_add]
    ring

/-- `{1, ω}` is `ℚ`-linearly independent in `ℚ(ω)`. -/
lemma linearIndependent_pb3 : LinearIndependent ℚ (![(1 : QW), omegaK] : Fin 2 → QW) := by
  have h : (![(1 : QW), omegaK] : Fin 2 → QW) = pb3 := by
    funext i; fin_cases i <;> simp [pb3_zero, pb3_one]
  rw [h]
  exact pb3.linearIndependent

lemma toK_injective : Function.Injective toK := by
  rw [injective_iff_map_eq_zero]
  intro z hz
  have hz' : (z.re : QW) + (z.im : QW) * omegaK = 0 := hz
  have hcomb : (z.re : ℚ) • (![(1 : QW), omegaK] : Fin 2 → QW) 0 +
      (z.im : ℚ) • (![(1 : QW), omegaK] : Fin 2 → QW) 1 = 0 := by
    simpa [Algebra.smul_def] using hz'
  have h2 := LinearIndependent.pair_iff.mp linearIndependent_pb3 (z.re : ℚ) (z.im : ℚ) hcomb
  have hre : z.re = 0 := by exact_mod_cast h2.1
  have him : z.im = 0 := by exact_mod_cast h2.2
  ext <;> simp [hre, him]

instance instAlgebraQW : Algebra EisensteinInt QW := toK.toAlgebra

lemma algebraMap_QW_eq_toK : (algebraMap EisensteinInt QW) = toK := rfl

instance : FaithfulSMul EisensteinInt QW :=
  (faithfulSMul_iff_algebraMap_injective _ _).mpr toK_injective

instance : IsScalarTower ℤ EisensteinInt QW := by
  refine IsScalarTower.of_algebraMap_eq (fun r => ?_)
  show (algebraMap ℤ QW) r = (algebraMap EisensteinInt QW) ((algebraMap ℤ EisensteinInt) r)
  simp

lemma algebraMap_eq_div_den3 (q : ℚ) :
    algebraMap ℚ QW q = ((q.num : ℤ) : QW) / ((q.den : ℤ) : QW) := by
  conv_lhs => rw [← Rat.num_div_den q]
  rw [map_div₀]
  push_cast
  rfl

lemma toK_mk (m n : ℤ) : toK (⟨m, n⟩ : EisensteinInt) = (m : QW) + (n : QW) * omegaK := rfl

lemma exists_div3 (z : QW) : ∃ x y : EisensteinInt, z = toK x / toK y := by
  set a := pb3.repr z 0
  set b := pb3.repr z 1
  refine ⟨⟨(a.num : ℤ) * (b.den : ℤ), (b.num : ℤ) * (a.den : ℤ)⟩,
    ⟨(a.den : ℤ) * (b.den : ℤ), 0⟩, ?_⟩
  have hy : toK (⟨(a.den : ℤ) * (b.den : ℤ), 0⟩ : EisensteinInt) ≠ 0 := by
    rw [toK_mk]
    norm_num
  rw [eq_div_iff hy, coord_eq3 z, algebraMap_eq_div_den3 a, algebraMap_eq_div_den3 b]
  rw [toK_mk, toK_mk]
  push_cast
  field_simp
  ring

/-- **`ℚ(ω)` is the fraction field of `ℤ[ω]`.** -/
instance : IsFractionRing EisensteinInt QW :=
  IsFractionRing.of_field (R := EisensteinInt) (K := QW) exists_div3

/-- **`ℤ[ω]` is integrally closed in `ℚ(ω)`.** -/
instance instIsIntegralClosure3 : IsIntegralClosure EisensteinInt ℤ QW :=
  haveI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  haveI : Algebra.IsIntegral ℤ EisensteinInt := Algebra.IsIntegral.of_finite ℤ EisensteinInt
  IsIntegralClosure.of_isIntegrallyClosed EisensteinInt ℤ QW

/-- **The `d = 3` bridge:** the ring of integers of `ℚ(√−3)` is `ℤ[ω]`. -/
noncomputable def ringOfIntegersEquiv_three : NumberField.RingOfIntegers QW ≃+* EisensteinInt :=
  @NumberField.RingOfIntegers.equiv QW _ EisensteinInt _ instAlgebraQW instIsIntegralClosure3

end EisensteinInt
