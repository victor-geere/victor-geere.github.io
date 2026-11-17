import Mathlib
import QuadraticInt.IdealCountThree

/-!
# The split local structure in `ℤ[ω]`

The split-prime factorisation `(p) = (π)(star π)` for `p ≡ 1 (mod 3)` and the
`k+1` local ideal count, the Eisenstein analogue of
`QuadraticInt/SplitCountTwo.lean`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace EisensteinInt

/-! ## Units, conjugates and the split factorisation -/

lemma prime_not_sq_nat {p : ℕ} [Fact p.Prime] {n : ℕ} (h : n ^ 2 = p) : False := by
  have hdvd : n ∣ p := ⟨n, by rw [← h]; ring⟩
  rcases (Fact.out : p.Prime).eq_one_or_self_of_dvd n hdvd with h1 | h1
  · rw [h1] at h
    norm_num at h
    exact (Fact.out : p.Prime).ne_one h.symm
  · rw [h1] at h
    nlinarith [(Fact.out : p.Prime).two_le]

lemma unit_cases (u : EisensteinIntˣ) :
    (u : EisensteinInt) = 1 ∨ (u : EisensteinInt) = -1 ∨
      (u : EisensteinInt) = omega ∨ (u : EisensteinInt) = -omega ∨
      (u : EisensteinInt) = -1 - omega ∨ (u : EisensteinInt) = 1 + omega :=
  normE_eq_one_cases (unit_normE_eq_one u)

lemma star_mk_three (a b : ℤ) : star (⟨a, b⟩ : EisensteinInt) = ⟨a - b, -b⟩ := rfl

lemma mul_star_three_mk (a b : ℤ) :
    (⟨a, b⟩ : EisensteinInt) * star (⟨a, b⟩ : EisensteinInt) =
      (⟨a ^ 2 - a * b + b ^ 2, 0⟩ : EisensteinInt) := by
  rw [star_mk_three]
  ext <;> simp [re_mul, im_mul] <;> ring

/-- For `a² − ab + b² = p` with `p` prime: `a ≠ 0`. -/
lemma repr_ne_zero_left {p : ℕ} [Fact p.Prime] {a b : ℤ}
    (h : a ^ 2 - a * b + b ^ 2 = (p : ℤ)) : a ≠ 0 := by
  rintro rfl
  have hp_sq : (p : ℤ) = b ^ 2 := by rw [← h]; ring
  rw [← Int.natAbs_sq] at hp_sq
  exact prime_not_sq_nat (by exact_mod_cast hp_sq.symm)

lemma repr_ne_zero_right {p : ℕ} [Fact p.Prime] {a b : ℤ}
    (h : a ^ 2 - a * b + b ^ 2 = (p : ℤ)) : b ≠ 0 := by
  rintro rfl
  have hp_sq : (p : ℤ) = a ^ 2 := by rw [← h]; ring
  rw [← Int.natAbs_sq] at hp_sq
  exact prime_not_sq_nat (by exact_mod_cast hp_sq.symm)

lemma repr_ne_diag {p : ℕ} [Fact p.Prime] {a b : ℤ}
    (h : a ^ 2 - a * b + b ^ 2 = (p : ℤ)) : a ≠ b := by
  intro hab
  have hp_sq : (p : ℤ) = b ^ 2 := by rw [← h, hab]; ring
  rw [← Int.natAbs_sq] at hp_sq
  exact prime_not_sq_nat (by exact_mod_cast hp_sq.symm)

theorem split_prime_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 1) :
    ∃ π : EisensteinInt, Prime π ∧ π * star π = (p : EisensteinInt) := by
  obtain ⟨a, b, hab⟩ := prime_normE hp3
  have habZ : a ^ 2 - a * b + b ^ 2 = (p : ℤ) := hab
  have ha := repr_ne_zero_left habZ
  have hb := repr_ne_zero_right habZ
  refine ⟨⟨a, b⟩, ?_, ?_⟩
  · apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (⟨a, b⟩ : EisensteinInt).normE = 0 := by rw [h]; rfl
      rw [normE_eq_zero_iff] at hz
      exact ha (by simpa using congr_arg EisensteinInt.re hz)
    · have habs : Ideal.absNorm (Ideal.span ({⟨a, b⟩} : Set EisensteinInt)) = p := by
        rw [absNorm_span_three, show (⟨a, b⟩ : EisensteinInt).normE = a ^ 2 - a * b + b ^ 2
          from rfl, habZ]
        simp
      rw [habs]
      exact hp.out
  · rw [mul_star_three_mk]
    ext <;> simp [habZ]


