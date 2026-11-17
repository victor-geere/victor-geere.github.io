import Mathlib
import GaussianGram8
import PoleEnclosure
import PrimeEnclosure
import Assembly
import Transfer

/-!
# R3 at 8×8 — the assembly

Given the seven density-term intervals certified by the compact chains
(`DensityG0 … DensityG6`) and the entry deviations at the two new separations
`c = 6/5` and `c = 7/5`, the exact `8 × 8` Gaussian Weil Gram matrix is positive
definite at `σ = 1/20`.  The pole and prime inputs are the proved enclosures of
[`PoleEnclosure.lean`](PoleEnclosure.lean) and
[`PrimeEnclosure.lean`](PrimeEnclosure.lean); the prime band at `c = 6/5` is the
one input still open (see [`../HANDOFF-M0P-NEXT.md`](../HANDOFF-M0P-NEXT.md)
§4.1), so it enters as a hypothesis here.

The entry budget is `ε = 11/10000`.  `8ε = 0.0088 < 1/110 = gramMargin8`, and
`gramCentre8 − (1/110)·I` is positive definite by the exact rational `LDLᵀ`
factorisation of [`GaussianGram8.lean`](GaussianGram8.lean).

This is a finite computational certificate.  It is **not** a statement about the
infinite Weil cone and **not** a proof of the Riemann hypothesis.
-/

set_option maxHeartbeats 2400000

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- One `8 × 8` Gram entry, split into its three terms. -/
theorem gaussianGram8_apply (σ : ℝ) (i j : Fin 8) :
    gaussianGram8 σ i j =
      poleTerm (centre8 i - centre8 j) σ + densityTerm (centre8 i - centre8 j) σ +
        (primeTerm (centre8 i - centre8 j) σ + primeTerm (centre8 j - centre8 i) σ) / 2 := by
  simp only [gaussianGram8, gaussianGramEntry, gaussianW, Matrix.of_apply]
  have h1 : centre8 j - centre8 i = -(centre8 i - centre8 j) := by ring
  rw [h1, poleTerm_neg, densityTerm_neg]
  ring

/-- **The 7×7 assembly** (conditional on the density bands and the `c = 6/5`
prime band). -/
theorem gaussianGram8_posDef_of_density_bands
    (hd0 : densityTerm 0 (1 / 20) ∈ Set.Icc (5807874597 / 500000000000 : ℝ) (9430631 / 800000000))
    (hd1 : densityTerm (1 / 5) (1 / 20) ∈ Set.Icc (-6030410797 / 125000000000 : ℝ) (-11979489407 / 250000000000))
    (hd2 : densityTerm (2 / 5) (1 / 20) ∈ Set.Icc (-12146643203 / 500000000000 : ℝ) (-11886937939 / 500000000000))
    (hd3 : densityTerm (3 / 5) (1 / 20) ∈ Set.Icc (-8606446909 / 500000000000 : ℝ) (-8232274893 / 500000000000))
    (hd4 : densityTerm (4 / 5) (1 / 20) ∈ Set.Icc (-6887143137 / 500000000000 : ℝ) (-255243089 / 20000000000))
    (hd5 : densityTerm 1 (1 / 20) ∈ Set.Icc (-234216177 / 20000000000 : ℝ) (-5200019897 / 500000000000))
    (hE6 : |poleTerm (6 / 5) (1 / 20) + densityTerm (6 / 5) (1 / 20) +
        (primeTerm (6 / 5) (1 / 20) + primeTerm (-(6 / 5)) (1 / 20)) / 2 -
        (334911 / 50000000 : ℝ)| ≤ 11 / 10000)
    (hE7 : |poleTerm (7 / 5) (1 / 20) + densityTerm (7 / 5) (1 / 20) +
        (primeTerm (7 / 5) (1 / 20) + primeTerm (-(7 / 5)) (1 / 20)) / 2 -
        (3891 / 20000000 : ℝ)| ≤ 11 / 10000) :
    (gaussianGram8 (1 / 20)).PosDef := by
  have hp0 := poleTerm_mem_c0
  have hp1 := poleTerm_mem_c1
  have hp2 := poleTerm_mem_c2
  have hp3 := poleTerm_mem_c3
  have hp4 := poleTerm_mem_c4
  have hp5 := poleTerm_mem_c5
  have hq0 := primeTerm_mem_small (c := 0) (by norm_num)
  have hq1 := primeTerm_mem_small (c := 1 / 5) (by norm_num)
  have hq2 := primeTerm_mem_small (c := 2 / 5) (by norm_num)
  have hq3 := primeTerm_mem_three_fifths
  have hq4 := primeTerm_mem_four_fifths
  have hq5 := primeTerm_c1_mem
  have hqn1 := primeTerm_mem_small (c := -(1 / 5)) (by norm_num)
  have hqn2 := primeTerm_mem_small (c := -(2 / 5)) (by norm_num)
  have hqn3 := primeTerm_mem_small (c := -(3 / 5)) (by norm_num)
  have hqn4 := primeTerm_mem_small (c := -(4 / 5)) (by norm_num)
  have hqn5 := primeTerm_mem_small (c := -(1 : ℝ)) (by norm_num)
  have hqn6 := primeTerm_mem_small (c := -(6 / 5 : ℝ)) (by norm_num)
  have hqn7 := primeTerm_mem_small (c := -(7 / 5 : ℝ)) (by norm_num)
  refine gaussianGram8_posDef_of_entry_bound (G := gaussianGram8 (1 / 20)) (ε := 11 / 10000)
    (gaussianGram8_symm _) ?_ (by norm_num) (by norm_num [gramMargin8])
  intro i j
  rw [gaussianGram8_apply]
  fin_cases i <;> fin_cases j <;>
    simp only [centre8] <;>
    norm_num [gramCentre8] <;>
    (try simp only [poleTerm_neg, densityTerm_neg]) <;>
    norm_num <;>
    rw [abs_le] <;> constructor <;>
    linarith [hp0.1, hp0.2, hp1.1, hp1.2, hp2.1, hp2.2, hp3.1, hp3.2, hp4.1, hp4.2, hp5.1, hp5.2,
      (abs_le.mp hE6).1, (abs_le.mp hE6).2, (abs_le.mp hE7).1, (abs_le.mp hE7).2, hd0.1, hd0.2, hd1.1, hd1.2, hd2.1, hd2.2, hd3.1, hd3.2, hd4.1, hd4.2,
      hd5.1, hd5.2, hq0.1, hq0.2, hq1.1, hq1.2, hq2.1, hq2.2, hq3.1, hq3.2,
      hq4.1, hq4.2, hq5.1, hq5.2,
      hqn1.1, hqn1.2, hqn2.1, hqn2.2, hqn3.1, hqn3.2, hqn4.1, hqn4.2, hqn5.1, hqn5.2,
      hqn6.1, hqn6.2, hqn7.1, hqn7.2]

end PrimeSpectrumTensor
