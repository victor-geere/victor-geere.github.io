import Topic
import Symbol
import Repair
import Shift
import Mathlib.Analysis.Complex.Liouville

/-!
# Positivity of the grouped eta series on the positive real axis

For real `σ > 0` each grouped pair
`(2m+1)^{-σ} - (2m+2)^{-σ}`
is a positive real number, because `x ↦ x^{-σ}` is strictly decreasing on
`(0, ∞)`.  Since the grouped series is summable on `Re s > 0`, the sum of the
pair terms is therefore a positive real number.  This file records that
elementary fact; it is the real-axis positivity input for the eta-to-zeta
transfer in `Topic.lean`.

Note on formalisation: `ℂ` carries no `LT`/`Preorder` instance, so the
statement `0 < etaGrouped (σ : ℂ)` is not well-typed.  The faithful versions
proved below are positivity of the real part (`etaGrouped_real_pos`) and the
stronger statement that the value is the cast of a positive real number
(`etaGrouped_eq_pos_ofReal`).

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Filter Topology

namespace FiniteWindowZeros

open AbsoluteHodgeSymbol

/-- The real-valued grouped eta pair. -/
def realPairTerm (σ : ℝ) (m : ℕ) : ℝ :=
  (((2 * m + 1 : ℕ) : ℝ) ^ (-σ)) - (((2 * m + 2 : ℕ) : ℝ) ^ (-σ))

/-- Each real pair term is positive for `σ > 0`. -/
theorem realPairTerm_pos {σ : ℝ} (hσ : 0 < σ) (m : ℕ) :
    0 < realPairTerm σ m := by
  have ha : 0 < ((2 * m + 1 : ℕ) : ℝ) := by positivity
  have hlt : ((2 * m + 1 : ℕ) : ℝ) < ((2 * m + 2 : ℕ) : ℝ) := by
    push_cast
    linarith
  have h := Real.rpow_lt_rpow_of_neg ha hlt (show -σ < 0 by linarith)
  dsimp [realPairTerm]
  linarith

/-- The complex pair term is the cast of the real pair term. -/
theorem pairTerm_eq_ofReal {σ : ℝ} (m : ℕ) :
    pairTerm (σ : ℂ) m = (realPairTerm σ m : ℂ) := by
  unfold pairTerm realPairTerm
  rw [show ((2 * m + 1 : ℕ) : ℂ) = ((((2 * m + 1 : ℕ) : ℝ)) : ℂ) by
        push_cast
        ring,
      show ((2 * m + 2 : ℕ) : ℂ) = ((((2 * m + 2 : ℕ) : ℝ)) : ℂ) by
        push_cast
        ring]
  have hexp : -(σ : ℂ) = ((-σ : ℝ) : ℂ) := by
    push_cast
    ring
  rw [hexp]
  rw [← Complex.ofReal_cpow (by positivity : (0 : ℝ) ≤ ((2 * m + 1 : ℕ) : ℝ)) (-σ),
    ← Complex.ofReal_cpow (by positivity : (0 : ℝ) ≤ ((2 * m + 2 : ℕ) : ℝ)) (-σ)]
  push_cast
  ring

