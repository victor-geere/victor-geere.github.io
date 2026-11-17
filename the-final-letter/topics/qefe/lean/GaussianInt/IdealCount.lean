import Mathlib
import GaussianInt.Norm

/-!
# Ideal counts in `ℤ[i]`: splitting, local counts, multiplicativity

Standalone, Mathlib-only extraction of declarations T138–T198 of `Topic.lean`.
The main results are the local ideal counts at the three prime types
(`p ≡ 1 mod 4` split, `p ≡ 3 mod 4` inert, `p = 2` ramified), multiplicativity of
the ideal count over coprime norms, and the `ArithmeticFunction` assembly proving

`# { I : Ideal ℤ[i] // absNorm I = n } = Σ_{d ∣ n} χ₄(d)`.

Nothing in this file refers to `r2` or to the QEFE ledger.
-/

noncomputable section

open scoped BigOperators

namespace GaussianInt

/-- The quadratic character `χ₄` on the integers, with complex values. -/
def chi4Int (n : ℤ) : ℂ := ((ZMod.χ₄ (n : ZMod 4) : ℤ) : ℂ)

/-- The divisor sum `Σ_{d|n} χ₄(d)`. -/
def divisorSumChi4 (n : ℕ) : ℤ :=
  ∑ d ∈ n.divisors, ZMod.χ₄ (d : ZMod 4)

/-- Named arithmetic input: the number of ideals of norm `n` is `Σ_{d|n} χ₄(d)`. -/
def IdealCountFormula : Prop :=
  ∀ n : ℕ, 1 ≤ n →
    (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} : ℤ) = divisorSumChi4 n

/-! ## Splitting of rational primes in `ℤ[i]` -/

lemma gaussian_star_mk (a b : ℤ) : star (⟨a, b⟩ : GaussianInt) = ⟨a, -b⟩ := by
  ext <;> simp

lemma gaussian_mul_star_mk (a b : ℤ) :
    (⟨a, b⟩ : GaussianInt) * star (⟨a, b⟩ : GaussianInt) = (⟨a^2 + b^2, 0⟩ : GaussianInt) := by
  rw [gaussian_star_mk]
  ext <;> simp <;> ring

lemma gaussian_norm_mk' (a b : ℤ) : (⟨a, b⟩ : GaussianInt).norm = a^2 + b^2 := by
  rw [Zsqrtd.norm_def]; ring

/-- **T138:** a prime `p ≡ 1 mod 4` splits as `π * star π` in `ℤ[i]`. -/
theorem gaussian_split_prime {p : ℕ} [Fact p.Prime] (hp4 : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ π * star π = (p : GaussianInt) := by
  let hp : p.Prime := Fact.out
  letI : Fact p.Prime := ⟨hp⟩
  have hp3 : p % 4 ≠ 3 := by omega
  obtain ⟨a, b, hab⟩ := Nat.Prime.sq_add_sq (p := p) hp3
  refine ⟨⟨(a:ℤ), (b:ℤ)⟩, ?_, ?_⟩
  · apply Ideal.prime_of_irreducible_absNorm_span
    · intro h
      have hz : (⟨(a:ℤ), (b:ℤ)⟩ : GaussianInt).norm = 0 := by rw [h]; rfl
      rw [GaussianInt.norm_eq_zero] at hz
      -- contradiction with norm = p > 0
      have hnorm : (⟨(a:ℤ), (b:ℤ)⟩ : GaussianInt).norm = (p:ℤ) := by
        rw [gaussian_norm_mk']; exact_mod_cast hab
      rw [hz] at hnorm
      simp at hnorm
      have hpz : p = 0 := by exact_mod_cast hnorm.symm
      exact hp.ne_zero hpz
    · have hnorm : Ideal.absNorm (Ideal.span ({⟨(a:ℤ), (b:ℤ)⟩} : Set GaussianInt)) = p := by
        rw [absNorm_span_gaussian, gaussian_norm_mk']
        rw [show (a:ℤ)^2 + (b:ℤ)^2 = (p:ℤ) by exact_mod_cast hab]
        exact Int.natAbs_natCast p
      rw [hnorm]
      exact hp
  · rw [gaussian_mul_star_mk]
    have h : ((a:ℤ)^2 + (b:ℤ)^2) = (p:ℤ) := by exact_mod_cast hab
    ext <;> simp [h]

/-- **T139:** the principal ideal `(p)` factors as `(π)(star π)` for `p ≡ 1 mod 4`. -/
theorem gaussian_span_prime_factorization {p : ℕ} [Fact p.Prime] (hp4 : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧
      Ideal.span ({π} : Set GaussianInt) * Ideal.span ({star π} : Set GaussianInt) =
        Ideal.span ({(p : GaussianInt)} : Set GaussianInt) := by
  obtain ⟨π, hprime, hprod⟩ := gaussian_split_prime hp4
  exact ⟨π, hprime, by rw [Ideal.span_singleton_mul_span_singleton, hprod]⟩


/-! ## Inert and ramified primes in `ℤ[i]` -/

#check @GaussianInt.prime_iff_mod_four_eq_three_of_nat_prime
#check @Ideal.span_singleton_prime
#check @Ideal.absNorm_span_natCast
#check @Module.finrank_eq_card_basis
#check @Module.finrank_fin_fun

example : Module.finrank ℤ GaussianInt = 2 := by
  rw [Module.finrank_eq_card_basis gaussianBasis]
  simp

lemma gaussian_finrank : Module.finrank ℤ GaussianInt = 2 := by
  rw [Module.finrank_eq_card_basis gaussianBasis]
  simp

/-- **T140:** see the theorem statement. -/
lemma gaussian_absNorm_span_natCast (n : ℕ) :
    Ideal.absNorm (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = n^2 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  rw [Ideal.absNorm_span_natCast, gaussian_finrank]

/-- **T141:** see the theorem statement. -/
lemma gaussian_inert_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) :
    Prime (p : GaussianInt) :=
  (GaussianInt.prime_iff_mod_four_eq_three_of_nat_prime p).mpr hp

def gaussianI : GaussianInt := ⟨0, 1⟩

lemma gaussianI_sq : gaussianI ^ 2 = (-1 : GaussianInt) := by
  decide

lemma gaussian_one_add_I_sq : (1 + gaussianI) ^ 2 = 2 * gaussianI := by
  decide

/-- **T142:** see the theorem statement. -/
lemma gaussian_prime_one_add_I : Prime (1 + gaussianI) := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have := congr_arg Zsqrtd.re h
    simp [gaussianI] at this
  · have hnorm : Ideal.absNorm (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) = 2 := by
      rw [absNorm_span_gaussian, gaussian_norm_mk]
      norm_num [gaussianI]
    rw [hnorm]
    exact Nat.prime_two

/-- **T143:** see the theorem statement. -/
lemma gaussian_ramified_two :
    Ideal.span ({(2 : GaussianInt)} : Set GaussianInt) =
      Ideal.span ({(1 + gaussianI)} : Set GaussianInt) ^ 2 := by
  rw [pow_two, Ideal.span_singleton_mul_span_singleton, ← pow_two, gaussian_one_add_I_sq]
  rw [Ideal.span_singleton_eq_span_singleton]
  exact ⟨gaussianIUnit, by simp [gaussianIUnit, gaussianI]⟩


/-- **T144:** the ideal `(p)` is prime for inert `p ≡ 3 mod 4`. -/
lemma gaussian_inert_span_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) :
    (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr (gaussian_inert_prime hp)
  intro h
  have hpz : (p : GaussianInt) = 0 := h
  have := congr_arg Zsqrtd.re hpz
  simp at this
  exact (Fact.out : p.Prime).ne_zero this

/-- **T145:** the ramified ideal `(1+i)` is prime. -/
lemma gaussian_ramified_span_prime :
    (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)).IsPrime := by
  apply (Ideal.span_singleton_prime ?_).mpr gaussian_prime_one_add_I
  intro h
  have := congr_arg Zsqrtd.re h
  simp [gaussianI] at this


/-- **T146:** the unique maximal ideal above an inert prime `p ≡ 3 mod 4`. -/
lemma gaussian_inert_unique_prime {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3)
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) := by
  have hpP : (p : GaussianInt) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hle : Ideal.span ({(p : GaussianInt)} : Set GaussianInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hpP)
  have hmax : (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)).IsMaximal :=
    (gaussian_inert_span_prime hp).isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have hp0 : p = 0 := by exact_mod_cast h
      exact (Fact.out : p.Prime).ne_zero hp0)
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm


/-! ## Local ideal count: inert primes -/

