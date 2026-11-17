import DensityG0_4
import DensityG1_4
import DensityG2_4
import DensityG3_4
import DensityG4_4
import DensityG5_4
import DensityEnclosure

/-!
# The six density-term bands at `σ = 1/20`

The compact generated chains `DensityG0 … DensityG5` (the 779-panel partition
`gen/edges_779.txt` to `T = 80`, the second-order `h³` panel rule with
`--lip-c 5/2`) enclose
`IntersectionForm.density (1/20) c` at the six separations

```
c = 0, 1/5, 2/5, 3/5, 4/5, 1
```

that the 6×6 basis needs.  `densityTerm_eq_two_mul_density` doubles the
intervals, and the results below are the bands fed to
[`Assembly6.lean`](Assembly6.lean).

Each band is the certified interval rounded *outward* to five decimals.  The
partitions are the error-equalising grids of `gen/build_edges_opt.py`
(1878 panels, shared `Ω` module, LipSmall3 Lipschitz constant); `gen/predict.py`
reproduces the certified half-widths exactly.

This file is not a statement about the infinite Weil cone.
-/

noncomputable section

namespace PrimeSpectrumTensor

set_option maxHeartbeats 4000000

/-- `densityTerm 0 (1/20) ∈ [0.010712, 0.012680]`. -/
theorem densityTerm_mem6_c0 :
    densityTerm 0 (1 / 20) ∈ Set.Icc (5807874597 / 500000000000 : ℝ) (9430631 / 800000000) := by
  have h := PrimeSpectrumTensor.G0.density_mem_c0
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

/-- `densityTerm (1/5) (1/20) ∈ [-0.049070, -0.047102]`. -/
theorem densityTerm_mem6_c1 :
    densityTerm (1 / 5) (1 / 20) ∈ Set.Icc (-6030410797 / 125000000000 : ℝ) (-11979489407 / 250000000000) := by
  have h := PrimeSpectrumTensor.G1.density_mem_c1
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

/-- `densityTerm (2/5) (1/20) ∈ [-0.025022, -0.023054]`. -/
theorem densityTerm_mem6_c2 :
    densityTerm (2 / 5) (1 / 20) ∈ Set.Icc (-12146643203 / 500000000000 : ℝ) (-11886937939 / 500000000000) := by
  have h := PrimeSpectrumTensor.G2.density_mem_c2
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

/-- `densityTerm (3/5) (1/20) ∈ [-0.017826, -0.015858]`. -/
theorem densityTerm_mem6_c3 :
    densityTerm (3 / 5) (1 / 20) ∈ Set.Icc (-8606446909 / 500000000000 : ℝ) (-8232274893 / 500000000000) := by
  have h := PrimeSpectrumTensor.G3.density_mem_c3
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

/-- `densityTerm (4/5) (1/20) ∈ [-0.014438, -0.012104]`. -/
theorem densityTerm_mem6_c4 :
    densityTerm (4 / 5) (1 / 20) ∈ Set.Icc (-6887143137 / 500000000000 : ℝ) (-255243089 / 20000000000) := by
  have h := PrimeSpectrumTensor.G4.density_mem_c4
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

/-- `densityTerm 1 (1/20) ∈ [-0.012224, -0.009891]`. -/
theorem densityTerm_mem6_c5 :
    densityTerm 1 (1 / 20) ∈ Set.Icc (-234216177 / 20000000000 : ℝ) (-5200019897 / 500000000000) := by
  have h := PrimeSpectrumTensor.G5.density_mem_c5
  rw [Set.mem_Icc] at h ⊢
  rw [densityTerm_eq_two_mul_density]
  constructor <;> linarith [h.1, h.2]

end PrimeSpectrumTensor
