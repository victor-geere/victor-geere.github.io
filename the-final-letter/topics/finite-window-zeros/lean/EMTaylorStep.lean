import EMTaylorH2

/-!
# The Taylor remainder step: `h2` and the certified zero

`EMTaylorH2.lean` reduced `h2` to a single estimate on the Taylor remainder of `ζ′`
at `s14` (journal I.314).  This file supplies that estimate and closes the
programme.

1. **The chain rule.**  `iteratedDeriv k (fun t : ℝ => f (s14 + ↑t · w)) =
   f^{(k)}(s14 + ↑t · w) · w^k`, first as a first-derivative statement
   (`hasDerivAt_comp_ofReal_mul`), then by induction for all `k`
   (`iteratedDeriv_comp_ofReal_mul`).
2. **The supremum bound** `‖ζ^{(7)}‖ ≤ 43393` on the closed `1/5`-ball, assembled
   from the three proved pieces of journal I.315: the base sum `≤ 13189`
   (`norm_base_seven_le`), the `21`-part `≤ 25204` (from `norm_iteratedDeriv_Psi3_le`
   and `log21_le`), and the Euler–Maclaurin remainder `≤ 5000` (Cauchy on the
   `1/4`-ball).
3. **The Taylor remainder** from `taylor_mean_remainder_bound` (`n = 5`, `[0,1]`,
   `sup|ζ^{(7)}| ≤ 43393`): `‖ζ′(z) − taylorPoly (z − s14)‖ ≤ 24/1000` on the
   closed `1/5`-ball.  This is `0.0232`, inside the `34/1000` remainder budget
   `47/250 − 154/1000`, but *above* the `14/1000` threshold hard-coded in
   `EMTaylorH2.h2_of_taylor_remainder` (that constant was set for
   `sup|ζ^{(7)}| ≤ 25000`, which I.315 refined to `43393`); hence the restated
   `h2_of_taylor_remainder_wide` below.
4. **Assembly.**  `h2_deriv`, and `zeta_zero_14` with `h1_deriv`:

   `zeta_zero_14 : ∃ z ∈ closedBall s14 (1/5), riemannZeta z = 0`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology

/-! ## 1. The chain rule for `t ↦ f (s14 + t·w)` -/

/-- The derivative in `t` of `t ↦ f (z + t·w)` is `f′(z + t·w)·w`. -/
theorem hasDerivAt_comp_ofReal_mul (f : ℂ → ℂ) (z w : ℂ) (t : ℝ)
    (hf : DifferentiableAt ℂ f (z + (t : ℂ) * w)) :
    HasDerivAt (fun s : ℝ => f (z + (s : ℂ) * w))
      (deriv f (z + (t : ℂ) * w) * w) t := by
  have h₂ : HasDerivAt (fun u : ℂ => z + u * w) w (t : ℂ) :=
    (hasDerivAt_mul_const w).const_add z
  have h₃ : HasDerivAt (fun u : ℂ => f (z + u * w))
      (deriv f (z + (t : ℂ) * w) * w) (t : ℂ) :=
    HasDerivAt.comp ((t : ℂ)) hf.hasDerivAt h₂
  exact h₃.comp_ofReal

/-- The `m`-th iterated derivative of a `C^{m+1}` function is differentiable. -/
theorem differentiableAt_iteratedDeriv_of_contDiffAt {f : ℂ → ℂ} {x : ℂ} {m : ℕ}
    (hf : ContDiffAt ℂ (((m + 1 : ℕ)) : WithTop ℕ∞) f x) :
    DifferentiableAt ℂ (iteratedDeriv m f) x := by
  obtain ⟨u, hu, hud⟩ := hf.contDiffOn (m := (((m + 1 : ℕ)) : WithTop ℕ∞)) le_rfl (by simp)
  obtain ⟨v, hvu, hvopen, hxv⟩ := mem_nhds_iff.mp hu
  have hvu' : ContDiffOn ℂ (((m + 1 : ℕ)) : WithTop ℕ∞) f v := hud.mono hvu
  have hdiff : DifferentiableOn ℂ (iteratedDerivWithin m f v) v :=
    hvu'.differentiableOn_iteratedDerivWithin
      (WithTop.coe_lt_coe.mpr (Nat.cast_lt.mpr (Nat.lt_succ_self m))) hvopen.uniqueDiffOn
  have hEq : Set.EqOn (iteratedDerivWithin m f v) (iteratedDeriv m f) v :=
    iteratedDerivWithin_of_isOpen hvopen
  have h1 : DifferentiableAt ℂ (iteratedDerivWithin m f v) x :=
    hdiff.differentiableAt (hvopen.mem_nhds hxv)
  exact DifferentiableAt.congr_of_eventuallyEq h1
    (hEq.eventuallyEq_of_mem (hvopen.mem_nhds hxv)).symm

