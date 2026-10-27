/-
  DirichletMellinPrereq.lean — ambient estimates for the Mellin contour shift.

  The contour shift needs the twisted von Mangoldt series `Σ Λ(n)χ(n)n^{−s}` to converge
  uniformly on `Re s ≥ c > 1`.  The domination is pointwise:

    `‖Λ(n)χ(n)n^{−s}‖ ≤ Λ(n)·n^{−c}`   for `Re s ≥ c`, `n ≥ 1`,

  with the majorant `Σ Λ(n)n^{−c}` summable for `c > 1` (`LSeriesSummable_vonMangoldt`).  This
  file proves the pointwise domination.
-/
import DirichletPrimeTail
import DirichletCompletedLogDeriv
import DirichletCompletedSymmetry
import DirichletAnalytic
import DirichletArchimedean
import DirichletZeroCounting
import Mathlib.Analysis.Complex.HalfPlane
import Mathlib.NumberTheory.LSeries.Dirichlet
import Mathlib.Analysis.Normed.Group.FunctionSeries
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.Topology.Sets.Compacts
import Mathlib.Analysis.SpecialFunctions.Pow.Continuity
import Mathlib.Analysis.Complex.CauchyIntegral

open scoped BigOperators ArithmeticFunction.vonMangoldt Interval
open MeasureTheory DirichletCharacter

namespace RouteABC

noncomputable section

/-- **Pointwise domination of the twisted von Mangoldt series.**  For `Re s ≥ c` and `n ≥ 1`,
    `‖Λ(n)·χ(n)·n^{−s}‖ ≤ Λ(n)·n^{−c}`. -/
theorem norm_dirichletWeight_mul_cpow_le {N : ℕ} (χ : DirichletCharacter ℂ N) {c : ℝ} {s : ℂ}
    (hc : c ≤ s.re) (n : ℕ) :
    ‖dirichletWeight χ n * (n : ℂ) ^ (-s)‖ ≤ (Λ n) * (n : ℝ) ^ (-c) := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp [dirichletWeight]
  · have hnorm : ‖(n : ℂ) ^ (-s)‖ = (n : ℝ) ^ (-s.re) := by
      rw [Complex.norm_natCast_cpow_of_pos hn]; simp
    rw [norm_mul, hnorm]
    calc ‖dirichletWeight χ n‖ * (n : ℝ) ^ (-s.re)
        ≤ (Λ n) * (n : ℝ) ^ (-s.re) :=
          mul_le_mul_of_nonneg_right (norm_dirichletWeight_le χ n)
            (Real.rpow_nonneg (Nat.cast_nonneg n) _)
      _ ≤ (Λ n) * (n : ℝ) ^ (-c) :=
          mul_le_mul_of_nonneg_left
            (Real.rpow_le_rpow_of_exponent_le (by exact_mod_cast hn) (by linarith))
            ArithmeticFunction.vonMangoldt_nonneg

/-- The majorant `Σ Λ(n)·n^{−c}` is summable for `c > 1` (von Mangoldt L-series convergence). -/
theorem summable_vonMangoldt_rpow {c : ℝ} (hc : 1 < c) :
    Summable (fun n : ℕ => (Λ n) * (n : ℝ) ^ (-c)) := by
  have hc' : 1 < (c : ℂ).re := by simpa using hc
  have h := ArithmeticFunction.LSeriesSummable_vonMangoldt (s := (c : ℂ)) hc'
  rw [LSeriesSummable] at h
  have hnorm : Summable (fun n : ℕ => ‖(Λ n : ℂ) * (n : ℂ) ^ (-(c : ℂ))‖) := by
    refine h.norm.congr ?_
    intro n
    rw [LSeries.term_def]
    rcases eq_or_ne n 0 with rfl | hn
    · simp
    · rw [if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg]
  refine hnorm.congr ?_
  intro n
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp
  · simp only [norm_mul, Complex.norm_natCast_cpow_of_pos hn,
      Complex.norm_of_nonneg ArithmeticFunction.vonMangoldt_nonneg, Complex.neg_re,
      Complex.ofReal_re]

/-- The twisted von Mangoldt series `Σ Λ(n)χ(n)n^{−s}` is summable for `Re s ≥ c > 1`. -/
theorem summable_dirichletWeight_cpow {N : ℕ} (χ : DirichletCharacter ℂ N) {c : ℝ} (hc : 1 < c)
    {s : ℂ} (hs : c ≤ s.re) :
    Summable (fun n : ℕ => dirichletWeight χ n * (n : ℂ) ^ (-s)) :=
  (Summable.of_nonneg_of_le (fun n => norm_nonneg _)
    (fun n => norm_dirichletWeight_mul_cpow_le χ hs n) (summable_vonMangoldt_rpow hc)).of_norm

/-- **Uniform domination of the twisted von Mangoldt series.**  For `Re s ≥ c > 1`,
    `∑' n, ‖Λ(n)χ(n)n^{−s}‖ ≤ ∑' n, Λ(n)·n^{−c}`, a bound independent of `s`. -/
theorem tsum_norm_dirichletWeight_le {N : ℕ} (χ : DirichletCharacter ℂ N) {c : ℝ} (hc : 1 < c)
    {s : ℂ} (hs : c ≤ s.re) :
    ∑' n : ℕ, ‖dirichletWeight χ n * (n : ℂ) ^ (-s)‖
      ≤ ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) := by
  refine Real.tsum_le_of_sum_le (fun n => norm_nonneg _) (fun t => ?_)
  calc ∑ n ∈ t, ‖dirichletWeight χ n * (n : ℂ) ^ (-s)‖
      ≤ ∑ n ∈ t, (Λ n) * (n : ℝ) ^ (-c) :=
        Finset.sum_le_sum fun n _ => norm_dirichletWeight_mul_cpow_le χ hs n
    _ ≤ ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) :=
        (summable_vonMangoldt_rpow hc).sum_le_tsum t (fun n _ =>
          mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
            (Real.rpow_nonneg (Nat.cast_nonneg n) _))

/-- **Integrand domination on a vertical contour segment.**  For `F` bounded by `B` on
`Re s = c` and `Re s = c ≥ c > 1`, the termwise integrand of the Mellin contour shift is
dominated by `B·Λ(n)·n^{−c}`, a summable bound independent of `t`. -/
theorem norm_contour_integrand_le {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ} {c B t0 t1 : ℝ}
    (hB : 0 ≤ B) (hF : ∀ t ∈ Set.uIcc t0 t1, ‖F (c + t * Complex.I)‖ ≤ B) (n : ℕ)
    (t : ℝ) (ht : t ∈ Set.uIcc t0 t1) :
    ‖F (c + t * Complex.I) * dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))‖
      ≤ B * ((Λ n) * (n : ℝ) ^ (-c)) := by
  rw [mul_assoc, norm_mul]
  refine mul_le_mul (hF t ht) (norm_dirichletWeight_mul_cpow_le χ ?_ n) (norm_nonneg _) hB
  simp

/-- Global form of the contour integrand domination (no interval membership needed). -/
theorem norm_contour_integrand_le_global {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    {c B : ℝ} (hB : 0 ≤ B) (hF : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B) (n : ℕ) (t : ℝ) :
    ‖F (c + t * Complex.I) * dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))‖
      ≤ B * ((Λ n) * (n : ℝ) ^ (-c)) :=
  norm_contour_integrand_le (t0 := t) (t1 := t) χ hB (fun s _ => hF s) n t (by simp [Set.uIcc])

/-- **Termwise integration (measure form).**  For a finite measure `μ` on `ℝ` and `F` continuous
and bounded by `B` on the line `Re s = c > 1`,

    `∑' n, ∫ t, F(c+it)·Λ(n)χ(n)n^{−(c+it)} ∂μ
        = ∫ t, F(c+it) · (∑' n, Λ(n)χ(n)n^{−(c+it)}) ∂μ`. -/
