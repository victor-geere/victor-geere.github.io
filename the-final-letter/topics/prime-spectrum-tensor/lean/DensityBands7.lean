import DensityG6_4
import DensityBands6
import DensityEnclosure

/-!
# The seven density-term bands at `σ = 1/20`

The six bands of [`DensityBands6.lean`](DensityBands6.lean) plus the new
separation `c = 6/5`, certified by the chain `DensityG6` (779 panels, second-order
`h³` rule, `T = 80`).  These are the density inputs of the `7 × 7` assembly
[`Assembly7.lean`](Assembly7.lean).
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- `densityTerm (6/5) (1/20)` from the chain `DensityG6`. -/
theorem densityTerm_mem7_c6 :
    densityTerm (6 / 5) (1 / 20) ∈
      Set.Icc (-10467759008 / 1000000000000 : ℝ) (-8537084428 / 1000000000000) := by
  have h := PrimeSpectrumTensor.G6.density_mem_c6
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

end PrimeSpectrumTensor
