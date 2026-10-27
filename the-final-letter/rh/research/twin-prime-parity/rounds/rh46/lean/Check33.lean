import Mathlib
namespace Rh46
noncomputable section

example (a h : ℕ) (ha : 1 ≤ a) (hh : 0 < h) : a - h < a := by omega
example (a h : ℕ) (ha : 1 ≤ a) (hh : 0 < h) : a - h < a := Nat.sub_lt (by omega) hh
example (a h N : ℕ) (ha : 1 ≤ a) (haN : a ≤ N) (hh : 0 < h) : a - h < a := by omega
example (a h : ℕ) (hh : 0 < h) (hsub : a - h = 0) : a ≤ h := by omega

theorem sign_add_ne_zero {x y : ℤ} (hx : x = 1 ∨ x = -1) (hy : y = 1 ∨ y = -1) :
    x + y ≠ 0 := by
  intro h
  have hy' : y = -x := by omega
  rcases hx with h1 | h1
  · rw [h1] at hy'; rw [hy'] at h; norm_num at h
  · rw [h1] at hy'; rw [hy'] at h; norm_num at h

example (a : ℕ) (ha : 2 ≤ a) : a - 2 ≠ 0 := by omega
example (a : ℕ) (ha : 2 ≤ a) : a - 2 ≠ 0 := Nat.sub_ne_zero_of_lt (by omega : 2 < a)

end
end Rh46
