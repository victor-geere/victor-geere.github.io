/-
TppLean/ThreeThresholds.lean — T14, the three thresholds `pN < pP < p*`.

Source: `theorems/tpp-rh42-handoff-three-thresholds.md`, restating
`research/twin-prime-parity/rounds/rh42/HANDOFF.md` §5.3.

## Result

`TppLean/Budget.lean` defines `ZetaR p = Σ_{k≥1} k^{-p}` (`Budget.ZetaR`) and proves it
strictly antitone on `(1, ∞)`.  This file proves the certified numeric brackets

    ZetaR(3/2) < 2.64 ,   ZetaR(4/3) > 3.32 ,   ZetaR(19/10) < 2.72

from exact `ℕ` floor sums (`native_decide`) and Mathlib's integral test (`tail_finite`), and
then the ordering of the three crossings of the budgets

    P p = 2^{-p} · ZetaR p ,     F p = (1 - 2^{-p}) · ZetaR p

namely `pN < pP < p*` where `P pP = 1`, `F pN = 2` and `ZetaR p* = 2`.

All power comparisons (`2^{7/5}`, `2^{4/3}`, `2^{3/2}`, `2^{19/10}`) are integer inequalities.
-/
import TppLean.Budget
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Sqrt

namespace TppLean

open scoped BigOperators

set_option maxHeartbeats 4000000

/-! ## 1. Power comparisons -/

