import Mathlib
import QuadraticInt.IdealCountTwo

/-!
# Local ideal counts in `ℤ[√−2]`

The inert and ramified local counts for `d = 2`, completing the prime-by-prime
input to the ideal-count formula.

* **Inert `p ≡ 5, 7 (mod 8)`.** There is no representation `p = a² + 2b²`, purely
  by reduction mod `8` (`a² ∈ {0,1,4}`, `2b² ∈ {0,2}`), so `p` stays prime in
  `ℤ[√−2]`; the unique ideal of norm `p^{2k}` is `(p)^k` and there are none of
  odd norm.
* **Ramified `p = 2`.** `(2) = (√−2)²`; every ideal of norm `2^k` is
  `(√−2)^k`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

namespace ZsqrtdTwo

/-! ## The mod-`8` obstruction -/

lemma sq_add_two_sq_ne_five : ∀ a b : ZMod 8, a ^ 2 + 2 * b ^ 2 ≠ 5 := by decide

lemma sq_add_two_sq_ne_seven : ∀ a b : ZMod 8, a ^ 2 + 2 * b ^ 2 ≠ 7 := by decide

lemma not_repr_of_mod_eight {p : ℕ} (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    ¬ ∃ a b : ℤ, a ^ 2 + 2 * b ^ 2 = (p : ℤ) := by
  rintro ⟨a, b, hab⟩
  have h8 : ((a : ZMod 8)) ^ 2 + 2 * ((b : ZMod 8)) ^ 2 = ((p : ZMod 8)) := by
    have h := congr_arg ((↑) : ℤ → ZMod 8) hab
    push_cast at h
    exact h
  rcases hp8 with hp | hp
  · have hpZ : ((p : ZMod 8)) = (5 : ZMod 8) :=
      (ZMod.natCast_eq_natCast_iff' p 5 8).mpr (by
        show p % 8 = 5 % 8
        norm_num [hp])
    rw [hpZ] at h8
    exact sq_add_two_sq_ne_five a b h8
  · have hpZ : ((p : ZMod 8)) = (7 : ZMod 8) :=
      (ZMod.natCast_eq_natCast_iff' p 7 8).mpr (by
        show p % 8 = 7 % 8
        norm_num [hp])
    rw [hpZ] at h8
    exact sq_add_two_sq_ne_seven a b h8

/-- A representation makes `p` reducible. -/
theorem not_irreducible_of_repr {p : ℕ} [hp : Fact p.Prime] {a b : ℤ}
    (h : a ^ 2 + 2 * b ^ 2 = (p : ℤ)) : ¬ Irreducible (p : R2) := by
  have hp2 : 2 ≤ p := hp.out.two_le
  set π : R2 := ⟨a, b⟩ with hπdef
  have hprod : π * star π = (p : R2) := by
    rw [hπdef, mul_star_two_mk]
    have hcast : ((a : ℤ) ^ 2 + 2 * (b : ℤ) ^ 2) = (p : ℤ) := h
    ext <;> simp [hcast]
  have hnorm : π.norm = (p : ℤ) := by
    rw [hπdef, norm_two_mk, h]
  intro hirr
  have hunit := hirr.isUnit_or_isUnit hprod.symm
  have hp1 : (p : ℤ) = 1 ∨ (p : ℤ) = -1 := by
    rcases hunit with hu | hu
    · left
      have := (Zsqrtd.norm_eq_one_iff' (by norm_num : (-2 : ℤ) ≤ 0) π).mpr hu
      rw [hnorm] at this; exact this
    · left
      have hn : (star π).norm = (p : ℤ) := by rw [Zsqrtd.norm_conj, hnorm]
      have := (Zsqrtd.norm_eq_one_iff' (by norm_num : (-2 : ℤ) ≤ 0) (star π)).mpr hu
      rw [hn] at this; exact this
  rcases hp1 with h1 | h1 <;> nlinarith

/-- `p` is irreducible in `ℤ[√−2]` iff `p` is not of the form `a² + 2b²`. -/
theorem irreducible_iff_no_repr {p : ℕ} [hp : Fact p.Prime] :
    Irreducible (p : R2) ↔ ¬ ∃ a b : ℤ, a ^ 2 + 2 * b ^ 2 = (p : ℤ) := by
  constructor
  · rintro hirr ⟨a, b, hab⟩
    exact not_irreducible_of_repr hab hirr
  · intro h
    by_contra hirr
    obtain ⟨a, b, hab⟩ := exists_nat_repr_of_not_irreducible p hirr
    exact h ⟨(a : ℤ), (b : ℤ), by exact_mod_cast hab⟩

/-- **The inert prime is prime:** for `p ≡ 5, 7 (mod 8)`, `(p)` is prime. -/
theorem inert_prime_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    Prime (p : R2) := by
  exact (irreducible_iff_prime (a := (p : R2))).mp
    ((irreducible_iff_no_repr).mpr (not_repr_of_mod_eight hp8))

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## The ideal norm of `(n)` and the rank -/

lemma finrank_two : Module.finrank ℤ R2 = 2 := by
  rw [Module.finrank_eq_card_basis sqrtdBasis]
  simp

lemma absNorm_span_natCast_two (n : ℕ) :
    Ideal.absNorm (Ideal.span ({(n : R2)} : Set R2)) = n ^ 2 := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  rw [Ideal.absNorm_span_natCast, finrank_two]

/-! ## Inert primes: `(p)` is prime and unique above `p` -/

lemma inert_span_prime_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    (Ideal.span ({(p : R2)} : Set R2)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr (inert_prime_two hp8)
  intro h
  have hp0 : (p : ℤ) = 0 := by simpa using congr_arg Zsqrtd.re h
  have : p = 0 := by exact_mod_cast hp0
  exact hp.out.ne_zero this

lemma inert_unique_prime_two {p : ℕ} [hp : Fact p.Prime] (hp8 : p % 8 = 5 ∨ p % 8 = 7)
    (P : Ideal R2) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(p : R2)} : Set R2) := by
  have hpP : (p : R2) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]; exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hle : Ideal.span ({(p : R2)} : Set R2) ≤ P :=
    Ideal.span_le.mpr (by simpa using hpP)
  have hmax : (Ideal.span ({(p : R2)} : Set R2)).IsMaximal :=
    (inert_span_prime_two hp8).isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hp0 : (p : ℤ) = 0 := by simpa using congr_arg Zsqrtd.re h
      exact hp.out.ne_zero (by exact_mod_cast hp0))
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

