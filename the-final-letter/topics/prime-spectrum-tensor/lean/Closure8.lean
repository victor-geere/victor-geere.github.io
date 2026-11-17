import Assembly8
import DensityBands8
import PrimeEnclosure8

/-!
# R3 at 8×8 — closure

The exact `8 × 8` Gaussian Weil Gram matrix at `σ = 1/20` is positive definite,
with no hypotheses.  The eight density bands come from the compact chains
`DensityG0 … DensityG7`, the pole enclosures from
[`PoleEnclosure.lean`](PoleEnclosure.lean) and the prime enclosures from
[`PrimeEnclosure7.lean`](PrimeEnclosure7.lean) (`c = 6/5`) and
[`PrimeEnclosure8.lean`](PrimeEnclosure8.lean) (`c = 7/5`).

The entry budget is `ε = 11/10000` and `8ε = 0.0088 < 1/110 = gramMargin8`.

This is a finite computational certificate.  It is **not** a statement about the
infinite Weil cone and **not** a proof of the Riemann hypothesis.
-/

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- **The `8 × 8` closure.** -/
theorem gaussianGram8_posDef : (gaussianGram8 (1 / 20)).PosDef := by
  have hd6 := densityTerm_mem7_c6
  have hd7 := densityTerm_mem8_c7
  have hp6 := poleTerm_mem_c6
  have hp7 := poleTerm_mem_c75
  have hq6 := primeTerm_sym_mem_six_fifths
  have hq7 := primeTerm_mem_seven_fifths
  have hqn7 := primeTerm_mem_small (c := -(7 / 5 : ℝ)) (by norm_num)
  refine gaussianGram8_posDef_of_density_bands
    (hd0 := densityTerm_mem6_c0) (hd1 := densityTerm_mem6_c1)
    (hd2 := densityTerm_mem6_c2) (hd3 := densityTerm_mem6_c3)
    (hd4 := densityTerm_mem6_c4) (hd5 := densityTerm_mem6_c5)
    (hE6 := ?_) (hE7 := ?_)
  · rw [abs_le]
    constructor <;> linarith [hd6.1, hd6.2, hp6.1, hp6.2, hq6.1, hq6.2]
  · rw [abs_le]
    constructor <;> linarith [hd7.1, hd7.2, hp7.1, hp7.2, hq7.1, hq7.2, hqn7.1, hqn7.2]

end PrimeSpectrumTensor