/-- **The chain rule**, iterated form:
`iteratedDeriv k (fun t : ℝ => f (z + t·w)) t = f^{(k)}(z + t·w)·w^k`. -/
theorem iteratedDeriv_comp_ofReal_mul (f : ℂ → ℂ) (z w : ℂ) (k : ℕ) (t : ℝ)
    (hf : ContDiffAt ℂ (((k + 1 : ℕ)) : WithTop ℕ∞) f (z + (t : ℂ) * w)) :
    iteratedDeriv k (fun s : ℝ => f (z + (s : ℂ) * w)) t
      = iteratedDeriv k f (z + (t : ℂ) * w) * w ^ k := by
  induction k generalizing t with
  | zero => simp
  | succ k ih =>
      have hcont : Continuous (fun s : ℝ => z + (s : ℂ) * w) := by fun_prop
      have hk1 : ContDiffAt ℂ (((k + 1 : ℕ)) : WithTop ℕ∞) f (z + (t : ℂ) * w) :=
        hf.of_le (by simp)
      have hev : ∀ᶠ s : ℝ in 𝓝 t, ContDiffAt ℂ (((k + 1 : ℕ)) : WithTop ℕ∞) f (z + (s : ℂ) * w) := by
        have h1 : ∀ᶠ y in 𝓝 (z + (t : ℂ) * w), ContDiffAt ℂ (((k + 1 : ℕ)) : WithTop ℕ∞) f y :=
          (hk1.eventually (by simp)).mono
            (fun y hy => hy.of_le (by simp))
        exact (hcont.tendsto t).eventually h1
      have hEq : iteratedDeriv k (fun s : ℝ => f (z + (s : ℂ) * w))
          =ᶠ[𝓝 t] fun s : ℝ => iteratedDeriv k f (z + (s : ℂ) * w) * w ^ k :=
        hev.mono fun s hs => ih s hs
      have hdiff : DifferentiableAt ℂ (iteratedDeriv k f) (z + (t : ℂ) * w) :=
        differentiableAt_iteratedDeriv_of_contDiffAt hk1
      have hA := hasDerivAt_comp_ofReal_mul (iteratedDeriv k f) z w t hdiff
      have hB := hA.mul_const (w ^ k)
      rw [iteratedDeriv_succ, hEq.deriv_eq, hB.deriv, ← iteratedDeriv_succ]
      ring


/-! ## 2. The supremum bound `‖ζ^{(7)}‖ ≤ 43393` on the closed `1/5`-ball -/

theorem analyticAt_riemannZeta_ball {z : ℂ} (hz : ‖z - s14‖ < (1 / 2 : ℝ)) :
    AnalyticAt ℂ riemannZeta z := by
  have hd : DifferentiableOn ℂ riemannZeta (Metric.ball s14 (1 / 2)) := by
    intro w hw
    exact (differentiableAt_riemannZeta
      (ne_one_of_ball_half (mem_ball_half.mp hw))).differentiableWithinAt
  exact (hd.analyticOnNhd Metric.isOpen_ball) z (mem_ball_half.mpr hz)

theorem analyticAt_iteratedDeriv_zeta_ball (m : ℕ) {z : ℂ} (hz : ‖z - s14‖ < (1 / 2 : ℝ)) :
    AnalyticAt ℂ (iteratedDeriv m riemannZeta) z := by
  induction m with
  | zero => simpa [iteratedDeriv_zero] using analyticAt_riemannZeta_ball hz
  | succ m ih => rw [iteratedDeriv_succ]; exact ih.deriv

