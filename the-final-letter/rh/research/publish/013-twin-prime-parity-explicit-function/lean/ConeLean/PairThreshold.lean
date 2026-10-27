/-
ConeLean/PairThreshold.lean — the radial-pair completeness threshold.

The radial-pair alphabet of the positive half is

    a_k = (4k+2)^{-p} + (4k+4)^{-p}          (the pairs {2,4}, {6,8}, {10,12}, …),

i.e. `P(p) = 2^{-p} ζ(p)` grouped into consecutive radial pairs.  Brown's first
completeness condition `a_0 ≤ Σ_{k≥1} a_k` reads `2 + 2^{1-p} ≤ ζ(p)`, so the
pair-completeness threshold `p_pair` is the root of

    Ψ(p) := ζ(p) - 2 - 2^{1-p} = 0 .

Proved here, with no `sorry`:

* `Psi_strictAnti`  — `Ψ` is strictly decreasing on `[7/5, 8/5]`, from the one-power
  bound (`ConeLean.shiftDiff_le`) applied at `n = 3, 4` against the loss at `n = 2`,
  with the certified constant `log 3·3^{-8/5} + log 4·4^{-8/5} - log 2·2^{-7/5} > 0`;
* `Psi_22_15_gt`, `Psi_3_2_lt`, `BPos_22_15_lt_one` — the certified brackets
  `Ψ(22/15) > 0 > Ψ(3/2)` and `P(22/15) < 1`, through the TppLean floor oracle;
* `Psi_pos_of_lt_seven_fifths`, `Psi_neg_of_eight_fifths_le` — the two tails, so the
  bracket `7/5 ≤ p_pair ≤ 8/5` is *derived*, not assumed;
* `pair_threshold_between` — **`pP < p_pair < p*`**, unconditionally.
-/
import ConeLean.Cone
import TppLean.ThreeThresholds
import Mathlib.Analysis.Complex.ExponentialBounds

namespace ConeLean

open scoped BigOperators
open TppLean

set_option maxHeartbeats 1000000

noncomputable section

/-! ## 1. The threshold function and its difference form -/

/-- **The pair-greedy threshold function** `Ψ(p) = ζ(p) - 2 - 2^{1-p}`. -/
noncomputable def Psi (p : ℝ) : ℝ := ZetaR p - 2 - (2 : ℝ) ^ (1 - p)

/-- **The difference form.**  For `p, q > 1`,

    Ψ(p) - Ψ(q) = Σ_{k≥0} [ (k+3)^{-p} - (k+3)^{-q} ] - ( 2^{-p} - 2^{-q} ).

The `n = 1` term vanishes and the `n = 2` term cancels half of `2^{1-p} - 2^{1-q}`;
the split is `TppLean.ZetaR_split` at `N = 2`. -/
lemma Psi_sub {p q : ℝ} (hp : 1 < p) (hq : 1 < q) :
    Psi p - Psi q =
      (∑' k : ℕ, ((((k + 3 : ℕ)) : ℝ) ^ (-p) - (((k + 3 : ℕ)) : ℝ) ^ (-q)))
        - ((2 : ℝ) ^ (-p) - (2 : ℝ) ^ (-q)) := by
  have hsp := ZetaR_split hp 2
  have hsq := ZetaR_split hq 2
  have hsum_p : (∑ k ∈ Finset.range 2, (((k + 1 : ℕ)) : ℝ) ^ (-p)) = 1 + (2 : ℝ) ^ (-p) := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
    norm_num
  have hsum_q : (∑ k ∈ Finset.range 2, (((k + 1 : ℕ)) : ℝ) ^ (-q)) = 1 + (2 : ℝ) ^ (-q) := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
    norm_num
  have hp_s : Summable fun k : ℕ => (((k + 3 : ℕ)) : ℝ) ^ (-p) := by
    have h2 : Summable fun k : ℕ => ((((k + 3 : ℕ)) : ℝ) ^ p)⁻¹ :=
      (summable_zetaR hp).comp_injective (fun a b hab => by simpa using hab)
    refine h2.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg (k + 3))]
  have hq_s : Summable fun k : ℕ => (((k + 3 : ℕ)) : ℝ) ^ (-q) := by
    have h2 : Summable fun k : ℕ => ((((k + 3 : ℕ)) : ℝ) ^ q)⁻¹ :=
      (summable_zetaR hq).comp_injective (fun a b hab => by simpa using hab)
    refine h2.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg (k + 3))]
  have hsub : (∑' k : ℕ, (((k + 3 : ℕ)) : ℝ) ^ (-p)) - (∑' k : ℕ, (((k + 3 : ℕ)) : ℝ) ^ (-q))
      = ∑' k : ℕ, ((((k + 3 : ℕ)) : ℝ) ^ (-p) - (((k + 3 : ℕ)) : ℝ) ^ (-q)) :=
    (Summable.tsum_sub hp_s hq_s).symm
  have h2p : (2 : ℝ) ^ (1 - p) = 2 * (2 : ℝ) ^ (-p) := by
    rw [show (1 : ℝ) - p = 1 + (-p) by ring, Real.rpow_add (by norm_num), Real.rpow_one]
  have h2q : (2 : ℝ) ^ (1 - q) = 2 * (2 : ℝ) ^ (-q) := by
    rw [show (1 : ℝ) - q = 1 + (-q) by ring, Real.rpow_add (by norm_num), Real.rpow_one]
  rw [Psi, Psi, hsp, hsq, hsum_p, hsum_q, h2p, h2q, ← hsub]
  ring

/-! ## 2. The one-power bounds -/

