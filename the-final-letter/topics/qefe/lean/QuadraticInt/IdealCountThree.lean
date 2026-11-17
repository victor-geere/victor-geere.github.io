import Mathlib
import QuadraticInt.Eisenstein
import QuadraticInt.SplitThree

/-!
# The ideal count in `ℤ[ω]` (the `d = 3` counting development)

The Eisenstein analogues of `QuadraticInt/IdealCountTwo.lean`: the
principal-ideal norm, the `6`-to-`1` element/ideal correspondence, and the ideal
count function.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace EisensteinInt

/-! ## The algebra norm and the principal-ideal norm -/

lemma eisensteinBasis_zero : eisensteinBasis 0 = (1 : EisensteinInt) := by
  rw [eisensteinBasis, Module.Basis.mk_apply]
  rfl

lemma eisensteinBasis_one : eisensteinBasis 1 = omega := by
  rw [eisensteinBasis, Module.Basis.mk_apply]
  rfl

lemma repr_eisenstein_zero (z : EisensteinInt) : eisensteinBasis.repr z 0 = z.re := by
  have h : z = z.re • eisensteinBasis 0 + z.im • eisensteinBasis 1 := by
    rw [eisensteinBasis_zero, eisensteinBasis_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [eisensteinBasis_zero, eisensteinBasis_one]

lemma repr_eisenstein_one (z : EisensteinInt) : eisensteinBasis.repr z 1 = z.im := by
  have h : z = z.re • eisensteinBasis 0 + z.im • eisensteinBasis 1 := by
    rw [eisensteinBasis_zero, eisensteinBasis_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [eisensteinBasis_zero, eisensteinBasis_one]

/-- The algebra norm of `z ∈ ℤ[ω]` is its norm form `a² − ab + b²`. -/
lemma algebra_norm_three (z : EisensteinInt) : Algebra.norm ℤ z = normE z := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  rw [Algebra.norm_eq_matrix_det eisensteinBasis z]
  have hmat : Algebra.leftMulMatrix eisensteinBasis z = !![z.re, -z.im; z.im, z.re - z.im] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Algebra.leftMulMatrix_eq_repr_mul, eisensteinBasis_zero, eisensteinBasis_one,
        repr_eisenstein_zero, repr_eisenstein_one, mul_one]
  rw [hmat]
  simp only [Matrix.det_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one]
  simp only [normE]
  ring

/-- The ideal norm of the principal ideal `(z)` is `|N(z)|`. -/
lemma absNorm_span_three (z : EisensteinInt) :
    Ideal.absNorm (Ideal.span {z}) = (normE z).natAbs := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  rw [Ideal.absNorm_span_singleton]
  congr 1
  exact algebra_norm_three z

/-! ## Finiteness of the unit group and the norm-`n` elements -/

instance unitsSixFintype : Fintype EisensteinIntˣ := by
  letI : Fintype {z : EisensteinInt // z ∈ units6} :=
    Fintype.subtype units6 (fun z => Iff.rfl)
  exact Fintype.ofEquiv _ unitsEquivUnits6

lemma unitsSix_fintype_card : Fintype.card EisensteinIntˣ = 6 := by
  rw [← Nat.card_eq_fintype_card]
  exact units_card_six

abbrev NormElementsThree (n : ℕ) := {z : EisensteinInt // (normE z).natAbs = n}

def normElementsSmulThree (n : ℕ) (u : EisensteinIntˣ) (z : NormElementsThree n) :
    NormElementsThree n :=
  ⟨(u : EisensteinInt) * z.val, by
    rw [normE_mul, Int.natAbs_mul, unit_normE_eq_one u, z.2]
    norm_num⟩

@[simp]
lemma normElementsSmulThree_def (n : ℕ) (u : EisensteinIntˣ) (z : NormElementsThree n) :
    (normElementsSmulThree n u z).val = (u : EisensteinInt) * z.val := rfl

instance normElementsMulActionThree (n : ℕ) : MulAction EisensteinIntˣ (NormElementsThree n) where
  smul := normElementsSmulThree n
  one_smul z := by
    apply Subtype.ext
    change (normElementsSmulThree n 1 z).val = z.val
    rw [normElementsSmulThree_def]
    simp
  mul_smul u v z := by
    apply Subtype.ext
    change (normElementsSmulThree n (u * v) z).val =
      (normElementsSmulThree n u (normElementsSmulThree n v z)).val
    rw [normElementsSmulThree_def, normElementsSmulThree_def, normElementsSmulThree_def]
    simp [mul_assoc]

lemma normElementsThree_ne_zero (n : ℕ) (hn : 0 < n) (z : NormElementsThree n) :
    z.val ≠ 0 := by
  intro h
  have hz := z.2
  rw [h] at hz
  simp [normE] at hz
  omega

lemma normElementsThree_smul_eq_self_iff (n : ℕ) (hn : 0 < n) (u : EisensteinIntˣ)
    (z : NormElementsThree n) : u • z = z ↔ u = 1 := by
  constructor
  · intro h
    have hz : z.val ≠ 0 := normElementsThree_ne_zero n hn z
    have hval : (u : EisensteinInt) * z.val = z.val := by
      have := congr_arg Subtype.val h
      change (normElementsSmulThree n u z).val = z.val at this
      rwa [normElementsSmulThree_def] at this
    have h1 : (u : EisensteinInt) * z.val = (1 : EisensteinInt) * z.val := by simpa using hval
    have hu : (u : EisensteinInt) = 1 := mul_right_cancel₀ hz h1
    exact Units.ext hu
  · intro h
    rw [h]
    exact one_smul _ _

/-! ## Finiteness -/

def pairToNormElementsThree (n : ℕ) :
    {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)} → NormElementsThree n
  | ⟨⟨x, y⟩, h⟩ => ⟨⟨x, y⟩, by
      rw [show (⟨x, y⟩ : EisensteinInt).normE = x ^ 2 - x * y + y ^ 2 from rfl, h,
        Int.natAbs_natCast]⟩

def normElementsToPairThree (n : ℕ) :
    NormElementsThree n → {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)}
  | ⟨z, hz⟩ => ⟨(z.re, z.im), by
      have hnonneg : 0 ≤ normE z := normE_nonneg z
      have hcast : (((normE z).natAbs : ℤ)) = normE z := Int.natAbs_of_nonneg hnonneg
      change z.re ^ 2 - z.re * z.im + z.im ^ 2 = (n : ℤ)
      have hnorm : normE z = (n : ℤ) := by rw [← hcast, hz]
      simpa [normE] using hnorm⟩

lemma normElementsToPairThree_pairTo (n : ℕ)
    (p : {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)}) :
    normElementsToPairThree n (pairToNormElementsThree n p) = p := by
  obtain ⟨⟨x, y⟩, h⟩ := p
  rfl

