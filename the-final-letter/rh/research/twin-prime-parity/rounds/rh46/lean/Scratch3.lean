import Mathlib

namespace Rh46

noncomputable section

open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n

def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

theorem Omega_two : Omega 2 = 1 := by
  show ArithmeticFunction.cardFactors 2 = 1
  exact ArithmeticFunction.cardFactors_apply_prime Nat.prime_two

theorem Omega_three : Omega 3 = 1 := by
  show ArithmeticFunction.cardFactors 3 = 1
  exact ArithmeticFunction.cardFactors_apply_prime (by norm_num : Nat.Prime 3)

theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    Omega (m * n) = Omega m + Omega n := by
  show ArithmeticFunction.cardFactors (m * n) =
    ArithmeticFunction.cardFactors m + ArithmeticFunction.cardFactors n
  exact ArithmeticFunction.cardFactors_mul hm hn

theorem Omega_six : Omega 6 = 2 := by
  have h := Omega_mul (m := 2) (n := 3) (by norm_num) (by norm_num)
  rw [show (6 : ℕ) = 2 * 3 by norm_num, h, Omega_two, Omega_three]

theorem liouville_zero : liouville 0 = 1 := by
  show (-1 : ℤ) ^ ArithmeticFunction.cardFactors 0 = 1
  rw [ArithmeticFunction.cardFactors_zero]; norm_num

theorem liouville_two : liouville 2 = -1 := by
  rw [liouville, Omega_two]; norm_num

theorem liouville_four : liouville 4 = 1 := by
  rw [liouville, show Omega 4 = 2 from by
    have h := ArithmeticFunction.cardFactors_apply_prime_pow Nat.prime_two (k := 2)
    norm_num at h
    exact h]
  norm_num

theorem liouville_six : liouville 6 = -1 := by
  rw [liouville, Omega_six]; norm_num

theorem liouville_mul (m n : ℕ) : liouville (m * n) = liouville m * liouville n := by
  by_cases hm : m = 0
  · subst hm
    have hL : liouville (0 * n) = 1 := by
      rw [show (0 : ℕ) * n = 0 from Nat.zero_mul n]
      exact liouville_zero
    have hR : liouville 0 * liouville n = 1 := by
      rw [liouville_zero, one_mul]
    exact hL.trans hR.symm
  by_cases hn : n = 0
  · subst hn
    have hL : liouville (m * 0) = 1 := by
      rw [show m * (0 : ℕ) = 0 from Nat.mul_zero m]
      exact liouville_zero
    have hR : liouville m * liouville 0 = 1 := by
      rw [liouville_zero, mul_one]
    exact hL.trans hR.symm
  rw [liouville, liouville, liouville, Omega_mul hm hn, pow_add]

end

end Rh46
