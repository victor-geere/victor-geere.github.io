import Mathlib
namespace Rh46
noncomputable section
open scoped BigOperators ArithmeticFunction.Omega

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    Omega (m * n) = Omega m + Omega n := by
  show ArithmeticFunction.cardFactors (m * n) =
    ArithmeticFunction.cardFactors m + ArithmeticFunction.cardFactors n
  exact ArithmeticFunction.cardFactors_mul hm hn

theorem liouville_six : liouville 6 = -1 := by
  have h1 := Omega_mul (m := 2) (n := 3) (by norm_num) (by norm_num)
  have h2 : Omega 2 = 1 := by
    show ArithmeticFunction.cardFactors 2 = 1
    exact ArithmeticFunction.cardFactors_apply_prime Nat.prime_two
  have h3 : Omega 3 = 1 := by
    show ArithmeticFunction.cardFactors 3 = 1
    exact ArithmeticFunction.cardFactors_apply_prime (by norm_num : Nat.Prime 3)
  have h4 : (6 : ℕ) = 2 * 3 := by norm_num
  rw [h4, h1, h2, h3]
  norm_num

end
end Rh46
