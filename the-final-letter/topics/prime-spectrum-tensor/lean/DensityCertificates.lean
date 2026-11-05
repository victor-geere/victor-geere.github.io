import DensityC0_8
import DensityC1_8
import DensityC2_8
import DensityC3_8
import DensityEnclosure
import Assembly

/-!
# R2 closed: the four density-term bands and the positive-definiteness of the
# exact Gaussian Gram matrix

The generated files `DensityC0 … DensityC3` enclose `IntersectionForm.density`
       on the half line.  `densityTerm_eq_two_mul_density` doubles the intervals,
and the four results are fed to
`gaussianGram4_posDef_of_density_enclosure_loose`.

This file is the only hand-written step: the intervals below are read off the
conclusions of `density_mem_c0 … density_mem_c3`.
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The density term at `c = 0`, in the assembly band. -/
theorem densityTerm_mem_c0 :
    densityTerm 0 (1 / 20) ∈ Set.Icc (82 / 10000 : ℝ) (152 / 10000) := by
  have h := PrimeSpectrumTensor.D0.density_mem_c0
  rw [Set.mem_Icc] at h
  rw [densityTerm_eq_two_mul_density, Set.mem_Icc]
  constructor
  · linarith [h.1]
  · linarith [h.2]

/-- The density term at `c = 1/5`, in the assembly band. -/
theorem densityTerm_mem_c1 :
    densityTerm (1 / 5) (1 / 20) ∈ Set.Icc (-5158 / 100000 : ℝ) (-4458 / 100000) := by
  have h := PrimeSpectrumTensor.D1.density_mem_c1
  rw [Set.mem_Icc] at h
  rw [densityTerm_eq_two_mul_density, Set.mem_Icc]
  constructor
  · linarith [h.1]
  · linarith [h.2]

/-- The density term at `c = 2/5`, in the assembly band. -/
theorem densityTerm_mem_c2 :
    densityTerm (2 / 5) (1 / 20) ∈ Set.Icc (-2754 / 100000 : ℝ) (-2054 / 100000) := by
  have h := PrimeSpectrumTensor.D2.density_mem_c2
  rw [Set.mem_Icc] at h
  rw [densityTerm_eq_two_mul_density, Set.mem_Icc]
  constructor
  · linarith [h.1]
  · linarith [h.2]

/-- The density term at `c = 3/5`, in the assembly band. -/
theorem densityTerm_mem_c3 :
    densityTerm (3 / 5) (1 / 20) ∈ Set.Icc (-2034 / 100000 : ℝ) (-1334 / 100000) := by
  have h := PrimeSpectrumTensor.D3.density_mem_c3
  rw [Set.mem_Icc] at h
  rw [densityTerm_eq_two_mul_density, Set.mem_Icc]
  constructor
  · linarith [h.1]
  · linarith [h.2]

/-- **O4, closed.** The exact `4 × 4` Gaussian Weil Gram matrix at `σ = 1/20`
is positive definite. -/
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef :=
  gaussianGram4_posDef_of_density_enclosure_loose
    ⟨densityTerm_mem_c0.1, densityTerm_mem_c0.2⟩
    ⟨densityTerm_mem_c1.1, densityTerm_mem_c1.2⟩
    ⟨densityTerm_mem_c2.1, densityTerm_mem_c2.2⟩
    ⟨densityTerm_mem_c3.1, densityTerm_mem_c3.2⟩

end PrimeSpectrumTensor
