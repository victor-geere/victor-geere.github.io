import Mathlib

/-!
# Gaussian integers: basis, norm, units, and element/ideal counting

Standalone, Mathlib-only extraction of the Gaussian-integer development that
lives in `Topic.lean` (declarations T125–T136).  Nothing here refers to the QEFE
ledger, the Egyptian-denominator material, or any `r2`-style representation
count; the reusable content is the norm API, the unit action, and the `4`-to-`1`
correspondence between norm-`n` elements and ideals of norm `n`.

The extracted tree is:

* `GaussianInt.Norm`            — this file;
* `GaussianInt.IdealCount`      — splitting, local counts, multiplicativity;
* `GaussianInt.TwoSquares`      — the `ArithmeticFunction` assembly and corollaries;
* `GaussianInt.QuadraticField`  — `ℚ(i)` and the embedding `ℤ[i] ↪ ℚ(i)`;
* `GaussianInt.RingOfIntegers`  — the bridge `𝓞 (ℚ(i)) ≃+* ℤ[i]`.
-/

noncomputable section

namespace GaussianInt

/-! ## Gaussian integers: basis, algebra norm, and ideal norm -/

def gaussianVec : Fin 2 → GaussianInt
  | 0 => 1
  | 1 => ⟨0, 1⟩

lemma gaussianVec_zero : gaussianVec 0 = 1 := rfl
lemma gaussianVec_one : gaussianVec 1 = (⟨0, 1⟩ : GaussianInt) := rfl

lemma gaussianVec_linearIndependent : LinearIndependent ℤ gaussianVec := by
  have h : gaussianVec = ![(1:GaussianInt), (⟨0,1⟩ : GaussianInt)] := by
    funext i
    fin_cases i <;> rfl
  rw [h, LinearIndependent.pair_iff]
  intro s t hst
  have hre := congr_arg Zsqrtd.re hst
  have him := congr_arg Zsqrtd.im hst
  simp at hre him
  omega

lemma gaussianVec_span : ⊤ ≤ Submodule.span ℤ (Set.range gaussianVec) := by
  intro x hx
  rw [Submodule.mem_span_range_iff_exists_fun]
  refine ⟨fun i : Fin 2 => if i = 0 then x.re else x.im, ?_⟩
  rw [Fin.sum_univ_two]
  simp [gaussianVec_zero, gaussianVec_one]
  ext <;> simp

noncomputable def gaussianBasis : Module.Basis (Fin 2) ℤ GaussianInt :=
  Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span

lemma gaussianBasis_apply_zero : gaussianBasis (0 : Fin 2) = (1 : GaussianInt) := by
  rw [show gaussianBasis = Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span from rfl,
    Module.Basis.mk_apply]
  rfl

lemma gaussianBasis_apply_one : gaussianBasis (1 : Fin 2) = (⟨0, 1⟩ : GaussianInt) := by
  rw [show gaussianBasis = Module.Basis.mk gaussianVec_linearIndependent gaussianVec_span from rfl,
    Module.Basis.mk_apply]
  rfl

