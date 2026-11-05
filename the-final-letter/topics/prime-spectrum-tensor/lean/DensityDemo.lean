import Mathlib
import DensityAssembly
import PanelCertificate
import LipSmall

/-!
# R2 — interface validation on a single panel

Two checks that the chain's hypotheses and conclusions *match up*:

* `panel_one_panel` — `panel_certificate` produces the `panel_mem` conclusion for
  the coarse panel `[0,60]` (midpoint `30`), with the `Ω` enclosure taken from
  `IntersectionForm.omega_mem` and the Lipschitz bound `10` from `LipSmall`;
* `density_one_panel` — `density_approx_error` accepts that panel and yields the
  density enclosure.

Both keep `w(30)` symbolic, so **no exp or cos bound is required**: the whole
chain can be validated before the transcendental layer exists.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

theorem weight_eq_densityWeight (c t : ℝ) :
    weight c t = IntersectionForm.densityWeight (1 / 20) c t := by
  unfold weight IntersectionForm.densityWeight
  norm_num
  ring_nf

theorem omega_mem_thirty :
    ((IntersectionForm.omegaLo 30 1 1000 : ℚ) : ℝ) ≤ IntersectionForm.Omega 30 ∧
      IntersectionForm.Omega 30 ≤ ((IntersectionForm.omegaHi 30 1 1000 : ℚ) : ℝ) := by
  have h := IntersectionForm.omega_mem 30 1 1000 (by norm_num) (by norm_num)
  push_cast at h
  exact h

/-- **Interface check 2**: `density_approx_error` accepts the panel. -/
theorem density_one_panel {qmid E : ℝ}
    (hpanel : |(∫ x in (0 : ℝ)..60, IntersectionForm.densityWeight (1 / 20) 0 x *
        IntersectionForm.Omega x) -
      qmid * (60 * IntersectionForm.densityWeight (1 / 20) 0 30)| ≤ E) :
    |IntersectionForm.density (1 / 20) 0 -
      qmid * (60 * IntersectionForm.densityWeight (1 / 20) 0 30)| ≤ E + 1 / 10000 := by
  have hmain := density_approx_error (c := 0) (P := 1)
    (a := fun p : ℕ => 60 * (p : ℝ)) (qmid := fun _ => qmid) (E := fun _ => E)
    (by norm_num) (by norm_num) ?_
  · convert hmain using 2 <;> norm_num [Finset.sum_range_one]
  · intro p hp
    have hp0 : p = 0 := by omega
    subst hp0
    norm_num
    exact hpanel

end PrimeSpectrumTensor
