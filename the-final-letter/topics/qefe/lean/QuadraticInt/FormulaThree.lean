import Mathlib
import QuadraticInt.MultThree
import QuadraticInt.SplitCountThreeFull

/-!
# The ideal-count and representation formulas for `ℤ[ω]`

With `χ₃ := quadraticChar (ZMod 3)` (the quadratic character of `ℚ(√−3)`),

`# { I : Ideal ℤ[ω] // absNorm I = n } = Σ_{d|n} χ₃(d)`

and `r_{x²−xy+y²}(n) = 6 Σ_{d|n} χ₃(d)`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace EisensteinInt

/-- The quadratic character `χ₃` on the integers. -/
def chi3Int (n : ℤ) : ℂ := ((quadraticChar (ZMod 3) (n : ZMod 3) : ℤ) : ℂ)

/-- The divisor sum `Σ_{d|n} χ₃(d)`. -/
def divisorSumChi3 (n : ℕ) : ℤ :=
  ∑ d ∈ n.divisors, quadraticChar (ZMod 3) (d : ZMod 3)

lemma chi3_zero : quadraticChar (ZMod 3) (0 : ZMod 3) = 0 := by decide
lemma chi3_one : quadraticChar (ZMod 3) (1 : ZMod 3) = 1 := by decide
lemma chi3_two : quadraticChar (ZMod 3) (2 : ZMod 3) = -1 := by decide