theorem analyticAt_deriv_zeta_ball {z : ℂ} (hz : ‖z - s14‖ < (1 / 2 : ℝ)) :
    AnalyticAt ℂ (deriv riemannZeta) z := by
  have h := analyticAt_iteratedDeriv_zeta_ball 1 hz
  rwa [iteratedDeriv_one] at h

/-- The numeric content of the `21`-part bound (journal I.315): dominated by the
`i = 7` term `(61/20)⁷·8`. -/
theorem psi_part_rat_le :
    (∑ i ∈ Finset.range 8, (((Nat.choose 7 i : ℕ) : ℚ) * (61 / 20 : ℚ) ^ i
        * (((7 - i).factorial : ℚ) * 8 / (10 : ℚ) ^ (7 - i)))) ≤ (25204 : ℚ) := by
  native_decide

theorem norm_psi_part_seven_le {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    ‖∑ i ∈ Finset.range 8,
        ((Nat.choose 7 i : ℕ) : ℂ) * ((-Complex.log 21) ^ i * (21 : ℂ) ^ (-z))
          * iteratedDeriv (7 - i) Psi3 z‖ ≤ (25204 : ℝ) := by
  refine (norm_sum_le _ _).trans ?_
  have hterm : ∀ i ∈ Finset.range 8,
      ‖((Nat.choose 7 i : ℕ) : ℂ) * ((-Complex.log 21) ^ i * (21 : ℂ) ^ (-z))
          * iteratedDeriv (7 - i) Psi3 z‖
        ≤ ((Nat.choose 7 i : ℕ) : ℝ) * ((61 / 20 : ℝ) ^ i)
            * (((7 - i).factorial : ℝ) * 8 / (10 : ℝ) ^ (7 - i)) := by
    intro i hi
    have hlog21 : Complex.log (21 : ℂ) = ((Real.log 21 : ℝ) : ℂ) := by
      exact (Complex.ofReal_log (x := (21 : ℝ)) (by norm_num)).symm
    have hlog : ‖(-Complex.log (21 : ℂ)) ^ i‖ = (Real.log 21) ^ i := by
      rw [hlog21, norm_pow, norm_neg, norm_ofReal_eq,
        abs_of_nonneg (Real.log_nonneg (by norm_num))]
    have hlogle : (Real.log 21) ^ i ≤ ((61 / 20 : ℝ)) ^ i := log21_pow_le i
    have h21 : ‖(21 : ℂ) ^ (-z)‖ ≤ 1 := by
      rw [show (21 : ℂ) = ((21 : ℝ) : ℂ) by norm_num]
      rw [norm_cpow_neg_ofReal (s := z) (x := 21) (by norm_num)]
      exact Real.rpow_le_one_of_one_le_of_nonpos (by norm_num)
        (by linarith [re_nonneg_of_ball_fifth hz])
    have hPsi := norm_iteratedDeriv_Psi3_le (7 - i) hz
    calc ‖((Nat.choose 7 i : ℕ) : ℂ) * ((-Complex.log 21) ^ i * (21 : ℂ) ^ (-z))
            * iteratedDeriv (7 - i) Psi3 z‖
        = ((Nat.choose 7 i : ℕ) : ℝ) * (‖(-Complex.log 21) ^ i‖ * ‖(21 : ℂ) ^ (-z)‖)
            * ‖iteratedDeriv (7 - i) Psi3 z‖ := by
          rw [norm_mul, norm_mul, norm_mul, Complex.norm_natCast]
      _ ≤ ((Nat.choose 7 i : ℕ) : ℝ) * (((61 / 20 : ℝ) ^ i) * 1)
            * (((7 - i).factorial : ℝ) * 8 / (10 : ℝ) ^ (7 - i)) := by
          have hA : (0 : ℝ) ≤ ((Nat.choose 7 i : ℕ) : ℝ) := by positivity
          have hBC : ‖(-Complex.log 21) ^ i‖ * ‖(21 : ℂ) ^ (-z)‖
              ≤ ((61 / 20 : ℝ) ^ i) * 1 := by
            apply mul_le_mul
            · rw [hlog]; exact hlogle
            · exact h21
            · positivity
            · exact pow_nonneg (by norm_num) i
          exact mul_le_mul (mul_le_mul_of_nonneg_left hBC hA) hPsi (norm_nonneg _)
            (mul_nonneg hA (mul_nonneg (pow_nonneg (by norm_num) i) zero_le_one))
      _ = ((Nat.choose 7 i : ℕ) : ℝ) * ((61 / 20 : ℝ) ^ i)
            * (((7 - i).factorial : ℝ) * 8 / (10 : ℝ) ^ (7 - i)) := by ring
  refine (Finset.sum_le_sum hterm).trans ?_
  have hcast : (∑ i ∈ Finset.range 8, ((Nat.choose 7 i : ℕ) : ℝ) * ((61 / 20 : ℝ) ^ i)
        * (((7 - i).factorial : ℝ) * 8 / (10 : ℝ) ^ (7 - i)))
      = ((∑ i ∈ Finset.range 8, (((Nat.choose 7 i : ℕ) : ℚ) * (61 / 20 : ℚ) ^ i
        * (((7 - i).factorial : ℚ) * 8 / (10 : ℚ) ^ (7 - i)))) : ℚ) := by
    push_cast
    rfl
  rw [hcast]
  exact_mod_cast psi_part_rat_le

/-- Cauchy for `R₃^{(7)}` on the radius-`1/4` ball. -/
theorem diffContOnCl_remainder_quarter {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    DiffContOnCl ℂ (zetaEMRemainder 3 20) (Metric.ball z (1 / 4)) := by
  apply DifferentiableOn.diffContOnCl
  rw [closure_ball z (by norm_num : (1 / 4 : ℝ) ≠ 0)]
  intro w hw
  have hw' : ‖w - z‖ ≤ 1 / 4 := by simpa [Metric.mem_closedBall, dist_eq_norm] using hw
  have hws : ‖w - s14‖ < (1 / 2 : ℝ) := by
    calc ‖w - s14‖ = ‖(w - z) + (z - s14)‖ := by ring_nf
      _ ≤ ‖w - z‖ + ‖z - s14‖ := norm_add_le _ _
      _ < 1 / 2 := by linarith
  exact ((contDiffAt_remainder_at (1 : WithTop ℕ∞) hws).differentiableAt (by simp)).differentiableWithinAt

theorem norm_iteratedDeriv_remainder_seven_le {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    ‖iteratedDeriv 7 (zetaEMRemainder 3 20) z‖ ≤ (5000 : ℝ) := by
  have hR : (0 : ℝ) < 1 / 4 := by norm_num
  have h := Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le
    (f := zetaEMRemainder 3 20) (c := z) (R := 1 / 4) (C := 6 / 100000)
    7 hR (diffContOnCl_remainder_quarter hz) (fun w hw => by
      have hw1 : ‖w - z‖ = 1 / 4 := by simpa [Metric.mem_sphere, dist_eq_norm] using hw
      have hws : ‖w - s14‖ < (1 / 2 : ℝ) := by
        calc ‖w - s14‖ = ‖(w - z) + (z - s14)‖ := by ring_nf
          _ ≤ ‖w - z‖ + ‖z - s14‖ := norm_add_le _ _
          _ < 1 / 2 := by rw [hw1]; linarith
      exact norm_remainder_three_ball_le hws)
  calc ‖iteratedDeriv 7 (zetaEMRemainder 3 20) z‖
      ≤ ((Nat.factorial 7 : ℕ) : ℝ) * (6 / 100000) / (1 / 4 : ℝ) ^ 7 := h
    _ ≤ 5000 := by norm_num

theorem norm_gen3_seven_le {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    ‖iteratedDeriv 7 (zetaEMGen 3 20) z‖ ≤ (13189 + 25204 : ℝ) := by
  rw [iteratedDeriv_gen3 7 (ne_one_of_ball_fifth hz)]
  refine (norm_add_le _ _).trans ?_
  rw [base_sum_cast_z 7 z]
  have hb := norm_base_seven_le (z := z) (re_nonneg_of_ball_fifth hz)
  have hp := norm_psi_part_seven_le hz
  linarith

/-- **The supremum bound** used by the Taylor remainder: `‖ζ^{(7)}‖ ≤ 43393` on
the closed `1/5`-ball (journal I.315). -/
theorem norm_iteratedDeriv_seven_le {z : ℂ} (hz : ‖z - s14‖ ≤ (1 / 5 : ℝ)) :
    ‖iteratedDeriv 7 riemannZeta z‖ ≤ (43393 : ℝ) := by
  have hz2 : ‖z - s14‖ < (1 / 2 : ℝ) := lt_of_le_of_lt hz (by norm_num)
  rw [iteratedDeriv_zeta_eq_gen3_add_at 7 hz2]
  calc ‖iteratedDeriv 7 (zetaEMGen 3 20) z + iteratedDeriv 7 (zetaEMRemainder 3 20) z‖
      ≤ ‖iteratedDeriv 7 (zetaEMGen 3 20) z‖
          + ‖iteratedDeriv 7 (zetaEMRemainder 3 20) z‖ := norm_add_le _ _
    _ ≤ (13189 + 25204) + 5000 :=
        add_le_add (norm_gen3_seven_le hz) (norm_iteratedDeriv_remainder_seven_le hz)
    _ ≤ 43393 := by norm_num


/-! ## 3. The Taylor remainder, `h2` and the certified zero -/

theorem norm_affine_sub_le {w : ℂ} (hw : ‖w‖ ≤ (1 / 5 : ℝ)) {y : ℝ} (hy : |y| ≤ 1) :
    ‖(s14 + (y : ℂ) * w) - s14‖ ≤ (1 / 5 : ℝ) := by
  have he : s14 + (y : ℂ) * w - s14 = (y : ℂ) * w := by ring
  rw [he, norm_mul]
  have hy' : ‖(y : ℂ)‖ = |y| := by simp
  rw [hy']
  nlinarith [norm_nonneg w]

/-- The chain rule specialised to `ζ′`. -/
theorem iteratedDeriv_comp_zeta {w : ℂ} (t : ℝ) (k : ℕ)
    (hball : ‖(s14 + (t : ℂ) * w) - s14‖ < (1 / 2 : ℝ)) :
    iteratedDeriv k (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) t
      = iteratedDeriv (k + 1) riemannZeta (s14 + (t : ℂ) * w) * w ^ k := by
  have hcd : ContDiffAt ℂ (((k + 1 : ℕ)) : WithTop ℕ∞) (deriv riemannZeta)
      (s14 + (t : ℂ) * w) := (analyticAt_deriv_zeta_ball hball).contDiffAt
  have h := iteratedDeriv_comp_ofReal_mul (deriv riemannZeta) s14 w k t hcd
  rw [h, ← iteratedDeriv_succ']

/-- `t ↦ ζ′(s14 + t·w)` is `C^6` at any `y` with `|y| ≤ 1`. -/
theorem contDiffAt_zeta_deriv_comp {w : ℂ} (hw : ‖w‖ ≤ (1 / 5 : ℝ)) {y : ℝ} (hy : |y| ≤ 1) :
    ContDiffAt ℝ (6 : WithTop ℕ∞) (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) y := by
  have hp : ‖(s14 + (y : ℂ) * w) - s14‖ < (1 / 2 : ℝ) :=
    lt_of_le_of_lt (norm_affine_sub_le hw hy) (by norm_num)
  have hcd : ContDiffAt ℝ (6 : WithTop ℕ∞) (deriv riemannZeta) (s14 + (y : ℂ) * w) :=
    (analyticAt_deriv_zeta_ball hp).contDiffAt.restrict_scalars ℝ
  have h1 : ContDiffAt ℝ (6 : WithTop ℕ∞) (fun z : ℂ => s14 + z * w) (y : ℂ) := by fun_prop
  have h2 : ContDiffAt ℝ (6 : WithTop ℕ∞) (fun s : ℝ => (s : ℂ)) y :=
    Complex.ofRealCLM.contDiff.contDiffAt
  have hcomp : ContDiffAt ℝ (6 : WithTop ℕ∞)
      ((fun z : ℂ => s14 + z * w) ∘ (fun s : ℝ => (s : ℂ))) y :=
    ContDiffAt.comp y h1 h2
  simpa [Function.comp_def] using ContDiffAt.comp y hcd hcomp

/-- `(k!)⁻¹·ζ^{(k+1)}(s14) = (k+1)·c_{k+1}`, summed: the Taylor coefficients of
`ζ′` are those of `taylorPoly`. -/
theorem sum_coef_eq_taylorPoly (w : ℂ) :
    (∑ k ∈ Finset.range 6, ((k.factorial : ℝ)⁻¹ : ℂ)
        * (iteratedDeriv (k + 1) riemannZeta s14 * w ^ k)) = taylorPoly w := by
  rw [taylorPoly]
  apply Finset.sum_congr rfl
  intro k hk
  rw [taylorCoef]
  have hfac : (((k + 1).factorial : ℕ) : ℂ)
      = (((k + 1 : ℕ)) : ℂ) * (((k.factorial : ℕ)) : ℂ) := by
    rw [Nat.factorial_succ]
    push_cast
    ring
  have hk0 : (((k.factorial : ℕ)) : ℂ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)
  have hk1 : (((k + 1 : ℕ)) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.succ_ne_zero k)
  rw [hfac]
  push_cast
  field_simp

/-- The Lagrange remainder `taylorWithinEval` is the polynomial `taylorPoly`. -/
theorem taylorWithinEval_eq_taylorPoly (w : ℂ) (hw : ‖w‖ ≤ (1 / 5 : ℝ)) :
    taylorWithinEval (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) 5
      (Set.Icc (0 : ℝ) 1) 0 1 = taylorPoly w := by
  rw [taylor_within_apply]
  have hstep : ∀ k ∈ Finset.range 6,
      ((k.factorial : ℝ)⁻¹ * ((1 : ℝ) - 0) ^ k) •
          iteratedDerivWithin k (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w))
            (Set.Icc (0 : ℝ) 1) 0
        = ((k.factorial : ℝ)⁻¹ : ℂ) * (iteratedDeriv (k + 1) riemannZeta s14 * w ^ k) := by
    intro k hk
    have hk6 : k < 6 := Finset.mem_range.mp hk
    have hcd : ContDiffAt ℝ (k : WithTop ℕ∞)
        (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) 0 :=
      (contDiffAt_zeta_deriv_comp hw (by norm_num)).of_le
        (WithTop.coe_le_coe.mpr (Nat.cast_le.mpr (Nat.le_of_lt hk6)))
    rw [iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc (by norm_num)) hcd (by norm_num)]
    rw [iteratedDeriv_comp_zeta 0 k (by simp)]
    simp [RCLike.real_smul_eq_coe_mul]
  rw [Finset.sum_congr rfl hstep]
  exact sum_coef_eq_taylorPoly w

/-- **The Taylor remainder** (`n = 5`, `[0,1]`, `sup|ζ^{(7)}| ≤ 43393`). -/
theorem norm_deriv_sub_taylorPoly_le {w : ℂ} (hw : ‖w‖ ≤ (1 / 5 : ℝ)) :
    ‖deriv riemannZeta (s14 + w) - taylorPoly w‖ ≤ (24 / 1000 : ℝ) := by
  have hF : ContDiffOn ℝ (6 : WithTop ℕ∞)
      (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) (Set.Icc (0 : ℝ) 1) := by
    intro y hy
    have hy1 : |y| ≤ 1 := by
      rw [abs_le]
      exact ⟨by linarith [hy.1], hy.2⟩
    exact (contDiffAt_zeta_deriv_comp hw hy1).contDiffWithinAt
  have hC : ∀ y ∈ Set.Icc (0 : ℝ) 1,
      ‖iteratedDerivWithin 6 (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w))
        (Set.Icc (0 : ℝ) 1) y‖ ≤ (43393 : ℝ) * ‖w‖ ^ 6 := by
    intro y hy
    have hy1 : |y| ≤ 1 := by
      rw [abs_le]
      exact ⟨by linarith [hy.1], hy.2⟩
    have hle := norm_affine_sub_le hw hy1
    have hcd : ContDiffAt ℝ (6 : WithTop ℕ∞)
        (fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w)) y :=
      contDiffAt_zeta_deriv_comp hw hy1
    rw [iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc (by norm_num)) hcd hy]
    rw [iteratedDeriv_comp_zeta y 6 (lt_of_le_of_lt hle (by norm_num))]
    calc ‖iteratedDeriv 7 riemannZeta (s14 + (y : ℂ) * w) * w ^ 6‖
        = ‖iteratedDeriv 7 riemannZeta (s14 + (y : ℂ) * w)‖ * ‖w ^ 6‖ := norm_mul _ _
      _ = ‖iteratedDeriv 7 riemannZeta (s14 + (y : ℂ) * w)‖ * ‖w‖ ^ 6 := by rw [norm_pow]
      _ ≤ 43393 * ‖w‖ ^ 6 :=
          mul_le_mul_of_nonneg_right (norm_iteratedDeriv_seven_le hle)
            (pow_nonneg (norm_nonneg w) 6)
  have hmain := taylor_mean_remainder_bound
    (f := fun s : ℝ => deriv riemannZeta (s14 + (s : ℂ) * w))
    (a := 0) (b := 1) (C := 43393 * ‖w‖ ^ 6) (x := 1) (n := 5)
    (by norm_num) hF (by norm_num) hC
  rw [Complex.ofReal_one, one_mul, taylorWithinEval_eq_taylorPoly w hw] at hmain
  refine hmain.trans ?_
  have hpow : ‖w‖ ^ 6 ≤ (1 / 5 : ℝ) ^ 6 := pow_le_pow_left₀ (norm_nonneg w) hw 6
  have hfac : ((Nat.factorial 5 : ℕ) : ℝ) = 120 := by norm_num
  rw [hfac]
  nlinarith [hpow]

/-- The remainder estimate on the closed `1/5`-ball, in the shape of `h2`. -/
theorem hrem_closedBall :
    ∀ z ∈ Metric.closedBall s14 (1 / 5),
      ‖deriv riemannZeta z - taylorPoly (z - s14)‖ ≤ (24 / 1000 : ℝ) := by
  intro z hz
  have hz' : ‖z - s14‖ ≤ (1 / 5 : ℝ) := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hz
  have h := norm_deriv_sub_taylorPoly_le (w := z - s14) hz'
  have hw : s14 + (z - s14) = z := by ring
  simpa [hw] using h

/-- **`h2`** with the remainder budget `34/1000` implied by
`47/250 − 154/1000` (the constant `14/1000` of `EMTaylorH2.h2_of_taylor_remainder`
was set for `sup|ζ^{(7)}| ≤ 25000`; I.315 refined that to `43393`, giving the
`24/1000` remainder proved above). -/
theorem h2_of_taylor_remainder_wide
    (hrem : ∀ z ∈ Metric.closedBall s14 (1 / 5),
      ‖deriv riemannZeta z - taylorPoly (z - s14)‖ ≤ (24 / 1000 : ℝ)) :
    ∀ z ∈ Metric.closedBall s14 (1 / 5),
      ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ) := by
  intro z hz
  have hz' : ‖z - s14‖ ≤ (1 / 5 : ℝ) := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hz
  have hsum := norm_taylorPoly_sub_le (w := z - s14) hz'
  have hsplit : deriv riemannZeta z - deriv riemannZeta s14
      = (deriv riemannZeta z - taylorPoly (z - s14))
        + (taylorPoly (z - s14) - deriv riemannZeta s14) := by ring
  rw [hsplit]
  have h := norm_add_le (deriv riemannZeta z - taylorPoly (z - s14))
    (taylorPoly (z - s14) - deriv riemannZeta s14)
  linarith [hrem z hz]

/-- **`h2`**, proved. -/
theorem h2_deriv : ∀ z ∈ Metric.closedBall s14 (1 / 5),
    ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ (47 / 250 : ℝ) :=
  h2_of_taylor_remainder_wide hrem_closedBall

/-- **A Lean-certified zero of `ζ` at `1/2 + 14i`.**  No RH, twin-prime, Chowla
or infinite Weil-positivity claim is made. -/
theorem zeta_zero_14 : ∃ z ∈ Metric.closedBall s14 (1 / 5), riemannZeta z = 0 :=
  zeta_zero_14_of_bounds h1_deriv h2_deriv

end FiniteWindowZeros