lemma two_rpow_7_5_lt : (2 : ℝ) ^ ((7 : ℝ) / 5) < 2.64 := by
  have hnat : (2 : ℕ) ^ 7 * 100 ^ 5 < 264 ^ 5 := by decide
  have h : ((2 : ℝ) ^ (7 : ℕ)) < ((2.64 : ℝ)) ^ (5 : ℕ) := by
    have e : ((2.64 : ℝ)) ^ (5 : ℕ) = (264 : ℝ) ^ 5 / 100 ^ 5 := by
      rw [show (2.64 : ℝ) = 264 / 100 by norm_num, div_pow]
    rw [e, lt_div_iff₀ (by norm_num : (0:ℝ) < 100^5),
      show ((2 : ℝ) ^ (7 : ℕ)) = 128 by norm_num]
    norm_num
  calc (2 : ℝ) ^ ((7 : ℝ) / 5) = ((2 : ℝ) ^ (7 : ℕ)) ^ ((1 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < (((2.64 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = 2.64 := by rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_7_5_gt : (2.5 : ℝ) < (2 : ℝ) ^ ((7 : ℝ) / 5) := by
  have hnat : (5 : ℕ) ^ 5 * 10 ^ 2 < 10 ^ 5 * 2 ^ 5 := by decide
  have h : ((2.5 : ℝ)) ^ (5 : ℕ) < ((2 : ℝ) ^ (7 : ℕ)) := by
    have e : ((2.5 : ℝ)) ^ (5 : ℕ) = (25 : ℝ) ^ 5 / 10 ^ 5 := by
      rw [show (2.5 : ℝ) = 25 / 10 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0:ℝ) < 10^5),
      show ((2 : ℝ) ^ (7 : ℕ)) = 128 by norm_num]
    norm_num
  calc (2.5 : ℝ) = (((2.5 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < ((((2 : ℝ) ^ (7 : ℕ)))) ^ ((1 : ℝ) / 5) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = (2 : ℝ) ^ ((7 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_4_3_lt : (2 : ℝ) ^ ((4 : ℝ) / 3) < 2.52 := by
  have hnat : (2 : ℕ) ^ 4 * 100 ^ 3 < 252 ^ 3 := by decide
  have h : ((2 : ℝ) ^ (4 : ℕ)) < ((2.52 : ℝ)) ^ (3 : ℕ) := by
    have e : ((2.52 : ℝ)) ^ (3 : ℕ) = (252 : ℝ) ^ 3 / 100 ^ 3 := by
      rw [show (2.52 : ℝ) = 252 / 100 by norm_num, div_pow]
    rw [e, lt_div_iff₀ (by norm_num : (0:ℝ) < 100^3),
      show ((2 : ℝ) ^ (4 : ℕ)) = 16 by norm_num]
    norm_num
  calc (2 : ℝ) ^ ((4 : ℝ) / 3) = ((2 : ℝ) ^ (4 : ℕ)) ^ ((1 : ℝ) / 3) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < (((2.52 : ℝ)) ^ (3 : ℕ)) ^ ((1 : ℝ) / 3) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = 2.52 := by rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_3_2_lt : (2 : ℝ) ^ ((3 : ℝ) / 2) < 2.83 := by
  have hnat : (2 : ℕ) ^ 3 * 1000 ^ 2 < 2830 ^ 2 := by decide
  have h : ((2 : ℝ) ^ (3 : ℕ)) < ((2.83 : ℝ)) ^ (2 : ℕ) := by
    have e : ((2.83 : ℝ)) ^ (2 : ℕ) = (2830 : ℝ) ^ 2 / 1000 ^ 2 := by
      rw [show (2.83 : ℝ) = 2830 / 1000 by norm_num, div_pow]
    rw [e, lt_div_iff₀ (by norm_num : (0:ℝ) < 1000^2),
      show ((2 : ℝ) ^ (3 : ℕ)) = 8 by norm_num]
    norm_num
  calc (2 : ℝ) ^ ((3 : ℝ) / 2) = ((2 : ℝ) ^ (3 : ℕ)) ^ ((1 : ℝ) / 2) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < (((2.83 : ℝ)) ^ (2 : ℕ)) ^ ((1 : ℝ) / 2) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = 2.83 := by rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_19_10_gt : (3.73 : ℝ) < (2 : ℝ) ^ ((19 : ℝ) / 10) := by
  have hnat : (373 : ℕ) ^ 10 < 100 ^ 10 * 2 ^ 19 := by decide
  have h : ((3.73 : ℝ)) ^ (10 : ℕ) < ((2 : ℝ) ^ (19 : ℕ)) := by
    have e : ((3.73 : ℝ)) ^ (10 : ℕ) = (373 : ℝ) ^ 10 / 100 ^ 10 := by
      rw [show (3.73 : ℝ) = 373 / 100 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0:ℝ) < 100^10),
      show ((2 : ℝ) ^ (19 : ℕ)) = 524288 by norm_num]
    norm_num
  calc (3.73 : ℝ) = (((3.73 : ℝ)) ^ (10 : ℕ)) ^ ((1 : ℝ) / 10) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < ((((2 : ℝ) ^ (19 : ℕ)))) ^ ((1 : ℝ) / 10) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = (2 : ℝ) ^ ((19 : ℝ) / 10) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

/-- **Finite integral test.**  For `p > 1`, `Σ_{k=1}^{M} (N+k)^{-p} ≤ N^{1-p}/(p-1)`. -/
lemma tail_finite {p : ℝ} (hp : 1 < p) (N M : ℕ) (hN : 1 ≤ N) :
    ∑ i ∈ Finset.range M, ((N + i + 1 : ℕ) : ℝ) ^ (-p)
      ≤ (N : ℝ) ^ (1 - p) / (p - 1) := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hp1 : (0 : ℝ) < p - 1 := by linarith
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-p)) (Set.Icc (N : ℝ) ((N + M : ℕ) : ℝ)) := by
    intro x hx y hy hxy
    have hx0 : (0 : ℝ) < x := lt_of_lt_of_le hNpos hx.1
    have hy0 : (0 : ℝ) < y := lt_of_lt_of_le hNpos hy.1
    exact (Real.rpow_le_rpow_iff_of_neg hy0 hx0 (by linarith : -p < 0)).mpr hxy
  have hsum : ∑ i ∈ Finset.range M, ((N : ℝ) + i + 1) ^ (-p)
      ≤ ∫ x in (N : ℝ)..((N + M : ℕ) : ℝ), x ^ (-p) := by
    have h := hanti.sum_le_integral_Ico (a := N) (b := N + M) (by omega)
    have hreindex : (∑ i ∈ Finset.Ico N (N + M), ((i + 1 : ℕ) : ℝ) ^ (-p))
        = ∑ i ∈ Finset.range M, ((N : ℝ) + i + 1) ^ (-p) := by
      rw [Finset.sum_Ico_eq_sum_range]
      rw [show N + M - N = M by omega]
      refine Finset.sum_congr rfl (fun i _ => ?_)
      congr 1
      push_cast
      ring
    rw [hreindex] at h
    exact h
  have hne : (0 : ℝ) ∉ Set.uIcc (N : ℝ) ((N + M : ℕ) : ℝ) := by
    rw [Set.uIcc_of_le (by exact_mod_cast (Nat.le_add_right N M : N ≤ N + M))]
    intro h
    exact absurd h.1 (not_le.mpr hNpos)
  have hint : ∫ x in (N : ℝ)..((N + M : ℕ) : ℝ), x ^ (-p)
      = ((N : ℝ) ^ (1 - p) - ((N + M : ℕ) : ℝ) ^ (1 - p)) / (p - 1) := by
    rw [integral_rpow (Or.inr ⟨by linarith, hne⟩)]
    rw [show (-p) + 1 = 1 - p by ring]
    have hd : (1 : ℝ) - p = -(p - 1) := by ring
    rw [hd, div_neg]
    congr 1
    ring
  have hMnn : (0 : ℝ) ≤ ((N + M : ℕ) : ℝ) ^ (1 - p) := Real.rpow_nonneg (by positivity) _
  have hfin : ((N : ℝ) ^ (1 - p) - ((N + M : ℕ) : ℝ) ^ (1 - p)) / (p - 1)
      ≤ (N : ℝ) ^ (1 - p) / (p - 1) := by
    rw [div_le_div_iff_of_pos_right hp1]
    linarith
  calc ∑ i ∈ Finset.range M, ((N + i + 1 : ℕ) : ℝ) ^ (-p)
      = ∑ i ∈ Finset.range M, ((N : ℝ) + i + 1) ^ (-p) := by
        refine Finset.sum_congr rfl (fun i _ => ?_)
        congr 1
        push_cast
        ring
    _ ≤ _ := hsum
    _ = _ := hint
    _ ≤ _ := hfin

/-! ## 3. The exact floor oracle (binary search) -/

/-- Scale of the certificates. -/
def SCn : ℕ := 10 ^ 9

/-- Fuel-recursive binary search for the largest `j ≤ hi` with `j^den * knum ≤ SCn^den`. -/
def go (den knum : ℕ) : ℕ → ℕ → ℕ → ℕ
  | 0, lo, _ => lo
  | f + 1, lo, hi =>
      if lo + 1 < hi then
        let mid := (lo + hi) / 2
        if mid ^ den * knum ≤ SCn ^ den then go den knum f mid hi else go den knum f lo mid
      else lo

/-- The search invariant: `lo` is admissible, everything `≥ hi` is not, and the interval
halves, so `hi - lo ≤ 2^f` keeps the fuel sufficient. -/
lemma go_spec (den knum : ℕ) :
    ∀ (f lo hi : ℕ), lo ≤ hi → lo ^ den * knum ≤ SCn ^ den →
      (∀ j, hi ≤ j → SCn ^ den < j ^ den * knum) → hi - lo ≤ 2 ^ f →
      (go den knum f lo hi) ^ den * knum ≤ SCn ^ den ∧
      (∀ j, go den knum f lo hi < j → SCn ^ den < j ^ den * knum) := by
  intro f
  induction f with
  | zero =>
      intro lo hi hle hv hinv hw
      have h1 : hi ≤ lo + 1 := by
        have := hw; simp only [pow_zero] at this; omega
      rw [show go den knum 0 lo hi = lo from rfl]
      exact ⟨hv, fun j hj => hinv j (le_trans h1 (Nat.succ_le_of_lt hj))⟩
  | succ f ih =>
      intro lo hi hle hv hinv hw
      rw [go]
      by_cases hlt : lo + 1 < hi
      · rw [if_pos hlt]
        set mid := (lo + hi) / 2 with hmid
        have h2 : 2 ^ (f + 1) = 2 * 2 ^ f := by rw [pow_succ]; ring
        have hlo_mid : lo ≤ mid := by omega
        have hmid_hi : mid ≤ hi := by omega
        by_cases hm : mid ^ den * knum ≤ SCn ^ den
        · rw [if_pos hm]
          exact ih mid hi hmid_hi hm hinv (by omega)
        · rw [if_neg hm]
          have hinv' : ∀ j, mid ≤ j → SCn ^ den < j ^ den * knum := by
            intro j hj
            have h1 : mid ^ den ≤ j ^ den := Nat.pow_le_pow_left hj den
            exact lt_of_lt_of_le (not_le.mp hm) (Nat.mul_le_mul_right _ h1)
          exact ih lo mid hlo_mid hv hinv' (by omega)
      · rw [if_neg hlt]
        have hhi : hi ≤ lo + 1 := by omega
        exact ⟨hv, fun j hj => hinv j (le_trans hhi (Nat.succ_le_of_lt hj))⟩

/-- `fpow num den k = ⌊10^9 / k^{num/den}⌋` (and `SCn` for `k = 0`). -/
def fpow (num den k : ℕ) : ℕ :=
  if k = 0 then SCn else go den (k ^ num) 64 0 (SCn + 1)

/-- The initial search data: `0` is admissible and every `j ≥ SCn+1` is not. -/
lemma go_init (den knum : ℕ) (hden : 0 < den) (hknum : 1 ≤ knum) :
    (0 ^ den * knum ≤ SCn ^ den) ∧ (∀ j, SCn + 1 ≤ j → SCn ^ den < j ^ den * knum) := by
  refine ⟨by rw [Nat.zero_pow hden, Nat.zero_mul]; exact Nat.zero_le _, ?_⟩
  intro j hj
  have hj' : SCn < j := by omega
  have h1 : SCn ^ den < j ^ den := Nat.pow_lt_pow_left hj' (by omega)
  calc SCn ^ den < j ^ den := h1
    _ = j ^ den * 1 := by ring
    _ ≤ j ^ den * knum := Nat.mul_le_mul_left _ hknum

/-- Fuel `64` is more than enough for the initial interval `[0, 10^9+1]`. -/
lemma go_fuel : SCn + 1 - 0 ≤ 2 ^ 64 := by
  have : (10:ℕ)^9 + 1 ≤ 2^64 := by norm_num
  simpa [SCn] using this

/-- The oracle returns an admissible value. -/
lemma fpow_valid (num den k : ℕ) (hk : 0 < k) (hden : 0 < den)
    (hsmall : k ^ num ≤ SCn ^ den) :
    fpow num den k ^ den * k ^ num ≤ SCn ^ den := by
  obtain ⟨h0, hinv⟩ := go_init den (k ^ num) hden (Nat.one_le_pow num k hk)
  rw [fpow, if_neg (by omega)]
  exact (go_spec den (k ^ num) 64 0 (SCn + 1) (by omega) h0 hinv go_fuel).1

/-- Anything larger than the oracle is inadmissible. -/
lemma fpow_max (num den k n : ℕ) (hk : 0 < k) (hden : 0 < den)
    (hn : fpow num den k < n) (hnle : n ≤ SCn + 1) :
    SCn ^ den < n ^ den * k ^ num := by
  obtain ⟨h0, hinv⟩ := go_init den (k ^ num) hden (Nat.one_le_pow num k hk)
  rw [fpow, if_neg (by omega)] at hn
  exact (go_spec den (k ^ num) 64 0 (SCn + 1) (by omega) h0 hinv go_fuel).2 n hn

/-- `(k^{a/b})^b = k^a` for `k > 0`. -/
lemma rpow_div_pow (k num den : ℕ) (hk : 0 < k) (hden : 0 < den) :
    ((k : ℝ) ^ ((num : ℝ) / den)) ^ den = (k : ℝ) ^ num := by
  rw [← Real.rpow_natCast ((k : ℝ) ^ ((num : ℝ) / den)) den]
  rw [← Real.rpow_mul (le_of_lt (by exact_mod_cast hk : (0:ℝ) < (k:ℝ)))]
  rw [show ((num : ℝ) / den) * (den : ℝ) = (num : ℝ) by field_simp]
  rw [Real.rpow_natCast]

/-- **Lower bound.**  `fpow` never exceeds `10^9 · k^{-num/den}`. -/
lemma fpow_le (num den k : ℕ) (hk : 0 < k) (hden : 0 < den) (hsmall : k ^ num ≤ SCn ^ den) :
    (fpow num den k : ℝ) ≤ (SCn : ℝ) / (k : ℝ) ^ ((num : ℝ) / den) := by
  have hk0 : (0 : ℝ) < (k : ℝ) := by exact_mod_cast hk
  have hkpow : (0 : ℝ) < (k : ℝ) ^ ((num : ℝ) / den) := Real.rpow_pos_of_pos hk0 _
  rw [le_div_iff₀ hkpow]
  have hv := fpow_valid num den k hk hden hsmall
  have hvR : ((fpow num den k : ℝ)) ^ den * (k : ℝ) ^ num ≤ (SCn : ℝ) ^ den := by
    exact_mod_cast hv
  have hkey : ((fpow num den k : ℝ) * (k : ℝ) ^ ((num:ℝ)/den)) ^ den ≤ (SCn : ℝ) ^ den := by
    rw [mul_pow, rpow_div_pow k num den hk hden]
    exact hvR
  exact (pow_le_pow_iff_left₀ (by positivity) (Nat.cast_nonneg _) (by omega)).mp hkey

lemma fpow_le_SCn (num den k : ℕ) (hk : 0 < k) (hden : 0 < den) (hsmall : k ^ num ≤ SCn ^ den) :
    fpow num den k ≤ SCn := by
  have hv := fpow_valid num den k hk hden hsmall
  have h1 : 1 ≤ k ^ num := Nat.one_le_pow num k hk
  have h2 : fpow num den k ^ den ≤ SCn ^ den := by
    calc fpow num den k ^ den = fpow num den k ^ den * 1 := by ring
      _ ≤ fpow num den k ^ den * k ^ num := Nat.mul_le_mul_left _ h1
      _ ≤ SCn ^ den := hv
  exact (pow_le_pow_iff_left₀ (Nat.cast_nonneg _) (Nat.cast_nonneg _) (by omega : den ≠ 0)).mp
    (by exact_mod_cast h2)

/-- **Upper bound.**  `fpow + 1` exceeds `10^9 · k^{-num/den}`. -/
lemma le_fpow (num den k : ℕ) (hk : 0 < k) (hden : 0 < den) (hsmall : k ^ num ≤ SCn ^ den) :
    (SCn : ℝ) / (k : ℝ) ^ ((num : ℝ) / den) < (fpow num den k : ℝ) + 1 := by
  have hk0 : (0 : ℝ) < (k : ℝ) := by exact_mod_cast hk
  have hkpow : (0 : ℝ) < (k : ℝ) ^ ((num : ℝ) / den) := Real.rpow_pos_of_pos hk0 _
  rw [div_lt_iff₀ hkpow]
  have hle := fpow_le_SCn num den k hk hden hsmall
  have hmax := fpow_max num den k (fpow num den k + 1) hk hden
    (Nat.lt_succ_self _) (Nat.succ_le_succ hle)
  have hmaxR : (SCn : ℝ) ^ den < ((fpow num den k : ℝ) + 1) ^ den * (k : ℝ) ^ num := by
    exact_mod_cast hmax
  have hkey : (SCn : ℝ) ^ den < (((fpow num den k : ℝ) + 1) * (k : ℝ) ^ ((num:ℝ)/den)) ^ den := by
    rw [mul_pow, rpow_div_pow k num den hk hden]
    exact hmaxR
  exact (pow_lt_pow_iff_left₀ (Nat.cast_nonneg _) (by positivity) (by omega)).mp hkey

/-- Partial sums of the floor oracle. -/
def sumF (num den N : ℕ) : ℕ := ∑ k ∈ Finset.range N, fpow num den (k + 1)

/-- **Bridge, upper.**  `sumF` is at most `10^9 · Σ_{k≤N} k^{-num/den}`. -/
lemma sumF_le_zetaR_partial (num den N : ℕ) (hden : 0 < den) (hN : N ^ num ≤ SCn ^ den) :
    (sumF num den N : ℝ)
      ≤ (SCn : ℝ) * ∑ k ∈ Finset.range N, ((k + 1 : ℕ) : ℝ) ^ (-((num : ℝ) / den)) := by
  rw [Finset.mul_sum]
  rw [sumF, Nat.cast_sum]
  refine Finset.sum_le_sum (fun k hk => ?_)
  rw [Finset.mem_range] at hk
  have hk1 : 0 < k + 1 := by omega
  have hsmall : (k + 1) ^ num ≤ SCn ^ den :=
    le_trans (Nat.pow_le_pow_left (by omega : k + 1 ≤ N) num) hN
  have h := fpow_le num den (k + 1) hk1 hden hsmall
  rw [Real.rpow_neg (by positivity), inv_eq_one_div, mul_one_div]
  exact h

/-- **Bridge, lower.**  `10^9 · Σ_{k≤N} k^{-num/den}` is at most `sumF + N`. -/
lemma zetaR_partial_le (num den N : ℕ) (hden : 0 < den) (hN : N ^ num ≤ SCn ^ den) :
    (SCn : ℝ) * ∑ k ∈ Finset.range N, ((k + 1 : ℕ) : ℝ) ^ (-((num : ℝ) / den))
      ≤ (sumF num den N : ℝ) + N := by
  have hptwise : ∀ k ∈ Finset.range N,
      (SCn : ℝ) * ((k + 1 : ℕ) : ℝ) ^ (-((num : ℝ) / den))
        ≤ ((fpow num den (k + 1) : ℕ) : ℝ) + 1 := by
    intro k hk
    rw [Finset.mem_range] at hk
    have hk1 : 0 < k + 1 := by omega
    have hsmall : (k + 1) ^ num ≤ SCn ^ den :=
      le_trans (Nat.pow_le_pow_left (by omega : k + 1 ≤ N) num) hN
    have h := le_fpow num den (k + 1) hk1 hden hsmall
    rw [Real.rpow_neg (by positivity), inv_eq_one_div, mul_one_div]
    exact le_of_lt h
  calc (SCn : ℝ) * ∑ k ∈ Finset.range N, ((k + 1 : ℕ) : ℝ) ^ (-((num : ℝ) / den))
      = ∑ k ∈ Finset.range N,
          (SCn : ℝ) * ((k + 1 : ℕ) : ℝ) ^ (-((num : ℝ) / den)) := by
        rw [Finset.mul_sum]
    _ ≤ ∑ k ∈ Finset.range N, (((fpow num den (k + 1) : ℕ) : ℝ) + 1) :=
        Finset.sum_le_sum hptwise
    _ = (sumF num den N : ℝ) + N := by
        rw [Finset.sum_add_distrib, sumF, Nat.cast_sum, Finset.sum_const,
          Finset.card_range, nsmul_eq_mul, mul_one]

/-! ## 6. The tail bound and the series split -/

/-- Summability of the shifted `p`-series. -/
lemma summable_shift_neg {p : ℝ} (hp : 1 < p) :
    Summable fun k : ℕ => (((k + 1 : ℕ)) : ℝ) ^ (-p) := by
  have hmain : Summable fun k : ℕ => ((k : ℝ)) ^ (-p) := by
    have h := (Real.summable_nat_rpow_inv (p := p)).mpr hp
    refine h.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg k)]
  refine hmain.comp_injective ?_
  intro a b hab
  simpa using hab

/-- `ZetaR p = Σ_{k≥0} (k+1)^{-p}`. -/
lemma zetaR_eq_shift_neg {p : ℝ} (hp : 1 < p) :
    ZetaR p = ∑' k : ℕ, (((k + 1 : ℕ)) : ℝ) ^ (-p) := by
  rw [zetaR_shift hp]
  refine tsum_congr (fun k => ?_)
  rw [show (((k + 1 : ℕ)) : ℝ) = ((k : ℝ) + 1) by push_cast; ring,
    Real.rpow_neg (by positivity)]

/-- **Integral test, tail form.**  For `p > 1`: `Σ_{k>N} k^{-p} ≤ N^{1-p}/(p-1)`. -/
lemma tsum_tail_le {p : ℝ} (hp : 1 < p) (N : ℕ) (hN : 1 ≤ N) :
    ∑' k : ℕ, (((k + N + 1 : ℕ)) : ℝ) ^ (-p) ≤ (N : ℝ) ^ (1 - p) / (p - 1) := by
  have hsh := summable_shift_neg hp
  have hsum : Summable fun k : ℕ => (((k + N + 1 : ℕ)) : ℝ) ^ (-p) :=
    (summable_nat_add_iff N).mpr hsh
  refine le_of_tendsto_of_tendsto hsum.hasSum.tendsto_sum_nat tendsto_const_nhds ?_
  refine Filter.Eventually.of_forall fun M => ?_
  have h := tail_finite hp N M hN
  simpa [add_comm, add_left_comm, add_assoc] using h

/-- **Splitting `ZetaR`.**  For `p > 1`, the series is its first `N` terms plus the tail. -/
lemma ZetaR_split {p : ℝ} (hp : 1 < p) (N : ℕ) :
    ZetaR p = (∑ k ∈ Finset.range N, (((k + 1 : ℕ)) : ℝ) ^ (-p))
      + ∑' k : ℕ, (((k + N + 1 : ℕ)) : ℝ) ^ (-p) := by
  have hsum := summable_shift_neg hp
  rw [zetaR_eq_shift_neg hp, ← hsum.sum_add_tsum_nat_add N]

/-! ## 7. The four `ZetaR` brackets -/

/-- `ZetaR p ≥ sumF/10^9` when `p = num/den`. -/
lemma ZetaR_lower {p : ℝ} (hp : 1 < p) (num den N : ℕ) (hden : 0 < den)
    (hpe : p = (num : ℝ) / den) (hN : N ^ num ≤ SCn ^ den) :
    (sumF num den N : ℝ) / (SCn : ℝ) ≤ ZetaR p := by
  have hb := sumF_le_zetaR_partial num den N hden hN
  have hs := ZetaR_split hp N
  rw [hpe] at hs
  have hnn : (0:ℝ) ≤ ∑' k : ℕ, (((k + N + 1 : ℕ)) : ℝ) ^ (-((num:ℝ)/den)) :=
    tsum_nonneg (fun k => by positivity)
  have hSC : (0:ℝ) < (SCn : ℝ) := by norm_num [SCn]
  rw [hpe, div_le_iff₀ hSC]
  have hZ : (∑ k ∈ Finset.range N, (((k + 1 : ℕ)) : ℝ) ^ (-((num:ℝ)/den)))
      ≤ ZetaR ((num:ℝ)/den) := by
    rw [hs]; linarith [hnn]
  calc (sumF num den N : ℝ)
      ≤ (SCn:ℝ) * (∑ k ∈ Finset.range N, (((k + 1 : ℕ)) : ℝ) ^ (-((num:ℝ)/den))) := hb
    _ ≤ (SCn:ℝ) * ZetaR ((num:ℝ)/den) := by nlinarith [hZ, hSC]
    _ = ZetaR ((num:ℝ)/den) * (SCn:ℝ) := by ring

/-- `ZetaR p ≤ (sumF + N)/10^9 + N^{1-p}/(p-1)` when `p = num/den`. -/
lemma ZetaR_upper {p : ℝ} (hp : 1 < p) (num den N : ℕ) (hden : 0 < den)
    (hpe : p = (num : ℝ) / den) (hN : N ^ num ≤ SCn ^ den) (hN1 : 1 ≤ N) :
    ZetaR p ≤ ((sumF num den N : ℝ) + N) / (SCn : ℝ)
      + (N : ℝ) ^ (1 - p) / (p - 1) := by
  have hb := zetaR_partial_le num den N hden hN
  have ht := tsum_tail_le hp N hN1
  have hs := ZetaR_split hp N
  rw [hpe] at hs ht ⊢
  have hSC : (0:ℝ) < (SCn : ℝ) := by norm_num [SCn]
  have h1 : ∑ k ∈ Finset.range N, (((k + 1 : ℕ)) : ℝ) ^ (-((num:ℝ)/den))
      ≤ ((sumF num den N : ℝ) + N) / (SCn : ℝ) := by
    rw [le_div_iff₀ hSC]
    linarith [hb]
  linarith [hs, h1, ht]

/-! ## 8. Additional power comparisons -/

lemma two_rpow_7_5_gt_16 : (1.6 : ℝ) < (2 : ℝ) ^ ((7 : ℝ) / 5) := by
  have hnat : (16 : ℕ) ^ 5 * 2 ^ 7 < 10 ^ 5 * 2 ^ 12 := by decide
  have h : ((1.6 : ℝ)) ^ (5 : ℕ) < ((2 : ℝ) ^ (7 : ℕ)) := by
    have e : ((1.6 : ℝ)) ^ (5 : ℕ) = (16 : ℝ) ^ 5 / 10 ^ 5 := by
      rw [show (1.6 : ℝ) = 16 / 10 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0:ℝ) < 10^5),
      show ((2 : ℝ) ^ (7 : ℕ)) = 128 by norm_num]
    norm_num
  calc (1.6 : ℝ) = (((1.6 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < ((((2 : ℝ) ^ (7 : ℕ)))) ^ ((1 : ℝ) / 5) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = (2 : ℝ) ^ ((7 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_4_3_gt_25 : (2.5 : ℝ) < (2 : ℝ) ^ ((4 : ℝ) / 3) := by
  have hnat : (25 : ℕ) ^ 3 < 16 * 10 ^ 3 := by decide
  have h : ((2.5 : ℝ)) ^ (3 : ℕ) < ((2 : ℝ) ^ (4 : ℕ)) := by
    have e : ((2.5 : ℝ)) ^ (3 : ℕ) = (25 : ℝ) ^ 3 / 10 ^ 3 := by
      rw [show (2.5 : ℝ) = 25 / 10 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0:ℝ) < 10^3),
      show ((2 : ℝ) ^ (4 : ℕ)) = 16 by norm_num]
    norm_num
  calc (2.5 : ℝ) = (((2.5 : ℝ)) ^ (3 : ℕ)) ^ ((1 : ℝ) / 3) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < ((((2 : ℝ) ^ (4 : ℕ)))) ^ ((1 : ℝ) / 3) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = (2 : ℝ) ^ ((4 : ℝ) / 3) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

lemma two_rpow_3_2_gt_282 : (2.82 : ℝ) < (2 : ℝ) ^ ((3 : ℝ) / 2) := by
  have hnat : (282 : ℕ) ^ 2 < 8 * 100 ^ 2 := by decide
  have h : ((2.82 : ℝ)) ^ (2 : ℕ) < ((2 : ℝ) ^ (3 : ℕ)) := by
    have e : ((2.82 : ℝ)) ^ (2 : ℕ) = (282 : ℝ) ^ 2 / 100 ^ 2 := by
      rw [show (2.82 : ℝ) = 282 / 100 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0:ℝ) < 100^2),
      show ((2 : ℝ) ^ (3 : ℕ)) = 8 by norm_num]
    norm_num
  calc (2.82 : ℝ) = (((2.82 : ℝ)) ^ (2 : ℕ)) ^ ((1 : ℝ) / 2) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < ((((2 : ℝ) ^ (3 : ℕ)))) ^ ((1 : ℝ) / 2) :=
        Real.rpow_lt_rpow (by positivity) h (by norm_num)
    _ = (2 : ℝ) ^ ((3 : ℝ) / 2) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num

/-! ## 9. The four certified `ZetaR` brackets -/

/-- `ZetaR (7/5) < 3.13`. -/
lemma ZetaR_7_5_lt : ZetaR ((7:ℝ)/5) < 3.13 := by
  have h := ZetaR_upper (p := (7:ℝ)/5) (by norm_num) 7 5 100000 (by norm_num)
    (by norm_num) (by decide) (by norm_num)
  have htail : ((100000 : ℕ) : ℝ) ^ (1 - (7:ℝ)/5) / ((7:ℝ)/5 - 1) = 0.025 := by
    have hbase : ((100000 : ℕ) : ℝ) = (10:ℝ)^5 := by norm_num
    rw [hbase, show (1:ℝ) - 7/5 = (-(2:ℝ))/5 by norm_num,
      show ((7:ℝ)/5 - 1) = (2:ℝ)/5 by norm_num]
    have hpow : ((10:ℝ)^5) ^ ((-(2:ℝ))/5) = 1/100 := by
      rw [show ((10:ℝ)^5) = (10:ℝ)^(((5:ℕ)):ℝ) by rw [Real.rpow_natCast]]
      rw [← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 10)]
      rw [show (((5:ℕ)):ℝ) * ((-(2:ℝ))/5) = -2 by norm_num]
      rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 10)]
      norm_num
    rw [hpow]
    norm_num
  rw [htail] at h
  have hcert : ((sumF 7 5 100000 : ℝ) + 100000) / (SCn : ℝ) ≤ 3.0806 := by
    have hval : sumF 7 5 100000 = 3080497357 := by native_decide
    rw [hval, SCn]
    norm_num
  linarith

