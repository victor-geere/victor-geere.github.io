import Mathlib
import Assembly7
import DensityBands7
import PrimeEnclosure7

/-!
# The `7 × 7` closure, conditional on one prime band

`Assembly7.gaussianGram7_posDef_of_density_bands` needs the seven density bands
and the *entry* deviation at the new separation `c = 6/5`.  Here the entry is
assembled from the certified density band
(`densityTerm_mem7_c6`) and a prime band at `6/5`, which is the single remaining
input: the prime enclosures in [`PrimeEnclosure.lean`](PrimeEnclosure.lean) are
instances per separation and there is none for `6/5` yet.

With `ε = 16/10000`, `7ε = 0.0112 < gramMargin7 = 3/250 = 0.012`, so the transfer
applies.  See [`../HANDOFF-M0P-NEXT.md`](../HANDOFF-M0P-NEXT.md) §4.1.

This is a finite computational certificate conditional on one rational band.  It
is **not** a statement about the infinite Weil cone and **not** a proof of the
Riemann hypothesis.
-/

set_option maxHeartbeats 2400000

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- **The `7 × 7` closure.**  Conditional only on the prime band at `c = 6/5`. -/
theorem gaussianGram7_posDef_of_prime_band
    (hq6 : (primeTerm (6 / 5) (1 / 20) + primeTerm (-(6 / 5)) (1 / 20)) / 2 ∈
      Set.Icc (-21100000 / 1000000000 : ℝ) (-21030000 / 1000000000)) :
    (gaussianGram7 (1 / 20)).PosDef := by
  have hd6 := densityTerm_mem7_c6
  have hp6 := poleTerm_mem_c6
  refine gaussianGram7_posDef_of_density_bands
    (hd0 := densityTerm_mem6_c0) (hd1 := densityTerm_mem6_c1)
    (hd2 := densityTerm_mem6_c2) (hd3 := densityTerm_mem6_c3)
    (hd4 := densityTerm_mem6_c4) (hd5 := densityTerm_mem6_c5) (hE6 := ?_)
  rw [abs_le]
  constructor <;> linarith [hd6.1, hd6.2, hp6.1, hp6.2, hq6.1, hq6.2]

/-- **The `7 × 7` closure, unconditional.** -/
theorem gaussianGram7_posDef : (gaussianGram7 (1 / 20)).PosDef :=
  gaussianGram7_posDef_of_prime_band primeTerm_sym_mem_six_fifths

end PrimeSpectrumTensor
