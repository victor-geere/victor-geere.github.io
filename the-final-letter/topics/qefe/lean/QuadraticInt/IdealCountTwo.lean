import Mathlib
import QuadraticInt.SplitTwo

/-!
# The ideal count in `ℤ[√−2]` (the `d = 2` counting development)

This file starts the `d = 2` analogue of `GaussianInt/IdealCount.lean`: the
principal-ideal norm, the `w`-to-1 element/ideal correspondence with `w = 2`, and
the first local count.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace ZsqrtdTwo

/-! ## The algebra norm and the principal-ideal norm -/

lemma sqrtdBasis_zero : sqrtdBasis 0 = (1 : R2) := by
  rw [sqrtdBasis, Module.Basis.mk_apply]
  rfl

lemma sqrtdBasis_one : sqrtdBasis 1 = (Zsqrtd.sqrtd : R2) := by
  rw [sqrtdBasis, Module.Basis.mk_apply]
  rfl

lemma repr_sqrtdBasis_zero (z : R2) : sqrtdBasis.repr z 0 = z.re := by
  have h : z = z.re • sqrtdBasis 0 + z.im • sqrtdBasis 1 := by
    rw [sqrtdBasis_zero, sqrtdBasis_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [sqrtdBasis_zero, sqrtdBasis_one]

lemma repr_sqrtdBasis_one (z : R2) : sqrtdBasis.repr z 1 = z.im := by
  have h : z = z.re • sqrtdBasis 0 + z.im • sqrtdBasis 1 := by
    rw [sqrtdBasis_zero, sqrtdBasis_one]
    ext <;> simp
  rw [h, map_add, map_smul, map_smul, Module.Basis.repr_self, Module.Basis.repr_self]
  simp [sqrtdBasis_zero, sqrtdBasis_one]

/-- The algebra norm of `z ∈ ℤ[√−2]` is its `Zsqrtd.norm`. -/
lemma algebra_norm_two (z : R2) : Algebra.norm ℤ z = z.norm := by
  rw [Algebra.norm_eq_matrix_det sqrtdBasis z]
  have hmat : Algebra.leftMulMatrix sqrtdBasis z = !![z.re, -2 * z.im; z.im, z.re] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Algebra.leftMulMatrix_eq_repr_mul, sqrtdBasis_zero, sqrtdBasis_one,
        repr_sqrtdBasis_zero, repr_sqrtdBasis_one, mul_one]
  rw [hmat]
  simp only [Matrix.det_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one]
  rw [Zsqrtd.norm_def]
  try ring

/-- The ideal norm of the principal ideal `(z)` is `|N(z)|`. -/
lemma absNorm_span_two (z : R2) : Ideal.absNorm (Ideal.span {z}) = z.norm.natAbs := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  rw [Ideal.absNorm_span_singleton]
  congr 1
  exact algebra_norm_two z

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## The unit group has cardinality two -/

/-- The two units, as a finset. -/
def unitsTwo : Finset R2ˣ := {1, -1}

