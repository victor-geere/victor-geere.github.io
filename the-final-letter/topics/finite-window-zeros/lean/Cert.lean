import Topic
import CpowBox
import ReplayGeneral

/-!
# A finite-window certificate for `ζ(1/2 + 5i)`

This file assembles the P3 certificate:

* `CpowPair` records the parameters of two verified complex-power boxes;
* `pairBox`/`pairValue` are the box and the value of one eta pair;
* `sumBox`/`sumValue` fold a list of pairs;
* `sumBox_mem` proves that the folded box contains the folded value;
* the concrete list `params M` uses uniform log/exp parameters and the proved
  tail bound to enclose `η(1/2+5i)`, and the resulting box excludes zero.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-- Parameters for a pair `b1^{-s} - b2^{-s}`. -/
structure CpowPair where
  b1 : ℕ
  b2 : ℕ
  N1 : ℕ
  k1 : ℕ
  kI1 : ℕ
  n1 : ℕ
  N2 : ℕ
  k2 : ℕ
  kI2 : ℕ
  n2 : ℕ

/-- The side conditions of `cpowBox_mem`, bundled. -/
def CpowConditions (N k kI n : ℕ) (b : ℕ) (S : Cx) : Prop :=
  1 ≤ b ∧ 0 < k ∧ 0 < kI ∧ 0 < n ∧
    (-1 : ℚ) ≤ ((cpowExponent N b S).re.scale (1 / (k : ℚ))).lo ∧
    ((cpowExponent N b S).re.scale (1 / (k : ℚ))).hi ≤ 1 ∧
    (-1 : ℚ) ≤ ((cpowExponent N b S).im.scale (1 / (kI : ℚ))).lo ∧
    ((cpowExponent N b S).im.scale (1 / (kI : ℚ))).hi ≤ 1

/-- Boolean version of `CpowConditions`, for `native_decide`. -/
def CpowOK (N k kI n : ℕ) (b : ℕ) (S : Cx) : Bool :=
  decide (1 ≤ b) && decide (0 < k) && decide (0 < kI) && decide (0 < n) &&
    decide ((-1 : ℚ) ≤ ((cpowExponent N b S).re.scale (1 / (k : ℚ))).lo) &&
    decide (((cpowExponent N b S).re.scale (1 / (k : ℚ))).hi ≤ 1) &&
    decide ((-1 : ℚ) ≤ ((cpowExponent N b S).im.scale (1 / (kI : ℚ))).lo) &&
    decide (((cpowExponent N b S).im.scale (1 / (kI : ℚ))).hi ≤ 1)

theorem CpowConditions_of_OK {N k kI n : ℕ} {b : ℕ} {S : Cx}
    (h : CpowOK N k kI n b S = true) : CpowConditions N k kI n b S := by
  simp only [CpowOK, Bool.and_eq_true, decide_eq_true_eq] at h
  simp only [CpowConditions]
  tauto

/-- Both atoms of a pair satisfy their side conditions. -/
def PairConditions (p : CpowPair) (S : Cx) : Prop :=
  CpowConditions p.N1 p.k1 p.kI1 p.n1 p.b1 S ∧
    CpowConditions p.N2 p.k2 p.kI2 p.n2 p.b2 S

/-- Boolean version of `PairConditions`. -/
def PairOK (p : CpowPair) (S : Cx) : Bool :=
  CpowOK p.N1 p.k1 p.kI1 p.n1 p.b1 S && CpowOK p.N2 p.k2 p.kI2 p.n2 p.b2 S

theorem PairConditions_of_OK {p : CpowPair} {S : Cx}
    (h : PairOK p S = true) : PairConditions p S := by
  simp only [PairOK, Bool.and_eq_true] at h
  exact ⟨CpowConditions_of_OK h.1, CpowConditions_of_OK h.2⟩

/-- All pairs in a list pass the Boolean checks. -/
def allOK (ps : List CpowPair) (S : Cx) : Bool :=
  ps.all fun p => PairOK p S

theorem allOK_conditions {ps : List CpowPair} {S : Cx}
    (h : allOK ps S = true) : ∀ p ∈ ps, PairConditions p S := by
  intro p hp
  exact PairConditions_of_OK ((List.all_eq_true.mp h) p hp)

/-- The box for one eta pair. -/
def pairBox (p : CpowPair) (S : Cx) : Cx :=
  (cpowBox p.N1 p.k1 p.kI1 p.n1 p.b1 S).sub
    (cpowBox p.N2 p.k2 p.kI2 p.n2 p.b2 S)

/-- The value of one eta pair. -/
def pairValue (p : CpowPair) (s : ℂ) : ℂ :=
  (((p.b1 : ℝ) : ℂ) ^ (-s)) - (((p.b2 : ℝ) : ℂ) ^ (-s))