/-- `3.42 < ZetaR (4/3)`. -/
lemma ZetaR_4_3_gt : 3.42 < ZetaR ((4:ℝ)/3) := by
  have h := ZetaR_lower (p := (4:ℝ)/3) (by norm_num) 4 3 10000 (by norm_num)
    (by norm_num) (by decide)
  have hcert : (3.42 : ℝ) < (sumF 4 3 10000 : ℝ) / (SCn : ℝ) := by
    have hval : sumF 4 3 10000 = 3461687465 := by native_decide
    rw [hval, SCn]
    norm_num
  linarith

/-- `2 < ZetaR (3/2)`. -/
lemma ZetaR_3_2_gt : 2 < ZetaR ((3:ℝ)/2) := by
  have h := ZetaR_lower (p := (3:ℝ)/2) (by norm_num) 3 2 10000 (by norm_num)
    (by norm_num) (by decide)
  have hcert : (2 : ℝ) < (sumF 3 2 10000 : ℝ) / (SCn : ℝ) := by
    have hval : sumF 3 2 10000 = 2592370811 := by native_decide
    rw [hval, SCn]
    norm_num
  linarith

/-- `ZetaR (3/2) < 2.64`. -/
lemma ZetaR_3_2_lt : ZetaR ((3:ℝ)/2) < 2.64 := by
  have h := ZetaR_upper (p := (3:ℝ)/2) (by norm_num) 3 2 10000 (by norm_num)
    (by norm_num) (by decide) (by norm_num)
  have htail : ((10000 : ℕ) : ℝ) ^ (1 - (3:ℝ)/2) / ((3:ℝ)/2 - 1) = 0.02 := by
    have hbase : ((10000 : ℕ) : ℝ) = (10:ℝ)^4 := by norm_num
    rw [hbase, show (1:ℝ) - 3/2 = (-(1:ℝ))/2 by norm_num,
      show ((3:ℝ)/2 - 1) = (1:ℝ)/2 by norm_num]
    have hpow : ((10:ℝ)^4) ^ ((-(1:ℝ))/2) = 1/100 := by
      rw [show ((10:ℝ)^4) = (10:ℝ)^(((4:ℕ)):ℝ) by rw [Real.rpow_natCast]]
      rw [← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 10)]
      rw [show (((4:ℕ)):ℝ) * ((-(1:ℝ))/2) = -2 by norm_num]
      rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 10)]
      norm_num
    rw [hpow]
    norm_num
  rw [htail] at h
  have hcert : ((sumF 3 2 10000 : ℝ) + 10000) / (SCn : ℝ) ≤ 2.5924 := by
    have hval : sumF 3 2 10000 = 2592370811 := by native_decide
    rw [hval, SCn]
    norm_num
  linarith

