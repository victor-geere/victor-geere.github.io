import Mathlib
import QuadraticInt.SplitCountThree

/-!
# Local ideal counts in `ℤ[ω]`: inert and ramified primes

* **Inert `p ≡ 2 (mod 3)`.** No representation `p = a² − ab + b²` (the norm form
  is `0` or `1` mod `3`), so `p` stays prime; the unique ideal of norm `p^{2k}`
  is `(p)^k` and there are none of odd norm.
* **Ramified `p = 3`.** `(3) = (1 − ω)²`; every ideal of norm `3^k` is
  `(1 − ω)^k`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

namespace EisensteinInt

/-! ## The mod-`3` obstruction -/

lemma norm_form_ne_two_mod_three : ∀ a b : ZMod 3, a ^ 2 - a * b + b ^ 2 ≠ 2 := by decide

lemma not_repr_of_mod_three {p : ℕ} (hp3 : p % 3 = 2) :
    ¬ ∃ a b : ℤ, a ^ 2 - a * b + b ^ 2 = (p : ℤ) := by
  rintro ⟨a, b, hab⟩
  have h3 : ((a : ZMod 3)) ^ 2 - (a : ZMod 3) * (b : ZMod 3) + (b : ZMod 3) ^ 2 =
      ((p : ZMod 3)) := by
    have h := congr_arg ((↑) : ℤ → ZMod 3) hab
    push_cast at h
    linear_combination h
  have hpZ : ((p : ZMod 3)) = (2 : ZMod 3) :=
    (ZMod.natCast_eq_natCast_iff' p 2 3).mpr (by
      show p % 3 = 2 % 3
      norm_num [hp3])
  rw [hpZ] at h3
  exact norm_form_ne_two_mod_three a b h3

/-- A representation makes `p` reducible in `ℤ[ω]`. -/
theorem not_irreducible_of_repr_three {p : ℕ} [hp : Fact p.Prime] {a b : ℤ}
    (h : a ^ 2 - a * b + b ^ 2 = (p : ℤ)) : ¬ Irreducible (p : EisensteinInt) := by
  have hp2 : 2 ≤ p := hp.out.two_le
  set π : EisensteinInt := ⟨a, b⟩ with hπdef
  have hnorm : π.normE = (p : ℤ) := h
  have hprod : π * star π = (p : EisensteinInt) := by
    rw [hπdef, mul_star_three_mk]
    ext <;> simp [h]
  intro hirr
  have hunit := hirr.isUnit_or_isUnit hprod.symm
  have hp1 : π.normE = 1 ∨ (star π).normE = 1 := by
    rcases hunit with hu | hu
    · left; exact isUnit_iff_normE_eq_one.mp hu
    · right; exact isUnit_iff_normE_eq_one.mp hu
  rcases hp1 with h1 | h1
  · rw [hnorm] at h1; omega
  · rw [normE_star, hnorm] at h1; omega

theorem irreducible_iff_no_repr_three {p : ℕ} [hp : Fact p.Prime] :
    Irreducible (p : EisensteinInt) ↔ ¬ ∃ a b : ℤ, a ^ 2 - a * b + b ^ 2 = (p : ℤ) := by
  constructor
  · rintro hirr ⟨a, b, hab⟩
    exact not_irreducible_of_repr_three hab hirr
  · intro h
    by_contra hirr
    obtain ⟨a, b, hab⟩ := exists_normE_of_not_irreducible p hirr
    exact h ⟨a, b, hab⟩

/-- **The inert prime is prime:** for `p ≡ 2 (mod 3)`, `(p)` is prime. -/
theorem inert_prime_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    Prime (p : EisensteinInt) := by
  exact (irreducible_iff_prime (a := (p : EisensteinInt))).mp
    ((irreducible_iff_no_repr_three).mpr (not_repr_of_mod_three hp3))

/-! ## The ideal norm of `(n)` and the rank -/

lemma finrank_three : Module.finrank ℤ EisensteinInt = 2 := by
  rw [Module.finrank_eq_card_basis eisensteinBasis]
  simp

lemma absNorm_span_natCast_three (n : ℕ) :
    Ideal.absNorm (Ideal.span ({(n : EisensteinInt)} : Set EisensteinInt)) = n ^ 2 := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  rw [Ideal.absNorm_span_natCast, finrank_three]

/-! ## Inert local counts -/

lemma inert_span_prime_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    (Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr (inert_prime_three hp3)
  intro h
  have hp0 : (p : ℤ) = 0 := by simpa using congr_arg EisensteinInt.re h
  have : p = 0 := by exact_mod_cast hp0
  exact hp.out.ne_zero this

lemma inert_unique_prime_three {p : ℕ} [hp : Fact p.Prime] (hp3 : p % 3 = 2)
    (P : Ideal EisensteinInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) := by
  have hpP : (p : EisensteinInt) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]; exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hle : Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hpP)
  have hmax : (Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt)).IsMaximal :=
    (inert_span_prime_three hp3).isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hp0 : (p : ℤ) = 0 := by simpa using congr_arg EisensteinInt.re h
      exact hp.out.ne_zero (by exact_mod_cast hp0))
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