/-- The grouped eta series on the positive real axis is the cast of the sum of
the positive real pair terms. -/
theorem etaGrouped_eq_ofReal_tsum {σ : ℝ} :
    etaGrouped (σ : ℂ) = ((∑' m : ℕ, realPairTerm σ m : ℝ) : ℂ) := by
  rw [etaGrouped]
  calc
    (∑' m : ℕ, pairTerm (σ : ℂ) m) = ∑' m : ℕ, (realPairTerm σ m : ℂ) :=
      tsum_congr (fun m => pairTerm_eq_ofReal m)
    _ = ((∑' m : ℕ, realPairTerm σ m : ℝ) : ℂ) :=
      (Complex.ofReal_tsum (fun m : ℕ => realPairTerm σ m)).symm

/-- **Goal A, strong form.**  For `σ > 0` the value `etaGrouped (σ : ℂ)` is a
positive real number. -/
theorem etaGrouped_eq_pos_ofReal {σ : ℝ} (hσ : 0 < σ) :
    ∃ r : ℝ, 0 < r ∧ etaGrouped (σ : ℂ) = (r : ℂ) := by
  have hsummableC : Summable (fun m : ℕ => pairTerm (σ : ℂ) m) :=
    summable_pairTerm (by simpa using hσ)
  have hsummableR : Summable (realPairTerm σ) :=
    Complex.summable_ofReal.mp (hsummableC.congr (fun m => pairTerm_eq_ofReal m))
  have htsum : 0 < ∑' m : ℕ, realPairTerm σ m :=
    hsummableR.tsum_pos (fun m => (realPairTerm_pos hσ m).le) 0
      (realPairTerm_pos hσ 0)
  exact ⟨_, htsum, etaGrouped_eq_ofReal_tsum⟩

/-- **Goal A.**  The grouped eta series is positive on the positive real axis
(in the sense of the real part of its value). -/
theorem etaGrouped_real_pos {σ : ℝ} (hσ : 0 < σ) :
    0 < (etaGrouped (σ : ℂ)).re := by
  obtain ⟨r, hr, heq⟩ := etaGrouped_eq_pos_ofReal hσ
  rw [heq]
  simpa using hr

/-- The grouped eta series is real on the positive real axis. -/
theorem etaGrouped_real_im_eq_zero {σ : ℝ} (hσ : 0 < σ) :
    (etaGrouped (σ : ℂ)).im = 0 := by
  obtain ⟨r, -, heq⟩ := etaGrouped_eq_pos_ofReal hσ
  rw [heq]
  simp

/-- **Goal B, as a consequence.**  On the real interval `(0, 1)` the eta
identity and the strict positivity of `etaGrouped` rule out zeros of `ζ`. -/
theorem zeta_real_ne_zero {σ : ℝ} (h1 : 0 < σ) (h2 : σ < 1) :
    riemannZeta (σ : ℂ) ≠ 0 := by
  obtain ⟨r, hr, heq⟩ := etaGrouped_eq_pos_ofReal h1
  have heta : etaGrouped (σ : ℂ) ≠ 0 := by
    rw [heq]
    exact_mod_cast hr.ne'
  refine zeta_ne_zero_of_eta_ne_zero (s := (σ : ℂ)) (by simpa using h1) ?_ heta
  intro h
  have hσ1 : σ = 1 := by exact_mod_cast h
  linarith
/-- **Eventual nonvanishing around a real point.**  Every real point
`σ ∈ (0,1)` has a complex neighbourhood on which `ζ` is nonzero. -/
theorem eventually_zeta_ne_zero_of_real {σ : ℝ} (h1 : 0 < σ) (h2 : σ < 1) :
    ∀ᶠ z : ℂ in 𝓝 (σ : ℂ), riemannZeta z ≠ 0 := by
  have hne : (σ : ℂ) ≠ 1 := by
    intro h
    have h' : σ = 1 := by exact_mod_cast h
    linarith
  exact (differentiableAt_riemannZeta hne).continuousAt.eventually_ne
    (zeta_real_ne_zero h1 h2)

/-- The real segment `[1/2,1]` is zero-free for `ζ`. -/
theorem zeta_real_ne_zero_Icc {σ : ℝ} (h1 : (1 / 2 : ℝ) ≤ σ) (h2 : σ ≤ 1) :
    riemannZeta (σ : ℂ) ≠ 0 := by
  rcases lt_or_eq_of_le h2 with hlt | heq
  · exact zeta_real_ne_zero (by linarith) hlt
  · subst σ
    exact riemannZeta_ne_zero_of_one_le_re (by norm_num)

/-- **Uniform zero-free neighbourhood of the real segment `[1/2,1]`.**  There
is a single positive `δ` such that `ζ` does not vanish on the box
`{z : ℂ | |z.re - σ| ≤ δ ∧ |z.im| ≤ δ}` around every `σ ∈ [1/2,1]`.

The proof takes, for each point of the segment, a zero-free open neighbourhood
(from `eventually_zeta_ne_zero_of_real` in the interior, and from the residue
`riemannZeta_residue_one` together with `riemannZeta_one_ne_zero` at `1`), then
extracts a finite subcover of the compact segment and takes the minimum of the
corresponding radii. -/
theorem exists_uniform_zeroFree_nhds_realSegment :
    ∃ δ : ℝ, 0 < δ ∧ ∀ σ : ℝ, (1 / 2 : ℝ) ≤ σ → σ ≤ 1 →
      ∀ z : ℂ, |z.re - σ| ≤ δ → |z.im| ≤ δ → riemannZeta z ≠ 0 := by
  have hlocal : ∀ σ : ℝ, σ ∈ Set.Icc (1 / 2 : ℝ) 1 →
      ∃ r : ℝ, 0 < r ∧ ∀ z : ℂ, dist z (σ : ℂ) < r → riemannZeta z ≠ 0 := by
    intro σ hσ
    rcases lt_or_eq_of_le hσ.2 with hlt | heq
    · have h1 : 0 < σ := by linarith [hσ.1]
      have hev := eventually_zeta_ne_zero_of_real h1 hlt
      rw [Metric.eventually_nhds_iff] at hev
      obtain ⟨r, hr, hball⟩ := hev
      exact ⟨r, hr, fun z hz => hball hz⟩
    · subst σ
      have hev : ∀ᶠ z : ℂ in 𝓝[≠] (1 : ℂ),
          (z - 1) * riemannZeta z ∈ Metric.ball (1 : ℂ) (1 / 2) :=
        riemannZeta_residue_one.eventually (Metric.ball_mem_nhds _ (by norm_num))
      rw [eventually_nhdsWithin_iff] at hev
      rw [Metric.eventually_nhds_iff] at hev
      obtain ⟨r, hr, hprop⟩ := hev
      refine ⟨r, hr, ?_⟩
      intro z hz
      by_cases hz1 : z = 1
      · subst z
        exact riemannZeta_one_ne_zero
      · have hprod : (z - 1) * riemannZeta z ∈ Metric.ball (1 : ℂ) (1 / 2) :=
          hprop hz hz1
        have hprod_ne : (z - 1) * riemannZeta z ≠ 0 := by
          intro h0
          have hdist : dist ((z - 1) * riemannZeta z) (1 : ℂ) < 1 / 2 := hprod
          have hdist0 : dist (0 : ℂ) (1 : ℂ) < 1 / 2 := by
            simpa [h0] using hdist
          norm_num at hdist0
        exact (mul_ne_zero_iff.mp hprod_ne).2
  let r : ℝ → ℝ := fun σ =>
    if h : σ ∈ Set.Icc (1 / 2 : ℝ) 1 then Classical.choose (hlocal σ h) else 1
  have hr_pos : ∀ σ : ℝ, 0 < r σ := by
    intro σ
    by_cases h : σ ∈ Set.Icc (1 / 2 : ℝ) 1
    · dsimp only [r]
      rw [dite_eq_left h]
      exact (Classical.choose_spec (hlocal σ h)).1
    · dsimp only [r]
      rw [dite_eq_right h]
      norm_num
  have hr_spec : ∀ (σ : ℝ) (hσ : σ ∈ Set.Icc (1 / 2 : ℝ) 1),
      ∀ z : ℂ, dist z (σ : ℂ) < r σ → riemannZeta z ≠ 0 := by
    intro σ hσ z hz
    have hEq : r σ = Classical.choose (hlocal σ hσ) := by
      dsimp only [r]
      rw [dite_eq_left hσ]
    rw [hEq] at hz
    exact (Classical.choose_spec (hlocal σ hσ)).2 z hz
  let U : ℝ → Set ℂ := fun σ =>
    if h : σ ∈ Set.Icc (1 / 2 : ℝ) 1 then Metric.ball (σ : ℂ) (r σ / 2) else ∅
  have hUopen : ∀ σ : ℝ, IsOpen (U σ) := by
    intro σ
    by_cases h : σ ∈ Set.Icc (1 / 2 : ℝ) 1
    · dsimp only [U]
      rw [dite_eq_left h]
      exact Metric.isOpen_ball
    · dsimp only [U]
      rw [dite_eq_right h]
      exact isOpen_empty
  have hcover : (fun σ : ℝ => (σ : ℂ)) '' Set.Icc (1 / 2 : ℝ) 1 ⊆ ⋃ σ, U σ := by
    rintro x ⟨σ, hσ, rfl⟩
    refine Set.mem_iUnion.mpr ⟨σ, ?_⟩
    have hpos := hr_pos σ
    dsimp only [U]
    rw [dite_eq_left hσ]
    exact Metric.mem_ball.mpr (by simpa using half_pos hpos)
  have hcompact : IsCompact ((fun σ : ℝ => (σ : ℂ)) '' Set.Icc (1 / 2 : ℝ) 1) :=
    isCompact_Icc.image Complex.continuous_ofReal
  obtain ⟨t, htcover⟩ := hcompact.elim_finite_subcover U hUopen hcover
  have ht_nonempty : t.Nonempty := by
    have hx : ((1 / 2 : ℝ) : ℂ) ∈ (fun σ : ℝ => (σ : ℂ)) '' Set.Icc (1 / 2 : ℝ) 1 :=
      ⟨1 / 2, ⟨le_rfl, by norm_num⟩, rfl⟩
    have hxU : ((1 / 2 : ℝ) : ℂ) ∈ ⋃ i ∈ t, U i := htcover hx
    obtain ⟨i, hit, -⟩ := (by simpa only [Set.mem_iUnion, exists_prop] using hxU)
    exact ⟨i, hit⟩
  obtain ⟨i0, hi0t, hmin⟩ := Finset.exists_min_image t (fun i => r i / 4) ht_nonempty
  refine ⟨r i0 / 4, by have := hr_pos i0; linarith, ?_⟩
  intro σ h1 h2 z hzre hzim
  have hσ : σ ∈ Set.Icc (1 / 2 : ℝ) 1 := ⟨h1, h2⟩
  have hσs : (σ : ℂ) ∈ (fun σ : ℝ => (σ : ℂ)) '' Set.Icc (1 / 2 : ℝ) 1 :=
    ⟨σ, hσ, rfl⟩
  have hσU : (σ : ℂ) ∈ ⋃ i ∈ t, U i := htcover hσs
  obtain ⟨i, hit, hiU⟩ := (by simpa only [Set.mem_iUnion, exists_prop] using hσU)
  have hi : i ∈ Set.Icc (1 / 2 : ℝ) 1 := by
    by_contra hni
    have hempty : U i = ∅ := by
      dsimp only [U]
      rw [dite_eq_right hni]
    rw [hempty] at hiU
    exact hiU
  have hiUi : dist (σ : ℂ) (i : ℂ) < r i / 2 := by
    dsimp only [U] at hiU
    rw [dite_eq_left hi] at hiU
    exact hiU
  have hzσ : dist z (σ : ℂ) ≤ |z.re - σ| + |z.im| := by
    rw [Complex.dist_eq]
    calc ‖z - (σ : ℂ)‖ ≤ |(z - (σ : ℂ)).re| + |(z - (σ : ℂ)).im| :=
          Complex.norm_le_abs_re_add_abs_im _
      _ = |z.re - σ| + |z.im| := by simp
  have hzδ : dist z (σ : ℂ) ≤ 2 * (r i0 / 4) := by
    nlinarith [hzσ, abs_nonneg (z.re - σ), hzre, hzim]
  have hδle : r i0 / 4 ≤ r i / 4 := hmin i hit
  have hdist : dist z (i : ℂ) < r i := by
    calc
      dist z (i : ℂ) ≤ dist z (σ : ℂ) + dist (σ : ℂ) (i : ℂ) :=
        dist_triangle _ _ _
      _ < 2 * (r i0 / 4) + r i / 2 := by linarith
      _ ≤ r i := by linarith
  exact hr_spec i hi z hdist


/-- The uniform zero-free height extracted from T574. -/
noncomputable def uniformDelta : ℝ :=
  Classical.choose exists_uniform_zeroFree_nhds_realSegment

theorem uniformDelta_pos : 0 < uniformDelta :=
  (Classical.choose_spec exists_uniform_zeroFree_nhds_realSegment).1

/-- The uniform `δ`-box is zero-free. -/
theorem zeta_ne_zero_uniformDelta {σ : ℝ} (h1 : (1 / 2 : ℝ) ≤ σ) (h2 : σ ≤ 1)
    {z : ℂ} (hre : |z.re - σ| ≤ uniformDelta) (him : |z.im| ≤ uniformDelta) :
    riemannZeta z ≠ 0 :=
  (Classical.choose_spec exists_uniform_zeroFree_nhds_realSegment).2 σ h1 h2 z hre him

/-- Uniform zero-free box on the left half of the critical strip, by the
completed-zeta functional equation. -/
theorem zeta_ne_zero_uniformDelta_left {σ : ℝ} (h0 : 0 < σ) (h1 : σ ≤ 1 / 2)
    {z : ℂ} (hzre0 : 0 < z.re) (hzre1 : z.re < 1)
    (hre : |z.re - σ| ≤ uniformDelta) (him : |z.im| ≤ uniformDelta) :
    riemannZeta z ≠ 0 := by
  have hσ'1 : (1 / 2 : ℝ) ≤ 1 - σ := by linarith
  have hσ'2 : 1 - σ ≤ 1 := by linarith
  have hre' : |(1 - z).re - (1 - σ)| ≤ uniformDelta := by
    simpa [abs_sub_comm] using hre
  have him' : |(1 - z).im| ≤ uniformDelta := by
    simpa using him
  have hne' : riemannZeta (1 - z) ≠ 0 :=
    zeta_ne_zero_uniformDelta hσ'1 hσ'2 hre' him'
  intro hz0
  have hz0ne : z ≠ 0 := by
    intro h; rw [h] at hzre0; norm_num at hzre0
  have hz1ne : z ≠ 1 := by
    intro h; rw [h] at hzre1; norm_num at hzre1
  have hz0comp : completedZeta z = 0 :=
    (completedZeta_eq_zero_iff_zeta hzre0 hzre1).mpr hz0
  have hΓ : z.Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hzre0
  have hΓ' : (1 - z).Gammaℝ ≠ 0 :=
    Complex.Gammaℝ_ne_zero_of_re_pos (by simpa using sub_pos.mpr hzre1)
  have hcomp' : completedZeta (1 - z) = 0 := by
    rw [completedZeta_one_sub hz0ne hz1ne hΓ hΓ']
    exact hz0comp
  have hzre1' : 0 < (1 - z).re := by simpa using sub_pos.mpr hzre1
  have hzre0' : (1 - z).re < 1 := by simpa using sub_pos.mpr hzre0
  exact hne' ((completedZeta_eq_zero_iff_zeta hzre1' hzre0').mp hcomp')

/-! ## The lower bound `‖ζ(σ)‖ ≥ 1` on `[1/2, 1)`

The eta identity `η(σ) = (1 - 2^{1-σ}) ζ(σ)` is available on the positive
half-plane.  On `[1/2, 1)` the factor `1 - 2^{1-σ}` has norm at most `1/2`,
so it is enough to prove `1/2 ≤ η(σ)` (which is a positive real number).

The key point is *not* that the first pair term `1 - 2^{-σ}` is large (it is
only `1 - 1/√2 ≈ 0.293` at `σ = 1/2`), but that the whole pair series is
bounded below by a telescoping series: by convexity (AM–GM) of `x ↦ x^{-σ}`,

`(2m+1)^{-σ} - (2m+2)^{-σ} ≥ ½ ((2m+1)^{-σ} - (2m+3)^{-σ})`,

and the right-hand side telescopes to `½`. -/

/-- Convexity of `x ↦ x^{-σ}` in the form of the second-difference inequality
`f a + f c ≥ 2 f b` for `a < b < c` with `b = (a+c)/2` and `ac ≤ b²`. -/
theorem half_pair_shift_le_realPairTerm {σ : ℝ} (hσ : 0 < σ) (m : ℕ) :
    (1 / 2) * ((((2 * m + 1 : ℕ) : ℝ) ^ (-σ)) - (((2 * m + 3 : ℕ) : ℝ) ^ (-σ)))
      ≤ realPairTerm σ m := by
  set a : ℝ := ((2 * m + 1 : ℕ) : ℝ)
  set b : ℝ := ((2 * m + 2 : ℕ) : ℝ)
  set c : ℝ := ((2 * m + 3 : ℕ) : ℝ)
  have ha : 0 < a := by positivity
  have hb : 0 < b := by positivity
  have hc : 0 < c := by positivity
  have hac : 0 < a * c := mul_pos ha hc
  have hac_le : a * c ≤ b ^ (2 : ℝ) := by
    rw [Real.rpow_two]
    dsimp [a, b, c]
    push_cast
    nlinarith [sq_nonneg (2 * (m : ℝ) + 2)]
  -- AM–GM applied to `a^{-σ}` and `c^{-σ}`.
  have hAG := Real.geom_mean_le_arith_mean2_weighted (w₁ := (1 / 2 : ℝ))
    (w₂ := (1 / 2 : ℝ)) (p₁ := a ^ (-σ)) (p₂ := c ^ (-σ))
    (by norm_num) (by norm_num) (Real.rpow_nonneg ha.le _)
    (Real.rpow_nonneg hc.le _) (by norm_num)
  have hsqrt : (a ^ (-σ)) ^ ((1 : ℝ) / 2) * (c ^ (-σ)) ^ ((1 : ℝ) / 2)
      = (a * c) ^ (-σ / 2) := by
    rw [← Real.mul_rpow (Real.rpow_nonneg ha.le _) (Real.rpow_nonneg hc.le _)]
    rw [← Real.mul_rpow ha.le hc.le]
    rw [← Real.rpow_mul (mul_nonneg ha.le hc.le)]
    congr 1
    ring
  have hB : (b ^ (2 : ℝ)) ^ (-σ / 2) = b ^ (-σ) := by
    rw [← Real.rpow_mul hb.le]
    congr 1
    ring
  have hle : b ^ (-σ) ≤ (a * c) ^ (-σ / 2) := by
    rw [← hB]
    exact Real.rpow_le_rpow_of_nonpos hac hac_le (by linarith)
  have hmain : 2 * b ^ (-σ) ≤ a ^ (-σ) + c ^ (-σ) := by
    have h1 : 2 * ((a ^ (-σ)) ^ ((1 : ℝ) / 2) * (c ^ (-σ)) ^ ((1 : ℝ) / 2))
        ≤ a ^ (-σ) + c ^ (-σ) := by linarith
    rw [hsqrt] at h1
    linarith
  have hgoal : (1 / 2) * (a ^ (-σ) - c ^ (-σ)) ≤ a ^ (-σ) - b ^ (-σ) := by
    linarith
  simpa [realPairTerm, a, b, c] using hgoal

/-- **The eta series is at least `1/2` on the positive real axis.** -/
theorem half_le_tsum_realPairTerm {σ : ℝ} (hσ : 0 < σ) :
    (1 / 2 : ℝ) ≤ ∑' m : ℕ, realPairTerm σ m := by
  have hsummableC : Summable (fun m : ℕ => pairTerm (σ : ℂ) m) :=
    summable_pairTerm (by simpa using hσ)
  have hsummableR : Summable (realPairTerm σ) :=
    Complex.summable_ofReal.mp (hsummableC.congr (fun m => pairTerm_eq_ofReal m))
  have hbound : ∀ M : ℕ,
      (1 / 2) * (1 - (((2 * (M + 1) + 1 : ℕ) : ℝ) ^ (-σ)))
        ≤ ∑' m : ℕ, realPairTerm σ m := by
    intro M
    let h : ℕ → ℝ := fun m => (((2 * m + 1 : ℕ) : ℝ) ^ (-σ))
    have htel : (∑ m ∈ Finset.range (M + 1), (1 / 2) * (h m - h (m + 1)))
        = (1 / 2) * (1 - h (M + 1)) := by
      rw [← Finset.mul_sum, Finset.sum_range_sub' h (M + 1)]
      simp [h]
    have hle_sum : (∑ m ∈ Finset.range (M + 1), realPairTerm σ m)
        ≤ ∑' m : ℕ, realPairTerm σ m :=
      Summable.sum_le_tsum (Finset.range (M + 1))
        (fun i _ => (realPairTerm_pos hσ i).le) hsummableR
    calc
      (1 / 2) * (1 - (((2 * (M + 1) + 1 : ℕ) : ℝ) ^ (-σ)))
          = ∑ m ∈ Finset.range (M + 1), (1 / 2) * (h m - h (m + 1)) := htel.symm
      _ ≤ ∑ m ∈ Finset.range (M + 1), realPairTerm σ m :=
          Finset.sum_le_sum (fun m _ => half_pair_shift_le_realPairTerm hσ m)
      _ ≤ ∑' m : ℕ, realPairTerm σ m := hle_sum
  have hbase : Tendsto (fun M : ℕ => (((2 * (M + 1) + 1 : ℕ)) : ℝ)) atTop atTop := by
    have hnat : Tendsto (fun M : ℕ => (2 * (M + 1) + 1 : ℕ)) atTop atTop :=
      Filter.tendsto_atTop_mono (fun M => by show M ≤ 2 * (M + 1) + 1; omega) tendsto_id
    exact tendsto_natCast_atTop_atTop.comp hnat
  have hpow : Tendsto (fun M : ℕ => (((2 * (M + 1) + 1 : ℕ) : ℝ) ^ (-σ)))
      atTop (𝓝 0) :=
    (tendsto_rpow_neg_atTop hσ).comp hbase
  have htend : Tendsto
      (fun M : ℕ => (1 / 2) * (1 - (((2 * (M + 1) + 1 : ℕ) : ℝ) ^ (-σ))))
      atTop (𝓝 (1 / 2)) := by
    have h := (tendsto_const_nhds (x := (1 / 2 : ℝ))).mul
      ((tendsto_const_nhds (x := (1 : ℝ))).sub hpow)
    simpa using h
  exact le_of_tendsto_of_tendsto' htend
    (tendsto_const_nhds : Tendsto (fun _ : ℕ => ∑' m : ℕ, realPairTerm σ m)
      atTop (𝓝 (∑' m : ℕ, realPairTerm σ m))) hbound

/-- The eta prefactor `1 - 2^{1-σ}` has norm at most `1/2` for `σ ∈ [1/2,1)`. -/
theorem norm_one_sub_two_cpow_le_half {σ : ℝ} (h1 : (1 / 2 : ℝ) ≤ σ) (h2 : σ < 1) :
    ‖1 - (2 : ℂ) ^ (1 - (σ : ℂ))‖ ≤ (1 / 2 : ℝ) := by
  have ht0 : (0 : ℝ) ≤ 1 - σ := by linarith
  have ht1 : 1 - σ ≤ (1 / 2 : ℝ) := by linarith
  have hexp : (1 - (σ : ℂ)) = ((1 - σ : ℝ) : ℂ) := by push_cast; ring
  have hcast : (2 : ℂ) ^ (1 - (σ : ℂ)) = ((((2 : ℝ) ^ (1 - σ) : ℝ)) : ℂ) := by
    rw [hexp]
    rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num]
    exact (Complex.ofReal_cpow (by norm_num : (0 : ℝ) ≤ 2) (1 - σ)).symm
  rw [hcast]
  rw [show (1 : ℂ) - ((((2 : ℝ) ^ (1 - σ) : ℝ)) : ℂ)
      = (((1 - (2 : ℝ) ^ (1 - σ)) : ℝ) : ℂ) by push_cast; ring]
  rw [Complex.norm_real, Real.norm_eq_abs]
  have hx1 : (1 : ℝ) ≤ (2 : ℝ) ^ (1 - σ) := Real.one_le_rpow (by norm_num) ht0
  have hx2 : (2 : ℝ) ^ (1 - σ) ≤ Real.sqrt 2 := by
    have h := Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 2) ht1
    rwa [Real.sqrt_eq_rpow]
  have habs : |1 - (2 : ℝ) ^ (1 - σ)| = (2 : ℝ) ^ (1 - σ) - 1 := by
    rw [abs_of_nonpos (by linarith)]
    ring
  rw [habs]
  have hsqrt : Real.sqrt 2 ≤ (3 / 2 : ℝ) := by
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2), Real.sqrt_nonneg 2]
  linarith

/-- **`ζ` is at least one in norm on the real segment `[1/2,1)`.** -/
theorem zeta_real_abs_ge_one {σ : ℝ} (h1 : (1 / 2 : ℝ) ≤ σ) (h2 : σ < 1) :
    1 ≤ ‖riemannZeta (σ : ℂ)‖ := by
  have hσ : 0 < σ := by linarith
  have hσre : 0 < (σ : ℂ).re := by simpa using hσ
  have hne : (σ : ℂ) ≠ 1 := by
    intro h
    have h' : σ = 1 := by exact_mod_cast h
    linarith
  have heta_lb : (1 / 2 : ℝ) ≤ ‖etaGrouped (σ : ℂ)‖ := by
    have hsum : (1 / 2 : ℝ) ≤ ∑' m : ℕ, realPairTerm σ m :=
      half_le_tsum_realPairTerm hσ
    have hnonneg : (0 : ℝ) ≤ ∑' m : ℕ, realPairTerm σ m :=
      tsum_nonneg (fun m => (realPairTerm_pos hσ m).le)
    rw [etaGrouped_eq_ofReal_tsum, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg hnonneg]
    exact hsum
  have hident : etaGrouped (σ : ℂ) = (1 - (2 : ℂ) ^ (1 - (σ : ℂ))) * riemannZeta (σ : ℂ) :=
    etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hσre hne
  have hfac : ‖1 - (2 : ℂ) ^ (1 - (σ : ℂ))‖ ≤ (1 / 2 : ℝ) :=
    norm_one_sub_two_cpow_le_half h1 h2
  have hnormz : (0 : ℝ) ≤ ‖riemannZeta (σ : ℂ)‖ := norm_nonneg _
  rw [hident, norm_mul] at heta_lb
  have hprod : ‖1 - (2 : ℂ) ^ (1 - (σ : ℂ))‖ * ‖riemannZeta (σ : ℂ)‖
      ≤ (1 / 2 : ℝ) * ‖riemannZeta (σ : ℂ)‖ :=
    mul_le_mul_of_nonneg_right hfac hnormz
  linarith

/-! ## A uniform norm bound on the segment `1/2 ≤ Re s ≤ 3/4`, `|Im s| ≤ 1` -/

/-- **Uniform bound for `ζ` near the critical segment.**  On the rectangle
`1/2 ≤ Re s ≤ 3/4`, `|Im s| ≤ 1` the Riemann zeta function is bounded by `16`.

The proof uses the eta identity `η(s) = (1 - 2^{1-s}) ζ(s)`.  The grouped eta
series is bounded in norm by `‖s‖` times the majorant
`Σ (2m+1)^{-Re s-1} ≤ 1 + 1/(2 Re s) ≤ 2`, while `‖s‖ ≤ 5/4`, so
`‖η(s)‖ ≤ 5/2`.  Since `Re s ≤ 3/4` we have `1 - Re s ≥ 1/4`, hence
`‖2^{1-s}‖ = 2^{1-Re s} ≥ 2^{1/4} ≥ 7/6`, and reverse triangle gives
`‖1 - 2^{1-s}‖ ≥ 1/6`.  Therefore `‖ζ(s)‖ ≤ (5/2)/(1/6) = 15 ≤ 16`. -/
theorem norm_zeta_le_sixteen {s : ℂ} (h1 : (1 / 2 : ℝ) ≤ s.re) (h2 : s.re ≤ (3 / 4 : ℝ))
    (him : |s.im| ≤ 1) : ‖riemannZeta s‖ ≤ 16 := by
  have hre : 0 < s.re := by linarith
  have hne : s ≠ 1 := by
    intro h
    have hre1 : s.re = 1 := by rw [h]; simp
    linarith
  have hident : etaGrouped s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s :=
    etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hre hne
  -- `‖s‖ ≤ 5/4` on the rectangle.
  have hs_norm : ‖s‖ ≤ (5 / 4 : ℝ) := by
    have hsq : ‖s‖ ^ 2 = s.re * s.re + s.im * s.im := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
    have him_sq : s.im * s.im ≤ 1 := by
      nlinarith [abs_le.mp him]
    have hre_sq : s.re * s.re ≤ (3 / 4 : ℝ) * (3 / 4) := by nlinarith
    have hn : (0 : ℝ) ≤ ‖s‖ := norm_nonneg s
    nlinarith
  -- The grouped eta series is bounded by `5/2`.
  have heta_bound : ‖etaGrouped s‖ ≤ (5 / 2 : ℝ) := by
    have hs : Summable (fun m : ℕ => pairTerm s m) := summable_pairTerm hre
    have hnorm : ‖∑' m : ℕ, pairTerm s m‖ ≤ ∑' m : ℕ, ‖pairTerm s m‖ :=
      norm_tsum_le_tsum_norm hs.norm
    have hmaj : Summable (fun m : ℕ => ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1))) :=
      (summable_pairMajorant' hre).mul_left ‖s‖
    have hle : ∑' m : ℕ, ‖pairTerm s m‖ ≤
        ∑' m : ℕ, ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) :=
      hs.norm.tsum_le_tsum (fun m => norm_pairTerm_le hre le_rfl m) hmaj
    have hcast : (∑' m : ℕ, ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1))) =
        ‖s‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) :=
      tsum_mul_left
    have htail : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) ≤ 2 := by
      have h := tsum_pairMajorant_add_le (p := s.re + 1) (by linarith) 0
      have h' : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) ≤
          1 + 1 / (2 * s.re) := by
        simpa [show -(s.re + 1) = -s.re - 1 by ring] using h
      have hden : 1 / (2 * s.re) ≤ 1 := by
        rw [div_le_one (by linarith : (0 : ℝ) < 2 * s.re)]
        linarith
      linarith
    have htsum_nonneg : (0 : ℝ) ≤ ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) :=
      tsum_nonneg (fun m => Real.rpow_nonneg (by positivity) _)
    calc
      ‖etaGrouped s‖ = ‖∑' m : ℕ, pairTerm s m‖ := by rw [etaGrouped]
      _ ≤ ∑' m : ℕ, ‖pairTerm s m‖ := hnorm
      _ ≤ ∑' m : ℕ, ‖s‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) := hle
      _ = ‖s‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-s.re - 1)) := hcast
      _ ≤ (5 / 4 : ℝ) * 2 := mul_le_mul hs_norm htail htsum_nonneg (by norm_num)
      _ = 5 / 2 := by norm_num
  -- The eta prefactor is bounded below in norm by `1/6`.
  have hfac : (1 / 6 : ℝ) ≤ ‖1 - (2 : ℂ) ^ (1 - s)‖ := by
    have hnorm_w : ‖(2 : ℂ) ^ (1 - s)‖ = (2 : ℝ) ^ ((1 - s).re) :=
      Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num) (1 - s)
    have hre_exp : (1 - s).re = 1 - s.re := by simp
    have hpow_lb : (7 / 6 : ℝ) ≤ (2 : ℝ) ^ (1 - s.re) := by
      have hexp_le : ((1 : ℝ) / 4) ≤ 1 - s.re := by linarith
      have hmono : (2 : ℝ) ^ ((1 : ℝ) / 4) ≤ (2 : ℝ) ^ (1 - s.re) :=
        Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ)) (y := ((1 : ℝ) / 4))
          (z := 1 - s.re) (by norm_num) hexp_le
      have hfour : ((7 / 6 : ℝ) ^ 4) ≤ 2 := by norm_num
      have hbase : ((7 / 6 : ℝ) ^ 4) ^ ((1 : ℝ) / 4) ≤ (2 : ℝ) ^ ((1 : ℝ) / 4) :=
        Real.rpow_le_rpow (x := ((7 / 6 : ℝ) ^ 4)) (y := 2) (z := ((1 : ℝ) / 4))
          (by positivity) hfour (by norm_num)
      have heq : ((7 / 6 : ℝ) ^ 4) ^ ((1 : ℝ) / 4) = 7 / 6 := by
        rw [← Real.rpow_natCast (7 / 6) 4]
        rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 7 / 6)]
        norm_num
      linarith
    have htri : ‖(2 : ℂ) ^ (1 - s)‖ - 1 ≤ ‖1 - (2 : ℂ) ^ (1 - s)‖ := by
      have h := norm_sub_norm_le ((2 : ℂ) ^ (1 - s)) 1
      rwa [norm_one, norm_sub_rev] at h
    rw [hnorm_w, hre_exp] at htri
    linarith
  have hzeta : ‖riemannZeta s‖ ≤ 15 := by
    have hprod : (1 / 6 : ℝ) * ‖riemannZeta s‖ ≤ ‖etaGrouped s‖ := by
      rw [hident, norm_mul]
      exact mul_le_mul_of_nonneg_right hfac (norm_nonneg _)
    nlinarith
  linarith

