import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  rcases hx with h1 | h1 <;> rcases hy with h2 | h2 <;> rw [h1, h2] <;> norm_num

example (a : ℕ) (ha : 2 ≤ a) : a ≠ 0 := by
  have h : 1 ≤ a := by omega
  omega

example (a : ℕ) (ha : 2 ≤ a) : a ≠ 0 := by
  intro h; rw [h] at ha; omega

example (a : ℕ) (ha : 2 ≤ a) : a - 2 ≠ 0 := Nat.sub_ne_zero_of_lt (by omega : 2 < a)

end
end Rh46
