import Mathlib

namespace Rh46

noncomputable section

open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n

def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

theorem liouville_zero : liouville 0 = 1 := by
  show (-1 : ℤ) ^ ArithmeticFunction.cardFactors 0 = 1
  rw [ArithmeticFunction.cardFactors_zero]; norm_num

theorem liouville_two : liouville 2 = -1 := by
  rw [liouville, show Omega 2 = 1 from by
    show ArithmeticFunction.cardFactors 2 = 1
    exact ArithmeticFunction.cardFactors_apply_prime Nat.prime_two]
  norm_num

/-- Concrete: n = 2 shows the m = 0 case is FALSE. -/
example : ¬ (liouville (0 * 2) = liouville 0 * liouville 2) := by
  rw [Nat.zero_mul, liouville_zero, liouville_two]
  norm_num

end

end Rh46