/-- **T147:** every ideal of norm `p^(2e)` is `(p)^e` for inert `p`. -/
lemma gaussian_inert_ideal_eq_span_pow (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3)
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ (2 * e)) :
    I = (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ e := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction e generalizing I with
  | zero =>
      simp only [Nat.mul_zero, pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ e ih =>
      have hp_dvd : p ∣ Ideal.absNorm I := by
        rw [hI]
        exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, rfl⟩ := hPdvd
      have hnormP : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      rw [map_mul, hnormP] at hI
      have hJ : Ideal.absNorm J = p ^ (2 * e) := by
        have hpow : p ^ (2 * (e + 1)) = p ^ (2 * e) * p ^ 2 := by
          rw [show 2 * (e + 1) = 2 * e + 2 by omega, pow_add]
        rw [hpow] at hI
        exact Nat.mul_right_cancel (pow_pos (Fact.out : p.Prime).pos 2) hI
      have hJe := ih J hJ
      rw [hP, hJe, pow_succ]

/-- **T148:** the inert even-exponent local ideal count is one. -/
lemma gaussian_inert_ideal_count_even (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e)} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [gaussian_inert_ideal_eq_span_pow p e hp I I.2,
      gaussian_inert_ideal_eq_span_pow p e hp J J.2]
  · refine ⟨⟨(Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ e, ?_⟩⟩
    rw [map_pow, gaussian_absNorm_span_natCast]
    rw [← pow_mul]


/-- **T149:** there is no ideal of norm `p` for inert `p`. -/
lemma gaussian_inert_no_ideal_norm_prime (p : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p} = 0 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  have : IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p} := by
    refine ⟨fun I => ?_⟩
    have hI : Ideal.absNorm I.1 = p := I.2
    have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
    obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
      Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
    have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
      gaussian_inert_unique_prime hp P hPunder
    rw [dvd_iff_exists_eq_mul_left] at hPdvd
    obtain ⟨J, hIJ⟩ := hPdvd
    have hPnorm : Ideal.absNorm P = p ^ 2 := by
      rw [hP, gaussian_absNorm_span_natCast]
    have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
      rw [hIJ, map_mul, hPnorm]
      ring
    rw [hI] at hnorm
    have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
    have hle : p ^ 2 ≤ p := Nat.le_of_dvd (Fact.out : p.Prime).pos hdiv
    have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
    nlinarith
  exact Nat.card_of_isEmpty

/-- **T150:** there is no ideal of odd exponent norm for inert `p`. -/
lemma gaussian_inert_no_ideal_norm_odd (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction e with
  | zero =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p := by simpa using I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by rw [hI]
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]
        ring
      rw [hI] at hnorm
      have hdiv : p ^ 2 ∣ p := ⟨Ideal.absNorm J, hnorm⟩
      have hle : p ^ 2 ≤ p := Nat.le_of_dvd (Fact.out : p.Prime).pos hdiv
      have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
      nlinarith
  | succ e ih =>
      refine ⟨fun I => ?_⟩
      have hI : Ideal.absNorm I.1 = p ^ (2 * (e + 1) + 1) := I.2
      have hp_dvd : p ∣ Ideal.absNorm I.1 := by
        rw [hI]
        exact dvd_pow_self p (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I.1 hp_dvd
      have hP : P = Ideal.span ({(p : GaussianInt)} : Set GaussianInt) :=
        gaussian_inert_unique_prime hp P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = p ^ 2 := by
        rw [hP, gaussian_absNorm_span_natCast]
      have hnorm : Ideal.absNorm I.1 = p ^ 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm]
        ring
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = p ^ (2 * e + 1) := by
        have hpow : p ^ (2 * (e + 1) + 1) = p ^ (2 * e + 1) * p ^ 2 := by
          rw [show 2 * (e + 1) + 1 = 2 * e + 1 + 2 by omega, pow_add]
        rw [hpow] at hnorm
        rw [mul_comm (p ^ 2) (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (pow_pos (Fact.out : p.Prime).pos 2) hnorm).symm
      exact ih.false ⟨J, hJ⟩


/-- **T151:** the inert odd-exponent local ideal count is zero. -/
lemma gaussian_inert_ideal_count_odd (p e : ℕ) [Fact p.Prime] (hp : p % 4 = 3) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} = 0 := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  letI : IsEmpty {I : Ideal GaussianInt // Ideal.absNorm I = p ^ (2 * e + 1)} :=
    gaussian_inert_no_ideal_norm_odd p e hp
  exact Nat.card_of_isEmpty


/-! ## Local ideal count: the ramified prime -/

/-- **T152:** the unique maximal ideal above `2` is `(1+i)`. -/
lemma gaussian_ramified_unique_prime (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(2 : ℤ)} : Set ℤ)) :
    P = Ideal.span ({(1 + gaussianI)} : Set GaussianInt) := by
  have h2P : (2 : GaussianInt) ∈ P := by
    have hmem : (2 : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hsq : (1 + gaussianI) ^ 2 ∈ P := by
    rw [gaussian_one_add_I_sq]
    exact P.mul_mem_right gaussianI h2P
  have hprime : P.IsPrime := inferInstance
  have hmem : (1 + gaussianI) ∈ P := hprime.mem_of_pow_mem 2 hsq
  have hle : Ideal.span ({(1 + gaussianI)} : Set GaussianInt) ≤ P :=
    Ideal.span_le.mpr (by simpa using hmem)
  have hmax : (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)).IsMaximal :=
    gaussian_ramified_span_prime.isMaximal (by
      intro h
      rw [Ideal.span_singleton_eq_bot] at h
      have := congr_arg Zsqrtd.re h
      simp [gaussianI] at this)
  exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm

/-- **T153:** every ideal of norm `2^k` is `(1+i)^k`. -/
lemma gaussian_ramified_ideal_eq_span_pow (k : ℕ) (I : Ideal GaussianInt)
    (hI : Ideal.absNorm I = 2 ^ k) :
    I = (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) ^ k := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      rw [hI, pow_zero]
      simp
  | succ k ih =>
      have h2dvd : 2 ∣ Ideal.absNorm I := by
        rw [hI]
        exact dvd_pow_self 2 (by omega)
      obtain ⟨P, hPmax, hPunder, hPdvd⟩ :=
        Ideal.exists_isMaximal_dvd_of_dvd_absNorm' Nat.prime_two I h2dvd
      have hP : P = Ideal.span ({(1 + gaussianI)} : Set GaussianInt) :=
        gaussian_ramified_unique_prime P hPunder
      rw [dvd_iff_exists_eq_mul_left] at hPdvd
      obtain ⟨J, hIJ⟩ := hPdvd
      have hPnorm : Ideal.absNorm P = 2 := by
        rw [hP, absNorm_span_gaussian, gaussian_norm_mk]
        norm_num [gaussianI]
      have hnorm : Ideal.absNorm I = 2 * Ideal.absNorm J := by
        rw [hIJ, map_mul, hPnorm, mul_comm]
      rw [hI] at hnorm
      have hJ : Ideal.absNorm J = 2 ^ k := by
        have hpow : 2 ^ (k + 1) = 2 ^ k * 2 := by rw [pow_succ]
        rw [hpow] at hnorm
        rw [mul_comm 2 (Ideal.absNorm J)] at hnorm
        exact (Nat.mul_right_cancel (by norm_num : 0 < 2) hnorm).symm
      have hJe := ih J hJ
      rw [hIJ, hP, hJe, pow_succ]

/-- **T154:** the ramified local ideal count is one. -/
lemma gaussian_ramified_ideal_count (k : ℕ) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = 2 ^ k} = 1 := by
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [gaussian_ramified_ideal_eq_span_pow k I I.2,
      gaussian_ramified_ideal_eq_span_pow k J J.2]
  · refine ⟨⟨(Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) ^ k, ?_⟩⟩
    rw [map_pow]
    have hP : Ideal.absNorm (Ideal.span ({(1 + gaussianI)} : Set GaussianInt)) = 2 := by
      rw [absNorm_span_gaussian, gaussian_norm_mk]
      norm_num [gaussianI]
    rw [hP]


/-! ## Ideals divide their norm ideal -/

/-- **T155:** every ideal divides the principal ideal generated by its norm. -/
lemma gaussian_ideal_dvd_span_absNorm (I : Ideal GaussianInt) :
    I ∣ Ideal.span ({((Ideal.absNorm I : ℕ) : GaussianInt)} : Set GaussianInt) := by
  rw [Ideal.dvd_iff_le]
  exact Ideal.span_le.mpr (by simpa using Ideal.absNorm_mem I)

/-- **T156:** an ideal of norm `p^k` divides `(p)^k`. -/
lemma gaussian_ideal_dvd_span_pow_of_absNorm (p k : ℕ) (I : Ideal GaussianInt)
    (hI : Ideal.absNorm I = p ^ k) :
    I ∣ (Ideal.span ({(p : GaussianInt)} : Set GaussianInt)) ^ k := by
  have h := gaussian_ideal_dvd_span_absNorm I
  rw [hI] at h
  rw [Ideal.span_singleton_pow]
  simpa [Nat.cast_pow] using h


