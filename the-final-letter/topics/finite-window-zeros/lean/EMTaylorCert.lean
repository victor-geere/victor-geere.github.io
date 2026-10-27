import EMTaylor

/-!
# The `c_k` bounds for the Taylor model of `h2`

`h2` is proved by a Taylor model of `ζ′` on the closed `1/5`-ball at `s14`
(design in `research-journal-003.md` §2b).  This file supplies the coefficient
bounds: `ζ = gen₃ + R₃` (`iteratedDeriv_zeta_eq_gen3_add`), the `R₃` derivatives
by Cauchy's estimate on the `1/2`-ball, and hence

`‖c_k‖ = ‖ζ^{(k)}(s14)/k!‖ ≤ 0.351, 0.103, 0.025, 0.007, 0.006`  for `k = 2..6`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros
open PartialTail
open Filter Topology

/-! ## Analyticity and smoothness -/

theorem analyticAt_riemannZeta_s14 : AnalyticAt ℂ riemannZeta s14 := by
  have hd : DifferentiableOn ℂ riemannZeta (Metric.ball s14 (1 / 2)) := by
    intro z hz
    exact (differentiableAt_riemannZeta (ne_one_of_ball_half (mem_ball_half.mp hz))).differentiableWithinAt
  exact (hd.analyticOnNhd Metric.isOpen_ball) s14 (Metric.mem_ball_self (by norm_num))

theorem analyticAt_iteratedDeriv_zeta_s14 (m : ℕ) :
    AnalyticAt ℂ (iteratedDeriv m riemannZeta) s14 := by
  induction m with
  | zero => simpa [iteratedDeriv_zero] using analyticAt_riemannZeta_s14
  | succ m ih =>
      rw [iteratedDeriv_succ]
      exact ih.deriv

theorem contDiffAt_gen3 {s : ℂ} (hs : s ≠ 1) (n : WithTop ℕ∞) :
    ContDiffAt ℂ n (zetaEMGen 3 20) s := by
  have hsum : ContDiffAt ℂ n
      (fun z : ℂ => ∑ k ∈ Finset.range 20, ((((k + 1 : ℝ)) : ℂ) ^ (-z))) s := by
    apply ContDiffAt.sum
    intro k hk
    refine contDiffAt_cpow_neg _ ?_ n s
    intro hzero
    have hre := congrArg Complex.re hzero
    rw [Complex.ofReal_re, Complex.zero_re] at hre
    have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    linarith
  have hprod : ContDiffAt ℂ n (fun z : ℂ => (21 : ℂ) ^ (-z) * Psi3 z) s :=
    (contDiffAt_cpow_neg 21 (by norm_num) n s).mul (contDiffAt_Psi3 n hs)
  rw [show (zetaEMGen 3 20 : ℂ → ℂ) = fun z : ℂ =>
      (∑ k ∈ Finset.range 20, ((((k + 1 : ℝ)) : ℂ) ^ (-z))) + (21 : ℂ) ^ (-z) * Psi3 z from
    funext gen3_eq_sum_psi]
  exact hsum.add hprod

theorem analyticAt_zetaEM_twenty : AnalyticAt ℂ (zetaEM 20) s14 := by
  have hd : DifferentiableOn ℂ (zetaEM 20) (Metric.ball s14 (1 / 2)) :=
    (differentiableOn_zetaEM 20).mono (fun z hz => by
      exact ⟨re_pos_of_ball_half (mem_ball_half.mp hz),
        ne_one_of_ball_half (mem_ball_half.mp hz)⟩)
  exact (hd.analyticOnNhd Metric.isOpen_ball) s14 (Metric.mem_ball_self (by norm_num))

theorem contDiffAt_remainder (n : WithTop ℕ∞) :
    ContDiffAt ℂ n (zetaEMRemainder 3 20) s14 := by
  have h := analyticAt_zetaEM_twenty.contDiffAt.sub (contDiffAt_gen3 s14_ne_one n)
  have hfun : zetaEMRemainder 3 20 = fun s => zetaEM 20 s - zetaEMGen 3 20 s := by
    funext s
    rw [zetaEMRemainder]
  rw [hfun]
  exact h

