import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  have hx' : x = 1 ∨ x + 1 = 0 := by
    rcases hx with h | h
    · exact Or.inl h
    · exact Or.inr (by rw [h]; norm_num)
  have hy' : y = 1 ∨ y + 1 = 0 := by
    rcases hy with h | h
    · exact Or.inl h
    · exact Or.inr (by rw [h]; norm_num)
  intro h
  rcases hx' with h1 | h1 <;> rcases hy' with h2 | h2
  · rw [h1, h2] at h; exact one_add_one_eq_two ▸ h
  · rw [h1] at h; exact absurd h (by rw [h2]; norm_num)
  · rw [h2] at h; exact absurd h (by rw [h1]; norm_num)
  · rw [h1, h2] at h; exact absurd h (by norm_num)

end
end Rh46