lemma repr_gaussian_zero (z : GaussianInt) : gaussianBasis.repr z 0 = z.re := by
  have h : z = z.re • gaussianBasis 0 + z.im • gaussianBasis 1 := by
    rw [gaussianBasis_apply_zero, gaussianBasis_apply_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [gaussianBasis_apply_zero, gaussianBasis_apply_one]

lemma repr_gaussian_one (z : GaussianInt) : gaussianBasis.repr z 1 = z.im := by
  have h : z = z.re • gaussianBasis 0 + z.im • gaussianBasis 1 := by
    rw [gaussianBasis_apply_zero, gaussianBasis_apply_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [gaussianBasis_apply_zero, gaussianBasis_apply_one]

/-- **T125:** the algebra norm of a Gaussian integer is its `Zsqrtd.norm`. -/
lemma algebra_norm_gaussian (z : GaussianInt) : Algebra.norm ℤ z = z.norm := by
  rw [Algebra.norm_eq_matrix_det gaussianBasis z]
  have hmat : Algebra.leftMulMatrix gaussianBasis z = !![z.re, -z.im; z.im, z.re] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Algebra.leftMulMatrix_eq_repr_mul, gaussianBasis_apply_zero,
        gaussianBasis_apply_one, repr_gaussian_zero, repr_gaussian_one, mul_one]
  rw [hmat]
  simp only [Matrix.det_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one]
  rw [Zsqrtd.norm_def]
  ring

/-- **T126:** the ideal norm of the principal ideal `(z)` is `z.norm.natAbs`. -/
lemma absNorm_span_gaussian (z : GaussianInt) :
    Ideal.absNorm (Ideal.span {z}) = z.norm.natAbs := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  rw [Ideal.absNorm_span_singleton]
  congr 1
  exact algebra_norm_gaussian z


/-! ## Gaussian units -/

lemma gaussian_unit_norm_eq_one (u : GaussianIntˣ) :
    (u : GaussianInt).norm = 1 := by
  have h := (Zsqrtd.norm_eq_one_iff (x := (u : GaussianInt))).mpr u.isUnit
  have habs := GaussianInt.abs_natCast_norm (u : GaussianInt)
  rw [← habs, h]
  norm_num

/-- **T127:** every Gaussian unit is one of `1, -1, i, -i`. -/
lemma gaussian_unit_classification (u : GaussianIntˣ) :
    (u : GaussianInt) = 1 ∨ (u : GaussianInt) = -1 ∨
      (u : GaussianInt) = ⟨0, 1⟩ ∨ (u : GaussianInt) = ⟨0, -1⟩ := by
  have hnorm := gaussian_unit_norm_eq_one u
  rw [Zsqrtd.norm_def] at hnorm
  have hre1 : -1 ≤ (u : GaussianInt).re := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have hre2 : (u : GaussianInt).re ≤ 1 := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have him1 : -1 ≤ (u : GaussianInt).im := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  have him2 : (u : GaussianInt).im ≤ 1 := by
    nlinarith [sq_nonneg ((u : GaussianInt).re), sq_nonneg ((u : GaussianInt).im)]
  interval_cases h1 : (u : GaussianInt).re <;> interval_cases h2 : (u : GaussianInt).im
  all_goals simp_all
  case «-1».«0» => right; left; ext <;> simp_all
  case «0».«-1» => right; right; right; ext <;> simp_all
  case «0».«1» => right; right; left; ext <;> simp_all
  case «1».«0» => left; ext <;> simp_all

def gaussianIUnit : GaussianIntˣ :=
  ⟨⟨0, 1⟩, ⟨0, -1⟩, by ext <;> simp, by ext <;> simp⟩

def gaussianNegIUnit : GaussianIntˣ :=
  ⟨⟨0, -1⟩, ⟨0, 1⟩, by ext <;> simp, by ext <;> simp⟩

def gaussianUnits : Finset GaussianIntˣ :=
  {1, -1, gaussianIUnit, gaussianNegIUnit}

lemma mem_gaussianUnits (u : GaussianIntˣ) : u ∈ gaussianUnits := by
  rcases gaussian_unit_classification u with h | h | h | h
  · have hu : u = (1 : GaussianIntˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = (-1 : GaussianIntˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = gaussianIUnit := Units.ext (by simpa [gaussianIUnit] using h)
    rw [hu]; simp [gaussianUnits]
  · have hu : u = gaussianNegIUnit := Units.ext (by simpa [gaussianNegIUnit] using h)
    rw [hu]; simp [gaussianUnits]

def unitsEquivSubtype : GaussianIntˣ ≃ {x : GaussianIntˣ // x ∈ gaussianUnits} where
  toFun u := ⟨u, mem_gaussianUnits u⟩
  invFun x := x.1
  left_inv _ := rfl
  right_inv x := by
    obtain ⟨u, hu⟩ := x
    exact Subtype.ext rfl

/-- **T128:** the Gaussian unit group has cardinality four. -/
lemma gaussianUnits_card_four : Nat.card GaussianIntˣ = 4 := by
  rw [Nat.card_congr unitsEquivSubtype]
  letI : Fintype {x : GaussianIntˣ // x ∈ gaussianUnits} :=
    Fintype.subtype gaussianUnits (fun x => Iff.rfl)
  rw [Nat.card_eq_fintype_card]
  have h : Fintype.card {x : GaussianIntˣ // x ∈ gaussianUnits} = gaussianUnits.card := by
    rw [← Finset.card_attach]
    rfl
  rw [h]
  decide


/-! ## Counting Gaussian integers of a given norm -/

lemma gaussian_norm_mk (x y : ℤ) : (⟨x, y⟩ : GaussianInt).norm = x^2 + y^2 := by
  rw [Zsqrtd.norm_def]
  ring

def pairToGaussian (n : ℕ) :
    {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} → {z : GaussianInt // z.norm.natAbs = n}
  | ⟨⟨x, y⟩, h⟩ => ⟨⟨x, y⟩, by
      rw [gaussian_norm_mk, h, Int.natAbs_natCast]⟩

def gaussianToPair (n : ℕ) :
    {z : GaussianInt // z.norm.natAbs = n} → {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)}
  | ⟨z, hz⟩ => ⟨(z.re, z.im), by
      have hnonneg : 0 ≤ z.norm := Zsqrtd.norm_nonneg (by norm_num) z
      have hcast : ((z.norm.natAbs : ℤ)) = z.norm := by
        rw [GaussianInt.abs_natCast_norm]
      change z.re ^ 2 + z.im ^ 2 = (n:ℤ)
      have hnorm : z.norm = (n:ℤ) := by
        rw [← hcast, hz]
      rw [Zsqrtd.norm_def] at hnorm
      linarith⟩

lemma gaussianToPair_pairToGaussian (n : ℕ) (p : {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)}) :
    gaussianToPair n (pairToGaussian n p) = p := by
  obtain ⟨⟨x, y⟩, h⟩ := p
  rfl

lemma pairToGaussian_gaussianToPair (n : ℕ) (z : {z : GaussianInt // z.norm.natAbs = n}) :
    pairToGaussian n (gaussianToPair n z) = z := by
  obtain ⟨⟨x, y⟩, hz⟩ := z
  rfl

def pairGaussianEquiv (n : ℕ) :
    {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} ≃ {z : GaussianInt // z.norm.natAbs = n} where
  toFun := pairToGaussian n
  invFun := gaussianToPair n
  left_inv := gaussianToPair_pairToGaussian n
  right_inv := pairToGaussian_gaussianToPair n

/-- **T130:** a norm-`n` Gaussian integer generates an ideal of norm `n`. -/
lemma absNorm_span_gaussian_of_norm (n : ℕ) (z : GaussianInt)
    (hz : z.norm.natAbs = n) : Ideal.absNorm (Ideal.span {z}) = n := by
  rw [absNorm_span_gaussian, hz]

/-- **T131:** two Gaussian integers generate the same principal ideal iff they
are associates. -/
lemma gaussian_span_eq_iff_associated (x y : GaussianInt) :
    Ideal.span ({x} : Set GaussianInt) = Ideal.span ({y} : Set GaussianInt) ↔
      Associated x y :=
  Ideal.span_singleton_eq_span_singleton


/-! ## Free unit action on norm-`n` Gaussian integers -/

abbrev NormElements (n : ℕ) := {z : GaussianInt // z.norm.natAbs = n}

def normElementsSmul (n : ℕ) (u : GaussianIntˣ) (z : NormElements n) : NormElements n :=
  ⟨(u : GaussianInt) * z.val, by
    rw [Zsqrtd.norm_mul, Int.natAbs_mul, gaussian_unit_norm_eq_one u, z.2]
    norm_num⟩

@[simp]
lemma normElementsSmul_def (n : ℕ) (u : GaussianIntˣ) (z : NormElements n) :
    (normElementsSmul n u z).val = (u : GaussianInt) * z.val := rfl

instance normElementsMulAction (n : ℕ) : MulAction GaussianIntˣ (NormElements n) where
  smul := normElementsSmul n
  one_smul z := by
    apply Subtype.ext
    change (normElementsSmul n 1 z).val = z.val
    rw [normElementsSmul_def]
    simp
  mul_smul u v z := by
    apply Subtype.ext
    change (normElementsSmul n (u * v) z).val = (normElementsSmul n u (normElementsSmul n v z)).val
    rw [normElementsSmul_def, normElementsSmul_def, normElementsSmul_def]
    simp [mul_assoc]

lemma normElements_ne_zero (n : ℕ) (hn : 0 < n) (z : NormElements n) :
    z.val ≠ 0 := by
  intro h
  have hz := z.2
  rw [h] at hz
  simp at hz
  omega

/-- **T132:** the Gaussian unit action on norm-`n` elements is free for `n > 0`. -/
lemma normElements_smul_eq_self_iff (n : ℕ) (hn : 0 < n) (u : GaussianIntˣ)
    (z : NormElements n) : u • z = z ↔ u = 1 := by
  constructor
  · intro h
    have hz : z.val ≠ 0 := normElements_ne_zero n hn z
    have hval : (u : GaussianInt) * z.val = z.val := by
      have := congr_arg Subtype.val h
      change (normElementsSmul n u z).val = z.val at this
      rwa [normElementsSmul_def] at this
    have h1 : (u : GaussianInt) * z.val = (1 : GaussianInt) * z.val := by
      simpa using hval
    have hu : (u : GaussianInt) = 1 := mul_right_cancel₀ hz h1
    exact Units.ext hu
  · intro h
    rw [h]
    exact one_smul _ _


/-! ## The 4-to-1 generator/ideal correspondence -/

instance gaussianUnitsFintype : Fintype GaussianIntˣ := by
  letI : Fintype {x : GaussianIntˣ // x ∈ gaussianUnits} :=
    Fintype.subtype gaussianUnits (fun x => Iff.rfl)
  exact Fintype.ofEquiv _ unitsEquivSubtype.symm

lemma gaussianUnits_fintype_card : Fintype.card GaussianIntˣ = 4 := by
  rw [← Nat.card_eq_fintype_card]
  exact gaussianUnits_card_four

def fintype_pairs_norm (n : ℕ) : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n:ℤ)) (n:ℤ)).product (Finset.Icc (-(n:ℤ)) (n:ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1^2 + p.2^2 = (n:ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
  have hsub : {p : ℤ × ℤ | p.1^2 + p.2^2 = (n:ℤ)} ⊆ {p | p ∈ S} := fun p hp => hfin p hp
  exact Fintype.ofFinset (S.filter (fun p => p.1^2 + p.2^2 = (n:ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)

def fintype_normElements (n : ℕ) : Fintype (NormElements n) :=
  letI : Fintype {p : ℤ × ℤ // p.1^2 + p.2^2 = (n:ℤ)} := fintype_pairs_norm n
  Fintype.ofEquiv _ (pairGaussianEquiv n)

/-- **T133:** Burnside count: `|NormElements n| = 4 * #orbits` for `n > 0`. -/
lemma normElements_card_eq_four_mul_orbits (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElements n) =
      4 * Nat.card (Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n))) := by
  letI : Fintype (NormElements n) := fintype_normElements n
  let Ω := Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n))
  letI : DecidableEq Ω := Classical.decEq Ω
  letI : Fintype Ω := Fintype.ofSurjective (Quotient.mk'' : NormElements n → Ω) Quotient.mk''_surjective
  have hburn := MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group
    GaussianIntˣ (NormElements n)
  have hsum : (∑ g : GaussianIntˣ, Fintype.card (MulAction.fixedBy (NormElements n) g)) =
      Fintype.card (NormElements n) := by
    rw [Finset.sum_eq_single (1 : GaussianIntˣ)]
    · refine Fintype.card_congr ?_
      refine ⟨fun x => x.val, fun x => ⟨x, ?_⟩, fun x => rfl, fun x => rfl⟩
      simp [MulAction.fixedBy]
    · intro g _ hg
      rw [Fintype.card_eq_zero_iff]
      refine ⟨fun x => ?_⟩
      exact hg ((normElements_smul_eq_self_iff n hn g x.val).mp x.2)
    · intro h
      simp at h
  rw [hsum, gaussianUnits_fintype_card] at hburn
  rw [Nat.card_eq_fintype_card, hburn]
  rw [Nat.card_eq_fintype_card]
  omega

def orbitToIdeal (n : ℕ) :
    Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) →
      {I : Ideal GaussianInt // Ideal.absNorm I = n} :=
  Quotient.lift
    (fun z : NormElements n => ⟨Ideal.span {z.val}, absNorm_span_gaussian_of_norm n z.val z.2⟩)
    (by
      intro z y hzy
      obtain ⟨g, hg⟩ := hzy
      have hval : z.val = (g : GaussianInt) * y.val := by
        have := congr_arg Subtype.val hg
        change (normElementsSmul n g y).val = z.val at this
        rw [normElementsSmul_def] at this
        exact this.symm
      have hAssoc : Associated y.val z.val := ⟨g, by rw [mul_comm, ← hval]⟩
      have hspan : Ideal.span {z.val} = Ideal.span {y.val} :=
        ((gaussian_span_eq_iff_associated y.val z.val).mpr hAssoc).symm
      exact Subtype.ext hspan)

def idealToOrbit (n : ℕ) :
    {I : Ideal GaussianInt // Ideal.absNorm I = n} →
      Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) :=
  fun I =>
    Quotient.mk'' ⟨Submodule.IsPrincipal.generator I.1, by
      letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
      have hspan : Ideal.span ({Submodule.IsPrincipal.generator I.1} : Set GaussianInt) = I.1 :=
        Ideal.span_singleton_generator I.1
      have h := I.2
      rw [← hspan] at h
      rw [absNorm_span_gaussian] at h
      exact h⟩

/-- **T134:** the orbit quotient of norm-`n` Gaussian integers is the set of ideals of norm `n`. -/
def orbitsEquivIdeals (n : ℕ) :
    Quotient (MulAction.orbitRel GaussianIntˣ (NormElements n)) ≃
      {I : Ideal GaussianInt // Ideal.absNorm I = n} where
  toFun := orbitToIdeal n
  invFun := idealToOrbit n
  left_inv q := by
    induction q using Quotient.ind with
    | _ z =>
      apply Quotient.sound
      letI : (Ideal.span ({z.val} : Set GaussianInt)).IsPrincipal :=
        IsPrincipalIdealRing.principal _
      have hspan := Ideal.span_singleton_generator (Ideal.span ({z.val} : Set GaussianInt))
      have hassoc : Associated z.val (Submodule.IsPrincipal.generator
          (Ideal.span ({z.val} : Set GaussianInt))) := by
        rw [← gaussian_span_eq_iff_associated, hspan]
      obtain ⟨u, hu⟩ := hassoc
      have hI : orbitToIdeal n (Quotient.mk'' z) =
          ⟨Ideal.span {z.val}, absNorm_span_gaussian_of_norm n z.val z.2⟩ := by
        apply Subtype.ext
        rw [orbitToIdeal, Quotient.lift_mk]
      refine ⟨u, ?_⟩
      rw [hI]
      apply Subtype.ext
      simp only [Subtype.coe_mk]
      change (u : GaussianInt) * z.val =
        Submodule.IsPrincipal.generator (Ideal.span ({z.val} : Set GaussianInt))
      rw [mul_comm, hu]
  right_inv I := by
    apply Subtype.ext
    letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
    exact Ideal.span_singleton_generator I.1

/-- **T135 / the 4-to-1 correspondence:** for `n > 0` there are four times as
many Gaussian integers of norm `n` as there are ideals of `ℤ[i]` of norm `n`. -/
theorem normElements_card_eq_four_mul_idealCount (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElements n) =
      4 * Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [normElements_card_eq_four_mul_orbits n hn]
  rw [Nat.card_congr (orbitsEquivIdeals n)]

end GaussianInt