/-! ## A bound for the derivative of `ζ` on the critical segment -/

/-- **Derivative bound on the critical segment.**  For `1/2 ≤ σ ≤ 3/4`,
`‖ζ'(σ)‖ ≤ 512`.

The bound is obtained from Cauchy's estimate on the disc of radius `1/8` about
`σ`.  On that disc `ζ` is holomorphic (the pole at `1` lies outside), and on
the boundary circle `Re z ≤ 7/8`, `|Im z| ≤ 1/8`.  On this rectangle we repeat
the eta-majorant argument of `norm_zeta_le_sixteen`: `‖η(z)‖ ≤ 7/3` while
`‖1 - 2^{1-z}‖ ≥ 9/100` (because `1 - Re z ≥ 1/8` and `2^{1/8} ≥ 109/100`),
so `‖ζ(z)‖ ≤ (7/3)/(9/100) = 700/27 ≤ 28`.  Cauchy's estimate then gives
`‖ζ'(σ)‖ ≤ 28/(1/8) = 224 ≤ 512`. -/
theorem norm_deriv_zeta_le {σ : ℝ} (h1 : (1 / 2 : ℝ) ≤ σ) (h2 : σ ≤ (3 / 4 : ℝ)) :
    ‖deriv riemannZeta (σ : ℂ)‖ ≤ 512 := by
  -- A uniform bound for `ζ` on the rectangle `3/8 ≤ Re z ≤ 7/8`, `|Im z| ≤ 1/8`.
  have rect : ∀ z : ℂ, (3 / 8 : ℝ) ≤ z.re → z.re ≤ (7 / 8 : ℝ) → |z.im| ≤ (1 / 8 : ℝ) →
      ‖riemannZeta z‖ ≤ 28 := by
    intro z hzlo hzhi hzim
    have hre : 0 < z.re := by linarith
    have hne : z ≠ 1 := by
      intro h
      have hre1 : z.re = 1 := by rw [h]; simp
      linarith
    have hident : etaGrouped z = (1 - (2 : ℂ) ^ (1 - z)) * riemannZeta z :=
      etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hre hne
    -- `‖z‖ ≤ 1` on the rectangle.
    have hz_norm : ‖z‖ ≤ 1 := by
      have hsq : ‖z‖ ^ 2 = z.re * z.re + z.im * z.im := by
        rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      have him_sq : z.im * z.im ≤ (1 / 8 : ℝ) * (1 / 8) := by
        nlinarith [abs_le.mp hzim]
      have hre_sq : z.re * z.re ≤ (7 / 8 : ℝ) * (7 / 8) := by nlinarith
      have hn : (0 : ℝ) ≤ ‖z‖ := norm_nonneg z
      nlinarith
    -- The grouped eta series is bounded by `7/3`.
    have heta_bound : ‖etaGrouped z‖ ≤ (7 / 3 : ℝ) := by
      have hs : Summable (fun m : ℕ => pairTerm z m) := summable_pairTerm hre
      have hnorm : ‖∑' m : ℕ, pairTerm z m‖ ≤ ∑' m : ℕ, ‖pairTerm z m‖ :=
        norm_tsum_le_tsum_norm hs.norm
      have hmaj : Summable (fun m : ℕ => ‖z‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1))) :=
        (summable_pairMajorant' hre).mul_left ‖z‖
      have hle : ∑' m : ℕ, ‖pairTerm z m‖ ≤
          ∑' m : ℕ, ‖z‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) :=
        hs.norm.tsum_le_tsum (fun m => norm_pairTerm_le hre le_rfl m) hmaj
      have hcast : (∑' m : ℕ, ‖z‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1))) =
          ‖z‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) :=
        tsum_mul_left
      have htail : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) ≤ 7 / 3 := by
        have h := tsum_pairMajorant_add_le (p := z.re + 1) (by linarith) 0
        have h' : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) ≤
            1 + 1 / (2 * z.re) := by
          simpa [show -(z.re + 1) = -z.re - 1 by ring] using h
        have hden : 1 / (2 * z.re) ≤ 4 / 3 := by
          have hpos : (0 : ℝ) < 2 * z.re := by linarith
          rw [div_le_div_iff₀ hpos (by norm_num)]
          linarith
        linarith
      have htsum_nonneg : (0 : ℝ) ≤ ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) :=
        tsum_nonneg (fun m => Real.rpow_nonneg (by positivity) _)
      calc
        ‖etaGrouped z‖ = ‖∑' m : ℕ, pairTerm z m‖ := by rw [etaGrouped]
        _ ≤ ∑' m : ℕ, ‖pairTerm z m‖ := hnorm
        _ ≤ ∑' m : ℕ, ‖z‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) := hle
        _ = ‖z‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-z.re - 1)) := hcast
        _ ≤ 1 * (7 / 3) := mul_le_mul hz_norm htail htsum_nonneg (by norm_num)
        _ = 7 / 3 := by norm_num
    -- The eta prefactor is bounded below in norm by `9/100`.
    have hfac : (9 / 100 : ℝ) ≤ ‖1 - (2 : ℂ) ^ (1 - z)‖ := by
      have hnorm_w : ‖(2 : ℂ) ^ (1 - z)‖ = (2 : ℝ) ^ ((1 - z).re) :=
        Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num) (1 - z)
      have hre_exp : (1 - z).re = 1 - z.re := by simp
      have hpow_lb : (109 / 100 : ℝ) ≤ (2 : ℝ) ^ (1 - z.re) := by
        have hexp_le : ((1 : ℝ) / 8) ≤ 1 - z.re := by linarith
        have hmono : (2 : ℝ) ^ ((1 : ℝ) / 8) ≤ (2 : ℝ) ^ (1 - z.re) :=
          Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ)) (y := ((1 : ℝ) / 8))
            (z := 1 - z.re) (by norm_num) hexp_le
        have hbase : ((109 / 100 : ℝ) ^ 8) ≤ 2 := by norm_num
        have hpow : ((109 / 100 : ℝ) ^ 8) ^ ((1 : ℝ) / 8) ≤ (2 : ℝ) ^ ((1 : ℝ) / 8) :=
          Real.rpow_le_rpow (x := ((109 / 100 : ℝ) ^ 8)) (y := 2) (z := ((1 : ℝ) / 8))
            (by positivity) hbase (by norm_num)
        have heq : ((109 / 100 : ℝ) ^ 8) ^ ((1 : ℝ) / 8) = 109 / 100 := by
          rw [← Real.rpow_natCast (109 / 100) 8]
          rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 109 / 100)]
          norm_num
        linarith
      have htri : ‖(2 : ℂ) ^ (1 - z)‖ - 1 ≤ ‖1 - (2 : ℂ) ^ (1 - z)‖ := by
        have h := norm_sub_norm_le ((2 : ℂ) ^ (1 - z)) 1
        rwa [norm_one, norm_sub_rev] at h
      rw [hnorm_w, hre_exp] at htri
      linarith
    have hzeta : ‖riemannZeta z‖ ≤ 700 / 27 := by
      have hprod : (9 / 100 : ℝ) * ‖riemannZeta z‖ ≤ ‖etaGrouped z‖ := by
        rw [hident, norm_mul]
        exact mul_le_mul_of_nonneg_right hfac (norm_nonneg _)
      nlinarith
    linarith
  -- `ζ` is holomorphic on the disc of radius `1/8` about `σ`, since it avoids `1`.
  have hR : (0 : ℝ) < 1 / 8 := by norm_num
  have hsub : Metric.closedBall (σ : ℂ) (1 / 8) ⊆ ({1}ᶜ : Set ℂ) := by
    intro z hz
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    intro hz1
    have hzre : z.re = 1 := by rw [hz1]; simp
    rw [Metric.mem_closedBall, dist_eq_norm] at hz
    have hbound : z.re - σ ≤ 1 / 8 := by
      have h := Complex.re_le_norm (z - (σ : ℂ))
      rw [Complex.sub_re, Complex.ofReal_re] at h
      linarith
    linarith
  have hd : DiffContOnCl ℂ riemannZeta (Metric.ball (σ : ℂ) (1 / 8)) :=
    DifferentiableOn.diffContOnCl_ball differentiableOn_riemannZeta hsub
  have hC : ∀ z ∈ Metric.sphere (σ : ℂ) (1 / 8), ‖riemannZeta z‖ ≤ 28 := by
    intro z hz
    rw [Metric.mem_sphere, dist_eq_norm] at hz
    have hre_up : z.re ≤ (7 / 8 : ℝ) := by
      have h := Complex.re_le_norm (z - (σ : ℂ))
      rw [Complex.sub_re, Complex.ofReal_re] at h
      linarith
    have hre_lo : (3 / 8 : ℝ) ≤ z.re := by
      have h := Complex.re_le_norm ((σ : ℂ) - z)
      rw [Complex.sub_re, Complex.ofReal_re] at h
      have hnorm : ‖(σ : ℂ) - z‖ = 1 / 8 := by
        rw [norm_sub_rev]
        exact hz
      linarith
    have him : |z.im| ≤ (1 / 8 : ℝ) := by
      have h := Complex.abs_im_le_norm (z - (σ : ℂ))
      rw [Complex.sub_im, Complex.ofReal_im, sub_zero] at h
      rwa [hz] at h
    exact rect z hre_lo hre_up him
  have hderiv := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le (c := (σ : ℂ)) (R := 1 / 8)
    (C := 28) (f := riemannZeta) hR hd hC
  have hconst : (28 : ℝ) / (1 / 8) = 224 := by norm_num
  linarith

