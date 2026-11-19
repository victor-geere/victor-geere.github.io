import Mathlib

noncomputable section

open Complex
open MeasureTheory

namespace FiniteWindowZeros

private lemma tsum_rpow_neg_five_four_le_five :
    (∑' n : ℕ, (n : ℝ) ^ (-(5 / 4 : ℝ))) ≤ 5 := by
  set p : ℝ := -(5 / 4 : ℝ) with hp
  have hpneg : p < -1 := by rw [hp]; norm_num
  have hpne : p ≠ 0 := by rw [hp]; norm_num
  have hpnonpos : p ≤ 0 := by rw [hp]; norm_num
  have hanti : AntitoneOn (fun x : ℝ => x ^ p) (Set.Ici (((1 : ℕ) : ℝ))) := by
    refine (Real.antitoneOn_rpow_Ioi_of_exponent_nonpos hpnonpos).mono ?_
    intro x hx
    have hx1 : (1 : ℝ) ≤ x := by simpa using hx
    exact lt_of_lt_of_le zero_lt_one hx1
  have hInt : IntegrableOn (fun x : ℝ => x ^ p) (Set.Ioi (((1 : ℕ) : ℝ))) :=
    integrableOn_Ioi_rpow_of_lt (a := p) (c := ((1 : ℕ) : ℝ)) hpneg (by norm_num)
  have hnonneg : ∀ t ∈ Set.Ioi (((1 : ℕ) : ℝ)), 0 ≤ t ^ p := by
    intro t ht
    have ht1 : (1 : ℝ) < t := by simpa using ht
    exact Real.rpow_nonneg (le_of_lt (lt_trans zero_lt_one ht1)) _
  have htail : (∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ p)
      ≤ ∫ x in Set.Ioi (((1 : ℕ) : ℝ)), x ^ p :=
    AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ p) (N := 1)
      hanti hInt hnonneg
  have hint : (∫ x in Set.Ioi (((1 : ℕ) : ℝ)), x ^ p) = 4 := by
    rw [hp]
    rw [integral_Ioi_rpow_of_lt (a := -(5 / 4 : ℝ)) (c := ((1 : ℕ) : ℝ))
      (by norm_num) (by norm_num)]
    norm_num
  have htail2 : (∑' n : ℕ, ((n + 2 : ℕ) : ℝ) ^ p) ≤ 4 := by
    calc (∑' n : ℕ, ((n + 2 : ℕ) : ℝ) ^ p)
        = ∑' n : ℕ, ((n + 1 + 1 : ℕ) : ℝ) ^ p := by
          congr 1
      _ ≤ 4 := htail.trans_eq hint
  have hsumm : Summable (fun n : ℕ => (n : ℝ) ^ p) := by
    rw [hp]
    exact (Real.summable_nat_rpow (p := -(5 / 4 : ℝ))).mpr (by norm_num)
  have hdecomp := Summable.sum_add_tsum_nat_add
    (f := fun n : ℕ => (n : ℝ) ^ p) (k := 2) hsumm
  have h0 : ((0 : ℕ) : ℝ) ^ p = 0 := by
    simp [Real.zero_rpow hpne]
  have h1 : ((1 : ℕ) : ℝ) ^ p = 1 := by simp
  calc (∑' n : ℕ, (n : ℝ) ^ (-(5 / 4 : ℝ)))
      = ∑' n : ℕ, (n : ℝ) ^ p := by rw [hp]
    _ = (∑ i ∈ Finset.range 2, ((i : ℕ) : ℝ) ^ p)
          + (∑' n : ℕ, ((n + 2 : ℕ) : ℝ) ^ p) := hdecomp.symm
    _ = 1 + (∑' n : ℕ, ((n + 2 : ℕ) : ℝ) ^ p) := by
        norm_num [Finset.sum_range_succ, h0, h1]
    _ ≤ 1 + 4 := by gcongr
    _ = 5 := by norm_num

private lemma norm_LSeries_le_of_rpow_quarter
    {f : ℕ → ℂ} {C : ℝ} (hC : 0 ≤ C)
    (hf : ∀ n, n ≠ 0 → ‖f n‖ ≤ C * (n : ℝ) ^ (1 / 4 : ℝ))
    {s : ℂ} (hs : (3 / 2 : ℝ) ≤ s.re) :
    ‖LSeries f s‖ ≤ C * 5 := by
  have hterm : ∀ n : ℕ, ‖LSeries.term f s n‖ ≤ C * (n : ℝ) ^ (-(5 / 4 : ℝ)) := by
    intro n
    rcases eq_or_ne n 0 with h0 | hn
    · subst n
      simp [LSeries.term_zero, Real.zero_rpow (by norm_num : (-(5 / 4 : ℝ)) ≠ 0)]
    · have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hn1 : (1 : ℝ) ≤ (n : ℝ) := by
        exact_mod_cast Nat.one_le_iff_ne_zero.mpr hn
      rw [LSeries.term_of_ne_zero hn, norm_div,
        Complex.norm_natCast_cpow_of_pos (Nat.pos_of_ne_zero hn)]
      have hdenpos : 0 < (n : ℝ) ^ s.re := Real.rpow_pos_of_pos hnpos _
      rw [div_le_iff₀ hdenpos]
      have hexp : (1 / 4 : ℝ) ≤ -(5 / 4 : ℝ) + s.re := by linarith
      have hpow : (n : ℝ) ^ (1 / 4 : ℝ)
          ≤ (n : ℝ) ^ (-(5 / 4 : ℝ)) * (n : ℝ) ^ s.re := by
        calc (n : ℝ) ^ (1 / 4 : ℝ) ≤ (n : ℝ) ^ (-(5 / 4 : ℝ) + s.re) :=
              Real.rpow_le_rpow_of_exponent_le hn1 hexp
          _ = (n : ℝ) ^ (-(5 / 4 : ℝ)) * (n : ℝ) ^ s.re := by
              rw [Real.rpow_add hnpos]
      calc ‖f n‖ ≤ C * (n : ℝ) ^ (1 / 4 : ℝ) := hf n hn
        _ ≤ C * ((n : ℝ) ^ (-(5 / 4 : ℝ)) * (n : ℝ) ^ s.re) := by gcongr
        _ = C * (n : ℝ) ^ (-(5 / 4 : ℝ)) * (n : ℝ) ^ s.re := by ring
  have hmaj : Summable (fun n : ℕ => C * (n : ℝ) ^ (-(5 / 4 : ℝ))) := by
    have hsumnat : Summable (fun n : ℕ => (n : ℝ) ^ (-(5 / 4 : ℝ))) :=
      (Real.summable_nat_rpow (p := -(5 / 4 : ℝ))).mpr (by norm_num)
    exact hsumnat.mul_left C
  have hnormsumm : Summable (fun n : ℕ => ‖LSeries.term f s n‖) :=
    hmaj.of_nonneg_of_le (fun n => norm_nonneg _) hterm
  calc ‖LSeries f s‖ = ‖∑' n, LSeries.term f s n‖ := rfl
    _ ≤ ∑' n, ‖LSeries.term f s n‖ := norm_tsum_le_tsum_norm hnormsumm
    _ ≤ ∑' n : ℕ, C * (n : ℝ) ^ (-(5 / 4 : ℝ)) :=
        Summable.tsum_le_tsum hterm hnormsumm hmaj
    _ = C * ∑' n : ℕ, (n : ℝ) ^ (-(5 / 4 : ℝ)) := by rw [tsum_mul_left]
    _ ≤ C * 5 := by gcongr; exact tsum_rpow_neg_five_four_le_five

/-- The L-series of the von Mangoldt function is Lipschitz at `2` along the
imaginary direction, with an explicit constant. -/
theorem norm_LSeries_vonMangoldt_sub_two_le {y : ℝ} (hy : |y| ≤ (1 / 2 : ℝ)) :
    ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 + (y : ℂ) * Complex.I)
      - LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) 2‖ ≤ 200 * |y| := by
  have hy0 : |y| ≤ (1 / 2 : ℝ) := hy
  let Λc : ℕ → ℂ := fun n => (ArithmeticFunction.vonMangoldt n : ℂ)
  have hΛ_bound : ∀ n, n ≠ 0 → ‖Λc n‖ ≤ 4 * (n : ℝ) ^ (1 / 4 : ℝ) := by
    intro n hn
    have hnnonneg : (0 : ℝ) ≤ (n : ℝ) := by positivity
    have hΛle : (ArithmeticFunction.vonMangoldt n : ℝ) ≤ Real.log (n : ℝ) :=
      ArithmeticFunction.vonMangoldt_le_log
    have hlog : Real.log (n : ℝ) ≤ 4 * (n : ℝ) ^ (1 / 4 : ℝ) := by
      have h := Real.log_le_rpow_div (x := (n : ℝ)) (ε := (1 / 4 : ℝ)) hnnonneg
        (by norm_num)
      calc Real.log (n : ℝ) ≤ (n : ℝ) ^ (1 / 4 : ℝ) / (1 / 4 : ℝ) := h
        _ = 4 * (n : ℝ) ^ (1 / 4 : ℝ) := by ring
    have hnorm : ‖Λc n‖ = (ArithmeticFunction.vonMangoldt n : ℝ) := by
      simp [Λc]
    rw [hnorm]
    exact hΛle.trans hlog
  have hvalue : ∀ s : ℂ, (3 / 2 : ℝ) ≤ s.re → ‖LSeries Λc s‖ ≤ 20 := by
    intro s hs
    have h := norm_LSeries_le_of_rpow_quarter (f := Λc) (C := 4) (by norm_num) hΛ_bound hs
    norm_num at h ⊢
    exact h
  have habsc : LSeries.abscissaOfAbsConv Λc ≤ (5 / 4 : ℝ) := by
    have h := LSeries.abscissaOfAbsConv_le_of_le_const_mul_rpow (f := Λc)
      (x := (1 / 4 : ℝ)) ⟨4, hΛ_bound⟩
    have h' : (↑(1 / 4 : ℝ) : EReal) + 1 = (↑(5 / 4 : ℝ) : EReal) := by
      rw [← EReal.coe_one, ← EReal.coe_add]
      norm_num
    rw [h'] at h
    exact h
  have hdiff_U : DifferentiableOn ℂ (LSeries Λc) {z : ℂ | (5 / 4 : ℝ) < z.re} := by
    intro z hz
    have hzE : (↑(5 / 4 : ℝ) : EReal) < (z.re : EReal) := EReal.coe_lt_coe_iff.mpr hz
    exact (LSeries_hasDerivAt (f := Λc) (lt_of_le_of_lt habsc hzE)).differentiableAt
      |>.differentiableWithinAt
  have hdiff_ball : ∀ z : ℂ, z.re = 2 →
      DiffContOnCl ℂ (LSeries Λc) (Metric.ball z (1 / 2)) := by
    intro z hz
    refine DifferentiableOn.diffContOnCl_ball hdiff_U ?_
    intro w hw
    simp only [Metric.mem_closedBall, dist_eq_norm] at hw
    have hbound : |w.re - z.re| ≤ ‖w - z‖ := by
      have hre : w.re - z.re = (w - z).re := by simp
      rw [hre]
      exact Complex.abs_re_le_norm _
    have h1 : z.re - w.re ≤ 1 / 2 := by
      have := neg_abs_le (w.re - z.re)
      linarith
    rw [hz] at h1
    show (5 / 4 : ℝ) < w.re
    linarith
  have hsphere : ∀ z : ℂ, z.re = 2 →
      ∀ w ∈ Metric.sphere z (1 / 2), ‖LSeries Λc w‖ ≤ 20 := by
    intro z hz w hw
    apply hvalue w
    simp only [Metric.mem_sphere, dist_eq_norm] at hw
    have hbound : |w.re - z.re| ≤ ‖w - z‖ := by
      have hre : w.re - z.re = (w - z).re := by simp
      rw [hre]
      exact Complex.abs_re_le_norm _
    have h1 : z.re - w.re ≤ 1 / 2 := by
      have := neg_abs_le (w.re - z.re)
      linarith
    rw [hz] at h1
    linarith
  have hderiv_bound : ∀ z : ℂ, z.re = 2 → ‖deriv (LSeries Λc) z‖ ≤ 40 := by
    intro z hz
    have hR : (0 : ℝ) < 1 / 2 := by norm_num
    have h := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le
      (c := z) (R := 1 / 2) (C := 20) hR (hdiff_ball z hz) (hsphere z hz)
    norm_num at h ⊢
    exact h
  have hconv : Convex ℝ {z : ℂ | z.re = 2} := by
    have h := (convex_halfSpace_re_le (r := (2 : ℝ))).inter
      (convex_halfSpace_re_ge (r := (2 : ℝ)))
    convert h using 1
    ext z
    simp [le_antisymm_iff]
  have hdiff_line : ∀ z ∈ {z : ℂ | z.re = 2}, DifferentiableAt ℂ (LSeries Λc) z := by
    intro z hz
    have hz' : (5 / 4 : ℝ) < z.re := by
      rw [show z.re = 2 from hz]
      norm_num
    have hzE : (↑(5 / 4 : ℝ) : EReal) < (z.re : EReal) := EReal.coe_lt_coe_iff.mpr hz'
    exact (LSeries_hasDerivAt (f := Λc) (lt_of_le_of_lt habsc hzE)).differentiableAt
  have htwo_mem : (2 : ℂ) ∈ {z : ℂ | z.re = 2} := by simp
  have hpoint_mem : 2 + (y : ℂ) * Complex.I ∈ {z : ℂ | z.re = 2} := by simp
  have hmvt := Convex.norm_image_sub_le_of_norm_deriv_le
    (𝕜 := ℂ) (f := LSeries Λc) (s := {z : ℂ | z.re = 2}) (C := 40)
    hdiff_line (fun z hz => hderiv_bound z hz) hconv htwo_mem hpoint_mem
  have hdist : ‖(2 + (y : ℂ) * Complex.I) - 2‖ = |y| := by
    rw [show (2 + (y : ℂ) * Complex.I) - 2 = (y : ℂ) * Complex.I by ring]
    simp [Complex.norm_real]
  have h40 : ‖LSeries Λc (2 + (y : ℂ) * Complex.I) - LSeries Λc 2‖ ≤ 40 * |y| := by
    simpa [hdist] using hmvt
  have h200 : (40 : ℝ) * |y| ≤ 200 * |y| := by
    nlinarith [abs_nonneg y, hy0]
  exact h40.trans h200

end FiniteWindowZeros