theorem contour_termwise_integral_measure {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    (hF : Continuous F) {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B)
    (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B) (μ : MeasureTheory.Measure ℝ)
    [MeasureTheory.IsFiniteMeasure μ] :
    ∑' n : ℕ, (∫ t, F (c + t * Complex.I) * dirichletWeight χ n
        * (n : ℂ) ^ (-(c + t * Complex.I)) ∂μ)
      = ∫ t, F (c + t * Complex.I)
          * (∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))) ∂μ := by
  set f : ℕ → ℝ → ℂ := fun n t => F (c + t * Complex.I) * dirichletWeight χ n
      * (n : ℂ) ^ (-(c + t * Complex.I)) with hf_def
  have hcont : ∀ n : ℕ, Continuous (f n) := by
    intro n
    rcases eq_or_ne n 0 with rfl | hn
    · have hz : dirichletWeight χ 0 = 0 := by
        rw [dirichletWeight_def]; simp [ArithmeticFunction.vonMangoldt_apply]
      simp only [hf_def, hz, mul_zero, zero_mul]
      fun_prop
    · haveI : NeZero ((n : ℂ)) := ⟨by exact_mod_cast hn⟩
      refine ((hF.comp (by fun_prop)).mul continuous_const).mul ?_
      exact (continuous_const_cpow (n : ℂ)).comp (by fun_prop)
  have hint : ∀ n : ℕ, Integrable (f n) μ := fun n =>
    Integrable.of_bound (hcont n).aestronglyMeasurable _ (Filter.Eventually.of_forall fun t =>
      norm_contour_integrand_le_global χ hB hFb n t)
  have hsum : Summable fun n : ℕ => ∫ t, ‖f n t‖ ∂μ := by
    refine ((summable_vonMangoldt_rpow hc).mul_left B).mul_right (μ.real Set.univ) |>.of_nonneg_of_le
      (fun n => integral_nonneg fun t => norm_nonneg _) (fun n => ?_)
    calc ∫ t, ‖f n t‖ ∂μ ≤ ∫ t, B * ((Λ n) * (n : ℝ) ^ (-c)) ∂μ :=
          integral_mono_ae (hint n).norm
            (integrable_const (B * ((Λ n) * (n : ℝ) ^ (-c))))
            (Filter.Eventually.of_forall fun t => norm_contour_integrand_le_global χ hB hFb n t)
      _ = B * ((Λ n) * (n : ℝ) ^ (-c)) * μ.real Set.univ := by
          rw [integral_const, smul_eq_mul]; ring
  have hcongr : (∫ t, F (c + t * Complex.I)
        * (∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))) ∂μ)
      = ∫ t, ∑' n : ℕ, (F (c + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(c + t * Complex.I))) ∂μ := by
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    dsimp only
    rw [show F (c + t * Complex.I)
          * (∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I)))
        = ∑' n : ℕ, F (c + t * Complex.I)
            * (dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))) from tsum_mul_left.symm]
    exact tsum_congr fun n => by ring
  rw [hcongr]
  exact integral_tsum_of_summable_integral_norm hint hsum

/-- **Termwise integration (interval form).**  The measure-form result applied to
`μ = volume.restrict (Ioc a b)`. -/
theorem contour_termwise_integral {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    (hF : Continuous F) {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B)
    (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B) {a b : ℝ} (hab : a ≤ b) :
    ∑' n : ℕ, (∫ t in a..b, F (c + t * Complex.I) * dirichletWeight χ n
        * (n : ℂ) ^ (-(c + t * Complex.I)))
      = ∫ t in a..b, F (c + t * Complex.I)
          * (∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-(c + t * Complex.I))) := by
  have h := contour_termwise_integral_measure χ hF hc hB hFb (volume.restrict (Set.Ioc a b))
  simpa only [intervalIntegral.integral_of_le hab] using h

/-- `LSeries` of the twisted von Mangoldt weight as an explicit `tsum`. -/
theorem LSeries_dirichletWeight_eq_tsum {N : ℕ} (χ : DirichletCharacter ℂ N) (s : ℂ) :
    LSeries (fun n => dirichletWeight χ n) s
      = ∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-s) := by
  rw [LSeries]
  refine tsum_congr fun n => ?_
  rw [LSeries.term_def]
  rcases eq_or_ne n 0 with rfl | hn
  · simp
  · rw [if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg]

/-- **The analytic half of the contour move.**  On the line `Re s = c > 1` the weighted integral of
`Λ_χ'/Λ_χ` splits into the archimedean term and the (termwise-integrated) prime series:

    `∫_{a}^{b} F(c+it)·Λ_χ'/Λ_χ dt
        = ∫ F·(½log N − ½log π + ½ψ((c+it)/2)) dt
          − ∑' n, ∫_{a}^{b} F(c+it)·Λ(n)χ(n)n^{−(c+it)} dt`.

The two `IntervalIntegrable` hypotheses are the standard integrability inputs (cf.
`rectBoundary_F_logDeriv_eq`). -/
theorem contour_cLine_eq_arch_sub_prime {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ} (hF : Continuous F) {c B : ℝ} (hc : 1 < c)
    (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B) {t0 t1 : ℝ} (ht : t0 ≤ t1)
    (hint_arch : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1)
    (hint_L : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1) :
    (∫ t in t0..t1, F (c + t * Complex.I) * logDeriv (dirichletCompleted χ) (c + t * Complex.I))
      + ∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(c + t * Complex.I))
      = ∫ t in t0..t1, F (c + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2)) := by
  have hpt : ∀ t : ℝ, logDeriv (dirichletCompleted χ) (c + t * Complex.I)
      = ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
          + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))
        - LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I) := fun t =>
    logDeriv_dirichletCompleted_eq_even χ hχ hE (by
      have hre : (c + t * Complex.I).re = c := by simp
      rw [hre]; exact hc)
  have hsplit : (∫ t in t0..t1, F (c + t * Complex.I)
        * logDeriv (dirichletCompleted χ) (c + t * Complex.I))
      = (∫ t in t0..t1, F (c + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2)))
        - (∫ t in t0..t1, F (c + t * Complex.I)
            * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) := by
    rw [← intervalIntegral.integral_sub hint_arch hint_L]
    refine intervalIntegral.integral_congr fun t _ => ?_
    rw [hpt t]; ring
  have hterm : (∫ t in t0..t1, F (c + t * Complex.I)
        * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I))
      = ∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(c + t * Complex.I)) := by
    simp only [LSeries_dirichletWeight_eq_tsum]
    exact (contour_termwise_integral χ hF hc hB hFb ht).symm
  rw [hsplit, hterm]
  ring

/-- **Transport of a vertical line across a rectangle (Cauchy–Goursat).**  If `g` is continuous on
`[1,c]×[t₀,t₁]` and complex-differentiable in its interior, the boundary integral of the rectangle
vanishes:

    `∫_{1}^{c} g(x+it₀) dx − ∫_{1}^{c} g(x+it₁) dx
        + i·∫_{t₀}^{t₁} g(c+iy) dy − i·∫_{t₀}^{t₁} g(1+iy) dy = 0`.

Rearranged, this transports the vertical line `Re s = 1` to `Re s = c`. -/
theorem verticalLine_transport {g : ℂ → ℂ} {c t0 t1 : ℝ} (h1c : 1 ≤ c)
    (hcont : ContinuousOn g ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ g x) :
    (∫ x in 1..c, g (x + t0 * Complex.I)) - (∫ x in 1..c, g (x + t1 * Complex.I))
      + Complex.I * (∫ y in t0..t1, g (c + y * Complex.I))
      - Complex.I * (∫ y in t0..t1, g (1 + y * Complex.I)) = 0 := by
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiable_on_off_countable g
    (1 + (t0 : ℂ) * Complex.I) (c + (t1 : ℂ) * Complex.I) ∅ Set.countable_empty
    (by simpa using hcont) (by simpa [min_eq_left h1c, max_eq_right h1c] using hdiff)
  simpa only [smul_eq_mul, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.one_re,
    Complex.one_im, Complex.ofReal_one, mul_zero, mul_one, zero_mul, add_zero, zero_add,
    sub_zero] using h

/-- **Transport of the `rightPath` to the line `Re s = c`.**  For `g` meromorphic-free on
`[1,c]×[t₀,t₁]` (continuous there, differentiable inside),

    `rightPath g t₀ t₁ = ∫_{1/2}^{c} g(x+it₀) dx − ∫_{1/2}^{c} g(x+it₁) dx
                          + i·∫_{t₀}^{t₁} g(c+iy) dy`.

