import Mathlib
import GaussianGram

/-!
# W3 — the prime term at `σ = 1/20`

This file encloses the prime term

```
primeTerm c (1/20) = −2 Σ_{n} Λ(n)/√n · √π/20 · exp(−100 (log n − c)²)
```

in rational intervals. At `σ = 1/20` the sum is carried by `n = 2`; for `n ≥ 3`
the Gaussian factor is below `exp(−14 log n)`, so the summand is dominated by
`(√π/20)·n⁻¹³` and the whole tail is below `2.51·10⁻⁷`.

## Proved

* `gaussianBump_inv20` — the bump at `σ = 1/20`;
* `primeSummand`, `primeTerm_eq_inv20` — the summand and the definition;
* `log_ge_one_of_three_le`, `exp_decay_le` — `exp(−100(x−c)²) ≤ exp(−14x)` for
  `x ≥ 1`, `c ≤ 3/5`;
* `exp_neg_log_pow`, `primeSummand_le` — `primeSummand c n ≤ (√π/20)·n⁻¹³`;
* `tele2`, `tele2_sub`, `sum_tele2`, `primeSummand_le_tail`,
  `prime_sum_range_tail_le`, `sum_tail_le`, `sum_tail_le_rat` — the tail bound
  `Σ_{n≥3} primeSummand c n ≤ (√π/20)·3⁻¹¹/2 ≤ 2.51·10⁻⁷`;
* `vonMangoldt_two`, `log_two_mem`, `sqrt_two_mem`, `sqrt_pi_mem`,
  `primeSummand_two`, `prime_sum_split` — the `n = 2` term and the split of the
  full sum;
* `primeTerm_mem_small` — for `c ≤ 2/5`,
  `−2.2·10⁻⁵ ≤ primeTerm c (1/20) ≤ 0`;
* `primeTerm_mem_three_fifths` — at `c = 3/5`,
  `−0.036490 ≤ primeTerm (3/5) (1/20) ≤ −0.03646`
  (the true value is `−0.036481…`).

Everything is rational arithmetic plus `Real.exp_bound`, `Real.log_le_log`,
`Real.log_le_sub_one_of_pos`, `vonMangoldt_le_log`, `Real.tsum_le_of_sum_range_le`
and monotonicity of `exp`.

## Not here