lemma inert_ideal_eq_span_pow_three (p e : ℕ) [hp : Fact p.Prime]
    (hp3 : p % 3 = 2) (I : Ideal EisensteinInt)
    (hI : Ideal.absNorm I = p ^ (2 * e)) :
    I = (Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt)) ^ e := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  induction e generalizing I with
  | zero =>
      simp only [Nat.mul_zero, pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ e ih =>
      have hp_dvd : p ∣ Ideal.absNorm I := by
        rw [hI]; exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I hp_dvd
      have hP : P = Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) :=
        inert_unique_prime_three hp3 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, rfl⟩ := hPdvd
      have hnormP : Ideal.absNorm P = p ^ 2 := by
        rw [hP, absNorm_span_natCast_three]
      rw [map_mul, hnormP] at hI
      have hJ : Ideal.absNorm J = p ^ (2 * e) := by
        have hpow : p ^ (2 * (e + 1)) = p ^ (2 * e) * p ^ 2 := by
          rw [show 2 * (e + 1) = 2 * e + 2 by omega, pow_add]
        rw [hpow] at hI
        exact Nat.mul_right_cancel (pow_pos hp.out.pos 2) hI
      have hJe := ih J hJ
      rw [hP, hJe, pow_succ]

lemma inert_ideal_count_even_three (p e : ℕ) [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = p ^ (2 * e)} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [inert_ideal_eq_span_pow_three p e hp3 I I.2,
      inert_ideal_eq_span_pow_three p e hp3 J J.2]
  · refine ⟨⟨(Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt)) ^ e, ?_⟩⟩
    rw [map_pow, absNorm_span_natCast_three, ← pow_mul]

lemma inert_no_ideal_norm_prime_three (p : ℕ) [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = p} = 0 := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  have : IsEmpty {I : Ideal EisensteinInt // Ideal.absNorm I = p} := by
    refine ⟨fun I => ?_⟩
    have hI : Ideal.absNorm I.1 = p := I.2
    have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
    obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
      Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I.1 hp_dvd
    have hP : P = Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) :=
      inert_unique_prime_three hp3 P hPunder
    rw [dvd_iff_exists_eq_mul_left] at hPdvd
    obtain ⟨J, hIJ⟩ := hPdvd
    have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_three]
    have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
      rw [hIJ, map_mul, hPnorm]; ring
    rw [hI] at hnorm
    have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
    have hle : p ^ 2 ≤ p := Nat.le_of_dvd hp.out.pos hdiv
    have hp2 : 2 ≤ p := hp.out.two_le
    nlinarith
  exact Nat.card_of_isEmpty

lemma inert_no_ideal_norm_odd_three (p e : ℕ) [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    IsEmpty {I : Ideal EisensteinInt // Ideal.absNorm I = p ^ (2 * e + 1)} := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  induction e with
  | zero =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p := by simpa using I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I.1 hp_dvd
      have hP : P = Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) :=
        inert_unique_prime_three hp3 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_three]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]; ring
      rw [hI] at hnorm
      have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
      have hle : p ^ 2 ≤ p := Nat.le_of_dvd hp.out.pos hdiv
      have hp2 : 2 ≤ p := hp.out.two_le
      nlinarith
  | succ e ih =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p ^ (2 * (e + 1) + 1) := I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by
        rw [hI]; exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I.1 hp_dvd
      have hP : P = Ideal.span ({(p : EisensteinInt)} : Set EisensteinInt) :=
        inert_unique_prime_three hp3 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_three]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]; ring
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = p ^ (2 * e + 1) := by
        have hpow : p ^ (2 * (e + 1) + 1) = p ^ (2 * e + 1) * p ^ 2 := by
          rw [show 2 * (e + 1) + 1 = 2 * e + 1 + 2 by omega, pow_add]
        rw [hpow] at hnorm
        rw [mul_comm (p ^ 2) (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (pow_pos hp.out.pos 2) hnorm).symm
      exact ih.false ⟨J, hJ⟩

lemma inert_ideal_count_odd_three (p e : ℕ) [hp : Fact p.Prime] (hp3 : p % 3 = 2) :
    Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = p ^ (2 * e + 1)} = 0 := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  letI : IsEmpty {I : Ideal EisensteinInt // Ideal.absNorm I = p ^ (2 * e + 1)} :=
    inert_no_ideal_norm_odd_three p e hp3
  exact Nat.card_of_isEmpty

end EisensteinInt

namespace EisensteinInt

/-! ## The ramified prime `1 − ω` -/

lemma norm_one_sub_omega : normE (⟨1, -1⟩ : EisensteinInt) = 3 := by
  simp only [normE]; norm_num

lemma prime_one_sub_omega : Prime (⟨1, -1⟩ : EisensteinInt) := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have hz : normE (⟨1, -1⟩ : EisensteinInt) = 0 := by rw [h]; rfl
    rw [norm_one_sub_omega] at hz
    exact absurd hz (by norm_num)
  · have hnorm : Ideal.absNorm (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)) = 3 := by
      rw [absNorm_span_three, norm_one_sub_omega]
      norm_num
    rw [hnorm]; exact Nat.prime_three