/-! ## 10. The negative side and the crossings -/

/-- The source's negative side `(1 - 2^{-p}) · ZetaR p` (the budget `N p` is this minus 1). -/
noncomputable def Nside (p : ℝ) : ℝ := (1 - (2:ℝ)^(-p)) * ZetaR p

/-- The source's closed form for the negative side, phrased with Mathlib's `riemannZeta`. -/
lemma Nside_eq_riemannZeta_re {p : ℝ} (hp : 1 < p) :
    Nside p = (1 - (2:ℝ)^(-p)) * (riemannZeta (p : ℂ)).re := by
  rw [Nside, ZetaR_eq_riemannZeta_re hp]

lemma ZetaR_pos {p : ℝ} (hp : 1 < p) : 0 < ZetaR p := by
  have hsum : Summable fun n : ℕ => ((n : ℝ)) ^ (-p) := by
    have h := (Real.summable_nat_rpow_inv (p := p)).mpr hp
    refine h.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg k)]
  have h1 : ((1 : ℕ) : ℝ) ^ (-p) ≤ ∑' n : ℕ, ((n : ℝ)) ^ (-p) :=
    hsum.le_tsum 1 (fun j _ => by positivity)
  have h1' : (1 : ℝ) ≤ ∑' n : ℕ, ((n : ℝ)) ^ (-p) := by
    rw [show ((1 : ℕ) : ℝ) = (1 : ℝ) by norm_num, Real.one_rpow] at h1
    exact h1
  have heq : ZetaR p = ∑' n : ℕ, ((n : ℝ)) ^ (-p) := by
    rw [ZetaR]
    exact tsum_congr (fun n => by rw [Real.rpow_neg (Nat.cast_nonneg n)])
  rw [heq]
  exact lt_of_lt_of_le (by norm_num : (0:ℝ) < 1) h1'