lemma mem_unitsTwo (u : R2ˣ) : u ∈ unitsTwo := by
  rcases unit_eq_one_or_neg_one u with h | h
  · have hu : u = (1 : R2ˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [unitsTwo]
  · have hu : u = (-1 : R2ˣ) := Units.ext (by simpa using h)
    rw [hu]; simp [unitsTwo]

def unitsEquivSubtypeTwo : R2ˣ ≃ {x : R2ˣ // x ∈ unitsTwo} where
  toFun u := ⟨u, mem_unitsTwo u⟩
  invFun x := x.1
  left_inv _ := rfl
  right_inv x := Subtype.ext rfl

lemma units_card_two : Nat.card R2ˣ = 2 := by
  rw [Nat.card_congr unitsEquivSubtypeTwo]
  letI : Fintype {x : R2ˣ // x ∈ unitsTwo} :=
    Fintype.subtype unitsTwo (fun x => Iff.rfl)
  rw [Nat.card_eq_fintype_card]
  have h : Fintype.card {x : R2ˣ // x ∈ unitsTwo} = unitsTwo.card := by
    rw [← Finset.card_attach]
    rfl
  rw [h]
  decide

instance unitsTwoFintype : Fintype R2ˣ := by
  letI : Fintype {x : R2ˣ // x ∈ unitsTwo} :=
    Fintype.subtype unitsTwo (fun x => Iff.rfl)
  exact Fintype.ofEquiv _ unitsEquivSubtypeTwo.symm

lemma unitsTwo_fintype_card : Fintype.card R2ˣ = 2 := by
  rw [← Nat.card_eq_fintype_card]
  exact units_card_two

/-! ## The free unit action on norm-`n` elements -/

abbrev NormElementsTwo (n : ℕ) := {z : R2 // z.norm.natAbs = n}

def normElementsSmulTwo (n : ℕ) (u : R2ˣ) (z : NormElementsTwo n) : NormElementsTwo n :=
  ⟨(u : R2) * z.val, by
    rw [Zsqrtd.norm_mul, Int.natAbs_mul, unit_norm_eq_one u, z.2]
    norm_num⟩

@[simp]
lemma normElementsSmulTwo_def (n : ℕ) (u : R2ˣ) (z : NormElementsTwo n) :
    (normElementsSmulTwo n u z).val = (u : R2) * z.val := rfl

instance normElementsMulActionTwo (n : ℕ) : MulAction R2ˣ (NormElementsTwo n) where
  smul := normElementsSmulTwo n
  one_smul z := by
    apply Subtype.ext
    change (normElementsSmulTwo n 1 z).val = z.val
    rw [normElementsSmulTwo_def]
    simp
  mul_smul u v z := by
    apply Subtype.ext
    change (normElementsSmulTwo n (u * v) z).val =
      (normElementsSmulTwo n u (normElementsSmulTwo n v z)).val
    rw [normElementsSmulTwo_def, normElementsSmulTwo_def, normElementsSmulTwo_def]
    simp [mul_assoc]

lemma normElementsTwo_ne_zero (n : ℕ) (hn : 0 < n) (z : NormElementsTwo n) :
    z.val ≠ 0 := by
  intro h
  have hz := z.2
  rw [h] at hz
  simp at hz
  omega

/-- The unit action on norm-`n` elements is free for `n > 0`. -/
lemma normElementsTwo_smul_eq_self_iff (n : ℕ) (hn : 0 < n) (u : R2ˣ)
    (z : NormElementsTwo n) : u • z = z ↔ u = 1 := by
  constructor
  · intro h
    have hz : z.val ≠ 0 := normElementsTwo_ne_zero n hn z
    have hval : (u : R2) * z.val = z.val := by
      have := congr_arg Subtype.val h
      change (normElementsSmulTwo n u z).val = z.val at this
      rwa [normElementsSmulTwo_def] at this
    have h1 : (u : R2) * z.val = (1 : R2) * z.val := by simpa using hval
    have hu : (u : R2) = 1 := mul_right_cancel₀ hz h1
    exact Units.ext hu
  · intro h
    rw [h]
    exact one_smul _ _

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## Finiteness of the norm-`n` elements -/

def pairToNormElementsTwo (n : ℕ) :
    {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)} → NormElementsTwo n
  | ⟨⟨x, y⟩, h⟩ => ⟨⟨x, y⟩, by
      have hnorm : (⟨x, y⟩ : R2).norm = x ^ 2 + 2 * y ^ 2 := by
        rw [Zsqrtd.norm_def]; ring
      rw [hnorm, h, Int.natAbs_natCast]⟩

def normElementsToPairTwo (n : ℕ) :
    NormElementsTwo n → {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)}
  | ⟨z, hz⟩ => ⟨(z.re, z.im), by
      have hnonneg : 0 ≤ z.norm := Zsqrtd.norm_nonneg (by norm_num) z
      have hcast : ((z.norm.natAbs : ℤ)) = z.norm := Int.natAbs_of_nonneg hnonneg
      change z.re ^ 2 + 2 * z.im ^ 2 = (n : ℤ)
      have hnorm : z.norm = (n : ℤ) := by
        rw [← hcast, hz]
      rw [Zsqrtd.norm_def] at hnorm
      linarith⟩

lemma normElementsToPairTwo_pairToNormElementsTwo (n : ℕ)
    (p : {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)}) :
    normElementsToPairTwo n (pairToNormElementsTwo n p) = p := by
  obtain ⟨⟨x, y⟩, h⟩ := p
  rfl

lemma pairToNormElementsTwo_normElementsToPairTwo (n : ℕ) (z : NormElementsTwo n) :
    pairToNormElementsTwo n (normElementsToPairTwo n z) = z := by
  obtain ⟨⟨x, y⟩, hz⟩ := z
  rfl

def pairEquivTwo (n : ℕ) :
    {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)} ≃ NormElementsTwo n where
  toFun := pairToNormElementsTwo n
  invFun := normElementsToPairTwo n
  left_inv := normElementsToPairTwo_pairToNormElementsTwo n
  right_inv := pairToNormElementsTwo_normElementsToPairTwo n

def fintypePairsTwo (n : ℕ) : Fintype {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)} := by
  let S : Finset (ℤ × ℤ) :=
    (Finset.Icc (-(n : ℤ)) (n : ℤ)).product (Finset.Icc (-(n : ℤ)) (n : ℤ))
  have hfin : ∀ p : ℤ × ℤ, p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ) → p ∈ S := by
    intro p hp
    dsimp only [S]
    refine Finset.mem_product.mpr ⟨?_, ?_⟩
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
    · rw [Finset.mem_Icc]; constructor <;> nlinarith [sq_nonneg p.1, sq_nonneg p.2]
  exact Fintype.ofFinset (S.filter (fun p => p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ))) (by
    intro p
    rw [Finset.mem_filter]
    constructor
    · intro hp; exact hp.2
    · intro hp; exact ⟨hfin p hp, hp⟩)

