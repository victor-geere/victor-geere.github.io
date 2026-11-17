import Mathlib
import GaussianGram6
import PoleEnclosure
import PrimeEnclosure
import Assembly
import Transfer

/-!
# R3 at 6×6 — the assembly

Given the six density-term intervals certified by the compact chains
(`DensityBands6.lean`), the exact `6 × 6` Gaussian Weil Gram matrix is positive
definite at `σ = 1/20`.  The pole and prime inputs are the proved enclosures of
[`PoleEnclosure.lean`](PoleEnclosure.lean) and
[`PrimeEnclosure.lean`](PrimeEnclosure.lean).

The entry budget is `ε = 8/10000`.  The certified density bands give an entry
error of at most `7.356·10⁻⁴` (at `c = 1`, the worst separation), and
`6ε = 0.0048 < 1/70 = 0.014286`, so the rational transfer of
[`GaussianGram6.lean`](GaussianGram6.lean) applies.

This is a finite computational certificate.  It is **not** a statement about
the infinite Weil cone and **not** a proof of the Riemann hypothesis.
-/

set_option maxHeartbeats 1200000

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- One Gram entry, split into its three terms. -/
theorem gaussianGram6_apply (σ : ℝ) (i j : Fin 6) :
    gaussianGram6 σ i j =
      poleTerm (centre6 i - centre6 j) σ + densityTerm (centre6 i - centre6 j) σ +
        (primeTerm (centre6 i - centre6 j) σ + primeTerm (centre6 j - centre6 i) σ) / 2 := by
  simp only [gaussianGram6, gaussianGramEntry, gaussianW, Matrix.of_apply]
  have h1 : centre6 j - centre6 i = -(centre6 i - centre6 j) := by ring
  rw [h1, poleTerm_neg, densityTerm_neg]
  ring

/-- **The 6×6 assembly.**

Given the six density-term bands, the exact 6×6 Gaussian Weil Gram matrix at
`σ = 1/20` is positive definite.  The pole and prime terms are supplied by
`PoleEnclosure.lean` and `PrimeEnclosure.lean`. -/
theorem gaussianGram6_posDef_of_density_bands
    (hd0 : densityTerm 0 (1 / 20) ∈ Set.Icc (5807874597 / 500000000000 : ℝ) (9430631 / 800000000))
    (hd1 : densityTerm (1 / 5) (1 / 20) ∈ Set.Icc (-6030410797 / 125000000000 : ℝ) (-11979489407 / 250000000000))
    (hd2 : densityTerm (2 / 5) (1 / 20) ∈ Set.Icc (-12146643203 / 500000000000 : ℝ) (-11886937939 / 500000000000))
    (hd3 : densityTerm (3 / 5) (1 / 20) ∈ Set.Icc (-8606446909 / 500000000000 : ℝ) (-8232274893 / 500000000000))
    (hd4 : densityTerm (4 / 5) (1 / 20) ∈ Set.Icc (-6887143137 / 500000000000 : ℝ) (-255243089 / 20000000000))
    (hd5 : densityTerm 1 (1 / 20) ∈ Set.Icc (-234216177 / 20000000000 : ℝ) (-5200019897 / 500000000000)) :
    (gaussianGram6 (1 / 20)).PosDef := by
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
  refine gaussianGram6_posDef_of_entry_bound (G := gaussianGram6 (1 / 20)) (ε := 8 / 10000)
    (gaussianGram6_symm _) ?_ (by norm_num) (by norm_num [gramMargin6])
  intro i j
  rw [gaussianGram6_apply]
  fin_cases i <;> fin_cases j <;>
    simp only [centre6] <;>
    norm_num [gramCentre6] <;>
    (try simp only [poleTerm_neg, densityTerm_neg]) <;>
    norm_num <;>
    rw [abs_le] <;> constructor <;>
    linarith [hp0.1, hp0.2, hp1.1, hp1.2, hp2.1, hp2.2, hp3.1, hp3.2, hp4.1, hp4.2, hp5.1, hp5.2,
      hd0.1, hd0.2, hd1.1, hd1.2, hd2.1, hd2.2, hd3.1, hd3.2, hd4.1, hd4.2, hd5.1, hd5.2,
      hq0.1, hq0.2, hq1.1, hq1.2, hq2.1, hq2.2, hq3.1, hq3.2, hq4.1, hq4.2, hq5.1, hq5.2,
      hqn1.1, hqn1.2, hqn2.1, hqn2.2, hqn3.1, hqn3.2, hqn4.1, hqn4.2, hqn5.1, hqn5.2]

/-- The vector-level form of the 6×6 certificate: the Weil quadratic form on
the six Gaussian test functions is nonnegative. -/
theorem gaussianGram6_quadraticForm_nonneg_of_density_bands
    (hd0 : densityTerm 0 (1 / 20) ∈ Set.Icc (5807874597 / 500000000000 : ℝ) (9430631 / 800000000))
    (hd1 : densityTerm (1 / 5) (1 / 20) ∈ Set.Icc (-6030410797 / 125000000000 : ℝ) (-11979489407 / 250000000000))
    (hd2 : densityTerm (2 / 5) (1 / 20) ∈ Set.Icc (-12146643203 / 500000000000 : ℝ) (-11886937939 / 500000000000))
    (hd3 : densityTerm (3 / 5) (1 / 20) ∈ Set.Icc (-8606446909 / 500000000000 : ℝ) (-8232274893 / 500000000000))
    (hd4 : densityTerm (4 / 5) (1 / 20) ∈ Set.Icc (-6887143137 / 500000000000 : ℝ) (-255243089 / 20000000000))
    (hd5 : densityTerm 1 (1 / 20) ∈ Set.Icc (-234216177 / 20000000000 : ℝ) (-5200019897 / 500000000000))
    (x : Fin 6 → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * x j *
      gaussianGramEntry (centre6 i) (centre6 j) (1 / 20) := by
  have hpos := gaussianGram6_posDef_of_density_bands hd0 hd1 hd2 hd3 hd4 hd5
  have h := (Matrix.posSemidef_iff_dotProduct_mulVec.mp hpos.posSemidef).2 x
  have hq : star x ⬝ᵥ (gaussianGram6 (1 / 20) *ᵥ x)
      = ∑ i, ∑ j, x i * x j * gaussianGramEntry (centre6 i) (centre6 j) (1 / 20) := by
    simp only [dotProduct, Matrix.mulVec, gaussianGram6, Matrix.of_apply, star_trivial,
      Finset.sum_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  rwa [hq] at h

end PrimeSpectrumTensor