This moves the vertical edge of `rightPath` from `Re s = 1` out to `Re s = c > 1`, where the
Dirichlet series converges — the geometric content of the Mellin contour shift. -/
theorem rightPath_transport {g : ℂ → ℂ} {c t0 t1 : ℝ} (h1c : 1 ≤ c)
    (hcont : ContinuousOn g ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ g x)
    (hint0 : IntervalIntegrable (fun x : ℝ => g (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => g (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c) :
    Rh45RouteBAnalytic.rightPath g t0 t1
      = (∫ x in (1 / 2 : ℝ)..c, g (x + t0 * Complex.I))
        - (∫ x in (1 / 2 : ℝ)..c, g (x + t1 * Complex.I))
        + Complex.I * (∫ y in t0..t1, g (c + y * Complex.I)) := by
  have htr := verticalLine_transport (g := g) h1c hcont hdiff
  have hI : Complex.I * (∫ y in t0..t1, g (1 + y * Complex.I))
      = (∫ x in 1..c, g (x + t0 * Complex.I)) - (∫ x in 1..c, g (x + t1 * Complex.I))
        + Complex.I * (∫ y in t0..t1, g (c + y * Complex.I)) :=
    (sub_eq_zero.mp htr).symm
  have hlow : (1 / 2 : ℝ) ≤ 1 := by norm_num
  have hsub0 : Set.uIcc (1 / 2 : ℝ) 1 ⊆ Set.uIcc (1 / 2 : ℝ) c := by
    rw [Set.uIcc_of_le hlow, Set.uIcc_of_le (le_trans hlow h1c)]
    exact Set.Icc_subset_Icc le_rfl h1c
  have hsub1 : Set.uIcc (1 : ℝ) c ⊆ Set.uIcc (1 / 2 : ℝ) c := by
    rw [Set.uIcc_of_le h1c, Set.uIcc_of_le (le_trans hlow h1c)]
    exact Set.Icc_subset_Icc hlow le_rfl
  have hadj0 := intervalIntegral.integral_add_adjacent_intervals
    (hint0.mono_set hsub0) (hint0.mono_set hsub1)
  have hadj1 := intervalIntegral.integral_add_adjacent_intervals
    (hint1.mono_set hsub0) (hint1.mono_set hsub1)
  rw [Rh45RouteBAnalytic.rightPath, hI]
  rw [← hadj0, ← hadj1]
  ring

/-- **The assembled Dirichlet `L` explicit formula** (horizontal-edge form).  Combining the zero
side (`dirichletCompleted_zeroSum`), the contour shift (§§56–57) and the archimedean − prime
evaluation on `Re s = c` (§55):

    `π·Re(∑_{z∈Z} m z·F z)
        = Re(∫ arch) − Re(∑' n, ∫ F·Λ(n)χ(n)n^{−(c+it)})
          + Im(∫_{1/2}^{c} g(x+it₀) − ∫_{1/2}^{c} g(x+it₁))`,

with `g = F·Λ_χ'/Λ_χ`.  The right-hand side is exactly `archimedean − prime` up to the horizontal
edge terms, which the reflection `F(1−conj s) = conj(F s)` cancels. -/
theorem dirichlet_explicit_formula_assembled {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) (hχ1 : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ}
    (hF : Continuous F) (hF_refl : ∀ s, F (1 - starRingEnd ℂ s) = starRingEnd ℂ (F s))
    {c B : ℝ} (hc : 1 < c) (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B)
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hAn : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ (dirichletCompleted χ) s)
    (hF_an : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume 0 1)
    (hcont : ContinuousOn (fun s => F s * logDeriv (dirichletCompleted χ) s)
      ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ (fun s => F s * logDeriv (dirichletCompleted χ) s) x)
    (hint0 : IntervalIntegrable (fun x : ℝ => F (x + t0 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => F (x + t1 * Complex.I)
      * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint_arch : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1)
    (hint_L : IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1) :
    Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re
      = (∫ t in t0..t1, F (c + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))).re
        - (∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
            * (n : ℂ) ^ (-(c + t * Complex.I))).re
        + ((∫ x in (1 / 2 : ℝ)..c, F (x + t0 * Complex.I)
              * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
            - (∫ x in (1 / 2 : ℝ)..c, F (x + t1 * Complex.I)
              * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))).im := by
  have hz := dirichletCompleted_zeroSum χ hχ hχinv hsign hreal F hF_refl t0 t1 Z m ht hAn hF_an
    hZ hm hno hint₀ hint₁
  have htr := rightPath_transport (g := fun s => F s * logDeriv (dirichletCompleted χ) s)
    (le_of_lt hc) hcont hdiff hint0 hint1
  rw [htr] at hz
  have hCc : (∫ t in t0..t1, F (c + t * Complex.I)
        * logDeriv (dirichletCompleted χ) (c + t * Complex.I))
      = (∫ t in t0..t1, F (c + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2)))
        - ∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
            * (n : ℂ) ^ (-(c + t * Complex.I)) :=
    eq_sub_iff_add_eq.mpr (contour_cLine_eq_arch_sub_prime χ hχ1 hE hF hc hB hFb (le_of_lt ht)
      hint_arch hint_L)
  simp only [hCc] at hz
  have him : ((∫ x in (1 / 2 : ℝ)..c, F (x + t0 * Complex.I)
        * logDeriv (dirichletCompleted χ) (x + t0 * Complex.I))
      - (∫ x in (1 / 2 : ℝ)..c, F (x + t1 * Complex.I)
        * logDeriv (dirichletCompleted χ) (x + t1 * Complex.I))).im
      + ((∫ t in t0..t1, F (c + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2)))
        - ∑' n : ℕ, ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ n
            * (n : ℂ) ^ (-(c + t * Complex.I))).re
      = Real.pi * (∑ z ∈ Z, (m z : ℂ) * F z).re := by
    simpa only [Complex.add_im, Complex.sub_im, Complex.mul_im, Complex.I_re, Complex.I_im,
      zero_mul, one_mul, add_zero, sub_zero, mul_one, zero_add, Complex.ofReal_re,
      Complex.ofReal_im] using hz
  rw [Complex.sub_re] at him
  linarith [him]

/-- Domination of the integrand on a **horizontal** segment `Re ∈ [c₀,c]` (all `≤ c₀`-th powers). -/
theorem norm_horizontal_integrand_le {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    {c0 c B t : ℝ} (hc0c : c0 ≤ c) (hB : 0 ≤ B)
    (hFb : ∀ x ∈ Set.uIcc c0 c, ‖F (x + t * Complex.I)‖ ≤ B) (n : ℕ) (x : ℝ)
    (hx : x ∈ Set.uIcc c0 c) :
    ‖F (x + t * Complex.I) * dirichletWeight χ n * (n : ℂ) ^ (-(x + t * Complex.I))‖
      ≤ B * ((Λ n) * (n : ℝ) ^ (-c0)) := by
  have hx' : c0 ≤ x := by rw [Set.uIcc_of_le hc0c] at hx; exact hx.1
  rw [mul_assoc, norm_mul]
  refine mul_le_mul (hFb x hx) (norm_dirichletWeight_mul_cpow_le χ ?_ n) (norm_nonneg _) hB
  simpa using hx'

/-- **Termwise integration with domination.**  For a finite measure `μ` and a family `G i` with
summable majorant `u`, the integral of the series is the series of the integrals. -/
theorem termwise_integral_of_dominated {ι : Type*} [Countable ι] (μ : MeasureTheory.Measure ℝ)
    [MeasureTheory.IsFiniteMeasure μ] (G : ι → ℝ → ℂ) (u : ι → ℝ)
    (hmeas : ∀ i, AEStronglyMeasurable (G i) μ)
    (hbound : ∀ i, ∀ᵐ x ∂μ, ‖G i x‖ ≤ u i) (hu : Summable u) :
    ∑' i, (∫ x, G i x ∂μ) = ∫ x, (∑' i, G i x) ∂μ := by
  have hint : ∀ i, Integrable (G i) μ := fun i => Integrable.of_bound (hmeas i) (u i) (hbound i)
  have hsum : Summable fun i => ∫ x, ‖G i x‖ ∂μ := by
    refine (hu.mul_right (μ.real Set.univ)).of_nonneg_of_le
      (fun i => integral_nonneg fun x => norm_nonneg _) (fun i => ?_)
    calc ∫ x, ‖G i x‖ ∂μ ≤ ∫ x, u i ∂μ :=
          integral_mono_ae (hint i).norm (integrable_const (u i)) (hbound i)
      _ = u i * μ.real Set.univ := by rw [integral_const, smul_eq_mul, mul_comm]
  exact integral_tsum_of_summable_integral_norm hint hsum

/-- **Termwise integration on a horizontal segment** `Re ∈ [c₀,c]` with `1 < c₀ ≤ c`. -/
theorem hLine_termwise_integral {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    (hF : Continuous F) {c0 c B : ℝ} (hc0 : 1 < c0) (hc0c : c0 ≤ c) (hB : 0 ≤ B)
    (hFb : ∀ t : ℝ, ∀ x ∈ Set.uIcc c0 c, ‖F (x + t * Complex.I)‖ ≤ B) (t : ℝ) :
    ∑' n : ℕ, (∫ x in c0..c, F (x + t * Complex.I) * dirichletWeight χ n
        * (n : ℂ) ^ (-(x + t * Complex.I)))
      = ∫ x in c0..c, F (x + t * Complex.I)
          * (∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-(x + t * Complex.I))) := by
  have hgen := termwise_integral_of_dominated (volume.restrict (Set.Ioc c0 c))
    (fun n x => F (x + t * Complex.I) * dirichletWeight χ n * (n : ℂ) ^ (-(x + t * Complex.I)))
    (fun n => B * ((Λ n) * (n : ℝ) ^ (-c0)))
    (fun n => by
      rcases eq_or_ne n 0 with rfl | hn
      · have hz : dirichletWeight χ 0 = 0 := by
          rw [dirichletWeight_def]; simp [ArithmeticFunction.vonMangoldt_apply]
        simp only [hz, mul_zero, zero_mul]
        fun_prop
      · haveI : NeZero ((n : ℂ)) := ⟨by exact_mod_cast hn⟩
        refine Continuous.aestronglyMeasurable ?_
        refine ((hF.comp (by fun_prop)).mul continuous_const).mul ?_
        exact (continuous_const_cpow (n : ℂ)).comp (by fun_prop))
    (fun n => by
      filter_upwards [MeasureTheory.self_mem_ae_restrict measurableSet_Ioc] with x hx
      exact norm_horizontal_integrand_le χ hc0c hB (fun y hy => hFb t y hy) n x
        (by rw [Set.uIcc_of_le hc0c]; exact ⟨le_of_lt hx.1, hx.2⟩))
    ((summable_vonMangoldt_rpow hc0).mul_left B)
  simp only [intervalIntegral.integral_of_le hc0c]
  refine hgen.trans ?_
  refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
  dsimp only
  rw [← tsum_mul_left]
  exact tsum_congr fun n => by ring