/-- Derivative of `t ↦ n^{-t}` for `n > 0`. -/
lemma hasDerivAt_rpow_neg (n : ℝ) (hn : 0 < n) (t : ℝ) :
    HasDerivAt (fun s : ℝ => n ^ (-s)) (-(Real.log n) * n ^ (-t)) t := by
  have hfun : (fun s : ℝ => n ^ (-s)) = fun s : ℝ => Real.exp (Real.log n * (-s)) := by
    funext s
    rw [Real.rpow_def_of_pos hn]
  have h1 : HasDerivAt (fun s : ℝ => Real.log n * (-s)) (Real.log n * (-1)) t :=
    (hasDerivAt_neg t).const_mul (Real.log n)
  have h2 := h1.exp
  rw [hfun]
  convert h2 using 1
  rw [Real.rpow_def_of_pos hn]
  ring

/-- **One-power lower bound**: `n^{-p} - n^{-q} ≥ (q-p) log n · n^{-8/5}` for `n ≥ 2`,
`0 < p < q ≤ 8/5`.  (The fencing theorem with the boundary `n^{-p} - L(t-p)`.) -/
lemma rpow_sub_lower {n : ℕ} (hn : 2 ≤ n) {p q : ℝ} (hpq : p < q) (hq : q ≤ 8 / 5) :
    (q - p) * Real.log n * ((n : ℝ)) ^ (-(8 / 5 : ℝ))
      ≤ ((n : ℝ)) ^ (-p) - ((n : ℝ)) ^ (-q) := by
  have hn1 : (1 : ℝ) < (n : ℝ) := by exact_mod_cast (by omega : 1 < n)
  have hn0 : (0 : ℝ) < (n : ℝ) := lt_trans zero_lt_one hn1
  have hlog : 0 ≤ Real.log n := le_of_lt (Real.log_pos hn1)
  set L : ℝ := Real.log n * ((n : ℝ)) ^ (-(8 / 5 : ℝ)) with hL
  have hderiv : ∀ t ∈ Set.Ico p q, HasDerivWithinAt (fun s : ℝ => ((n : ℝ)) ^ (-s))
      (-(Real.log n) * ((n : ℝ)) ^ (-t)) (Set.Ici t) t :=
    fun t _ => (hasDerivAt_rpow_neg (n : ℝ) hn0 t).hasDerivWithinAt
  have hB : ∀ t : ℝ, HasDerivAt (fun s : ℝ => ((n : ℝ)) ^ (-p) - L * (s - p)) (-L) t := by
    intro t
    have h1 : HasDerivAt (fun s : ℝ => s - p) 1 t := (hasDerivAt_id t).sub_const p
    have h2 : HasDerivAt (fun s : ℝ => L * (s - p)) (L * 1) t := h1.const_mul L
    have h3 : HasDerivAt (fun s : ℝ => ((n : ℝ)) ^ (-p) - L * (s - p)) (0 - L * 1) t :=
      (hasDerivAt_const t (((n : ℝ)) ^ (-p))).sub h2
    simpa using h3
  have hbound : ∀ t ∈ Set.Ico p q, (-(Real.log n) * ((n : ℝ)) ^ (-t)) ≤ (-L) := by
    intro t ht
    have htq : t ≤ 8 / 5 := le_trans (le_of_lt ht.2) hq
    have hmono : ((n : ℝ)) ^ (-(8 / 5 : ℝ)) ≤ ((n : ℝ)) ^ (-t) :=
      Real.rpow_le_rpow_of_exponent_le (le_of_lt hn1) (by linarith)
    have hle : L ≤ Real.log n * ((n : ℝ)) ^ (-t) := by
      rw [hL]; exact mul_le_mul_of_nonneg_left hmono hlog
    linarith
  have hcont : ContinuousOn (fun s : ℝ => ((n : ℝ)) ^ (-s)) (Set.Icc p q) :=
    fun t _ => (hasDerivAt_rpow_neg (n : ℝ) hn0 t).continuousAt.continuousWithinAt
  have ha : (fun s : ℝ => ((n : ℝ)) ^ (-s)) p ≤ ((n : ℝ)) ^ (-p) - L * (p - p) := by simp
  have hBcont : ContinuousOn (fun s : ℝ => ((n : ℝ)) ^ (-p) - L * (s - p)) (Set.Icc p q) :=
    fun t _ => (hB t).continuousAt.continuousWithinAt
  have hB' : ∀ t ∈ Set.Ico p q,
      HasDerivWithinAt (fun s : ℝ => ((n : ℝ)) ^ (-p) - L * (s - p)) (-L) (Set.Ici t) t :=
    fun t _ => (hB t).hasDerivWithinAt
  have hmain := image_le_of_deriv_right_le_deriv_boundary hcont hderiv ha hBcont hB' hbound
  have hfin := hmain (show q ∈ Set.Icc p q from ⟨le_of_lt hpq, le_rfl⟩)
  have hLnn : 0 ≤ L := mul_nonneg hlog (Real.rpow_nonneg (le_of_lt hn0) _)
  rw [hL] at hfin
  nlinarith [hfin]

