import Mathlib
import QuadraticInt.MultTwo
import QuadraticInt.SplitCountTwo

/-!
# The ideal-count formula and two-squares formula for `ℤ[√−2]`

The `d = 2` capstone, mirroring `GaussianInt/IdealCount.lean` T183–T199 with
`χ₄` replaced by the Kronecker character `χ₈'` (which corresponds to `ℚ(√−2)`)
and `w = 4` replaced by `w = 2`:

`# { I : Ideal ℤ[√−2] // absNorm I = n } = Σ_{d|n} χ₈'(d)`,

hence `r_{x²+2y²}(n) = 2 Σ_{d|n} χ₈'(d)`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace ZsqrtdTwo

/-- The Kronecker character `χ₈'` on the integers. -/
def chi8Int (n : ℤ) : ℂ := ((ZMod.χ₈' (n : ZMod 8) : ℤ) : ℂ)

/-- The divisor sum `Σ_{d|n} χ₈'(d)`. -/
def divisorSumChi8 (n : ℕ) : ℤ :=
  ∑ d ∈ n.divisors, ZMod.χ₈' (d : ZMod 8)

/-! ## Values of `χ₈'` -/

lemma chi8_nat_split {p : ℕ} [Fact p.Prime] (hp : p % 8 = 1 ∨ p % 8 = 3) :
    ZMod.χ₈' (p : ZMod 8) = 1 := by
  rw [ZMod.χ₈'_nat_eq_if_mod_eight]
  have hodd : p % 2 ≠ 0 := by rcases hp with h | h <;> omega
  rcases hp with h | h <;> simp [h, hodd]

lemma chi8_nat_inert {p : ℕ} [Fact p.Prime] (hp : p % 8 = 5 ∨ p % 8 = 7) :
    ZMod.χ₈' (p : ZMod 8) = -1 := by
  rw [ZMod.χ₈'_nat_eq_if_mod_eight]
  have hodd : p % 2 ≠ 0 := by rcases hp with h | h <;> omega
  rcases hp with h | h <;> simp [h, hodd]

lemma chi8_mul_zmod : ∀ a b : ZMod 8, ZMod.χ₈' (a * b) = ZMod.χ₈' a * ZMod.χ₈' b := by
  decide

lemma chi8_pow_split {p : ℕ} [Fact p.Prime] (hp : p % 8 = 1 ∨ p % 8 = 3) (j : ℕ) :
    ZMod.χ₈' ((p ^ j : ℕ) : ZMod 8) = 1 := by
  have hpv : ZMod.χ₈' (p : ZMod 8) = 1 := chi8_nat_split hp
  induction j with
  | zero => simp
  | succ j ih =>
      rw [pow_succ, Nat.cast_mul, chi8_mul_zmod, ih, hpv, mul_one]

lemma chi8_pow_inert {p : ℕ} [Fact p.Prime] (hp : p % 8 = 5 ∨ p % 8 = 7) (j : ℕ) :
    ZMod.χ₈' ((p ^ j : ℕ) : ZMod 8) = (-1 : ℤ) ^ j := by
  have hpv : ZMod.χ₈' (p : ZMod 8) = -1 := chi8_nat_inert hp
  induction j with
  | zero => simp
  | succ j ih =>
      rw [pow_succ, Nat.cast_mul, chi8_mul_zmod, ih, hpv]
      ring

lemma chi8_pow_two (j : ℕ) :
    ZMod.χ₈' ((2 ^ j : ℕ) : ZMod 8) = if j = 0 then 1 else 0 := by
  rw [ZMod.χ₈'_nat_eq_if_mod_eight]
  rcases Nat.eq_zero_or_pos j with rfl | hj
  · simp
  · have hmod : (2 ^ j) % 2 = 0 := by
      rw [Nat.pow_mod]; simp [hj.ne']
    simp [hmod, hj.ne']

/-! ## The local divisor sums -/

lemma divisorSumChi8_split {p : ℕ} [Fact p.Prime]
    (hp : p % 8 = 1 ∨ p % 8 = 3) (k : ℕ) :
    divisorSumChi8 (p ^ k) = (k + 1 : ℤ) := by
  unfold divisorSumChi8
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1), ZMod.χ₈' ((p ^ j : ℕ) : ZMod 8) = 1 := by
    intro j _
    exact chi8_pow_split hp j
  rw [Finset.sum_congr rfl h]
  simp

lemma divisorSumChi8_inert {p : ℕ} [Fact p.Prime]
    (hp : p % 8 = 5 ∨ p % 8 = 7) (k : ℕ) :
    divisorSumChi8 (p ^ k) = if Even k then 1 else 0 := by
  unfold divisorSumChi8
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1),
      ZMod.χ₈' ((p ^ j : ℕ) : ZMod 8) = (-1 : ℤ) ^ j := by
    intro j _
    exact chi8_pow_inert hp j
  rw [Finset.sum_congr rfl h]
  rw [← Fin.sum_univ_eq_sum_range (fun j => (-1 : ℤ) ^ j) (k + 1)]
  rw [Fin.sum_neg_one_pow]
  by_cases hk : Even k <;> simp [Nat.even_add_one, hk]

lemma divisorSumChi8_two (k : ℕ) : divisorSumChi8 (2 ^ k) = 1 := by
  unfold divisorSumChi8
  rw [Nat.sum_divisors_prime_pow Nat.prime_two]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro j _ hj0
    rw [ZMod.χ₈'_nat_eq_if_mod_eight]
    have hmod : (2 ^ j) % 2 = 0 := by
      rw [Nat.pow_mod]; simp [hj0]
    simp [hmod]
  · intro h
    simp at h

/-! ## Multiplicativity of the divisor sum -/

lemma chi8_mul (a b : ℤ) : ZMod.χ₈' (a * b) = ZMod.χ₈' a * ZMod.χ₈' b := by
  push_cast
  exact chi8_mul_zmod (a : ZMod 8) (b : ZMod 8)

lemma divisorSumChi8_mul {m n : ℕ} (hmn : Nat.Coprime m n) :
    divisorSumChi8 (m * n) = divisorSumChi8 m * divisorSumChi8 n := by
  unfold divisorSumChi8
  rw [hmn.divisors_mul]
  rw [Finset.sum_map]
  let f : ℕ × ℕ → ℤ := fun q => ZMod.χ₈' ((q.1 * q.2 : ℕ) : ZMod 8)
  change (∑ p ∈ (m.divisors ×ˢ n.divisors).attach, f ↑p) = _
  rw [Finset.sum_attach]
  rw [Finset.sum_product]
  have h : ∀ x ∈ m.divisors, ∀ y ∈ n.divisors,
      ZMod.χ₈' ((x * y : ℕ) : ZMod 8) =
        ZMod.χ₈' (x : ZMod 8) * ZMod.χ₈' (y : ZMod 8) := by
    intro x _ y _
    simpa using chi8_mul (x : ℤ) (y : ℤ)
  calc (∑ x ∈ m.divisors, ∑ y ∈ n.divisors, ZMod.χ₈' ((x * y : ℕ) : ZMod 8))
      = ∑ x ∈ m.divisors, (ZMod.χ₈' (x : ZMod 8) *
          ∑ y ∈ n.divisors, ZMod.χ₈' (y : ZMod 8)) := by
        apply Finset.sum_congr rfl
        intro x hx
        rw [Finset.sum_congr rfl (fun y hy => h x hx y hy), Finset.mul_sum]
    _ = (∑ x ∈ m.divisors, ZMod.χ₈' (x : ZMod 8)) *
          (∑ y ∈ n.divisors, ZMod.χ₈' (y : ZMod 8)) := by
        rw [Finset.sum_mul]

/-! ## The `ArithmeticFunction` assembly -/

def idealCountFunTwo : ArithmeticFunction ℤ where
  toFun n := if n = 0 then 0 else (idealCountTwo n : ℤ)
  map_zero' := by simp

def divisorSumFunTwo : ArithmeticFunction ℤ where
  toFun := divisorSumChi8
  map_zero' := by simp [divisorSumChi8]

lemma idealCountTwo_one : idealCountTwo 1 = 1 := by
  unfold idealCountTwo
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [Ideal.absNorm_eq_one_iff.mp I.2, Ideal.absNorm_eq_one_iff.mp J.2]
  · exact ⟨⟨⊤, by rw [Ideal.absNorm_top]⟩⟩

lemma idealCountFunTwo_isMultiplicative : idealCountFunTwo.IsMultiplicative := by
  constructor
  · simp [idealCountFunTwo, idealCountTwo_one]
  · intro m n hmn
    by_cases hm : m = 0
    · subst hm; simp [idealCountFunTwo]
    · by_cases hn : n = 0
      · subst hn; simp [idealCountFunTwo]
      · have hmn0 : m * n ≠ 0 := Nat.mul_ne_zero hm hn
        simp only [idealCountFunTwo, ArithmeticFunction.coe_mk, idealCountTwo, hm, hn, hmn0, if_false]
        change (Nat.card {I : Ideal R2 // Ideal.absNorm I = m * n} : ℤ) =
          (Nat.card {I : Ideal R2 // Ideal.absNorm I = m} : ℤ) *
            (Nat.card {I : Ideal R2 // Ideal.absNorm I = n} : ℤ)
        rw [idealCountTwo_mul hm hn hmn]
        push_cast
        ring

lemma divisorSumFunTwo_isMultiplicative : divisorSumFunTwo.IsMultiplicative := by
  constructor
  · simp [divisorSumFunTwo, divisorSumChi8]
  · intro m n hmn
    simpa [divisorSumFunTwo] using divisorSumChi8_mul hmn

lemma idealCountTwo_prime_pow_eq (p i : ℕ) (hp : p.Prime) :
    idealCountFunTwo (p ^ i) = divisorSumFunTwo (p ^ i) := by
  have hpi : p ^ i ≠ 0 := pow_ne_zero i hp.ne_zero
  simp only [idealCountFunTwo, divisorSumFunTwo, ArithmeticFunction.coe_mk, hpi, if_false,
    idealCountTwo]
  rcases hp.eq_two_or_odd with rfl | hodd
  · rw [ramified_ideal_count_two i, divisorSumChi8_two i]
    norm_num
  · have h8 : p % 8 = 1 ∨ p % 8 = 3 ∨ p % 8 = 5 ∨ p % 8 = 7 := by omega
    letI : Fact p.Prime := ⟨hp⟩
    rcases h8 with h | h | h | h
    · rw [split_ideal_count_two p i (Or.inl h), divisorSumChi8_split (Or.inl h) i]
      norm_num
    · rw [split_ideal_count_two p i (Or.inr h), divisorSumChi8_split (Or.inr h) i]
      norm_num
    · have hI : Nat.card {I : Ideal R2 // Ideal.absNorm I = p ^ i} = if Even i then 1 else 0 := by
        by_cases hi : Even i
        · obtain ⟨k, hk⟩ := hi
          rw [hk, show k + k = 2 * k by ring, inert_ideal_count_even_two p k (Or.inl h)]
          simp
        · rw [Nat.not_even_iff_odd] at hi
          obtain ⟨k, hk⟩ := hi
          rw [hk, inert_ideal_count_odd_two p k (Or.inl h)]
          simp
      have hD : divisorSumChi8 (p ^ i) = if Even i then 1 else 0 := divisorSumChi8_inert (Or.inl h) i
      rw [hI, hD]
      split_ifs <;> norm_num
    · have hI : Nat.card {I : Ideal R2 // Ideal.absNorm I = p ^ i} = if Even i then 1 else 0 := by
        by_cases hi : Even i
        · obtain ⟨k, hk⟩ := hi
          rw [hk, show k + k = 2 * k by ring, inert_ideal_count_even_two p k (Or.inr h)]
          simp
        · rw [Nat.not_even_iff_odd] at hi
          obtain ⟨k, hk⟩ := hi
          rw [hk, inert_ideal_count_odd_two p k (Or.inr h)]
          simp
      have hD : divisorSumChi8 (p ^ i) = if Even i then 1 else 0 := divisorSumChi8_inert (Or.inr h) i
      rw [hI, hD]
      split_ifs <;> norm_num

/-- The ideal-count formula for `ℤ[√−2]`. -/
theorem idealCountTwoFormula (n : ℕ) (hn : 1 ≤ n) :
    (idealCountTwo n : ℤ) = divisorSumChi8 n := by
  have hfun : idealCountFunTwo = divisorSumFunTwo :=
    (ArithmeticFunction.IsMultiplicative.eq_iff_eq_on_prime_powers idealCountFunTwo
      idealCountFunTwo_isMultiplicative divisorSumFunTwo
      divisorSumFunTwo_isMultiplicative).mpr
      (fun p i hp => idealCountTwo_prime_pow_eq p i hp)
  have hn0 : n ≠ 0 := by omega
  have h := congrArg (fun f : ArithmeticFunction ℤ => f n) hfun
  simpa [idealCountFunTwo, idealCountTwo, divisorSumFunTwo, ArithmeticFunction.coe_mk, hn0,
    if_false] using h

/-- **The two-squares-type formula for `x² + 2y²`:** the number of representations
is `2 Σ_{d|n} χ₈'(d)`. -/
theorem rTwo_formula (n : ℕ) (hn : 1 ≤ n) :
    Nat.card (NormElementsTwo n) = 2 * idealCountTwo n :=
  normElementsTwo_card_eq_two_mul_idealCount n (by omega)

theorem idealCountTwo_eq_divisorSum (n : ℕ) (hn : 1 ≤ n) :
    idealCountTwo n = (divisorSumChi8 n).toNat := by
  have h := idealCountTwoFormula n hn
  have h2 : idealCountTwo n = (divisorSumChi8 n).toNat := by
    rw [← h]
    simp
  exact h2

end ZsqrtdTwo

namespace ZsqrtdTwo

/-! ## Closed forms

A single arithmetic-function identity in `n`, with the character sum inline and
no reference to `idealCountTwo` or `toNat`. -/

/-- **The ideal count of `ℤ[√−2]`, closed form.** -/
theorem idealCountTwo_closed (n : ℕ) (hn : 1 ≤ n) :
    (idealCountTwo n : ℤ) = ∑ d ∈ n.divisors, ZMod.χ₈' (d : ZMod 8) := by
  rw [idealCountTwoFormula n hn]
  simp [divisorSumChi8]

/-- **The `x² + 2y²` representation count, closed form:**
`r₂'(n) = 2 Σ_{d|n} χ₈'(d)`. -/
theorem rTwo_closed (n : ℕ) (hn : 1 ≤ n) :
    (Nat.card (NormElementsTwo n) : ℤ) =
      2 * ∑ d ∈ n.divisors, ZMod.χ₈' (d : ZMod 8) := by
  have h1 : (Nat.card (NormElementsTwo n) : ℤ) = 2 * (idealCountTwo n : ℤ) := by
    rw [rTwo_formula n hn]
    push_cast
    ring
  rw [h1, idealCountTwoFormula n hn]
  simp [divisorSumChi8]

end ZsqrtdTwo
