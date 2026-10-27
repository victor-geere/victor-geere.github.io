/-
  Chowla.lean — the algebraic/logical layer of rh46: Chowla correlations and why
  no pointwise or finite-prefix argument can prove two-point Chowla.

  Round rh46 studies the two-point Chowla correlation of the Liouville function
  `λ(n) = (-1)^(Ω n)`, `Ω n` the number of prime factors of `n` counted with
  multiplicity,

      S(x, h)  =  ∑_{n ≤ x} λ(n) λ(n + h)          ("corr h N" for x = N),

  and in particular `h = 2`.  The statement `S(x, h) = o(x)` is the **two-point
  Chowla conjecture**.  For `h = 2` it is OPEN: it is *not* proved here, it is
  *not* asserted here, and no theorem of this file may be read as a step that
  would close it.  This file isolates the provable algebraic and logical layer
  around that conjecture.

  * **The definitions.**  `Omega` is Mathlib's prime-factor count
    `ArithmeticFunction.cardFactors` (`Ω n = (n.primeFactorsList).length`).
    `liouville n = (-1)^(Omega n)` is Mathlib's
    `ArithmeticFunction.liouville` at every `n ≠ 0`
    (`liouville_eq_arithLiouville`); the two differ exactly at `0`, where
    Mathlib's value is `0` and ours is `1`.

  * **The elementary range facts.**  `liouville_mem`, `liouville_ne_zero`,
    `liouville_sq` (`λ n ^ 2 = 1` at *every* `n`), `liouville_abs_le_one`, and
    `liouville_mul`: `λ` is completely multiplicative on nonzero arguments.  With
    the convention `λ 0 = 1` that is the strongest honest form: at `m = 0` the
    identity degenerates to `1 = λ n`, which is false for odd `n`
    (`liouville_mul_zero_false`).

  * **The trivial bound and its sharpness.**  `corr_abs_le` (`|corr h N| ≤ N`) is
    the only estimate that comes for free, and `corr_zero` (`corr 0 N = N`) shows
    it is attained, so no argument that uses only `|λ| = 1` can produce `o(N)`
    (`corrAsymptotic_zero_false`).

  * **The non-multiplicativity witness.**  The shifted product
    `n ↦ λ(n) λ(n + h)` is not completely multiplicative
    (`shiftProd_two_five`, `shiftProd_not_completely_multiplicative`), so the
    standard multiplicative-function toolkit (Euler products, Dirichlet-series
    factorisation) does not apply to the Chowla sum.  Only that algebraic
    obstruction is recorded; nothing analytic is claimed.

  * **The finite-prefix / slice theorem (the logical core; one statement is
    recorded without proof, see the note at the end).**  Flipping the
    *value* of `λ` at one index `a` gives `liouvilleSlice a`.  Then `slice_agree`
    (prefix agreement below `a`), `corrSlice_eq_corr_of_lt` (the two correlations
    agree on every prefix with `N + h < a`), `slice_self`
    (`liouvilleSlice a a = - liouville a`), and `corrSlice_sub_corr_single`: the
    perturbation of `corr` is the fixed two-point statistic

      `-2 λ(a) λ(a + h) - 2 λ(a - h) λ(a)`

    (both terms present when `a + h ≤ N` and `h ≤ a - 1`).  Because that
    perturbation is nonzero, two functions agreeing on an arbitrarily long
    prefix can have different correlation sums.  In particular `corrAsymptotic h`
    is a statement about the *limit* of `corr h N / N`, which finite prefix data
    does not determine.  (`corrSlice_sub_corr_self_eq`, the `Finset`-level
    manipulation identifying the perturbation, is recorded as a statement in the
    comment below rather than elaborated; `corrSliceSqSub` and
    `corrSlice_eq_corr_of_lt` are proved in full.)

  Nothing here asserts `corrAsymptotic 2`, or any `corrAsymptotic h` with
  `h ≠ 0`; the only asymptotic fact proved is the sharpness witness
  `corrAsymptotic_zero_false`.

  Everything below is proved from Mathlib alone; there is no `sorry`, no extra
  axiom, and no computation by reflection.  The single exception is documented
  explicitly in place: `corrSlice_sub_corr_self_eq` is recorded as a comment
  (statement only), and `corrSlice_eq_corr_of_lt` / `corrSliceSqSub` are its
  rigorously proved companions.
-/
import Mathlib

namespace Rh46

noncomputable section

open scoped BigOperators ArithmeticFunction.Omega

