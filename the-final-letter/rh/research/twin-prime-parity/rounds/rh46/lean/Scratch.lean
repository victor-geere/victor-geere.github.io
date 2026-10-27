import Mathlib

namespace Rh46

noncomputable section

open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n

def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

def corr (h N : ℕ) : ℤ := ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)

theorem Omega_zero : Omega 0 = 0 := by
  show ArithmeticFunction.cardFactors 0 = 0
  exact ArithmeticFunction.cardFactors_zero

theorem liouville_zero : liouville 0 = 1 := by
  show (-1 : ℤ) ^ ArithmeticFunction.cardFactors 0 = 1
  rw [ArithmeticFunction.cardFactors_zero]
  norm_num

theorem liouville_sq (n : ℕ) : liouville n ^ 2 = 1 := by
  rw [liouville, pow_two, ← pow_add,
    show Omega n + Omega n = 2 * Omega n by ring]
  exact (even_two_mul (Omega n)).neg_one_pow

theorem liouville_mul (m n : ℕ) : liouville (m * n) = liouville m * liouville n := by
  by_cases hm : m = 0
  · subst hm
    rw [Nat.zero_mul, liouville_zero]
    simp only [one_mul]
  by_cases hn : n = 0
  · subst hn
    rw [Nat.mul_zero, liouville_zero]
    simp only [mul_one]
  have h : Omega (m * n) = Omega m + Omega n := by
    show ArithmeticFunction.cardFactors (m * n) =
      ArithmeticFunction.cardFactors m + ArithmeticFunction.cardFactors n
    exact ArithmeticFunction.cardFactors_mul hm hn
  rw [liouville, liouville, liouville, h, pow_add]

theorem liouville_ne_zero {n : ℕ} (hn : n ≠ 0) : liouville n ≠ 0 := by
  rcases Nat.even_or_odd (Omega n) with h | h
  · rw [liouville, h.neg_one_pow]; norm_num
  · rw [liouville, h.neg_one_pow]; norm_num

theorem liouville_abs_le_one (n : ℕ) : |liouville n| ≤ 1 := by
  rcases Nat.even_or_odd (Omega n) with h | h
  · rw [liouville, h.neg_one_pow]; norm_num
  · rw [liouville, h.neg_one_pow]; norm_num

example (N : ℕ) : corr 0 N = N := by
  have hterm : ∀ n ∈ Finset.Icc 1 N, liouville n * liouville (n + 0) = 1 := by
    intro n _
    rw [Nat.add_zero, ← pow_two]
    exact liouville_sq n
  rw [corr, Finset.sum_congr rfl hterm, Finset.sum_const, nsmul_eq_mul, mul_one,
    Nat.card_Icc]
  omega

example : Omega 4 = 2 := by
  show ArithmeticFunction.cardFactors 4 = 2
  have h : ArithmeticFunction.cardFactors (2 ^ 2) = 2 :=
    ArithmeticFunction.cardFactors_apply_prime_pow Nat.prime_two (k := 2)
  norm_num at h
  exact h

example : liouville 2 = -1 := by
  rw [liouville,
    show Omega 2 = 1 from by
      show ArithmeticFunction.cardFactors 2 = 1
      exact ArithmeticFunction.cardFactors_apply_prime Nat.prime_two]
  norm_num

example : liouville 4 = 1 := by
  rw [liouville,
    show Omega 4 = 2 from by
      show ArithmeticFunction.cardFactors 4 = 2
      have h : ArithmeticFunction.cardFactors (2 ^ 2) = 2 :=
        ArithmeticFunction.cardFactors_apply_prime_pow Nat.prime_two (k := 2)
      norm_num at h
      exact h]
  norm_num

end

end Rh46