/-- **One-power upper bound at the base `2`**: `2^{-p} - 2^{-q} ≤ (q-p) log 2 · 2^{-7/5}`
for `7/5 ≤ p < q`. -/
lemma two_rpow_sub_upper {p q : ℝ} (hp : 7 / 5 ≤ p) (hpq : p < q) :
    (2 : ℝ) ^ (-p) - (2 : ℝ) ^ (-q) ≤ (q - p) * Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)) := by
  have hlog : 0 ≤ Real.log 2 := le_of_lt (Real.log_pos (by norm_num))
  have hderiv : ∀ t ∈ Set.Icc p q, HasDerivWithinAt (fun s : ℝ => (2 : ℝ) ^ (-s))
      (-(Real.log 2) * (2 : ℝ) ^ (-t)) (Set.Icc p q) t :=
    fun t _ => (hasDerivAt_rpow_neg (2 : ℝ) (by norm_num) t).hasDerivWithinAt
  have hbound : ∀ t ∈ Set.Ico p q,
      ‖-(Real.log 2) * (2 : ℝ) ^ (-t)‖ ≤ Real.log 2 * (2 : ℝ) ^ (-p) := by
    intro t ht
    have hmono : (2 : ℝ) ^ (-t) ≤ (2 : ℝ) ^ (-p) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2)
        (show (-t : ℝ) ≤ -p by linarith [ht.1])
    have hpos : (0 : ℝ) < (2 : ℝ) ^ (-t) := Real.rpow_pos_of_pos (by norm_num) _
    rw [Real.norm_eq_abs, abs_mul, abs_neg, abs_of_nonneg hlog, abs_of_pos hpos]
    exact mul_le_mul_of_nonneg_left hmono hlog
  have hmain := norm_image_sub_le_of_norm_deriv_le_segment' (a := p) (b := q)
    (f := fun s : ℝ => (2 : ℝ) ^ (-s)) (f' := fun t : ℝ => -(Real.log 2) * (2 : ℝ) ^ (-t))
    (C := Real.log 2 * (2 : ℝ) ^ (-p)) hderiv hbound q ⟨le_of_lt hpq, le_rfl⟩
  have habs : ‖(2 : ℝ) ^ (-q) - (2 : ℝ) ^ (-p)‖ = (2 : ℝ) ^ (-p) - (2 : ℝ) ^ (-q) := by
    rw [Real.norm_eq_abs, abs_of_nonpos]
    · ring
    · have := Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2)
        (show (-q : ℝ) ≤ -p by linarith)
      linarith
  rw [habs] at hmain
  have hCM : Real.log 2 * (2 : ℝ) ^ (-p) ≤ Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)) := by
    have hmono : (2 : ℝ) ^ (-p) ≤ (2 : ℝ) ^ (-(7 / 5 : ℝ)) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2)
        (show (-p : ℝ) ≤ -(7 / 5) by linarith)
    exact mul_le_mul_of_nonneg_left hmono hlog
  nlinarith [hmain, hCM, hpq, hlog]

/-! ## 3. Certified constants -/

