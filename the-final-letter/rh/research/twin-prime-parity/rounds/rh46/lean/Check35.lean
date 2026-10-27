import Mathlib
namespace Rh46
noncomputable section

theorem sign_add_ne_zero {u v : ℤ} (hu : u ^ 2 = 1) (hv : v ^ 2 = 1) : u + v ≠ 0 := by
  intro h
  have hpq : u * v = -1 := by nlinarith
  nlinarith [hpq, hu]

end
end Rh46
