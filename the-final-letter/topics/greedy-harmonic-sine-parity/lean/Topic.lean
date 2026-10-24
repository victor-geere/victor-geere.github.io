import Mathlib

/-!
# Greedy harmonic sine / twin-prime parity — finite-prefix formal core

The archived `summary-rh` corpus asks whether the greedy harmonic sine can
solve the parity problem for the twin prime conjecture.  Its own verdict is
that it cannot, and the one clean theorem it produced on the parity side is
the **finite-prefix indeterminacy theorem** for the two-point Liouville
correlation

`S(x, h) = ∑_{1 ≤ n ≤ N} λ(n) λ(n + h)`.

This file reconstructs the elementary, machine-checked core of that logical
layer.  It does **not** state or prove two-point Chowla, the twin prime
conjecture, the Riemann hypothesis, Sarnak's conjecture or Elliott's
conjecture.  No asymptotic statement about `corr` is proved here; the only
content is the algebraic sign structure, the trivial bound, the prefix
agreement of a one-point slice, the exact `ℓ²` mass of that slice, and the
non-complete-multiplicativity witness for the shifted product.
-/

namespace GSP

noncomputable section

open scoped BigOperators

/-! ## 1. The Liouville sign and the correlation -/

/-- `Ω n`, the number of prime factors of `n`, counted with multiplicity. -/
def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n

/-- The Liouville function `λ n = (-1)^(Ω n)`; the value at `0` is `1`. -/
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

/-- The two-point correlation `S(x,h) = ∑_{1 ≤ n ≤ N} λ(n) λ(n+h)`. -/
def corr (h N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)

/-- The summand of the correlation at shift `h`. -/
def shiftProd (h n : ℕ) : ℤ := liouville n * liouville (n + h)

/-- `λ` with the single value at index `a` negated. -/
def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville a else liouville n

/-- The correlation built from the sliced Liouville function. -/
def corrSlice (h a N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, liouvilleSlice a n * liouvilleSlice a (n + h)

/-! ## 2. The proved core -/

/-- **`λ` is a sign everywhere.**  `λ n ^ 2 = 1` for every `n`, including
`n = 0`.  This is the parity fact on which the trivial bound rests. -/
theorem liouville_sq (n : ℕ) : liouville n ^ 2 = 1 := by
  rw [liouville, pow_two, ← pow_add,
    show Omega n + Omega n = 2 * Omega n by ring]
  exact (even_two_mul (Omega n)).neg_one_pow

/-- **The trivial bound.**  Each of the `N` summands has absolute value at
most `1`, so `|S(x,h)| ≤ N`.  It is the only estimate that follows from
`|λ| = 1` alone. -/
theorem corr_abs_le (h N : ℕ) : |corr h N| ≤ (N : ℤ) := by
  have h1 : ∀ n, |liouville n| ≤ 1 := by
    intro n
    rcases Nat.even_or_odd (Omega n) with he | ho
    · rw [liouville, he.neg_one_pow]; norm_num
    · rw [liouville, ho.neg_one_pow]; norm_num
  have h2 : (∑ n ∈ Finset.Icc 1 N, |liouville n * liouville (n + h)|) ≤
      ∑ _n ∈ Finset.Icc 1 N, (1 : ℤ) :=
    Finset.sum_le_sum fun n _ => by
      rw [abs_mul]
      nlinarith [h1 n, h1 (n + h), abs_nonneg (liouville n),
        abs_nonneg (liouville (n + h))]
  calc |corr h N|
      = |∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)| := rfl
    _ ≤ ∑ n ∈ Finset.Icc 1 N, |liouville n * liouville (n + h)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _n ∈ Finset.Icc 1 N, (1 : ℤ) := h2
    _ = (Finset.Icc 1 N).card := by simp
    _ = (N : ℤ) := by simp

/-- **Sharpness.**  At zero shift the correlation is exactly `N`, so the
trivial bound is attained and no argument using only `|λ| = 1` can produce an
`o(N)` estimate. -/
theorem corr_zero (N : ℕ) : corr 0 N = (N : ℤ) := by
  have hterm : ∀ n ∈ Finset.Icc 1 N, liouville n * liouville (n + 0) = 1 := by
    intro n _
    rw [Nat.add_zero, ← pow_two]
    exact liouville_sq n
  rw [corr, Finset.sum_congr rfl hterm, Finset.sum_const, nsmul_eq_mul, mul_one,
    Nat.card_Icc]
  omega