lemma three_rpow_neg_eight_fifths_gt : (1 / 5.81 : ℝ) < (3 : ℝ) ^ (-(8 / 5 : ℝ)) := by
  have hnat : (3 : ℕ) ^ 8 * 100 ^ 5 < 581 ^ 5 := by native_decide
  have h : ((3 : ℝ) ^ (8 : ℕ)) < ((5.81 : ℝ)) ^ (5 : ℕ) := by
    have e : ((5.81 : ℝ)) ^ (5 : ℕ) = (581 : ℝ) ^ 5 / 100 ^ 5 := by
      rw [show (5.81 : ℝ) = 581 / 100 by norm_num, div_pow]
    rw [e, lt_div_iff₀ (by norm_num : (0 : ℝ) < 100 ^ 5),
      show ((3 : ℝ) ^ (8 : ℕ)) = 6561 by norm_num]
    norm_num
  have h2 : (3 : ℝ) ^ ((8 : ℝ) / 5) < 5.81 := by
    calc (3 : ℝ) ^ ((8 : ℝ) / 5) = (((3 : ℝ) ^ (8 : ℕ))) ^ ((1 : ℝ) / 5) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((5.81 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) :=
          Real.rpow_lt_rpow (by positivity) h (by norm_num)
      _ = 5.81 := by rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  have h3 := one_div_lt_one_div_of_lt (by positivity : (0 : ℝ) < (3 : ℝ) ^ ((8 : ℝ) / 5)) h2
  calc (1 / 5.81 : ℝ) < 1 / (3 : ℝ) ^ ((8 : ℝ) / 5) := h3
    _ = (3 : ℝ) ^ (-(8 / 5 : ℝ)) := by
        rw [show -(8 / 5 : ℝ) = -((8 : ℝ) / 5) by norm_num, Real.rpow_neg (by norm_num),
          one_div]

lemma four_rpow_neg_eight_fifths_gt : (1 / 9.21 : ℝ) < (4 : ℝ) ^ (-(8 / 5 : ℝ)) := by
  have hnat : (4 : ℕ) ^ 8 * 100 ^ 5 < 921 ^ 5 := by native_decide
  have h : ((4 : ℝ) ^ (8 : ℕ)) < ((9.21 : ℝ)) ^ (5 : ℕ) := by
    have e : ((9.21 : ℝ)) ^ (5 : ℕ) = (921 : ℝ) ^ 5 / 100 ^ 5 := by
      rw [show (9.21 : ℝ) = 921 / 100 by norm_num, div_pow]
    rw [e, lt_div_iff₀ (by norm_num : (0 : ℝ) < 100 ^ 5),
      show ((4 : ℝ) ^ (8 : ℕ)) = 65536 by norm_num]
    norm_num
  have h2 : (4 : ℝ) ^ ((8 : ℝ) / 5) < 9.21 := by
    calc (4 : ℝ) ^ ((8 : ℝ) / 5) = (((4 : ℝ) ^ (8 : ℕ))) ^ ((1 : ℝ) / 5) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((9.21 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) :=
          Real.rpow_lt_rpow (by positivity) h (by norm_num)
      _ = 9.21 := by rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  have h3 := one_div_lt_one_div_of_lt (by positivity : (0 : ℝ) < (4 : ℝ) ^ ((8 : ℝ) / 5)) h2
  calc (1 / 9.21 : ℝ) < 1 / (4 : ℝ) ^ ((8 : ℝ) / 5) := h3
    _ = (4 : ℝ) ^ (-(8 / 5 : ℝ)) := by
        rw [show -(8 / 5 : ℝ) = -((8 : ℝ) / 5) by norm_num, Real.rpow_neg (by norm_num),
          one_div]

lemma two_rpow_neg_seven_fifths_lt : (2 : ℝ) ^ (-(7 / 5 : ℝ)) < 0.381 := by
  have hnat : (263 : ℕ) ^ 5 < 2 ^ 7 * 100 ^ 5 := by native_decide
  have h : ((2.63 : ℝ)) ^ (5 : ℕ) < ((2 : ℝ) ^ (7 : ℕ)) := by
    have e : ((2.63 : ℝ)) ^ (5 : ℕ) = (263 : ℝ) ^ 5 / 100 ^ 5 := by
      rw [show (2.63 : ℝ) = 263 / 100 by norm_num, div_pow]
    rw [e, div_lt_iff₀ (by norm_num : (0 : ℝ) < 100 ^ 5),
      show ((2 : ℝ) ^ (7 : ℕ)) = 128 by norm_num]
    norm_num
  have h2 : (2.63 : ℝ) < (2 : ℝ) ^ ((7 : ℝ) / 5) := by
    calc (2.63 : ℝ) = (((2.63 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((2 : ℝ) ^ (7 : ℕ))) ^ ((1 : ℝ) / 5) :=
          Real.rpow_lt_rpow (by positivity) h (by norm_num)
      _ = (2 : ℝ) ^ ((7 : ℝ) / 5) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  have h3 : (1 / (2 : ℝ) ^ ((7 : ℝ) / 5)) < (1 / 2.63 : ℝ) :=
    one_div_lt_one_div_of_lt (by norm_num : (0 : ℝ) < 2.63) h2
  calc (2 : ℝ) ^ (-(7 / 5 : ℝ)) = 1 / (2 : ℝ) ^ ((7 : ℝ) / 5) := by
        rw [show -(7 / 5 : ℝ) = -((7 : ℝ) / 5) by norm_num, Real.rpow_neg (by norm_num),
          one_div]
    _ < 1 / 2.63 := h3
    _ < 0.381 := by norm_num

/-- The separating constant of the pair-threshold comparison is positive. -/
lemma pair_constant_pos :
    (0 : ℝ) < Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
      + Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
      - Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)) := by
  have h3 : (1 : ℝ) < Real.log 3 := by linarith [Real.log_three_gt_d9]
  have h4 : (1 : ℝ) < Real.log 4 := by
    have h := Real.log_two_gt_d9
    have h4eq : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]; norm_num
    rw [h4eq]; linarith
  have h2 : Real.log 2 < 0.7 := by linarith [Real.log_two_lt_d9]
  have hp3 := three_rpow_neg_eight_fifths_gt
  have hp4 := four_rpow_neg_eight_fifths_gt
  have hp2 := two_rpow_neg_seven_fifths_lt
  have h3pos : (0 : ℝ) < (3 : ℝ) ^ (-(8 / 5 : ℝ)) := Real.rpow_pos_of_pos (by norm_num) _
  have h4pos : (0 : ℝ) < (4 : ℝ) ^ (-(8 / 5 : ℝ)) := Real.rpow_pos_of_pos (by norm_num) _
  have h2pos : (0 : ℝ) < (2 : ℝ) ^ (-(7 / 5 : ℝ)) := Real.rpow_pos_of_pos (by norm_num) _
  nlinarith [h3, h4, h2, hp3, hp4, hp2, h3pos, h4pos, h2pos]

/-! ## 4. Strict antitonicity of `Ψ` on `[7/5, 8/5]` -/

/-- **`Ψ` is strictly decreasing on `[7/5, 8/5]`.** -/
lemma Psi_strictAnti {p q : ℝ} (hp : 7 / 5 ≤ p) (hpq : p < q) (hq : q ≤ 8 / 5) :
    Psi q < Psi p := by
  have hp1 : 1 < p := by linarith
  have hq1 : 1 < q := by linarith
  have hp_s : Summable fun k : ℕ => (((k + 3 : ℕ)) : ℝ) ^ (-p) := by
    have h2 : Summable fun k : ℕ => ((((k + 3 : ℕ)) : ℝ) ^ p)⁻¹ :=
      (summable_zetaR hp1).comp_injective (fun a b hab => by simpa using hab)
    refine h2.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg (k + 3))]
  have hq_s : Summable fun k : ℕ => (((k + 3 : ℕ)) : ℝ) ^ (-q) := by
    have h2 : Summable fun k : ℕ => ((((k + 3 : ℕ)) : ℝ) ^ q)⁻¹ :=
      (summable_zetaR hq1).comp_injective (fun a b hab => by simpa using hab)
    refine h2.congr (fun k => ?_)
    rw [Real.rpow_neg (Nat.cast_nonneg (k + 3))]
  have hshift : Summable fun k : ℕ =>
      ((((k + 3 : ℕ)) : ℝ) ^ (-p) - (((k + 3 : ℕ)) : ℝ) ^ (-q)) := hp_s.sub hq_s
  have hnonneg : ∀ k : ℕ, 0 ≤ (((k + 3 : ℕ)) : ℝ) ^ (-p) - (((k + 3 : ℕ)) : ℝ) ^ (-q) := by
    intro k
    have h1 : (1 : ℝ) < ((k + 3 : ℕ) : ℝ) := by
      have : (1 : ℕ) < k + 3 := by omega
      exact_mod_cast this
    exact sub_nonneg.mpr
      (Real.rpow_le_rpow_of_exponent_le (le_of_lt h1) (show -q ≤ -p by linarith))
  have hlow := hshift.sum_le_tsum ({0, 1} : Finset ℕ) (fun i _ => hnonneg i)
  have hsum01 : (∑ i ∈ ({0, 1} : Finset ℕ),
      ((((i + 3 : ℕ)) : ℝ) ^ (-p) - (((i + 3 : ℕ)) : ℝ) ^ (-q)))
      = (((3 : ℕ) : ℝ) ^ (-p) - ((3 : ℕ) : ℝ) ^ (-q))
        + (((4 : ℕ) : ℝ) ^ (-p) - ((4 : ℕ) : ℝ) ^ (-q)) := by
    rw [Finset.sum_insert (by decide), Finset.sum_singleton]
  rw [hsum01] at hlow
  have hlowk : ((3 : ℝ) ^ (-p) - (3 : ℝ) ^ (-q)) + ((4 : ℝ) ^ (-p) - (4 : ℝ) ^ (-q))
      ≤ ∑' k : ℕ, ((((k + 3 : ℕ)) : ℝ) ^ (-p) - (((k + 3 : ℕ)) : ℝ) ^ (-q)) := by
    simpa only [Nat.cast_ofNat] using hlow
  have hb3raw := rpow_sub_lower (n := 3) (by norm_num) hpq hq
  have hb4raw := rpow_sub_lower (n := 4) (by norm_num) hpq hq
  have hb3 : (q - p) * Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
      ≤ (3 : ℝ) ^ (-p) - (3 : ℝ) ^ (-q) := by
    simpa only [Nat.cast_ofNat] using hb3raw
  have hb4 : (q - p) * Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
      ≤ (4 : ℝ) ^ (-p) - (4 : ℝ) ^ (-q) := by
    simpa only [Nat.cast_ofNat] using hb4raw
  have hb2 := two_rpow_sub_upper hp hpq
  have hconst := pair_constant_pos
  have hdiff := Psi_sub hp1 hq1
  have hkey : (q - p) * (Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
      + Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
      - Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)))
      ≤ Psi p - Psi q := by
    rw [hdiff]
    have h34 : (q - p) * Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
        + (q - p) * Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
        ≤ ((3 : ℝ) ^ (-p) - (3 : ℝ) ^ (-q)) + ((4 : ℝ) ^ (-p) - (4 : ℝ) ^ (-q)) := by
      linarith [hb3, hb4]
    have e : (q - p) * (Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
        + Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
        - Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)))
        = (q - p) * Real.log 3 * (3 : ℝ) ^ (-(8 / 5 : ℝ))
          + (q - p) * Real.log 4 * (4 : ℝ) ^ (-(8 / 5 : ℝ))
          - (q - p) * Real.log 2 * (2 : ℝ) ^ (-(7 / 5 : ℝ)) := by ring
    rw [e]
    linarith [hlowk, h34, hb2]
  nlinarith [hkey, hconst, hpq]


