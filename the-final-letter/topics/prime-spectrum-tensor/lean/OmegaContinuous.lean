import Mathlib
import DensityEnclosure
import Archimedean

/-!
# `Ω` is continuous

`Ω(t) = −log π + Re ψ(1/4 + (t/2)i)`, and `ψ` is analytic on the slit plane, so
the whole line `Re = 1/4` lies inside its domain.  The library already proves
`Rh45.analyticAt_digamma_line`, which gives continuity at every `t`,
hence global continuity.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem continuous_digamma_line :
    Continuous (fun t : ℝ => Complex.digamma (Rh45.digammaLine t)) := by
  rw [continuous_iff_continuousAt]
  intro t
  have h1 : ContinuousAt (fun t : ℝ => Rh45.digammaLine t) t := by
    unfold Rh45.digammaLine
    fun_prop
  exact ContinuousAt.comp (Rh45.analyticAt_digamma_line t).continuousAt h1

theorem continuous_Omega : Continuous IntersectionForm.Omega := by
  have h : (fun t : ℝ => (Complex.digamma (Rh45.digammaLine t)).re) =
      fun t : ℝ => (Complex.digamma ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I)).re := by
    funext t
    unfold Rh45.digammaLine
    ring_nf
  unfold IntersectionForm.Omega
  refine Continuous.add continuous_const ?_
  show Continuous (fun t : ℝ =>
    (Complex.digamma ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I)).re)
  rw [← h]
  exact Complex.continuous_re.comp continuous_digamma_line

theorem differentiable_digamma_line :
    Differentiable ℝ (fun t : ℝ => Complex.digamma (Rh45.digammaLine t)) := by
  intro t
  have h1 : DifferentiableAt ℂ Complex.digamma (Rh45.digammaLine t) :=
    (Rh45.analyticAt_digamma_line t).differentiableAt
  have h2 : DifferentiableAt ℝ (fun x : ℝ => Rh45.digammaLine x) t := by
    unfold Rh45.digammaLine
    fun_prop
  exact (h1.restrictScalars ℝ).comp t h2

theorem differentiable_Omega : Differentiable ℝ IntersectionForm.Omega := by
  have h : (fun t : ℝ => (Complex.digamma (Rh45.digammaLine t)).re) =
      fun t : ℝ => (Complex.digamma ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I)).re := by
    funext t
    unfold Rh45.digammaLine
    ring_nf
  unfold IntersectionForm.Omega
  have hd : Differentiable ℝ (fun t : ℝ =>
      (Complex.digamma ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I)).re) := by
    rw [← h]
    exact Complex.differentiable_re.comp differentiable_digamma_line
  exact hd.const_add _

end PrimeSpectrumTensor