/-- **Horizontal archimedean − prime evaluation.**  On a horizontal segment `Re ∈ [c₀,c]` with
`1 < c₀ ≤ c`,

    `∫_{c₀}^{c} F(x+it)·Λ_χ'/Λ_χ dx + ∑' n, ∫_{c₀}^{c} F(x+it)·Λ(n)χ(n)n^{−(x+it)} dx
        = ∫_{c₀}^{c} F(x+it)·(½log N − ½log π + ½ψ((x+it)/2)) dx`.

Note `c₀ > 1` is essential: at `Re = 1` the series `Σ Λ(n)/n` diverges. -/
theorem contour_hLine_eq_arch_sub_prime {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hE : χ.Even) {F : ℂ → ℂ} (hF : Continuous F) {c0 c B : ℝ} (hc0 : 1 < c0)
    (hc0c : c0 ≤ c) (hB : 0 ≤ B)
    (hFb : ∀ t : ℝ, ∀ x ∈ Set.uIcc c0 c, ‖F (x + t * Complex.I)‖ ≤ B) (t : ℝ)
    (hint_arch : IntervalIntegrable (fun x : ℝ => F (x + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((x + t * Complex.I) / 2))) volume c0 c)
    (hint_L : IntervalIntegrable (fun x : ℝ => F (x + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (x + t * Complex.I)) volume c0 c) :
    (∫ x in c0..c, F (x + t * Complex.I) * logDeriv (dirichletCompleted χ) (x + t * Complex.I))
      + ∑' n : ℕ, ∫ x in c0..c, F (x + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(x + t * Complex.I))
      = ∫ x in c0..c, F (x + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((x + t * Complex.I) / 2)) := by
  have hsplit : (∫ x in c0..c, F (x + t * Complex.I)
        * logDeriv (dirichletCompleted χ) (x + t * Complex.I))
      = (∫ x in c0..c, F (x + t * Complex.I)
          * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * Complex.digamma ((x + t * Complex.I) / 2)))
        - (∫ x in c0..c, F (x + t * Complex.I)
            * LSeries (fun n => dirichletWeight χ n) (x + t * Complex.I)) := by
    rw [← intervalIntegral.integral_sub hint_arch hint_L]
    refine intervalIntegral.integral_congr fun x hx => ?_
    have hx' : c0 ≤ x := by rw [Set.uIcc_of_le hc0c] at hx; exact hx.1
    rw [show logDeriv (dirichletCompleted χ) (x + t * Complex.I)
          = ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
              + (1 / 2) * Complex.digamma ((x + t * Complex.I) / 2))
            - LSeries (fun n => dirichletWeight χ n) (x + t * Complex.I) from
        logDeriv_dirichletCompleted_eq_even χ hχ hE (by
          have hre : (x + t * Complex.I).re = x := by simp
          rw [hre]; linarith)]
    ring
  have hterm : (∫ x in c0..c, F (x + t * Complex.I)
        * LSeries (fun n => dirichletWeight χ n) (x + t * Complex.I))
      = ∑' n : ℕ, ∫ x in c0..c, F (x + t * Complex.I) * dirichletWeight χ n
          * (n : ℂ) ^ (-(x + t * Complex.I)) := by
    simp only [LSeries_dirichletWeight_eq_tsum]
    exact (hLine_termwise_integral χ hF hc0 hc0c hB hFb t).symm
  rw [hsplit, hterm]
  ring