/-! ## 5. The certified brackets -/

lemma tail_22_15 : (((100000 : ℕ)) : ℝ) ^ (1 - (22 : ℝ) / 15) / ((22 : ℝ) / 15 - 1) < 0.0102 := by
  rw [show (1 : ℝ) - 22 / 15 = -(7 / 15) by norm_num, Real.rpow_neg (by norm_num),
    show (22 : ℝ) / 15 - 1 = 7 / 15 by norm_num]
  have hbase : (((100000 : ℕ)) : ℝ) = (10 : ℝ) ^ 5 := by norm_num
  rw [hbase, ← Real.rpow_natCast (10 : ℝ) 5, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 10)]
  rw [show ((5 : ℕ) : ℝ) * (7 / 15) = (7 : ℝ) / 3 by norm_num]
  have hgt : (212.2 : ℝ) < (10 : ℝ) ^ ((7 : ℝ) / 3) := by
    have h3 : ((212.2 : ℝ)) ^ 3 < ((10 : ℝ) ^ 7) := by
      rw [show ((212.2 : ℝ)) = 2122 / 10 by norm_num, div_pow]
      rw [div_lt_iff₀ (by norm_num : (0 : ℝ) < 10 ^ 3)]
      norm_num
    calc (212.2 : ℝ) = (((212.2 : ℝ)) ^ 3) ^ ((1 : ℝ) / 3) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((10 : ℝ) ^ 7)) ^ ((1 : ℝ) / 3) :=
          Real.rpow_lt_rpow (by positivity) h3 (by norm_num)
      _ = (10 : ℝ) ^ ((7 : ℝ) / 3) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  have hinv : ((10 : ℝ) ^ ((7 : ℝ) / 3))⁻¹ < (212.2 : ℝ)⁻¹ := by
    rw [← one_div, ← one_div]
    exact one_div_lt_one_div_of_lt (by norm_num : (0 : ℝ) < 212.2) hgt
  rw [div_lt_iff₀ (by norm_num : (0 : ℝ) < 7 / 15)]
  calc ((10 : ℝ) ^ ((7 : ℝ) / 3))⁻¹ < (212.2 : ℝ)⁻¹ := hinv
    _ < 0.0102 * (7 / 15) := by norm_num

lemma ZetaR_22_15_gt : 2.742971773 < ZetaR ((22 : ℝ) / 15) := by
  have h := ZetaR_lower (p := (22 : ℝ) / 15) (by norm_num) 22 15 100000 (by norm_num)
    (by norm_num) (by native_decide)
  have hcert : (2.742971773 : ℝ) < (sumF 22 15 100000 : ℝ) / (SCn : ℝ) := by
    have hval : sumF 22 15 100000 = 2742971774 := by native_decide
    rw [hval, SCn]; norm_num
  linarith