The **density** term — the archimedean integral `(1/400)∫ exp(−t²/400)cos(ct)Ω`
— is not enclosed. It is R2 of [`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4 and
is the only remaining obstruction to O4.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-! ## The summand -/

/-- The Gaussian bump at `σ = 1/20`: `√π/20 · exp(−100 (v − c)²)`. -/
theorem gaussianBump_inv20 (c v : ℝ) :
    gaussianBump c (1 / 20) v = Real.sqrt Real.pi / 20 * Real.exp (-100 * (v - c) ^ 2) := by
  unfold gaussianBump
  have h4 : (4 : ℝ) * (1 / 20) ^ 2 = 1 / 100 := by norm_num
  rw [h4]
  have harg : -((v - c) ^ 2) / (1 / 100 : ℝ) = -100 * (v - c) ^ 2 := by ring
  rw [harg]
  ring

/-- The `n`-th summand of the prime term at `σ = 1/20`. -/
def primeSummand (c : ℝ) (n : ℕ) : ℝ :=
  ArithmeticFunction.vonMangoldt n / Real.sqrt n * gaussianBump c (1 / 20) (Real.log n)

theorem primeTerm_eq_inv20 (c : ℝ) :
    primeTerm c (1 / 20) = -2 * ∑' n : ℕ, primeSummand c n := rfl

/-! ## Elementary estimates -/

/-- `1 ≤ log n` for `n ≥ 3`. -/
theorem log_ge_one_of_three_le {n : ℕ} (hn : 3 ≤ n) : 1 ≤ Real.log n := by
  have h3 : (1 : ℝ) ≤ Real.log 3 := by
    rw [Real.le_log_iff_exp_le (by norm_num : (0 : ℝ) < 3)]
    exact le_of_lt Real.exp_one_lt_three
  refine h3.trans (Real.log_le_log (by norm_num) ?_)
  exact_mod_cast hn

/-- For `x ≥ 1` and `|c| ≤ 3/5`, `exp(−100 (x − c)²) ≤ exp(−14 x)`. -/
theorem exp_decay_le {x c : ℝ} (hx1 : 1 ≤ x) (hc : c ≤ 3 / 5) :
    Real.exp (-100 * (x - c) ^ 2) ≤ Real.exp (-14 * x) := by
  have hc' : c ≤ 3 / 5 := hc
  have hsq : (x - 3 / 5) ^ 2 ≤ (x - c) ^ 2 := by
    have h0 : 0 ≤ x - 3 / 5 := by linarith
    nlinarith [h0]
  have hkey : 14 * x ^ 2 ≤ 100 * (x - 3 / 5) ^ 2 := by
    nlinarith [sq_nonneg (x - 1), hx1]
  have hxx : x ≤ x ^ 2 := by nlinarith [hx1]
  have harg : -100 * (x - c) ^ 2 ≤ -14 * x := by nlinarith [hsq, hkey, hxx]
  exact Real.exp_le_exp.mpr harg

/-- `exp(−14 log n) = ((n)¹⁴)⁻¹` for `n > 0`. -/
theorem exp_neg_log_pow (n : ℕ) (hn : 0 < (n : ℝ)) :
    Real.exp (-14 * Real.log n) = (((n : ℝ) ^ 14)⁻¹) := by
  have h1 : Real.exp (-14 * Real.log n) = (n : ℝ) ^ (-14 : ℝ) := by
    rw [Real.rpow_def_of_pos hn]
    congr 1
    ring
  rw [h1, show (-14 : ℝ) = -((14 : ℕ) : ℝ) by norm_num, Real.rpow_neg (le_of_lt hn),
    Real.rpow_natCast]

/-- The pointwise bound `Λ(n)/√n · bump ≤ (√π/20)·n⁻¹³` for `n ≥ 3`, `|c| ≤ 3/5`. -/
theorem primeSummand_le (c : ℝ) (hc : c ≤ 3 / 5) {n : ℕ} (hn : 3 ≤ n) :
    primeSummand c n ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 13)⁻¹) := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hnpos : (0 : ℝ) < n := by
    have : (3 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hΛ0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n :=
    ArithmeticFunction.vonMangoldt_nonneg
  have hΛle : ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
    ArithmeticFunction.vonMangoldt_le_log
  have hlog1 : 1 ≤ Real.log n := log_ge_one_of_three_le hn
  have hsqrt1 : (1 : ℝ) ≤ Real.sqrt n := by
    rw [show (1 : ℝ) = Real.sqrt 1 by simp]
    exact Real.sqrt_le_sqrt (by exact_mod_cast hn.trans' (by norm_num : (1:ℕ) ≤ 3))
  have hcoef : ArithmeticFunction.vonMangoldt n / Real.sqrt n ≤ Real.log n := by
    rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt n)]
    have hb : Real.log n ≤ Real.log n * Real.sqrt n := by
      calc Real.log n = Real.log n * 1 := by ring
        _ ≤ Real.log n * Real.sqrt n :=
            mul_le_mul_of_nonneg_left hsqrt1 (by linarith)
    linarith [hΛle, hb]
  have hexp : Real.exp (-100 * (Real.log n - c) ^ 2) ≤ (((n : ℝ) ^ 14)⁻¹) := by
    have h := exp_decay_le hlog1 hc
    rwa [exp_neg_log_pow n hnpos] at h
  have hS0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n / Real.sqrt n :=
    div_nonneg hΛ0 (by positivity)
  have hlog14 : Real.log n * (((n : ℝ) ^ 14)⁻¹) ≤ (((n : ℝ) ^ 13)⁻¹) := by
    have hkey : (n : ℝ) * (((n : ℝ) ^ 14)⁻¹) = (((n : ℝ) ^ 13)⁻¹) := by
      field_simp
    have hlogle : Real.log n ≤ (n : ℝ) := by
      have h := Real.log_le_sub_one_of_pos hnpos
      linarith
    calc Real.log n * (((n : ℝ) ^ 14)⁻¹)
        ≤ (n : ℝ) * (((n : ℝ) ^ 14)⁻¹) := by
          apply mul_le_mul_of_nonneg_right hlogle (by positivity)
      _ = (((n : ℝ) ^ 13)⁻¹) := hkey
  have h14 : (0 : ℝ) ≤ (((n : ℝ) ^ 14)⁻¹) := by positivity
  calc ArithmeticFunction.vonMangoldt n / Real.sqrt n *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log n - c) ^ 2))
      = (ArithmeticFunction.vonMangoldt n / Real.sqrt n) *
          (Real.sqrt Real.pi / 20) * Real.exp (-100 * (Real.log n - c) ^ 2) := by ring
    _ ≤ Real.log n * (Real.sqrt Real.pi / 20) * (((n : ℝ) ^ 14)⁻¹) := by
        apply mul_le_mul (mul_le_mul hcoef (le_refl _) (by positivity) (by linarith)) hexp
          (by positivity) (by positivity)
    _ = Real.sqrt Real.pi / 20 * (Real.log n * (((n : ℝ) ^ 14)⁻¹)) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 13)⁻¹) := by
        apply mul_le_mul_of_nonneg_left hlog14 (by positivity)

/-! ## The tail bound -/

/-- The telescoping sequence `1/(n+2)`, used to sum the `n⁻²`-dominated tail. -/
def tele2 (n : ℕ) : ℝ := 1 / ((n : ℝ) + 2)

theorem tele2_sub (n : ℕ) :
    tele2 n - tele2 (n + 1) = 1 / (((n : ℝ) + 2) * ((n : ℝ) + 3)) := by
  unfold tele2
  push_cast
  field_simp
  ring

theorem sum_tele2 (N : ℕ) :
    ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) = tele2 0 - tele2 N := by
  induction N with
  | zero => simp
  | succ N ih => rw [Finset.sum_range_succ, ih]; ring

theorem tele2_nonneg (n : ℕ) : 0 ≤ tele2 n := by
  unfold tele2
  positivity

/-- The summand dominates its own `n⁻²`-normalised tail term.

For `m = n + 3 ≥ 3`, `m⁻¹³ = m⁻¹¹·m⁻² ≤ 3⁻¹¹·m⁻² ≤ 3⁻¹¹·(1/((m−1)m))`, and the
last factor telescopes. -/
theorem primeSummand_le_tail (c : ℝ) (hc : c ≤ 3 / 5) (n : ℕ) :
    primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
  have h1 : primeSummand c (n + 3) ≤ Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 13)⁻¹) := by
    have h := primeSummand_le c hc (n := n + 3) (by omega)
    simpa using h
  have hm : (3 : ℝ) ≤ (n : ℝ) + 3 := by
    have : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have h3 : ((((n : ℝ) + 3) ^ 11)⁻¹) ≤ ((3 : ℝ) ^ 11)⁻¹ := by
    rw [inv_eq_one_div, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (pow_le_pow_left₀ (by norm_num) hm 11)
  have hm13 : ((((n : ℝ) + 3) ^ 13)⁻¹) =
      ((((n : ℝ) + 3) ^ 11)⁻¹) * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [← mul_inv]
    congr 1
    ring
  have h2 : ((((n : ℝ) + 3) ^ 13)⁻¹) ≤
      ((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [hm13]
    exact mul_le_mul_of_nonneg_right h3 (by positivity)
  have h4 : ((((n : ℝ) + 3) ^ 2)⁻¹) ≤ tele2 n - tele2 (n + 1) := by
    rw [tele2_sub, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (by nlinarith)
  calc primeSummand c (n + 3) ≤ Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 13)⁻¹) := h1
    _ ≤ Real.sqrt Real.pi / 20 * (((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹)) :=
        mul_le_mul_of_nonneg_left h2 (by positivity)
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) :=
        mul_le_mul_of_nonneg_left h4 (by positivity)

theorem primeSummand_nonneg (c : ℝ) (n : ℕ) : 0 ≤ primeSummand c n := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have h1 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n := ArithmeticFunction.vonMangoldt_nonneg
  have h2 : (0 : ℝ) ≤ Real.sqrt n := Real.sqrt_nonneg n
  have h3 : (0 : ℝ) < Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log n - c) ^ 2) := by
    positivity
  exact mul_nonneg (div_nonneg h1 h2) h3.le

/-- **The prime tail is below `(√π/20)·3⁻¹¹/2 ≈ 8.3·10⁻⁸`.** -/
theorem sum_tail_le (c : ℝ) (hc : c ≤ 3 / 5) :
    ∑' n : ℕ, primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
  refine Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg c (n + 3)) (fun N => ?_)
  calc ∑ n ∈ Finset.range N, primeSummand c (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail c hc n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-! ## The `n = 2` term and the prime-term enclosures -/

theorem vonMangoldt_two : ArithmeticFunction.vonMangoldt 2 = Real.log 2 :=
  ArithmeticFunction.vonMangoldt_apply_prime (by norm_num)

theorem log_two_mem :
    (69314718 / 100000000 : ℝ) ≤ Real.log 2 ∧ Real.log 2 ≤ 69314719 / 100000000 := by
  constructor
  · linarith [Real.log_two_gt_d9]
  · linarith [Real.log_two_lt_d9]

theorem sqrt_two_mem : (14142 / 10000 : ℝ) ≤ Real.sqrt 2 ∧ Real.sqrt 2 ≤ 14143 / 10000 := by
  have h2 : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hnn : (0 : ℝ) ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  constructor <;> nlinarith [h2, hnn]

theorem sqrt_pi_mem :
    (17724 / 10000 : ℝ) ≤ Real.sqrt Real.pi ∧ Real.sqrt Real.pi ≤ 17725 / 10000 := by
  have h2 : Real.sqrt Real.pi ^ 2 = Real.pi := Real.sq_sqrt Real.pi_pos.le
  have hnn : (0 : ℝ) ≤ Real.sqrt Real.pi := Real.sqrt_nonneg _
  constructor <;> nlinarith [h2, hnn, Real.pi_gt_d4, Real.pi_lt_d4]

theorem primeSummand_two (c : ℝ) :
    primeSummand c 2 =
      Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - c) ^ 2)) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_two]
  norm_num

theorem prime_sum_range_tail_le (c : ℝ) (hc : c ≤ 3 / 5) (N : ℕ) :
    ∑ n ∈ Finset.range N, primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
  calc ∑ n ∈ Finset.range N, primeSummand c (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail c hc n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-- The split of the full prime sum into the finite prefix and the tail. -/
theorem prime_sum_split (c : ℝ) (hc : c ≤ 3 / 5) :
    (∑' n : ℕ, primeSummand c n) =
      primeSummand c 2 + ∑' n : ℕ, primeSummand c (n + 3) := by
  have htail : Summable (fun n : ℕ => primeSummand c (n + 3)) :=
    summable_of_sum_range_le (fun n => primeSummand_nonneg c (n + 3))
      (fun N => prime_sum_range_tail_le c hc N)
  have hsum : Summable (fun n : ℕ => primeSummand c n) :=
    (summable_nat_add_iff 3).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 3
  have h0 : primeSummand c 0 = 0 := by
    unfold primeSummand
    simp
  have h1 : primeSummand c 1 = 0 := by
    unfold primeSummand
    simp
  have hprefix : ∑ n ∈ Finset.range 3, primeSummand c n = primeSummand c 2 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hprefix] at hsplit
  linarith [hsplit]

/-- `√π/20 ≤ 8863/10⁵`. -/
theorem sqrt_pi_div_twenty_le : Real.sqrt Real.pi / 20 ≤ 8863 / 100000 := by
  have h := sqrt_pi_mem.2
  linarith

/-- The tail is below `2.51·10⁻⁷`. -/
theorem sum_tail_le_rat (c : ℝ) (hc : c ≤ 3 / 5) :
    ∑' n : ℕ, primeSummand c (n + 3) ≤ 251 / 1000000000 := by
  refine le_trans (sum_tail_le c hc) ?_
  have hB := sqrt_pi_div_twenty_le
  have h1 : Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) ≤
      (8863 / 100000 : ℝ) * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
    apply mul_le_mul_of_nonneg_right _ (by norm_num)
    exact mul_le_mul_of_nonneg_right hB (by positivity)
  refine le_trans h1 ?_
  norm_num

/-- Case `c ≤ 2/5`: the `n = 2` term is below `1.061·10⁻⁵`, so the prime term is
in `[−2.2·10⁻⁵, 0]`. -/
theorem primeTerm_mem_small {c : ℝ} (hc : c ≤ 2 / 5) :
    (-22 / 1000000 : ℝ) ≤ primeTerm c (1 / 20) ∧ primeTerm c (1 / 20) ≤ 0 := by
  have hc3 : c ≤ 3 / 5 := by linarith
  have hsplit := prime_sum_split c hc3
  have htail := sum_tail_le_rat c hc3
  have hnn : 0 ≤ ∑' n : ℕ, primeSummand c n :=
    tsum_nonneg (fun n => primeSummand_nonneg c n)
  -- the Gaussian factor at `n = 2`
  have hE : Real.exp (-100 * (Real.log 2 - c) ^ 2) ≤ 1 / 4096 := by
    have hl := log_two_mem.1
    have hx : (29314718 / 100000000 : ℝ) ≤ Real.log 2 - c := by linarith
    have hx0 : (0 : ℝ) ≤ 29314718 / 100000000 := by norm_num
    have hsq : (29314718 / 100000000 : ℝ) ^ 2 ≤ (Real.log 2 - c) ^ 2 := by
      nlinarith [hx, hx0]
    have he : (8593 / 1000 : ℝ) ≤ 100 * (Real.log 2 - c) ^ 2 := by nlinarith
    have h1 : Real.exp (-100 * (Real.log 2 - c) ^ 2) ≤ Real.exp (-(8593 / 1000)) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : Real.exp (-(8593 / 1000) : ℝ) ≤ 1 / 4096 := by
      have hlog := log_two_mem.2
      have h3 : Real.exp (12 * Real.log 2) ≤ Real.exp (8593 / 1000) :=
        Real.exp_le_exp.mpr (by nlinarith)
      have h4 : Real.exp (12 * Real.log 2) = 4096 := by
        rw [show (12 : ℝ) * Real.log 2 = Real.log 2 * 12 by ring]
        rw [← Real.rpow_def_of_pos (by norm_num : (0 : ℝ) < 2) (12 : ℝ)]
        norm_num
      rw [Real.exp_neg, ← one_div]
      exact one_div_le_one_div_of_le (by positivity) (by linarith [h3, h4])
    linarith [h1, h2]
  have hf2 : primeSummand c 2 ≤ 1061 / 100000000 := by
    rw [primeSummand_two]
    have hA : Real.log 2 / Real.sqrt 2 ≤ 4902 / 10000 := by
      have hl := log_two_mem.2
      have hs := sqrt_two_mem.1
      rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt 2)]
      nlinarith [hl, hs]
    have hA0 : (0 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
      apply div_nonneg (by linarith [log_two_mem.1]) (by positivity)
    have hB := sqrt_pi_div_twenty_le
    calc Real.log 2 / Real.sqrt 2 *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - c) ^ 2))
        ≤ (4902 / 10000 : ℝ) * ((8863 / 100000 : ℝ) * (1 / 4096)) := by
          apply mul_le_mul hA ?_ (by positivity) (by linarith)
          exact mul_le_mul hB hE (by positivity) (by positivity)
      _ ≤ 1061 / 100000000 := by norm_num
  have hbound : ∑' n : ℕ, primeSummand c n ≤ 11 / 1000000 := by
    rw [hsplit]
    linarith [hf2, htail]
  have hrw : primeTerm c (1 / 20) = -2 * ∑' n : ℕ, primeSummand c n := primeTerm_eq_inv20 c
  constructor
  · rw [hrw]; linarith [hbound]
  · rw [hrw]; linarith [hnn]

theorem sqrt_pi_div_twenty_le_close : Real.sqrt Real.pi / 20 ≤ 88625 / 1000000 := by
  have h := sqrt_pi_mem.2
  linarith

theorem sqrt_pi_div_twenty_ge : (8862 / 100000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by
  have h := sqrt_pi_mem.1
  linarith

/-- Case `c = 3/5`: the `n = 2` term is the whole sum. -/
theorem primeTerm_mem_three_fifths :
    (-36490 / 1000000 : ℝ) ≤ primeTerm (3 / 5) (1 / 20) ∧
      primeTerm (3 / 5) (1 / 20) ≤ -3646 / 100000 := by
  have hc : (3 / 5 : ℝ) ≤ 3 / 5 := le_rfl
  have hsplit := prime_sum_split (3 / 5) hc
  have htail := sum_tail_le_rat (3 / 5) hc
  -- exponent range
  have hxlo : (9314718 / 100000000 : ℝ) ≤ Real.log 2 - 3 / 5 := by
    linarith [log_two_mem.1]
  have hxhi : Real.log 2 - 3 / 5 ≤ 9314719 / 100000000 := by
    linarith [log_two_mem.2]
  have hx0 : (0 : ℝ) ≤ 9314718 / 100000000 := by norm_num
  have hpos : (0 : ℝ) ≤ Real.log 2 - 3 / 5 := by linarith [hxlo]
  have hsqlo : (9314718 / 100000000 : ℝ) ^ 2 ≤ (Real.log 2 - 3 / 5) ^ 2 := by
    rw [pow_two, pow_two]
    exact mul_self_le_mul_self hx0 hxlo
  have hsqhi : (Real.log 2 - 3 / 5) ^ 2 ≤ (9314719 / 100000000 : ℝ) ^ 2 := by
    rw [pow_two, pow_two]
    exact mul_self_le_mul_self hpos hxhi
  have helo : (8676397 / 10000000 : ℝ) ≤ 100 * (Real.log 2 - 3 / 5) ^ 2 := by
    nlinarith [hsqlo]
  have hehi : 100 * (Real.log 2 - 3 / 5) ^ 2 ≤ 86763991 / 100000000 := by
    nlinarith [hsqhi]
  -- exp bounds from the Taylor remainder
  have hexplo : (4199414 / 10000000 : ℝ) ≤ Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) := by
    have h1 : Real.exp (-(86763991 / 100000000 : ℝ)) ≤
        Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : (4199414 / 10000000 : ℝ) ≤ Real.exp (-(86763991 / 100000000 : ℝ)) := by
      have hx : |(-(86763991 / 100000000 : ℝ))| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      linarith [h.1]
    exact le_trans h2 h1
  have hexphi : Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) ≤ (4199417 / 10000000 : ℝ) := by
    have h1 : Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) ≤
        Real.exp (-(8676397 / 10000000 : ℝ)) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : Real.exp (-(8676397 / 10000000 : ℝ)) ≤ (4199417 / 10000000 : ℝ) := by
      have hx : |(-(8676397 / 10000000 : ℝ))| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      linarith [h.2]
    exact le_trans h1 h2
  -- the `n = 2` term
  have hAlo : (4900 / 10000 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [le_div_iff₀ hs]
    have hp : (4900 / 10000 : ℝ) * Real.sqrt 2 ≤ (4900 / 10000) * (14143 / 10000) :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.2 (by norm_num)
    nlinarith [hp, log_two_mem.1]
  have hAhi : Real.log 2 / Real.sqrt 2 ≤ 4902 / 10000 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [div_le_iff₀ hs]
    have hp : (4902 / 10000 : ℝ) * (14142 / 10000) ≤ (4902 / 10000) * Real.sqrt 2 :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.1 (by norm_num)
    nlinarith [hp, log_two_mem.2]
  have hf2lo : (18235 / 1000000 : ℝ) ≤ primeSummand (3 / 5) 2 := by
    rw [primeSummand_two]
    calc (18235 / 1000000 : ℝ) ≤
          (4900 / 10000 : ℝ) * ((8862 / 100000 : ℝ) * (4199414 / 10000000)) := by norm_num
      _ ≤ Real.log 2 / Real.sqrt 2 *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2)) := by
          apply mul_le_mul hAlo ?_ (by norm_num) (by linarith)
          exact mul_le_mul sqrt_pi_div_twenty_ge hexplo (by norm_num) (by positivity)
  have hf2hi : primeSummand (3 / 5) 2 ≤ 18244 / 1000000 := by
    rw [primeSummand_two]
    calc Real.log 2 / Real.sqrt 2 *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2))
        ≤ (4902 / 10000 : ℝ) * ((88625 / 1000000 : ℝ) * (4199417 / 10000000)) := by
          apply mul_le_mul hAhi ?_ (by positivity) (by norm_num)
          exact mul_le_mul sqrt_pi_div_twenty_le_close hexphi (by positivity) (by positivity)
      _ ≤ 18244 / 1000000 := by norm_num
  have htail0 : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (3 / 5) (n + 3) :=
    tsum_nonneg (fun n => primeSummand_nonneg (3 / 5) (n + 3))
  have hupper : ∑' n : ℕ, primeSummand (3 / 5) n ≤
      18244 / 1000000 + 251 / 1000000000 := by
    rw [hsplit]
    linarith [hf2hi, htail]
  have hlower : (18235 / 1000000 : ℝ) ≤ ∑' n : ℕ, primeSummand (3 / 5) n := by
    rw [hsplit]
    linarith [hf2lo, htail0]
  have hrw := primeTerm_eq_inv20 (3 / 5)
  constructor
  · rw [hrw]; linarith [hupper]
  · rw [hrw]; linarith [hlower]

end PrimeSpectrumTensor