/-- `dirichletCompleted χ` is nonzero on `Re s > 1` (the Euler-product region). -/
theorem dirichletCompleted_ne_zero_of_one_lt_re {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    {s : ℂ} (hs : 1 < s.re) : dirichletCompleted χ s ≠ 0 := by
  rw [show dirichletCompleted χ s = (N : ℂ) ^ (s / 2) * completedLFunction χ s from rfl]
  exact mul_ne_zero (Complex.cpow_ne_zero_iff.mpr (Or.inl (by exact_mod_cast NeZero.ne N)))
    (completedLFunction_ne_zero_of_one_lt_re χ hs)

/-- **Analyticity side-condition.**  `F·Λ_χ'/Λ_χ` is continuous on any `S ⊆ {Re > 1}` where `F` is
continuous.  (Discharges `hcont` of the assembled formula when `F` is continuous and
`S ⊆ {Re > 1}`.) -/
theorem continuousOn_mul_logDeriv_dirichletCompleted {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {F : ℂ → ℂ} {S : Set ℂ}
    (hS : ∀ s ∈ S, 1 < s.re) (hF : ContinuousOn F S) :
    ContinuousOn (fun s => F s * logDeriv (dirichletCompleted χ) s) S := by
  have hne : ∀ s ∈ S, dirichletCompleted χ s ≠ 0 :=
    fun s hs => dirichletCompleted_ne_zero_of_one_lt_re χ (hS s hs)
  have hf : ContinuousOn (dirichletCompleted χ) S :=
    fun s hs => (analyticAt_dirichletCompleted χ hχ s).continuousAt.continuousWithinAt
  have hd : ContinuousOn (deriv (dirichletCompleted χ)) S :=
    fun s hs => (analyticAt_dirichletCompleted χ hχ s).deriv.continuousAt.continuousWithinAt
  have hlog : (fun s => F s * logDeriv (dirichletCompleted χ) s)
      = fun s => F s * (deriv (dirichletCompleted χ) s / dirichletCompleted χ s) := by
    funext s; rw [logDeriv_apply]
  rw [hlog]
  exact hF.mul (hd.div hf hne)

/-- **Differentiability side-condition.**  (Discharges `hdiff` of the assembled formula.) -/
theorem differentiableAt_mul_logDeriv_dirichletCompleted {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {F : ℂ → ℂ} {s : ℂ} (hs : 1 < s.re)
    (hF : DifferentiableAt ℂ F s) :
    DifferentiableAt ℂ (fun s => F s * logDeriv (dirichletCompleted χ) s) s := by
  have hne : dirichletCompleted χ s ≠ 0 := dirichletCompleted_ne_zero_of_one_lt_re χ hs
  have hf : DifferentiableAt ℂ (dirichletCompleted χ) s :=
    (analyticAt_dirichletCompleted χ hχ s).differentiableAt
  have hd : DifferentiableAt ℂ (deriv (dirichletCompleted χ)) s :=
    (analyticAt_dirichletCompleted χ hχ s).deriv.differentiableAt
  have hlog : (fun s => F s * logDeriv (dirichletCompleted χ) s)
      = fun s => F s * (deriv (dirichletCompleted χ) s / dirichletCompleted χ s) := by
    funext s; rw [logDeriv_apply]
  rw [hlog]
  exact hF.mul (hd.div hf hne)

/-- `ψ((c+it)/2)` is continuous for `c ≥ 1` (no poles: real part `≥ 1/2 > 0`). -/
theorem continuous_digamma_halfLine {c : ℝ} (hc : 1 ≤ c) :
    Continuous (fun t : ℝ => Complex.digamma ((c + t * Complex.I) / 2)) := by
  have ha : 0 ≤ c - 1 / 2 := by linarith
  have hfun : (fun t : ℝ => Complex.digamma ((c + t * Complex.I) / 2))
      = fun t : ℝ => Complex.digamma (dirichletDigammaLine (c - 1 / 2) t) := by
    funext t; congr 1; rw [dirichletDigammaLine]; push_cast; ring
  rw [hfun]
  exact continuous_iff_continuousAt.mpr fun t =>
    ((analyticAt_digamma_dirichletLine (c - 1 / 2) t ha).continuousAt).comp
      (by unfold dirichletDigammaLine; fun_prop)

/-- **`hint_arch` discharged.**  The archimedean integrand is interval-integrable for `c ≥ 1`. -/
theorem intervalIntegrable_arch {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    (hF : Continuous F) {c : ℝ} (hc : 1 ≤ c) (t0 t1 : ℝ) :
    IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
         + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))) volume t0 t1 := by
  apply Continuous.intervalIntegrable
  refine Continuous.mul (hF.comp (by fun_prop)) ?_
  refine Continuous.add (Continuous.sub continuous_const continuous_const) ?_
  exact continuous_const.mul (continuous_digamma_halfLine hc)

/-- `LSeries (dirichletWeight χ)` is summable for `Re s > 1`. -/
theorem LSeriesSummable_dirichletWeight {N : ℕ} (χ : DirichletCharacter ℂ N) {s : ℂ}
    (hs : 1 < s.re) : LSeriesSummable (fun n => dirichletWeight χ n) s := by
  rw [LSeriesSummable]
  refine Summable.congr (summable_dirichletWeight_cpow (c := s.re) χ hs le_rfl) fun n => ?_
  rw [LSeries.term_def]
  rcases eq_or_ne n 0 with rfl | hn
  · simp
  · rw [if_neg hn, div_eq_mul_inv, ← Complex.cpow_neg]

/-- The abscissa of absolute convergence of `Λ(n)χ(n)` is at most `1`. -/
theorem abscissaOfAbsConv_dirichletWeight_le_one {N : ℕ} (χ : DirichletCharacter ℂ N) :
    LSeries.abscissaOfAbsConv (fun n => dirichletWeight χ n) ≤ 1 := by
  exact LSeries.abscissaOfAbsConv_le_of_forall_lt_LSeriesSummable fun y hy =>
    LSeriesSummable_dirichletWeight χ (by simpa using hy)

/-- `LSeries (dirichletWeight χ)` is continuous on `Re s > 1`. -/
theorem continuous_LSeries_dirichletWeight {N : ℕ} (χ : DirichletCharacter ℂ N) {c : ℝ}
    (hc : 1 < c) :
    Continuous (fun t : ℝ => LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) :=
  (LSeries_differentiableOn (fun n => dirichletWeight χ n)).continuousOn.comp_continuous
    (by fun_prop) fun t => by
      simp only [Set.mem_setOf_eq, Complex.add_re, Complex.ofReal_re, Complex.ofReal_im,
        Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im, mul_zero, mul_one, sub_zero,
        add_zero, zero_add]
      exact lt_of_le_of_lt (abscissaOfAbsConv_dirichletWeight_le_one χ) (by exact_mod_cast hc : (1 : EReal) < ↑c)

/-- **`hint_L` discharged.**  The Dirichlet-series integrand on `Re s = c > 1` is
interval-integrable. -/
theorem intervalIntegrable_LSeries {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ}
    (hF : Continuous F) {c : ℝ} (hc : 1 < c) (t0 t1 : ℝ) :
    IntervalIntegrable (fun t : ℝ => F (c + t * Complex.I)
      * LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)) volume t0 t1 := by
  apply Continuous.intervalIntegrable
  exact (hF.comp (by fun_prop)).mul (continuous_LSeries_dirichletWeight χ hc)

/-- **Real-part bound for a summable complex series.** -/
theorem abs_re_tsum_le {ι : Type*} [Countable ι] {z : ι → ℂ} (hz : Summable z) :
    |(∑' i, z i).re| ≤ ∑' i, ‖z i‖ :=
  (Complex.abs_re_le_norm _).trans (norm_tsum_le_tsum_norm hz.norm)

/-- **Bound on the truncated prime tail.**  The tail of the Dirichlet series beyond `K` is bounded
by the sum of the term norms. -/
theorem abs_primeTail_le {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ} (c : ℝ) (t0 t1 : ℝ)
    (K : ℕ)
    (hz : Summable fun n : ℕ => ∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ (n + K)
      * ((n + K : ℕ) : ℂ) ^ (-(c + t * Complex.I))) :
    |-(∑' n : ℕ, (∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ (n + K)
        * ((n + K : ℕ) : ℂ) ^ (-(c + t * Complex.I))).re)|
      ≤ ∑' n : ℕ, ‖∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ (n + K)
          * ((n + K : ℕ) : ℂ) ^ (-(c + t * Complex.I))‖ := by
  rw [abs_neg, ← Complex.re_tsum hz]
  exact abs_re_tsum_le hz

/-- **Termwise integral bound for the prime tail.**  Each term of the truncated Dirichlet series is
bounded by `(t₁−t₀)·B·Λ(m)·m^{−c}` with `m = n+K`. -/
theorem norm_integral_primeTerm_le {N : ℕ} (χ : DirichletCharacter ℂ N) {F : ℂ → ℂ} {c B : ℝ}
    (hB : 0 ≤ B) (hFb : ∀ t : ℝ, ‖F (c + t * Complex.I)‖ ≤ B) {t0 t1 : ℝ} (ht : t0 ≤ t1)
    (K n : ℕ) :
    ‖∫ t in t0..t1, F (c + t * Complex.I) * dirichletWeight χ (n + K)
        * ((n + K : ℕ) : ℂ) ^ (-(c + t * Complex.I))‖
      ≤ (t1 - t0) * (B * ((Λ (n + K)) * (((n + K : ℕ) : ℝ)) ^ (-c))) := by
  refine (intervalIntegral.norm_integral_le_of_norm_le_const fun t _ =>
    norm_contour_integrand_le_global χ hB hFb (n + K) t).trans_eq ?_
  rw [abs_of_nonneg (by linarith : (0 : ℝ) ≤ t1 - t0)]
  ring

/-- A shifted tail of a nonnegative summable real series is at most the whole sum. -/
theorem tsum_shift_le {f : ℕ → ℝ} (hf : Summable f) (hnn : ∀ n, 0 ≤ f n) (K : ℕ) :
    ∑' n, f (n + K) ≤ ∑' n, f n := by
  refine Real.tsum_le_of_sum_le (fun n => hnn _) fun s => ?_
  calc ∑ n ∈ s, f (n + K) = ∑ m ∈ s.image (fun n => n + K), f m := by
        rw [Finset.sum_image]; intro a _ b _ hab; exact Nat.add_right_cancel hab
    _ ≤ ∑' m, f m := hf.sum_le_tsum _ fun m _ => hnn m

