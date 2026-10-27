import Cert

/-!
# A thin critical-line segment

The point certificate of `Cert.lean` extended to the rectangle
`1/2 + it`, `t ∈ [5, 5.000003]`.  The interval width is small enough that the
folded box still excludes zero.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail

/-- The thin critical-line segment. -/
def Sseg : Cx := ⟨⟨(1 / 2 : ℚ), (1 / 2 : ℚ)⟩, ⟨(5 : ℚ), (5000003 / 1000000 : ℚ)⟩⟩

theorem tail_bound_seg {s : ℂ} (hs : Cx.mem s Sseg) :
    ‖∑' m : ℕ, pairTerm s (m + 100)‖ ≤ (1 : ℝ) := by
  have hsre : s.re = (1 / 2 : ℝ) := by
    have h := hs.1
    simp [Sseg, Iv.memR] at h
    linarith [h.1, h.2]
  have hsim_lo : (5 : ℝ) ≤ s.im := by
    have h := hs.2
    simp [Sseg, Iv.memR] at h
    linarith [h.1]
  have hsim_hi : s.im ≤ (5.01 : ℝ) := by
    have h := hs.2
    simp [Sseg, Iv.memR] at h
    linarith [h.2]
  have h := norm_tsum_pairTerm_tail_le (s := s) (M := 100) (by rw [hsre]; norm_num)
  have hs_norm : ‖s‖ ≤ (5.1 : ℝ) := by
    have hsq : Complex.normSq s ≤ (5.1 : ℝ) ^ 2 := by
      rw [Complex.normSq_apply]
      nlinarith [sq_nonneg s.im]
    have hnn : (0:ℝ) ≤ Complex.normSq s := Complex.normSq_nonneg _
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

/-- `ζ(1/2+it) ≠ 0` on the certified segment. -/
theorem zeta_ne_zero_segment {s : ℂ} (hs : Cx.mem s Sseg) :
    riemannZeta s ≠ 0 := by
  have hsre : s.re = (1 / 2 : ℝ) := by
    have h := hs.1
    simp [Sseg, Iv.memR] at h
    linarith [h.1, h.2]
  have hsre_pos : (0 : ℝ) < s.re := by rw [hsre]; norm_num
  have hsim_lo : (5 : ℝ) ≤ s.im := by
    have h := hs.2
    simp [Sseg, Iv.memR] at h
    linarith [h.1]
  have hsne : s ≠ 1 := by
    intro h
    have him := congrArg Complex.im h
    rw [h] at hsim_lo
    norm_num at hsim_lo
  have hcond : ∀ p ∈ params 100, PairConditions p Sseg :=
    allOK_conditions (by native_decide)
  have hsum : Cx.mem (sumValue (params 100) s) (sumBox (params 100) Sseg) :=
    sumBox_mem (params 100) Sseg s hs hcond
  have hsum_eq : sumValue (params 100) s =
      ∑ m ∈ Finset.range 100, pairTerm s m :=
    sumValue_params 100 s
  have hsummable : Summable (fun m : ℕ => pairTerm s m) :=
    summable_pairTerm (by rw [hsre]; norm_num)
  have hdecomp : etaGrouped s = sumValue (params 100) s +
      ∑' m : ℕ, pairTerm s (m + 100) := by
    rw [etaGrouped, ← hsummable.sum_add_tsum_nat_add 100, ← hsum_eq]
  let B : Cx := (sumBox (params 100) Sseg).add (PartialTail.ball (1 : ℚ))
  have htail : Cx.mem (∑' m : ℕ, pairTerm s (m + 100)) (PartialTail.ball (1 : ℚ)) :=
    PartialTail.mem_ball_of_norm_le (by norm_num) (by simpa using tail_bound_seg hs)
  have hB : Cx.mem (etaGrouped s) B := by
    rw [hdecomp]
    exact Cx.mem_add hsum htail
  have hzero : ¬ Cx.mem (0 : ℂ) B := by
    have hz : containsZero B = false := by native_decide
    intro h
    have htrue := (containsZero_iff B).mpr h
    rw [hz] at htrue
    exact Bool.false_ne_true htrue
  exact zeta_ne_zero_of_eta_mem (U := {z : ℂ | Cx.mem z B}) hsre_pos hsne hB hzero

end FiniteWindowZeros
