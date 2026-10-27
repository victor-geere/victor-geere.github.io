import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  intro h
  rcases hx with h1 | h1 <;> rcases hy with h2 | h2
  · omega
  · rw [h1, h2] at h; omega
  · rw [h1, h2] at h; omega
  · rw [h1, h2] at h; omega

example (h : (1 : ℤ) + (-1) = 0) : False := by omega
example (h : (1 : ℤ) + (-1) = 0) : False := by norm_num at h

end
end Rh46