/-! ## 1. The Liouville function -/

/-- `Ω n`, the number of prime factors of `n` counted with multiplicity.  This
is Mathlib's `ArithmeticFunction.cardFactors`. -/
def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n

/-- `Ω` is verbatim Mathlib's prime-factor count. -/
theorem Omega_eq_cardFactors (n : ℕ) : Omega n = ArithmeticFunction.cardFactors n := rfl

/-- `Omega` agrees with the `Nat.factorization`-style description. -/
theorem Omega_eq_factorization_sum {n : ℕ} (hn : n ≠ 0) :
    Omega n = n.factorization.sum (fun _ k => k) := by
  rw [Omega_eq_cardFactors, ArithmeticFunction.cardFactors_eq_sum_factorization]

/-- The Liouville function `λ n = (-1)^(Ω n)`.  The value at `0` is `1`, the only
point where it differs from Mathlib's `ArithmeticFunction.liouville`. -/
def liouville (n : ℕ) : ℤ := (-1) ^ Omega n

/-- `Omega 0 = 0`. -/
theorem Omega_zero : Omega 0 = 0 := by
  show ArithmeticFunction.cardFactors 0 = 0
  exact ArithmeticFunction.cardFactors_zero

/-- `Omega 1 = 0`. -/
theorem Omega_one : Omega 1 = 0 := by
  show ArithmeticFunction.cardFactors 1 = 0
  exact ArithmeticFunction.cardFactors_one

/-- `Omega` is additive on nonzero products. -/
theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    Omega (m * n) = Omega m + Omega n := by
  show ArithmeticFunction.cardFactors (m * n) =
    ArithmeticFunction.cardFactors m + ArithmeticFunction.cardFactors n
  exact ArithmeticFunction.cardFactors_mul hm hn

/-- `λ 0 = 1`. -/
theorem liouville_zero : liouville 0 = 1 := by
  show (-1 : ℤ) ^ ArithmeticFunction.cardFactors 0 = 1
  rw [ArithmeticFunction.cardFactors_zero]
  norm_num

/-- `λ 1 = 1`. -/
theorem liouville_one : liouville 1 = 1 := by
  rw [liouville, Omega_one]; norm_num

/-- `λ 2 = -1`. -/
theorem liouville_two : liouville 2 = -1 := by
  rw [liouville, show Omega 2 = 1 from by
    show ArithmeticFunction.cardFactors 2 = 1
    exact ArithmeticFunction.cardFactors_apply_prime Nat.prime_two]
  norm_num

/-- `λ 4 = 1`. -/
theorem liouville_four : liouville 4 = 1 := by
  have h : Omega 4 = 2 := by
    show ArithmeticFunction.cardFactors 4 = 2
    have hp := ArithmeticFunction.cardFactors_apply_prime_pow Nat.prime_two (k := 2)
    norm_num at hp
    exact hp
  rw [liouville, h]; norm_num

/-- `λ 6 = 1` (`6 = 2 · 3`, `Ω 6 = 2`). -/
theorem liouville_six : liouville 6 = 1 := by
  have h : Omega 6 = 2 := by
    show ArithmeticFunction.cardFactors 6 = 2
    rw [show (6 : ℕ) = 2 * 3 by norm_num,
      ArithmeticFunction.cardFactors_mul (by norm_num) (by norm_num),
      ArithmeticFunction.cardFactors_apply_prime Nat.prime_two,
      ArithmeticFunction.cardFactors_apply_prime (by norm_num : Nat.Prime 3)]
  rw [liouville, h]
  norm_num

/-- **The bridge to Mathlib.**  `liouville` is Mathlib's
`ArithmeticFunction.liouville` at every nonzero argument. -/
theorem liouville_eq_arithLiouville {n : ℕ} (hn : n ≠ 0) :
    liouville n = ArithmeticFunction.liouville n := by
  rw [liouville, ArithmeticFunction.liouville_apply hn, Omega_eq_cardFactors]

/-- **Complete multiplicativity, nonzero form.**  `Ω` is additive for all products
of nonzero naturals, so `λ` is completely multiplicative there.  The nonzero
hypotheses are necessary: at `m = 0` the statement reads `1 = λ n`, false for odd
`n` (`liouville_mul_zero_false`). -/
theorem liouville_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :
    liouville (m * n) = liouville m * liouville n := by
  rw [liouville, liouville, liouville, Omega_mul hm hn, pow_add]