lemma chi3_nat_split {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 1) :
    quadraticChar (ZMod 3) (p : ZMod 3) = 1 := by
  have hpz : ((p : ZMod 3)) = (1 : ZMod 3) := by
    have h : ((p : ZMod 3)) = (((1 : ℕ)) : ZMod 3) := by
      rw [ZMod.natCast_eq_natCast_iff']
      show p % 3 = 1 % 3
      simp [hp3]
    simpa using h
  rw [hpz]
  exact chi3_one

lemma chi3_nat_inert {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 2) :
    quadraticChar (ZMod 3) (p : ZMod 3) = -1 := by
  have hpz : ((p : ZMod 3)) = (2 : ZMod 3) := by
    have h : ((p : ZMod 3)) = (((2 : ℕ)) : ZMod 3) := by
      rw [ZMod.natCast_eq_natCast_iff']
      show p % 3 = 2 % 3
      simp [hp3]
    simpa using h
  rw [hpz]
  exact chi3_two

lemma chi3_mul_zmod : ∀ a b : ZMod 3,
    quadraticChar (ZMod 3) (a * b) = quadraticChar (ZMod 3) a * quadraticChar (ZMod 3) b := by
  decide

lemma chi3_pow_split {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 1) (j : ℕ) :
    quadraticChar (ZMod 3) ((p ^ j : ℕ) : ZMod 3) = 1 := by
  have hpv : quadraticChar (ZMod 3) (p : ZMod 3) = 1 := chi3_nat_split hp3
  induction j with
  | zero => simp
  | succ j ih =>
      rw [pow_succ, Nat.cast_mul, chi3_mul_zmod, ih, hpv, mul_one]

lemma chi3_pow_inert {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 2) (j : ℕ) :
    quadraticChar (ZMod 3) ((p ^ j : ℕ) : ZMod 3) = (-1 : ℤ) ^ j := by
  have hpv : quadraticChar (ZMod 3) (p : ZMod 3) = -1 := chi3_nat_inert hp3
  induction j with
  | zero => simp
  | succ j ih =>
      rw [pow_succ, Nat.cast_mul, chi3_mul_zmod, ih, hpv]
      ring

lemma chi3_pow_three (j : ℕ) :
    quadraticChar (ZMod 3) ((3 ^ j : ℕ) : ZMod 3) = if j = 0 then 1 else 0 := by
  rcases Nat.eq_zero_or_pos j with rfl | hj
  · simp
  · have hz : ((3 ^ j : ℕ) : ZMod 3) = 0 := by
      have hdvd : (3 : ℕ) ∣ 3 ^ j := dvd_pow_self 3 hj.ne'
      have hZ : ((3 ^ j : ℤ) : ZMod 3) = 0 :=
        (ZMod.intCast_zmod_eq_zero_iff_dvd _ 3).mpr (by exact_mod_cast hdvd)
      simpa using hZ
    rw [hz, chi3_zero]
    simp [hj.ne']

lemma divisorSumChi3_split {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 1) (k : ℕ) :
    divisorSumChi3 (p ^ k) = (k + 1 : ℤ) := by
  unfold divisorSumChi3
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1), quadraticChar (ZMod 3) ((p ^ j : ℕ) : ZMod 3) = 1 := by
    intro j _
    exact chi3_pow_split hp3 j
  rw [Finset.sum_congr rfl h]
  simp

lemma divisorSumChi3_inert {p : ℕ} [Fact p.Prime] (hp3 : p % 3 = 2) (k : ℕ) :
    divisorSumChi3 (p ^ k) = if Even k then 1 else 0 := by
  unfold divisorSumChi3
  rw [Nat.sum_divisors_prime_pow (Fact.out : p.Prime)]
  have h : ∀ j ∈ Finset.range (k + 1),
      quadraticChar (ZMod 3) ((p ^ j : ℕ) : ZMod 3) = (-1 : ℤ) ^ j := by
    intro j _
    exact chi3_pow_inert hp3 j
  rw [Finset.sum_congr rfl h]
  rw [← Fin.sum_univ_eq_sum_range (fun j => (-1 : ℤ) ^ j) (k + 1)]
  rw [Fin.sum_neg_one_pow]
  by_cases hk : Even k <;> simp [Nat.even_add_one, hk]

lemma divisorSumChi3_three (k : ℕ) : divisorSumChi3 (3 ^ k) = 1 := by
  unfold divisorSumChi3
  rw [Nat.sum_divisors_prime_pow Nat.prime_three]
  rw [Finset.sum_eq_single 0]
  · simp
  · intro j _ hj0
    have hz : ((3 ^ j : ℕ) : ZMod 3) = 0 := by
      have hdvd : (3 : ℕ) ∣ 3 ^ j := dvd_pow_self 3 hj0
      have hZ : ((3 ^ j : ℤ) : ZMod 3) = 0 :=
        (ZMod.intCast_zmod_eq_zero_iff_dvd _ 3).mpr (by exact_mod_cast hdvd)
      simpa using hZ
    rw [hz]; exact chi3_zero
  · intro h
    simp at h

lemma chi3_mul (a b : ℤ) :
    quadraticChar (ZMod 3) (a * b) = quadraticChar (ZMod 3) a * quadraticChar (ZMod 3) b := by
  push_cast
  exact chi3_mul_zmod (a : ZMod 3) (b : ZMod 3)

lemma divisorSumChi3_mul {m n : ℕ} (hmn : Nat.Coprime m n) :
    divisorSumChi3 (m * n) = divisorSumChi3 m * divisorSumChi3 n := by
  unfold divisorSumChi3
  rw [hmn.divisors_mul]
  rw [Finset.sum_map]
  let f : ℕ × ℕ → ℤ := fun q => quadraticChar (ZMod 3) ((q.1 * q.2 : ℕ) : ZMod 3)
  change (∑ p ∈ (m.divisors ×ˢ n.divisors).attach, f ↑p) = _
  rw [Finset.sum_attach]
  rw [Finset.sum_product]
  have h : ∀ x ∈ m.divisors, ∀ y ∈ n.divisors,
      quadraticChar (ZMod 3) ((x * y : ℕ) : ZMod 3) =
        quadraticChar (ZMod 3) (x : ZMod 3) * quadraticChar (ZMod 3) (y : ZMod 3) := by
    intro x _ y _
    simpa using chi3_mul (x : ℤ) (y : ℤ)
  calc (∑ x ∈ m.divisors, ∑ y ∈ n.divisors, quadraticChar (ZMod 3) ((x * y : ℕ) : ZMod 3))
      = ∑ x ∈ m.divisors, (quadraticChar (ZMod 3) (x : ZMod 3) *
          ∑ y ∈ n.divisors, quadraticChar (ZMod 3) (y : ZMod 3)) := by
        apply Finset.sum_congr rfl
        intro x hx
        rw [Finset.sum_congr rfl (fun y hy => h x hx y hy), Finset.mul_sum]
    _ = (∑ x ∈ m.divisors, quadraticChar (ZMod 3) (x : ZMod 3)) *
          (∑ y ∈ n.divisors, quadraticChar (ZMod 3) (y : ZMod 3)) := by
        rw [Finset.sum_mul]

/-! ## The `ArithmeticFunction` assembly -/

def idealCountFunThree : ArithmeticFunction ℤ where
  toFun n := if n = 0 then 0 else (idealCountThree n : ℤ)
  map_zero' := by simp

def divisorSumFunThree : ArithmeticFunction ℤ where
  toFun := divisorSumChi3
  map_zero' := by simp [divisorSumChi3]

lemma idealCountThree_one : idealCountThree 1 = 1 := by
  unfold idealCountThree
  rw [Nat.card_eq_one_iff_unique]
  constructor
  · apply Subsingleton.intro
    intro I J
    apply Subtype.ext
    rw [Ideal.absNorm_eq_one_iff.mp I.2, Ideal.absNorm_eq_one_iff.mp J.2]
  · exact ⟨⟨⊤, by rw [Ideal.absNorm_top]⟩⟩

lemma idealCountFunThree_isMultiplicative : idealCountFunThree.IsMultiplicative := by
  constructor
  · simp [idealCountFunThree, idealCountThree_one]
  · intro m n hmn
    by_cases hm : m = 0
    · subst hm; simp [idealCountFunThree]
    · by_cases hn : n = 0
      · subst hn; simp [idealCountFunThree]
      · have hmn0 : m * n ≠ 0 := Nat.mul_ne_zero hm hn
        simp only [idealCountFunThree, ArithmeticFunction.coe_mk, idealCountThree, hm, hn, hmn0,
          if_false]
        change (Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = m * n} : ℤ) =
          (Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = m} : ℤ) *
            (Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = n} : ℤ)
        rw [idealCountThree_mul hm hn hmn]
        push_cast
        ring