/-! ## The derivative split `ζ = gen₃ + R₃` -/

theorem iteratedDeriv_zeta_eq_gen3_add (k : ℕ) :
    iteratedDeriv k riemannZeta s14 =
      iteratedDeriv k (zetaEMGen 3 20) s14 + iteratedDeriv k (zetaEMRemainder 3 20) s14 := by
  have heq : riemannZeta =ᶠ[𝓝 s14]
      (fun s => zetaEMGen 3 20 s + zetaEMRemainder 3 20 s) := by
    filter_upwards [Metric.ball_mem_nhds s14 (by norm_num : (0 : ℝ) < 1 / 2)] with z hz
    have hz' : ‖z - s14‖ < 1 / 2 := by simpa [dist_eq_norm] using hz
    have hζ := zeta_eq_zetaEM_of_im 20 (re_pos_of_ball_half hz')
      (im_bounds_of_ball_half hz').1 (im_bounds_of_ball_half hz').2
    rw [hζ, zetaEMRemainder]
    ring
  rw [heq.iteratedDeriv_eq k]
  exact iteratedDeriv_add (contDiffAt_gen3 s14_ne_one k) (contDiffAt_remainder k)

/-! ## Cauchy estimate for the remainder -/

theorem diffContOnCl_remainder :
    DiffContOnCl ℂ (zetaEMRemainder 3 20) (Metric.ball s14 (49 / 100)) := by
  apply DifferentiableOn.diffContOnCl
  rw [closure_ball s14 (by norm_num : (49 / 100 : ℝ) ≠ 0)]
  intro z hz
  have hz' : ‖z - s14‖ < 1 / 2 := by
    have h : ‖z - s14‖ ≤ 49 / 100 := by
      simpa [Metric.mem_closedBall, dist_eq_norm] using hz
    linarith
  have hne : z ≠ 1 := ne_one_of_ball_half hz'
  have hzb : z ∈ Metric.ball s14 (1 / 2) := by
    simp only [Metric.mem_ball, dist_eq_norm]
    exact hz'
  have hmono : DifferentiableOn ℂ (zetaEM 20) (Metric.ball s14 (1 / 2)) :=
    (differentiableOn_zetaEM 20).mono (fun w hw => by
      exact ⟨re_pos_of_ball_half (mem_ball_half.mp hw),
        ne_one_of_ball_half (mem_ball_half.mp hw)⟩)
  have h1 : DifferentiableAt ℂ (zetaEM 20) z :=
    hmono.differentiableAt (Metric.isOpen_ball.mem_nhds hzb)
  have h2 : DifferentiableAt ℂ (zetaEMGen 3 20) z :=
    (contDiffAt_gen3 hne (1 : WithTop ℕ∞)).differentiableAt (by simp)
  exact (h1.sub h2).differentiableWithinAt

/-! ## Cauchy estimate for the remainder, and the `c_k` bounds -/

theorem norm_iteratedDeriv_remainder_le (k : ℕ) :
    ‖iteratedDeriv k (zetaEMRemainder 3 20) s14‖ ≤
      (k.factorial : ℝ) * (6 / 100000) / (49 / 100) ^ k := by
  have hR : (0 : ℝ) < 49 / 100 := by norm_num
  have h := Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le
    (f := zetaEMRemainder 3 20) (c := s14) (R := 49 / 100) (C := 6 / 100000)
    k hR diffContOnCl_remainder (fun z hz => by
      have hz' : ‖z - s14‖ = 49 / 100 := by
        simpa [Metric.mem_sphere, dist_eq_norm] using hz
      exact norm_remainder_three_ball_le (by rw [hz']; norm_num))
  simpa using h

theorem norm_c_k_le (k : ℕ) {q : ℝ}
    (hq : ‖iteratedDeriv k (zetaEMGen 3 20) s14‖ ≤ q) :
    ‖iteratedDeriv k riemannZeta s14 / (((k.factorial : ℕ)) : ℂ)‖ ≤
      q / (k.factorial : ℝ) + (6 / 100000) / (49 / 100) ^ k := by
  have hfacpos : (0 : ℝ) < (k.factorial : ℝ) := by positivity
  have hfac : ‖(((k.factorial : ℕ)) : ℂ)‖ = (k.factorial : ℝ) := by
    rw [Complex.norm_natCast]
  have hsplit := iteratedDeriv_zeta_eq_gen3_add k
  have hR3 := norm_iteratedDeriv_remainder_le k
  rw [hsplit, norm_div, hfac]
  have h1 : ‖iteratedDeriv k (zetaEMGen 3 20) s14‖ / (k.factorial : ℝ) ≤
      q / (k.factorial : ℝ) :=
    div_le_div_of_nonneg_right hq (le_of_lt hfacpos)
  have h2 : ‖iteratedDeriv k (zetaEMRemainder 3 20) s14‖ / (k.factorial : ℝ) ≤
      (6 / 100000) / (49 / 100) ^ k := by
    rw [div_le_iff₀ hfacpos]
    calc ‖iteratedDeriv k (zetaEMRemainder 3 20) s14‖
        ≤ (k.factorial : ℝ) * (6 / 100000) / (49 / 100) ^ k := hR3
      _ = (6 / 100000) / (49 / 100) ^ k * (k.factorial : ℝ) := by ring
  calc ‖iteratedDeriv k (zetaEMGen 3 20) s14 + iteratedDeriv k (zetaEMRemainder 3 20) s14‖
        / (k.factorial : ℝ)
      ≤ (‖iteratedDeriv k (zetaEMGen 3 20) s14‖
          + ‖iteratedDeriv k (zetaEMRemainder 3 20) s14‖) / (k.factorial : ℝ) :=
        div_le_div_of_nonneg_right (norm_add_le _ _) (le_of_lt hfacpos)
    _ = ‖iteratedDeriv k (zetaEMGen 3 20) s14‖ / (k.factorial : ℝ)
          + ‖iteratedDeriv k (zetaEMRemainder 3 20) s14‖ / (k.factorial : ℝ) := by
        rw [add_div]
    _ ≤ q / (k.factorial : ℝ) + (6 / 100000) / (49 / 100) ^ k := add_le_add h1 h2

/-- `|c₂| = |ζ″(s14)|/2 ≤ 0.351` (true `0.3189`). -/
theorem norm_c_two :
    ‖iteratedDeriv 2 riemannZeta s14 / ((Nat.factorial 2 : ℕ) : ℂ)‖ ≤ (351 / 1000 : ℝ) := by
  have h := norm_c_k_le 2 (q := ((70 / 100 : ℚ) : ℝ)) norm_gen3_deriv_two
  refine le_trans h ?_
  norm_num

/-- `|c₃| ≤ 0.103` (true `0.09176`). -/
theorem norm_c_three :
    ‖iteratedDeriv 3 riemannZeta s14 / ((Nat.factorial 3 : ℕ) : ℂ)‖ ≤ (103 / 1000 : ℝ) := by
  have h := norm_c_k_le 3 (q := ((61 / 100 : ℚ) : ℝ)) norm_gen3_deriv_three
  refine le_trans h ?_
  norm_num

/-- `|c₄| ≤ 0.025` (true `0.02086`). -/
theorem norm_c_four :
    ‖iteratedDeriv 4 riemannZeta s14 / ((Nat.factorial 4 : ℕ) : ℂ)‖ ≤ (25 / 1000 : ℝ) := by
  have h := norm_c_k_le 4 (q := ((55 / 100 : ℚ) : ℝ)) norm_gen3_deriv_four
  refine le_trans h ?_
  norm_num

/-- `|c₅| ≤ 0.007` (true `0.003991`). -/
theorem norm_c_five :
    ‖iteratedDeriv 5 riemannZeta s14 / ((Nat.factorial 5 : ℕ) : ℂ)‖ ≤ (7 / 1000 : ℝ) := by
  have h := norm_c_k_le 5 (q := ((53 / 100 : ℚ) : ℝ)) norm_gen3_deriv_five
  refine le_trans h ?_
  norm_num

/-- `|c₆| ≤ 0.006` (true `0.0006669`). -/
theorem norm_c_six :
    ‖iteratedDeriv 6 riemannZeta s14 / ((Nat.factorial 6 : ℕ) : ℂ)‖ ≤ (6 / 1000 : ℝ) := by
  have h := norm_c_k_le 6 (q := ((53 / 100 : ℚ) : ℝ)) norm_gen3_deriv_six
  refine le_trans h ?_
  norm_num

/-! ## Geometry of the closed `1/5`-ball -/

theorem norm_le_fifteen_of_ball_fifth {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) : ‖z‖ ≤ 15 := by
  have h2 : ‖s14‖ ≤ (14.5 : ℝ) := norm_s14_le
  calc ‖z‖ = ‖(z - s14) + s14‖ := by rw [sub_add_cancel]
    _ ≤ ‖z - s14‖ + ‖s14‖ := norm_add_le _ _
    _ ≤ 1 / 5 + 14.5 := by linarith
    _ ≤ 15 := by norm_num

theorem re_nonneg_of_ball_fifth {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) : 0 ≤ z.re := by
  have h := Complex.abs_re_le_norm (z - s14)
  rw [Complex.sub_re] at h
  have hsre : s14.re = (1 / 2 : ℝ) := by norm_num [s14]
  rw [hsre] at h
  have := (abs_le.mp (le_trans h hz)).1
  linarith

theorem norm_sub_one_ge_of_ball_fifth {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    (13 : ℝ) ≤ ‖z - 1‖ := by
  have h14 : (14 : ℝ) ≤ ‖s14 - 1‖ := by
    have hsq : ‖s14 - 1‖ ^ 2 = (785 : ℝ) / 4 := by
      rw [← Complex.normSq_eq_norm_sq]
      simp [s14, Complex.normSq_apply]
      norm_num
    have hnn : (0 : ℝ) ≤ ‖s14 - 1‖ := norm_nonneg _
    nlinarith
  have h := norm_sub_norm_le (s14 - 1) (s14 - z)
  have hzb : ‖s14 - z‖ = ‖z - s14‖ := norm_sub_rev s14 z
  rw [hzb] at h
  rw [show z - 1 = (s14 - 1) - (s14 - z) by ring]
  linarith

theorem ne_one_of_ball_fifth {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) : z ≠ 1 := by
  intro h
  have h13 := norm_sub_one_ge_of_ball_fifth hz
  rw [h] at h13
  norm_num at h13

/-! ## Upper bounds for `log n` and `log 21`, from the certified `log` boxes -/

theorem norm_ofReal_eq (x : ℝ) : ‖((x : ℂ))‖ = |x| := by simp

theorem log_natCast_le_logIvRat (n : ℕ) (hn : 1 ≤ n) :
    Real.log (n : ℝ) ≤ (((logIvRat 20 n).hi : ℚ) : ℝ) :=
  (logIvRat_mem (N := 20) hn).2

theorem log21_le : Real.log 21 ≤ (61 / 20 : ℝ) := by
  have h := (logIvRat_mem (N := 20) (b := 21) (by norm_num)).2
  have h2 : (logIvRat 20 21).hi ≤ (61 / 20 : ℚ) := by native_decide
  have h3 : (((logIvRat 20 21).hi : ℚ) : ℝ) ≤ ((61 / 20 : ℚ) : ℝ) := by exact_mod_cast h2
  have h4 : ((61 / 20 : ℚ) : ℝ) = (61 / 20 : ℝ) := by norm_num
  calc Real.log 21 ≤ (((logIvRat 20 21).hi : ℚ) : ℝ) := h
    _ ≤ ((61 / 20 : ℚ) : ℝ) := h3
    _ = (61 / 20 : ℝ) := h4

theorem log21_pow_le (i : ℕ) : (Real.log 21) ^ i ≤ ((61 / 20 : ℝ)) ^ i :=
  pow_le_pow_left₀ (Real.log_nonneg (by norm_num)) log21_le i

theorem base_seven_sum_le :
    (∑ n ∈ Finset.range 20, ((logIvRat 20 (n + 1)).hi : ℚ) ^ 7) ≤ (13189 : ℚ) := by
  native_decide

/-! ## The base-sum bound on the ball -/

theorem base_sum_cast_z (k : ℕ) (z : ℂ) :
    (∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℝ)) : ℂ))) ^ k * ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
      = ∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ k * ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-z)) := by
  apply Finset.sum_congr rfl
  intro n hn
  have hc : ((((n + 1 : ℕ) : ℝ)) : ℂ) = ((((n + 1 : ℝ)) : ℂ)) := by push_cast; ring
  rw [hc]

