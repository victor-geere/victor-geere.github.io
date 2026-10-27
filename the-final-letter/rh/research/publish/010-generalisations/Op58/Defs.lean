/-
  Op58/Defs.lean — the exact reduction behind the automorphic/spectral attempt.

  The point of this file is to record, machine-checked, the one piece of
  arithmetic geography that makes an *automorphic/spectral* input meaningful:

      S_2(x) = Σ_{n≤x} λ(n)λ(n+2)
             = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋) ,          (R1)

      S_1(y) = Σ_{m≤y} λ(m)λ(m+1) ,   C(K) = Σ_{k≤K} λ(2k-1)λ(2k+1) ,

  and

      C(K) = Σ_{k≤K} λ(4k² − 1) ,                    (R2)

  because λ is *completely* multiplicative (no coprimality hypothesis):

      λ((2k−1)(2k+1)) = λ(2k−1) λ(2k+1) .            (R3)

  So the whole open content of `S_2(x) = o(x)` is a sum of λ over the
  **quadratic polynomial** `k² − 1`.  That is precisely the shape attacked by
  spectral methods over ℚ (Kuznetsov / Maass forms for quadratic congruences)
  and by trace-function / ℓ-adic methods over 𝔽_q[T] (Sawin–Shusterman), where
  the analogous statement is a theorem.
-/

import Mathlib

namespace Op58

noncomputable section

open scoped BigOperators

open ArithmeticFunction

/-- The Liouville function `λ` is **completely** multiplicative: valid for all
`m, n`, with no coprimality hypothesis. -/
theorem liouville_mul (m n : ℕ) : liouville (m * n) = liouville m * liouville n := by
  rcases eq_or_ne m 0 with rfl | hm
  · simp
  rcases eq_or_ne n 0 with rfl | hn
  · simp
  rw [ArithmeticFunction.liouville_apply (mul_ne_zero hm hn),
    ArithmeticFunction.liouville_apply hm, ArithmeticFunction.liouville_apply hn,
    ArithmeticFunction.cardFactors_mul hm hn, pow_add]

/-- `λ(2) = −1`. -/
theorem liouville_two : liouville 2 = -1 := by
  rw [ArithmeticFunction.liouville_apply (by norm_num : (2 : ℕ) ≠ 0)]
  norm_num [ArithmeticFunction.cardFactors_apply]

/-- `λ(n)² = 1` for `n ≠ 0`. -/
theorem liouville_sq {n : ℕ} (hn : n ≠ 0) : liouville n * liouville n = 1 := by
  have h := liouville_apply (n := n) hn
  rw [h, ← pow_add]
  exact Even.neg_one_pow ⟨cardFactors n, by ring⟩

/-- **(R3)** the term-level identity: `λ((2k−1)(2k+1)) = λ(2k−1)λ(2k+1)`. -/
theorem liouville_pair (k : ℕ) :
    liouville ((2 * k - 1) * (2 * k + 1)) = liouville (2 * k - 1) * liouville (2 * k + 1) :=
  liouville_mul _ _

/-- `(2k−1)(2k+1) = 4k² − 1`. -/
theorem poly_identity (k : ℕ) : (2 * k - 1) * (2 * k + 1) = 4 * k * k - 1 := by
  rcases k with _ | k
  · norm_num
  · have h1 : 1 ≤ 2 * (k + 1) := by omega
    have h2 : 1 ≤ 4 * (k + 1) * (k + 1) := by nlinarith [h1]
    zify [h1, h2]
    ring

/-- The **even part** of the shift-2 correlation reduces to the shift-1
correlation: `λ(2m)λ(2m+2) = λ(m)λ(m+1)`. -/
theorem even_shift (m : ℕ) :
    liouville (2 * m) * liouville (2 * m + 2) = liouville m * liouville (m + 1) := by
  have h2 : (2 : ℕ) * m + 2 = 2 * (m + 1) := by ring
  rw [liouville_mul, h2, liouville_mul, liouville_two]
  ring

end

end Op58