lemma one_sub_omega_sq :
    (⟨1, -1⟩ : EisensteinInt) * ⟨1, -1⟩ = (⟨0, -3⟩ : EisensteinInt) := by
  decide

lemma ramified_three_sq_three :
    Ideal.span ({(3 : EisensteinInt)} : Set EisensteinInt) =
      (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)) ^ 2 := by
  rw [pow_two, Ideal.span_singleton_mul_span_singleton, one_sub_omega_sq,
    Ideal.span_singleton_eq_span_singleton]
  refine ⟨⟨-omega, 1 + omega, ?_, ?_⟩, ?_⟩
  · decide
  · decide
  · decide

lemma ramified_span_prime_three :
    (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr prime_one_sub_omega
  intro h
  have hz : normE (⟨1, -1⟩ : EisensteinInt) = 0 := by rw [h]; rfl
  rw [norm_one_sub_omega] at hz
  exact absurd hz (by norm_num)

lemma ramified_unique_prime_three (P : Ideal EisensteinInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(3 : ℤ)} : Set ℤ)) :
    P = Ideal.span ({⟨1, -1⟩} : Set EisensteinInt) := by
  have h3P : (3 : EisensteinInt) ∈ P := by
    have hmem : (3 : ℤ) ∈ P.under ℤ := by
      rw [hP]; exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hsq : (⟨1, -1⟩ : EisensteinInt) * ⟨1, -1⟩ ∈ P := by
    rw [one_sub_omega_sq]
    -- ⟨0,-3⟩ = -3 * omega ∈ P since 3 ∈ P
    have hthis : (⟨0, -3⟩ : EisensteinInt) = -(3 : EisensteinInt) * omega := by
      decide
    rw [hthis]
    exact P.mul_mem_left omega (P.neg_mem h3P)
  have hprime : P.IsPrime := inferInstance
  have hmem : (⟨1, -1⟩ : EisensteinInt) ∈ P :=
    hprime.mem_of_pow_mem 2 (by simpa [pow_two] using hsq)
  have hle : Ideal.span ({⟨1, -1⟩} : Set EisensteinInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hmem)
  have hmax : (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)).IsMaximal :=
    ramified_span_prime_three.isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hz : normE (⟨1, -1⟩ : EisensteinInt) = 0 := by rw [h]; rfl
      rw [norm_one_sub_omega] at hz
      exact absurd hz (by norm_num))
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

lemma ramified_ideal_eq_span_pow_three (k : ℕ) (I : Ideal EisensteinInt)
    (hI : Ideal.absNorm I = 3 ^ k) :
    I = (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)) ^ k := by
  letI : Module.Free ℤ EisensteinInt := Module.Free.of_basis eisensteinBasis
  letI : Module.Finite ℤ EisensteinInt := Module.Finite.of_basis eisensteinBasis
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ k ih =>
      have h3dvd : 3 ∣ Ideal.absNorm I := by
        rw [hI]; exact dvd_pow_self 3 (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' Nat.prime_three I h3dvd
      have hP : P = Ideal.span ({⟨1, -1⟩} : Set EisensteinInt) :=
        ramified_unique_prime_three P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = 3 := by
        rw [hP, absNorm_span_three, norm_one_sub_omega]
        simp
      have hnorm : Ideal.absNorm I = 3 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]; ring
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = 3 ^ k := by
        have hpow : 3 ^ (k + 1) = 3 ^ k * 3 := by rw [pow_succ]
        rw [hpow] at hnorm
        rw [mul_comm 3 (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (by norm_num : 0 < 3) hnorm).symm
      have hJe := ih J hJ
      rw [hIJ, hP, hJe, pow_succ]

lemma ramified_ideal_count_three (k : ℕ) :
    Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = 3 ^ k} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [ramified_ideal_eq_span_pow_three k I I.2, ramified_ideal_eq_span_pow_three k J J.2]
  · refine ⟨⟨(Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)) ^ k, ?_⟩⟩
    rw [map_pow]
    have hP : Ideal.absNorm (Ideal.span ({⟨1, -1⟩} : Set EisensteinInt)) = 3 := by
      rw [absNorm_span_three, norm_one_sub_omega]
      norm_num
    rw [hP]

end EisensteinInt
