import Seg

/-!
# A wider height-5 segment

Three adjacent boxes of width `3×10⁻⁶` cover
`1/2 + it`, `t ∈ [5, 5.000009]`.  Each box is certified by the generic
`zeta_ne_zero_on_rect_of_params`; the existing `Sseg` covers the first one.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-- Tail bound for any rectangle on `Re = 1/2` with height in `[5, 5.01]`. -/
theorem tail_bound_im_range {s : ℂ} (hsre : s.re = (1 / 2 : ℝ))
    (hlo : (5 : ℝ) ≤ s.im) (hhi : s.im ≤ (5.01 : ℝ)) :
    ‖∑' m : ℕ, pairTerm s (m + 100)‖ ≤ (1 : ℝ) := by
  have h := norm_tsum_pairTerm_tail_le (s := s) (M := 100) (by rw [hsre]; norm_num)
  have hs_norm : ‖s‖ ≤ (5.1 : ℝ) := by
    have hsq : Complex.normSq s ≤ (5.1 : ℝ) ^ 2 := by
      rw [Complex.normSq_apply]
      nlinarith [sq_nonneg s.im]
    have hnn : (0 : ℝ) ≤ Complex.normSq s := Complex.normSq_nonneg _
    calc
      ‖s‖ = Real.sqrt (Complex.normSq s) := by
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
  have h1' : (201 : ℝ) ^ (-(1:ℝ) / 2 - 1) ≤ (1 / 14 : ℝ) := by
    simpa [show (-(1:ℝ) / 2 - 1) = -(3:ℝ) / 2 by ring] using h1
  have h2' : (201 : ℝ) ^ (-(1:ℝ) / 2) ≤ (1 / 14 : ℝ) := by simpa using h2
  calc
    ‖∑' m : ℕ, pairTerm s (m + 100)‖
        ≤ ‖s‖ * ((201 : ℝ) ^ (-(1:ℝ) / 2 - 1) + (201 : ℝ) ^ (-(1:ℝ) / 2)) := by
          have hs' := h
          rw [hsre] at hs'
          norm_num at hs'
          convert hs' using 2 <;> ring
    _ ≤ (5.1 : ℝ) * ((1 / 14 : ℝ) + (1 / 14 : ℝ)) := by gcongr
    _ ≤ 1 := by norm_num

/-- A height-5 segment box with rational endpoints. -/
def segBox (a b : ℚ) : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨a, b⟩⟩

/-- One-box certificate: if the endpoints lie in `[5, 5.01]`, the pair side
conditions hold and the folded box excludes zero, then `ζ` is nonvanishing on
the box. -/
theorem zeta_ne_zero_seg_box {a b : ℚ} (ha : (5 : ℚ) ≤ a) (hb : (b : ℝ) ≤ (5.01 : ℝ))
    (hcond : ∀ p ∈ params 100, PairConditions p (segBox a b))
    (hzero : containsZero ((sumBox (params 100) (segBox a b)).add
      (PartialTail.ball (1 : ℚ))) = false) :
    ∀ s : ℂ, Cx.mem s (segBox a b) → riemannZeta s ≠ 0 := by
  apply zeta_ne_zero_on_rect_of_params 100 (segBox a b) 1 (by norm_num)
  · exact hcond
  · intro s hs
    have hre : s.re = (1 / 2 : ℝ) := by
      have h := hs.1
      simp [segBox, Iv.memR] at h
      linarith [h.1, h.2]
    have hlo : (5 : ℝ) ≤ s.im := by
      have h := hs.2
      simp [segBox, Iv.memR] at h
      have : (a : ℝ) ≤ s.im := h.1
      exact le_trans (by exact_mod_cast ha) this
    have hhi : s.im ≤ (5.01 : ℝ) := by
      have h := hs.2
      simp [segBox, Iv.memR] at h
      have : s.im ≤ (b : ℝ) := h.2
      exact le_trans this hb
    simpa using tail_bound_im_range hre hlo hhi
  · exact hzero
  · intro s hs
    have h := hs.1
    simp [segBox, Iv.memR] at h
    linarith [h.1, h.2]
  · intro s hs h
    have hlo : (5 : ℝ) ≤ s.im := by
      have h' := hs.2
      simp [segBox, Iv.memR] at h'
      have : (a : ℝ) ≤ s.im := h'.1
      exact le_trans (by exact_mod_cast ha) this
    have him := congrArg Complex.im h
    rw [h] at hlo
    norm_num at hlo