/-- **Prefix agreement of one flipped value.**  The sliced function equals `λ`
at every index below `a`, so no initial segment can see the flip. -/
theorem slice_agree {a n : ℕ} (hn : n < a) : liouvilleSlice a n = liouville n := by
  rw [liouvilleSlice, ite_eq_right (Nat.ne_of_lt hn)]

/-- **Prefix agreement of the correlations.**  If `N + h < a` then the
correlation of the slice and the correlation of `λ` agree on the whole prefix
`1, …, N`.  This is the finite-prefix statement: prefix data cannot
distinguish `λ` from a function changed at a later index. -/
theorem corrSlice_eq_corr_of_lt {h a N : ℕ} (hN : N + h < a) :
    corrSlice h a N = corr h N := by
  have key : ∀ n, n < a → n + h < a →
      liouvilleSlice a n * liouvilleSlice a (n + h) =
        liouville n * liouville (n + h) :=
    fun n hn hnh => by rw [slice_agree hn, slice_agree hnh]
  refine Finset.sum_congr rfl fun n hn => ?_
  have hnN : n ≤ N := (Finset.mem_Icc.mp hn).2
  exact key n (by omega) (by omega)

/-- **The slice perturbation has `ℓ²`-mass exactly `4`.**  On any prefix
containing the flipped index exactly one term contributes, and it contributes
`(±2)² = 4`.  This is the sharp quantitative form of the one-point flip. -/
theorem corrSliceSqSub {a N : ℕ} (ha : 1 ≤ a) (haN : a ≤ N) :
    ∑ n ∈ Finset.Icc 1 N, (liouvilleSlice a n - liouville n) ^ 2 = 4 := by
  have hmem : a ∈ Finset.Icc 1 N := Finset.mem_Icc.mpr ⟨ha, haN⟩
  have hsingle : ∀ n ∈ Finset.Icc 1 N,
      (liouvilleSlice a n - liouville n) ^ 2 = if n = a then (4 : ℤ) else 0 := by
    intro n _
    by_cases hna : n = a
    · rw [liouvilleSlice, ite_eq_left hna, hna]
      have hdouble : -liouville a - liouville a = -2 * liouville a := by ring
      rw [hdouble, mul_pow, liouville_sq]
      norm_num
    · rw [liouvilleSlice, ite_eq_right hna, ite_eq_right hna]
      norm_num
  rw [Finset.sum_congr rfl hsingle,
    Finset.sum_ite_eq' (Finset.Icc 1 N) a (fun _ => (4 : ℤ))]
  exact ite_eq_left hmem

/-- **The shifted product is not completely multiplicative.**  With
`f(n) = λ(n)λ(n+2)`, `f(25) = λ(25)λ(27) = -1` while
`f(5)·f(5) = (λ(5)λ(7))² = 1`.  This is the source's witness at the
non-coprime pair `(5,5)`; multiplicativity at coprime arguments is not
addressed by it. -/
theorem shiftProd_two_five :
    shiftProd 2 (5 * 5) ≠ shiftProd 2 5 * shiftProd 2 5 := by
  have h25 : liouville 25 = 1 := by
    have h : Omega 25 = 2 := by
      show ArithmeticFunction.cardFactors 25 = 2
      have hp := ArithmeticFunction.cardFactors_apply_prime_pow
        (by norm_num : Nat.Prime 5) (k := 2)
      norm_num at hp
      exact hp
    rw [liouville, h]; norm_num
  have h27 : liouville 27 = -1 := by
    have h : Omega 27 = 3 := by
      show ArithmeticFunction.cardFactors 27 = 3
      have hp := ArithmeticFunction.cardFactors_apply_prime_pow
        (by norm_num : Nat.Prime 3) (k := 3)
      norm_num at hp
      exact hp
    rw [liouville, h]; norm_num
  have h7 : (liouville 5 * liouville 7) ^ 2 = 1 := by
    rw [mul_pow, liouville_sq, liouville_sq, mul_one]
  have hL : shiftProd 2 (5 * 5) = liouville (5 * 5) * liouville (5 * 5 + 2) := rfl
  have hR : shiftProd 2 5 = liouville 5 * liouville (5 + 2) := rfl
  simp only [hL, hR, show 5 * 5 = (25 : ℕ) by norm_num,
    show (5 : ℕ) + 2 = 7 by norm_num, show (25 : ℕ) + 2 = 27 by norm_num,
    h25, h27]
  rw [show (liouville 5 * liouville 7) * (liouville 5 * liouville 7) = 1 from by
    rw [← pow_two]; exact h7]
  norm_num

end

end GSP
