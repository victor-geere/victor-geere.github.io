import Mathlib
import DensityTail
import PanelSum
import MidpointRule
import WeightBound

/-!
# R2 — the density assembly

Composing the pieces: the density is the sum of its panel integrals (with the
per-panel signed error `E p`) plus the tail beyond `60`.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

theorem continuous_densityWeight_mul_Omega (c : ℝ) :
    Continuous (fun x => IntersectionForm.densityWeight (1 / 20) c x * IntersectionForm.Omega x) :=
  (continuous_densityWeight c).mul continuous_Omega

/-- **The density assembly.** -/
theorem density_approx_error {c : ℝ} {P : ℕ} {a : ℕ → ℝ} {qmid E : ℕ → ℝ}
    (h0 : a 0 = 0) (hT : a P = 60)
    (hpanel : ∀ p < P,
      |(∫ x in a p..a (p + 1), IntersectionForm.densityWeight (1 / 20) c x *
          IntersectionForm.Omega x) -
        qmid p * ((a (p + 1) - a p) *
          IntersectionForm.densityWeight (1 / 20) c ((a p + a (p + 1)) / 2))| ≤ E p) :
    |IntersectionForm.density (1 / 20) c -
      ∑ p ∈ Finset.range P, qmid p * ((a (p + 1) - a p) *
        IntersectionForm.densityWeight (1 / 20) c ((a p + a (p + 1)) / 2))| ≤
      (∑ p ∈ Finset.range P, E p) + 1 / 10000 := by
  set f : ℝ → ℝ := fun x => IntersectionForm.densityWeight (1 / 20) c x * IntersectionForm.Omega x
    with hf
  have hcont : Continuous f := continuous_densityWeight_mul_Omega c
  have hint1 : MeasureTheory.IntegrableOn f (Set.Ioc 0 60) := by
    rw [← intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num : (0:ℝ) ≤ 60)]
    exact hcont.intervalIntegrable (μ := MeasureTheory.volume) 0 60
  have hint2 : MeasureTheory.IntegrableOn f (Set.Ioi 60) := by
    have hgm := integrableOn_gaussian_moment (T := 60)
    refine MeasureTheory.Integrable.mono' hgm ?_ ?_
    · exact hcont.aestronglyMeasurable
    · filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
      rw [Real.norm_eq_abs]
      exact abs_densityWeight_mul_Omega_le (le_of_lt (Set.mem_Ioi.mp hx))
  have hsplit := integral_Ioi_split f (by norm_num : (0:ℝ) ≤ 60) hint1 hint2
  have hpanelsum := panel_sum_error (w := fun x => IntersectionForm.densityWeight (1 / 20) c x)
    (Ω := IntersectionForm.Omega) (P := P) (a := a) qmid E
    (fun p _ => hcont.intervalIntegrable (a p) (a (p + 1))) hpanel
  rw [h0, hT] at hpanelsum
  have hdens : IntersectionForm.density (1 / 20) c =
      (∫ x in (0:ℝ)..60, f x) + ∫ x in Set.Ioi (60:ℝ), f x := by
    unfold IntersectionForm.density
    rw [← hf]
    exact hsplit
  have htail : |∫ x in Set.Ioi (60 : ℝ), f x| ≤ 1 / 10000 := by
    rw [hf]
    exact density_tail_le
  calc |IntersectionForm.density (1 / 20) c -
        ∑ p ∈ Finset.range P, qmid p * ((a (p + 1) - a p) *
          IntersectionForm.densityWeight (1 / 20) c ((a p + a (p + 1)) / 2))|
      = |((∫ x in (0:ℝ)..60, f x) - ∑ p ∈ Finset.range P, qmid p * ((a (p + 1) - a p) *
          IntersectionForm.densityWeight (1 / 20) c ((a p + a (p + 1)) / 2))) +
          ∫ x in Set.Ioi (60:ℝ), f x| := by rw [hdens]; ring
    _ ≤ |(∫ x in (0:ℝ)..60, f x) - ∑ p ∈ Finset.range P, qmid p * ((a (p + 1) - a p) *
          IntersectionForm.densityWeight (1 / 20) c ((a p + a (p + 1)) / 2))| +
          |∫ x in Set.Ioi (60:ℝ), f x| := abs_add_le _ _
    _ ≤ (∑ p ∈ Finset.range P, E p) + 1 / 10000 := by linarith [hpanelsum, htail]

end PrimeSpectrumTensor