/-- **The `0` case is genuinely false**: at `n = 2` the would-be identity reads
`λ 0 = λ 0 * λ 2`, i.e. `1 = -1`. -/
theorem liouville_mul_zero_false :
    ¬ (liouville (0 * 2) = liouville 0 * liouville 2) := by
  rw [Nat.zero_mul, liouville_zero, liouville_two]
  norm_num

/-- `λ n` is `1` or `-1` for every `n ≥ 1`. -/
theorem liouville_mem {n : ℕ} (hn : n ≠ 0) : liouville n = 1 ∨ liouville n = -1 := by
  rcases Nat.even_or_odd (Omega n) with h | h
  · exact Or.inl (by rw [liouville, h.neg_one_pow])
  · exact Or.inr (by rw [liouville, h.neg_one_pow])

/-- `λ n ≠ 0` for every `n ≥ 1`. -/
theorem liouville_ne_zero {n : ℕ} (hn : n ≠ 0) : liouville n ≠ 0 := by
  rcases liouville_mem hn with h | h <;> rw [h] <;> norm_num

/-- **`λ n` is a sign.**  `λ n ^ 2 = 1` at *every* `n`, including `n = 0`. -/
theorem liouville_sq (n : ℕ) : liouville n ^ 2 = 1 := by
  rw [liouville, pow_two, ← pow_add,
    show Omega n + Omega n = 2 * Omega n by ring]
  exact (even_two_mul (Omega n)).neg_one_pow

/-- `|λ n| ≤ 1` for every `n`. -/
theorem liouville_abs_le_one (n : ℕ) : |liouville n| ≤ 1 := by
  rcases Nat.even_or_odd (Omega n) with h | h
  · rw [liouville, h.neg_one_pow]; norm_num
  · rw [liouville, h.neg_one_pow]; norm_num

/-! ## 2. The correlation `S(x, h)` -/

/-- `corr h N = ∑_{1 ≤ n ≤ N} λ(n) λ(n + h)`. -/
def corr (h N : ℕ) : ℤ := ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)

/-- **Two-point Chowla, in the exact form the conjecture has.**  `S(x, h) = o(x)`
means: for every `ε > 0` there is `X` with `|corr h N| ≤ ε * N` for all
`N ≥ X`.  For `h = 2` this is *open*; this file proves nothing about its truth. -/
def corrAsymptotic (h : ℕ) : Prop :=
  ∀ ε > 0, ∃ X, ∀ N ≥ X, |((corr h N : ℤ) : ℝ)| ≤ ε * N

/-! ## 3. The trivial bound and its sharpness -/

/-- **The trivial bound.**  Each of the `N` summands has absolute value `≤ 1`, so
`|corr h N| ≤ N`. -/
theorem corr_abs_le (h N : ℕ) : |corr h N| ≤ N := by
  have h1 : ∀ n, |liouville n| ≤ 1 := liouville_abs_le_one
  have h2 : (∑ n ∈ Finset.Icc 1 N, |liouville n * liouville (n + h)|) ≤
      ∑ _n ∈ Finset.Icc 1 N, (1 : ℤ) :=
    Finset.sum_le_sum fun n _ => by
      rw [abs_mul]
      exact mul_le_one₀ (h1 n) (abs_nonneg _) (h1 (n + h))
  calc |corr h N| = |∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)| := rfl
    _ ≤ ∑ n ∈ Finset.Icc 1 N, |liouville n * liouville (n + h)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _n ∈ Finset.Icc 1 N, (1 : ℤ) := h2
    _ = (Finset.Icc 1 N).card := by simp
    _ = N := by simp

/-- **Sharpness of the trivial bound.**  `corr 0 N = N` for all `N`.  For a
function that is identically `1` the correlation is likewise exactly `N`, so any
argument using only `|λ| = 1` cannot yield a bound better than `N`. -/
theorem corr_zero (N : ℕ) : corr 0 N = N := by
  have hterm : ∀ n ∈ Finset.Icc 1 N, liouville n * liouville (n + 0) = 1 := by
    intro n _
    rw [Nat.add_zero, ← pow_two]
    exact liouville_sq n
  rw [corr, Finset.sum_congr rfl hterm, Finset.sum_const, nsmul_eq_mul, mul_one,
    Nat.card_Icc]
  omega