lemma pairToNormElementsThree_normElementsToPair (n : ℕ) (z : NormElementsThree n) :
    pairToNormElementsThree n (normElementsToPairThree n z) = z := by
  obtain ⟨⟨x, y⟩, hz⟩ := z
  rfl

def pairEquivThree (n : ℕ) :
    {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)} ≃ NormElementsThree n where
  toFun := pairToNormElementsThree n
  invFun := normElementsToPairThree n
  left_inv := normElementsToPairThree_pairTo n
  right_inv := pairToNormElementsThree_normElementsToPair n

def fintypePairsThree (n : ℕ) :
    Fintype {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n : ℤ)) (n : ℤ)).product (Finset.Icc (-(n : ℤ)) (n : ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]; constructor <;>
        nlinarith [sq_nonneg p.1, sq_nonneg p.2, sq_nonneg (p.1 - p.2)]
    · rw [Finset.mem_Icc]; constructor <;>
        nlinarith [sq_nonneg p.1, sq_nonneg p.2, sq_nonneg (p.1 - p.2)]
  exact Fintype.ofFinset (S.filter (fun p => p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)

def fintypeNormElementsThree (n : ℕ) : Fintype (NormElementsThree n) :=
  letI : Fintype {p : ℤ × ℤ // p.1 ^ 2 - p.1 * p.2 + p.2 ^ 2 = (n : ℤ)} := fintypePairsThree n
  Fintype.ofEquiv _ (pairEquivThree n)

/-! ## The `6`-to-`1` correspondence -/

lemma normElementsThree_card_eq_six_mul_orbits (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElementsThree n) =
      6 * Nat.card (Quotient (MulAction.orbitRel EisensteinIntˣ (NormElementsThree n))) := by
  letI : Fintype (NormElementsThree n) := fintypeNormElementsThree n
  let Ω := Quotient (MulAction.orbitRel EisensteinIntˣ (NormElementsThree n))
  letI : DecidableEq Ω := Classical.decEq Ω
  letI : Fintype Ω := Fintype.ofSurjective (Quotient.mk'' : NormElementsThree n → Ω)
    Quotient.mk''_surjective
  have hburn := MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group
    EisensteinIntˣ (NormElementsThree n)
  have hsum : (∑ g : EisensteinIntˣ, Fintype.card (MulAction.fixedBy (NormElementsThree n) g)) =
      Fintype.card (NormElementsThree n) := by
    rw [Finset.sum_eq_single (1 : EisensteinIntˣ)]
    · refine Fintype.card_congr ?_
      refine ⟨fun x => x.val, fun x => ⟨x, ?_⟩, fun x => rfl, fun x => rfl⟩
      simp [MulAction.fixedBy]
    · intro g _ hg
      rw [Fintype.card_eq_zero_iff]
      refine ⟨fun x => ?_⟩
      exact hg ((normElementsThree_smul_eq_self_iff n hn g x.val).mp x.2)
    · intro h
      simp at h
  rw [hsum, unitsSix_fintype_card] at hburn
  rw [Nat.card_eq_fintype_card, hburn]
  rw [Nat.card_eq_fintype_card]
  omega

lemma span_eq_iff_associated_three (x y : EisensteinInt) :
    Ideal.span ({x} : Set EisensteinInt) = Ideal.span ({y} : Set EisensteinInt) ↔
      Associated x y :=
  Ideal.span_singleton_eq_span_singleton

lemma absNorm_span_three_of_norm (n : ℕ) (z : EisensteinInt) (hz : (normE z).natAbs = n) :
    Ideal.absNorm (Ideal.span {z}) = n := by
  rw [absNorm_span_three, hz]

def orbitToIdealThree (n : ℕ) :
    Quotient (MulAction.orbitRel EisensteinIntˣ (NormElementsThree n)) →
      {I : Ideal EisensteinInt // Ideal.absNorm I = n} :=
  Quotient.lift
    (fun z : NormElementsThree n => ⟨Ideal.span {z.val}, absNorm_span_three_of_norm n z.val z.2⟩)
    (by
      intro z y hzy
      obtain ⟨g, hg⟩ := hzy
      have hval : z.val = (g : EisensteinInt) * y.val := by
        have := congr_arg Subtype.val hg
        change (normElementsSmulThree n g y).val = z.val at this
        rw [normElementsSmulThree_def] at this
        exact this.symm
      have hAssoc : Associated y.val z.val := ⟨g, by rw [mul_comm, ← hval]⟩
      have hspan : Ideal.span {z.val} = Ideal.span {y.val} :=
        ((span_eq_iff_associated_three y.val z.val).mpr hAssoc).symm
      exact Subtype.ext hspan)

def idealToOrbitThree (n : ℕ) :
    {I : Ideal EisensteinInt // Ideal.absNorm I = n} →
      Quotient (MulAction.orbitRel EisensteinIntˣ (NormElementsThree n)) :=
  fun I =>
    Quotient.mk'' ⟨Submodule.IsPrincipal.generator I.1, by
      letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
      have hspan : Ideal.span ({Submodule.IsPrincipal.generator I.1} : Set EisensteinInt) = I.1 :=
        Ideal.span_singleton_generator I.1
      have h := I.2
      rw [← hspan] at h
      rw [absNorm_span_three] at h
      exact h⟩

def orbitsEquivIdealsThree (n : ℕ) :
    Quotient (MulAction.orbitRel EisensteinIntˣ (NormElementsThree n)) ≃
      {I : Ideal EisensteinInt // Ideal.absNorm I = n} where
  toFun := orbitToIdealThree n
  invFun := idealToOrbitThree n
  left_inv q := by
    induction q using Quotient.ind with
    | _ z =>
      apply Quotient.sound
      letI : (Ideal.span ({z.val} : Set EisensteinInt)).IsPrincipal :=
        IsPrincipalIdealRing.principal _
      have hspan := Ideal.span_singleton_generator (Ideal.span ({z.val} : Set EisensteinInt))
      have hassoc : Associated z.val (Submodule.IsPrincipal.generator
          (Ideal.span ({z.val} : Set EisensteinInt))) := by
        rw [← span_eq_iff_associated_three, hspan]
      obtain ⟨u, hu⟩ := hassoc
      have hI : orbitToIdealThree n (Quotient.mk'' z) =
          ⟨Ideal.span {z.val}, absNorm_span_three_of_norm n z.val z.2⟩ := by
        apply Subtype.ext
        rw [orbitToIdealThree, Quotient.lift_mk]
      refine ⟨u, ?_⟩
      rw [hI]
      apply Subtype.ext
      simp only [Subtype.coe_mk]
      change (u : EisensteinInt) * z.val =
        Submodule.IsPrincipal.generator (Ideal.span ({z.val} : Set EisensteinInt))
      rw [mul_comm, hu]
  right_inv I := by
    apply Subtype.ext
    letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
    exact Ideal.span_singleton_generator I.1

theorem normElementsThree_card_eq_six_mul_idealCount (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElementsThree n) =
      6 * Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = n} := by
  rw [normElementsThree_card_eq_six_mul_orbits n hn]
  rw [Nat.card_congr (orbitsEquivIdealsThree n)]

/-- The ideal count of `ℤ[ω]`. -/
def idealCountThree (n : ℕ) : ℕ := Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = n}

end EisensteinInt


