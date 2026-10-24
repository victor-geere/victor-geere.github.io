import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  intro h
  rcases hx with h1 | h1 <;> rcases hy with h2 | h2 <;> rw [h1, h2] at h <;> omega

example (a : ℕ) (ha : 2 ≤ a) : a - 2 ≠ 0 := by
  intro h0
  have hle : a ≤ 2 := by omega
  omega

end
end Rh46
