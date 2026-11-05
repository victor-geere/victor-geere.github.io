import Mathlib
import DensityPanel

/-!
# R2 — from a midpoint enclosure to a panel enclosure

`IntersectionForm.omega_mem` encloses `Ω` at a *point*.  The panel bound needs an
enclosure on the whole panel, obtained from the midpoint value by the Lipschitz
bound `|Ω′| ≤ lipx`:

```
Ω t ∈ [qmlo − lipx·(b−a)/2, qmhi + lipx·(b−a)/2]      (t ∈ [a,b]).
```
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- **Midpoint to panel.** -/
theorem omega_panel_enclosure {a b lipx qmlo qmhi : ℝ} (hab : a ≤ b)
    (hlip : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ lipx)
    (hderiv : ∀ t ∈ Set.Icc a b, DifferentiableAt ℝ IntersectionForm.Omega t)
    (hm : qmlo ≤ IntersectionForm.Omega ((a + b) / 2))
    (hm2 : IntersectionForm.Omega ((a + b) / 2) ≤ qmhi) :
    ∀ t ∈ Set.Icc a b,
      qmlo - lipx * (b - a) / 2 ≤ IntersectionForm.Omega t ∧
        IntersectionForm.Omega t ≤ qmhi + lipx * (b - a) / 2 := by
  intro t ht
  have hm_mem : (a + b) / 2 ∈ Set.Icc a b := by
    constructor <;> linarith
  have hconv : Convex ℝ (Set.Icc a b) := convex_Icc a b
  have hbound : ∀ x ∈ Set.Icc a b, ‖deriv IntersectionForm.Omega x‖ ≤ lipx := by
    intro x hx
    rw [Real.norm_eq_abs]
    exact hlip x hx
  have h := Convex.norm_image_sub_le_of_norm_deriv_le (f := IntersectionForm.Omega)
    (s := Set.Icc a b) (C := lipx) hderiv hbound hconv hm_mem ht
  rw [Real.norm_eq_abs] at h
  have hdist : |t - (a + b) / 2| ≤ (b - a) / 2 := by
    rw [abs_le]
    constructor <;> linarith [ht.1, ht.2]
  have hmain : |IntersectionForm.Omega t - IntersectionForm.Omega ((a + b) / 2)| ≤
      lipx * ((b - a) / 2) := by
    apply le_trans h
    apply mul_le_mul_of_nonneg_left hdist
    -- `lipx ≥ 0`
    have := hlip a ⟨le_rfl, hab⟩
    linarith [abs_nonneg (deriv IntersectionForm.Omega a)]
  rw [abs_le] at hmain
  constructor <;> linarith [hmain.1, hmain.2, hm, hm2]

end PrimeSpectrumTensor
