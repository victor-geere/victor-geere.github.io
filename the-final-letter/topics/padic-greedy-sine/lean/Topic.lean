import Mathlib

/-!
# p-adic greedy sine — formal core

The proposed p-adic analogue of the greedy harmonic sine uses steps
`p^{-n}` on `Z_p`.  That sequence is **not** p-adically null: its norm is
`p^n`, which grows.  The correct p-adic step sequence is `p^n` (equivalently,
the base-`p` digit expansion with digits `0, …, p-1`).

This file formalises the finite arithmetic of that corrected expansion:

* the base-`p` digit truncation `trunc p x N` is `x % p^N`;
* it satisfies `partial + p^N * (x / p^N) = x`;
* `p^n` is strictly shrinking in the p-adic norm, while `p^{-n}` grows.

The p-adic sine series, its Newton polygon and its zeros are recorded as
computation in the Python layer, not formalised here.
-/

noncomputable section

open Finset

namespace PadicGreedy

/-- The p-adic norm on `ℚ`. -/
def pNorm (p : ℕ) (q : ℚ) : ℚ := padicNorm p q

/-- The low `N` base-`p` digits of `x`, read as an integer. -/
def trunc (p x N : ℕ) : ℕ := Nat.ofDigits p ((Nat.digits p x).take N)

/-- The truncation is exactly `x mod p^N`. -/
theorem trunc_eq_mod {p x N : ℕ} (hp : 2 ≤ p) :
    trunc p x N = x % p ^ N := by
  unfold trunc
  rw [← Nat.self_mod_pow_eq_ofDigits_take N x hp]

/-- The truncation is strictly below `p^N`. -/
theorem trunc_lt {p x N : ℕ} (hp : 2 ≤ p) : trunc p x N < p ^ N := by
  rw [trunc_eq_mod hp]
  exact Nat.mod_lt _ (pow_pos (by omega) N)

/-- The truncated digits plus the remaining high part recover `x`. -/
theorem trunc_add {p x N : ℕ} (hp : 2 ≤ p) :
    trunc p x N + p ^ N * (x / p ^ N) = x := by
  rw [trunc_eq_mod hp]
  exact Nat.mod_add_div x (p ^ N)

/-- The p-adic norm of `p^n` is `p^{-n}`. -/
theorem pNorm_p_pow (p : ℕ) [Fact p.Prime] (n : ℕ) :
    pNorm p ((p : ℚ) ^ n) = (p : ℚ) ^ (-(n : ℤ)) := by
  unfold pNorm
  have hp : p.Prime := Fact.out
  rw [padicNorm.eq_zpow_of_nonzero]
  · rw [padicValRat.pow, padicValRat.self hp.one_lt]
    simp
  · exact pow_ne_zero n (by exact_mod_cast hp.ne_zero)

/-- The p-adic norm of `p^{-n}` is `p^n`: the proposed steps grow. -/
theorem pNorm_p_neg_pow (p : ℕ) [Fact p.Prime] (n : ℕ) :
    pNorm p ((p : ℚ) ^ (-(n : ℤ))) = (p : ℚ) ^ n := by
  have h : (p : ℚ) ^ (-(n : ℤ)) = ((p : ℚ) ^ n)⁻¹ := by
    rw [zpow_neg, zpow_natCast]
  rw [pNorm, h]
  rw [IsAbsoluteValue.abv_inv (padicNorm p)]
  change (pNorm p ((p : ℚ) ^ n))⁻¹ = (p : ℚ) ^ n
  rw [pNorm_p_pow]
  rw [zpow_neg, zpow_natCast, inv_inv]

/-- Higher powers of `p` are strictly smaller in the p-adic norm. -/
theorem pNorm_p_pow_strictAnti (p : ℕ) [Fact p.Prime] :
    StrictAnti (fun n : ℕ => pNorm p ((p : ℚ) ^ n)) := by
  intro a b hab
  change pNorm p ((p : ℚ) ^ b) < pNorm p ((p : ℚ) ^ a)
  rw [pNorm_p_pow, pNorm_p_pow]
  have hp : (1 : ℚ) < (p : ℚ) := by exact_mod_cast (Fact.out : p.Prime).one_lt
  exact (zpow_lt_zpow_iff_right₀ hp).2 (by omega)

end PadicGreedy