/-- **Explicit prime-tail constant.**  The shifted von-Mangoldt series is bounded by the whole
series `∑ Λ(n)n^{−c}`, so the truncated prime tail of §§67–68 is bounded by the explicit constant
`(t₁−t₀)·B·∑' n, Λ(n)n^{−c}`. -/
theorem shifted_vonMangoldt_tail_le {c : ℝ} (hc : 1 < c) (K : ℕ) :
    ∑' n : ℕ, (Λ (n + K)) * (((n + K : ℕ) : ℝ)) ^ (-c)
      ≤ ∑' n : ℕ, (Λ n) * ((n : ℝ)) ^ (-c) :=
  tsum_shift_le (summable_vonMangoldt_rpow hc)
    (fun n => mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _)) K

/-- **Uniform bound on the Dirichlet-series part of `Λ_χ'/Λ_χ`.**  For `Re s ≥ c > 1`,

    `‖LSeries (Λ·χ) s‖ ≤ ∑' n, Λ(n)·n^{−c}`,

a bound *independent of `s`* — the `O(1)` half of the Riemann–von Mangoldt strip estimate
(the other half, `‖½ψ(s/2)‖ ≲ log|Im s|`, is the archimedean growth term). -/
theorem norm_LSeries_dirichletWeight_le {N : ℕ} (χ : DirichletCharacter ℂ N) {c : ℝ} (hc : 1 < c)
    {s : ℂ} (hs : c ≤ s.re) :
    ‖LSeries (fun n => dirichletWeight χ n) s‖ ≤ ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) := by
  rw [LSeries_dirichletWeight_eq_tsum]
  calc ‖∑' n : ℕ, dirichletWeight χ n * (n : ℂ) ^ (-s)‖
      ≤ ∑' n : ℕ, ‖dirichletWeight χ n * (n : ℂ) ^ (-s)‖ :=
        norm_tsum_le_tsum_norm (summable_dirichletWeight_cpow χ hc hs).norm
    _ ≤ ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) := tsum_norm_dirichletWeight_le χ hc hs