/-- **Pair soundness.** -/
theorem pairBox_mem {p : CpowPair} {S : Cx} {s : ℂ} (hs : Cx.mem s S)
    (h : PairConditions p S) : Cx.mem (pairValue p s) (pairBox p S) := by
  rcases h with ⟨h1, h2⟩
  apply Cx.mem_sub
  · rcases h1 with ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩
    exact cpowBox_mem hb hs hk hkI hn he1 he2 hI1 hI2
  · rcases h2 with ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩
    exact cpowBox_mem hb hs hk hkI hn he1 he2 hI1 hI2

/-- Fold boxes over a list of pairs. -/
def sumBox (ps : List CpowPair) (S : Cx) : Cx :=
  ps.foldr (fun p acc => (pairBox p S).add acc) ⟨⟨0, 0⟩, ⟨0, 0⟩⟩

/-- Fold values over a list of pairs. -/
def sumValue (ps : List CpowPair) (s : ℂ) : ℂ :=
  (ps.map (fun p => pairValue p s)).sum

/-- **Fold soundness.** -/
theorem sumBox_mem (ps : List CpowPair) (S : Cx) (s : ℂ) (hs : Cx.mem s S)
    (h : ∀ p ∈ ps, PairConditions p S) :
    Cx.mem (sumValue ps s) (sumBox ps S) := by
  induction ps with
  | nil =>
      simp [sumValue, sumBox, Cx.mem, Iv.memR]
  | cons p ps ih =>
      rw [sumValue, List.map_cons, List.sum_cons, sumBox, List.foldr_cons]
      exact Cx.mem_add (pairBox_mem hs (h p (by simp)))
        (ih (fun q hq => h q (by simp [hq])))

/-- Uniform parameters for the `m`-th pair `(2m+1, 2m+2)`. -/
def pairParams (m : ℕ) : CpowPair :=
  { b1 := (2 * m + 1 : ℕ), b2 := (2 * m + 2 : ℕ),
    N1 := 10, k1 := 10, kI1 := 32, n1 := 12,
    N2 := 10, k2 := 10, kI2 := 32, n2 := 12 }

/-- The parameter list for `M` pairs. -/
def params (M : ℕ) : List CpowPair :=
  (List.range M).map pairParams

/-- The folded value over `params M` is the finite eta partial sum. -/
theorem sumValue_params (M : ℕ) (s : ℂ) :
    sumValue (params M) s = ∑ m ∈ Finset.range M, pairTerm s m := by
  induction M with
  | zero => simp [params, sumValue]
  | succ M ih =>
      have hparams : params (M + 1) = params M ++ [pairParams M] := by
        simp [params, List.range_succ]
      rw [hparams, sumValue, List.map_append, List.sum_append, ← sumValue, ih,
        Finset.sum_range_succ]
      simp [pairValue, pairTerm, pairParams]



section TailBound

example : (201 : ℝ) ^ (-(1:ℝ) / 2) ≤ (1 / 14 : ℝ) := by
  rw [show (-(1:ℝ) / 2) = -(1 / 2 : ℝ) by ring]
  rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 201)]
  rw [show (201 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 201 by
    rw [← Real.sqrt_eq_rpow]]
  rw [show (1 / 14 : ℝ) = (14 : ℝ)⁻¹ by norm_num]
  rw [inv_le_inv₀ (by positivity) (by norm_num)]
  exact (Real.le_sqrt (by norm_num) (by norm_num)).mpr (by norm_num)

example : (201 : ℝ) ^ (-(3:ℝ) / 2) ≤ (1 / 14 : ℝ) := by
  have h1 : (201 : ℝ) ^ (-(3:ℝ) / 2) ≤ (201 : ℝ) ^ (-(1:ℝ) / 2) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) (by norm_num)
  exact h1.trans (by
    rw [show (-(1:ℝ) / 2) = -(1 / 2 : ℝ) by ring]
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 201)]
    rw [show (201 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 201 by
      rw [← Real.sqrt_eq_rpow]]
    rw [show (1 / 14 : ℝ) = (14 : ℝ)⁻¹ by norm_num]
    rw [inv_le_inv₀ (by positivity) (by norm_num)]
    exact (Real.le_sqrt (by norm_num) (by norm_num)).mpr (by norm_num))

example : ‖((1 / 2 : ℂ) + 5 * Complex.I)‖ ≤ (5.1 : ℝ) := by
  have h : Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I) ≤ (5.1 : ℝ) ^ 2 := by
    norm_num [Complex.normSq, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im]
  have hnn : (0:ℝ) ≤ Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I) := Complex.normSq_nonneg _
  calc
    ‖((1 / 2 : ℂ) + 5 * Complex.I)‖ = Real.sqrt (Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I)) := by
      rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
    _ ≤ Real.sqrt ((5.1 : ℝ) ^ 2) := Real.sqrt_le_sqrt h
    _ = 5.1 := by rw [Real.sqrt_sq (by norm_num)]

