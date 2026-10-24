/-
  Parity.lean — 020 round 119.

  The dimension factor `2^k` is even for `k ≥ 1`: the parity barrier's
  constants are themselves even, which is why a `k`-condition sieve can never
  reach a single-condition constant.
-/
import Mathlib

namespace Parity

/-- `2^k` is even for every `k ≥ 1`. -/
theorem even_two_pow {k : ℕ} (hk : 0 < k) : Even (2 ^ k) := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  exact ⟨2 ^ j, by rw [pow_succ]; ring⟩

/-- Consequently the dimension factor for `k ≥ 1` is at least `2`. -/
theorem two_pow_ge_two {k : ℕ} (hk : 0 < k) : 2 ≤ 2 ^ k := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  rw [pow_succ]
  have : 1 ≤ 2 ^ j := Nat.one_le_pow _ _ (by norm_num)
  nlinarith

end Parity

namespace Parity

/-- The dimension factor strictly increases: higher-dimensional sieves are
strictly worse. -/
theorem two_pow_lt_succ (k : ℕ) : 2 ^ k < 2 ^ (k + 1) := by
  rw [pow_succ]
  nlinarith [Nat.one_le_pow k 2 (by norm_num)]

end Parity
