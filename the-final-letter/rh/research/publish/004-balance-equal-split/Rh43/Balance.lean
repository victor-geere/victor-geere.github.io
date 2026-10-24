/-
  Balance.lean — "balanced" partial sums of the zeta Dirichlet series on the
  critical line.

  For real `t` and `N : ℕ` the truncation of the Riemann zeta Dirichlet series
  on the critical line is the ordinary finite sum

      zetaPartial N t = ∑_{k<N} (k+1)^{-it} = ∑_{k<N} exp(-i t log (k+1))

  (no analytic continuation is involved anywhere in this file), and its real
  part is the real sum

      realPartial N t = ∑_{k<N} cos (t log (k+1)).

  Splitting the indices according to the sign of the cosine gives the positive
  and the negative total

      posRe N t = ∑_{0 < cos (t log (k+1))} cos (t log (k+1))    (≥ 0),
      negRe N t = ∑_{cos (t log (k+1)) < 0} cos (t log (k+1))    (≤ 0).

  Indices with `cos = 0` belong to neither sum.  That is harmless at the level
  of real parts — such a term contributes `0`, so `realPartial = posRe + negRe`
  still holds exactly (`realPartial_eq_posRe_add_negRe`) — but it is the reason
  why the naive identity `posPart + negPart = zetaPartial` for the *complex*
  partial sums is false: a term with `cos = 0` has a non-zero imaginary part and
  is in neither filter.  All the bookkeeping below is therefore done at the
  level of real parts.

  The partial sum is called *balanced* when the positive and the negative totals
  have the same magnitude, `balanced N t := posRe N t = -negRe N t`; by the
  splitting identity this is equivalent to `realPartial N t = 0`
  (`balanced_iff_realPartial_eq_zero`).

  The main theorem is that a balanced partial sum exists
  (`exists_balanced_partial_sum`): `realPartial 3 0 = 3 > 0` while
  `realPartial 3 (5/2) < 0`, so the intermediate value theorem gives
  `t ∈ [0, 5/2]` with `realPartial 3 t = 0`, and `balanced 3 t` follows.  The
  sign at `t = 5/2` is decided by fully explicit rational bounds on `log 2`,
  `log 3` and `π` (Mathlib's `Real.log_two_gt_d9`, `Real.log_three_gt_d9`,
  `Real.pi_gt_d20`, `Real.pi_lt_d20`), together with the Taylor bounds
  `Real.one_sub_sq_div_two_le_cos`, `Real.sin_ge_sub_cube` and the monotonicity
  of `cos` on `[0, π]` — no numerical axiom is used.

  The complex partial sums behave differently from the real parts, and no
  blanket non-vanishing statement about them is true:

  * `N = 2` **does** vanish, exactly at `t = (2k+1)π / log 2`: there
    `zetaPartial 2 t = 1 + exp(-iπ) = 0` (`zetaPartial_two_pi_div_log_two`),
    and correspondingly `realPartial 2 t = 1 + cos π = 0` with
    `posRe 2 t = 1`, `negRe 2 t = -1`, so `N = 2` *is* balanced
    (`balanced_two`).  This is a different `t` from the `t = 0` of
    `not_balanced_two_zero`, which only says that `t = 0` is not balanced.
  * `N = 3` **never** vanishes: `zetaPartial 3 t ≠ 0` for every real `t`
    (`zetaPartial_three_ne_zero`).  If `1 + x + y = 0` with
    `x = exp(-i t log 2)`, `y = exp(-i t log 3)`, then comparing real and
    imaginary parts forces `cos (t log 2) = cos (t log 3) = -1/2`; hence
    `3 t log 2, 3 t log 3 ∈ 2πℤ`, which for `t ≠ 0` makes `log 3 / log 2`
    rational and then `3^q = 2^p` for positive naturals, impossible.  So
    `¬ ∀ N t, 0 < N → zetaPartial N t ≠ 0`
    (`not_forall_zetaPartial_ne_zero`), with the `N = 2` witness.
  * Nothing is claimed for `N ≥ 4`; that case is open here.
-/
import Mathlib

namespace Rh43

noncomputable section

/-! ## 1. The partial sums and their real parts -/

/-- The partial sum of the Riemann zeta Dirichlet series on the critical line:
`zetaPartial N t = ∑_{k<N} (k+1)^{-it} = ∑_{k<N} exp(-(t : ℂ) * I * log (k+1))`,
an ordinary finite sum.  The index `k = 0`, i.e. the summand `n = 1`,
contributes `exp 0 = 1`. -/
def zetaPartial (N : ℕ) (t : ℝ) : ℂ :=
  ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * (Real.log (k + 1) : ℂ))

