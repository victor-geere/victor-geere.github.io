import Mathlib
open scoped BigOperators ArithmeticFunction.Omega
namespace Rh46
noncomputable section

def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

theorem liouville_ne_zero {n : ℕ} (hn : n ≠ 0) : liouville n ≠ 0 := by
  rcases Nat.even_or_odd (Omega n) with h | h
  · rw [liouville, h.neg_one_pow]; norm_num
  · rw [liouville, h.neg_one_pow]; norm_num

example (a : ℕ) (ha : a ≠ 0) (h : -liouville a = liouville a) : False :=
  liouville_ne_zero ha (eq_zero_of_neg_eq h)

example (a N : ℕ) (ha : 1 ≤ a) (haN : a ≤ N) (x : ℤ) :
    (∑ n ∈ Finset.Icc 1 N, (if n = a then x else 0)) = x := by
  rw [Finset.sum_ite_eq' (Finset.Icc 1 N) a (fun _ => x)]
  exact ite_eq_left (Finset.mem_Icc.mpr ⟨ha, haN⟩)

end
end Rh46
