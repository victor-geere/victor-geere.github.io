/-
  PrecisionFloor.lean — OP-33(a): the precision floor is a theorem, not a bug.

  The rh40 residual orbit obeys `r_{k+1} ≤ (r k)²` (equivalently
  `r_{k+1} = r_k − 1/⌈1/r_k⌉` with `1/(q+2) ≥ r/2`).  Iterating the square gives
  `r_k ≤ (1/10)^{2^k}` as soon as `r_0 ≤ 1/10`, so reaching `r_K < 10^{−D}` needs
  `2^{K−1} ≤ D`, i.e. a forward orbit at `D` decimal digits can run only
  `K ≤ log₂ D + 1` steps before underflow.  This is the precise reason the source's
  finite-`r` measurements stop after 7–13 steps (OP-33), and it is why the backward
  route is the only way to reach `10^4` prescribed steps.

  See `research/attacks/OP-28-30-33.md` §2.2–2.3.
-/
import Mathlib

namespace Rh42

/-- A power of a unit fraction is the unit fraction of the power. -/
lemma one_div_pow (n : ℕ) : ((1 : ℚ) / 10) ^ n = 1 / (10 : ℚ) ^ n := by
  rw [div_pow, one_pow]

/-- The one-step loss `r (k+1) ≤ (r k)²` iterates to `r k ≤ (1/10)^{2^k}`. -/
lemma pow_ten_two_pow_le {r : ℕ → ℚ} (hpos : ∀ k, 0 ≤ r k) (h0 : r 0 ≤ 1 / 10)
    (hstep : ∀ k, r (k + 1) ≤ (r k) ^ 2) :
    ∀ k : ℕ, r k ≤ (1 / 10 : ℚ) ^ (2 ^ k) := by
  intro k
  induction k with
  | zero => simpa using h0
  | succ k ih =>
      calc r (k + 1) ≤ (r k) ^ 2 := hstep k
        _ ≤ ((1 / 10 : ℚ) ^ (2 ^ k)) ^ 2 := pow_le_pow_left₀ (hpos k) ih 2
        _ = (1 / 10 : ℚ) ^ (2 ^ k * 2) := by rw [pow_mul]
        _ = (1 / 10 : ℚ) ^ (2 ^ (k + 1)) := rfl

/-- Comparing unit-fraction powers: `(1/10)^D < (1/10)^{2^{K-1}}` forces
`2^{K-1} < D`. -/
lemma two_pow_pred_lt_of_unit_lt {D K : ℕ}
    (h : (1 / 10 : ℚ) ^ D < (1 / 10 : ℚ) ^ (2 ^ (K - 1))) :
    2 ^ (K - 1) < D := by
  have hD : (0 : ℚ) < (10 : ℚ) ^ D := by positivity
  have hK : (0 : ℚ) < (10 : ℚ) ^ (2 ^ (K - 1)) := by positivity
  have h1 : ((10 : ℚ) ^ D)⁻¹ < ((10 : ℚ) ^ (2 ^ (K - 1)))⁻¹ := by
    simpa [one_div, inv_pow] using h
  have h2 : (10 : ℚ) ^ (2 ^ (K - 1)) < (10 : ℚ) ^ D := (inv_lt_inv₀ hD hK).mp h1
  exact (pow_lt_pow_iff_right₀ (by norm_num : (1 : ℚ) < 10)).mp h2

/-- **OP-33(a), the precision floor.**  If `r` is nonnegative, `r 0 ≤ 1/10`,
`r (k+1) ≤ (r k)²`, and `10^{−D} < r (K−1)`, then `2^{K−1} ≤ D`: a forward orbit that
has not yet underflowed after `K−1` squaring steps needs `D ≥ 2^{K−1}` decimal digits,
i.e. `K ≤ log₂ D + 2`. -/
theorem step_bound {r : ℕ → ℚ} (hpos : ∀ k, 0 ≤ r k) (h0 : r 0 ≤ 1 / 10)
    (hstep : ∀ k, r (k + 1) ≤ (r k) ^ 2) {D K : ℕ}
    (hK : (1 / 10 : ℚ) ^ D < r (K - 1)) : 2 ^ (K - 1) ≤ D :=
  le_of_lt (two_pow_pred_lt_of_unit_lt
    (lt_of_lt_of_le hK (pow_ten_two_pow_le hpos h0 hstep (K - 1))))

end Rh42