def S1 : Cx := segBox (5000003 / 1000000) (5000006 / 1000000)
def S2 : Cx := segBox (5000006 / 1000000) (5000009 / 1000000)
def S3 : Cx := segBox (5000009 / 1000000) (5000012 / 1000000)
def S4 : Cx := segBox (5000012 / 1000000) (5000015 / 1000000)
def S5 : Cx := segBox (5000015 / 1000000) (5000018 / 1000000)
def S6 : Cx := segBox (5000018 / 1000000) (5000021 / 1000000)
def S7 : Cx := segBox (5000021 / 1000000) (5000024 / 1000000)
def S8 : Cx := segBox (5000024 / 1000000) (5000027 / 1000000)
def S9 : Cx := segBox (5000027 / 1000000) (5000030 / 1000000)
def S10 : Cx := segBox (5000030 / 1000000) (5000033 / 1000000)
def S11 : Cx := segBox (5000033 / 1000000) (5000036 / 1000000)

/-- The Boolean check for one segment box. -/
def boxOK (S : Cx) : Bool :=
  allOK (params 100) S &&
    !containsZero ((sumBox (params 100) S).add (PartialTail.ball (1 : ℚ)))

theorem boxOK_sound {S : Cx} (h : boxOK S = true) :
    (∀ p ∈ params 100, PairConditions p S) ∧
      containsZero ((sumBox (params 100) S).add (PartialTail.ball (1 : ℚ))) = false := by
  unfold boxOK at h
  rw [Bool.and_eq_true] at h
  exact ⟨allOK_conditions h.1, by simpa using h.2⟩

/-- All certified segment boxes, including the original first box. -/
def segmentBoxes : List Cx :=
  [Sseg, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11]

/-- One `native_decide` checks every segment box. -/
theorem segmentBoxes_ok : segmentBoxes.all boxOK = true := by native_decide

theorem mem_segmentBoxes_S1 : S1 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S2 : S2 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S3 : S3 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S4 : S4 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S5 : S5 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S6 : S6 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S7 : S7 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S8 : S8 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S9 : S9 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S10 : S10 ∈ segmentBoxes := by simp [segmentBoxes]
theorem mem_segmentBoxes_S11 : S11 ∈ segmentBoxes := by simp [segmentBoxes]

theorem boxOK_of_mem {S : Cx} (hS : S ∈ segmentBoxes) : boxOK S = true :=
  List.all_eq_true.mp segmentBoxes_ok S hS

theorem zeta_ne_zero_of_boxOK {a b : ℚ} (ha : (5 : ℚ) ≤ a) (hb : (b : ℝ) ≤ (5.01 : ℝ))
    (h : boxOK (segBox a b) = true) :
    ∀ s : ℂ, Cx.mem s (segBox a b) → riemannZeta s ≠ 0 :=
  zeta_ne_zero_seg_box ha hb (boxOK_sound h).1 (boxOK_sound h).2

theorem zeta_ne_zero_S1 : ∀ s : ℂ, Cx.mem s S1 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S1)

theorem zeta_ne_zero_S2 : ∀ s : ℂ, Cx.mem s S2 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S2)

theorem zeta_ne_zero_S3 : ∀ s : ℂ, Cx.mem s S3 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S3)

theorem zeta_ne_zero_S4 : ∀ s : ℂ, Cx.mem s S4 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S4)

theorem zeta_ne_zero_S5 : ∀ s : ℂ, Cx.mem s S5 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S5)

