import Cert

/-!
# Towards a ζ box at `1/2 + 14i`

Reuses the `CpowBox`/`params`/`sumBox` certificate machinery from `Cert.lean`.
The heavy `native_decide` term-count check is left as the explicit `hOK`
hypothesis so the assembly is proved independently of the computation.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-- The point rectangle `s = 1/2 + 14i`. -/
def S14 : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(14 : ℚ), (14 : ℚ)⟩⟩

/-- The point `s = 1/2 + 14i`. -/
def s14 : ℂ := (1 / 2 : ℂ) + 14 * Complex.I

theorem mem_S14 : Cx.mem s14 S14 := by
  refine ⟨?_, ?_⟩ <;> norm_num [S14, s14, Cx.mem, Iv.memR]

/-- The eta partial sum after `M` pairs, enclosed by the folded box. -/
theorem etaPartial_mem_box (M : ℕ) (hOK : allOK (params M) S14 = true) :
    Cx.mem (∑ m ∈ Finset.range M, pairTerm s14 m) (sumBox (params M) S14) := by
  have hmem := sumBox_mem (params M) S14 s14 mem_S14 (allOK_conditions hOK)
  rwa [sumValue_params] at hmem

/-- Higher-precision pair parameters for `Im = 14`. -/
def pairParams14 (m : ℕ) : CpowPair :=
  { b1 := (2 * m + 1 : ℕ), b2 := (2 * m + 2 : ℕ),
    N1 := 14, k1 := 14, kI1 := 512, n1 := 18,
    N2 := 14, k2 := 14, kI2 := 512, n2 := 18 }

def params14 (M : ℕ) : List CpowPair :=
  (List.range M).map pairParams14

/-- The `M = 100` checker run at `1/2+14i` with higher precision. -/
theorem allOK_100 : allOK (params14 100) S14 = true := by
  native_decide

theorem sumValue_params14 (M : ℕ) (s : ℂ) :
    sumValue (params14 M) s = ∑ m ∈ Finset.range M, pairTerm s m := by
  induction M with
  | zero => simp [params14, sumValue]
  | succ M ih =>
      have hparams : params14 (M + 1) = params14 M ++ [pairParams14 M] := by
        simp [params14, List.range_succ]
      rw [hparams, sumValue, List.map_append, List.sum_append, ← sumValue, ih,
        Finset.sum_range_succ]
      simp [pairValue, pairTerm, pairParams14]

theorem etaPartial_mem_box14 (M : ℕ) (hOK : allOK (params14 M) S14 = true) :
    Cx.mem (∑ m ∈ Finset.range M, pairTerm s14 m) (sumBox (params14 M) S14) := by
  have hmem := sumBox_mem (params14 M) S14 s14 mem_S14 (allOK_conditions hOK)
  rwa [sumValue_params14] at hmem

theorem etaPartial_100_mem14 :
    Cx.mem (∑ m ∈ Finset.range 100, pairTerm s14 m) (sumBox (params14 100) S14) :=
  etaPartial_mem_box14 100 allOK_100

theorem allOK_1000 : allOK (params14 1000) S14 = true := by
  native_decide

theorem allOK_10000 : allOK (params14 10000) S14 = true := by
  native_decide

theorem allOK_100000 : allOK (params14 100000) S14 = true := by
  native_decide


/-- Faster parameters for million-term checks. -/
def pairParamsFast (m : ℕ) : CpowPair :=
  { b1 := (2 * m + 1 : ℕ), b2 := (2 * m + 2 : ℕ),
    N1 := 10, k1 := 10, kI1 := 256, n1 := 12,
    N2 := 10, k2 := 10, kI2 := 256, n2 := 12 }

def paramsFast (M : ℕ) : List CpowPair :=
  (List.range M).map pairParamsFast

theorem allOK_fast_10000 : allOK (paramsFast 10000) S14 = true := by
  native_decide

theorem norm_s14_le_fifteen : ‖s14‖ ≤ (15 : ℝ) := by
  have hsq : Complex.normSq s14 ≤ (15 : ℝ) ^ 2 := by
    change Complex.normSq ((1 / 2 : ℂ) + 14 * Complex.I) ≤ (15 : ℝ) ^ 2
    rw [show Complex.normSq ((1 / 2 : ℂ) + 14 * Complex.I) = (785 : ℝ) / 4 by
      simp [Complex.normSq_apply]
      norm_num]
    norm_num
  calc ‖s14‖ = Real.sqrt (Complex.normSq s14) := by
        rw [← Real.sqrt_sq (norm_nonneg _), Complex.normSq_eq_norm_sq]
    _ ≤ Real.sqrt ((15 : ℝ) ^ 2) := Real.sqrt_le_sqrt hsq
    _ = (15 : ℝ) := by rw [Real.sqrt_sq (by norm_num)]

