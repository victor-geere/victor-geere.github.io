import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  intro h
  rcases hx with h1 | h1
  · rcases hy with h2 | h2
    · subst h1; subst h2; exact absurd h (by norm_num)
    · subst h1; subst h2; exact absurd h (by norm_num)
  · rcases hy with h2 | h2
    · subst h1; subst h2; exact absurd h (by norm_num)
    · subst h1; subst h2; exact absurd h (by norm_num)

end
end Rh46