/-- **Derivative bound in a complex neighbourhood of the critical segment.**
For `z` with `1/2 ≤ Re z ≤ 3/4` and `|Im z| ≤ 1/8`, `‖ζ'(z)‖ ≤ 512`.

The proof repeats the Cauchy estimate of `norm_deriv_zeta_le`, now with centre
`z` and radius `1/8`.  The closed disc lies in `3/8 ≤ Re w ≤ 7/8`,
`|Im w| ≤ 1/4`, hence avoids the pole at `1`.  On that rectangle the
eta-majorant argument gives `‖η(w)‖ ≤ 2 · (1 + 4/3) = 14/3` (using
`‖w‖ ≤ 2` and `Re w ≥ 3/8`), while `‖1 - 2^{1-w}‖ ≥ 9/100` as in the real
case, so `‖ζ(w)‖ ≤ (14/3)/(9/100) = 1400/27 ≤ 64`.  Cauchy's estimate then
yields `‖ζ'(z)‖ ≤ 64/(1/8) = 512`. -/
theorem norm_deriv_zeta_le_complex {z : ℂ} (h1 : (1 / 2 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (3 / 4 : ℝ)) (him : |z.im| ≤ (1 / 8 : ℝ)) :
    ‖deriv riemannZeta z‖ ≤ 512 := by
  -- A uniform bound for `ζ` on the rectangle `3/8 ≤ Re w ≤ 7/8`, `|Im w| ≤ 1/4`.
  have rect : ∀ w : ℂ, (3 / 8 : ℝ) ≤ w.re → w.re ≤ (7 / 8 : ℝ) →
      |w.im| ≤ (1 / 4 : ℝ) → ‖riemannZeta w‖ ≤ 64 := by
    intro w hwlo hwhi hwim
    have hre : 0 < w.re := by linarith
    have hne : w ≠ 1 := by
      intro h
      have hre1 : w.re = 1 := by rw [h]; simp
      linarith
    have hident : etaGrouped w = (1 - (2 : ℂ) ^ (1 - w)) * riemannZeta w :=
      etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hre hne
    -- `‖w‖ ≤ 2` on the rectangle.
    have hw_norm : ‖w‖ ≤ 2 := by
      have hsq : ‖w‖ ^ 2 = w.re * w.re + w.im * w.im := by
        rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
      have him_sq : w.im * w.im ≤ (1 / 4 : ℝ) * (1 / 4) := by
        nlinarith [abs_le.mp hwim]
      have hre_sq : w.re * w.re ≤ (7 / 8 : ℝ) * (7 / 8) := by nlinarith
      have hn : (0 : ℝ) ≤ ‖w‖ := norm_nonneg w
      nlinarith
    -- The grouped eta series is bounded by `14/3`.
    have heta_bound : ‖etaGrouped w‖ ≤ (14 / 3 : ℝ) := by
      have hs : Summable (fun m : ℕ => pairTerm w m) := summable_pairTerm hre
      have hnorm : ‖∑' m : ℕ, pairTerm w m‖ ≤ ∑' m : ℕ, ‖pairTerm w m‖ :=
        norm_tsum_le_tsum_norm hs.norm
      have hmaj : Summable (fun m : ℕ => ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1))) :=
        (summable_pairMajorant' hre).mul_left ‖w‖
      have hle : ∑' m : ℕ, ‖pairTerm w m‖ ≤
          ∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
        hs.norm.tsum_le_tsum (fun m => norm_pairTerm_le hre le_rfl m) hmaj
      have hcast : (∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1))) =
          ‖w‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
        tsum_mul_left
      have htail : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) ≤ 7 / 3 := by
        have h := tsum_pairMajorant_add_le (p := w.re + 1) (by linarith) 0
        have h' : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) ≤
            1 + 1 / (2 * w.re) := by
          simpa [show -(w.re + 1) = -w.re - 1 by ring] using h
        have hden : 1 / (2 * w.re) ≤ 4 / 3 := by
          have hpos : (0 : ℝ) < 2 * w.re := by linarith
          rw [div_le_div_iff₀ hpos (by norm_num)]
          linarith
        linarith
      have htsum_nonneg : (0 : ℝ) ≤ ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
        tsum_nonneg (fun m => Real.rpow_nonneg (by positivity) _)
      calc
        ‖etaGrouped w‖ = ‖∑' m : ℕ, pairTerm w m‖ := by rw [etaGrouped]
        _ ≤ ∑' m : ℕ, ‖pairTerm w m‖ := hnorm
        _ ≤ ∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) := hle
        _ = ‖w‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) := hcast
        _ ≤ 2 * (7 / 3) := mul_le_mul hw_norm htail htsum_nonneg (by norm_num)
        _ = 14 / 3 := by norm_num
    -- The eta prefactor is bounded below in norm by `9/100`.
    have hfac : (9 / 100 : ℝ) ≤ ‖1 - (2 : ℂ) ^ (1 - w)‖ := by
      have hnorm_w : ‖(2 : ℂ) ^ (1 - w)‖ = (2 : ℝ) ^ ((1 - w).re) :=
        Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num) (1 - w)
      have hre_exp : (1 - w).re = 1 - w.re := by simp
      have hpow_lb : (109 / 100 : ℝ) ≤ (2 : ℝ) ^ (1 - w.re) := by
        have hexp_le : ((1 : ℝ) / 8) ≤ 1 - w.re := by linarith
        have hmono : (2 : ℝ) ^ ((1 : ℝ) / 8) ≤ (2 : ℝ) ^ (1 - w.re) :=
          Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ)) (y := ((1 : ℝ) / 8))
            (z := 1 - w.re) (by norm_num) hexp_le
        have hbase : ((109 / 100 : ℝ) ^ 8) ≤ 2 := by norm_num
        have hpow : ((109 / 100 : ℝ) ^ 8) ^ ((1 : ℝ) / 8) ≤ (2 : ℝ) ^ ((1 : ℝ) / 8) :=
          Real.rpow_le_rpow (x := ((109 / 100 : ℝ) ^ 8)) (y := 2) (z := ((1 : ℝ) / 8))
            (by positivity) hbase (by norm_num)
        have heq : ((109 / 100 : ℝ) ^ 8) ^ ((1 : ℝ) / 8) = 109 / 100 := by
          rw [← Real.rpow_natCast (109 / 100) 8]
          rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 109 / 100)]
          norm_num
        linarith
      have htri : ‖(2 : ℂ) ^ (1 - w)‖ - 1 ≤ ‖1 - (2 : ℂ) ^ (1 - w)‖ := by
        have h := norm_sub_norm_le ((2 : ℂ) ^ (1 - w)) 1
        rwa [norm_one, norm_sub_rev] at h
      rw [hnorm_w, hre_exp] at htri
      linarith
    have hzeta : ‖riemannZeta w‖ ≤ 64 := by
      have hprod : (9 / 100 : ℝ) * ‖riemannZeta w‖ ≤ ‖etaGrouped w‖ := by
        rw [hident, norm_mul]
        exact mul_le_mul_of_nonneg_right hfac (norm_nonneg _)
      nlinarith
    exact hzeta
  -- `ζ` is holomorphic on the disc of radius `1/8` about `z`, since it avoids `1`.
  have hR : (0 : ℝ) < 1 / 8 := by norm_num
  have hsub : Metric.closedBall z (1 / 8) ⊆ ({1}ᶜ : Set ℂ) := by
    intro w hw
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    intro hw1
    have hwre : w.re = 1 := by rw [hw1]; simp
    rw [Metric.mem_closedBall, dist_eq_norm] at hw
    have hbound : w.re - z.re ≤ 1 / 8 := by
      have h := Complex.re_le_norm (w - z)
      rw [Complex.sub_re] at h
      linarith
    linarith
  have hd : DiffContOnCl ℂ riemannZeta (Metric.ball z (1 / 8)) :=
    DifferentiableOn.diffContOnCl_ball differentiableOn_riemannZeta hsub
  have hC : ∀ w ∈ Metric.sphere z (1 / 8), ‖riemannZeta w‖ ≤ 64 := by
    intro w hw
    rw [Metric.mem_sphere, dist_eq_norm] at hw
    have hre_up : w.re ≤ (7 / 8 : ℝ) := by
      have h := Complex.re_le_norm (w - z)
      rw [Complex.sub_re] at h
      linarith
    have hre_lo : (3 / 8 : ℝ) ≤ w.re := by
      have h := Complex.re_le_norm (z - w)
      rw [Complex.sub_re] at h
      have hnorm : ‖z - w‖ = 1 / 8 := by
        rw [norm_sub_rev]
        exact hw
      linarith
    have hwim : |w.im| ≤ (1 / 4 : ℝ) := by
      have h := Complex.abs_im_le_norm (w - z)
      rw [Complex.sub_im] at h
      have h1 := abs_le.mp h
      have h2 := abs_le.mp him
      rw [abs_le]
      constructor <;> linarith
    exact rect w hre_lo hre_up hwim
  have hderiv := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le (c := z) (R := 1 / 8)
    (C := 64) (f := riemannZeta) hR hd hC
  have hconst : (64 : ℝ) / (1 / 8) = 512 := by norm_num
  linarith