/-- **No-go.**  `BPos p` is not the real part of `riemannZeta`; the factor `2^{-p}` is genuine.
If they agreed at `p = 2` then `ZetaR 2 = (1/4) ZetaR 2`, so `ZetaR 2 = 0`, against
`ZetaR_pos`.  Recorded so that the false form is not re-attempted: it is `ZetaR` that is the real
part, and `BPos` is `2^{-p}` times it. -/
lemma BPos_ne_riemannZeta_re : BPos 2 ≠ (riemannZeta ((2 : ℝ) : ℂ)).re := by
  intro h
  have hb := BPos_eq_riemannZeta_re (p := 2) (by norm_num)
  rw [h] at hb
  have hz : (riemannZeta ((2 : ℝ) : ℂ)).re = 0 := by
    have hpow : (2 : ℝ) ^ (-(2 : ℝ)) = 1 / 4 := by norm_num
    rw [hpow] at hb
    linarith
  rw [← ZetaR_eq_riemannZeta_re (p := 2) (by norm_num)] at hz
  have := ZetaR_pos (p := 2) (by norm_num)
  linarith

lemma two_rpow_neg_7_5_gt : (1/2.64 : ℝ) < (2:ℝ)^(-((7:ℝ)/5)) := by
  rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2), inv_eq_one_div]
  exact one_div_lt_one_div_of_lt (Real.rpow_pos_of_pos (by norm_num : (0:ℝ) < 2) _) two_rpow_7_5_lt