/-- The real part of the partial sum, written directly as a real sum:
`realPartial N t = ∑_{k<N} cos (t log (k+1))`. -/
def realPartial (N : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N, Real.cos (t * Real.log ((k : ℝ) + 1))

/-- The real part of the complex partial sum is `realPartial`. -/
theorem zetaPartial_re (N : ℕ) (t : ℝ) : (zetaPartial N t).re = realPartial N t := by
  rw [zetaPartial, realPartial, Complex.re_sum]
  refine Finset.sum_congr rfl fun k _ => ?_
  have harg : -(t : ℂ) * Complex.I * (Real.log (k + 1) : ℂ)
      = ((-(t * Real.log (k + 1)) : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring
  rw [harg, Complex.exp_ofReal_mul_I_re, Real.cos_neg]

/-- Each summand `cos (t log n)` is continuous in `t`. -/
theorem continuous_cos_mul_log (n : ℕ) :
    Continuous (fun t : ℝ => Real.cos (t * Real.log n)) :=
  Real.continuous_cos.comp (continuous_id.mul continuous_const)

/-- `realPartial N ·` is continuous, being a finite sum of continuous functions. -/
theorem realPartial_continuous (N : ℕ) : Continuous (fun t : ℝ => realPartial N t) := by
  unfold realPartial
  fun_prop

/-! ## 2. The positive and negative parts of the real part -/

/-- The total of the summands whose cosine is strictly positive. -/
def posRe (N : ℕ) (t : ℝ) : ℝ := by
  classical
  exact ∑ k ∈ (Finset.range N).filter
      (fun k : ℕ => 0 < Real.cos (t * Real.log ((k : ℝ) + 1))),
    Real.cos (t * Real.log ((k : ℝ) + 1))

/-- The total of the summands whose cosine is strictly negative. -/
def negRe (N : ℕ) (t : ℝ) : ℝ := by
  classical
  exact ∑ k ∈ (Finset.range N).filter
      (fun k : ℕ => Real.cos (t * Real.log ((k : ℝ) + 1)) < 0),
    Real.cos (t * Real.log ((k : ℝ) + 1))

/-- Summands whose cosine vanishes contribute `0`, so dropping them from
`filter (¬ 0 < f)` leaves the sum unchanged. -/
theorem sum_filter_not_pos_eq_sum_filter_neg (s : Finset ℕ) (f : ℕ → ℝ) :
    ∑ k ∈ s.filter (fun k => ¬ 0 < f k), f k
      = ∑ k ∈ s.filter (fun k => f k < 0), f k := by
  classical
  have hset : s.filter (fun k => ¬ 0 < f k)
      = s.filter (fun k => f k < 0) ∪ s.filter (fun k => f k = 0) := by
    ext k
    simp only [Finset.mem_filter, Finset.mem_union]
    constructor
    · rintro ⟨hk, hk'⟩
      rcases lt_or_eq_of_le (le_of_not_gt hk') with h | h
      · exact Or.inl ⟨hk, h⟩
      · exact Or.inr ⟨hk, h⟩
    · rintro (⟨hk, h⟩ | ⟨hk, h⟩)
      · exact ⟨hk, not_lt.mpr h.le⟩
      · exact ⟨hk, by rw [h]; exact lt_irrefl 0⟩
  have hdisj : Disjoint (s.filter (fun k => f k < 0)) (s.filter (fun k => f k = 0)) := by
    rw [Finset.disjoint_left]
    intro k hk1 hk2
    rw [Finset.mem_filter] at hk1 hk2
    exact absurd (hk2.2 ▸ hk1.2) (lt_irrefl 0)
  have hzero : ∑ k ∈ s.filter (fun k => f k = 0), f k = 0 :=
    Finset.sum_eq_zero fun k hk => (Finset.mem_filter.mp hk).2
  rw [hset, Finset.sum_union hdisj, hzero, add_zero]

/-- The real part splits exactly into its positive and negative totals: the
indices on which the cosine vanishes drop out because they contribute `0`. -/
theorem sum_split (s : Finset ℕ) (f : ℕ → ℝ) :
    ∑ k ∈ s, f k = (∑ k ∈ s.filter (fun k => 0 < f k), f k)
      + ∑ k ∈ s.filter (fun k => f k < 0), f k := by
  classical
  rw [← Finset.sum_filter_add_sum_filter_not s (fun k => 0 < f k) f,
    sum_filter_not_pos_eq_sum_filter_neg]

/-- **Splitting the real part.**  `realPartial N t = posRe N t + negRe N t`. -/
theorem realPartial_eq_posRe_add_negRe (N : ℕ) (t : ℝ) :
    realPartial N t = posRe N t + negRe N t := by
  classical
  unfold realPartial posRe negRe
  rw [sum_split]

/-- The same splitting read off the complex partial sum. -/
theorem zetaPartial_re_eq_posRe_add_negRe (N : ℕ) (t : ℝ) :
    (zetaPartial N t).re = posRe N t + negRe N t := by
  rw [zetaPartial_re, realPartial_eq_posRe_add_negRe]

/-- The positive total is nonnegative. -/
theorem posRe_nonneg (N : ℕ) (t : ℝ) : 0 ≤ posRe N t := by
  classical
  rw [posRe]
  exact Finset.sum_nonneg fun k hk => le_of_lt (Finset.mem_filter.mp hk).2

/-- The negative total is nonpositive. -/
theorem negRe_nonpos (N : ℕ) (t : ℝ) : negRe N t ≤ 0 := by
  classical
  rw [negRe]
  exact Finset.sum_nonpos fun k hk => le_of_lt (Finset.mem_filter.mp hk).2

/-! ## 3. Balanced partial sums and the accounting theorem -/

/-- **Balanced.**  The positive and the negative parts of the real part of the
partial sum have the same total magnitude. -/
def balanced (N : ℕ) (t : ℝ) : Prop := posRe N t = -negRe N t

/-- **Accounting theorem.**  The partial sum is balanced exactly when its real
part vanishes. -/
theorem balanced_iff_realPartial_eq_zero (N : ℕ) (t : ℝ) :
    balanced N t ↔ realPartial N t = 0 := by
  have h := realPartial_eq_posRe_add_negRe N t
  constructor
  · intro hb
    rw [h, hb, neg_add_cancel]
  · intro h0
    rw [h] at h0
    unfold balanced
    linarith

/-- **Equal splitting of the two parts.**  A balanced partial sum has its
positive total split into two equal nonnegative halves and its negative total
into two equal nonpositive halves, the two halves being opposite numbers. -/
theorem balanced_equal_split {N : ℕ} {t : ℝ} (hb : balanced N t) :
    ∃ p1 p2 n1 n2 : ℝ, p1 = p2 ∧ n1 = n2 ∧ 0 ≤ p1 ∧ n1 ≤ 0 ∧ p1 + n1 = 0 ∧
      p1 + p2 = posRe N t ∧ n1 + n2 = negRe N t ∧
      p1 + p2 + n1 + n2 = realPartial N t := by
  have hp := posRe_nonneg N t
  have hn := negRe_nonpos N t
  have hb' : posRe N t = -negRe N t := hb
  refine ⟨posRe N t / 2, posRe N t / 2, negRe N t / 2, negRe N t / 2,
    rfl, rfl, by linarith, by linarith, by linarith, by ring, by ring, ?_⟩
  rw [realPartial_eq_posRe_add_negRe N t]
  ring

/-- Conversely, an equal splitting of the two parts *that also balances each
half against the other* (`p1 + n1 = 0`) exhibits a balanced partial sum.  The
extra hypothesis is necessary: without it the converse is false, even though the
four numbers still split the two totals (see `not_balanced_two_zero`). -/
theorem equal_split_balanced {N : ℕ} {t : ℝ} {p1 p2 n1 n2 : ℝ}
    (hp : p1 = p2) (hn : n1 = n2) (hbal : p1 + n1 = 0)
    (hpos : p1 + p2 = posRe N t) (hneg : n1 + n2 = negRe N t) : balanced N t := by
  have h1 : posRe N t = 2 * p1 := by rw [← hpos, hp]; ring
  have h2 : negRe N t = 2 * n1 := by rw [← hneg, hn]; ring
  unfold balanced
  rw [h1, h2]
  linarith

/-- **Equal splitting, iff form.**  Balanced partial sums are exactly those
whose positive total is the sum of two equal nonnegative halves and whose
negative total is the sum of two equal nonpositive halves, the two halves
themselves being opposite (`p1 + n1 = 0`). -/
theorem balanced_iff_equal_split (N : ℕ) (t : ℝ) :
    balanced N t ↔ ∃ p1 p2 n1 n2 : ℝ, p1 = p2 ∧ n1 = n2 ∧ 0 ≤ p1 ∧ n1 ≤ 0 ∧
      p1 + n1 = 0 ∧ p1 + p2 = posRe N t ∧ n1 + n2 = negRe N t ∧
      p1 + p2 + n1 + n2 = realPartial N t :=
  ⟨balanced_equal_split,
    fun ⟨_p1, _p2, _n1, _n2, hp, hn, _hp1, _hn1, hbal, hpos, hneg, _htot⟩ =>
      equal_split_balanced hp hn hbal hpos hneg⟩

/-- A non-zero imaginary part makes the complex partial sum non-zero: the
balance condition concerns the real part only, not the whole complex sum. -/
theorem zetaPartial_ne_zero_of_im_ne_zero {N : ℕ} {t : ℝ}
    (h : (zetaPartial N t).im ≠ 0) : zetaPartial N t ≠ 0 := by
  intro hz
  exact h (by rw [hz]; simp)

/-- The same statement under the name used in the round's brief. -/
theorem not_balanced_zero_of_im_ne_zero {N : ℕ} {t : ℝ}
    (h : (zetaPartial N t).im ≠ 0) : zetaPartial N t ≠ 0 :=
  zetaPartial_ne_zero_of_im_ne_zero h

/-! ## 4. The numerical bounds at `t = 5/2` -/

/-- `cos ((5/2) log 2) < -0.16`: the argument `(5/2) log 2 ≈ 1.73287` lies beyond
`π/2 + 0.162`, where the cosine is at most `-sin 0.162 ≤ -0.162 + 0.162³/6`. -/
theorem cos_two_mul_log_two_lt : Real.cos ((5 / 2 : ℝ) * Real.log 2) < -0.16 := by
  have hlo : Real.pi / 2 + 0.162 < (5 / 2 : ℝ) * Real.log 2 := by
    have h1 : Real.pi / 2 < (1.57079632679489661924 : ℝ) := by
      linarith [Real.pi_lt_d20]
    have h2 : (1.73286795075 : ℝ) < (5 / 2 : ℝ) * Real.log 2 := by
      linarith [Real.log_two_gt_d9]
    have h3 : (1.57079632679489661924 : ℝ) + 0.162 < 1.73286795075 := by norm_num
    linarith
  have hnonneg : (0 : ℝ) ≤ Real.pi / 2 + 0.162 := by linarith [Real.pi_gt_d20]
  have hle : (5 / 2 : ℝ) * Real.log 2 ≤ Real.pi := by
    have h1 : (5 / 2 : ℝ) * Real.log 2 < 1.732867952 := by linarith [Real.log_two_lt_d9]
    have h2 : (3.14 : ℝ) < Real.pi := by linarith [Real.pi_gt_d20]
    linarith
  have h1 : Real.cos ((5 / 2 : ℝ) * Real.log 2) < Real.cos (Real.pi / 2 + 0.162) :=
    Real.cos_lt_cos_of_nonneg_of_le_pi hnonneg hle hlo
  have h2 : Real.cos (Real.pi / 2 + 0.162) = -Real.sin 0.162 := by
    rw [show Real.pi / 2 + 0.162 = 0.162 + Real.pi / 2 by ring, Real.cos_add_pi_div_two]
  have h3 : -Real.sin 0.162 ≤ -(0.162 : ℝ) + 0.162 ^ 3 / 6 := by
    have hs := Real.sin_ge_sub_cube (x := (0.162 : ℝ)) (by norm_num)
    linarith
  have h4 : (-0.16 : ℝ) > -(0.162 : ℝ) + 0.162 ^ 3 / 6 := by norm_num
  linarith

/-- `cos ((5/2) log 3) < -0.92`: the argument `(5/2) log 3 ≈ 2.74653` lies below
`π`, at distance less than `0.39506194` from it, and `cos` is decreasing on
`[0, π]` with `cos 0.39506194 ≥ 1 - 0.39506194²/2`. -/
theorem cos_two_mul_log_three_lt : Real.cos ((5 / 2 : ℝ) * Real.log 3) < -0.92 := by
  have hb_lt : Real.pi - (5 / 2 : ℝ) * Real.log 3 < 0.39506194 := by
    have h1 : (2.74653072125 : ℝ) < (5 / 2 : ℝ) * Real.log 3 := by
      linarith [Real.log_three_gt_d9]
    have h2 : Real.pi < 3.14159265358979323847 := Real.pi_lt_d20
    linarith
  have hb_nonneg : (0 : ℝ) ≤ Real.pi - (5 / 2 : ℝ) * Real.log 3 := by
    have h1 : (5 / 2 : ℝ) * Real.log 3 < 2.746530722 := by linarith [Real.log_three_lt_d9]
    have h2 : (3.14 : ℝ) < Real.pi := by linarith [Real.pi_gt_d20]
    linarith
  have hb_le_pi : (0.39506194 : ℝ) ≤ Real.pi := by linarith [Real.pi_gt_d20]
  have h1 : Real.cos 0.39506194 < Real.cos (Real.pi - (5 / 2 : ℝ) * Real.log 3) :=
    Real.cos_lt_cos_of_nonneg_of_le_pi hb_nonneg hb_le_pi hb_lt
  have h2 : 1 - (0.39506194 : ℝ) ^ 2 / 2 ≤ Real.cos 0.39506194 :=
    Real.one_sub_sq_div_two_le_cos
  have h3 : Real.cos ((5 / 2 : ℝ) * Real.log 3)
      = -Real.cos (Real.pi - (5 / 2 : ℝ) * Real.log 3) := by
    have := Real.cos_pi_sub ((5 / 2 : ℝ) * Real.log 3)
    linarith
  have h4 : (-0.92 : ℝ) > -(1 - (0.39506194 : ℝ) ^ 2 / 2) := by norm_num
  linarith

/-! ## 5. The sign of `realPartial 3` at `0` and at `5/2` -/

/-- `realPartial 3` expanded: the three summands are `1`, `cos (t log 2)` and
`cos (t log 3)`. -/
theorem realPartial_three (t : ℝ) :
    realPartial 3 t = 1 + Real.cos (t * Real.log 2) + Real.cos (t * Real.log 3) := by
  rw [realPartial, Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_one]
  norm_num

/-- At `t = 0` every summand is `1`, so the truncation at `N = 3` equals `3`. -/
theorem realPartial_three_at_zero : realPartial 3 0 = 3 := by
  rw [realPartial_three]
  simp only [zero_mul, Real.cos_zero]
  norm_num

/-- `realPartial 2` expanded: the two summands are `1` and `cos (t log 2)`. -/
theorem realPartial_two (t : ℝ) : realPartial 2 t = 1 + Real.cos (t * Real.log 2) := by
  rw [realPartial, Finset.sum_range_succ, Finset.sum_range_one]
  norm_num

/-- `realPartial 2 0 = 2`. -/
theorem realPartial_two_at_zero : realPartial 2 0 = 2 := by
  rw [realPartial, Finset.sum_range_succ, Finset.sum_range_one]
  simp only [zero_mul, Real.cos_zero]
  norm_num

/-- **The key sign.**  At `t = 5/2` the truncation at `N = 3` is negative:
`1 + cos((5/2) log 2) + cos((5/2) log 3) ≤ 1 - 0.16 - 0.92 < 0`. -/
theorem realPartial_three_five_halves_neg : realPartial 3 (5 / 2) < 0 := by
  rw [realPartial_three]
  have h2 := cos_two_mul_log_two_lt
  have h3 := cos_two_mul_log_three_lt
  linarith

/-- A zero of `realPartial 3` in `[0, 5/2]`, by the intermediate value theorem. -/
theorem exists_zero_realPartial_three :
    ∃ t ∈ Set.Icc (0 : ℝ) (5 / 2), realPartial 3 t = 0 := by
  have hcont : ContinuousOn (fun t : ℝ => realPartial 3 t) (Set.Icc (0 : ℝ) (5 / 2)) :=
    (realPartial_continuous 3).continuousOn
  have hmem : (0 : ℝ) ∈ Set.Icc (realPartial 3 (5 / 2)) (realPartial 3 0) := by
    rw [realPartial_three_at_zero]
    exact ⟨le_of_lt realPartial_three_five_halves_neg, by norm_num⟩
  have himg := intermediate_value_Icc' (by norm_num : (0 : ℝ) ≤ 5 / 2) hcont hmem
  rw [Set.mem_image] at himg
  obtain ⟨t, ht, hft⟩ := himg
  exact ⟨t, ht, hft⟩

/-- The plain existence form: some `t` makes the truncation at `N = 3` vanish. -/
theorem exists_realPartial_three_eq_zero : ∃ t : ℝ, realPartial 3 t = 0 := by
  obtain ⟨t, _, ht⟩ := exists_zero_realPartial_three
  exact ⟨t, ht⟩

/-! ## 6. The answer: a balanced partial sum exists -/

/-- **Main theorem.**  Some non-empty truncation of the zeta Dirichlet series on
the critical line has a balanced real part: the witness is `N = 3` at the `t`
produced by the intermediate value theorem, where `posRe 3 t = -negRe 3 t`. -/
theorem exists_balanced_partial_sum : ∃ (N : ℕ) (t : ℝ), 0 < N ∧ balanced N t := by
  obtain ⟨t, _, ht⟩ := exists_zero_realPartial_three
  exact ⟨3, t, by norm_num, (balanced_iff_realPartial_eq_zero 3 t).mpr ht⟩

/-- At `t = 0` the truncation at `N = 2` is `2`, so it is not balanced.  This is
also the counterexample showing that the bare equal-splitting data (without the
balance of the two halves, `p1 + n1 = 0`) does not imply `balanced`: at `N = 2`,
`t = 0` the data `p1 = p2 = 1`, `n1 = n2 = 0` splits `posRe = 2` and
`negRe = 0` into equal halves.  It does **not** say that `N = 2` is never
balanced: at `t = π / log 2` it is balanced (`balanced_two`). -/
theorem not_balanced_two_zero : ¬ balanced 2 0 := by
  intro hb
  have h := (balanced_iff_realPartial_eq_zero 2 0).mp hb
  rw [realPartial_two_at_zero] at h
  norm_num at h

/-! ## 6. The truncation at `N = 2` is balanced at `t = π / log 2`

`not_balanced_two_zero` only rules out `t = 0`.  The zeros of `realPartial 2`
are *tangential* at `t = (2k+1)π / log 2`, where
`realPartial 2 t = 1 + cos (t log 2) = 1 + cos π = 0`, so `N = 2` is balanced
there; the positive and the negative parts are both non-trivial, being
`posRe = 1` (the summand `n = 1`) and `negRe = -1` (the summand `n = 2`). -/

/-- **`realPartial 2` vanishes at `t = π / log 2`.** -/
theorem realPartial_two_pi_div_log_two : realPartial 2 (Real.pi / Real.log 2) = 0 := by
  rw [realPartial_two]
  have hlog : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have ht : Real.pi / Real.log 2 * Real.log 2 = Real.pi := div_mul_cancel₀ _ hlog
  rw [ht, Real.cos_pi]
  norm_num

/-- **`N = 2` is balanced at `t = π / log 2`.** -/
theorem balanced_two : balanced 2 (Real.pi / Real.log 2) :=
  (balanced_iff_realPartial_eq_zero 2 _).mpr realPartial_two_pi_div_log_two

/-- Some real `t` makes the truncation at `N = 2` balanced. -/
theorem exists_balanced_two : ∃ t : ℝ, balanced 2 t := ⟨_, balanced_two⟩

/-- At `t = π / log 2` the positive total of the `N = 2` truncation is `1`
(only the summand `n = 1` contributes). -/
theorem posRe_two_at_pi_div_log_two : posRe 2 (Real.pi / Real.log 2) = 1 := by
  have ht : Real.pi / Real.log 2 * Real.log 2 = Real.pi :=
    div_mul_cancel₀ _ (Real.log_pos (by norm_num)).ne'
  rw [posRe, Finset.sum_filter, Finset.sum_range_succ, Finset.sum_range_one]
  have h0 : Real.cos (Real.pi / Real.log 2 * Real.log (((0 : ℕ) : ℝ) + 1)) = 1 := by
    norm_num [Real.log_one]
  have h1 : Real.cos (Real.pi / Real.log 2 * Real.log (((1 : ℕ) : ℝ) + 1)) = -1 := by
    rw [show (((1 : ℕ) : ℝ) + 1) = 2 by norm_num, ht, Real.cos_pi]
  rw [h0, h1]
  norm_num

/-- At `t = π / log 2` the negative total of the `N = 2` truncation is `-1`
(only the summand `n = 2` contributes). -/
theorem negRe_two_at_pi_div_log_two : negRe 2 (Real.pi / Real.log 2) = -1 := by
  have ht : Real.pi / Real.log 2 * Real.log 2 = Real.pi :=
    div_mul_cancel₀ _ (Real.log_pos (by norm_num)).ne'
  rw [negRe, Finset.sum_filter, Finset.sum_range_succ, Finset.sum_range_one]
  have h0 : Real.cos (Real.pi / Real.log 2 * Real.log (((0 : ℕ) : ℝ) + 1)) = 1 := by
    norm_num [Real.log_one]
  have h1 : Real.cos (Real.pi / Real.log 2 * Real.log (((1 : ℕ) : ℝ) + 1)) = -1 := by
    rw [show (((1 : ℕ) : ℝ) + 1) = 2 by norm_num, ht, Real.cos_pi]
  rw [h0, h1]
  norm_num

/-! ## 7. The complex partial sums: `N = 2` vanishes, `N = 3` never does

No blanket non-vanishing statement about the complex partial sums is true: at
`N = 2` we have `zetaPartial 2 (π / log 2) = 1 + exp(-iπ) = 0`.  What *is* true
is that `N = 3` never vanishes, which is proved below; nothing is claimed for
`N ≥ 4`. -/

/-- `zetaPartial 2` expanded: the summand `n = 1` is `1` and the summand `n = 2`
is `exp(-i t log 2)`. -/
theorem zetaPartial_two (t : ℝ) :
    zetaPartial 2 t = 1 + Complex.exp ((((-(t * Real.log 2)) : ℝ) : ℂ) * Complex.I) := by
  rw [zetaPartial, Finset.sum_range_succ, Finset.sum_range_one]
  have h0 : -(t : ℂ) * Complex.I * (Real.log (((0 : ℕ) : ℝ) + 1) : ℂ) = 0 := by
    rw [show Real.log (((0 : ℕ) : ℝ) + 1) = 0 by norm_num [Real.log_one]]
    simp
  have h1 : -(t : ℂ) * Complex.I * (Real.log (((1 : ℕ) : ℝ) + 1) : ℂ)
      = (((-(t * Real.log 2)) : ℝ) : ℂ) * Complex.I := by
    rw [show Real.log (((1 : ℕ) : ℝ) + 1) = Real.log 2 by norm_num]
    push_cast
    ring
  rw [h0, h1, Complex.exp_zero]

/-- **`N = 2` vanishes exactly at `t = π / log 2` up to the periodicity of the
cosine:** `zetaPartial 2 (π / log 2) = 1 + exp(-iπ) = 0`. -/
theorem zetaPartial_two_pi_div_log_two : zetaPartial 2 (Real.pi / Real.log 2) = 0 := by
  rw [zetaPartial_two]
  have ht : Real.pi / Real.log 2 * Real.log 2 = Real.pi :=
    div_mul_cancel₀ _ (Real.log_pos (by norm_num)).ne'
  have harg : (((-((Real.pi / Real.log 2) * Real.log 2)) : ℝ) : ℂ) * Complex.I
      = (((-Real.pi : ℝ)) : ℂ) * Complex.I := by rw [ht]
  rw [harg, Complex.exp_ofReal_mul_I]
  norm_num [Real.cos_neg, Real.sin_neg, Real.cos_pi, Real.sin_pi]

/-- **The blanket non-vanishing claim is false**, with the `N = 2` witness. -/
theorem not_forall_zetaPartial_ne_zero :
    ¬ ∀ (N : ℕ) (t : ℝ), 0 < N → zetaPartial N t ≠ 0 := by
  intro h
  exact h 2 (Real.pi / Real.log 2) (by norm_num) zetaPartial_two_pi_div_log_two

/-- `|(n : ℝ)| = (n.natAbs : ℝ)` for an integer `n`. -/
theorem abs_intCast_eq_natAbs (n : ℤ) : |(n : ℝ)| = (n.natAbs : ℝ) := by
  rw [← Int.cast_abs, ← Int.natCast_natAbs]
  norm_num

/-- `zetaPartial 3` expanded: the summands `n = 1, 2, 3` are `1`,
`exp(-i t log 2)` and `exp(-i t log 3)`. -/
theorem zetaPartial_three (t : ℝ) :
    zetaPartial 3 t = 1 + Complex.exp (-(t : ℂ) * Complex.I * (Real.log 2 : ℂ))
      + Complex.exp (-(t : ℂ) * Complex.I * (Real.log 3 : ℂ)) := by
  rw [zetaPartial, Finset.sum_range_succ, Finset.sum_range_succ, Finset.sum_range_one]
  norm_num [Real.log_one]

/-- **`N = 3` never vanishes.**  For every real `t`, `zetaPartial 3 t ≠ 0`.

Suppose `1 + x + y = 0` with `x = exp(-i t log 2)`, `y = exp(-i t log 3)`.
Comparing real parts gives `1 + cos (t log 2) + cos (t log 3) = 0` and comparing
imaginary parts gives `sin (t log 2) = -sin (t log 3)`, hence
`cos (t log 2)² = cos (t log 3)²`; the real-part equation then forces
`cos (t log 2) = cos (t log 3) = -1/2`.  By `Real.cos_three_mul` this gives
`cos (3 t log 2) = cos (3 t log 3) = 1`, so `Real.cos_eq_one_iff` produces
integers `n, m` with `3 t log 2 = 2πn`, `3 t log 3 = 2πm`.  If `t = 0` the
real-part equation reads `3 = 0`, so `t ≠ 0` and then `m log 2 = n log 3` with
`n, m ≠ 0`; taking absolute values gives `3^|n| = 2^|m|` (using `Real.log_pow`
and the injectivity of `Real.log` on the positive reals), which is impossible
because `3 ∣ 2^|m|` would force `3 ∣ 2`. -/
theorem zetaPartial_three_ne_zero (t : ℝ) : zetaPartial 3 t ≠ 0 := by
  intro h
  set x := Complex.exp (-(t : ℂ) * Complex.I * (Real.log 2 : ℂ)) with hx
  set y := Complex.exp (-(t : ℂ) * Complex.I * (Real.log 3 : ℂ)) with hy
  have hsum : 1 + x + y = 0 := by
    rw [hx, hy, ← zetaPartial_three]
    exact h
  have hxarg : x = Complex.exp (((-(t * Real.log 2) : ℝ) : ℂ) * Complex.I) := by
    rw [hx]
    congr 1
    push_cast
    ring
  have hyarg : y = Complex.exp (((-(t * Real.log 3) : ℝ) : ℂ) * Complex.I) := by
    rw [hy]
    congr 1
    push_cast
    ring
  have hre : 1 + Real.cos (t * Real.log 2) + Real.cos (t * Real.log 3) = 0 := by
    have h' := congrArg Complex.re hsum
    simp only [Complex.add_re, Complex.one_re, Complex.zero_re, hxarg, hyarg,
      Complex.exp_ofReal_mul_I_re, Real.cos_neg] at h'
    linarith [h']
  have him : Real.sin (t * Real.log 2) + Real.sin (t * Real.log 3) = 0 := by
    have h' := congrArg Complex.im hsum
    simp only [Complex.add_im, Complex.one_im, Complex.zero_im, hxarg, hyarg,
      Complex.exp_ofReal_mul_I_im, Real.sin_neg] at h'
    linarith [h']
  have hsin : Real.sin (t * Real.log 2) ^ 2 = Real.sin (t * Real.log 3) ^ 2 := by
    rw [show Real.sin (t * Real.log 2) = -Real.sin (t * Real.log 3) by linarith [him]]
    ring
  have hcos_sq : Real.cos (t * Real.log 2) ^ 2 = Real.cos (t * Real.log 3) ^ 2 := by
    have h2 := Real.sin_sq (t * Real.log 2)
    have h3 := Real.sin_sq (t * Real.log 3)
    linarith [hsin, h2, h3]
  have hcos2 : Real.cos (t * Real.log 2) = -1 / 2 := by
    rcases sq_eq_sq_iff_eq_or_eq_neg.mp hcos_sq with h' | h'
    · linarith [hre, h']
    · exfalso
      linarith [hre, h']
  have hcos3 : Real.cos (t * Real.log 3) = -1 / 2 := by linarith [hre, hcos2]
  have hcos3A : Real.cos (3 * (t * Real.log 2)) = 1 := by
    rw [Real.cos_three_mul, hcos2]
    norm_num
  have hcos3B : Real.cos (3 * (t * Real.log 3)) = 1 := by
    rw [Real.cos_three_mul, hcos3]
    norm_num
  obtain ⟨n, hn⟩ := (Real.cos_eq_one_iff (3 * (t * Real.log 2))).mp hcos3A
  obtain ⟨m, hm⟩ := (Real.cos_eq_one_iff (3 * (t * Real.log 3))).mp hcos3B
  have hlog2pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlog3pos : 0 < Real.log 3 := Real.log_pos (by norm_num)
  rcases eq_or_ne t 0 with ht0 | ht0
  · rw [ht0] at hre
    norm_num at hre
  · have hn0 : n ≠ 0 := by
      intro hnz
      rw [hnz] at hn
      simp only [Int.cast_zero, zero_mul] at hn
      have hz : t * Real.log 2 = 0 := by linarith [hn]
      rcases mul_eq_zero.mp hz with h' | h'
      · exact ht0 h'
      · exact absurd h' hlog2pos.ne'
    have hm0 : m ≠ 0 := by
      intro hmz
      rw [hmz] at hm
      simp only [Int.cast_zero, zero_mul] at hm
      have hz : t * Real.log 3 = 0 := by linarith [hm]
      rcases mul_eq_zero.mp hz with h' | h'
      · exact ht0 h'
      · exact absurd h' hlog3pos.ne'
    have hmn : (m : ℝ) * (3 * (t * Real.log 2)) = (n : ℝ) * (3 * (t * Real.log 3)) := by
      rw [← hn, ← hm]
      ring
    have hlog : (m : ℝ) * Real.log 2 = (n : ℝ) * Real.log 3 := by
      have h3 : (3 * t : ℝ) ≠ 0 := mul_ne_zero (by norm_num) ht0
      have hmn' : (3 * t) * ((m : ℝ) * Real.log 2)
          = (3 * t) * ((n : ℝ) * Real.log 3) := by
        linear_combination hmn
      exact mul_left_cancel₀ h3 hmn'
    have hnat : ((m.natAbs : ℝ)) * Real.log 2 = ((n.natAbs : ℝ)) * Real.log 3 := by
      have h1 : |(m : ℝ) * Real.log 2| = |(n : ℝ) * Real.log 3| := by rw [hlog]
      rw [abs_mul, abs_mul, abs_of_pos hlog2pos, abs_of_pos hlog3pos,
        abs_intCast_eq_natAbs, abs_intCast_eq_natAbs] at h1
      exact h1
    have hlogeq : Real.log ((3 : ℝ) ^ n.natAbs) = Real.log ((2 : ℝ) ^ m.natAbs) := by
      rw [Real.log_pow, Real.log_pow]
      linarith [hnat]
    have hpow : (3 : ℝ) ^ n.natAbs = (2 : ℝ) ^ m.natAbs := by
      have h1 := congrArg Real.exp hlogeq
      rwa [Real.exp_log (by positivity), Real.exp_log (by positivity)] at h1
    have hpowNat : (3 : ℕ) ^ n.natAbs = (2 : ℕ) ^ m.natAbs := by
      exact_mod_cast hpow
    have hnz : n.natAbs ≠ 0 := by simpa using hn0
    have hdvd : (3 : ℕ) ∣ 3 ^ n.natAbs := dvd_pow_self 3 hnz
    rw [hpowNat] at hdvd
    have h32 : (3 : ℕ) ∣ 2 := (Nat.Prime.dvd_of_dvd_pow (by norm_num : Nat.Prime 3)) hdvd
    norm_num at h32

end

end Rh43