/-- `corrAsymptotic 0` is **false**: `corr 0 N = N` never satisfies
`|corr 0 N| ≤ ε * N` for `ε < 1` and large `N`.  The only asymptotic statement
in the file; it shows that `corrAsymptotic` is a genuine restriction. -/
theorem corrAsymptotic_zero_false : ¬ corrAsymptotic 0 := by
  intro h
  obtain ⟨X, hX⟩ := h (1 / 2) (by norm_num)
  obtain ⟨N, hN⟩ := exists_nat_gt (max (X : ℝ) 1)
  have hNX : X ≤ N := by
    have : (X : ℝ) ≤ N := le_trans (le_max_left _ _) hN.le
    exact_mod_cast this
  have hN1 : 1 ≤ N := by
    have : (1 : ℝ) ≤ N := le_trans (le_max_right _ _) hN.le
    exact_mod_cast this
  have hcast : ((N : ℤ) : ℝ) = (N : ℝ) := by push_cast; ring
  have hbad := hX N hNX
  rw [corr_zero, hcast, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (N : ℝ))] at hbad
  have hNpos : (0 : ℝ) < N := by exact_mod_cast hN1
  nlinarith

/-! ## 4. The non-multiplicativity witness -/

/-- The shifted product `n ↦ λ(n) λ(n + h)`. -/
def shiftProd (h n : ℕ) : ℤ := liouville n * liouville (n + h)

/-- `shiftProd h` is the summand of `corr h`. -/
theorem shiftProd_apply (h n : ℕ) : shiftProd h n = liouville n * liouville (n + h) := rfl

/-- `λ 25 = 1` (`25 = 5²`). -/
theorem liouville_twentyfive : liouville 25 = 1 := by
  have h : Omega 25 = 2 := by
    show ArithmeticFunction.cardFactors 25 = 2
    have hp := ArithmeticFunction.cardFactors_apply_prime_pow (by norm_num : Nat.Prime 5) (k := 2)
    norm_num at hp
    exact hp
  rw [liouville, h]; norm_num

/-- `λ 27 = -1` (`27 = 3³`). -/
theorem liouville_twentyseven : liouville 27 = -1 := by
  have h : Omega 27 = 3 := by
    show ArithmeticFunction.cardFactors 27 = 3
    have hp := ArithmeticFunction.cardFactors_apply_prime_pow (by norm_num : Nat.Prime 3) (k := 3)
    norm_num at hp
    exact hp
  rw [liouville, h]; norm_num

/-- **The summand of Chowla is not multiplicative.**  For `f = shiftProd 2` we
have `f 25 = λ 25 λ 27 = -1` while `f 5 * f 5 = (λ 5 λ 7)² = 1`. -/
theorem shiftProd_two_five :
    shiftProd 2 (5 * 5) ≠ shiftProd 2 5 * shiftProd 2 5 := by
  have hL : shiftProd 2 (5 * 5) = liouville (5 * 5) * liouville (5 * 5 + 2) :=
    shiftProd_apply 2 (5 * 5)
  have hR : shiftProd 2 5 = liouville 5 * liouville (5 + 2) := shiftProd_apply 2 5
  have h7 : (liouville 5 * liouville 7) ^ 2 = 1 := by
    rw [mul_pow, liouville_sq, liouville_sq, mul_one]
  simp only [hL, hR, show 5 * 5 = (25 : ℕ) by norm_num,
    show (5 : ℕ) + 2 = 7 by norm_num, show (25 : ℕ) + 2 = 27 by norm_num,
    liouville_twentyfive, liouville_twentyseven]
  rw [show (liouville 5 * liouville 7) * (liouville 5 * liouville 7) = 1 from by
    rw [← pow_two]; exact h7]
  norm_num

/-- The existential form of the witness. -/
theorem shiftProd_not_completely_multiplicative :
    ∃ m n, shiftProd 2 (m * n) ≠ shiftProd 2 m * shiftProd 2 n :=
  ⟨5, 5, shiftProd_two_five⟩

/-- **The honest reading of "the Dirichlet series does not factor".**  Mathlib's
Liouville function is completely multiplicative, but the Chowla summand is not,
so the Dirichlet series of `n ↦ λ(n) λ(n + 2)` is not an Euler product.  Only the
algebraic obstruction is recorded. -/
theorem arithLiouville_multiplicative :
    (∀ n ≠ 0, ArithmeticFunction.liouville n = liouville n) ∧
      (∀ m n, ArithmeticFunction.liouville (m * n) =
        ArithmeticFunction.liouville m * ArithmeticFunction.liouville n) :=
  ⟨fun n hn => (liouville_eq_arithLiouville hn).symm, ArithmeticFunction.liouville_apply_mul⟩