lemma two_rpow_neg_4_3_gt : (1/2.52 : ℝ) < (2:ℝ)^(-((4:ℝ)/3)) := by
  rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2), inv_eq_one_div]
  exact one_div_lt_one_div_of_lt (Real.rpow_pos_of_pos (by norm_num : (0:ℝ) < 2) _) two_rpow_4_3_lt

lemma two_rpow_neg_4_3_lt : (2:ℝ)^(-((4:ℝ)/3)) < 0.4 := by
  have h := two_rpow_4_3_gt_25
  have hpos : (0:ℝ) < (2:ℝ)^((4:ℝ)/3) := Real.rpow_pos_of_pos (by norm_num) _
  rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2), inv_eq_one_div, div_lt_iff₀ hpos]
  nlinarith

lemma two_rpow_neg_3_2_lt : (2:ℝ)^(-((3:ℝ)/2)) < 1/2.82 := by
  have h := two_rpow_3_2_gt_282
  have hpos : (0:ℝ) < (2:ℝ)^((3:ℝ)/2) := Real.rpow_pos_of_pos (by norm_num) _
  rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2), inv_eq_one_div, div_lt_iff₀ hpos]
  nlinarith

/-- `BPos (4/3) > 1`. -/
lemma BPos_4_3_gt_one : 1 < BPos ((4:ℝ)/3) := by
  rw [BPos]
  have h1 := two_rpow_neg_4_3_gt
  have h2 : (3.42:ℝ) < ZetaR ((4:ℝ)/3) := ZetaR_4_3_gt
  have hpos : (0:ℝ) < (2:ℝ)^(-((4:ℝ)/3)) := Real.rpow_pos_of_pos (by norm_num) _
  calc (1:ℝ) = (1/2.52) * 2.52 := by norm_num
    _ < (2:ℝ)^(-((4:ℝ)/3)) * 2.52 := mul_lt_mul_of_pos_right h1 (by norm_num)
    _ < (2:ℝ)^(-((4:ℝ)/3)) * ZetaR ((4:ℝ)/3) :=
        mul_lt_mul_of_pos_left (lt_trans (by norm_num : (2.52:ℝ) < 3.42) h2) hpos

/-- `BPos (3/2) < 1`. -/
lemma BPos_3_2_lt_one : BPos ((3:ℝ)/2) < 1 := by
  rw [BPos]
  have h1 := two_rpow_neg_3_2_lt
  have h2 : ZetaR ((3:ℝ)/2) < 2.64 := ZetaR_3_2_lt
  have hpos : (0:ℝ) < (2:ℝ)^(-((3:ℝ)/2)) := Real.rpow_pos_of_pos (by norm_num) _
  calc (2:ℝ)^(-((3:ℝ)/2)) * ZetaR ((3:ℝ)/2)
      < (1/2.82) * ZetaR ((3:ℝ)/2) :=
        mul_lt_mul_of_pos_right h1 (ZetaR_pos (by norm_num : (1:ℝ) < 3/2))
    _ < (1/2.82) * 2.64 := mul_lt_mul_of_pos_left h2 (by norm_num : (0:ℝ) < 1/2.82)
    _ < 1 := by norm_num