lemma ZetaR_22_15_lt : ZetaR ((22 : ℝ) / 15) < 2.754 := by
  have h := ZetaR_upper (p := (22 : ℝ) / 15) (by norm_num) 22 15 100000 (by norm_num)
    (by norm_num) (by native_decide) (by norm_num)
  have htail := tail_22_15
  have hcert : ((sumF 22 15 100000 : ℝ) + 100000) / (SCn : ℝ) < 2.7431 := by
    have hval : sumF 22 15 100000 = 2742971774 := by native_decide
    rw [hval, SCn]; norm_num
  linarith

lemma ZetaR_7_5_gt_three : 3 < ZetaR ((7 : ℝ) / 5) := by
  have h := ZetaR_lower (p := (7 : ℝ) / 5) (by norm_num) 7 5 100000 (by norm_num)
    (by norm_num) (by native_decide)
  have hcert : (3 : ℝ) < (sumF 7 5 100000 : ℝ) / (SCn : ℝ) := by
    have hval : sumF 7 5 100000 = 3080497357 := by native_decide
    rw [hval, SCn]; norm_num
  linarith

lemma tail_8_5 : (((100000 : ℕ)) : ℝ) ^ (1 - (8 : ℝ) / 5) / ((8 : ℝ) / 5 - 1) = 1 / 600 := by
  rw [show (1 : ℝ) - 8 / 5 = -(3 / 5) by norm_num, Real.rpow_neg (by norm_num),
    show (8 : ℝ) / 5 - 1 = 3 / 5 by norm_num]
  have hbase : (((100000 : ℕ)) : ℝ) = (10 : ℝ) ^ 5 := by norm_num
  rw [hbase, ← Real.rpow_natCast (10 : ℝ) 5, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 10)]
  rw [show ((5 : ℕ) : ℝ) * (3 / 5) = (3 : ℝ) by norm_num]
  norm_num

lemma ZetaR_8_5_lt : ZetaR ((8 : ℝ) / 5) < 2.29 := by
  have h := ZetaR_upper (p := (8 : ℝ) / 5) (by norm_num) 8 5 100000 (by norm_num)
    (by norm_num) (by native_decide) (by norm_num)
  have htail := tail_8_5
  rw [htail] at h
  have hcert : ((sumF 8 5 100000 : ℝ) + 100000) / (SCn : ℝ) < 2.2842 := by
    have hval : sumF 8 5 100000 = 2284049538 := by native_decide
    rw [hval, SCn]; norm_num
  linarith

lemma two_rpow_neg_22_15_lt : (2 : ℝ) ^ (-(22 / 15 : ℝ)) < 0.362 := by
  have hcert : (1000 : ℕ) ^ 15 < 362 ^ 15 * 2 ^ 22 := by native_decide
  have hdiv : (((1000 : ℝ) / 362)) ^ (15 : ℕ) < ((2 : ℝ) ^ (22 : ℕ)) := by
    rw [div_pow, div_lt_iff₀ (by norm_num : (0 : ℝ) < (362 : ℝ) ^ 15)]
    have hcast : ((1000 : ℝ)) ^ 15 < (362 : ℝ) ^ 15 * (2 : ℝ) ^ 22 := by exact_mod_cast hcert
    linarith
  have h : (1000 : ℝ) / 362 < (2 : ℝ) ^ ((22 : ℝ) / 15) := by
    calc (1000 : ℝ) / 362 = ((((1000 : ℝ) / 362)) ^ (15 : ℕ)) ^ ((1 : ℝ) / 15) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((2 : ℝ) ^ (22 : ℕ))) ^ ((1 : ℝ) / 15) :=
          Real.rpow_lt_rpow (by positivity) hdiv (by norm_num)
      _ = (2 : ℝ) ^ ((22 : ℝ) / 15) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  calc (2 : ℝ) ^ (-(22 / 15 : ℝ)) = (((2 : ℝ) ^ ((22 : ℝ) / 15)))⁻¹ := by
        rw [show -(22 / 15 : ℝ) = -((22 : ℝ) / 15) by norm_num, Real.rpow_neg (by norm_num)]
    _ < (((1000 : ℝ) / 362))⁻¹ := by
        rw [← one_div, ← one_div]
        exact one_div_lt_one_div_of_lt (by norm_num : (0 : ℝ) < 1000 / 362) h
    _ = 0.362 := by norm_num

lemma two_rpow_neg_7_15_lt : (2 : ℝ) ^ (-(7 / 15 : ℝ)) < 0.724 := by
  have hcert : (1000 : ℕ) ^ 15 < 724 ^ 15 * 2 ^ 7 := by native_decide
  have hdiv : (((1000 : ℝ) / 724)) ^ (15 : ℕ) < ((2 : ℝ) ^ (7 : ℕ)) := by
    rw [div_pow, div_lt_iff₀ (by norm_num : (0 : ℝ) < (724 : ℝ) ^ 15)]
    have hcast : ((1000 : ℝ)) ^ 15 < (724 : ℝ) ^ 15 * (2 : ℝ) ^ 7 := by exact_mod_cast hcert
    linarith
  have h : (1000 : ℝ) / 724 < (2 : ℝ) ^ ((7 : ℝ) / 15) := by
    calc (1000 : ℝ) / 724 = ((((1000 : ℝ) / 724)) ^ (15 : ℕ)) ^ ((1 : ℝ) / 15) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
      _ < (((2 : ℝ) ^ (7 : ℕ))) ^ ((1 : ℝ) / 15) :=
          Real.rpow_lt_rpow (by positivity) hdiv (by norm_num)
      _ = (2 : ℝ) ^ ((7 : ℝ) / 15) := by
          rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  calc (2 : ℝ) ^ (-(7 / 15 : ℝ)) = (((2 : ℝ) ^ ((7 : ℝ) / 15)))⁻¹ := by
        rw [show -(7 / 15 : ℝ) = -((7 : ℝ) / 15) by norm_num, Real.rpow_neg (by norm_num)]
    _ < (((1000 : ℝ) / 724))⁻¹ := by
        rw [← one_div, ← one_div]
        exact one_div_lt_one_div_of_lt (by norm_num : (0 : ℝ) < 1000 / 724) h
    _ = 0.724 := by norm_num