theorem tail_s14_1e6 :
    ‖∑' m : ℕ, pairTerm s14 (m + 1000000)‖ ≤ (1 / 64 : ℝ) := by
  have h := norm_tsum_pairTerm_tail_le (s := s14) (M := 1000000) (by norm_num [s14])
  have hs := norm_s14_le_fifteen
  have hA : (2000001 : ℝ) ^ (-(1 : ℝ) / 2 - 1) ≤ (1 / 1000000 : ℝ) := by
    have h1 : (2000001 : ℝ) ^ (-(1 : ℝ) / 2 - 1) ≤ (2000001 : ℝ) ^ (-(1 : ℝ)) := by
      apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
      norm_num
    have h2 : (2000001 : ℝ) ^ (-(1 : ℝ)) = (2000001 : ℝ)⁻¹ := by
      rw [show (-(1 : ℝ)) = (-1 : ℝ) by norm_num, Real.rpow_neg_one]
    rw [h2] at h1
    refine h1.trans ?_
    have h3 : (1000000:ℝ) ≤ 2000001 := by norm_num
    have h4 := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 1000000) h3
    simpa [one_div] using h4
  have hB : (2000001 : ℝ) ^ (-(1 : ℝ) / 2) ≤ (1 / 1400 : ℝ) := by
    have hsqrt : (1400 : ℝ) ≤ Real.sqrt (2000001 : ℝ) := by
      rw [Real.le_sqrt (by norm_num) (by norm_num)]
      norm_num
    have hval : (2000001 : ℝ) ^ (-(1 : ℝ) / 2) = (Real.sqrt (2000001 : ℝ))⁻¹ := by
      rw [show (-(1 : ℝ) / 2) = -(1 / 2 : ℝ) by ring, Real.rpow_neg (by norm_num)]
      rw [← Real.sqrt_eq_rpow]
    rw [hval]
    have h4 := one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 1400) hsqrt
    simpa [one_div] using h4
  have hsum : ((2000001 : ℝ) ^ (-(1 : ℝ) / 2 - 1) +
      (2000001 : ℝ) ^ (-(1 : ℝ) / 2) / (2 * (1 / 2 : ℝ))) ≤
      (1 / 1000000 : ℝ) + (1 / 1400 : ℝ) := by
    have hB' : (2000001 : ℝ) ^ (-(1 : ℝ) / 2) / (2 * (1 / 2 : ℝ)) ≤
        (1 / 1400 : ℝ) := by
      rw [show 2 * (1 / 2 : ℝ) = 1 by norm_num, div_one]
      exact hB
    linarith
  have hrhs : (15 : ℝ) * ((1 / 1000000 : ℝ) + (1 / 1400 : ℝ)) ≤ (1 / 64 : ℝ) := by
    norm_num
  calc ‖∑' m : ℕ, pairTerm s14 (m + 1000000)‖
      ≤ ‖s14‖ * ((2000001 : ℝ) ^ (-(1 : ℝ) / 2 - 1) +
          (2000001 : ℝ) ^ (-(1 : ℝ) / 2) / (2 * (1 / 2 : ℝ))) := by
        convert h using 2 <;> norm_num [s14]
    _ ≤ 15 * ((1 / 1000000 : ℝ) + (1 / 1400 : ℝ)) := by gcongr
    _ ≤ 1 / 64 := hrhs

/-- A block of `M` fast pairs starting at `offset`. -/
def paramsBlock (offset M : ℕ) : List CpowPair :=
  (List.range M).map (fun i => pairParamsFast (offset + i))

theorem sumValue_paramsBlock (offset M : ℕ) (s : ℂ) :
    sumValue (paramsBlock offset M) s = ∑ i ∈ Finset.range M, pairTerm s (offset + i) := by
  induction M with
  | zero => simp [paramsBlock, sumValue]
  | succ M ih =>
      have hparams : paramsBlock offset (M + 1) =
          paramsBlock offset M ++ [pairParamsFast (offset + M)] := by
        simp [paramsBlock, List.range_succ]
      rw [hparams, sumValue, List.map_append, List.sum_append, ← sumValue, ih,
        Finset.sum_range_succ]
      simp [pairValue, pairTerm, pairParamsFast, Nat.add_assoc]

theorem paramsFast_eq_append (off M : ℕ) :
    paramsFast (off + M) = paramsFast off ++ paramsBlock off M := by
  unfold paramsFast paramsBlock
  rw [List.range_add]
  simp [List.map_append, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]

theorem allOK_paramsBlock {N off M : ℕ} {S : Cx}
    (h : allOK (paramsFast N) S = true) (hoff : off + M ≤ N) :
    allOK (paramsBlock off M) S = true := by
  have hNM : N = off + M + (N - (off + M)) := by omega
  have hsplit : paramsFast N =
      paramsFast (off + M) ++ (List.range (N - (off + M))).map
        (fun i => pairParamsFast (off + M + i)) := by
    conv_lhs => rw [hNM]
    unfold paramsFast
    rw [List.range_add]
    simp [List.map_append]
  have h' : (paramsFast (off + M)).all (fun p => PairOK p S) = true := by
    rw [hsplit, allOK, List.all_append, Bool.and_eq_true] at h
    exact h.1
  rw [paramsFast_eq_append, List.all_append, Bool.and_eq_true] at h'
  exact h'.2

theorem blockBox_mem {N off M : ℕ} {S : Cx} {s : ℂ}
    (h : allOK (paramsFast N) S = true) (hoff : off + M ≤ N)
    (hs : Cx.mem s S) :
    Cx.mem (∑ i ∈ Finset.range M, pairTerm s (off + i))
      (sumBox (paramsBlock off M) S) := by
  have hOK := allOK_paramsBlock h hoff
  have hmem := sumBox_mem (paramsBlock off M) S s hs (allOK_conditions hOK)
  rwa [sumValue_paramsBlock] at hmem

theorem sum_blocks_eq (B M : ℕ) (s : ℂ) :
    (∑ j ∈ Finset.range B, ∑ i ∈ Finset.range M, pairTerm s (j * M + i)) =
      ∑ m ∈ Finset.range (B * M), pairTerm s m := by
  induction B with
  | zero => simp
  | succ B ih =>
      rw [Finset.sum_range_succ, ih, Nat.succ_mul]
      rw [Finset.sum_range_add]

end FiniteWindowZeros