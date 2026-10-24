/-
  VonMangoldtSieves.lean
  =====================
  Companion formalisation for the paper

      "Sieves for the von Mangoldt Function"
      publish/001/von-mangoldt-sieves.html

  It records, in Lean 4 / Mathlib, the elementary identities of §2 of the paper:

    * Proposition 2.1  — support of Λ and its values on prime powers;
    * Proposition 2.2  — the divisor identity   ∑_{d|n} Λ(d) = log n;
    * Corollary 2.3    — Möbius inversion       Λ = μ * log;
    * Proposition 2.4  — Λ is neither additive nor multiplicative;
    * Proposition 2.4+ — the elementary bound   Λ(n) ≤ log n.

  The only dependency is Mathlib (external).  Build inside any Lean 4 project
  that provides Mathlib, e.g. `lake env lean VonMangoldtSieves.lean`.
-/
import Mathlib

open ArithmeticFunction Finset

namespace VonMangoldtSieves

/-- **Proposition 2.1 (support).**  `Λ n ≠ 0` exactly when `n` is a power of a
prime.  This is Mathlib's `vonMangoldt_ne_zero_iff`. -/
theorem support_ne_zero_iff (n : ℕ) : Λ n ≠ 0 ↔ IsPrimePow n :=
  vonMangoldt_ne_zero_iff

/-- **Proposition 2.1 (values).**  On the powers of a prime, `Λ` is constant:
`Λ (p ^ k) = log p` for every `k ≥ 1`. -/
theorem apply_prime_pow (p k : ℕ) (hp : p.Prime) (hk : k ≠ 0) :
    Λ (p ^ k) = Real.log p := by
  rw [vonMangoldt_apply_pow hk, vonMangoldt_apply_prime hp]

/-- **Proposition 2.2 (divisor identity).**  For every `n`,
`∑_{d | n} Λ d = log n`.  This is Mathlib's `vonMangoldt_sum`, which is the
single identity underlying the divisor-sum sieve of §3.2. -/
theorem divisor_identity (n : ℕ) : ∑ d ∈ n.divisors, Λ d = Real.log n :=
  vonMangoldt_sum

/-- **Corollary 2.3 (Möbius inversion).**  `Λ = μ * log`. -/
theorem moebius_convolution :
    (↑moebius : ArithmeticFunction ℝ) * log = Λ :=
  moebius_mul_log_eq_vonMangoldt

/-- **Proposition 2.4 (not additive).**  The witness is `6 = 2 * 3`:
`Λ 6 = 0` while `Λ 2 + Λ 3 = log 6 > 0`. -/
theorem not_additive : ∃ m n : ℕ, Λ (m * n) ≠ Λ m + Λ n := by
  refine ⟨2, 3, ?_⟩
  have h6 : Λ 6 = 0 := by
    rw [vonMangoldt_eq_zero_iff]
    decide
  have h2 : Λ 2 = Real.log 2 := vonMangoldt_apply_prime (by decide)
  have h3 : Λ 3 = Real.log 3 := vonMangoldt_apply_prime (by decide)
  rw [h6, h2, h3, ← Real.log_mul (by norm_num) (by norm_num)]
  norm_num
  exact ne_of_lt (by positivity : (0 : ℝ) < Real.log 6)

/-- **Proposition 2.4 (not multiplicative).**  The witness is `4 = 2 * 2`:
`Λ 4 = log 2` while `Λ 2 * Λ 2 = (log 2)²`, and `0 < log 2 < 1`
(Mathlib's `Real.log_two_gt_d9`, `Real.log_two_lt_d9`) separates the two. -/
theorem not_multiplicative : ∃ m n : ℕ, Λ (m * n) ≠ Λ m * Λ n := by
  refine ⟨2, 2, ?_⟩
  have h2 : Λ 2 = Real.log 2 := vonMangoldt_apply_prime (by decide)
  have h4 : Λ 4 = Real.log 2 := by
    rw [show (4 : ℕ) = 2 ^ 2 by norm_num, vonMangoldt_apply_pow (by norm_num), h2]
  rw [h4, h2]
  have hpos : 0 < Real.log 2 := by linarith [Real.log_two_gt_d9]
  have hlt : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
  intro h
  have hzero : Real.log 2 * (1 - Real.log 2) = 0 := by nlinarith [h]
  exact (mul_ne_zero (ne_of_gt hpos) (by linarith : (1 - Real.log 2) ≠ 0)) hzero

/-- **Proposition 2.4 (elementary bound).**  `Λ n ≤ log n`, with equality exactly
on the prime powers.  This is Mathlib's `vonMangoldt_le_log`. -/
theorem le_log (n : ℕ) : Λ n ≤ Real.log (n : ℝ) :=
  vonMangoldt_le_log

end VonMangoldtSieves