/-- **`ζ` has no zeros in the central band `|Im z| ≤ 1/2048` over `1/2 ≤ Re z ≤ 3/4`.**

T581 supplies `1 ≤ ‖ζ σ‖` on the real axis, and T584 bounds the derivative by `512`
on the complex strip `|Im w| ≤ 1/8`.  The mean-value inequality on the segment from
`σ = Re z` to `z` then gives `‖ζ z - ζ σ‖ ≤ 512 · |Im z| ≤ 1/4`, so
`‖ζ z‖ ≥ 1 - 1/4 = 3/4 > 0`. -/
theorem zeta_ne_zero_central_band {z : ℂ} (h1 : (1 / 2 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (3 / 4 : ℝ)) (him : |z.im| ≤ (1 / 2048 : ℝ)) :
    riemannZeta z ≠ 0 := by
  set σ : ℝ := z.re with hσdef
  have hσ1 : (1 / 2 : ℝ) ≤ σ := by rw [hσdef]; exact h1
  have hσ2 : σ ≤ (3 / 4 : ℝ) := by rw [hσdef]; exact h2
  have hσ_lt_one : σ < 1 := by linarith
  -- Points of the segment have real part `σ` and imaginary part bounded by `|z.im|`.
  have hseg : ∀ w ∈ segment ℝ (σ : ℂ) z, w.re = σ ∧ |w.im| ≤ |z.im| := by
    intro w hw
    rw [segment_eq_image] at hw
    obtain ⟨θ, hθ, rfl⟩ := hw
    have hθ0 : (0 : ℝ) ≤ θ := hθ.1
    have hθ1 : θ ≤ 1 := hθ.2
    constructor
    · have hre : ((1 - θ) • (σ : ℂ) + θ • z).re = (1 - θ) * σ + θ * z.re := by
        simp [Complex.add_re]
      rw [hre, ← hσdef]
      ring
    · have him_eq : ((1 - θ) • (σ : ℂ) + θ • z).im = θ * z.im := by
        simp [Complex.add_im, Complex.ofReal_im]
      rw [him_eq, abs_mul, abs_of_nonneg hθ0]
      nlinarith [abs_nonneg z.im]
  -- `ζ` is differentiable at every point of the segment (they all avoid `1`).
  have hdiff : ∀ w ∈ segment ℝ (σ : ℂ) z, DifferentiableAt ℂ riemannZeta w := by
    intro w hw
    apply differentiableAt_riemannZeta
    intro hw1
    have hwre : w.re = σ := (hseg w hw).1
    rw [hw1] at hwre
    simp at hwre
    linarith
  -- The derivative is bounded by `512` on the segment (T584).
  have hbound : ∀ w ∈ segment ℝ (σ : ℂ) z, ‖deriv riemannZeta w‖ ≤ 512 := by
    intro w hw
    obtain ⟨hwre, hwim⟩ := hseg w hw
    have h8 : |w.im| ≤ (1 / 8 : ℝ) := by linarith
    exact norm_deriv_zeta_le_complex (by rw [hwre]; exact hσ1)
      (by rw [hwre]; exact hσ2) h8
  have hmvt := Convex.norm_image_sub_le_of_norm_deriv_le (f := riemannZeta)
    (s := segment ℝ (σ : ℂ) z) (x := (σ : ℂ)) (y := z) (C := 512)
    hdiff hbound (convex_segment _ _) (left_mem_segment ℝ _ _) (right_mem_segment ℝ _ _)
  -- The distance from `σ` to `z` is `|Im z|`.
  have hdist : ‖z - (σ : ℂ)‖ = |z.im| := by
    have hz : z - (σ : ℂ) = (z.im : ℂ) * Complex.I := by
      apply Complex.ext
      · simp [Complex.mul_re, Complex.sub_re, hσdef]
      · simp [Complex.mul_im, Complex.sub_im, hσdef]
    rw [hz, norm_mul, Complex.norm_real, Complex.norm_I, mul_one, Real.norm_eq_abs]
  have hstep : ‖riemannZeta z - riemannZeta (σ : ℂ)‖ ≤ (1 / 4 : ℝ) := by
    have h := hmvt
    rw [hdist] at h
    nlinarith
  -- Reverse triangle inequality together with T581.
  have h581 : (1 : ℝ) ≤ ‖riemannZeta (σ : ℂ)‖ := zeta_real_abs_ge_one hσ1 hσ_lt_one
  have hrev : |‖riemannZeta (σ : ℂ)‖ - ‖riemannZeta z‖| ≤
      ‖riemannZeta (σ : ℂ) - riemannZeta z‖ := abs_norm_sub_norm_le _ _
  have hsym : ‖riemannZeta (σ : ℂ) - riemannZeta z‖ = ‖riemannZeta z - riemannZeta (σ : ℂ)‖ :=
    norm_sub_rev _ _
  have hnorm : (3 / 4 : ℝ) ≤ ‖riemannZeta z‖ := by
    rw [hsym] at hrev
    have h := abs_le.mp hrev
    linarith [h.2]
  intro hzero
  rw [hzero, norm_zero] at hnorm
  norm_num at hnorm


/-- **Mirrored explicit central band.**  The zero-free band `1/2 ≤ Re ≤ 3/4`
mirrors to `1/4 ≤ Re ≤ 1/2` by the completed-zeta functional equation. -/
theorem zeta_ne_zero_central_band_left {z : ℂ} (h1 : (1 / 4 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (1 / 2 : ℝ)) (him : |z.im| ≤ (1 / 2048 : ℝ)) :
    riemannZeta z ≠ 0 := by
  have hzre0 : 0 < z.re := by linarith
  have hzre1 : z.re < 1 := by linarith
  have hne : z ≠ 1 := by
    intro h; rw [h] at hzre1; norm_num at hzre1
  intro hz0
  have hcomp : completedZeta z = 0 :=
    (completedZeta_eq_zero_iff_zeta hzre0 hzre1).mpr hz0
  have hΓ : z.Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hzre0
  have hΓ' : (1 - z).Gammaℝ ≠ 0 :=
    Complex.Gammaℝ_ne_zero_of_re_pos (by simpa using sub_pos.mpr hzre1)
  have hcomp' : completedZeta (1 - z) = 0 := by
    rw [completedZeta_one_sub (by
      intro h; rw [h] at hzre0; norm_num at hzre0) hne hΓ hΓ']
    exact hcomp
  have hre' : (1 / 2 : ℝ) ≤ (1 - z).re := by
    simp [Complex.sub_re]
    linarith
  have hre2' : (1 - z).re ≤ (3 / 4 : ℝ) := by
    simp [Complex.sub_re]
    linarith
  have him' : |(1 - z).im| ≤ (1 / 2048 : ℝ) := by simpa using him
  have hzre0' : 0 < (1 - z).re := by linarith
  have hzre1' : (1 - z).re < 1 := by linarith
  have hz0' : riemannZeta (1 - z) = 0 :=
    (completedZeta_eq_zero_iff_zeta hzre0' hzre1').mp hcomp'
  exact zeta_ne_zero_central_band hre' hre2' him' hz0'

/-! ## The band `3/4 ≤ Re z ≤ 7/8`, `|Im z| ≤ 1/2048`

We repeat the argument of `zeta_ne_zero_central_band` with centre `σ = Re z`
lying further to the right.  The price is that the Cauchy disc about a point of
the new band reaches `Re w = 15/16`, so the eta majorant has to be evaluated on
`11/16 ≤ Re w ≤ 15/16`, `|Im w| ≤ 1/8` rather than on the rectangle used for
T584. -/

/-- **Local bound for `ζ` on `11/16 ≤ Re w ≤ 15/16`, `|Im w| ≤ 1/8`.**

On this rectangle `‖w‖ ≤ 1` and `Re w ≥ 11/16`, so the grouped eta series is
bounded by `1 + 1/(2 · 11/16) = 19/11`.  Since `1 - Re w ≥ 1/16` and
`2^{1/16} ≥ 33/32` (because `(33/32)^16 ≤ 2`), the prefactor `1 - 2^{1-w}` has
norm at least `1/32`.  Hence `‖ζ w‖ ≤ (19/11)/(1/32) = 608/11 ≤ 64`. -/
theorem norm_zeta_le_sixtyfour_band {w : ℂ} (h1 : (11 / 16 : ℝ) ≤ w.re)
    (h2 : w.re ≤ (15 / 16 : ℝ)) (him : |w.im| ≤ (1 / 8 : ℝ)) :
    ‖riemannZeta w‖ ≤ 64 := by
  have hre : 0 < w.re := by linarith
  have hne : w ≠ 1 := by
    intro h
    have hre1 : w.re = 1 := by rw [h]; simp
    linarith
  have hident : etaGrouped w = (1 - (2 : ℂ) ^ (1 - w)) * riemannZeta w :=
    etaGrouped_eq_one_sub_two_cpow_mul_zeta_of_re_pos hre hne
  -- `‖w‖ ≤ 1` on the rectangle.
  have hw_norm : ‖w‖ ≤ 1 := by
    have hsq : ‖w‖ ^ 2 = w.re * w.re + w.im * w.im := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]
    have him_sq : w.im * w.im ≤ (1 / 8 : ℝ) * (1 / 8) := by
      nlinarith [abs_le.mp him]
    have hre_sq : w.re * w.re ≤ (15 / 16 : ℝ) * (15 / 16) := by nlinarith
    have hn : (0 : ℝ) ≤ ‖w‖ := norm_nonneg w
    nlinarith
  -- The grouped eta series is bounded by `19/11`.
  have heta_bound : ‖etaGrouped w‖ ≤ (19 / 11 : ℝ) := by
    have hs : Summable (fun m : ℕ => pairTerm w m) := summable_pairTerm hre
    have hnorm : ‖∑' m : ℕ, pairTerm w m‖ ≤ ∑' m : ℕ, ‖pairTerm w m‖ :=
      norm_tsum_le_tsum_norm hs.norm
    have hmaj : Summable (fun m : ℕ => ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1))) :=
      (summable_pairMajorant' hre).mul_left ‖w‖
    have hle : ∑' m : ℕ, ‖pairTerm w m‖ ≤
        ∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
      hs.norm.tsum_le_tsum (fun m => norm_pairTerm_le hre le_rfl m) hmaj
    have hcast : (∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1))) =
        ‖w‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
      tsum_mul_left
    have htail : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) ≤ 19 / 11 := by
      have h := tsum_pairMajorant_add_le (p := w.re + 1) (by linarith) 0
      have h' : ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) ≤
          1 + 1 / (2 * w.re) := by
        simpa [show -(w.re + 1) = -w.re - 1 by ring] using h
      have hden : 1 / (2 * w.re) ≤ 8 / 11 := by
        have hpos : (0 : ℝ) < 2 * w.re := by linarith
        rw [div_le_div_iff₀ hpos (by norm_num)]
        linarith
      linarith
    have htsum_nonneg : (0 : ℝ) ≤ ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) :=
      tsum_nonneg (fun m => Real.rpow_nonneg (by positivity) _)
    calc
      ‖etaGrouped w‖ = ‖∑' m : ℕ, pairTerm w m‖ := by rw [etaGrouped]
      _ ≤ ∑' m : ℕ, ‖pairTerm w m‖ := hnorm
      _ ≤ ∑' m : ℕ, ‖w‖ * (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) := hle
      _ = ‖w‖ * ∑' m : ℕ, (((2 * m + 1 : ℕ) : ℝ) ^ (-w.re - 1)) := hcast
      _ ≤ 1 * (19 / 11) := mul_le_mul hw_norm htail htsum_nonneg (by norm_num)
      _ = 19 / 11 := by norm_num
  -- The eta prefactor is bounded below in norm by `1/32`.
  have hfac : (1 / 32 : ℝ) ≤ ‖1 - (2 : ℂ) ^ (1 - w)‖ := by
    have hnorm_w : ‖(2 : ℂ) ^ (1 - w)‖ = (2 : ℝ) ^ ((1 - w).re) :=
      Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num) (1 - w)
    have hre_exp : (1 - w).re = 1 - w.re := by simp
    have hpow_lb : (33 / 32 : ℝ) ≤ (2 : ℝ) ^ (1 - w.re) := by
      have hexp_le : ((1 : ℝ) / 16) ≤ 1 - w.re := by linarith
      have hmono : (2 : ℝ) ^ ((1 : ℝ) / 16) ≤ (2 : ℝ) ^ (1 - w.re) :=
        Real.rpow_le_rpow_of_exponent_le (x := (2 : ℝ)) (y := ((1 : ℝ) / 16))
          (z := 1 - w.re) (by norm_num) hexp_le
      have hbase : ((33 / 32 : ℝ) ^ 16) ≤ 2 := by norm_num
      have hpow : ((33 / 32 : ℝ) ^ 16) ^ ((1 : ℝ) / 16) ≤ (2 : ℝ) ^ ((1 : ℝ) / 16) :=
        Real.rpow_le_rpow (x := ((33 / 32 : ℝ) ^ 16)) (y := 2) (z := ((1 : ℝ) / 16))
          (by positivity) hbase (by norm_num)
      have heq : ((33 / 32 : ℝ) ^ 16) ^ ((1 : ℝ) / 16) = 33 / 32 := by
        rw [← Real.rpow_natCast (33 / 32) 16]
        rw [← Real.rpow_mul (by positivity : (0 : ℝ) ≤ 33 / 32)]
        norm_num
      linarith
    have htri : ‖(2 : ℂ) ^ (1 - w)‖ - 1 ≤ ‖1 - (2 : ℂ) ^ (1 - w)‖ := by
      have h := norm_sub_norm_le ((2 : ℂ) ^ (1 - w)) 1
      rwa [norm_one, norm_sub_rev] at h
    rw [hnorm_w, hre_exp] at htri
    linarith
  have hzeta : ‖riemannZeta w‖ ≤ 64 := by
    have hprod : (1 / 32 : ℝ) * ‖riemannZeta w‖ ≤ ‖etaGrouped w‖ := by
      rw [hident, norm_mul]
      exact mul_le_mul_of_nonneg_right hfac (norm_nonneg _)
    nlinarith
  exact hzeta