lemma two_rpow_neg_half_gt : (0.64 : ℝ) < (2 : ℝ) ^ (-(1 / 2 : ℝ)) := by
  have h2 : ((0.64 : ℝ)) ^ (2 : ℕ) < ((2 : ℝ) ^ (-(1 : ℝ))) := by norm_num
  calc (0.64 : ℝ) = (((0.64 : ℝ)) ^ (2 : ℕ)) ^ ((1 : ℝ) / 2) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < (((2 : ℝ) ^ (-(1 : ℝ)))) ^ ((1 : ℝ) / 2) :=
        Real.rpow_lt_rpow (by positivity) h2 (by norm_num)
    _ = (2 : ℝ) ^ (-(1 / 2 : ℝ)) := by
        rw [← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]; norm_num

lemma two_rpow_neg_three_fifths_gt : (0.65 : ℝ) < (2 : ℝ) ^ (-(3 / 5 : ℝ)) := by
  have h5 : ((0.65 : ℝ)) ^ (5 : ℕ) < ((2 : ℝ) ^ (-(3 : ℝ))) := by norm_num
  calc (0.65 : ℝ) = (((0.65 : ℝ)) ^ (5 : ℕ)) ^ ((1 : ℝ) / 5) := by
        rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    _ < (((2 : ℝ) ^ (-(3 : ℝ)))) ^ ((1 : ℝ) / 5) :=
        Real.rpow_lt_rpow (by positivity) h5 (by norm_num)
    _ = (2 : ℝ) ^ (-(3 / 5 : ℝ)) := by
        rw [← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]; norm_num

lemma Psi_22_15_gt : 0 < Psi ((22 : ℝ) / 15) := by
  have hz := ZetaR_22_15_gt
  have h2 := two_rpow_neg_7_15_lt
  have hsplit : (2 : ℝ) ^ (1 - (22 : ℝ) / 15) = (2 : ℝ) ^ (-(7 / 15 : ℝ)) := by
    rw [show (1 : ℝ) - 22 / 15 = -(7 / 15) by norm_num]
  rw [Psi, hsplit]
  linarith

lemma Psi_3_2_lt : Psi ((3 : ℝ) / 2) < 0 := by
  have hz := ZetaR_3_2_lt
  have h2 := two_rpow_neg_half_gt
  have hsplit : (2 : ℝ) ^ (1 - (3 : ℝ) / 2) = (2 : ℝ) ^ (-(1 / 2 : ℝ)) := by
    rw [show (1 : ℝ) - 3 / 2 = -(1 / 2) by norm_num]
  rw [Psi, hsplit]
  linarith

lemma BPos_22_15_lt_one : BPos ((22 : ℝ) / 15) < 1 := by
  have hz := ZetaR_22_15_lt
  have h2 := two_rpow_neg_22_15_lt
  have hpos : (0 : ℝ) < (2 : ℝ) ^ (-(22 / 15 : ℝ)) := Real.rpow_pos_of_pos (by norm_num) _
  rw [BPos]
  nlinarith [hz, h2, hpos]

/-! ## 6. The two tails, and the threshold ordering -/

/-- For `p ≤ 1` the Dirichlet series is not summable, so Mathlib's `tsum` is `0`. -/
lemma ZetaR_eq_zero_of_le_one {p : ℝ} (hp : p ≤ 1) : ZetaR p = 0 := by
  rw [ZetaR]
  exact tsum_eq_zero_of_not_summable
    (fun hsum => absurd ((Real.summable_nat_rpow_inv).mp hsum) (not_lt.mpr hp))

/-- **`Ψ > 0` below `7/5`.** -/
lemma Psi_pos_of_lt_seven_fifths {p : ℝ} (h1 : 1 < p) (h : p < 7 / 5) : 0 < Psi p := by
  have hz : 3 < ZetaR p := lt_trans ZetaR_7_5_gt_three (ZetaR_strictAnti h1 h)
  have h2 : (2 : ℝ) ^ (1 - p) < 1 := by
    have hlt := Real.rpow_lt_rpow_of_exponent_lt (by norm_num : (1 : ℝ) < 2)
      (show 1 - p < 0 by linarith)
    rwa [Real.rpow_zero] at hlt
  rw [Psi]
  linarith

/-- The tail form of the zeta bound: `ζ(p) ≤ 1 + 2^{-p} + 2^{1-p}/(p-1)`. -/
lemma ZetaR_le_one_add {p : ℝ} (hp : 1 < p) :
    ZetaR p ≤ 1 + (2 : ℝ) ^ (-p) + (2 : ℝ) ^ (1 - p) / (p - 1) := by
  have hs := ZetaR_split hp 2
  have ht := tsum_tail_le hp 2 (by norm_num)
  have hsum : (∑ k ∈ Finset.range 2, (((k + 1 : ℕ)) : ℝ) ^ (-p)) = 1 + (2 : ℝ) ^ (-p) := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
    norm_num
  rw [hsum] at hs
  linarith

