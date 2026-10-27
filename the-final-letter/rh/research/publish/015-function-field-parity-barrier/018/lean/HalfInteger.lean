import Mathlib

namespace HalfInteger

/-- For `q ≡ 1 (mod 8)`, the numerator of `(q²−2q−7)/16` is `≡ 8 (mod 16)`. -/
theorem X_cong (q : ℤ) (hq : q % 8 = 1) : (q ^ 2 - 2 * q - 7) % 16 = 8 := by
  obtain ⟨k, rfl⟩ : ∃ k, q = 8 * k + 1 := ⟨(q - 1) / 8, by omega⟩
  have : (8 * k + 1) ^ 2 - 2 * (8 * k + 1) - 7 = 64 * k ^ 2 - 8 := by ring
  rw [this]
  omega

/-- For odd `a`, the numerator of `(a²+1)/4` is `≡ 2 (mod 4)`. -/
theorem Y_cong (a : ℤ) (ha : a % 2 = 1) : (a ^ 2 + 1) % 4 = 2 := by
  obtain ⟨k, rfl⟩ : ∃ k, a = 2 * k + 1 := ⟨(a - 1) / 2, by omega⟩
  have : (2 * k + 1) ^ 2 + 1 = 4 * (k ^ 2 + k) + 2 := by ring
  rw [this]
  omega

end HalfInteger
