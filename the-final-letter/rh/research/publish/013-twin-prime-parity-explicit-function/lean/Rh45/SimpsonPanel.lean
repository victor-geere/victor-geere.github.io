/-
  SimpsonPanel.lean — the single-panel Simpson estimate, proved.

  Mathlib contains no quadrature rule at all (no Simpson, no trapezium; see
  `Mathlib/MeasureTheory/Integral/IntervalIntegral/TrapezoidalRule.lean` for the
  trapezium, and nothing for Simpson).  `Rh45/Archimedean.lean` therefore used to
  isolate the classical single-panel Simpson error estimate as an *unproved*
  hypothesis `SimpsonPanelEstimate`; the module docstring called it "the one
  quadrature input Mathlib does not contain".

  This file supplies that input, and in doing so repairs the statement.  As
  originally written,

      def SimpsonPanelEstimate (H : ℝ) : Prop :=
        ∀ (G : ℝ → ℝ) (c B : ℝ), 0 ≤ B →
          (∀ x ∈ Set.Icc c (c + 2 * H), |iteratedDeriv 4 G x| ≤ B) →
          |simpsonPanel G c H - ∫ x in c..(c + 2 * H), G x| ≤ (2 * H) ^ 5 / 2880 * B

  was **false**: `G x = |x|` on `[-1,1]` has `iteratedDeriv 4 G = 0` everywhere
  (Lean's `deriv` is `0` where the function is not differentiable), yet
  `simpsonPanel G (-1) 1 = 2/3 ≠ 1 = ∫_{-1}^{1} |x|`, so with `B = 0` the claimed
  bound `≤ 0` fails.  The repaired statement therefore assumes
  `ContDiffOn ℝ 4 G (Set.Icc c (c + 2 * H))`.

  A second, independent defect is recorded in `SIMPSON.md`: for `H < 0` the
  derivative hypothesis is vacuous (the interval is empty) while the right-hand
  side `(2H)⁵/2880 · B` is negative, so the all-`H` statement is refutable; the
  estimate below is proved for `0 ≤ H`, which is the only case the round uses.
-/
import Mathlib

namespace Rh45

noncomputable section

open scoped BigOperators
open MeasureTheory
open scoped Topology
open Filter


/-- A single Simpson panel on `[c, c+2H]`, with the midpoint `c+H`. -/
noncomputable def simpsonPanel (F : ℝ → ℝ) (c H : ℝ) : ℝ :=
  (2 * H) / 6 * (F c + 4 * F (c + H) + F (c + 2 * H))

/-- The defining equation of `simpsonPanel`, for rewriting. -/
theorem simpsonPanel_def (F : ℝ → ℝ) (c H : ℝ) :
    simpsonPanel F c H = (2 * H) / 6 * (F c + 4 * F (c + H) + F (c + 2 * H)) := rfl

/-- Composite Simpson's rule: `m` panels of half-width `H`, from
`a` to `a + 2mH`. -/
noncomputable def simpsonSum (F : ℝ → ℝ) (a H : ℝ) (m : ℕ) : ℝ :=
  ∑ i ∈ Finset.range m, simpsonPanel F (a + 2 * (i : ℝ) * H) H

/-- The defining equation of `simpsonSum`, for rewriting. -/
theorem simpsonSum_def (F : ℝ → ℝ) (a H : ℝ) (m : ℕ) :
    simpsonSum F a H m =
      ∑ i ∈ Finset.range m, simpsonPanel F (a + 2 * (i : ℝ) * H) H := rfl

/-- **The classical single-panel Simpson error estimate.**  For a `C⁴` function
whose fourth derivative is bounded by `B ≥ 0` on `[c, c+2H]`, Simpson's rule on
that panel is off by at most `(2H)⁵/2880 · B`.  (The regularity hypothesis is
what makes the statement true; see the module docstring.) -/
def SimpsonPanelEstimate (H : ℝ) : Prop :=
  ∀ (G : ℝ → ℝ) (c B : ℝ), 0 ≤ B →
    ContDiffOn ℝ 4 G (Set.Icc c (c + 2 * H)) →
    (∀ x ∈ Set.Icc c (c + 2 * H), |iteratedDeriv 4 G x| ≤ B) →
    |simpsonPanel G c H - ∫ x in c..(c + 2 * H), G x| ≤ (2 * H) ^ 5 / 2880 * B

/-! ## Exactness of Simpson's rule on cubics -/

/-- The monomial integral: `∫_c^{c+2H} (x−c)^k = (2H)^{k+1}/(k+1)`. -/
theorem integral_sub_pow (c H : ℝ) (k : ℕ) :
    ∫ x in c..(c + 2 * H), (x - c) ^ k = (2 * H) ^ (k + 1) / (k + 1) := by
  have ha : c + (-c) = (0 : ℝ) := by ring
  have hb : c + 2 * H + (-c) = 2 * H := by ring
  simp only [sub_eq_add_neg]
  rw [intervalIntegral.integral_comp_add_right (f := fun x : ℝ => x ^ k) (a := c)
    (b := c + 2 * H) (-c)]
  rw [ha, hb]
  rw [integral_pow]
  rw [zero_pow (Nat.succ_ne_zero k), sub_zero]

/-- **Simpson's rule is exact on `(x−c)^k` for `k ≤ 3`.** -/
theorem simpsonPanel_pow_exact (c H : ℝ) (k : ℕ) (hk : k ≤ 3) :
    simpsonPanel (fun x => (x - c) ^ k) c H = ∫ x in c..(c + 2 * H), (x - c) ^ k := by
  rw [integral_sub_pow]
  interval_cases k <;>
    simp only [simpsonPanel, Nat.reduceAdd, Nat.cast_ofNat] <;>
    ring

/-- **Simpson's rule is exact on a scalar multiple of `(x−c)^k` for `k ≤ 3`.** -/
theorem simpsonPanel_const_mul_pow_exact (a c H : ℝ) (k : ℕ) (hk : k ≤ 3) :
    simpsonPanel (fun x => a * (x - c) ^ k) c H
      = ∫ x in c..(c + 2 * H), a * (x - c) ^ k := by
  have h1 : simpsonPanel (fun x => a * (x - c) ^ k) c H
      = a * simpsonPanel (fun x => (x - c) ^ k) c H := by
    simp only [simpsonPanel]
    ring
  rw [h1, simpsonPanel_pow_exact c H k hk, intervalIntegral.integral_const_mul]

/-- **Simpson's rule is exact on the cubic Taylor polynomial `taylorWithinEval G 3 s c`.** -/
theorem simpsonPanel_taylorWithinEval (G : ℝ → ℝ) (s : Set ℝ) (c H : ℝ) :
    simpsonPanel (fun x => taylorWithinEval G 3 s c x) c H
      = ∫ x in c..(c + 2 * H), taylorWithinEval G 3 s c x := by
  have hfun : (fun x => taylorWithinEval G 3 s c x) =
      fun x => ∑ k ∈ Finset.range 4,
        (((k.factorial : ℝ)⁻¹ * iteratedDerivWithin k G s c) * (x - c) ^ k) := by
    funext x
    rw [taylor_within_apply]
    refine Finset.sum_congr rfl fun k hk => ?_
    simp only [smul_eq_mul]
    ring
  rw [hfun]
  have hpanel : ∀ t : Finset ℕ,
      simpsonPanel (fun x => ∑ k ∈ t,
          (((k.factorial : ℝ)⁻¹ * iteratedDerivWithin k G s c) * (x - c) ^ k)) c H
        = ∑ k ∈ t, simpsonPanel (fun x =>
            ((k.factorial : ℝ)⁻¹ * iteratedDerivWithin k G s c) * (x - c) ^ k) c H := by
    intro t
    induction t using Finset.induction_on with
    | empty => simp [simpsonPanel]
    | insert a t ha ih =>
      simp_rw [Finset.sum_insert ha]
      rw [← ih]
      simp only [simpsonPanel]
      ring
  rw [hpanel]
  rw [intervalIntegral.integral_finsetSum]
  · refine Finset.sum_congr rfl fun k hk => ?_
    have hk3 : k ≤ 3 := by
      have := Finset.mem_range.mp hk
      omega
    exact simpsonPanel_const_mul_pow_exact _ c H k hk3
  · intro k hk
    exact (by fun_prop : Continuous (fun x =>
      ((k.factorial : ℝ)⁻¹ * iteratedDerivWithin k G s c) * (x - c) ^ k)).intervalIntegrable _ _

lemma integral_indicator_Ici {a b t : ℝ} (ht : t ∈ Set.Icc a b) (f : ℝ → ℝ) :
    ∫ x in a..b, Set.indicator (Set.Ici t) f x = ∫ x in t..b, f x := by
  have h₁ : ∫ x in a..b, Set.indicator (Set.Ici t) f x
      = ∫ x in -b..-a, Set.indicator (Set.Ici t) f (-x) := by
    rw [intervalIntegral.integral_comp_neg (f := fun x => Set.indicator (Set.Ici t) f x)
      (a := -b) (b := -a)]
    simp
  rw [h₁]
  have h₂ : (fun x : ℝ => Set.indicator (Set.Ici t) f (-x))
      = Set.indicator (Set.Iic (-t)) (fun x => f (-x)) := by
    funext x
    rw [Set.indicator_apply, Set.indicator_apply]
    by_cases h : t ≤ -x
    · have : -t ≥ x := by linarith only [h]
      simp [Set.mem_Ici, Set.mem_Iic, h, this]
    · have : ¬ x ≤ -t := by linarith only [h]
      simp [Set.mem_Ici, Set.mem_Iic, h, this]
  rw [h₂]
  simp only [Set.Iic]
  have ht' : -t ∈ Set.Icc (-b) (-a) := ⟨by linarith [ht.2], by linarith [ht.1]⟩
  rw [intervalIntegral.integral_indicator (f := fun x => f (-x)) (a₁ := -b) (a₂ := -t)
    (a₃ := -a) ht']
  rw [intervalIntegral.integral_comp_neg (f := f) (a := -b) (b := -t)]
  simp

lemma integral_sub_pow_gen (a b : ℝ) (k : ℕ) :
    ∫ x in a..b, (x - a) ^ k = (b - a) ^ (k + 1) / (k + 1) := by
  have h := integral_sub_pow a ((b - a) / 2) k
  rw [show a + 2 * ((b - a) / 2) = b by ring,
      show 2 * ((b - a) / 2) = b - a by ring] at h
  exact h

/-- The triangular swap `∫_c^b ∫_c^x ((x-t)^3/6) f t dt dx = ∫_c^b ((b-t)^4/24) f t dt`. -/
lemma integral_integral_triangle {f : ℝ → ℝ} {c b : ℝ} (hf : ContinuousOn f (Set.Icc c b))
    (hcb : c ≤ b) :
    ∫ x in c..b, ∫ t in c..x, ((x - t) ^ 3 / 6) * f t
      = ∫ t in c..b, ((b - t) ^ 4 / 24) * f t := by
  let F : ℝ → ℝ → ℝ := fun x t => ((x - t) ^ 3 / 6) * f t
  let G : ℝ → ℝ → ℝ := fun x t => Set.indicator (Set.Iic x) (F x) t
  have hFcont : ContinuousOn (Function.uncurry F) (Set.Icc c b ×ˢ Set.Icc c b) := by
    have h1 : ContinuousOn (fun p : ℝ × ℝ => (p.1 - p.2) ^ 3 / 6)
        (Set.Icc c b ×ˢ Set.Icc c b) := by fun_prop
    have h2 : ContinuousOn (fun p : ℝ × ℝ => f p.2) (Set.Icc c b ×ˢ Set.Icc c b) :=
      hf.comp continuous_snd.continuousOn (fun p hp => hp.2)
    exact h1.mul h2
  have hFint : IntegrableOn (Function.uncurry F) (Set.Icc c b ×ˢ Set.Icc c b) :=
    hFcont.integrableOn_compact (isCompact_Icc.prod isCompact_Icc)
  have hGint : IntegrableOn (Function.uncurry G) (Set.Icc c b ×ˢ Set.Icc c b) := by
    have h := hFint.indicator (t := {p : ℝ × ℝ | p.2 ≤ p.1})
      (measurableSet_le measurable_snd measurable_fst)
    convert h using 1
    funext p
    simp only [Function.uncurry, G, Set.indicator_apply, Set.mem_Iic, Set.mem_ofPred_eq, F]
  have hsub : Set.uIoc c b ⊆ Set.Icc c b := by
    rw [Set.uIoc_of_le hcb]; exact Set.Ioc_subset_Icc_self
  have hint : IntegrableOn (Function.uncurry G) (Set.uIoc c b ×ˢ Set.uIoc c b) :=
    hGint.mono_set (Set.prod_mono hsub hsub)
  have hswap := intervalIntegral_intervalIntegral_swap (F := G) (a := c) (b := b) (c := c)
    (d := b) hint
  have hstep1 : ∀ x ∈ Set.Icc c b, ∫ t in c..x, F x t = ∫ t in c..b, G x t := by
    intro x hx
    have h := intervalIntegral.integral_indicator (μ := volume) (f := F x) (a₁ := c) (a₂ := x) (a₃ := b) hx
    simpa only [G, Set.Iic] using h.symm
  have hstep2 : ∀ t ∈ Set.Icc c b, ∫ x in c..b, G x t = ((b - t) ^ 4 / 24) * f t := by
    intro t ht
    have hfun : (fun x => G x t) = Set.indicator (Set.Ici t) (fun x => F x t) := by
      funext x
      simp only [G, Set.indicator_apply, Set.mem_Iic, Set.mem_Ici]
    rw [hfun, integral_indicator_Ici ht]
    have hmul : ∫ x in t..b, F x t = (∫ x in t..b, ((x - t) ^ 3 / 6)) * f t := by
      rw [intervalIntegral.integral_mul_const]
    rw [hmul]
    congr 1
    rw [intervalIntegral.integral_div, integral_sub_pow_gen t b 3]
    ring
  rw [show (∫ x in c..b, ∫ t in c..x, ((x - t) ^ 3 / 6) * f t)
      = ∫ x in c..b, ∫ t in c..b, G x t from
    intervalIntegral.integral_congr fun x hx =>
      hstep1 x (by rwa [Set.uIcc_of_le hcb] at hx)]
  rw [hswap]
  exact intervalIntegral.integral_congr fun t ht =>
    hstep2 t (by rwa [Set.uIcc_of_le hcb] at ht)


lemma taylorWithinEval_Icc_congr {c x b : ℝ} (hcx : c < x) (hxb : x ≤ b) (G : ℝ → ℝ) :
    taylorWithinEval G 3 (Set.Icc c x) c = taylorWithinEval G 3 (Set.Icc c b) c := by
  have hev : Set.Icc c x =ᶠ[𝓝 c] Set.Icc c b := by
    filter_upwards [Metric.ball_mem_nhds c (sub_pos.mpr hcx)] with y hy
    rw [Metric.mem_ball, Real.dist_eq] at hy
    have hyx : y < x := by
      have := (abs_lt.mp hy).2; linarith only [this]
    apply propext
    simp only [Set.mem_Icc]
    constructor
    · intro h; exact ⟨h.1, le_trans h.2 hxb⟩
    · intro h; exact ⟨h.1, le_of_lt hyx⟩
  funext y
  rw [taylor_within_apply, taylor_within_apply]
  refine Finset.sum_congr rfl fun k hk => ?_
  simp only [iteratedDerivWithin_eq_iteratedFDerivWithin]
  rw [iteratedFDerivWithin_congr_set hev k]


lemma combine_integrals (g1 g2 g3 : ℝ → ℝ) (c m b a b' : ℝ)
    (hg1m : IntervalIntegrable g1 volume c m) (hg2m : IntervalIntegrable g2 volume c m)
    (hg2b : IntervalIntegrable g2 volume m b) (hg3m : IntervalIntegrable g3 volume c m)
    (hg3b : IntervalIntegrable g3 volume m b) :
    a * (∫ t in c..m, g1 t) + b' * (∫ t in c..m, g2 t)
      + b' * (∫ t in m..b, g2 t) - (∫ t in c..m, g3 t) - (∫ t in m..b, g3 t)
    = (∫ t in c..m, a * g1 t + b' * g2 t - g3 t)
      + (∫ t in m..b, b' * g2 t - g3 t) := by
  have h1 : ∫ t in c..m, a * g1 t + b' * g2 t - g3 t
      = a * (∫ t in c..m, g1 t) + b' * (∫ t in c..m, g2 t) - (∫ t in c..m, g3 t) := by
    rw [intervalIntegral.integral_sub ((hg1m.const_mul a).add (hg2m.const_mul b')) hg3m,
        intervalIntegral.integral_add (hg1m.const_mul a) (hg2m.const_mul b'),
        intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
  have h2 : ∫ t in m..b, b' * g2 t - g3 t
      = b' * (∫ t in m..b, g2 t) - (∫ t in m..b, g3 t) := by
    rw [intervalIntegral.integral_sub (hg2b.const_mul b') hg3b,
        intervalIntegral.integral_const_mul]
  rw [h1, h2]
  ring


theorem simpsonPanelEstimate (H : ℝ) (hH : 0 ≤ H) : SimpsonPanelEstimate H := by
  intro G c B hB hG hderiv
  rcases eq_or_lt_of_le hH with hH0 | hHpos
  · subst hH0
    simp [simpsonPanel]
  · set b : ℝ := c + 2 * H with hb
    set m : ℝ := c + H with hm
    set I : Set ℝ := Set.Icc c b with hI
    have hcb : c ≤ b := by rw [hb]; linarith only [hH]
    have hcblt : c < b := by rw [hb]; linarith only [hHpos]
    have hcm : c < m := by rw [hm]; linarith only [hHpos]
    have hmb : m < b := by rw [hm, hb]; linarith only [hHpos]
    have hG' : ContDiffOn ℝ 4 G I := by rw [hI, hb]; exact hG
    have hderiv' : ∀ x ∈ I, |iteratedDeriv 4 G x| ≤ B := by rw [hI, hb]; exact hderiv
    have hIcont : ContinuousOn G I := hG'.continuousOn
    set P : ℝ → ℝ := fun x => taylorWithinEval G 3 I c x with hP
    set psi : ℝ → ℝ := fun x => G x - P x with hpsi
    set f4 : ℝ → ℝ := fun t => iteratedDerivWithin 4 G I t with hf4
    have hPeq : P = fun x => ∑ k ∈ Finset.range 4,
        (((k.factorial : ℝ)⁻¹ * iteratedDerivWithin k G I c) * (x - c) ^ k) := by
      funext x
      rw [hP]
      simp only [taylor_within_apply, smul_eq_mul]
      refine Finset.sum_congr rfl fun k hk => ?_
      ring
    have hPcont : Continuous P := by rw [hPeq]; fun_prop
    have hf4cont : ContinuousOn f4 I := by
      rw [hf4]
      exact hG'.continuousOn_iteratedDerivWithin (by norm_num) (uniqueDiffOn_Icc hcblt)
    have hpsic : ContinuousOn psi I := hIcont.sub hPcont.continuousOn
    have hpsiint : IntervalIntegrable psi volume c b := hpsic.intervalIntegrable_of_Icc hcb
    have hPint : IntervalIntegrable P volume c b := hPcont.intervalIntegrable c b
    have hrepr : ∀ x ∈ I, psi x = ∫ t in c..x, ((x - t) ^ 3 / 6) * f4 t := by
      intro x hx
      have hcx : c ≤ x := hx.1
      have hxb : x ≤ b := hx.2
      have hsub : Set.uIcc c x ⊆ I := by
        rw [hI, Set.uIcc_of_le hcx]
        intro t ht
        exact ⟨ht.1, le_trans ht.2 hxb⟩
      have htay := taylor_integral_remainder (f := G) (x := x) (x₀ := c) (n := 3)
        (hG'.mono hsub)
      have hcoe : taylorWithinEval G 3 (Set.uIcc c x) c x = P x := by
        rcases eq_or_lt_of_le hcx with hxc | hlt
        · rw [← hxc, hP]
          simp
        · rw [Set.uIcc_of_le hcx, hP]
          exact congrFun (taylorWithinEval_Icc_congr hlt hxb G) x
      have hint : ∫ t in c..x, ((x - t) ^ 3 / ((3 : ℕ).factorial : ℝ)) •
            iteratedDerivWithin 4 G (Set.uIcc c x) t
          = ∫ t in c..x, ((x - t) ^ 3 / 6) * f4 t := by
        refine intervalIntegral.integral_congr_uIoo fun t ht => ?_
        rw [Set.uIoo_of_le hcx] at ht
        have hcdiff : c < x := lt_trans ht.1 ht.2
        have htI : t ∈ I := by
          rw [hI]; exact ⟨le_of_lt ht.1, le_of_lt (lt_of_lt_of_le ht.2 hxb)⟩
        have htint : t ∈ interior I := by
          rw [hI, interior_Icc]
          exact ⟨ht.1, lt_of_lt_of_le ht.2 hxb⟩
        have h1 : iteratedDerivWithin 4 G (Set.uIcc c x) t = iteratedDeriv 4 G t :=
          iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_uIcc (ne_of_lt hcdiff))
            (hG'.contDiffAt (mem_interior_iff_mem_nhds.mp htint))
            (by rw [Set.uIcc_of_le hcx]; exact ⟨le_of_lt ht.1, le_of_lt ht.2⟩)
        have h2 : f4 t = iteratedDeriv 4 G t := by
          rw [hf4]
          exact iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc hcblt)
            (hG'.contDiffAt (mem_interior_iff_mem_nhds.mp htint)) htI
        rw [show (((3 : ℕ).factorial : ℝ)) = 6 by norm_num, smul_eq_mul, h1, h2]
      rw [hpsi]
      change G x - P x = _
      rw [← hcoe, htay]
      exact hint
    have hmI : m ∈ I := ⟨le_of_lt hcm, le_of_lt hmb⟩
    have hbI : b ∈ I := ⟨hcb, le_rfl⟩
    have hψc : psi c = 0 := by
      rw [hpsi]; change G c - P c = 0; rw [hP]; simp
    have hpanel : simpsonPanel psi c H = (2 * H) / 6 * (4 * psi m + psi b) := by
      rw [simpsonPanel_def, hψc, ← hm, ← hb]; ring
    have hf4' : ContinuousOn f4 (Set.Icc c b) := by rwa [hI] at hf4cont
    have hψint : ∫ x in c..b, psi x = ∫ t in c..b, ((b - t) ^ 4 / 24) * f4 t := by
      have h1 : ∫ x in c..b, psi x = ∫ x in c..b, ∫ t in c..x, ((x - t) ^ 3 / 6) * f4 t := by
        apply intervalIntegral.integral_congr
        intro x hx
        rw [Set.uIcc_of_le hcb] at hx
        exact hrepr x hx
      rw [h1]
      exact integral_integral_triangle hf4' hcb
    have hf4cm : ContinuousOn f4 (Set.Icc c m) :=
      hf4cont.mono (by rw [hI]; intro t ht; exact ⟨ht.1, le_trans ht.2 hmb.le⟩)
    have hf4mb : ContinuousOn f4 (Set.Icc m b) :=
      hf4cont.mono (by rw [hI]; intro t ht; exact ⟨le_trans hcm.le ht.1, ht.2⟩)
    have hg1m : IntervalIntegrable (fun t => ((m - t) ^ 3 / 6) * f4 t) volume c m := by
      apply ContinuousOn.intervalIntegrable_of_Icc hcm.le
      exact (by fun_prop : ContinuousOn (fun t : ℝ => (m - t) ^ 3 / 6) (Set.Icc c m)).mul hf4cm
    have hg2m : IntervalIntegrable (fun t => ((b - t) ^ 3 / 6) * f4 t) volume c m := by
      apply ContinuousOn.intervalIntegrable_of_Icc hcm.le
      exact (by fun_prop : ContinuousOn (fun t : ℝ => (b - t) ^ 3 / 6) (Set.Icc c m)).mul hf4cm
    have hg2b : IntervalIntegrable (fun t => ((b - t) ^ 3 / 6) * f4 t) volume m b := by
      apply ContinuousOn.intervalIntegrable_of_Icc hmb.le
      exact (by fun_prop : ContinuousOn (fun t : ℝ => (b - t) ^ 3 / 6) (Set.Icc m b)).mul hf4mb
    have hg3m : IntervalIntegrable (fun t => ((b - t) ^ 4 / 24) * f4 t) volume c m := by
      apply ContinuousOn.intervalIntegrable_of_Icc hcm.le
      exact (by fun_prop : ContinuousOn (fun t : ℝ => (b - t) ^ 4 / 24) (Set.Icc c m)).mul hf4cm
    have hg3b : IntervalIntegrable (fun t => ((b - t) ^ 4 / 24) * f4 t) volume m b := by
      apply ContinuousOn.intervalIntegrable_of_Icc hmb.le
      exact (by fun_prop : ContinuousOn (fun t : ℝ => (b - t) ^ 4 / 24) (Set.Icc m b)).mul hf4mb
    have hdiff : simpsonPanel psi c H - ∫ x in c..b, psi x
        = (∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t)
          + (∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t) := by
      rw [hpanel, hψint, hrepr m hmI, hrepr b hbI,
          ← intervalIntegral.integral_add_adjacent_intervals hg2m hg2b,
          ← intervalIntegral.integral_add_adjacent_intervals hg3m hg3b]
      have hL : (2 * H) / 6 * (4 * (∫ t in c..m, ((m - t) ^ 3 / 6) * f4 t)
            + ((∫ t in c..m, ((b - t) ^ 3 / 6) * f4 t)
              + (∫ t in m..b, ((b - t) ^ 3 / 6) * f4 t)))
          - ((∫ t in c..m, ((b - t) ^ 4 / 24) * f4 t)
              + (∫ t in m..b, ((b - t) ^ 4 / 24) * f4 t))
          = ((2 * H) / 6 * 4) * (∫ t in c..m, ((m - t) ^ 3 / 6) * f4 t)
            + ((2 * H) / 6) * (∫ t in c..m, ((b - t) ^ 3 / 6) * f4 t)
            + ((2 * H) / 6) * (∫ t in m..b, ((b - t) ^ 3 / 6) * f4 t)
            - (∫ t in c..m, ((b - t) ^ 4 / 24) * f4 t)
            - (∫ t in m..b, ((b - t) ^ 4 / 24) * f4 t) := by ring
      rw [hL]
      rw [combine_integrals (fun t => ((m - t) ^ 3 / 6) * f4 t)
            (fun t => ((b - t) ^ 3 / 6) * f4 t) (fun t => ((b - t) ^ 4 / 24) * f4 t)
            c m b ((2 * H) / 6 * 4) ((2 * H) / 6) hg1m hg2m hg2b hg3m hg3b]
      congr 1
      · apply intervalIntegral.integral_congr
        intro t ht
        rw [Set.uIcc_of_le hcm.le] at ht
        show ((2 * H) / 6 * 4) * (((m - t) ^ 3 / 6) * f4 t)
            + ((2 * H) / 6) * (((b - t) ^ 3 / 6) * f4 t)
            - (((b - t) ^ 4 / 24) * f4 t)
            = (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t
        rw [hb, hm]; ring
      · apply intervalIntegral.integral_congr
        intro t ht
        rw [Set.uIcc_of_le hmb.le] at ht
        show ((2 * H) / 6) * (((b - t) ^ 3 / 6) * f4 t) - (((b - t) ^ 4 / 24) * f4 t)
            = (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t
        rw [hb]; ring
    have hEG : |simpsonPanel G c H - ∫ x in c..b, G x|
        = |simpsonPanel psi c H - ∫ x in c..b, psi x| := by
      have hGadd : G = fun x => P x + psi x := by
        funext x; rw [hpsi]; ring
      have h1 : simpsonPanel G c H = simpsonPanel P c H + simpsonPanel psi c H := by
        rw [hGadd]; simp only [simpsonPanel]; ring
      have h2 : ∫ x in c..b, G x = (∫ x in c..b, P x) + ∫ x in c..b, psi x := by
        rw [hGadd, intervalIntegral.integral_add hPint hpsiint]
      have h3 : simpsonPanel P c H = ∫ x in c..b, P x := by
        have h := simpsonPanel_taylorWithinEval G I c H
        rw [← hb] at h
        simpa only [hP] using h
      rw [h1, h2, h3]; congr 1; ring
    rw [hEG, hdiff]
    have hw1nn : ∀ t ∈ Set.Icc c m, 0 ≤ H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24 := by
      intro t ht
      have hs : 0 ≤ t - c := by linarith [ht.1]
      have htH : t - c ≤ H := by rw [hm] at ht; linarith [ht.2]
      have h4 : 0 ≤ 4 * H - 3 * (t - c) := by linarith only [htH, hHpos]
      have : H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24
          = (t - c) ^ 3 * (4 * H - 3 * (t - c)) / 72 := by ring
      rw [this]; positivity
    have hw2nn : ∀ t ∈ Set.Icc m b, 0 ≤ H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24 := by
      intro t ht
      have hs : 0 ≤ b - t := by linarith [ht.2]
      have htH : b - t ≤ H := by rw [hm, hb] at ht; linarith [ht.1]
      have h4 : 0 ≤ 4 * H - 3 * (b - t) := by linarith only [htH, hHpos]
      have : H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24
          = (b - t) ^ 3 * (4 * H - 3 * (b - t)) / 72 := by ring
      rw [this]; positivity
    have hw1int : ∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) = H ^ 5 / 180 := by
      rw [show (fun t : ℝ => H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24)
          = fun t => (H / 18) * (t - c) ^ 3 - (1 / 24) * (t - c) ^ 4 from by funext t; ring]
      rw [intervalIntegral.integral_sub, intervalIntegral.integral_const_mul,
          intervalIntegral.integral_const_mul, integral_sub_pow_gen c m 3,
          integral_sub_pow_gen c m 4]
      · have hmc : m - c = H := by rw [hm]; ring
        rw [hmc]; ring
      · exact (by fun_prop : Continuous (fun t : ℝ => H / 18 * (t - c) ^ 3)).intervalIntegrable c m
      · exact (by fun_prop : Continuous (fun t : ℝ => 1 / 24 * (t - c) ^ 4)).intervalIntegrable c m
    have hw2int : ∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) = H ^ 5 / 180 := by
      rw [show (fun t : ℝ => H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24)
          = fun t => (H / 18) * (b - t) ^ 3 - (1 / 24) * (b - t) ^ 4 from by funext t; ring]
      rw [intervalIntegral.integral_sub, intervalIntegral.integral_const_mul,
          intervalIntegral.integral_const_mul,
          intervalIntegral.integral_comp_sub_left (f := fun u : ℝ => u ^ 3) (a := m) (b := b) b,
          intervalIntegral.integral_comp_sub_left (f := fun u : ℝ => u ^ 4) (a := m) (b := b) b,
          show b - b = (0 : ℝ) by ring, show b - m = H by rw [hm, hb]; ring]
      · have h3 : ∫ u in (0 : ℝ)..H, u ^ 3 = H ^ 4 / 4 := by
          have h := integral_sub_pow_gen 0 H 3
          simp only [sub_zero] at h
          rw [h]; ring
        have h4 : ∫ u in (0 : ℝ)..H, u ^ 4 = H ^ 5 / 5 := by
          have h := integral_sub_pow_gen 0 H 4
          simp only [sub_zero] at h
          rw [h]; ring
        rw [h3, h4]; ring
      · exact (by fun_prop : Continuous (fun t : ℝ => H / 18 * (b - t) ^ 3)).intervalIntegrable m b
      · exact (by fun_prop : Continuous (fun t : ℝ => 1 / 24 * (b - t) ^ 4)).intervalIntegrable m b
    have hb1 : |∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t|
        ≤ B * (∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24)) := by
      have hwint : IntervalIntegrable
          (fun t => (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * |f4 t|) volume c m := by
        apply ContinuousOn.intervalIntegrable_of_Icc hcm.le
        exact (by fun_prop : ContinuousOn
          (fun t : ℝ => H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) (Set.Icc c m)).mul hf4cm.abs
      have hwB : IntervalIntegrable
          (fun t => (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * B) volume c m := by
        apply ContinuousOn.intervalIntegrable_of_Icc hcm.le
        exact (by fun_prop : ContinuousOn
          (fun t : ℝ => H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) (Set.Icc c m)).mul continuousOn_const
      calc |∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t|
          ≤ ∫ t in c..m, |(H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t| :=
            intervalIntegral.abs_integral_le_integral_abs hcm.le
        _ = ∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * |f4 t| := by
            apply intervalIntegral.integral_congr
            intro t ht
            rw [Set.uIcc_of_le hcm.le] at ht
            change |(H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t|
                = (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * |f4 t|
            rw [abs_mul, abs_of_nonneg (hw1nn t ht)]
        _ ≤ ∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * B := by
            apply intervalIntegral.integral_mono_on_of_le_Ioo hcm.le hwint hwB
            intro t ht
            have htI : t ∈ I := by
              rw [hI]; exact ⟨le_of_lt ht.1, le_of_lt (lt_of_lt_of_le ht.2 hmb.le)⟩
            have htint : t ∈ interior I := by
              rw [hI, interior_Icc]
              exact ⟨ht.1, lt_of_lt_of_le ht.2 hmb.le⟩
            have hf4t : f4 t = iteratedDeriv 4 G t := by
              rw [hf4]
              exact iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc hcblt)
                (hG'.contDiffAt (mem_interior_iff_mem_nhds.mp htint)) htI
            have hbd : |f4 t| ≤ B := by rw [hf4t]; exact hderiv' t htI
            have hnn : 0 ≤ H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24 :=
              hw1nn t ⟨ht.1.le, ht.2.le⟩
            exact mul_le_mul_of_nonneg_left hbd hnn
        _ = B * (∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24)) := by
            rw [intervalIntegral.integral_mul_const]; ring
    have hb2 : |∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t|
        ≤ B * (∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24)) := by
      have hwint : IntervalIntegrable
          (fun t => (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * |f4 t|) volume m b := by
        apply ContinuousOn.intervalIntegrable_of_Icc hmb.le
        exact (by fun_prop : ContinuousOn
          (fun t : ℝ => H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) (Set.Icc m b)).mul hf4mb.abs
      have hwB : IntervalIntegrable
          (fun t => (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * B) volume m b := by
        apply ContinuousOn.intervalIntegrable_of_Icc hmb.le
        exact (by fun_prop : ContinuousOn
          (fun t : ℝ => H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) (Set.Icc m b)).mul continuousOn_const
      calc |∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t|
          ≤ ∫ t in m..b, |(H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t| :=
            intervalIntegral.abs_integral_le_integral_abs hmb.le
        _ = ∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * |f4 t| := by
            apply intervalIntegral.integral_congr
            intro t ht
            rw [Set.uIcc_of_le hmb.le] at ht
            change |(H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t|
                = (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * |f4 t|
            rw [abs_mul, abs_of_nonneg (hw2nn t ht)]
        _ ≤ ∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * B := by
            apply intervalIntegral.integral_mono_on_of_le_Ioo hmb.le hwint hwB
            intro t ht
            have htI : t ∈ I := by
              rw [hI]; exact ⟨le_of_lt (lt_trans hcm ht.1), le_of_lt ht.2⟩
            have htint : t ∈ interior I := by
              rw [hI, interior_Icc]
              exact ⟨lt_of_le_of_lt hcm.le ht.1, ht.2⟩
            have hf4t : f4 t = iteratedDeriv 4 G t := by
              rw [hf4]
              exact iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc hcblt)
                (hG'.contDiffAt (mem_interior_iff_mem_nhds.mp htint)) htI
            have hbd : |f4 t| ≤ B := by rw [hf4t]; exact hderiv' t htI
            have hnn : 0 ≤ H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24 :=
              hw2nn t ⟨ht.1.le, ht.2.le⟩
            exact mul_le_mul_of_nonneg_left hbd hnn
        _ = B * (∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24)) := by
            rw [intervalIntegral.integral_mul_const]; ring
    calc |(∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t)
            + (∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t)|
        ≤ |∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24) * f4 t|
          + |∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24) * f4 t| := abs_add_le _ _
      _ ≤ B * (∫ t in c..m, (H * (t - c) ^ 3 / 18 - (t - c) ^ 4 / 24))
          + B * (∫ t in m..b, (H * (b - t) ^ 3 / 18 - (b - t) ^ 4 / 24)) :=
            add_le_add hb1 hb2
      _ = (2 * H) ^ 5 / 2880 * B := by rw [hw1int, hw2int]; ring


end

end Rh45