theorem zeta_ne_zero_S6 : ∀ s : ℂ, Cx.mem s S6 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S6)

theorem zeta_ne_zero_S7 : ∀ s : ℂ, Cx.mem s S7 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S7)

theorem zeta_ne_zero_S8 : ∀ s : ℂ, Cx.mem s S8 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S8)

theorem zeta_ne_zero_S9 : ∀ s : ℂ, Cx.mem s S9 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S9)

theorem zeta_ne_zero_S10 : ∀ s : ℂ, Cx.mem s S10 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S10)

theorem zeta_ne_zero_S11 : ∀ s : ℂ, Cx.mem s S11 → riemannZeta s ≠ 0 :=
  zeta_ne_zero_of_boxOK (by norm_num) (by norm_num) (boxOK_of_mem mem_segmentBoxes_S11)

/-- **Wider zero-free segment:** `ζ(1/2+it) ≠ 0` for `t ∈ [5, 5.000009]`. -/
theorem zeta_ne_zero_segment_wide {s : ℂ}
    (hre : s.re = (1 / 2 : ℝ))
    (hlo : (5 : ℝ) ≤ s.im) (hhi : s.im ≤ (5000009 / 1000000 : ℝ)) :
    riemannZeta s ≠ 0 := by
  by_cases h1 : s.im ≤ (5000003 / 1000000 : ℝ)
  · have hmem : Cx.mem s Sseg := by
      refine ⟨?_, ?_⟩
      · simp [Sseg, Iv.memR, hre]
      · simp [Sseg, Iv.memR]; exact ⟨hlo, h1⟩
    exact zeta_ne_zero_segment hmem
  · have h1' : (5000003 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h1
    by_cases h2 : s.im ≤ (5000006 / 1000000 : ℝ)
    · have hmem : Cx.mem s S1 := by
        refine ⟨?_, ?_⟩
        · simp [S1, segBox, Iv.memR, hre]
        · simp [S1, segBox, Iv.memR]; exact ⟨h1', h2⟩
      exact zeta_ne_zero_S1 s hmem
    · have h2' : (5000006 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h2
      have hmem : Cx.mem s S2 := by
        refine ⟨?_, ?_⟩
        · simp [S2, segBox, Iv.memR, hre]
        · simp [S2, segBox, Iv.memR]; exact ⟨h2', hhi⟩
      exact zeta_ne_zero_S2 s hmem

/-- **Wider zero-free segment (extended):** `ζ(1/2+it) ≠ 0` for
`t ∈ [5, 5.000018]`. -/
theorem zeta_ne_zero_segment_wide2 {s : ℂ}
    (hre : s.re = (1 / 2 : ℝ))
    (hlo : (5 : ℝ) ≤ s.im) (hhi : s.im ≤ (5000018 / 1000000 : ℝ)) :
    riemannZeta s ≠ 0 := by
  by_cases h0 : s.im ≤ (5000009 / 1000000 : ℝ)
  · exact zeta_ne_zero_segment_wide hre hlo h0
  · have h0' : (5000009 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h0
    by_cases h1 : s.im ≤ (5000012 / 1000000 : ℝ)
    · have hmem : Cx.mem s S3 := by
        refine ⟨?_, ?_⟩
        · simp [S3, segBox, Iv.memR, hre]
        · simp [S3, segBox, Iv.memR]; exact ⟨h0', h1⟩
      exact zeta_ne_zero_S3 s hmem
    · have h1' : (5000012 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h1
      by_cases h2 : s.im ≤ (5000015 / 1000000 : ℝ)
      · have hmem : Cx.mem s S4 := by
          refine ⟨?_, ?_⟩
          · simp [S4, segBox, Iv.memR, hre]
          · simp [S4, segBox, Iv.memR]; exact ⟨h1', h2⟩
        exact zeta_ne_zero_S4 s hmem
      · have h2' : (5000015 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h2
        have hmem : Cx.mem s S5 := by
          refine ⟨?_, ?_⟩
          · simp [S5, segBox, Iv.memR, hre]
          · simp [S5, segBox, Iv.memR]; exact ⟨h2', hhi⟩
        exact zeta_ne_zero_S5 s hmem