lemma divisorSumFunThree_isMultiplicative : divisorSumFunThree.IsMultiplicative := by
  constructor
  · simp [divisorSumFunThree, divisorSumChi3]
  · intro m n hmn
    simpa [divisorSumFunThree] using divisorSumChi3_mul hmn

lemma idealCountThree_prime_pow_eq (p i : ℕ) (hp : p.Prime) :
    idealCountFunThree (p ^ i) = divisorSumFunThree (p ^ i) := by
  have hpi : p ^ i ≠ 0 := pow_ne_zero i hp.ne_zero
  simp only [idealCountFunThree, divisorSumFunThree, ArithmeticFunction.coe_mk, hpi, if_false,
    idealCountThree]
  rcases eq_or_ne p 3 with h3 | h3
  · subst h3
    rw [ramified_ideal_count_three i, divisorSumChi3_three i]
    norm_num
  · have hmod : p % 3 = 1 ∨ p % 3 = 2 := by
      have hne0 : p % 3 ≠ 0 := by
        intro h0
        have hdvd : 3 ∣ p := Nat.dvd_of_mod_eq_zero h0
        rcases hp.eq_one_or_self_of_dvd 3 hdvd with h1 | h1
        · omega
        · exact h3 h1.symm
      omega
    letI : Fact p.Prime := ⟨hp⟩
    rcases hmod with h | h
    · rw [split_ideal_count_three p i h, divisorSumChi3_split h i]
      norm_num
    · have hI : Nat.card {I : Ideal EisensteinInt // Ideal.absNorm I = p ^ i} =
          if Even i then 1 else 0 := by
        by_cases hi : Even i
        · obtain ⟨k, hk⟩ := hi
          rw [hk, show k + k = 2 * k by ring, inert_ideal_count_even_three p k h]
          simp
        · rw [Nat.not_even_iff_odd] at hi
          obtain ⟨k, hk⟩ := hi
          rw [hk, inert_ideal_count_odd_three p k h]
          simp
      have hD : divisorSumChi3 (p ^ i) = if Even i then 1 else 0 := divisorSumChi3_inert h i
      rw [hI, hD]
      split_ifs <;> norm_num

/-- The ideal-count formula for `ℤ[ω]`. -/
theorem idealCountThreeFormula (n : ℕ) (hn : 1 ≤ n) :
    (idealCountThree n : ℤ) = divisorSumChi3 n := by
  have hfun : idealCountFunThree = divisorSumFunThree :=
    (ArithmeticFunction.IsMultiplicative.eq_iff_eq_on_prime_powers idealCountFunThree
      idealCountFunThree_isMultiplicative divisorSumFunThree
      divisorSumFunThree_isMultiplicative).mpr
      (fun p i hp => idealCountThree_prime_pow_eq p i hp)
  have hn0 : n ≠ 0 := by omega
  have h := congrArg (fun f : ArithmeticFunction ℤ => f n) hfun
  simpa [idealCountFunThree, idealCountThree, divisorSumFunThree, ArithmeticFunction.coe_mk, hn0,
    if_false] using h

/-- **The representation formula for the Eisenstein norm form:**
`r_{x²−xy+y²}(n) = 6 Σ_{d|n} χ₃(d)`. -/
theorem rThree_formula (n : ℕ) (hn : 1 ≤ n) :
    Nat.card (NormElementsThree n) = 6 * idealCountThree n :=
  normElementsThree_card_eq_six_mul_idealCount n (by omega)

theorem idealCountThree_eq_divisorSum (n : ℕ) (hn : 1 ≤ n) :
    idealCountThree n = (divisorSumChi3 n).toNat := by
  have h := idealCountThreeFormula n hn
  rw [← h]
  simp

end EisensteinInt

namespace EisensteinInt

/-! ## Closed forms -/

/-- **The ideal count of `ℤ[ω]`, closed form.** -/
theorem idealCountThree_closed (n : ℕ) (hn : 1 ≤ n) :
    (idealCountThree n : ℤ) = ∑ d ∈ n.divisors, quadraticChar (ZMod 3) (d : ZMod 3) := by
  rw [idealCountThreeFormula n hn]
  simp [divisorSumChi3]

/-- **The Eisenstein norm-form representation count, closed form:**
`r(n) = 6 Σ_{d|n} χ₃(d)`. -/
theorem rThree_closed (n : ℕ) (hn : 1 ≤ n) :
    (Nat.card (NormElementsThree n) : ℤ) =
      6 * ∑ d ∈ n.divisors, quadraticChar (ZMod 3) (d : ZMod 3) := by
  have h1 : (Nat.card (NormElementsThree n) : ℤ) = 6 * (idealCountThree n : ℤ) := by
    rw [rThree_formula n hn]
    push_cast
    ring
  rw [h1, idealCountThreeFormula n hn]
  simp [divisorSumChi3]

end EisensteinInt