/-- **T157:** a maximal ideal above a split prime `p` is `(π)` or `(star π)`. -/
lemma gaussian_split_maximal_eq {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (π : GaussianInt) (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    P = Ideal.span ({π} : Set GaussianInt) ∨
      P = Ideal.span ({star π} : Set GaussianInt) := by
  have hpP : (p : GaussianInt) ∈ P := by
    have hmem : (p : ℤ) ∈ P.under ℤ := by
      rw [hP]
      exact Ideal.subset_span (by simp)
    simpa [Ideal.mem_under] using hmem
  have hmem : π * star π ∈ P := by
    rw [hprod]
    exact hpP
  have hprime : P.IsPrime := inferInstance
  rcases hprime.mem_or_mem hmem with h | h
  · left
    have hle : Ideal.span ({π} : Set GaussianInt) ≤ P :=
      Ideal.span_le.mpr (by simpa using h)
    have hmax : (Ideal.span ({π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ.ne_zero).mpr hπ).isMaximal (by
        intro h
        rw [Ideal.span_singleton_eq_bot] at h
        exact hπ.ne_zero h)
    exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm
  · right
    have hle : Ideal.span ({star π} : Set GaussianInt) ≤ P :=
      Ideal.span_le.mpr (by simpa using h)
    have hmax : (Ideal.span ({star π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ'.ne_zero).mpr hπ').isMaximal (by
        intro h
        rw [Ideal.span_singleton_eq_bot] at h
        exact hπ'.ne_zero h)
    exact (hmax.eq_of_le (inferInstance : P.IsMaximal).ne_top hle).symm


/-- **T158:** a Gaussian integer of prime norm is prime. -/
lemma gaussian_prime_of_norm_natAbs {p : ℕ} [Fact p.Prime] {z : GaussianInt}
    (hz : z.norm.natAbs = p) : Prime z := by
  apply Ideal.prime_of_irreducible_absNorm_span
  · intro h
    have hp0 : p = 0 := by
      rw [← hz, h]
      rfl
    exact (Fact.out : p.Prime).ne_zero hp0
  · have hnorm : Ideal.absNorm (Ideal.span ({z} : Set GaussianInt)) = p := by
      rw [absNorm_span_gaussian, hz]
    rw [hnorm]
    exact (Fact.out : p.Prime)

/-- **T159:** both `π` and `star π` are prime in the split factorization. -/
lemma gaussian_split_prime_star {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) := by
  obtain ⟨π, hπ, hprod⟩ := gaussian_split_prime hp
  refine ⟨π, hπ, ?_, hprod⟩
  have hnorm_mul : π.norm * (star π).norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, hprod]
    rw [Zsqrtd.norm_def]
    simp
    ring
  rw [Zsqrtd.norm_conj] at hnorm_mul
  have hnonneg : 0 ≤ π.norm := Zsqrtd.norm_nonneg (by norm_num) π
  have hnorm : π.norm = (p : ℤ) := by nlinarith
  apply gaussian_prime_of_norm_natAbs (p := p)
  rw [Zsqrtd.norm_conj, hnorm]
  simp

/-- **T160:** unconditional classification of maximal ideals above a split prime. -/
lemma gaussian_split_maximal_eq' {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (P : Ideal GaussianInt) [P.IsMaximal]
    (hP : P.under ℤ = Ideal.span ({(p : ℤ)} : Set ℤ)) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) ∧
      (P = Ideal.span ({π} : Set GaussianInt) ∨
        P = Ideal.span ({star π} : Set GaussianInt)) := by
  obtain ⟨π, hπ, hπ', hprod⟩ := gaussian_split_prime_star hp
  exact ⟨π, hπ, hπ', hprod, gaussian_split_maximal_eq hp π hπ hπ' hprod P hP⟩


/-- **T161:** the split factor `π` has norm `p`. -/
lemma gaussian_split_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) : π.norm.natAbs = p := by
  have hnorm_mul : π.norm * (star π).norm = (p : ℤ) ^ 2 := by
    rw [← Zsqrtd.norm_mul, hprod]
    rw [Zsqrtd.norm_def]
    simp
    ring
  rw [Zsqrtd.norm_conj] at hnorm_mul
  have hnonneg : 0 ≤ π.norm := Zsqrtd.norm_nonneg (by norm_num) π
  have hnorm : π.norm = (p : ℤ) := by nlinarith
  rw [hnorm]
  simp

/-- **T162:** both split prime ideals have norm `p`. -/
lemma gaussian_split_span_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) :
    Ideal.absNorm (Ideal.span ({π} : Set GaussianInt)) = p ∧
      Ideal.absNorm (Ideal.span ({star π} : Set GaussianInt)) = p := by
  constructor
  · rw [absNorm_span_gaussian, gaussian_split_norm hprod]
  · rw [absNorm_span_gaussian, Zsqrtd.norm_conj, gaussian_split_norm hprod]


/-- **T163:** the two split prime ideals are distinct. -/
lemma gaussian_split_span_ne {p : ℕ} [Fact p.Prime] {a b : ℤ}
    (hp : (p : ℤ) % 4 = 1) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a ^ 2 + b ^ 2 = (p : ℤ)) :
    Ideal.span ({⟨a, b⟩} : Set GaussianInt) ≠
      Ideal.span ({star (⟨a, b⟩ : GaussianInt)} : Set GaussianInt) := by
  intro h
  have hassoc : Associated (⟨a, b⟩ : GaussianInt) (star (⟨a, b⟩ : GaussianInt)) :=
    (gaussian_span_eq_iff_associated _ _).mp h
  obtain ⟨u, hu⟩ := hassoc
  rcases gaussian_unit_classification u with h1 | h1 | h1 | h1
  · have hπ : (⟨a, b⟩ : GaussianInt) = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at him
    exact hb (by linarith)
  · have hπ : -(⟨a, b⟩ : GaussianInt) = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    simp [Zsqrtd.star_mk] at hre
    exact ha (by linarith)
  · have hπ : (⟨a, b⟩ : GaussianInt) * ⟨0, 1⟩ = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at hre him
    have hab' : a = -b := by linarith
    have h2dvd : 2 ∣ (p : ℤ) := ⟨a ^ 2, by rw [← hab, hab']; ring⟩
    omega
  · have hπ : (⟨a, b⟩ : GaussianInt) * ⟨0, -1⟩ = star (⟨a, b⟩ : GaussianInt) := by
      simpa [h1] using hu
    have hre := congr_arg Zsqrtd.re hπ
    have him := congr_arg Zsqrtd.im hπ
    simp [Zsqrtd.star_mk] at hre him
    have hab' : a = b := by linarith
    have h2dvd : 2 ∣ (p : ℤ) := ⟨a ^ 2, by rw [← hab, hab']; ring⟩
    omega

/-- **T164:** the split representation has both coordinates nonzero. -/
lemma gaussian_split_nonzero_data {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ a b : ℤ, a ≠ 0 ∧ b ≠ 0 ∧ a ^ 2 + b ^ 2 = (p : ℤ) := by
  have hp3 : p % 4 ≠ 3 := by omega
  obtain ⟨a, b, hab⟩ := Nat.Prime.sq_add_sq (p := p) hp3
  have hpp : Nat.Prime p := Fact.out
  have ha : (a : ℤ) ≠ 0 := by
    intro h
    have ha0 : a = 0 := by exact_mod_cast h
    have hp_sq : p = b ^ 2 := by
      rw [← hab]
      simp [ha0]
    have hdvd : b ∣ p := ⟨b, by rw [hp_sq]; ring⟩
    rcases hpp.eq_one_or_self_of_dvd b hdvd with hb1 | hbp
    · subst hb1
      have hp1 : p = 1 := by simpa using hp_sq
      exact hpp.ne_one hp1
    · subst hbp
      nlinarith [hpp.two_le]
  refine ⟨(a : ℤ), (b : ℤ), ha, ?_, ?_⟩
  · intro h
    have hb0 : b = 0 := by exact_mod_cast h
    have hp_sq : p = a ^ 2 := by
      rw [← hab]
      simp [hb0]
    have hdvd : a ∣ p := ⟨a, by rw [hp_sq]; ring⟩
    rcases hpp.eq_one_or_self_of_dvd a hdvd with ha1 | hap
    · subst ha1
      have hp1 : p = 1 := by simpa using hp_sq
      exact hpp.ne_one hp1
    · subst hap
      nlinarith [hpp.two_le]
  · exact_mod_cast hab

/-- **T165:** there is a split factorization with distinct prime ideals. -/
lemma gaussian_split_prime_star_ne {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    ∃ π : GaussianInt, Prime π ∧ Prime (star π) ∧ π * star π = (p : GaussianInt) ∧
      Ideal.span ({π} : Set GaussianInt) ≠
        Ideal.span ({star π} : Set GaussianInt) := by
  obtain ⟨a, b, ha, hb, hab⟩ := gaussian_split_nonzero_data hp
  let π : GaussianInt := ⟨a, b⟩
  have hπnorm : π.norm.natAbs = p := by
    rw [show π.norm = (p : ℤ) by rw [gaussian_norm_mk]; exact hab]
    simp
  have hπ : Prime π := gaussian_prime_of_norm_natAbs hπnorm
  have hπ' : Prime (star π) := by
    apply gaussian_prime_of_norm_natAbs (p := p)
    rw [Zsqrtd.norm_conj, hπnorm]
  have hprod : π * star π = (p : GaussianInt) := by
    rw [show π = ⟨a, b⟩ from rfl]
    rw [show star (⟨a, b⟩ : GaussianInt) = ⟨a, -b⟩ from Zsqrtd.star_mk a b]
    ext <;> simp
    all_goals first | nlinarith [hab] | ring
  have hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt) := by
    apply gaussian_split_span_ne (p := p)
    · exact_mod_cast hp
    · exact ha
    · exact hb
    · exact hab
  exact ⟨π, hπ, hπ', hprod, hne⟩


/-- **T166:** an ideal of prime norm is maximal. -/
lemma gaussian_isMaximal_of_absNorm_prime {p : ℕ} [Fact p.Prime]
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p) : I.IsMaximal := by
  have hprime : I.IsPrime := by
    apply Ideal.isPrime_of_irreducible_absNorm
    rw [hI]
    exact (Fact.out : p.Prime)
  have hne : I ≠ ⊥ := by
    intro h
    rw [h] at hI
    simp at hI
    exact (Fact.out : p.Prime).ne_zero hI.symm
  exact hprime.isMaximal hne

/-- **T167:** an ideal of norm `p` is `(π)` or `(star π)`. -/
lemma gaussian_split_ideal_eq_of_absNorm {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    (π : GaussianInt) (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p) :
    I = Ideal.span ({π} : Set GaussianInt) ∨
      I = Ideal.span ({star π} : Set GaussianInt) := by
  have hmax := gaussian_isMaximal_of_absNorm_prime I hI
  haveI : I.IsPrime := hmax.isPrime
  have hpI : (p : GaussianInt) ∈ I := by
    have := Ideal.absNorm_mem I
    rwa [hI] at this
  have hmem : π * star π ∈ I := by
    rw [hprod]
    exact hpI
  rcases (inferInstance : I.IsPrime).mem_or_mem hmem with h | h
  · left
    have hle : Ideal.span ({π} : Set GaussianInt) ≤ I :=
      Ideal.span_le.mpr (by simpa using h)
    have hPmax : (Ideal.span ({π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ.ne_zero).mpr hπ).isMaximal (by
        intro hbot
        rw [Ideal.span_singleton_eq_bot] at hbot
        exact hπ.ne_zero hbot)
    exact (hPmax.eq_of_le hmax.ne_top hle).symm
  · right
    have hle : Ideal.span ({star π} : Set GaussianInt) ≤ I :=
      Ideal.span_le.mpr (by simpa using h)
    have hQmax : (Ideal.span ({star π} : Set GaussianInt)).IsMaximal :=
      ((Ideal.span_singleton_prime hπ'.ne_zero).mpr hπ').isMaximal (by
        intro hbot
        rw [Ideal.span_singleton_eq_bot] at hbot
        exact hπ'.ne_zero hbot)
    exact (hQmax.eq_of_le hmax.ne_top hle).symm

/-- **T168:** there are exactly two ideals of norm `p` for split `p`. -/
lemma gaussian_split_ideal_count_one {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p} = 2 := by
  obtain ⟨π, hπ, hπ', hprod, hne⟩ := gaussian_split_prime_star_ne hp
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hP : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQ : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  let S : Finset (Ideal GaussianInt) := {P, Q}
  have hmem : ∀ I : {I : Ideal GaussianInt // Ideal.absNorm I = p}, I.1 ∈ S := by
    intro I
    rcases gaussian_split_ideal_eq_of_absNorm hp π hπ hπ' hprod I.1 I.2 with h | h
    · rw [h]; simp [S, P]
    · rw [h]; simp [S, Q]
  have hiff : ∀ I : Ideal GaussianInt, I ∈ S ↔ Ideal.absNorm I = p := by
    intro I
    constructor
    · intro h
      simp [S] at h
      rcases h with rfl | rfl
      · exact hP
      · exact hQ
    · intro h
      exact hmem ⟨I, h⟩
  letI : Fintype {I : Ideal GaussianInt // Ideal.absNorm I = p} :=
    Fintype.subtype S hiff
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype S hiff]
  dsimp [S]
  exact Finset.card_pair_eq_two_iff.mpr hne


/-- **T169:** the norm of `(π)^a (star π)^b` is `p^(a+b)`. -/
lemma gaussian_split_pow_norm {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) (a b : ℕ) :
    Ideal.absNorm ((Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ b) = p ^ (a + b) := by
  rw [map_mul, map_pow, map_pow, (gaussian_split_span_norm hprod).1,
    (gaussian_split_span_norm hprod).2, ← pow_add]

/-- **T170:** the norm of `(π)^a (star π)^b` is `p^k` when `a+b=k`. -/
lemma gaussian_split_pow_norm_of_add {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt)) {a b k : ℕ} (h : a + b = k) :
    Ideal.absNorm ((Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ b) = p ^ k := by
  rw [gaussian_split_pow_norm hprod, h]


/-- **T171:** the two split prime ideals are coprime. -/
lemma gaussian_split_isCoprime {P Q : Ideal GaussianInt} [P.IsMaximal] [Q.IsMaximal]
    (hne : P ≠ Q) : IsCoprime P Q := by
  rw [Ideal.isCoprime_iff_sup_eq]
  by_contra h
  have h1 : P ⊔ Q = P := ((inferInstance : P.IsMaximal).eq_of_le h le_sup_left).symm
  have h2 : P ⊔ Q = Q := ((inferInstance : Q.IsMaximal).eq_of_le h le_sup_right).symm
  exact hne (h1.symm.trans h2)

/-- **T172:** powers of the two split prime ideals are coprime. -/
lemma gaussian_split_isCoprime_pow {P Q : Ideal GaussianInt} [P.IsMaximal] [Q.IsMaximal]
    (hne : P ≠ Q) (a b : ℕ) : IsCoprime (P ^ a) (Q ^ b) :=
  (gaussian_split_isCoprime hne).pow


/-- **T173:** distinct powers of the two split primes are unequal. -/
lemma gaussian_split_pow_ne {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    {k : ℕ} (hk : 0 < k) :
    (Ideal.span ({π} : Set GaussianInt)) ^ k ≠
      (Ideal.span ({star π} : Set GaussianInt)) ^ k := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hPnorm : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQnorm : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  have hPmax : P.IsMaximal := gaussian_isMaximal_of_absNorm_prime _ hPnorm
  have hQmax : Q.IsMaximal := gaussian_isMaximal_of_absNorm_prime _ hQnorm
  letI : P.IsMaximal := hPmax
  letI : Q.IsMaximal := hQmax
  intro h
  have hcop : IsCoprime (P ^ k) (Q ^ k) := gaussian_split_isCoprime_pow hne k k
  rw [h] at hcop
  have hunit : IsUnit (Q ^ k) := hcop.isUnit_of_dvd (dvd_refl _)
  have htop : Q ^ k = ⊤ := by
    rwa [Ideal.isUnit_iff] at hunit
  have hnorm : Ideal.absNorm (Q ^ k) = p ^ k := by
    rw [map_pow, hQnorm]
  have hone : p ^ k = 1 := by
    rw [← hnorm, htop, Ideal.absNorm_top]
  have hgt : 1 < p ^ k := Nat.one_lt_pow hk.ne' (Fact.out : p.Prime).one_lt
  omega


/-- **T174:** the `k+1` ideals `(π)^a (star π)^(k-a)` are distinct. -/
lemma gaussian_split_pow_inj {p : ℕ} [Fact p.Prime] {π : GaussianInt}
    (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    {a c k : ℕ} (ha : a ≤ k) (hc : c ≤ k)
    (h : (Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a) =
      (Ideal.span ({π} : Set GaussianInt)) ^ c *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - c)) : a = c := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  have hPnorm : Ideal.absNorm P = p := (gaussian_split_span_norm hprod).1
  have hQnorm : Ideal.absNorm Q = p := (gaussian_split_span_norm hprod).2
  have hP0 : P ≠ 0 := by
    intro h
    rw [h] at hPnorm
    simp at hPnorm
    exact (Fact.out : p.Prime).ne_zero hPnorm.symm
  have hQ0 : Q ≠ 0 := by
    intro h
    rw [h] at hQnorm
    simp at hQnorm
    exact (Fact.out : p.Prime).ne_zero hQnorm.symm
  change P ^ a * Q ^ (k - a) = P ^ c * Q ^ (k - c) at h
  by_contra hne_ac
  rcases lt_or_gt_of_ne hne_ac with hac | hca
  · have hPc : P ^ c = P ^ a * P ^ (c - a) := by
      rw [← pow_add]
      congr 1
      omega
    have hQka : Q ^ (k - a) = Q ^ (k - c) * Q ^ (c - a) := by
      rw [← pow_add]
      congr 1
      omega
    rw [hPc, hQka] at h
    rw [mul_assoc] at h
    have h2 : Q ^ (k - c) * Q ^ (c - a) = P ^ (c - a) * Q ^ (k - c) :=
      mul_left_cancel₀ (pow_ne_zero a hP0) h
    rw [mul_comm (P ^ (c - a)) (Q ^ (k - c))] at h2
    have h3 : Q ^ (c - a) = P ^ (c - a) :=
      mul_left_cancel₀ (pow_ne_zero (k - c) hQ0) h2
    exact (gaussian_split_pow_ne hprod hne (Nat.sub_pos_of_lt hac)) h3.symm
  · have hPa : P ^ a = P ^ c * P ^ (a - c) := by
      rw [← pow_add]
      congr 1
      omega
    have hQkc : Q ^ (k - c) = Q ^ (k - a) * Q ^ (a - c) := by
      rw [← pow_add]
      congr 1
      omega
    rw [hPa, hQkc] at h
    rw [mul_assoc] at h
    have h2 : P ^ (a - c) * Q ^ (k - a) = Q ^ (k - a) * Q ^ (a - c) :=
      mul_left_cancel₀ (pow_ne_zero c hP0) h
    rw [mul_comm (P ^ (a - c)) (Q ^ (k - a))] at h2
    have h3 : P ^ (a - c) = Q ^ (a - c) :=
      mul_left_cancel₀ (pow_ne_zero (k - a) hQ0) h2
    exact (gaussian_split_pow_ne hprod hne (Nat.sub_pos_of_lt hca)) h3


/-- **T175:** the split local count follows from exhaustiveness. -/
lemma gaussian_split_ideal_count_of_exhaustive {p k : ℕ} [Fact p.Prime]
    {π : GaussianInt} (hprod : π * star π = (p : GaussianInt))
    (hne : Ideal.span ({π} : Set GaussianInt) ≠
      Ideal.span ({star π} : Set GaussianInt))
    (hex : ∀ I : Ideal GaussianInt, Ideal.absNorm I = p ^ k →
      ∃ a : ℕ, a ≤ k ∧ I = (Ideal.span ({π} : Set GaussianInt)) ^ a *
        (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a)) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} = k + 1 := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  let f : ℕ → Ideal GaussianInt := fun a => P ^ a * Q ^ (k - a)
  let S : Finset (Ideal GaussianInt) := (Finset.range (k + 1)).image f
  have hinj : Set.InjOn f (Finset.range (k + 1) : Set ℕ) := by
    intro a ha c hc h
    have ha' : a ≤ k := by simpa using ha
    have hc' : c ≤ k := by simpa using hc
    exact gaussian_split_pow_inj hprod hne ha' hc' h
  have hScard : S.card = k + 1 := by
    rw [show S = (Finset.range (k + 1)).image f from rfl]
    rw [Finset.card_image_of_injOn hinj, Finset.card_range]
  have hmem_norm : ∀ I ∈ S, Ideal.absNorm I = p ^ k := by
    intro I hI
    simp [S, f] at hI
    obtain ⟨a, ha, rfl⟩ := hI
    rw [gaussian_split_pow_norm_of_add hprod (by omega : a + (k - a) = k)]
  have hmem : ∀ I : {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k}, I.1 ∈ S := by
    intro I
    obtain ⟨a, ha, hIa⟩ := hex I.1 I.2
    rw [hIa]
    simp [S, f]
    exact ⟨a, by omega, rfl⟩
  have hiff : ∀ I : Ideal GaussianInt, I ∈ S ↔ Ideal.absNorm I = p ^ k := by
    intro I
    constructor
    · exact hmem_norm I
    · intro h
      exact hmem ⟨I, h⟩
  letI : Fintype {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} :=
    Fintype.subtype S hiff
  rw [Nat.card_eq_fintype_card]
  rw [Fintype.card_of_subtype S hiff]
  exact hScard


/-- **T176:** every norm-`p^(k+1)` ideal peels off `(π)` or `(star π)`. -/
lemma gaussian_split_peel {p k : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    {π : GaussianInt} (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ (k + 1)) :
    ∃ M : Ideal GaussianInt, (M = Ideal.span ({π} : Set GaussianInt) ∨
        M = Ideal.span ({star π} : Set GaussianInt)) ∧
      ∃ J : Ideal GaussianInt, I = M * J ∧ Ideal.absNorm J = p ^ k := by
  letI : Module.Free ℤ GaussianInt := Module.Free.of_basis gaussianBasis
  letI : Module.Finite ℤ GaussianInt := Module.Finite.of_basis gaussianBasis
  have hpdvd : p ∣ Ideal.absNorm I := by
    rw [hI]
    exact dvd_pow_self p (by omega)
  obtain ⟨M, hMmax, hMunder, hMdvd⟩ :=
    Ideal.exists_isMaximal_dvd_of_dvd_absNorm' (Fact.out : p.Prime) I hpdvd
  have hM : M = Ideal.span ({π} : Set GaussianInt) ∨
      M = Ideal.span ({star π} : Set GaussianInt) :=
    gaussian_split_maximal_eq hp π hπ hπ' hprod M hMunder
  rw [dvd_iff_exists_eq_mul_left] at hMdvd
  obtain ⟨J, hIJ⟩ := hMdvd
  have hIJ' : I = M * J := by rw [hIJ, mul_comm]
  refine ⟨M, hM, J, hIJ', ?_⟩
  have hMnorm : Ideal.absNorm M = p := by
    rcases hM with rfl | rfl
    · exact (gaussian_split_span_norm hprod).1
    · exact (gaussian_split_span_norm hprod).2
  have hnorm : Ideal.absNorm I = Ideal.absNorm M * Ideal.absNorm J := by
    rw [hIJ', map_mul]
  rw [hI, hMnorm] at hnorm
  have hpow : p ^ (k + 1) = p ^ k * p := by rw [pow_succ]
  rw [hpow, mul_comm (p ^ k) p] at hnorm
  exact (Nat.mul_left_cancel (Fact.out : p.Prime).pos hnorm).symm

/-- **T177:** every ideal of norm `p^k` is among the `k+1` candidates. -/
lemma gaussian_split_exhaustive {p k : ℕ} [Fact p.Prime] (hp : p % 4 = 1)
    {π : GaussianInt} (hπ : Prime π) (hπ' : Prime (star π))
    (hprod : π * star π = (p : GaussianInt))
    (I : Ideal GaussianInt) (hI : Ideal.absNorm I = p ^ k) :
    ∃ a : ℕ, a ≤ k ∧ I = (Ideal.span ({π} : Set GaussianInt)) ^ a *
      (Ideal.span ({star π} : Set GaussianInt)) ^ (k - a) := by
  let P := Ideal.span ({π} : Set GaussianInt)
  let Q := Ideal.span ({star π} : Set GaussianInt)
  change Ideal.absNorm I = p ^ k at hI
  induction k generalizing I with
  | zero =>
      simp only [pow_zero] at hI
      rw [Ideal.absNorm_eq_one_iff] at hI
      refine ⟨0, le_rfl, ?_⟩
      rw [hI]
      simp [P, Q]
  | succ k ih =>
      obtain ⟨M, hM, J, hIJ, hJ⟩ := gaussian_split_peel hp hπ hπ' hprod I hI
      obtain ⟨a, ha, hJa⟩ := ih J hJ
      rcases hM with rfl | rfl
      · refine ⟨a + 1, by omega, ?_⟩
        rw [hIJ, hJa]
        change P * (P ^ a * Q ^ (k - a)) = P ^ (a + 1) * Q ^ (k + 1 - (a + 1))
        rw [← mul_assoc, ← pow_succ']
        rw [show k + 1 - (a + 1) = k - a by omega]
      · refine ⟨a, by omega, ?_⟩
        rw [hIJ, hJa]
        change Q * (P ^ a * Q ^ (k - a)) = P ^ a * Q ^ (k + 1 - a)
        rw [← mul_assoc, mul_comm Q (P ^ a), mul_assoc, ← pow_succ']
        rw [show k + 1 - a = k - a + 1 by omega]

/-- **T178:** the split local ideal count is `k+1`. -/
lemma gaussian_split_ideal_count (p k : ℕ) [Fact p.Prime] (hp : p % 4 = 1) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ k} = k + 1 := by
  obtain ⟨π, hπ, hπ', hprod, hne⟩ := gaussian_split_prime_star_ne hp
  exact gaussian_split_ideal_count_of_exhaustive hprod hne
    (gaussian_split_exhaustive hp hπ hπ' hprod)


/-- **T179:** the principal ideals `(m)` and `(n)` are coprime for coprime `m, n`. -/
lemma gaussian_isCoprime_span_nat {m n : ℕ} (h : Nat.Coprime m n) :
    IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) := by
  rw [Ideal.isCoprime_span_singleton_iff]
  exact (Nat.Coprime.isCoprime h).map (Int.castRingHom GaussianInt)


/-- **T180:** a divisor of `(a)(b)` decomposes as `(K⊔(a))(K⊔(b))` when `a, b` are coprime. -/
lemma gaussian_coprime_dvd_decompose {a b : GaussianInt} (hab : IsCoprime a b)
    {K : Ideal GaussianInt}
    (hK : K ∣ Ideal.span ({a} : Set GaussianInt) * Ideal.span ({b} : Set GaussianInt)) :
    K = (K ⊔ Ideal.span ({a} : Set GaussianInt)) *
      (K ⊔ Ideal.span ({b} : Set GaussianInt)) := by
  let I := Ideal.span ({a} : Set GaussianInt)
  let J := Ideal.span ({b} : Set GaussianInt)
  have hIJle : I * J ≤ K := Ideal.le_of_dvd hK
  have habK : a * b ∈ K := by
    apply hIJle
    rw [Ideal.span_singleton_mul_span_singleton]
    exact Ideal.subset_span (by simp)
  have hcop : IsCoprime I J := (Ideal.isCoprime_span_singleton_iff a b).mpr hab
  have hsup : (K ⊔ I) ⊔ (K ⊔ J) = ⊤ := by
    have h : (K ⊔ I) ⊔ (K ⊔ J) = (I ⊔ J) ⊔ K := by ac_rfl
    rw [h, Ideal.isCoprime_iff_sup_eq.mp hcop]
    simp
  have hinf : (K ⊔ I) ⊓ (K ⊔ J) = K := by
    apply le_antisymm ?_ (le_inf le_sup_left le_sup_left)
    intro z hz
    rw [Ideal.mem_inf] at hz
    obtain ⟨hzI, hzJ⟩ := hz
    rw [Submodule.mem_sup] at hzI hzJ
    obtain ⟨k1, hk1, i, hi, hik⟩ := hzI
    obtain ⟨k2, hk2, j, hj, hjk⟩ := hzJ
    obtain ⟨x, rfl⟩ := Ideal.mem_span_singleton.mp hi
    obtain ⟨y, rfl⟩ := Ideal.mem_span_singleton.mp hj
    obtain ⟨u, v, huv⟩ := hab
    have hz1 : z = k1 + a * x := hik.symm
    have hz2 : z = k2 + b * y := hjk.symm
    have hza : z * a ∈ K := by
      rw [hz2]
      have heq : (k2 + b * y) * a = k2 * a + (a * b) * y := by ring
      rw [heq]
      exact K.add_mem (K.mul_mem_right a hk2) (K.mul_mem_right y habK)
    have hzb : z * b ∈ K := by
      rw [hz1]
      have heq : (k1 + a * x) * b = k1 * b + (a * b) * x := by ring
      rw [heq]
      exact K.add_mem (K.mul_mem_right b hk1) (K.mul_mem_right x habK)
    have hz : z = u * (z * a) + v * (z * b) := by
      calc z = z * 1 := by ring
        _ = z * (u * a + v * b) := by rw [huv]
        _ = u * (z * a) + v * (z * b) := by ring
    rw [hz]
    exact K.add_mem (K.mul_mem_left u hza) (K.mul_mem_left v hzb)
  have hprod : (K ⊔ I) * (K ⊔ J) = (K ⊔ I) ⊓ (K ⊔ J) := by
    have := Ideal.sup_mul_inf (K ⊔ I) (K ⊔ J)
    rw [hsup, Ideal.top_mul] at this
    exact this.symm
  conv_lhs => rw [← hinf]
  rw [hprod]


/-- **T181:** `chi4Int` is multiplicative. -/
lemma chi4Int_mul (a b : ℤ) : chi4Int (a * b) = chi4Int a * chi4Int b := by
  unfold chi4Int
  simp only [Int.cast_mul]
  have h : ∀ x y : ZMod 4, ZMod.χ₄ (x * y) = ZMod.χ₄ x * ZMod.χ₄ y := by decide
  rw [h (a : ZMod 4) (b : ZMod 4)]
  push_cast
  ring


/-- **T182:** a divisor of a product of coprime ideals splits as `(K⊔I)(K⊔J)`. -/
lemma ideal_coprime_dvd_decompose {I J K : Ideal GaussianInt} (hIJ : IsCoprime I J)
    (hK : K ∣ I * J) : K = (K ⊔ I) * (K ⊔ J) := by
  have hIJle : I * J ≤ K := Ideal.le_of_dvd hK
  obtain ⟨i, hi, j, hj, hij⟩ := hIJ.exists
  have hsup : (K ⊔ I) ⊔ (K ⊔ J) = ⊤ := by
    have h : (K ⊔ I) ⊔ (K ⊔ J) = (I ⊔ J) ⊔ K := by ac_rfl
    rw [h, Ideal.isCoprime_iff_sup_eq.mp hIJ]
    simp
  have hinf : (K ⊔ I) ⊓ (K ⊔ J) = K := by
    apply le_antisymm ?_ (le_inf le_sup_left le_sup_left)
    intro z hz
    rw [Ideal.mem_inf] at hz
    obtain ⟨hzI, hzJ⟩ := hz
    rw [Submodule.mem_sup] at hzI hzJ
    obtain ⟨k1, hk1, i1, hi1, hik⟩ := hzI
    obtain ⟨k2, hk2, j2, hj2, hjk⟩ := hzJ
    have hz1 : z = k1 + i1 := hik.symm
    have hz2 : z = k2 + j2 := hjk.symm
    have hzi : z * i ∈ K := by
      rw [hz2, add_mul]
      have hmul : j2 * i ∈ I * J := by
        rw [mul_comm j2 i]
        exact Ideal.mul_mem_mul hi hj2
      exact K.add_mem (K.mul_mem_right i hk2) (hIJle hmul)
    have hzj : z * j ∈ K := by
      rw [hz1, add_mul]
      exact K.add_mem (K.mul_mem_right j hk1) (hIJle (Ideal.mul_mem_mul hi1 hj))
    have hz : z = z * i + z * j := by
      rw [← mul_add, hij, mul_one]
    rw [hz]
    exact K.add_mem hzi hzj
  have hprod : (K ⊔ I) * (K ⊔ J) = (K ⊔ I) ⊓ (K ⊔ J) := by
    have := Ideal.sup_mul_inf (K ⊔ I) (K ⊔ J)
    rw [hsup, Ideal.top_mul] at this
    exact this.symm
  conv_lhs => rw [← hinf]
  rw [hprod]


/-- **T183:** for `p ≡ 1 mod 4`, `Σ_{j=0}^{k} χ₄(p^j) = k+1`. -/
lemma divisorSumChi4_prime_pow_one {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) (k : ℕ) :
    divisorSumChi4 (p ^ k) = (k + 1 : ℤ) := by
  change (∑ d ∈ (p ^ k).divisors, ZMod.χ₄ (d : ZMod 4)) = (k + 1 : ℤ)
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1), ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = 1 := by
    intro j hj
    apply ZMod.χ₄_nat_one_mod_four
    rw [Nat.pow_mod, hp]
    simp
  rw [Finset.sum_congr rfl h]
  simp


/-- **T184:** the raw `χ₄` is multiplicative on `ℤ`. -/
lemma chi4_mul (a b : ℤ) : ZMod.χ₄ (a * b) = ZMod.χ₄ a * ZMod.χ₄ b := by
  apply Int.cast_injective (α := ℂ)
  simpa [chi4Int] using chi4Int_mul a b

/-- **T185:** `χ₄(p^j) = (-1)^j` for `p ≡ 3 mod 4`. -/
lemma chi4_pow_three {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) (j : ℕ) :
    ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = (-1 : ℤ) ^ j := by
  induction j with
  | zero => simp
  | succ j ih =>
      have hcast : ((p ^ (j + 1) : ℕ) : ZMod 4) = ((p ^ j : ℕ) : ZMod 4) * (p : ZMod 4) := by
        rw [pow_succ, Nat.cast_mul]
      rw [hcast]
      have hmul : ZMod.χ₄ (((p ^ j : ℕ) : ZMod 4) * (p : ZMod 4)) =
          ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) * ZMod.χ₄ (p : ZMod 4) := by
        simpa using chi4_mul ((p ^ j : ℕ) : ℤ) (p : ℤ)
      rw [hmul, ih]
      have hpval : ZMod.χ₄ (p : ZMod 4) = (-1 : ℤ) := by
        have hp2 : p % 2 = 1 := by omega
        rw [ZMod.χ₄_nat_eq_if_mod_four]
        simp [hp, hp2]
      rw [hpval]
      ring

/-- **T186:** for `p ≡ 3 mod 4`, the divisor sum is `1` for even `k` and `0` for odd `k`. -/
lemma divisorSumChi4_prime_pow_three {p : ℕ} [Fact p.Prime] (hp : p % 4 = 3) (k : ℕ) :
    divisorSumChi4 (p ^ k) = if Even k then 1 else 0 := by
  change (∑ d ∈ (p ^ k).divisors, ZMod.χ₄ (d : ZMod 4)) = if Even k then 1 else 0
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1),
      ZMod.χ₄ ((p ^ j : ℕ) : ZMod 4) = (-1 : ℤ) ^ j := by
    intro j hj
    exact chi4_pow_three hp j
  rw [Finset.sum_congr rfl h]
  rw [← Fin.sum_univ_eq_sum_range (fun j => (-1 : ℤ) ^ j) (k + 1)]
  rw [Fin.sum_neg_one_pow]
  by_cases hk : Even k <;> simp [Nat.even_add_one, hk]


/-- **T187:** the ramified divisor sum `Σ_{j=0}^{k} χ₄(2^j)` is `1`. -/
lemma divisorSumChi4_prime_pow_two (k : ℕ) :
    divisorSumChi4 (2 ^ k) = 1 := by
  change (∑ d ∈ (2 ^ k).divisors, ZMod.χ₄ ((d : ℕ) : ZMod 4)) = (1 : ℤ)
  rw [Nat.sum_divisors_prime_pow Nat.prime_two]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro j hj hj0
    have hj1 : 1 ≤ j := by omega
    rw [ZMod.χ₄_nat_eq_if_mod_four]
    have hmod : (2 ^ j) % 2 = 0 := by
      rw [Nat.pow_mod]
      simp [hj0]
    simp [hmod]
  · intro h
    simp at h


/-- **T188:** `divisorSumChi4` is multiplicative over coprime `m, n`. -/
lemma divisorSumChi4_mul {m n : ℕ} (hmn : Nat.Coprime m n) :
    divisorSumChi4 (m * n) = divisorSumChi4 m * divisorSumChi4 n := by
  unfold divisorSumChi4
  rw [hmn.divisors_mul]
  rw [Finset.sum_map]
  let f : ℕ × ℕ → ℤ := fun q => ZMod.χ₄ (((q.1 * q.2 : ℕ)) : ZMod 4)
  change (∑ p ∈ (m.divisors ×ˢ n.divisors).attach, f ↑p) = _
  rw [Finset.sum_attach]
  rw [Finset.sum_product]
  have h : ∀ x ∈ m.divisors, ∀ y ∈ n.divisors,
      ZMod.χ₄ ((x * y : ℕ) : ZMod 4) =
        ZMod.χ₄ (x : ZMod 4) * ZMod.χ₄ (y : ZMod 4) := by
    intro x hx y hy
    simpa using chi4_mul (x : ℤ) (y : ℤ)
  calc (∑ x ∈ m.divisors, ∑ y ∈ n.divisors, ZMod.χ₄ ((x * y : ℕ) : ZMod 4))
      = ∑ x ∈ m.divisors, (ZMod.χ₄ (x : ZMod 4) *
          ∑ y ∈ n.divisors, ZMod.χ₄ (y : ZMod 4)) := by
        apply Finset.sum_congr rfl
        intro x hx
        rw [Finset.sum_congr rfl (fun y hy => h x hx y hy), Finset.mul_sum]
    _ = (∑ x ∈ m.divisors, ZMod.χ₄ (x : ZMod 4)) *
          (∑ y ∈ n.divisors, ZMod.χ₄ (y : ZMod 4)) := by
        rw [Finset.sum_mul]

/-- **T189:** if `a ∣ m²`, `b ∣ n²`, `ab = mn` and `m, n` are coprime, then `a = m`, `b = n`. -/
lemma nat_eq_of_dvd_sq_mul {a b m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (ha : a ∣ m ^ 2) (hb : b ∣ n ^ 2)
    (hab : a * b = m * n) : a = m ∧ b = n := by
  have hmb : Nat.Coprime m b := (hcop.pow_right 2).of_dvd_right hb
  have hma : m ∣ a := by
    have : m ∣ a * b := by rw [hab]; exact dvd_mul_right m n
    exact hmb.dvd_of_dvd_mul_right this
  have hna : Nat.Coprime n a := by
    have hnm : Nat.Coprime n (m ^ 2) := hcop.symm.pow_right 2
    exact hnm.of_dvd_right ha
  have hnb : n ∣ b := by
    have : n ∣ a * b := by rw [hab]; exact dvd_mul_left n m
    exact hna.dvd_of_dvd_mul_left this
  obtain ⟨c, rfl⟩ := hma
  obtain ⟨d, rfl⟩ := hnb
  have hmul : m * n * (c * d) = m * n * 1 := by
    calc m * n * (c * d) = m * c * (n * d) := by ring
      _ = m * n := hab
      _ = m * n * 1 := by ring
  have hmn : 0 < m * n := Nat.mul_pos (Nat.pos_of_ne_zero hm) (Nat.pos_of_ne_zero hn)
  have hcd : c * d = 1 := Nat.mul_left_cancel hmn hmul
  have hc : c = 1 := Nat.eq_one_of_mul_eq_one_right hcd
  have hd : d = 1 := Nat.eq_one_of_mul_eq_one_left hcd
  constructor <;> simp [hc, hd]

/-- **T190:** for ideals of coprime norms `m, n`, `(K1 K2) ⊔ (m) = K1`. -/
lemma gaussian_sup_mul_span_eq {K1 K2 : Ideal GaussianInt} {m n : ℕ}
    (hK1 : Ideal.absNorm K1 = m) (hK2 : Ideal.absNorm K2 = n)
    (hcop : Nat.Coprime m n) :
    (K1 * K2) ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) = K1 := by
  have hspan_m : K1 ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) := by
    rw [← hK1]
    exact gaussian_ideal_dvd_span_absNorm K1
  have hspan_n : K2 ∣ Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rw [← hK2]
    exact gaussian_ideal_dvd_span_absNorm K2
  have hcop_span : IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) :=
    gaussian_isCoprime_span_nat hcop
  have hcop_K1K2 : IsCoprime K1 K2 :=
    (hcop_span.of_isCoprime_of_dvd_left hspan_m).of_isCoprime_of_dvd_right hspan_n
  rw [dvd_iff_exists_eq_mul_left] at hspan_m
  obtain ⟨J, hJ⟩ := hspan_m
  have hJ' : Ideal.span ({(m : GaussianInt)} : Set GaussianInt) = K1 * J := by
    rw [hJ, mul_comm]
  have hJdvd : J ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) :=
    ⟨K1, by rw [hJ', mul_comm]⟩
  have hcop_K2_m : IsCoprime K2 (Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) :=
    (hcop_span.of_isCoprime_of_dvd_right hspan_n).symm
  have hcop_K2_J : IsCoprime K2 J := hcop_K2_m.of_isCoprime_of_dvd_right hJdvd
  have hsup : K2 ⊔ J = ⊤ := Ideal.isCoprime_iff_sup_eq.mp hcop_K2_J
  calc (K1 * K2) ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)
      = (K1 * K2) ⊔ (K1 * J) := by rw [hJ']
    _ = K1 * (K2 ⊔ J) := by rw [Ideal.mul_sup]
    _ = K1 * ⊤ := by rw [hsup]
    _ = K1 := by rw [Ideal.mul_top]


/-- **T191:** the left component of an ideal of norm `mn` has norm `m`. -/
lemma gaussian_sup_span_absNorm_left {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (K : Ideal GaussianInt)
    (hK : Ideal.absNorm K = m * n) :
    Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) = m := by
  have hKdvd : K ∣ Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) := by
    rw [← hK]
    exact gaussian_ideal_dvd_span_absNorm K
  have hspan : Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) =
      Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
        Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rw [Ideal.span_singleton_mul_span_singleton, Nat.cast_mul]
  have hKdvd' : K ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
      Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
    rwa [← hspan]
  have hcop_span : IsCoprime (Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) :=
    gaussian_isCoprime_span_nat hcop
  have hdecomp := ideal_coprime_dvd_decompose hcop_span hKdvd'
  have h1dvd : (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) ∣
      Ideal.span ({(m : GaussianInt)} : Set GaussianInt) :=
    Ideal.dvd_iff_le.mpr le_sup_right
  have h2dvd : (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) ∣
      Ideal.span ({(n : GaussianInt)} : Set GaussianInt) :=
    Ideal.dvd_iff_le.mpr le_sup_right
  have h1 : Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) ∣ m ^ 2 := by
    have := Ideal.absNorm_dvd_absNorm_of_le (I := K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt))
      (J := Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) le_sup_right
    rwa [gaussian_absNorm_span_natCast] at this
  have h2 : Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) ∣ n ^ 2 := by
    have := Ideal.absNorm_dvd_absNorm_of_le (I := K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt))
      (J := Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) le_sup_right
    rwa [gaussian_absNorm_span_natCast] at this
  have hprod : Ideal.absNorm (K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) *
      Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = m * n := by
    have hK' : Ideal.absNorm ((K ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt)) *
        (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt))) = m * n := by
      conv_lhs => rw [← hdecomp]
      rw [hK]
    rwa [map_mul] at hK'
  exact (nat_eq_of_dvd_sq_mul hm hn hcop h1 h2 hprod).1

