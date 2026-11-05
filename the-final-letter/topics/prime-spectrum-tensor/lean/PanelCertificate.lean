import Mathlib
import PanelAssembly
import WeightBound
import OmegaContinuous
import OmegaPanel
import LipSmall

/-!
# R2 — the per-panel certificate the generator emits

Given a midpoint enclosure `Ω(m) ∈ [qmlo, qmhi]` and a Lipschitz bound `lipx`,
produce the `panel_mem` conclusion for a panel `[a,b] ⊆ [0,60]`:

```
|∫_p w·Ω − qmid·(b−a)·w(m)| ≤ |qmid|·(1/100)·(b−a)³/4 + δ·(b−a)·(1/400),
δ = max (qmid − qlo) (qhi − qmid),  qmid = (qmlo+qmhi)/2,
qlo = qmlo − lipx(b−a)/2,          qhi = qmhi + lipx(b−a)/2.
```
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The midpoint rule for the weight on a panel inside `[0,60]`. -/
theorem weight_midpoint_rule {c : ℝ} (hc : |c| ≤ 3 / 5) {a b : ℝ} (hab : a ≤ b)
    (ha0 : 0 ≤ a) (hb60 : b ≤ 60) :
    |(∫ x in a..b, weight c x) - (b - a) * weight c ((a + b) / 2)| ≤
      (1 / 400) * (b - a) ^ 3 / 4 := by
  have hderiv : deriv (weight c) = weight1 c := funext fun t => (hasDerivAt_weight c t).deriv
  have hderiv2 : deriv (deriv (weight c)) = weight2 c := by
    rw [hderiv]
    funext t
    exact (hasDerivAt_weight2 c t).deriv
  refine midpoint_rule_bound hab ?_ ?_ ?_ ?_
  · intro x _
    rw [hderiv]
    exact hasDerivAt_weight c x
  · intro x _
    rw [hderiv2, hderiv]
    exact hasDerivAt_weight2 c x
  · intro x hx
    have h := abs_deriv2_weight_le hc (le_trans ha0 hx.1) (le_trans hx.2 hb60)
    simp only [hderiv2, hderiv] at h ⊢
    exact h
  · unfold weight
    fun_prop

/-- **The panel certificate.** -/
theorem panel_certificate {c : ℝ} (hc : |c| ≤ 3 / 5) {a b qmlo qmhi lipx : ℝ}
    (hab : a ≤ b) (ha0 : 0 ≤ a) (hb60 : b ≤ 60)
    (hlip : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ lipx)
    (hm1 : qmlo ≤ IntersectionForm.Omega ((a + b) / 2))
    (hm2 : IntersectionForm.Omega ((a + b) / 2) ≤ qmhi) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qmlo + qmhi) / 2) * ((b - a) * weight c ((a + b) / 2))| ≤
      |(qmlo + qmhi) / 2| * ((1 / 400) * (b - a) ^ 3 / 4) +
        max ((qmlo + qmhi) / 2 - (qmlo - lipx * (b - a) / 2))
            ((qmhi + lipx * (b - a) / 2) - (qmlo + qmhi) / 2) * ((b - a) * (1 / 400)) := by
  have hpanel := omega_panel_enclosure hab hlip
    (fun t _ => differentiable_Omega.differentiableAt) hm1 hm2
  refine panel_mem hab (by unfold weight; fun_prop) continuous_Omega ?_ ?_ ?_ ?_
    (weight_midpoint_rule hc hab ha0 hb60)
  · intro t ht
    exact (hpanel t ht).1
  · intro t ht
    exact (hpanel t ht).2
  · intro t _
    unfold weight
    rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400),
      abs_of_pos (Real.exp_pos _)]
    have h1 : |Real.cos (c * t)| ≤ 1 := Real.abs_cos_le_one _
    have h2 : Real.exp (-((1 / 20 : ℝ) * t) ^ 2) ≤ 1 := by
      rw [Real.exp_le_one_iff]
      nlinarith [sq_nonneg ((1 / 20 : ℝ) * t)]
    have h3 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) * t) ^ 2) := Real.exp_pos _
    have h4 : (0 : ℝ) ≤ |Real.cos (c * t)| := abs_nonneg _
    nlinarith [h1, h2, h3, h4]
  · norm_num

end PrimeSpectrumTensor