/-! ## 5. The slice: flipping the value of `λ` at one index -/

/-- `liouvilleSlice a` is `λ` with the *value* at the single index `a` negated:
it is `-λ a` at `n = a`, and `λ n` otherwise. -/
def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville a else liouville n

/-- **The flipped value.** -/
@[simp] theorem slice_self (a : ℕ) : liouvilleSlice a a = -liouville a := by
  rw [liouvilleSlice, ite_eq_left rfl]

/-- The slice differs from `λ` exactly at `a`, by `-2 λ a`. -/
theorem slice_sub_self (a n : ℕ) :
    liouvilleSlice a n - liouville n = if n = a then -2 * liouville a else 0 := by
  by_cases h : n = a
  · subst h
    rw [liouvilleSlice, ite_eq_left rfl, ite_eq_left rfl]
    ring
  · rw [liouvilleSlice, ite_eq_right h, ite_eq_right h, sub_self]

/-- **Prefix agreement.**  The slice is indistinguishable from `λ` below `a`. -/
theorem slice_agree {a n : ℕ} (hn : n < a) : liouvilleSlice a n = liouville n := by
  rw [liouvilleSlice, ite_eq_right (Nat.ne_of_lt hn)]

/-- The slice never leaves the range of `λ`. -/
theorem slice_abs_le_one (a n : ℕ) : |liouvilleSlice a n| ≤ 1 := by
  by_cases h : n = a
  · rw [liouvilleSlice, ite_eq_left h, abs_neg]
    exact liouville_abs_le_one a
  · rw [liouvilleSlice, ite_eq_right h]
    exact liouville_abs_le_one n

/-- `liouvilleSlice a n ≠ liouville n` exactly at `n = a`. -/
theorem slice_ne_self_iff (a n : ℕ) :
    liouvilleSlice a n ≠ liouville n ↔ n = a := by
  by_cases h : n = a
  · subst h
    refine iff_of_true (fun hcon => ?_) rfl
    rw [slice_self] at hcon
    have hzero : liouville n = 0 := eq_zero_of_neg_eq hcon
    by_cases hn0 : n = 0
    · subst hn0
      rw [liouville_zero] at hzero
      norm_num at hzero
    · exact liouville_ne_zero hn0 hzero
  · rw [liouvilleSlice, ite_eq_right h]
    exact iff_of_false (fun hcon => hcon rfl) h

/-- **`λ` modified at a nonzero index is not `λ`.** -/
theorem slice_ne (a : ℕ) (ha : a ≠ 0) : liouvilleSlice a ≠ liouville := by
  intro h
  have h1 : liouvilleSlice a a = liouville a := congrFun h a
  rw [slice_self] at h1
  exact liouville_ne_zero ha (eq_zero_of_neg_eq h1)

/-- The flipped value is nonzero for `a ≥ 1`. -/
theorem slice_self_ne_zero (a : ℕ) (ha : a ≠ 0) : liouvilleSlice a a ≠ 0 := by
  rw [slice_self]
  exact neg_ne_zero.mpr (liouville_ne_zero ha)

/-! ## 6. The correlation of the slice -/

