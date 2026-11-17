import DensityG7_6
import DensityBands7
import DensityEnclosure

/-!
# The eight density-term bands at `σ = 1/20`

The seven bands of [`DensityBands7.lean`](DensityBands7.lean) plus the new
separation `c = 7/5`, certified by the chain `DensityG7` (1042 panels on the
`c`-optimised partition `gen/edges_1042_c75.txt`, second-order `h³` rule,
`T = 80`).  These are the density inputs of the `8 × 8` assembly
[`Assembly8.lean`](Assembly8.lean).
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- `densityTerm (7/5) (1/20)` from the chain `DensityG7`. -/
theorem densityTerm_mem8_c7 :
    densityTerm (7 / 5) (1 / 20) ∈
      Set.Icc (-8956422242 / 1000000000000 : ℝ) (-7681872258 / 1000000000000) := by
  have h := PrimeSpectrumTensor.G7.density_mem_c7
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

end PrimeSpectrumTensor