/-- **T192:** the right component of an ideal of norm `mn` has norm `n`. -/
lemma gaussian_sup_span_absNorm_right {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) (K : Ideal GaussianInt)
    (hK : Ideal.absNorm K = m * n) :
    Ideal.absNorm (K ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt)) = n := by
  have h := gaussian_sup_span_absNorm_left hn hm hcop.symm K (by rwa [mul_comm] at hK)
  simpa [mul_comm] using h

/-- **T193:** the ideal-count product equivalence. -/
noncomputable def gaussianIdealCountEquiv (m n : ℕ) (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) :
    {I : Ideal GaussianInt // Ideal.absNorm I = m * n} ≃
      {I : Ideal GaussianInt // Ideal.absNorm I = m} ×
        {I : Ideal GaussianInt // Ideal.absNorm I = n} where
  toFun I :=
    (⟨I.1 ⊔ Ideal.span ({(m : GaussianInt)} : Set GaussianInt),
        gaussian_sup_span_absNorm_left hm hn hcop I.1 I.2⟩,
      ⟨I.1 ⊔ Ideal.span ({(n : GaussianInt)} : Set GaussianInt),
        gaussian_sup_span_absNorm_right hm hn hcop I.1 I.2⟩)
  invFun p :=
    ⟨p.1.1 * p.2.1, by rw [map_mul, p.1.2, p.2.2]⟩
  left_inv I := by
    apply Subtype.ext
    have hKdvd : I.1 ∣ Ideal.span ({((Ideal.absNorm I.1 : ℕ) : GaussianInt)} : Set GaussianInt) :=
      gaussian_ideal_dvd_span_absNorm I.1
    rw [I.2] at hKdvd
    have hspan : Ideal.span ({((m * n : ℕ) : GaussianInt)} : Set GaussianInt) =
        Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
          Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
      rw [Ideal.span_singleton_mul_span_singleton, Nat.cast_mul]
    have hKdvd' : I.1 ∣ Ideal.span ({(m : GaussianInt)} : Set GaussianInt) *
        Ideal.span ({(n : GaussianInt)} : Set GaussianInt) := by
      rwa [← hspan]
    exact (ideal_coprime_dvd_decompose (gaussian_isCoprime_span_nat hcop) hKdvd').symm
  right_inv p := by
    apply Prod.ext
    · apply Subtype.ext
      exact gaussian_sup_mul_span_eq p.1.2 p.2.2 hcop
    · apply Subtype.ext
      have h := gaussian_sup_mul_span_eq (m := n) (n := m) p.2.2 p.1.2 hcop.symm
      simpa [mul_comm] using h

/-- **T194:** the ideal count is multiplicative over coprime `m, n`. -/
theorem gaussian_idealCount_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (hcop : Nat.Coprime m n) :
    Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m * n} =
      Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m} *
        Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} := by
  rw [Nat.card_congr (gaussianIdealCountEquiv m n hm hn hcop), Nat.card_prod]


/-- **T195:** the ideal count as an arithmetic function. -/
def idealCount (n : ℕ) : ℕ := Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n}