theorem split_span_ne_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 1) {a b : ℤ}
    (ha : a ≠ 0) (hb : b ≠ 0) (habne : a ≠ b)
    (hnorm : a ^ 2 - a * b + b ^ 2 = (p : ℤ)) :
    Ideal.span ({⟨a, b⟩} : Set EisensteinInt) ≠
      Ideal.span ({star (⟨a, b⟩ : EisensteinInt)} : Set EisensteinInt) := by
  intro h
  have hassoc : Associated (⟨a, b⟩ : EisensteinInt) (star (⟨a, b⟩ : EisensteinInt)) :=
    (span_eq_iff_associated_three _ _).mp h
  obtain ⟨u, hu⟩ := hassoc
  have hu' : (u : EisensteinInt) * (⟨a, b⟩ : EisensteinInt) = star (⟨a, b⟩ : EisensteinInt) := by
    rw [mul_comm]; exact hu
  have h3p : (3 : ℤ) ∣ (p : ℤ) := by
    rcases unit_cases u with h1 | h1 | h1 | h1 | h1 | h1
    · rw [h1] at hu'
      have him := congr_arg EisensteinInt.im hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at him
      exact absurd him (by omega)
    · rw [h1] at hu'
      have hre := congr_arg EisensteinInt.re hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at hre
      have hb2 : b = 2 * a := by omega
      have hnn : a ^ 2 - a * b + b ^ 2 = 3 * a ^ 2 := by rw [hb2]; ring
      exact ⟨a ^ 2, by rw [← hnorm]; exact hnn⟩
    · rw [h1] at hu'
      have hre := congr_arg EisensteinInt.re hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at hre
      have h0 : a = 0 := by linarith
      exact absurd h0 ha
    · rw [h1] at hu'
      have hre := congr_arg EisensteinInt.re hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at hre
      have ha2 : a = 2 * b := by omega
      have hnn : a ^ 2 - a * b + b ^ 2 = 3 * b ^ 2 := by rw [ha2]; ring
      exact ⟨b ^ 2, by rw [← hnorm]; exact hnn⟩
    · rw [h1] at hu'
      have hre := congr_arg EisensteinInt.re hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at hre
      have hab : a = b := by omega
      exact absurd hab habne
    · rw [h1] at hu'
      have him := congr_arg EisensteinInt.im hu'
      simp only [star_mk_three, re_mk, im_mk, re_mul, im_mul, re_add, im_add, re_sub, im_sub, re_neg, im_neg, re_one, im_one, re_zero, im_zero, re_omega, im_omega, neg_mul, zero_mul, one_mul, add_zero, zero_add, sub_zero] at him
      have ha2 : a = -b := by omega
      have hnn : a ^ 2 - a * b + b ^ 2 = 3 * b ^ 2 := by rw [ha2]; ring
      exact ⟨b ^ 2, by rw [← hnorm]; exact hnn⟩
  obtain ⟨c, hc⟩ := h3p
  have h3 : (p : ℤ) = 3 * c := hc
  have hmod : ((p % 3 : ℕ) : ℤ) = 0 := by
    rw [Int.natCast_emod, h3]
    omega
  omega


lemma normE_star (z : EisensteinInt) : normE (star z) = normE z := by
  obtain ⟨a, b, rfl⟩ : ∃ a b, z = (⟨a, b⟩ : EisensteinInt) := ⟨z.re, z.im, rfl⟩
  rw [star_mk_three]
  simp only [normE]
  ring

lemma split_span_norm_three {p : ℕ} [hp : Fact p.Prime] {π : EisensteinInt}
    (hprod : π * star π = (p : EisensteinInt)) :
    Ideal.absNorm (Ideal.span ({π} : Set EisensteinInt)) = p ∧
      Ideal.absNorm (Ideal.span ({star π} : Set EisensteinInt)) = p := by
  have hnorm : π.normE * (star π).normE = (p : ℤ) ^ 2 := by
    rw [← normE_mul, hprod]
    simp only [normE, re_natCast, im_natCast, mul_zero, sub_zero]
    ring
  rw [normE_star] at hnorm
  have hnonneg : 0 ≤ π.normE := normE_nonneg π
  have hπ : π.normE = (p : ℤ) := by nlinarith
  constructor
  · rw [absNorm_span_three, hπ]; simp
  · rw [absNorm_span_three, normE_star, hπ]; simp

theorem split_prime_ne_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 1) :
    ∃ π : EisensteinInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : EisensteinInt) ∧
      Ideal.span ({π} : Set EisensteinInt) ≠ Ideal.span ({star π} : Set EisensteinInt) := by
  obtain ⟨a, b, hab⟩ := prime_normE hp3
  have habZ : a ^ 2 - a * b + b ^ 2 = (p : ℤ) := hab
  have ha := repr_ne_zero_left habZ
  have hb := repr_ne_zero_right habZ
  have habne := repr_ne_diag habZ
  have hnorm : (⟨a, b⟩ : EisensteinInt).normE = (p : ℤ) := habZ
  have hnormStar : (star (⟨a, b⟩ : EisensteinInt)).normE = (p : ℤ) := by
    rw [star_mk_three]; simp only [normE]; rw [← habZ]; ring
  have hprod : (⟨a, b⟩ : EisensteinInt) * star (⟨a, b⟩ : EisensteinInt) = (p : EisensteinInt) := by
    rw [mul_star_three_mk]; ext <;> simp [habZ]
  have hπ : Prime (⟨a, b⟩ : EisensteinInt) := by
    apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (⟨a, b⟩ : EisensteinInt).normE = 0 := by rw [h]; rfl
      rw [normE_eq_zero_iff] at hz
      exact ha (by simpa using congr_arg EisensteinInt.re hz)
    · have habs : Ideal.absNorm (Ideal.span ({⟨a, b⟩} : Set EisensteinInt)) = p := by
        rw [absNorm_span_three, hnorm]; simp
      rw [habs]; exact hp.out
  have hπ' : Prime (star (⟨a, b⟩ : EisensteinInt)) := by
    apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (star (⟨a, b⟩ : EisensteinInt)).normE = 0 := by rw [h]; rfl
      rw [normE_eq_zero_iff] at hz
      have hre : a - b = 0 := by simpa [star_mk_three] using congr_arg EisensteinInt.re hz
      exact habne (by omega)
    · have habs : Ideal.absNorm (Ideal.span ({star (⟨a, b⟩ : EisensteinInt)} : Set EisensteinInt)) = p := by
        rw [absNorm_span_three, hnormStar]; simp
      rw [habs]; exact hp.out
  exact ⟨⟨a, b⟩, hπ, hπ', hprod, split_span_ne_three hp3 ha hb habne habZ⟩


end EisensteinInt