/-- **Wider zero-free segment (extended again):** `ζ(1/2+it) ≠ 0` for
`t ∈ [5, 5.000027]`. -/
theorem zeta_ne_zero_segment_wide3 {s : ℂ}
    (hre : s.re = (1 / 2 : ℝ))
    (hlo : (5 : ℝ) ≤ s.im) (hhi : s.im ≤ (5000027 / 1000000 : ℝ)) :
    riemannZeta s ≠ 0 := by
  by_cases h0 : s.im ≤ (5000018 / 1000000 : ℝ)
  · exact zeta_ne_zero_segment_wide2 hre hlo h0
  · have h0' : (5000018 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h0
    by_cases h1 : s.im ≤ (5000021 / 1000000 : ℝ)
    · have hmem : Cx.mem s S6 := by
        refine ⟨?_, ?_⟩
        · simp [S6, segBox, Iv.memR, hre]
        · simp [S6, segBox, Iv.memR]; exact ⟨h0', h1⟩
      exact zeta_ne_zero_S6 s hmem
    · have h1' : (5000021 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h1
      by_cases h2 : s.im ≤ (5000024 / 1000000 : ℝ)
      · have hmem : Cx.mem s S7 := by
          refine ⟨?_, ?_⟩
          · simp [S7, segBox, Iv.memR, hre]
          · simp [S7, segBox, Iv.memR]; exact ⟨h1', h2⟩
        exact zeta_ne_zero_S7 s hmem
      · have h2' : (5000024 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h2
        have hmem : Cx.mem s S8 := by
          refine ⟨?_, ?_⟩
          · simp [S8, segBox, Iv.memR, hre]
          · simp [S8, segBox, Iv.memR]; exact ⟨h2', hhi⟩
        exact zeta_ne_zero_S8 s hmem


/-- **Wider zero-free segment (extended to 5.000036):** `ζ(1/2+it) ≠ 0` for
`t ∈ [5, 5.000036]`. -/
theorem zeta_ne_zero_segment_wide4 {s : ℂ}
    (hre : s.re = (1 / 2 : ℝ))
    (hlo : (5 : ℝ) ≤ s.im) (hhi : s.im ≤ (5000036 / 1000000 : ℝ)) :
    riemannZeta s ≠ 0 := by
  by_cases h0 : s.im ≤ (5000027 / 1000000 : ℝ)
  · exact zeta_ne_zero_segment_wide3 hre hlo h0
  · have h0' : (5000027 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h0
    by_cases h1 : s.im ≤ (5000030 / 1000000 : ℝ)
    · have hmem : Cx.mem s S9 := by
        refine ⟨?_, ?_⟩
        · simp [S9, segBox, Iv.memR, hre]
        · simp [S9, segBox, Iv.memR]; exact ⟨h0', h1⟩
      exact zeta_ne_zero_S9 s hmem
    · have h1' : (5000030 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h1
      by_cases h2 : s.im ≤ (5000033 / 1000000 : ℝ)
      · have hmem : Cx.mem s S10 := by
          refine ⟨?_, ?_⟩
          · simp [S10, segBox, Iv.memR, hre]
          · simp [S10, segBox, Iv.memR]; exact ⟨h1', h2⟩
        exact zeta_ne_zero_S10 s hmem
      · have h2' : (5000033 / 1000000 : ℝ) ≤ s.im := le_of_not_ge h2
        have hmem : Cx.mem s S11 := by
          refine ⟨?_, ?_⟩
          · simp [S11, segBox, Iv.memR, hre]
          · simp [S11, segBox, Iv.memR]; exact ⟨h2', hhi⟩
        exact zeta_ne_zero_S11 s hmem

end FiniteWindowZeros