/-- `idealCount 1 = 1`. -/
lemma idealCount_one : idealCount 1 = 1 := by
  unfold idealCount
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [Ideal.absNorm_eq_one_iff.mp I.2, Ideal.absNorm_eq_one_iff.mp J.2]
  · exact ⟨⟨⊤, by rw [Ideal.absNorm_top]⟩⟩

/-- The ideal count packaged as an `ArithmeticFunction ℤ`. -/
def idealCountFun : ArithmeticFunction ℤ where
  toFun n := if n = 0 then 0 else (idealCount n : ℤ)
  map_zero' := by simp

/-- **T195:** the packaged ideal count is multiplicative. -/
lemma idealCountFun_isMultiplicative : idealCountFun.IsMultiplicative := by
  constructor
  · simp [idealCountFun, idealCount_one]
  · intro m n hcop
    by_cases hm : m = 0
    · subst hm
      simp [idealCountFun]
    · by_cases hn : n = 0
      · subst hn
        simp [idealCountFun]
      · have hmn : m * n ≠ 0 := Nat.mul_ne_zero hm hn
        simp only [idealCountFun, ArithmeticFunction.coe_mk, idealCount, hm, hn, hmn, if_false]
        change (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m * n} : ℤ) =
          (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = m} : ℤ) *
            (Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = n} : ℤ)
        rw [gaussian_idealCount_mul hm hn hcop]
        push_cast
        ring