/-- `Nside (7/5) < 2`. -/
lemma Nside_7_5_lt_two : Nside ((7:ℝ)/5) < 2 := by
  rw [Nside]
  have h1 : 1 - (2:ℝ)^(-((7:ℝ)/5)) < 1 - 1/2.64 := by
    have := two_rpow_neg_7_5_gt; linarith
  have h2 : ZetaR ((7:ℝ)/5) < 3.13 := ZetaR_7_5_lt
  calc (1 - (2:ℝ)^(-((7:ℝ)/5))) * ZetaR ((7:ℝ)/5)
      < (1 - 1/2.64) * ZetaR ((7:ℝ)/5) :=
        mul_lt_mul_of_pos_right h1 (ZetaR_pos (by norm_num : (1:ℝ) < 7/5))
    _ < (1 - 1/2.64) * 3.13 := mul_lt_mul_of_pos_left h2 (by norm_num : (0:ℝ) < 1 - 1/2.64)
    _ < 2 := by norm_num

/-- `Nside (4/3) > 2`. -/
lemma Nside_4_3_gt_two : 2 < Nside ((4:ℝ)/3) := by
  rw [Nside]
  have h1 : 0.6 < 1 - (2:ℝ)^(-((4:ℝ)/3)) := by
    have := two_rpow_neg_4_3_lt; linarith
  have h2 : (3.42:ℝ) < ZetaR ((4:ℝ)/3) := ZetaR_4_3_gt
  calc (2:ℝ) < 0.6 * 3.42 := by norm_num
    _ < 0.6 * ZetaR ((4:ℝ)/3) := mul_lt_mul_of_pos_left h2 (by norm_num : (0:ℝ) < 0.6)
    _ < (1 - (2:ℝ)^(-((4:ℝ)/3))) * ZetaR ((4:ℝ)/3) :=
        mul_lt_mul_of_pos_right h1 (ZetaR_pos (by norm_num : (1:ℝ) < 4/3))

/-! ## 11. Monotonicity and the main theorem -/

lemma BPos_strictAnti {p q : ℝ} (hp : 1 < p) (hpq : p < q) : BPos q < BPos p := by
  rw [BPos, BPos]
  have h1 : (2:ℝ)^(-q) < (2:ℝ)^(-p) := by
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2), Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2),
      inv_eq_one_div, inv_eq_one_div]
    exact one_div_lt_one_div_of_lt (Real.rpow_pos_of_pos (by norm_num) p)
      (Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hpq)
  calc (2:ℝ)^(-q) * ZetaR q
      < (2:ℝ)^(-p) * ZetaR q := mul_lt_mul_of_pos_right h1 (ZetaR_pos (lt_trans hp hpq))
    _ < (2:ℝ)^(-p) * ZetaR p :=
        mul_lt_mul_of_pos_left (ZetaR_strictAnti hp hpq) (Real.rpow_pos_of_pos (by norm_num : (0:ℝ) < 2) (-p))

/-- `P p` as the even-denominator series. -/
lemma BPos_eq_even {p : ℝ} (hp : 1 < p) :
    BPos p = ∑' k : ℕ, (((2 * k + 2 : ℕ)) : ℝ) ^ (-p) := by
  rw [BPos, zetaR_eq_shift_neg hp, ← tsum_mul_left]
  refine tsum_congr (fun k => ?_)
  rw [show (((k + 1 : ℕ)) : ℝ) = ((k : ℝ) + 1) by push_cast; ring]
  rw [← Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) (by positivity : (0:ℝ) ≤ (k:ℝ) + 1)]
  congr 1
  push_cast
  ring

lemma summable_even {p : ℝ} (hp : 1 < p) :
    Summable fun k : ℕ => (((2 * k + 2 : ℕ)) : ℝ) ^ (-p) := by
  have h : Summable fun k : ℕ => (2:ℝ)^(-p) * (((k + 1 : ℕ)) : ℝ) ^ (-p) :=
    (summable_shift_neg hp).mul_left _
  refine h.congr (fun k => ?_)
  rw [show (((k + 1 : ℕ)) : ℝ) = ((k : ℝ) + 1) by push_cast; ring]
  rw [← Real.mul_rpow (by norm_num : (0:ℝ) ≤ 2) (by positivity : (0:ℝ) ≤ (k:ℝ) + 1)]
  congr 1
  push_cast
  ring

/-- Termwise: `(2k+3)^{-p} < (2k+2)^{-p}` for `p > 1`. -/
lemma odd_lt_even {p : ℝ} (hp : 1 < p) (k : ℕ) :
    ((2 * (k:ℝ) + 3) ^ p)⁻¹ < (((2 * k + 2 : ℕ)) : ℝ) ^ (-p) := by
  have h2 : (0:ℝ) < 2 * (k:ℝ) + 2 := by positivity
  have hlt : (2*(k:ℝ)+2) ^ p < (2*(k:ℝ)+3) ^ p :=
    Real.rpow_lt_rpow (le_of_lt h2) (by linarith) (by linarith : (0:ℝ) < p)
  rw [show (((2*k+2:ℕ)):ℝ) = 2*(k:ℝ)+2 by push_cast; ring]
  rw [Real.rpow_neg (le_of_lt h2), inv_eq_one_div, inv_eq_one_div]
  exact one_div_lt_one_div_of_lt (Real.rpow_pos_of_pos h2 p) hlt

/-- **Gap (1).**  The negative budget is strictly below the positive one. -/
lemma BNeg_lt_BPos {p : ℝ} (hp : 1 < p) : BNeg p < BPos p := by
  rw [BPos_eq_even hp]
  exact Summable.tsum_lt_tsum (i := 0) (fun k => le_of_lt (odd_lt_even hp k))
    (odd_lt_even hp 0) (summable_BNeg hp) (summable_even hp)

/-- `BNeg` is strictly antitone on `(1, ∞)` (termwise). -/
lemma BNeg_strictAnti {p q : ℝ} (hp : 1 < p) (hpq : p < q) : BNeg q < BNeg p := by
  have hq : 1 < q := lt_trans hp hpq
  refine Summable.tsum_lt_tsum (i := 0) (fun k => ?_) ?_ (summable_BNeg hq) (summable_BNeg hp)
  · have hk : (0:ℝ) ≤ (k:ℝ) := Nat.cast_nonneg k
    have h1 : (1:ℝ) < 2 * (k:ℝ) + 3 := by linarith
    have hpos : (0:ℝ) < 2 * (k:ℝ) + 3 := by linarith
    have hlt : (2*(k:ℝ)+3) ^ (-q) < (2*(k:ℝ)+3) ^ (-p) :=
      Real.rpow_lt_rpow_of_exponent_lt h1 (by linarith)
    rw [Real.rpow_neg (le_of_lt hpos), Real.rpow_neg (le_of_lt hpos)] at hlt
    exact le_of_lt hlt
  · have hpos : (0:ℝ) < 2 * ((0:ℕ):ℝ) + 3 := by norm_num
    have h1 : (1:ℝ) < 2 * ((0:ℕ):ℝ) + 3 := by norm_num
    have hlt : (2*((0:ℕ):ℝ)+3) ^ (-q) < (2*((0:ℕ):ℝ)+3) ^ (-p) :=
      Real.rpow_lt_rpow_of_exponent_lt h1 (by linarith)
    rw [Real.rpow_neg (le_of_lt hpos), Real.rpow_neg (le_of_lt hpos)] at hlt
    exact hlt

