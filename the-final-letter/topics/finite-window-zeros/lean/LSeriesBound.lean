import Mathlib
import Hadamard

/-!
# A uniform bound for the L-series of the von Mangoldt function on `re s = 2`

The logarithmic derivative identity
`L Λ s = - ζ' s / ζ s` (valid for `re s > 1`) together with

* a lower bound `1/2 ≤ ‖ζ s‖`, obtained from `ζ s * L μ s = 1` and
  `‖L μ s‖ ≤ ∑ n⁻² ≤ 2`, and
* an upper bound `‖ζ' s‖ ≤ 6`, obtained from Cauchy's estimate on the circle
  of radius `1/2` around `s`, where `‖ζ‖ ≤ 3`,

gives `‖L Λ s‖ ≤ 12` on the line `re s = 2`.  We state the weaker explicit
bound `24`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Complex

namespace FiniteWindowZeros

open ArithmeticFunction

/-- The L-series of the von Mangoldt function is bounded by `24` on the line
`re s = 2`. -/
theorem norm_LSeries_vonMangoldt_two_le {y : ℝ} :
    ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
      (2 + (y : ℂ) * Complex.I)‖ ≤ 24 := by
  set s : ℂ := 2 + (y : ℂ) * Complex.I with hs_def
  have hsre : s.re = 2 := by simp [hs_def]
  have hs : 1 < s.re := by rw [hsre]; norm_num
  -- Step 1: rewrite the L-series as a logarithmic derivative of `ζ`.
  have hΛ : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s
      = - deriv riemannZeta s / riemannZeta s := by
    have h := ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div (s := s) hs
    simpa using h
  -- Step 2: `ζ s * L μ s = 1`.
  have hζμ : riemannZeta s * LSeries (fun n => (ArithmeticFunction.moebius n : ℂ)) s = 1 := by
    have h := LSeries_one_mul_Lseries_moebius (s := s) hs
    rwa [LSeries_one_eq_riemannZeta hs] at h
  -- Step 3: `‖L μ s‖ ≤ ∑ n⁻² ≤ 2`.
  have hμsumm : LSeriesSummable (fun n => (ArithmeticFunction.moebius n : ℂ)) s :=
    ArithmeticFunction.LSeriesSummable_moebius_iff.mpr hs
  have hμnormsumm :
      Summable (fun n => ‖LSeries.term (fun n => (ArithmeticFunction.moebius n : ℂ)) s n‖) :=
    summable_norm_iff.mpr hμsumm
  have hGsumm : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) :=
    (Real.summable_one_div_nat_pow (p := 2)).mpr (by norm_num)
  have hterm : ∀ n : ℕ,
      ‖LSeries.term (fun n => (ArithmeticFunction.moebius n : ℂ)) s n‖ ≤ 1 / (n : ℝ) ^ 2 := by
    intro n
    rcases eq_or_ne n 0 with h0 | hn
    · subst h0
      simp
    · rw [LSeries.term_of_ne_zero hn, norm_div,
        Complex.norm_natCast_cpow_of_pos (Nat.pos_of_ne_zero hn), hsre]
      have hμ : ‖((ArithmeticFunction.moebius n : ℤ) : ℂ)‖ ≤ 1 := by
        rw [Complex.norm_intCast]
        exact_mod_cast ArithmeticFunction.abs_moebius_le_one
      rw [show (2:ℝ) = ((2:ℕ):ℝ) by norm_num, Real.rpow_natCast]
      rw [div_le_div_iff_of_pos_right (by positivity : (0:ℝ) < (n:ℝ)^2)]
      exact hμ
  have hμL : ‖LSeries (fun n => (ArithmeticFunction.moebius n : ℂ)) s‖ ≤ 2 := by
    calc ‖LSeries (fun n => (ArithmeticFunction.moebius n : ℂ)) s‖
        = ‖∑' n : ℕ, LSeries.term (fun n => (ArithmeticFunction.moebius n : ℂ)) s n‖ := rfl
      _ ≤ ∑' n : ℕ, ‖LSeries.term (fun n => (ArithmeticFunction.moebius n : ℂ)) s n‖ :=
          norm_tsum_le_tsum_norm hμnormsumm
      _ ≤ ∑' n : ℕ, 1 / (n : ℝ) ^ 2 := Summable.tsum_le_tsum hterm hμnormsumm hGsumm
      _ ≤ 2 := AbsoluteHodgeHadamard.zeta_bound_tsum_one_div_sq_le_two
  -- Step 4: `1/2 ≤ ‖ζ s‖`.
  have hζ_lower : (1 / 2 : ℝ) ≤ ‖riemannZeta s‖ := by
    have hnorm : (1 : ℝ) = ‖riemannZeta s * LSeries (fun n => (ArithmeticFunction.moebius n : ℂ)) s‖ := by
      rw [hζμ, norm_one]
    rw [norm_mul] at hnorm
    have hle : ‖riemannZeta s‖ * ‖LSeries (fun n => (ArithmeticFunction.moebius n : ℂ)) s‖
        ≤ ‖riemannZeta s‖ * 2 := by
      gcongr
    nlinarith [norm_nonneg (riemannZeta s)]
  -- Step 5: `‖ζ' s‖ ≤ 6` by Cauchy's estimate on the circle of radius `1/2`.
  have hderiv : ‖deriv riemannZeta s‖ ≤ 6 := by
    have hR : (0 : ℝ) < 1 / 2 := by norm_num
    have hdiff : DiffContOnCl ℂ riemannZeta (Metric.ball s (1 / 2)) := by
      refine DifferentiableOn.diffContOnCl_ball (U := {w : ℂ | 1 < w.re}) ?_ ?_
      · refine differentiableOn_riemannZeta.mono ?_
        intro w hw
        simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
        rintro rfl
        simp at hw
      · intro w hw
        simp only [Metric.mem_closedBall, dist_eq_norm] at hw
        show 1 < w.re
        have hre : w.re - s.re = (w - s).re := by simp
        have hbound : |w.re - s.re| ≤ ‖w - s‖ := by
          rw [hre]
          exact Complex.abs_re_le_norm _
        have h1 : s.re - w.re ≤ 1 / 2 := by
          have := neg_abs_le (w.re - s.re)
          linarith
        rw [hsre] at h1
        linarith
    have hC : ∀ z ∈ Metric.sphere s (1 / 2), ‖riemannZeta z‖ ≤ 3 := by
      intro z hz
      apply AbsoluteHodgeHadamard.norm_riemannZeta_le_three_of_three_halves
      simp only [Metric.mem_sphere, dist_eq_norm] at hz
      have hre : z.re - s.re = (z - s).re := by simp
      have hbound : |z.re - s.re| ≤ ‖z - s‖ := by
        rw [hre]
        exact Complex.abs_re_le_norm _
      have h1 : s.re - z.re ≤ 1 / 2 := by
        have := neg_abs_le (z.re - s.re)
        linarith
      rw [hsre] at h1
      linarith
    have h := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le
      (c := s) (R := 1 / 2) (C := 3) hR hdiff hC
    norm_num at h ⊢
    exact h
  -- Step 6: assemble.
  calc ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s‖
      = ‖- deriv riemannZeta s / riemannZeta s‖ := by rw [hΛ]
    _ = ‖deriv riemannZeta s‖ / ‖riemannZeta s‖ := by simp
    _ ≤ 6 / (1 / 2) := by gcongr
    _ = 12 := by norm_num
    _ ≤ 24 := by norm_num

end FiniteWindowZeros