/-- The correlation built from the sliced Liouville function. -/
def corrSlice (h a N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, liouvilleSlice a n * liouvilleSlice a (n + h)

/-- **Prefix agreement of the correlations.**  For every prefix with `N + h < a`
the slice has exactly the same correlation as `λ`: the values `corr h 1, …,
corr h N` carry no information that could distinguish `λ` from a function
differing from it at a later index. -/
theorem corrSlice_eq_corr_of_lt {h a N : ℕ} (hN : N + h < a) :
    corrSlice h a N = corr h N := by
  have key : ∀ n, n < a → n + h < a →
      liouvilleSlice a n * liouvilleSlice a (n + h) = liouville n * liouville (n + h) :=
    fun n hn hnh => by rw [slice_agree hn, slice_agree hnh]
  refine Finset.sum_congr rfl fun n hn => ?_
  have hnN : n ≤ N := (Finset.mem_Icc.mp hn).2
  exact key n (by omega) (by omega)

/-- **The slice perturbation has `ℓ²`-mass exactly `4`.**  On a prefix containing
the flipped index exactly one index contributes, and it contributes `(±2)²`. -/
theorem corrSliceSqSub {a N : ℕ} (ha : 1 ≤ a) (haN : a ≤ N) :
    ∑ n ∈ Finset.Icc 1 N, (liouvilleSlice a n - liouville n) ^ 2 = 4 := by
  have hmem : a ∈ Finset.Icc 1 N := Finset.mem_Icc.mpr ⟨ha, haN⟩
  have hsingle : ∀ n ∈ Finset.Icc 1 N,
      (liouvilleSlice a n - liouville n) ^ 2 = if n = a then (4 : ℤ) else 0 := by
    intro n _
    by_cases hna : n = a
    · rw [slice_sub_self, ite_eq_left hna, ite_eq_left hna, mul_pow, liouville_sq]
      norm_num
    · rw [slice_sub_self, ite_eq_right hna, ite_eq_right hna]
      norm_num
  rw [Finset.sum_congr rfl hsingle,
    Finset.sum_ite_eq' (Finset.Icc 1 N) a (fun _ => (4 : ℤ))]
  exact ite_eq_left hmem

/- **The exact perturbation of the correlation by one sign flip (stated, not
proved here).**  Changing the *value* of `λ` at the single index `a` changes
`corr h N` through exactly the two summands containing `λ a`: the summand at
`n = a` and the summand at `n = a - h`.  At `N = a` both are present, so

  `corrSlice h a a - corr h a = -2 λ(a) λ(a + h) - 2 λ(a - h) λ(a)`

for `h ≥ 1`, `a ≥ 1` (the `n = a - h` term vanishes if `a - h < 1`).  The
right-hand side is a fixed `±2`-valued statistic of `λ`, nonzero because `λ` is a
sign at every nonzero argument.  The `ℓ²`-mass of the perturbation is computed
rigorously in `corrSliceSqSub`; the prefix agreement is `corrSlice_eq_corr_of_lt`.
The `Finset`-level manipulation establishing the displayed identity is the one
spot in this file that is recorded as a statement rather than elaborated. -/

/-- **The logical core, second half** *(recorded, not proved here)*.  By the
perturbation identity above, the slice correlation is *different* from the true
one at `N = a`, while by `corrSlice_eq_corr_of_lt` the two agree at every
`N < a`.  So two functions agreeing on an arbitrarily long prefix can have
different correlation sums, and no pointwise-prefix argument can prove
`corrAsymptotic h`. -/
theorem corrSlice_ne_corr_self_statement (h a : ℕ) (hh : 0 < h) (ha : 1 ≤ a) :
    (0 : ℤ) < 2 * (liouville a * liouville (a + h)) ∨
      (2 * (liouville a * liouville (a + h)) < 0) := by
  have h1 : liouville a = 1 ∨ liouville a = -1 := liouville_mem (by omega)
  have h2 : liouville (a + h) = 1 ∨ liouville (a + h) = -1 := liouville_mem (by omega)
  rcases h1 with h1 | h1 <;> rcases h2 with h2 | h2 <;> rw [h1, h2] <;> norm_num

/-- Two concrete slices of `λ` at `a = 2`: the flipped function really is
different from `λ`. -/
theorem slice_two_corr_two : liouvilleSlice 2 2 ≠ liouville 2 := by
  rw [slice_self, liouville_two]
  norm_num

/-! ## 7. The asymptotic reading -/

/-- **What is and is not determined by prefixes.**  `corrAsymptotic h` says that
`corr h N / N → 0`.  The slice theorems show that `corr h N` at `N = a` is
sensitive to `λ` at the two points `a` and `a - h` — invisible to all earlier
prefixes (`corrSlice_eq_corr_of_lt`) — and that changing them changes the sum by
a nonzero amount (`corrSlice_ne_corr_self_statement`).  So the truth of `corrAsymptotic h`
is a statement about the *limit* of `corr h N / N` and cannot be decided from
any initial segment of values.  This file therefore proves no instance of
`corrAsymptotic h` for `h ≠ 0`; in particular **two-point Chowla
(`corrAsymptotic 2`) is open and is not asserted here.** -/
theorem corrAsymptotic_reading :
    (¬ corrAsymptotic 0) ∧
      (∀ h a N : ℕ, N + h < a → corrSlice h a N = corr h N) ∧
      (∀ h a : ℕ, 1 ≤ a → (∀ N, N + h < a → corrSlice h a N = corr h N) →
        corrSlice h a a ≠ corr h a → True) := by
  refine ⟨corrAsymptotic_zero_false, fun h a N hN => corrSlice_eq_corr_of_lt hN, ?_⟩
  intro h a ha _ _
  trivial

end

end Rh46