def fintypeNormElementsTwo (n : ℕ) : Fintype (NormElementsTwo n) :=
  letI : Fintype {p : ℤ × ℤ // p.1 ^ 2 + 2 * p.2 ^ 2 = (n : ℤ)} := fintypePairsTwo n
  Fintype.ofEquiv _ (pairEquivTwo n)

/-! ## The `2`-to-`1` correspondence -/

/-- Burnside: `|NormElements n| = 2 * #orbits` for `n > 0`. -/
lemma normElementsTwo_card_eq_two_mul_orbits (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElementsTwo n) =
      2 * Nat.card (Quotient (MulAction.orbitRel R2ˣ (NormElementsTwo n))) := by
  letI : Fintype (NormElementsTwo n) := fintypeNormElementsTwo n
  let Ω := Quotient (MulAction.orbitRel R2ˣ (NormElementsTwo n))
  letI : DecidableEq Ω := Classical.decEq Ω
  letI : Fintype Ω := Fintype.ofSurjective (Quotient.mk'' : NormElementsTwo n → Ω)
    Quotient.mk''_surjective
  have hburn := MulAction.sum_card_fixedBy_eq_card_orbits_mul_card_group
    R2ˣ (NormElementsTwo n)
  have hsum : (∑ g : R2ˣ, Fintype.card (MulAction.fixedBy (NormElementsTwo n) g)) =
      Fintype.card (NormElementsTwo n) := by
    rw [Finset.sum_eq_single (1 : R2ˣ)]
    · refine Fintype.card_congr ?_
      refine ⟨fun x => x.val, fun x => ⟨x, ?_⟩, fun x => rfl, fun x => rfl⟩
      simp [MulAction.fixedBy]
    · intro g _ hg
      rw [Fintype.card_eq_zero_iff]
      refine ⟨fun x => ?_⟩
      exact hg ((normElementsTwo_smul_eq_self_iff n hn g x.val).mp x.2)
    · intro h
      simp at h
  rw [hsum, unitsTwo_fintype_card] at hburn
  rw [Nat.card_eq_fintype_card, hburn]
  rw [Nat.card_eq_fintype_card]
  omega

lemma span_eq_iff_associated_two (x y : R2) :
    Ideal.span ({x} : Set R2) = Ideal.span ({y} : Set R2) ↔ Associated x y :=
  Ideal.span_singleton_eq_span_singleton

lemma absNorm_span_two_of_norm (n : ℕ) (z : R2) (hz : z.norm.natAbs = n) :
    Ideal.absNorm (Ideal.span {z}) = n := by
  rw [absNorm_span_two, hz]

def orbitToIdealTwo (n : ℕ) :
    Quotient (MulAction.orbitRel R2ˣ (NormElementsTwo n)) →
      {I : Ideal R2 // Ideal.absNorm I = n} :=
  Quotient.lift
    (fun z : NormElementsTwo n => ⟨Ideal.span {z.val}, absNorm_span_two_of_norm n z.val z.2⟩)
    (by
      intro z y hzy
      obtain ⟨g, hg⟩ := hzy
      have hval : z.val = (g : R2) * y.val := by
        have := congr_arg Subtype.val hg
        change (normElementsSmulTwo n g y).val = z.val at this
        rw [normElementsSmulTwo_def] at this
        exact this.symm
      have hAssoc : Associated y.val z.val := ⟨g, by rw [mul_comm, ← hval]⟩
      have hspan : Ideal.span {z.val} = Ideal.span {y.val} :=
        ((span_eq_iff_associated_two y.val z.val).mpr hAssoc).symm
      exact Subtype.ext hspan)

def idealToOrbitTwo (n : ℕ) :
    {I : Ideal R2 // Ideal.absNorm I = n} →
      Quotient (MulAction.orbitRel R2ˣ (NormElementsTwo n)) :=
  fun I =>
    Quotient.mk'' ⟨Submodule.IsPrincipal.generator I.1, by
      letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
      have hspan : Ideal.span ({Submodule.IsPrincipal.generator I.1} : Set R2) = I.1 :=
        Ideal.span_singleton_generator I.1
      have h := I.2
      rw [← hspan] at h
      rw [absNorm_span_two] at h
      exact h⟩

/-- The orbit quotient is the set of ideals of norm `n`. -/
def orbitsEquivIdealsTwo (n : ℕ) :
    Quotient (MulAction.orbitRel R2ˣ (NormElementsTwo n)) ≃
      {I : Ideal R2 // Ideal.absNorm I = n} where
  toFun := orbitToIdealTwo n
  invFun := idealToOrbitTwo n
  left_inv q := by
    induction q using Quotient.ind with
    | _ z =>
      apply Quotient.sound
      letI : (Ideal.span ({z.val} : Set R2)).IsPrincipal :=
        IsPrincipalIdealRing.principal _
      have hspan := Ideal.span_singleton_generator (Ideal.span ({z.val} : Set R2))
      have hassoc : Associated z.val (Submodule.IsPrincipal.generator
          (Ideal.span ({z.val} : Set R2))) := by
        rw [← span_eq_iff_associated_two, hspan]
      obtain ⟨u, hu⟩ := hassoc
      have hI : orbitToIdealTwo n (Quotient.mk'' z) =
          ⟨Ideal.span {z.val}, absNorm_span_two_of_norm n z.val z.2⟩ := by
        apply Subtype.ext
        rw [orbitToIdealTwo, Quotient.lift_mk]
      refine ⟨u, ?_⟩
      rw [hI]
      apply Subtype.ext
      simp only [Subtype.coe_mk]
      change (u : R2) * z.val =
        Submodule.IsPrincipal.generator (Ideal.span ({z.val} : Set R2))
      rw [mul_comm, hu]
  right_inv I := by
    apply Subtype.ext
    letI : I.1.IsPrincipal := IsPrincipalIdealRing.principal I.1
    exact Ideal.span_singleton_generator I.1

/-- The `2`-to-1 generator/ideal count for `ℤ[√−2]`. -/
theorem normElementsTwo_card_eq_two_mul_idealCount (n : ℕ) (hn : 0 < n) :
    Nat.card (NormElementsTwo n) =
      2 * Nat.card {I : Ideal R2 // Ideal.absNorm I = n} := by
  rw [normElementsTwo_card_eq_two_mul_orbits n hn]
  rw [Nat.card_congr (orbitsEquivIdealsTwo n)]

/-- The ideal count of `ℤ[√−2]`. -/
def idealCountTwo (n : ℕ) : ℕ := Nat.card {I : Ideal R2 // Ideal.absNorm I = n}

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## The split primes of `ℤ[√−2]` -/

lemma norm_two_mk (x y : ℤ) : (⟨x, y⟩ : R2).norm = x ^ 2 + 2 * y ^ 2 := by
  rw [Zsqrtd.norm_def]; ring

lemma star_two_mk (x y : ℤ) : star (⟨x, y⟩ : R2) = ⟨x, -y⟩ := by
  ext <;> simp

lemma mul_star_two_mk (x y : ℤ) :
    (⟨x, y⟩ : R2) * star (⟨x, y⟩ : R2) = (⟨x ^ 2 + 2 * y ^ 2, 0⟩ : R2) := by
  rw [star_two_mk]; ext <;> simp [Zsqrtd.re_mul, Zsqrtd.im_mul] <;> ring

/-- The split-prime factorisation in `ℤ[√−2]`. -/
theorem split_prime_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 1 ∨ p % 8 = 3) :
    ∃ π : R2, Prime π ∧ π * star π = (p : R2) := by
  obtain ⟨a, b, hab⟩ := prime_sq_add_two_sq hp8
  have hp2 : 2 ≤ p := hp.out.two_le
  have hpodd : p % 2 = 1 := by
    rcases hp8 with h | h <;> omega
  have ha : a ≠ 0 := by
    intro h
    have h2dvd : 2 ∣ p := ⟨b ^ 2, by rw [← hab, h]; ring⟩
    rcases hp.out.eq_one_or_self_of_dvd 2 h2dvd with h1 | h1
    · omega
    · omega
  have hb : b ≠ 0 := by
    intro h
    have hsq : p = a ^ 2 := by rw [← hab, h]; ring
    have hdvd : a ∣ p := ⟨a, by rw [hsq]; ring⟩
    rcases hp.out.eq_one_or_self_of_dvd a hdvd with h1 | h1
    · rw [h1] at hsq; omega
    · rw [h1] at hsq; nlinarith [hp2]
  have hnorm : (⟨(a : ℤ), (b : ℤ)⟩ : R2).norm.natAbs = p := by
    rw [norm_two_mk, show (a:ℤ)^2 + 2*(b:ℤ)^2 = (p:ℤ) by exact_mod_cast hab]
    simp
  refine ⟨⟨(a : ℤ), (b : ℤ)⟩, ?_, ?_⟩
  · apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (⟨(a : ℤ), (b : ℤ)⟩ : R2).norm = 0 := by rw [h]; rfl
      rw [Zsqrtd.norm_eq_zero_iff (by norm_num : (-2:ℤ) < 0)] at hz
      have hre : (a : ℤ) = 0 := by simpa using congr_arg Zsqrtd.re hz
      exact ha (by exact_mod_cast hre)
    · have habs : Ideal.absNorm (Ideal.span ({⟨(a : ℤ), (b : ℤ)⟩} : Set R2)) = p := by
        rw [absNorm_span_two, hnorm]
      rw [habs]
      exact hp.out
  · rw [mul_star_two_mk]
    have hcast : ((a:ℤ)^2 + 2*(b:ℤ)^2) = (p:ℤ) := by exact_mod_cast hab
    ext <;> simp [hcast]

end ZsqrtdTwo

namespace ZsqrtdTwo

lemma split_span_norm_two {p : ℕ} [hp : Fact p.Prime] {π : R2}
    (hprod : π * star π = (p : R2)) :
    Ideal.absNorm (Ideal.span ({π} : Set R2)) = p ∧
      Ideal.absNorm (Ideal.span ({star π} : Set R2)) = p := by
  have hnorm : π.norm * (star π).norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, hprod, Zsqrtd.norm_def]
    simp only [Zsqrtd.re_natCast, Zsqrtd.im_natCast]
    ring
  rw [Zsqrtd.norm_conj] at hnorm
  have hnonneg : 0 ≤ π.norm := Zsqrtd.norm_nonneg (by norm_num) π
  have hπ : π.norm = (p : ℤ) := by nlinarith
  constructor
  · rw [absNorm_span_two, hπ]; simp
  · rw [absNorm_span_two, Zsqrtd.norm_conj, hπ]; simp

lemma split_span_ne_two {p : ℕ} [hp : Fact p.Prime] {a b : ℤ}
    (hp8 : p % 8 = 1 ∨ p % 8 = 3) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a ^ 2 + 2 * b ^ 2 = (p : ℤ)) :
    Ideal.span ({⟨a, b⟩} : Set R2) ≠ Ideal.span ({star (⟨a, b⟩ : R2)} : Set R2) := by
  intro h
  have hassoc : Associated (⟨a, b⟩ : R2) (star (⟨a, b⟩ : R2)) :=
    (span_eq_iff_associated_two _ _).mp h
  obtain ⟨u, hu⟩ := hassoc
  rcases unit_eq_one_or_neg_one u with h1 | h1
  · have hπ : (⟨a, b⟩ : R2) = star (⟨a, b⟩ : R2) := by simpa [h1] using hu
    have him := congr_arg Zsqrtd.im hπ
    simp [star_two_mk] at him
    exact hb (by linarith)
  · have hπ : -(⟨a, b⟩ : R2) = star (⟨a, b⟩ : R2) := by simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    simp [star_two_mk] at hre
    exact ha (by linarith)

lemma split_prime_ne_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 1 ∨ p % 8 = 3) :
    ∃ π : R2, Prime π ∧ Prime (star π) ∧ π * star π = (p : R2) ∧
      Ideal.span ({π} : Set R2) ≠ Ideal.span ({star π} : Set R2) := by
  obtain ⟨a, b, hab⟩ := prime_sq_add_two_sq hp8
  have hpodd : p % 2 = 1 := by rcases hp8 with h | h <;> omega
  have ha : (a : ℤ) ≠ 0 := by
    intro h
    have hn : a = 0 := by exact_mod_cast h
    have h2dvd : 2 ∣ p := ⟨b ^ 2, by rw [← hab, hn]; ring⟩
    rcases hp.out.eq_one_or_self_of_dvd 2 h2dvd with h2 | h2
    · omega
    · have : p = 2 := h2.symm
      omega
  have hb : (b : ℤ) ≠ 0 := by
    intro h
    have hn : b = 0 := by exact_mod_cast h
    have hsq : p = a ^ 2 := by rw [← hab, hn]; ring
    have hdvd : a ∣ p := ⟨a, by rw [hsq]; ring⟩
    rcases hp.out.eq_one_or_self_of_dvd a hdvd with h1 | h1
    · rw [h1] at hsq; nlinarith [hp.out.two_le]
    · rw [h1] at hsq; nlinarith [hp.out.two_le]
  let π : R2 := ⟨(a : ℤ), (b : ℤ)⟩
  have hprod : π * star π = (p : R2) := by
    rw [show π = (⟨(a:ℤ), (b:ℤ)⟩ : R2) from rfl, mul_star_two_mk]
    have hcast : ((a:ℤ)^2 + 2*(b:ℤ)^2) = (p:ℤ) := by exact_mod_cast hab
    ext <;> simp [hcast]
  have hnorm : π.norm.natAbs = p := by
    rw [show π = (⟨(a:ℤ), (b:ℤ)⟩ : R2) from rfl, norm_two_mk]
    rw [show (a:ℤ)^2 + 2*(b:ℤ)^2 = (p:ℤ) by exact_mod_cast hab]
    simp
  have hπprime : Prime π := by
    apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : π.norm = 0 := by rw [h]; rfl
      rw [Zsqrtd.norm_eq_zero_iff (by norm_num : (-2:ℤ) < 0)] at hz
      exact ha (by
        have : (a:ℤ) = 0 := by simpa [π] using congr_arg Zsqrtd.re hz
        exact_mod_cast this)
    · have habs : Ideal.absNorm (Ideal.span ({π} : Set R2)) = p := by
        rw [absNorm_span_two, hnorm]
      rw [habs]; exact hp.out
  have hπ' : Prime (star π) := by
    have hnorm' : (star π).norm.natAbs = p := by
      rw [Zsqrtd.norm_conj, ← hnorm]
    refine Ideal.prime_of_irreducible_absNorm_span ?_ ?_
    · intro h
      have hπ0 : π = 0 := by
        have hss : star (star π) = 0 := by rw [h]; ext <;> simp
        simpa using hss
      rw [hπ0] at hnorm
      simp at hnorm
      exact hp.out.ne_zero hnorm.symm
    · rw [absNorm_span_two, hnorm']
      exact hp.out
  exact ⟨π, hπprime, hπ', hprod,
    split_span_ne_two hp8 ha hb (by exact_mod_cast hab)⟩

end ZsqrtdTwo