theorem norm_base_seven_le {z : ℂ} (hre : 0 ≤ z.re) :
    ‖∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ 7 * ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-z))‖
      ≤ (13189 : ℝ) := by
  refine (norm_sum_le _ _).trans ?_
  have hterm : ∀ n ∈ Finset.range 20,
      ‖(-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ 7 * ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-z))‖
        ≤ (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7 := by
    intro n hn
    have hb1 : (1 : ℝ) ≤ ((n + 1 : ℕ) : ℝ) := by
      exact_mod_cast Nat.succ_le_succ (Nat.zero_le n)
    have hbpos : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by linarith
    have hlogeq : Complex.log ((((n + 1 : ℕ) : ℝ)) : ℂ)
        = ((Real.log ((n + 1 : ℕ) : ℝ) : ℝ) : ℂ) :=
      (Complex.ofReal_log (le_of_lt hbpos)).symm
    simp only [norm_mul, norm_pow, norm_neg, hlogeq, RCLike.norm_ofReal,
      Complex.norm_cpow_eq_rpow_re_of_pos hbpos, norm_ofReal_eq,
      abs_of_nonneg (Real.log_nonneg hb1)]
    have hexp : (-z).re ≤ 0 := by
      simp only [Complex.neg_re]
      linarith
    have hpow1 : ((n + 1 : ℕ) : ℝ) ^ (-z).re ≤ 1 := by
      calc ((n + 1 : ℕ) : ℝ) ^ (-z).re ≤ ((n + 1 : ℕ) : ℝ) ^ (0 : ℝ) :=
            Real.rpow_le_rpow_of_exponent_le hb1 hexp
        _ = 1 := Real.rpow_zero _
    have hlog7 : (Real.log ((n + 1 : ℕ) : ℝ)) ^ 7
        ≤ (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7 :=
      pow_le_pow_left₀ (Real.log_nonneg hb1)
        (log_natCast_le_logIvRat (n + 1) (by omega)) 7
    have hhi : (0 : ℝ) ≤ (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) :=
      le_trans (Real.log_nonneg hb1) (log_natCast_le_logIvRat (n + 1) (by omega))
    have hbase : (0 : ℝ) ≤ ((n + 1 : ℕ) : ℝ) := le_of_lt hbpos
    have hmid : (0 : ℝ) ≤ ((n + 1 : ℕ) : ℝ) ^ (-z).re := Real.rpow_nonneg hbase _
    have hright : (0 : ℝ) ≤ (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7 := pow_nonneg hhi 7
    calc (Real.log ((n + 1 : ℕ) : ℝ)) ^ 7 * ((n + 1 : ℕ) : ℝ) ^ (-z).re
        ≤ (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7 * 1 :=
          mul_le_mul hlog7 hpow1 hmid hright
      _ = (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7 := by ring
  refine (Finset.sum_le_sum hterm).trans ?_
  have hcast : (∑ n ∈ Finset.range 20, (((logIvRat 20 (n + 1)).hi : ℚ) : ℝ) ^ 7)
      = (((∑ n ∈ Finset.range 20, ((logIvRat 20 (n + 1)).hi : ℚ) ^ 7) : ℚ) : ℝ) := by
    push_cast
    rfl
  rw [hcast]
  have h := base_seven_sum_le
  exact_mod_cast h

end FiniteWindowZeros
