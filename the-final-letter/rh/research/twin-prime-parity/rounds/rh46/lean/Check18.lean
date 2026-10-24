import Mathlib
namespace Rh46
noncomputable section
open scoped BigOperators ArithmeticFunction.Omega

theorem sign_add_ne_zero_test {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  rintro h
  rcases hx with h1 | h1 <;> rcases hy with h2 | h2 <;> rw [h1, h2] at h <;> norm_num at h

example (a : ℕ) (ha : 2 ≤ a) : a + 2 ≠ 0 := by omega
example (a : ℕ) (ha : 2 ≤ a) : a - 2 ≠ 0 := by omega
example (a : ℕ) (ha : 2 ≤ a) : a ≠ 0 := by omega
example (a : ℕ) (ha : 2 ≤ a) : 1 + 2 ≤ a := by omega
example (a : ℕ) (ha : 2 ≤ a) : a - 2 ∈ Finset.Icc 1 a := by
  refine Finset.mem_Icc.mpr ⟨?_, ?_⟩
  · exact Nat.le_sub_of_add_le (by omega : 1 + 2 ≤ a)
  · exact Nat.sub_le a 2

end
end Rh46