lemma tail_bound_main :
    ‖∑' m : ℕ, pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) (m + 100)‖ ≤ (1 : ℝ) := by
  have h := norm_tsum_pairTerm_tail_le (s := (1 / 2 : ℂ) + 5 * Complex.I) (M := 100)
    (by norm_num)
  have hs : ‖((1 / 2 : ℂ) + 5 * Complex.I)‖ ≤ (5.1 : ℝ) := by
    have hsq : Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I) ≤ (5.1 : ℝ) ^ 2 := by
      norm_num [Complex.normSq, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im]
    have hnn : (0:ℝ) ≤ Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I) := Complex.normSq_nonneg _
    calc
      ‖((1 / 2 : ℂ) + 5 * Complex.I)‖ = Real.sqrt (Complex.normSq ((1 / 2 : ℂ) + 5 * Complex.I)) := by
        rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
      _ ≤ Real.sqrt ((5.1 : ℝ) ^ 2) := Real.sqrt_le_sqrt hsq
      _ = 5.1 := by rw [Real.sqrt_sq (by norm_num)]
  have h1 : (201 : ℝ) ^ (-(3:ℝ) / 2) ≤ (1 / 14 : ℝ) := by
    have hle : (201 : ℝ) ^ (-(3:ℝ) / 2) ≤ (201 : ℝ) ^ (-(1:ℝ) / 2) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num) (by norm_num)
    refine hle.trans ?_
    rw [show (-(1:ℝ) / 2) = -(1 / 2 : ℝ) by ring]
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 201)]
    rw [show (201 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 201 by
      rw [← Real.sqrt_eq_rpow]]
    rw [show (1 / 14 : ℝ) = (14 : ℝ)⁻¹ by norm_num]
    rw [inv_le_inv₀ (by positivity) (by norm_num)]
    exact (Real.le_sqrt (by norm_num) (by norm_num)).mpr (by norm_num)
  have h2 : (201 : ℝ) ^ (-(1:ℝ) / 2) / (2 * (1 / 2 : ℝ)) ≤ (1 / 14 : ℝ) := by
    rw [show 2 * (1 / 2 : ℝ) = 1 by norm_num, div_one]
    rw [show (-(1:ℝ) / 2) = -(1 / 2 : ℝ) by ring]
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 201)]
    rw [show (201 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 201 by
      rw [← Real.sqrt_eq_rpow]]
    rw [show (1 / 14 : ℝ) = (14 : ℝ)⁻¹ by norm_num]
    rw [inv_le_inv₀ (by positivity) (by norm_num)]
    exact (Real.le_sqrt (by norm_num) (by norm_num)).mpr (by norm_num)
  have hrhs : (201 : ℝ) ^ (-(3:ℝ) / 2) + (201 : ℝ) ^ (-(1:ℝ) / 2) / (2 * (1 / 2 : ℝ)) ≤
      (1 / 14 : ℝ) + (1 / 14 : ℝ) := add_le_add h1 h2
  have hnonneg : (0:ℝ) ≤ (201 : ℝ) ^ (-(3:ℝ) / 2) +
      (201 : ℝ) ^ (-(1:ℝ) / 2) / (2 * (1 / 2 : ℝ)) := by positivity
  have h1' : (201 : ℝ) ^ (-(1:ℝ) / 2 - 1) ≤ (1 / 14 : ℝ) := by
    simpa [show (-(1:ℝ) / 2 - 1) = -(3:ℝ) / 2 by ring] using h1
  have h2' : (201 : ℝ) ^ (-(1:ℝ) / 2) ≤ (1 / 14 : ℝ) := by
    simpa using h2
  calc
    ‖∑' m : ℕ, pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) (m + 100)‖
        ≤ ‖((1 / 2 : ℂ) + 5 * Complex.I)‖ *
            ((201 : ℝ) ^ (-(1:ℝ) / 2 - 1) + (201 : ℝ) ^ (-(1:ℝ) / 2)) := by
          have hsre : ((1 / 2 : ℂ) + 5 * Complex.I).re = (1 / 2 : ℝ) := by
            norm_num [Complex.add_re]
          rw [hsre] at h
          norm_num at h
          convert h using 2 <;> ring
    _ ≤ (5.1 : ℝ) * ((1 / 14 : ℝ) + (1 / 14 : ℝ)) := by
          gcongr
    _ ≤ 1 := by norm_num

end TailBound

/-- The point rectangle `s = 1/2 + 5i`. -/
def S0 : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (5 : ℚ)⟩⟩

/-- The point `s = 1/2 + 5i`. -/
def s0 : ℂ := (1 / 2 : ℂ) + 5 * Complex.I

example : Cx.mem s0 S0 := by
  refine ⟨?_, ?_⟩ <;> norm_num [S0, s0, Cx.mem, Iv.memR]

example : allOK (params 100) S0 = true := by
  native_decide



/-- A rational test for `0 ∈ Z`. -/
def containsZero (Z : Cx) : Bool :=
  decide (Z.re.lo ≤ 0) && decide (0 ≤ Z.re.hi) &&
    decide (Z.im.lo ≤ 0) && decide (0 ≤ Z.im.hi)

theorem containsZero_iff (Z : Cx) : containsZero Z = true ↔ Cx.mem (0 : ℂ) Z := by
  simp only [containsZero, Bool.and_eq_true, decide_eq_true_eq, Cx.mem, Iv.memR,
    Complex.zero_re, Complex.zero_im]
  constructor
  · rintro ⟨⟨⟨h1, h2⟩, h3⟩, h4⟩
    exact ⟨⟨by exact_mod_cast h1, by exact_mod_cast h2⟩,
      ⟨by exact_mod_cast h3, by exact_mod_cast h4⟩⟩
  · rintro ⟨⟨h1, h2⟩, ⟨h3, h4⟩⟩
    exact ⟨⟨⟨by exact_mod_cast h1, by exact_mod_cast h2⟩,
      by exact_mod_cast h3⟩, by exact_mod_cast h4⟩



example : (1 : ℚ) < (sumBox (params 100) S0).re.lo := by native_decide

/-- **P3 instance.**  `ζ(1/2 + 5i) ≠ 0`, certified by the finite eta enclosure
with 100 pairs and the Lean tail bound. -/
theorem zeta_half_plus_five_ne_zero :
    riemannZeta ((1 / 2 : ℂ) + 5 * Complex.I) ≠ 0 := by
  have hs0_re : (0 : ℝ) < ((1 / 2 : ℂ) + 5 * Complex.I).re := by
    norm_num [Complex.add_re]
  have hs0_ne : ((1 / 2 : ℂ) + 5 * Complex.I) ≠ 1 := by
    intro h
    have him := congrArg Complex.im h
    norm_num at him
  have hS : Cx.mem ((1 / 2 : ℂ) + 5 * Complex.I) S0 := by
    refine ⟨?_, ?_⟩ <;> norm_num [S0, Cx.mem, Iv.memR]
  have hcond : ∀ p ∈ params 100, PairConditions p S0 :=
    allOK_conditions (by native_decide)
  have hsum : Cx.mem (sumValue (params 100) ((1 / 2 : ℂ) + 5 * Complex.I))
      (sumBox (params 100) S0) :=
    sumBox_mem (params 100) S0 ((1 / 2 : ℂ) + 5 * Complex.I) hS hcond
  have hsum_eq : sumValue (params 100) ((1 / 2 : ℂ) + 5 * Complex.I) =
      ∑ m ∈ Finset.range 100, pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) m :=
    sumValue_params 100 ((1 / 2 : ℂ) + 5 * Complex.I)
  have hsummable : Summable (fun m : ℕ => pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) m) :=
    summable_pairTerm (by norm_num)
  have hdecomp : etaGrouped ((1 / 2 : ℂ) + 5 * Complex.I) =
      sumValue (params 100) ((1 / 2 : ℂ) + 5 * Complex.I) +
        ∑' m : ℕ, pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) (m + 100) := by
    rw [etaGrouped, ← hsummable.sum_add_tsum_nat_add 100, ← hsum_eq]
  let B : Cx := (sumBox (params 100) S0).add (PartialTail.ball (1 : ℚ))
  have htail : Cx.mem (∑' m : ℕ, pairTerm ((1 / 2 : ℂ) + 5 * Complex.I) (m + 100))
      (PartialTail.ball (1 : ℚ)) :=
    PartialTail.mem_ball_of_norm_le (by norm_num) (by simpa using tail_bound_main)
  have hB : Cx.mem (etaGrouped ((1 / 2 : ℂ) + 5 * Complex.I)) B := by
    rw [hdecomp]
    exact Cx.mem_add hsum htail
  have hzero : ¬ Cx.mem (0 : ℂ) B := by
    have hz : containsZero B = false := by native_decide
    intro h
    have htrue := (containsZero_iff B).mpr h
    rw [hz] at htrue
    exact Bool.false_ne_true htrue
  exact zeta_ne_zero_of_eta_mem (U := {z : ℂ | Cx.mem z B}) hs0_re hs0_ne hB hzero

end FiniteWindowZeros