/-- **Compact-set bound on `Λ_χ'/Λ_χ`.**  On any rectangle `[c,d]×[−R,R]` with `c > 1`, the
logarithmic derivative of `dirichletCompleted χ` is bounded.  This is the qualitative version of the
Riemann–von Mangoldt strip estimate `‖Λ_χ'/Λ_χ(c+it)‖ ≤ C·log(q(|t|+2))` (the quantitative
`log` growth needs the digamma series, absent from Mathlib). -/
theorem exists_bound_logDeriv_dirichletCompleted {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {c d R : ℝ} (hc : 1 < c) (hcd : c ≤ d) :
    ∃ M : ℝ, ∀ s ∈ (Set.uIcc c d ×ℂ Set.uIcc (-R) R),
      ‖logDeriv (dirichletCompleted χ) s‖ ≤ M := by
  have hne : ∀ s ∈ (Set.uIcc c d ×ℂ Set.uIcc (-R) R), dirichletCompleted χ s ≠ 0 := by
    intro s hs
    rw [Complex.mem_reProdIm, Set.uIcc_of_le hcd] at hs
    exact dirichletCompleted_ne_zero_of_one_lt_re χ (by linarith [hs.1.1])
  have hcont : ContinuousOn (fun s => logDeriv (dirichletCompleted χ) s)
      (Set.uIcc c d ×ℂ Set.uIcc (-R) R) := by
    have hlog : (fun s => logDeriv (dirichletCompleted χ) s)
        = fun s => deriv (dirichletCompleted χ) s / dirichletCompleted χ s := by
      funext s; rw [logDeriv_apply]
    rw [hlog]
    exact ContinuousOn.div
      (fun s _ => (analyticAt_dirichletCompleted χ hχ s).deriv.continuousAt.continuousWithinAt)
      (fun s _ => (analyticAt_dirichletCompleted χ hχ s).continuousAt.continuousWithinAt) hne
  exact (isCompact_uIcc.reProdIm isCompact_uIcc).exists_bound_of_continuousOn hcont

/-- **Named interface: the digamma growth bound.**  `‖ψ(σ+it)‖ ≲ log(|t|+2)` uniformly for
`σ > 0` — stated as a `Prop` in the style of `RootNumberSign` / `RiemannVonMangoldtDensity`, since
Mathlib supplies no digamma series from which to prove it. -/
@[irreducible] noncomputable def digammaC (z : ℂ) : ℂ := Complex.digamma z

def DigammaGrowthBound (σ0 : ℝ) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ,
    ‖digammaC (σ0 + t * Complex.I)‖ ≤ C * (1 + Real.log (|t| + 2))

/-- **Covering the range `0 < σ0 ≤ 1`.**  §97 (`digammaGrowthBound_of_stripBound`) shifts *down* by a
natural number and therefore only covers `σ0 ≥ 1`.  But the strip estimate §80 needs
`DigammaGrowthBound (c/2)` with `c > 1`, i.e. `σ0 ∈ (1/2, 1)` — **exactly the uncovered range**.
Here the recursion is run *up* by one, `ψ(s) = ψ(s+1) − s⁻¹`, which costs only `1/σ0`. -/
theorem digammaGrowthBound_of_stripBound_small {σ0 : ℝ} (h0 : 0 < σ0) (h1 : σ0 ≤ 1)
    (h : ∃ C : ℝ, 0 < C ∧ ∀ σ ∈ Set.Icc (1 : ℝ) 2, ∀ t : ℝ,
      ‖Complex.digamma (σ + t * Complex.I)‖ ≤ C * (1 + Real.log (|t| + 2))) :
    DigammaGrowthBound σ0 := by
  obtain ⟨C, hC, hb⟩ := h
  refine ⟨C * 2 + 1 / σ0 + 1, by positivity, fun t => ?_⟩
  have hne : ∀ m : ℕ, ((σ0 : ℂ) + (t : ℂ) * Complex.I) ≠ -(m : ℂ) := by
    intro m hc
    have hre : ((σ0 : ℂ) + (t : ℂ) * Complex.I).re = σ0 := by simp
    have h2 : ((σ0 : ℂ) + (t : ℂ) * Complex.I).re = -(m : ℝ) := by rw [hc]; simp
    have hm : (0:ℝ) ≤ m := Nat.cast_nonneg m
    rw [hre] at h2
    linarith
  have harg : ((σ0 : ℂ) + (t : ℂ) * Complex.I) + 1 = ((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    push_cast; ring
  have hrec := Complex.digamma_apply_add_nat (s := (σ0 : ℂ) + (t : ℂ) * Complex.I) hne 1
  simp only [Finset.sum_range_one, Nat.cast_zero, add_zero] at hrec
  have hstrip := hb (σ0 + 1) ⟨by linarith, by linarith⟩ t
  have hinv : ‖(((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ ≤ 1 / σ0 := by
    rw [norm_inv]
    have hle : σ0 ≤ ‖(σ0 : ℂ) + (t : ℂ) * Complex.I‖ := by
      calc σ0 = ((σ0 : ℂ) + (t : ℂ) * Complex.I).re := by simp
        _ ≤ ‖(σ0 : ℂ) + (t : ℂ) * Complex.I‖ := Complex.re_le_norm _
    simpa only [one_div] using one_div_le_one_div_of_le h0 hle
  have hrec' : Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)
      = Complex.digamma ((σ0 : ℂ) + (t : ℂ) * Complex.I)
        + (((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹ := by
    rw [← harg]; simpa using hrec
  have hsplit : Complex.digamma ((σ0 : ℂ) + (t : ℂ) * Complex.I)
      = Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)
        - (((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹ := by
    rw [hrec']; ring
  simp only [digammaC]
  rw [hsplit]
  calc ‖Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)
        - (((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖
      ≤ ‖Complex.digamma (((σ0 + 1 : ℝ) : ℂ) + (t : ℂ) * Complex.I)‖
        + ‖(((σ0 : ℂ) + (t : ℂ) * Complex.I))⁻¹‖ := norm_sub_le _ _
    _ ≤ C * (1 + Real.log (|t| + 2)) + 1 / σ0 := add_le_add hstrip hinv
    _ ≤ (C * 2 + 1 / σ0 + 1) * (1 + Real.log (|t| + 2)) := by
        have hL : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
          linarith [Real.log_nonneg (by linarith [abs_nonneg t] : (1:ℝ) ≤ |t| + 2)]
        nlinarith [hL, hC, h0, one_div_pos.mpr h0]


/-- **Part (C), reduced to a fixed strip.**  A bound `‖ψ(σ+it)‖ ≤ C·(1 + log(|t|+2))` valid on the
*fixed* strip `1 ≤ σ ≤ 2` implies the same bound on the fixed vertical line `Re s = σ0`, for any
`σ0` with `σ0 - n ∈ [1,2]`.  The shift costs only the finite sum `∑_{k<n} 1/(σ0-n+k)`, which is
`O(1)` since `n` is fixed.

So the whole of part (C) reduces to the strip `1 ≤ Re s ≤ 2` — where the digamma asymptotic is
needed (Mathlib has the recurrence and reflection but no series or bound). -/
theorem digammaGrowthBound_of_stripBound {σ0 : ℝ} (n : ℕ)
    (hσ0n : σ0 - n ∈ Set.Icc (1 : ℝ) 2)
    (h : ∃ C : ℝ, 0 < C ∧ ∀ σ ∈ Set.Icc (1 : ℝ) 2, ∀ t : ℝ,
      ‖Complex.digamma (σ + t * Complex.I)‖ ≤ C * (1 + Real.log (|t| + 2))) :
    DigammaGrowthBound σ0 := by
  obtain ⟨C, hC, hb⟩ := h
  have hpos : ∀ k ∈ Finset.range n, (0:ℝ) < σ0 - n + k := by
    intro k hk
    have : (k : ℝ) < n := by exact_mod_cast Finset.mem_range.mp hk
    linarith [hσ0n.1]
  have hSnn : 0 ≤ ∑ k ∈ Finset.range n, 1 / (σ0 - n + k) :=
    Finset.sum_nonneg fun k hk => (div_pos one_pos (hpos k hk)).le
  refine ⟨C + (∑ k ∈ Finset.range n, 1 / (σ0 - n + k)) + 1,
    by linarith [hC, hSnn], fun t => ?_⟩
  have hs : ∀ m : ℕ, (↑(σ0 - n) : ℂ) + ↑t * Complex.I ≠ -(m : ℂ) := by
    intro m h
    have h1 : ((↑(σ0 - n) : ℂ) + ↑t * Complex.I).re = σ0 - n := by simp
    have h2 : (-(m : ℂ)).re = -(m : ℝ) := by simp
    rw [h, h2] at h1
    have hm : (0:ℝ) ≤ m := Nat.cast_nonneg m
    linarith [hσ0n.1]
  have hrec := Complex.digamma_apply_add_nat (s := (↑(σ0 - n) : ℂ) + ↑t * Complex.I) hs n
  have harg : (↑(σ0 - n) : ℂ) + ↑t * Complex.I + (n : ℂ) = ↑σ0 + ↑t * Complex.I := by
    push_cast; ring
  rw [harg] at hrec
  have hstrip := hb (σ0 - n) hσ0n t
  have hsum : ‖∑ k ∈ Finset.range n, ((↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ))⁻¹‖
      ≤ ∑ k ∈ Finset.range n, 1 / (σ0 - n + k) := by
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun k hk => ?_)
    rw [norm_inv]
    have hre : ((↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ)).re = σ0 - n + k := by
      simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, mul_zero,
        sub_zero, add_zero, Complex.ofReal_im, mul_one]
      norm_num
    have h3 : σ0 - n + k ≤ ‖(↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ)‖ := by
      have := Complex.abs_re_le_norm ((↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ))
      rw [hre, abs_of_pos (hpos k hk)] at this
      exact this
    simpa only [one_div] using one_div_le_one_div_of_le (hpos k hk) h3
  calc ‖digammaC (σ0 + ↑t * Complex.I)‖
      = ‖Complex.digamma (↑(σ0 - n) + ↑t * Complex.I)
          + ∑ k ∈ Finset.range n, ((↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ))⁻¹‖ := by
        rw [digammaC, ← hrec]
    _ ≤ ‖Complex.digamma (↑(σ0 - n) + ↑t * Complex.I)‖
          + ‖∑ k ∈ Finset.range n, ((↑(σ0 - n) : ℂ) + ↑t * Complex.I + (k : ℂ))⁻¹‖ :=
        norm_add_le _ _
    _ ≤ C * (1 + Real.log (|t| + 2)) + ∑ k ∈ Finset.range n, 1 / (σ0 - n + k) :=
        add_le_add hstrip hsum
    _ ≤ (C + (∑ k ∈ Finset.range n, 1 / (σ0 - n + k)) + 1) * (1 + Real.log (|t| + 2)) := by
        have hL : (1:ℝ) ≤ 1 + Real.log (|t| + 2) := by
          linarith [Real.log_nonneg (by linarith [abs_nonneg t] : (1:ℝ) ≤ |t| + 2)]
        nlinarith [hL, hC, hSnn]

/-- **`Λ_χ'/Λ_χ` differs from its archimedean part by exactly the Dirichlet series.**
`‖Λ_χ'/Λ_χ(c+it) − arch(c+it)‖ ≤ ∑' n, Λ(n)·n^{−c}` for `Re s = c > 1`. -/

theorem digammaGrowthBound_of_stripBound_all {σ0 : ℝ} (hσ0 : 0 < σ0)
    (h : ∃ C : ℝ, 0 < C ∧ ∀ σ ∈ Set.Icc (1 : ℝ) 2, ∀ t : ℝ,
      ‖Complex.digamma (σ + t * Complex.I)‖ ≤ C * (1 + Real.log (|t| + 2))) :
    DigammaGrowthBound σ0 := by
  by_cases h1 : σ0 ≤ 1
  · exact digammaGrowthBound_of_stripBound_small hσ0 h1 h
  · push_neg at h1
    refine digammaGrowthBound_of_stripBound ((Int.ceil σ0 - 2).toNat) ?_ h
    have hle : σ0 ≤ ((Int.ceil σ0 : ℤ) : ℝ) := Int.le_ceil σ0
    have hlt : (((Int.ceil σ0 : ℤ)) : ℝ) < σ0 + 1 := Int.ceil_lt_add_one σ0
    have hge2 : (2 : ℤ) ≤ Int.ceil σ0 := by
      have h' : (1 : ℝ) < ((Int.ceil σ0 : ℤ) : ℝ) := lt_of_lt_of_le h1 hle
      have h'' : (1 : ℤ) < Int.ceil σ0 := by exact_mod_cast h'
      omega
    have hz : (0:ℤ) ≤ Int.ceil σ0 - 2 := by omega
    have hcast : (((Int.ceil σ0 - 2).toNat : ℕ) : ℝ) = ((Int.ceil σ0 : ℤ) : ℝ) - 2 := by
      have h1 : (((Int.ceil σ0 - 2).toNat : ℕ) : ℤ) = Int.ceil σ0 - 2 :=
        Int.toNat_of_nonneg hz
      calc (((Int.ceil σ0 - 2).toNat : ℕ) : ℝ)
          = ((((Int.ceil σ0 - 2).toNat : ℕ) : ℤ) : ℝ) := by push_cast; ring
        _ = ((Int.ceil σ0 - 2 : ℤ) : ℝ) := by rw [h1]
        _ = ((Int.ceil σ0 : ℤ) : ℝ) - 2 := by push_cast; ring
    rw [hcast]
    exact ⟨by linarith, by linarith⟩

theorem norm_logDeriv_sub_arch_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hE : χ.Even) {c : ℝ} (hc : 1 < c) (t : ℝ) :
    ‖logDeriv (dirichletCompleted χ) (c + t * Complex.I)
        - ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
           + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))‖
      ≤ ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) := by
  rw [logDeriv_dirichletCompleted_eq_even χ hχ hE (by simp; linarith)]
  rw [show (1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
        + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2)
        - LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I)
        - ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
           + (1 / 2) * Complex.digamma ((c + t * Complex.I) / 2))
      = -LSeries (fun n => dirichletWeight χ n) (c + t * Complex.I) from by ring]
  rw [norm_neg]
  exact norm_LSeries_dirichletWeight_le χ hc (s := (c + t * Complex.I)) (by simp)

/-- **The quantitative strip estimate from the digamma bound.**  `DigammaGrowthBound` gives the
Riemann–von Mangoldt strip estimate `‖Λ_χ'/Λ_χ(c+it)‖ = O(1 + log(|t|+2))` on `Re s = c > 1`.

The proof `set`-binds `logDeriv (dirichletCompleted χ)` as an *opaque function* `f` before anything
else, so the elaborator never reduces the large `logDeriv`/`dirichletCompleted` normalform. -/
theorem norm_logDeriv_dirichletCompleted_le_of_digamma {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (hE : χ.Even) {c : ℝ} (hc : 1 < c)
    (h : DigammaGrowthBound (c / 2)) :
    ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ,
      ‖logDeriv (dirichletCompleted χ) (c + t * Complex.I)‖ ≤ C * (1 + Real.log (|t| + 2)) := by
  set f : ℂ → ℂ := logDeriv (dirichletCompleted χ) with hf
  obtain ⟨C0, hC0, hb⟩ := h
  set A : ℝ := ‖Complex.log (N : ℂ)‖ with hA
  set B : ℝ := ‖Complex.log (Real.pi : ℂ)‖ with hB
  set D : ℝ := ∑' n : ℕ, (Λ n) * (n : ℝ) ^ (-c) with hD
  have hAnn : 0 ≤ A := by rw [hA]; exact norm_nonneg _
  have hBnn : 0 ≤ B := by rw [hB]; exact norm_nonneg _
  have hDnn : 0 ≤ D := by
    rw [hD]
    exact tsum_nonneg fun n => mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
      (Real.rpow_nonneg (Nat.cast_nonneg n) _)
  refine ⟨(1 / 2) * A + (1 / 2) * B + (1 / 2) * C0 + D + 1, by positivity, fun t => ?_⟩
  have hlog1 : 1 ≤ 1 + Real.log (|t| + 2) :=
    le_add_of_nonneg_right (Real.log_nonneg (by linarith [abs_nonneg t]))
  have hlog0 : (0:ℝ) ≤ 1 + Real.log (|t| + 2) := le_trans zero_le_one hlog1
  have hnorm : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
  have hpsi : ‖digammaC ((c + t * Complex.I) / 2)‖ ≤ C0 * (1 + Real.log (|t| + 2)) := by
    have hbase := hb (t / 2)
    have hhalf : (c + t * Complex.I) / 2 = ((c / 2 : ℝ) : ℂ) + ((t / 2 : ℝ) : ℂ) * Complex.I := by
      push_cast; ring
    rw [hhalf]
    have h2 : |t / 2| + 2 ≤ |t| + 2 := by rw [abs_div]; linarith [abs_nonneg t]
    have h3 : Real.log (|t / 2| + 2) ≤ Real.log (|t| + 2) :=
      Real.log_le_log (by positivity) h2
    exact hbase.trans (mul_le_mul_of_nonneg_left (by linarith) hC0.le)
  have harch : ‖(1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
        + (1 / 2) * digammaC ((c + t * Complex.I) / 2)‖
      ≤ (1 / 2) * A + (1 / 2) * B + (1 / 2) * (C0 * (1 + Real.log (|t| + 2))) := by
    refine (norm_add_le _ _).trans (add_le_add ?_ ?_)
    · refine (norm_sub_le _ _).trans (le_of_eq ?_)
      rw [norm_mul, norm_mul, hnorm, hA, hB]
    · rw [norm_mul, hnorm]
      exact mul_le_mul_of_nonneg_left hpsi (by norm_num)
  have hsub : ‖f (c + t * Complex.I)
        - ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
           + (1 / 2) * digammaC ((c + t * Complex.I) / 2))‖ ≤ D := by
    rw [hf, hD]
    have := norm_logDeriv_sub_arch_le χ hχ hE hc t
    simpa only [digammaC] using this
  have hkey : f (c + t * Complex.I)
      = (f (c + t * Complex.I)
          - ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * digammaC ((c + t * Complex.I) / 2)))
        + ((1 / 2) * Complex.log (N : ℂ) - (1 / 2) * Complex.log (Real.pi : ℂ)
             + (1 / 2) * digammaC ((c + t * Complex.I) / 2)) := by ring
  rw [hkey]
  refine ((norm_add_le _ _).trans (add_le_add hsub harch)).trans ?_
  nlinarith [hAnn, hBnn, hDnn, hC0, hlog1, hlog0]

/-- **`rightPath` bound after transporting the vertical edge to `Re s = c`.**  On `[1/2, c]` the
horizontal segments are bounded by `Mh` and the vertical edge at `Re s = c` by `Mv`:

    `‖rightPath g t₀ t₁‖ ≤ 2·Mh·|c − 1/2| + Mv·|t₁ − t₀|`.

Since §80's strip estimate holds at `Re s = c > 1`, `Mv` is available in closed form; only the
horizontal segments (through the critical strip) remain. -/
theorem norm_rightPath_le_of_transport {g : ℂ → ℂ} {c t0 t1 Mh Mv : ℝ} (hc : 1 ≤ c)
    (hcont : ContinuousOn g ([[(1 : ℝ), c]] ×ℂ [[t0, t1]]))
    (hdiff : ∀ x ∈ Set.Ioo (1 : ℝ) c ×ℂ Set.Ioo (min t0 t1) (max t0 t1),
      DifferentiableAt ℂ g x)
    (hint0 : IntervalIntegrable (fun x : ℝ => g (x + t0 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hint1 : IntervalIntegrable (fun x : ℝ => g (x + t1 * Complex.I)) volume (1 / 2 : ℝ) c)
    (hh0 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) c, ‖g (x + t0 * Complex.I)‖ ≤ Mh)
    (hh1 : ∀ x ∈ Set.uIoc (1 / 2 : ℝ) c, ‖g (x + t1 * Complex.I)‖ ≤ Mh)
    (hv : ∀ y ∈ Set.uIoc t0 t1, ‖g (c + y * Complex.I)‖ ≤ Mv) :
    ‖Rh45RouteBAnalytic.rightPath g t0 t1‖ ≤ Mh * |c - 1 / 2| + Mv * |t1 - t0| + Mh * |c - 1 / 2| := by
  have hrt := rightPath_transport (g := g) hc hcont hdiff hint0 hint1
  have e0 : ‖∫ x in (1 / 2 : ℝ)..c, g (x + t0 * Complex.I)‖ ≤ Mh * |c - 1 / 2| :=
    intervalIntegral.norm_integral_le_of_norm_le_const hh0
  have e1 : ‖∫ x in (1 / 2 : ℝ)..c, g (x + t1 * Complex.I)‖ ≤ Mh * |c - 1 / 2| :=
    intervalIntegral.norm_integral_le_of_norm_le_const hh1
  have e2 : ‖∫ y in t0..t1, g (c + y * Complex.I)‖ ≤ Mv * |t1 - t0| :=
    intervalIntegral.norm_integral_le_of_norm_le_const hv
  rw [hrt]
  calc ‖(∫ x in (1 / 2 : ℝ)..c, g (x + t0 * Complex.I))
        - (∫ x in (1 / 2 : ℝ)..c, g (x + t1 * Complex.I))
        + Complex.I * (∫ y in t0..t1, g (c + y * Complex.I))‖
      ≤ ‖(∫ x in (1 / 2 : ℝ)..c, g (x + t0 * Complex.I))
          - (∫ x in (1 / 2 : ℝ)..c, g (x + t1 * Complex.I))‖
        + ‖Complex.I * (∫ y in t0..t1, g (c + y * Complex.I))‖ := norm_add_le _ _
    _ ≤ (‖∫ x in (1 / 2 : ℝ)..c, g (x + t0 * Complex.I)‖
          + ‖∫ x in (1 / 2 : ℝ)..c, g (x + t1 * Complex.I)‖)
        + ‖∫ y in t0..t1, g (c + y * Complex.I)‖ := by
        gcongr
        · exact norm_sub_le _ _
        · rw [norm_mul, Complex.norm_I, one_mul]
    _ ≤ Mh * |c - 1 / 2| + Mv * |t1 - t0| + Mh * |c - 1 / 2| := by
        linarith [e0, e1, e2]

end

end RouteABC