/-- The divisor sum packaged as an `ArithmeticFunction ℤ`. -/
def divisorSumFun : ArithmeticFunction ℤ where
  toFun := divisorSumChi4
  map_zero' := by
    simp [divisorSumChi4]

/-- **T196:** the packaged divisor sum is multiplicative. -/
lemma divisorSumFun_isMultiplicative : divisorSumFun.IsMultiplicative := by
  constructor
  · simp [divisorSumFun, divisorSumChi4]
  · intro m n hcop
    simpa [divisorSumFun] using divisorSumChi4_mul hcop


/-- **T197:** the ideal count and divisor sum agree on prime powers. -/
lemma idealCount_prime_pow_eq (p i : ℕ) (hp : p.Prime) :
    idealCountFun (p ^ i) = divisorSumFun (p ^ i) := by
  have hpi : p ^ i ≠ 0 := pow_ne_zero i hp.ne_zero
  simp only [idealCountFun, divisorSumFun, ArithmeticFunction.coe_mk, hpi, if_false,
    idealCount]
  rcases hp.eq_two_or_odd with rfl | hodd
  · rw [gaussian_ramified_ideal_count i, divisorSumChi4_prime_pow_two i]
    norm_num
  · letI : Fact p.Prime := ⟨hp⟩
    have h4 : p % 4 = 1 ∨ p % 4 = 3 := by omega
    rcases h4 with h1 | h3
    · have hI : Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ i} = i + 1 :=
        gaussian_split_ideal_count p i h1
      have hD : divisorSumChi4 (p ^ i) = (i + 1 : ℤ) :=
        divisorSumChi4_prime_pow_one h1 i
      rw [hI, hD]
      norm_num
    · have hI : Nat.card {I : Ideal GaussianInt // Ideal.absNorm I = p ^ i} =
          if Even i then 1 else 0 := by
        by_cases hi : Even i
        · obtain ⟨k, hk⟩ := hi
          rw [hk, show k + k = 2 * k by ring, gaussian_inert_ideal_count_even p k h3]
          simp
        · rw [Nat.not_even_iff_odd] at hi
          obtain ⟨k, hk⟩ := hi
          rw [hk, gaussian_inert_ideal_count_odd p k h3]
          simp
      have hD : divisorSumChi4 (p ^ i) = if Even i then 1 else 0 :=
        divisorSumChi4_prime_pow_three h3 i
      rw [hI, hD]
      split_ifs <;> norm_num

/-- **T198:** the ideal-count formula. -/
theorem idealCountFormula : IdealCountFormula := by
  have hfun : idealCountFun = divisorSumFun :=
    (ArithmeticFunction.IsMultiplicative.eq_iff_eq_on_prime_powers idealCountFun
      idealCountFun_isMultiplicative divisorSumFun
      divisorSumFun_isMultiplicative).mpr
      (fun p i hp => idealCount_prime_pow_eq p i hp)
  intro n hn
  have hn0 : n ≠ 0 := by omega
  have h := congrArg (fun f : ArithmeticFunction ℤ => f n) hfun
  simpa [idealCountFun, idealCount, divisorSumFun, ArithmeticFunction.coe_mk, hn0,
    if_false] using h

end GaussianInt