/-- **`Ψ < 0` above `8/5`.** -/
lemma Psi_neg_of_eight_fifths_le {p : ℝ} (h : 8 / 5 ≤ p) : Psi p < 0 := by
  have hp1 : 1 < p := by linarith
  have hpm : (0 : ℝ) < p - 1 := by linarith
  have hz := ZetaR_le_one_add (p := p) hp1
  have hA : (2 : ℝ) ^ (1 - p) / (p - 1) ≤ (5 / 3) * (2 : ℝ) ^ (1 - p) := by
    rw [div_le_iff₀ hpm]
    have hpos : (0 : ℝ) < (2 : ℝ) ^ (1 - p) := Real.rpow_pos_of_pos (by norm_num) _
    nlinarith
  have hB : (2 : ℝ) ^ (1 - p) = 2 * (2 : ℝ) ^ (-p) := by
    rw [show (1 : ℝ) - p = 1 + (-p) by ring, Real.rpow_add (by norm_num), Real.rpow_one]
  have hC : (7 / 3) * (2 : ℝ) ^ (-p) < 1 := by
    have hle : (2 : ℝ) ^ (-p) ≤ (2 : ℝ) ^ (-(8 / 5 : ℝ)) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2)
        (show -p ≤ -(8 / 5) by linarith)
    have hgt : (7 / 3 : ℝ) < (2 : ℝ) ^ ((8 : ℝ) / 5) := by
      have h5 : ((7 / 3 : ℝ)) ^ 5 < ((2 : ℝ) ^ 8) := by norm_num
      calc (7 / 3 : ℝ) = (((7 / 3 : ℝ)) ^ 5) ^ ((1 : ℝ) / 5) := by
            rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
        _ < (((2 : ℝ) ^ 8)) ^ ((1 : ℝ) / 5) :=
            Real.rpow_lt_rpow (by positivity) h5 (by norm_num)
        _ = (2 : ℝ) ^ ((8 : ℝ) / 5) := by
            rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
    have hinv : (2 : ℝ) ^ (-(8 / 5 : ℝ)) < 3 / 7 := by
      have h7 := one_div_lt_one_div_of_lt (by norm_num : (0 : ℝ) < 7 / 3) hgt
      have h73 : (1 : ℝ) / (7 / 3) = 3 / 7 := by norm_num
      calc (2 : ℝ) ^ (-(8 / 5 : ℝ)) = (2 : ℝ) ^ (-((8 : ℝ) / 5)) := by norm_num
        _ = 1 / (2 : ℝ) ^ ((8 : ℝ) / 5) := by rw [Real.rpow_neg (by norm_num), one_div]
        _ < 3 / 7 := by rw [← h73]; exact h7
    nlinarith [hle, hinv]
  rw [Psi]
  linarith [hz, hA, hB, hC]

/-- **`pP < p_pair < p*`.**  If `P(pP) = 1`, `Ψ(p_pair) = 0` and `ζ(p*) = 2`, then the
radial-pair completeness threshold lies strictly between the positive-endpoint
threshold and the positive-half completeness threshold. -/
theorem pair_threshold_between {pP pPair pstar : ℝ}
    (hP : BPos pP = 1) (hpair : Psi pPair = 0) (hstar : ZetaR pstar = 2) :
    pP < pPair ∧ pPair < pstar := by
  have hP1 : 1 < pP := one_lt_of_BPos_eq hP
  have hs1 : 1 < pstar := one_lt_of_zetaR_eq hstar
  have hpair1 : 1 < pPair := by
    by_contra hle
    push Not at hle
    have h0 : ZetaR pPair = 0 := ZetaR_eq_zero_of_le_one hle
    rw [Psi, h0] at hpair
    have : (0 : ℝ) < (2 : ℝ) ^ (1 - pPair) := Real.rpow_pos_of_pos (by norm_num) _
    linarith
  have hpair_ge : 7 / 5 ≤ pPair := by
    by_contra hlt
    push Not at hlt
    linarith [Psi_pos_of_lt_seven_fifths hpair1 hlt, hpair]
  have hpair_le : pPair ≤ 8 / 5 := by
    by_contra hlt
    push Not at hlt
    linarith [Psi_neg_of_eight_fifths_le (le_of_lt hlt), hpair]
  have hPc : pP < 22 / 15 := by
    rcases lt_trichotomy pP (22 / 15) with hh | hh | hh
    · exact hh
    · rw [hh] at hP; linarith [BPos_22_15_lt_one]
    · have := BPos_strictAnti (by norm_num : (1 : ℝ) < 22 / 15) hh
      rw [hP] at this
      linarith [BPos_22_15_lt_one]
  have hmid_lo : 22 / 15 < pPair := by
    rcases lt_trichotomy pPair (22 / 15) with hh | hh | hh
    · have := Psi_strictAnti (p := pPair) (q := 22 / 15) hpair_ge hh (by norm_num)
      rw [hpair] at this
      linarith [Psi_22_15_gt]
    · rw [hh] at hpair; linarith [Psi_22_15_gt]
    · exact hh
  have hmid_hi : pPair < 3 / 2 := by
    rcases lt_trichotomy pPair (3 / 2) with hh | hh | hh
    · exact hh
    · rw [hh] at hpair; linarith [Psi_3_2_lt]
    · have := Psi_strictAnti (p := 3 / 2) (q := pPair) (by norm_num) hh hpair_le
      rw [hpair] at this
      linarith [Psi_3_2_lt]
  have hsc : 3 / 2 < pstar := by
    rcases lt_trichotomy pstar (3 / 2) with hh | hh | hh
    · have := ZetaR_strictAnti hs1 hh
      rw [hstar] at this
      linarith [ZetaR_3_2_gt]
    · rw [hh] at hstar; linarith [ZetaR_3_2_gt]
    · exact hh
  exact ⟨by linarith, by linarith⟩

end

end ConeLean
