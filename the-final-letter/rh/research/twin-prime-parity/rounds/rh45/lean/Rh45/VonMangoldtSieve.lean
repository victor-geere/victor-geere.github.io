import Mathlib.NumberTheory.ArithmeticFunction.VonMangoldt

open ArithmeticFunction

/-- `Λ 6 = 0`: six is not a prime power. -/
theorem vonMangoldt_six : Λ 6 = 0 := by
  rw [vonMangoldt_eq_zero_iff]
  decide

/-- A positive real: `log 6 > 0`. -/
theorem log_six_pos : (0 : ℝ) < Real.log 6 := by positivity

/-- **`Λ` is not additive.**  The faulty linear sieve assumed
`f (p * i) = f p + f i` for `p ∤ i`, which for `f = Λ` fails at `6 = 2 * 3`:
`Λ 6 = 0` but `Λ 2 + Λ 3 = log 6 > 0`. -/
theorem vonMangoldt_not_additive : ∃ m n : ℕ, Λ (m * n) ≠ Λ m + Λ n := by
  refine ⟨2, 3, ?_⟩
  have h2 : Λ 2 = Real.log 2 := vonMangoldt_apply_prime (by decide)
  have h3 : Λ 3 = Real.log 3 := vonMangoldt_apply_prime (by decide)
  rw [vonMangoldt_six, h2, h3, ← Real.log_mul (by norm_num) (by norm_num)]
  norm_num
  exact ne_of_lt log_six_pos