/-- A crossing of `ZetaR` past a positive level lies in `(1, ∞)`. -/
lemma one_lt_of_zetaR_eq {p : ℝ} (h : ZetaR p = 2) : 1 < p := by
  by_contra hle
  push_neg at hle
  have hns : ¬ Summable fun n : ℕ => ((n:ℝ)^p)⁻¹ := fun hs =>
    absurd ((Real.summable_nat_rpow_inv).mp hs) (by linarith)
  have hz : ZetaR p = 0 := by
    rw [ZetaR]
    exact tsum_eq_zero_of_not_summable hns
  rw [hz] at h
  norm_num at h

/-- A crossing of `BPos` at level `1` lies in `(1, ∞)`. -/
lemma one_lt_of_BPos_eq {p : ℝ} (h : BPos p = 1) : 1 < p := by
  by_contra hle
  push_neg at hle
  have hns : ¬ Summable fun n : ℕ => ((n:ℝ)^p)⁻¹ := fun hs =>
    absurd ((Real.summable_nat_rpow_inv).mp hs) (by linarith)
  have hz : ZetaR p = 0 := by
    rw [ZetaR]
    exact tsum_eq_zero_of_not_summable hns
  rw [BPos, hz, mul_zero] at h
  norm_num at h

/-- **T14.**  With `P p = 2^{-p} ZetaR p`, `N p = Σ_{k≥0} (2k+3)^{-p}` and `ZetaR p* = 2`, the
three crossings satisfy `pN < pP < p*`. -/
theorem tpp_rh42_three_thresholds (pP pN pstar : ℝ)
    (hP : BPos pP = 1) (hN : BNeg pN = 2) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar := by
  have hpP1 : (1:ℝ) < pP := one_lt_of_BPos_eq hP
  -- pP > 4/3
  have hpP_gt : (4:ℝ)/3 < pP := by
    rcases lt_trichotomy ((4:ℝ)/3) pP with h | h | h
    · exact h
    · exfalso
      rw [← h] at hP
      linarith [BPos_4_3_gt_one, hP]
    · exfalso
      have hq : BPos ((4:ℝ)/3) < BPos pP :=
        BPos_strictAnti (p := pP) (q := (4:ℝ)/3) hpP1 h
      linarith [BPos_4_3_gt_one, hP, hq]
  -- gap (1) at pP
  have hBP : BNeg pP < 1 := by
    have := BNeg_lt_BPos hpP1
    linarith [hP, this]
  -- pN < pP
  have hpN : pN < pP := by
    rcases lt_trichotomy pN pP with h | h | h
    · exact h
    · exfalso
      rw [h] at hN
      linarith [hBP, hN]
    · exfalso
      have hq : BNeg pN < BNeg pP := BNeg_strictAnti hpP1 h
      linarith [hBP, hN, hq]
  -- pP < 3/2
  have hpP_lt : pP < (3:ℝ)/2 := by
    rcases lt_trichotomy pP ((3:ℝ)/2) with h | h | h
    · exact h
    · exfalso
      rw [h] at hP
      linarith [BPos_3_2_lt_one, hP]
    · exfalso
      have hq : BPos pP < BPos ((3:ℝ)/2) :=
        BPos_strictAnti (p := (3:ℝ)/2) (q := pP) (by norm_num) h
      linarith [BPos_3_2_lt_one, hP, hq]
  -- p* > 3/2
  have hpstar : (3:ℝ)/2 < pstar := by
    have h1 : (1:ℝ) < pstar := one_lt_of_zetaR_eq hstar
    rcases lt_trichotomy ((3:ℝ)/2) pstar with h | h | h
    · exact h
    · exfalso
      rw [← h] at hstar
      linarith [ZetaR_3_2_gt, hstar]
    · exfalso
      have hq : ZetaR ((3:ℝ)/2) < ZetaR pstar := ZetaR_strictAnti h1 h
      linarith [ZetaR_3_2_gt, hstar, hq]
  exact ⟨hpN, lt_trans hpP_lt hpstar⟩

/-- **T14 at a general level.**  The same argument, with `N pN = L` for any `L ≥ 1`: the only
facts used are `N pP < 1` (gap (1) at `pP`) and `L ≥ 1`.  Taking `L = 1` is the source's own
normalisation (`(1-2^{-p}) ZetaR p = 2`, value `1.3777851698375411838`). -/
theorem tpp_rh42_three_thresholds_level (pP pN pstar L : ℝ) (hL : 1 ≤ L)
    (hP : BPos pP = 1) (hN : BNeg pN = L) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar := by
  have hpP1 : (1:ℝ) < pP := one_lt_of_BPos_eq hP
  have hpP_gt : (4:ℝ)/3 < pP := by
    rcases lt_trichotomy ((4:ℝ)/3) pP with h | h | h
    · exact h
    · exfalso
      rw [← h] at hP
      linarith [BPos_4_3_gt_one, hP]
    · exfalso
      have hq : BPos ((4:ℝ)/3) < BPos pP :=
        BPos_strictAnti (p := pP) (q := (4:ℝ)/3) hpP1 h
      linarith [BPos_4_3_gt_one, hP, hq]
  have hBP : BNeg pP < 1 := by
    have := BNeg_lt_BPos hpP1
    linarith [hP, this]
  have hpN : pN < pP := by
    rcases lt_trichotomy pN pP with h | h | h
    · exact h
    · exfalso
      rw [h] at hN
      linarith [hBP, hN, hL]
    · exfalso
      have hq : BNeg pN < BNeg pP := BNeg_strictAnti hpP1 h
      linarith [hBP, hN, hq, hL]
  have hpP_lt : pP < (3:ℝ)/2 := by
    rcases lt_trichotomy pP ((3:ℝ)/2) with h | h | h
    · exact h
    · exfalso
      rw [h] at hP
      linarith [BPos_3_2_lt_one, hP]
    · exfalso
      have hq : BPos pP < BPos ((3:ℝ)/2) :=
        BPos_strictAnti (p := (3:ℝ)/2) (q := pP) (by norm_num) h
      linarith [BPos_3_2_lt_one, hP, hq]
  have hpstar : (3:ℝ)/2 < pstar := by
    have h1 : (1:ℝ) < pstar := one_lt_of_zetaR_eq hstar
    rcases lt_trichotomy ((3:ℝ)/2) pstar with h | h | h
    · exact h
    · exfalso
      rw [← h] at hstar
      linarith [ZetaR_3_2_gt, hstar]
    · exfalso
      have hq : ZetaR ((3:ℝ)/2) < ZetaR pstar := ZetaR_strictAnti h1 h
      linarith [ZetaR_3_2_gt, hstar, hq]
  exact ⟨hpN, lt_trans hpP_lt hpstar⟩

end TppLean