/-- Every ideal of norm `p^(2e)` is `(p)^e` for an inert prime. -/
lemma inert_ideal_eq_span_pow_two (p e : ℕ) [hp : Fact p.Prime]
    (hp8 : p % 8 = 5 ∨ p % 8 = 7) (I : Ideal R2)
    (hI : Ideal.absNorm I = p ^ (2 * e)) :
    I = (Ideal.span ({(p : R2)} : Set R2)) ^ e := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
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
      have hP : P = Ideal.span ({(p : R2)} : Set R2) := inert_unique_prime_two hp8 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, rfl⟩ := hPdvd
      have hnormP : Ideal.absNorm P = p ^ 2 := by
        rw [hP, absNorm_span_natCast_two]
      rw [map_mul, hnormP] at hI
      have hJ : Ideal.absNorm J = p ^ (2 * e) := by
        have hpow : p ^ (2 * (e + 1)) = p ^ (2 * e) * p ^ 2 := by
          rw [show 2 * (e + 1) = 2 * e + 2 by omega, pow_add]
        rw [hpow] at hI
        exact Nat.mul_right_cancel (pow_pos hp.out.pos 2) hI
      have hJe := ih J hJ
      rw [hP, hJe, pow_succ]

lemma inert_ideal_count_even_two (p e : ℕ) [hp : Fact p.Prime]
    (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    Nat.card {I : Ideal R2 // Ideal.absNorm I = p ^ (2 * e)} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [inert_ideal_eq_span_pow_two p e hp8 I I.2,
      inert_ideal_eq_span_pow_two p e hp8 J J.2]
  · refine ⟨⟨(Ideal.span ({(p : R2)} : Set R2)) ^ e, ?_⟩⟩
    rw [map_pow, absNorm_span_natCast_two, ← pow_mul]

lemma inert_no_ideal_norm_prime_two (p : ℕ) [hp : Fact p.Prime]
    (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    Nat.card {I : Ideal R2 // Ideal.absNorm I = p} = 0 := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  have : IsEmpty {I : Ideal R2 // Ideal.absNorm I = p} := by
    refine ⟨fun I => ?_⟩
    have hI : Ideal.absNorm I.1 = p := I.2
    have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
    obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
      Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I.1 hp_dvd
    have hP : P = Ideal.span ({(p : R2)} : Set R2) := inert_unique_prime_two hp8 P hPunder
    rw [dvd_iff_exists_eq_mul_left] at hPdvd
    obtain ⟨J, hIJ⟩ := hPdvd
    have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_two]
    have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
      rw [hIJ, map_mul, hPnorm]; ring
    rw [hI] at hnorm
    have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
    have hle : p ^ 2 ≤ p := Nat.le_of_dvd hp.out.pos hdiv
    have hp2 : 2 ≤ p := hp.out.two_le
    nlinarith
  exact Nat.card_of_isEmpty

lemma inert_no_ideal_norm_odd_two (p e : ℕ) [hp : Fact p.Prime]
    (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    IsEmpty {I : Ideal R2 // Ideal.absNorm I = p ^ (2 * e + 1)} := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  induction e with
  | zero =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p := by simpa using I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' hp.out I.1 hp_dvd
      have hP : P = Ideal.span ({(p : R2)} : Set R2) := inert_unique_prime_two hp8 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_two]
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
      have hP : P = Ideal.span ({(p : R2)} : Set R2) := inert_unique_prime_two hp8 P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by rw [hP, absNorm_span_natCast_two]
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

lemma inert_ideal_count_odd_two (p e : ℕ) [hp : Fact p.Prime]
    (hp8 : p % 8 = 5 ∨ p % 8 = 7) :
    Nat.card {I : Ideal R2 // Ideal.absNorm I = p ^ (2 * e + 1)} = 0 := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  letI : IsEmpty {I : Ideal R2 // Ideal.absNorm I = p ^ (2 * e + 1)} :=
    inert_no_ideal_norm_odd_two p e hp8
  exact Nat.card_of_isEmpty

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## The ramified prime `√−2` -/

lemma norm_sqrtd_two : (Zsqrtd.sqrtd : R2).norm = 2 := by
  rw [Zsqrtd.norm_def]; norm_num

lemma prime_sqrtd_two : Prime (Zsqrtd.sqrtd : R2) := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have hz : (Zsqrtd.sqrtd : R2).norm = 0 := by rw [h]; rfl
    rw [norm_sqrtd_two] at hz
    exact absurd hz (by norm_num)
  · have hnorm : Ideal.absNorm (Ideal.span ({Zsqrtd.sqrtd} : Set R2)) = 2 := by
      rw [absNorm_span_two, norm_sqrtd_two]
      norm_num
    rw [hnorm]; exact Nat.prime_two

lemma ramified_two_sq_two :
    Ideal.span ({(2 : R2)} : Set R2) = (Ideal.span ({Zsqrtd.sqrtd} : Set R2)) ^ 2 := by
  rw [pow_two, Ideal.span_singleton_mul_span_singleton,
    Ideal.span_singleton_eq_span_singleton]
  refine ⟨-1, ?_⟩
  rw [Zsqrtd.dmuld]
  ext <;> simp

lemma ramified_span_prime_two :
    (Ideal.span ({Zsqrtd.sqrtd} : Set R2)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr prime_sqrtd_two
  intro h
  have hz : (Zsqrtd.sqrtd : R2).norm = 0 := by rw [h]; rfl
  rw [norm_sqrtd_two] at hz
  exact absurd hz (by norm_num)

lemma ramified_unique_prime_two (P : Ideal R2) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(2 : ℤ)} : Set ℤ)) :
    P = Ideal.span ({Zsqrtd.sqrtd} : Set R2) := by
  have h2P : (2 : R2) ∈ P := by
    have hmem : (2 : ℤ) ∈ P.under ℤ := by
      rw [hP]; exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hsq : (Zsqrtd.sqrtd : R2) * Zsqrtd.sqrtd ∈ P := by
    rw [Zsqrtd.dmuld]
    -- 2 ∈ P and -2 = -(2) ∈ P
    exact P.neg_mem h2P
  have hprime : P.IsPrime := inferInstance
  have hmem : (Zsqrtd.sqrtd : R2) ∈ P :=
    hprime.mem_of_pow_mem 2 (by simpa [pow_two] using hsq)
  have hle : Ideal.span ({Zsqrtd.sqrtd} : Set R2) ≤ P :=
    Ideal.span_le.mpr (by simpa using hmem)
  have hmax : (Ideal.span ({Zsqrtd.sqrtd} : Set R2)).IsMaximal :=
    ramified_span_prime_two.isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hz : (Zsqrtd.sqrtd : R2).norm = 0 := by rw [h]; rfl
      rw [norm_sqrtd_two] at hz
      exact absurd hz (by norm_num))
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

lemma ramified_ideal_eq_span_pow_two (k : ℕ) (I : Ideal R2)
    (hI : Ideal.absNorm I = 2 ^ k) :
    I = (Ideal.span ({Zsqrtd.sqrtd} : Set R2)) ^ k := by
  letI : Module.Free ℤ R2 := Module.Free.of_basis sqrtdBasis
  letI : Module.Finite ℤ R2 := Module.Finite.of_basis sqrtdBasis
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ k ih =>
      have h2dvd : 2 ∣ Ideal.absNorm I := by
        rw [hI]; exact dvd_pow_self 2 (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' Nat.prime_two I h2dvd
      have hP : P = Ideal.span ({Zsqrtd.sqrtd} : Set R2) :=
        ramified_unique_prime_two P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = 2 := by
        rw [hP, absNorm_span_two, norm_sqrtd_two]
        norm_num
      have hnorm : Ideal.absNorm I = 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]; ring
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = 2 ^ k := by
        have hpow : 2 ^ (k + 1) = 2 ^ k * 2 := by rw [pow_succ]
        rw [hpow] at hnorm
        rw [mul_comm 2 (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (by norm_num : 0 < 2) hnorm).symm
      have hJe := ih J hJ
      rw [hIJ, hP, hJe, pow_succ]

lemma ramified_ideal_count_two (k : ℕ) :
    Nat.card {I : Ideal R2 // Ideal.absNorm I = 2 ^ k} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [ramified_ideal_eq_span_pow_two k I I.2, ramified_ideal_eq_span_pow_two k J J.2]
  · refine ⟨⟨(Ideal.span ({Zsqrtd.sqrtd} : Set R2)) ^ k, ?_⟩⟩
    rw [map_pow]
    have hP : Ideal.absNorm (Ideal.span ({Zsqrtd.sqrtd} : Set R2)) = 2 := by
      rw [absNorm_span_two, norm_sqrtd_two]
      norm_num
    rw [hP]

end ZsqrtdTwo