/-- **Derivative bound on `3/4 ≤ Re z ≤ 7/8`, `|Im z| ≤ 1/16`.**  Cauchy's
estimate on the disc of radius `1/16` about `z`, combined with the local bound
`norm_zeta_le_sixtyfour_band` on the enlarged rectangle
`11/16 ≤ Re w ≤ 15/16`, `|Im w| ≤ 1/8`, gives `‖ζ'(z)‖ ≤ 64 · 16 = 1024`. -/
theorem norm_deriv_zeta_le_band {z : ℂ} (h1 : (3 / 4 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (7 / 8 : ℝ)) (him : |z.im| ≤ (1 / 16 : ℝ)) :
    ‖deriv riemannZeta z‖ ≤ 1024 := by
  have hR : (0 : ℝ) < 1 / 16 := by norm_num
  have hsub : Metric.closedBall z (1 / 16) ⊆ ({1}ᶜ : Set ℂ) := by
    intro w hw
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    intro hw1
    have hwre : w.re = 1 := by rw [hw1]; simp
    rw [Metric.mem_closedBall, dist_eq_norm] at hw
    have hbound : w.re - z.re ≤ 1 / 16 := by
      have h := Complex.re_le_norm (w - z)
      rw [Complex.sub_re] at h
      linarith
    linarith
  have hd : DiffContOnCl ℂ riemannZeta (Metric.ball z (1 / 16)) :=
    DifferentiableOn.diffContOnCl_ball differentiableOn_riemannZeta hsub
  have hC : ∀ w ∈ Metric.sphere z (1 / 16), ‖riemannZeta w‖ ≤ 64 := by
    intro w hw
    rw [Metric.mem_sphere, dist_eq_norm] at hw
    have hre_up : w.re ≤ (15 / 16 : ℝ) := by
      have h := Complex.re_le_norm (w - z)
      rw [Complex.sub_re] at h
      linarith
    have hre_lo : (11 / 16 : ℝ) ≤ w.re := by
      have h := Complex.re_le_norm (z - w)
      rw [Complex.sub_re] at h
      have hnorm : ‖z - w‖ = 1 / 16 := by
        rw [norm_sub_rev]
        exact hw
      linarith
    have hwim : |w.im| ≤ (1 / 8 : ℝ) := by
      have h := Complex.abs_im_le_norm (w - z)
      rw [Complex.sub_im] at h
      have h1 := abs_le.mp h
      have h2 := abs_le.mp him
      rw [abs_le]
      constructor <;> linarith
    exact norm_zeta_le_sixtyfour_band hre_lo hre_up hwim
  have hderiv := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le (c := z) (R := 1 / 16)
    (C := 64) (f := riemannZeta) hR hd hC
  have hconst : (64 : ℝ) / (1 / 16) = 1024 := by norm_num
  linarith

/-- **`ζ` has no zeros in the band `3/4 ≤ Re z ≤ 7/8` with `|Im z| ≤ 1/2048`.**

T581 supplies `1 ≤ ‖ζ σ‖` on the real axis at `σ = Re z ≤ 7/8 < 1`, while
`norm_deriv_zeta_le_band` bounds the derivative by `1024` on the segment from
`σ` to `z`.  The mean-value inequality gives
`‖ζ z - ζ σ‖ ≤ 1024 · |Im z| ≤ 1/2`, hence `‖ζ z‖ ≥ 1/2`. -/
theorem zeta_ne_zero_band_34_78 {z : ℂ} (h1 : (3 / 4 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (7 / 8 : ℝ)) (him : |z.im| ≤ (1 / 2048 : ℝ)) :
    riemannZeta z ≠ 0 := by
  set σ : ℝ := z.re with hσdef
  have hσ1 : (3 / 4 : ℝ) ≤ σ := by rw [hσdef]; exact h1
  have hσ2 : σ ≤ (7 / 8 : ℝ) := by rw [hσdef]; exact h2
  have hσ_lt_one : σ < 1 := by linarith
  -- Points of the segment have real part `σ` and imaginary part bounded by `|z.im|`.
  have hseg : ∀ w ∈ segment ℝ (σ : ℂ) z, w.re = σ ∧ |w.im| ≤ |z.im| := by
    intro w hw
    rw [segment_eq_image] at hw
    obtain ⟨θ, hθ, rfl⟩ := hw
    have hθ0 : (0 : ℝ) ≤ θ := hθ.1
    have hθ1 : θ ≤ 1 := hθ.2
    constructor
    · have hre : ((1 - θ) • (σ : ℂ) + θ • z).re = (1 - θ) * σ + θ * z.re := by
        simp [Complex.add_re]
      rw [hre, ← hσdef]
      ring
    · have him_eq : ((1 - θ) • (σ : ℂ) + θ • z).im = θ * z.im := by
        simp [Complex.add_im, Complex.ofReal_im]
      rw [him_eq, abs_mul, abs_of_nonneg hθ0]
      nlinarith [abs_nonneg z.im]
  -- `ζ` is differentiable at every point of the segment (they all avoid `1`).
  have hdiff : ∀ w ∈ segment ℝ (σ : ℂ) z, DifferentiableAt ℂ riemannZeta w := by
    intro w hw
    apply differentiableAt_riemannZeta
    intro hw1
    have hwre : w.re = σ := (hseg w hw).1
    rw [hw1] at hwre
    simp at hwre
    linarith
  -- The derivative is bounded by `1024` on the segment.
  have hbound : ∀ w ∈ segment ℝ (σ : ℂ) z, ‖deriv riemannZeta w‖ ≤ 1024 := by
    intro w hw
    obtain ⟨hwre, hwim⟩ := hseg w hw
    have h16 : |w.im| ≤ (1 / 16 : ℝ) := by linarith
    exact norm_deriv_zeta_le_band (by rw [hwre]; exact hσ1)
      (by rw [hwre]; exact hσ2) h16
  have hmvt := Convex.norm_image_sub_le_of_norm_deriv_le (f := riemannZeta)
    (s := segment ℝ (σ : ℂ) z) (x := (σ : ℂ)) (y := z) (C := 1024)
    hdiff hbound (convex_segment _ _) (left_mem_segment ℝ _ _) (right_mem_segment ℝ _ _)
  -- The distance from `σ` to `z` is `|Im z|`.
  have hdist : ‖z - (σ : ℂ)‖ = |z.im| := by
    have hz : z - (σ : ℂ) = (z.im : ℂ) * Complex.I := by
      apply Complex.ext
      · simp [Complex.mul_re, Complex.sub_re, hσdef]
      · simp [Complex.mul_im, Complex.sub_im, hσdef]
    rw [hz, norm_mul, Complex.norm_real, Complex.norm_I, mul_one, Real.norm_eq_abs]
  have hstep : ‖riemannZeta z - riemannZeta (σ : ℂ)‖ ≤ (1 / 2 : ℝ) := by
    have h := hmvt
    rw [hdist] at h
    nlinarith
  -- Reverse triangle inequality together with T581.
  have h581 : (1 : ℝ) ≤ ‖riemannZeta (σ : ℂ)‖ :=
    zeta_real_abs_ge_one (by linarith) hσ_lt_one
  have hrev : |‖riemannZeta (σ : ℂ)‖ - ‖riemannZeta z‖| ≤
      ‖riemannZeta (σ : ℂ) - riemannZeta z‖ := abs_norm_sub_norm_le _ _
  have hsym : ‖riemannZeta (σ : ℂ) - riemannZeta z‖ = ‖riemannZeta z - riemannZeta (σ : ℂ)‖ :=
    norm_sub_rev _ _
  have hnorm : (1 / 2 : ℝ) ≤ ‖riemannZeta z‖ := by
    rw [hsym] at hrev
    have h := abs_le.mp hrev
    linarith [h.2]
  intro hzero
  rw [hzero, norm_zero] at hnorm
  norm_num at hnorm

/-- **Zero-free punctured neighbourhood of the pole.**  Since `(z−1)ζ(z) → 1`,
`ζ` is eventually nonzero as `z → 1` away from `1`. -/
theorem eventually_zeta_ne_zero_near_one :
    ∀ᶠ z : ℂ in 𝓝[≠] (1 : ℂ), riemannZeta z ≠ 0 := by
  have h : Tendsto (fun z : ℂ => (z - 1) * riemannZeta z) (𝓝[≠] (1 : ℂ)) (𝓝 1) :=
    riemannZeta_residue_one
  filter_upwards [h.eventually_ne (by norm_num : (1 : ℂ) ≠ 0)] with z hz hz0
  exact hz (by simp [hz0])

/-- **`Fext` is eventually nonzero near `1`.**  Unlike `ζ`, the pole-corrected
product has `Fext 1 = 1`, so continuity gives a zero-free neighbourhood. -/
theorem eventually_Fext_ne_zero_near_one :
    ∀ᶠ z : ℂ in 𝓝 (1 : ℂ), AbsoluteHodgeExplicitFormula.Fext z ≠ 0 := by
  have hcont : ContinuousAt AbsoluteHodgeExplicitFormula.Fext (1 : ℂ) :=
    AbsoluteHodgeExplicitFormula.differentiable_Fext.continuous.continuousAt
  exact hcont.eventually_ne (by
    rw [AbsoluteHodgeExplicitFormula.Fext_one]
    norm_num)

/-- `Fext` inherits nonvanishing from `ζ` away from the two poles. -/
theorem Fext_ne_zero_of_zeta_ne_zero {z : ℂ} (h0 : z ≠ 0) (h1 : z ≠ 1)
    (hΓ : z.Gammaℝ ≠ 0) (hζ : riemannZeta z ≠ 0) :
    AbsoluteHodgeExplicitFormula.Fext z ≠ 0 := by
  have hZ : completedZeta z ≠ 0 := by
    unfold completedZeta
    exact mul_ne_zero (mul_ne_zero (Complex.exp_ne_zero _)
      (by simpa [Complex.Gammaℝ] using hΓ)) hζ
  rw [AbsoluteHodgeExplicitFormula.Fext_apply_ne h0 h1 hΓ]
  exact mul_ne_zero (mul_ne_zero h0 (sub_ne_zero.mpr h1)) hZ

/-- **Explicit `Fext` zero-free band.**  `Fext z ≠ 0` on
`1/4 ≤ Re z ≤ 7/8`, `|Im z| ≤ 1/2048`. -/
theorem Fext_ne_zero_band {z : ℂ} (h1 : (1 / 4 : ℝ) ≤ z.re)
    (h2 : z.re ≤ (7 / 8 : ℝ)) (him : |z.im| ≤ (1 / 2048 : ℝ)) :
    AbsoluteHodgeExplicitFormula.Fext z ≠ 0 := by
  have hre0 : 0 < z.re := by linarith
  have hz0 : z ≠ 0 := by
    intro h; rw [h] at hre0; norm_num at hre0
  have hz1 : z ≠ 1 := by
    intro h; rw [h] at h2; norm_num at h2
  have hΓ : z.Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hre0
  apply Fext_ne_zero_of_zeta_ne_zero hz0 hz1 hΓ
  rcases le_or_gt z.re (1 / 2) with hle | hgt
  · exact zeta_ne_zero_central_band_left h1 hle him
  rcases le_or_gt z.re (3 / 4) with hle2 | hgt2
  · exact zeta_ne_zero_central_band (by linarith) hle2 him
  · exact zeta_ne_zero_band_34_78 (by linarith) h2 him

/-- **Digamma bound on the tent line.**  For `y ≠ 0`,
`‖ψ(1 + i y/2) − log(1 + i y/2)‖ ≤ 19`, from the digamma-contour-shift estimate. -/
theorem digamma_one_add_half_bound {y : ℝ} (hy : y ≠ 0) :
    ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))
      - Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ ≤ 19 := by
  apply DigammaContourShift.digamma_sub_log_le
  · simp [Complex.add_re, Complex.mul_re]
    norm_num
  · simp [Complex.add_im, Complex.mul_im]
    exact hy

end FiniteWindowZeros
