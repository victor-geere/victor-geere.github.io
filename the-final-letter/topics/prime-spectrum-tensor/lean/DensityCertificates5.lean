import DensityC4_8
import DensityCertificates
import DensityEnclosure
import GaussianGram5
import PoleEnclosure
import PrimeEnclosure

/-!
# M0′ at 5×5 — the density bands and the positive-definiteness theorem

This file closes the 5×5 rung of the finite Gaussian Weil–Gram programme
scoped in [`../HANDOFF-M0P-5X5.md`](../HANDOFF-M0P-5X5.md).  It combines

* the generated density certificate for the one new separation `c = 4/5`
  (`DensityC4_8.lean`, namespace `PrimeSpectrumTensor.D4`);
* the four density certificates already used for the closed 4×4 rung
  (`DensityCertificates.lean`);
* the pole enclosures `poleTerm_mem_c0 … poleTerm_mem_c4`
  ([`PoleEnclosure.lean`](PoleEnclosure.lean));
* the prime enclosures `primeTerm_mem_small`, `primeTerm_mem_three_fifths`
  and the new `primeTerm_mem_four_fifths` ([`PrimeEnclosure.lean`](PrimeEnclosure.lean));
* the exact rational transfer of [`GaussianGram5.lean`](GaussianGram5.lean).

The entry budget is `ε = 0.0036`; the transfer needs `5ε < 1/50 = 0.02`, and
`5·0.0036 = 0.018`.  The dominant entry error is the density band
`±0.003172`, followed by the prime band `±1.91·10⁻⁴` at `c = 4/5`.

This is **not** the infinite Weil cone and **not** a proof of the Riemann
hypothesis.  It is the finite certificate for the 5×5 basis at `σ = 1/20`.
-/

noncomputable section

namespace PrimeSpectrumTensor

set_option maxHeartbeats 8000000

/-- The density term at `c = 4/5`, in the assembly band. -/
theorem densityTerm_mem_c4 :
    densityTerm (4 / 5) (1 / 20) ∈ Set.Icc (-16443 / 1000000 : ℝ) (-10097 / 1000000) := by
  have h := PrimeSpectrumTensor.D4.density_mem_c4
  rw [Set.mem_Icc] at h
  rw [densityTerm_eq_two_mul_density, Set.mem_Icc]
  constructor
  · linarith [h.1]
  · linarith [h.2]

/-- One Gram entry of the 5×5 matrix, split into its three terms. -/
theorem gaussianGram5_apply (σ : ℝ) (i j : Fin 5) :
    gaussianGram5 σ i j =
      poleTerm (centre5 i - centre5 j) σ + densityTerm (centre5 i - centre5 j) σ +
        (primeTerm (centre5 i - centre5 j) σ + primeTerm (centre5 j - centre5 i) σ) / 2 := by
  simp only [gaussianGram5, gaussianGramEntry, gaussianW, Matrix.of_apply]
  have h1 : centre5 j - centre5 i = -(centre5 i - centre5 j) := by ring
  rw [h1, poleTerm_neg, densityTerm_neg]
  ring

/-- **The 5×5 assembly.**

Given the five density-term bands, the exact 5×5 Gaussian Weil Gram matrix at
`σ = 1/20` is positive definite.  The pole and prime terms are supplied by
`PoleEnclosure.lean` and `PrimeEnclosure.lean`. -/
theorem gaussianGram5_posDef_of_density_enclosure_loose
    (hd0 : (82 / 10000 : ℝ) ≤ densityTerm 0 (1 / 20) ∧
      densityTerm 0 (1 / 20) ≤ 152 / 10000)
    (hd1 : (-5158 / 100000 : ℝ) ≤ densityTerm (1 / 5) (1 / 20) ∧
      densityTerm (1 / 5) (1 / 20) ≤ -4458 / 100000)
    (hd2 : (-2754 / 100000 : ℝ) ≤ densityTerm (2 / 5) (1 / 20) ∧
      densityTerm (2 / 5) (1 / 20) ≤ -2054 / 100000)
    (hd3 : (-2034 / 100000 : ℝ) ≤ densityTerm (3 / 5) (1 / 20) ∧
      densityTerm (3 / 5) (1 / 20) ≤ -1334 / 100000)
    (hd4 : (-16443 / 1000000 : ℝ) ≤ densityTerm (4 / 5) (1 / 20) ∧
      densityTerm (4 / 5) (1 / 20) ≤ -10097 / 1000000) :
    (gaussianGram5 (1 / 20)).PosDef := by
  have hp0 := poleTerm_mem_c0
  have hp1 := poleTerm_mem_c1
  have hp2 := poleTerm_mem_c2
  have hp3 := poleTerm_mem_c3
  have hp4 := poleTerm_mem_c4
  have hq0 := primeTerm_mem_small (c := 0) (by norm_num)
  have hq1 := primeTerm_mem_small (c := 1 / 5) (by norm_num)
  have hq2 := primeTerm_mem_small (c := 2 / 5) (by norm_num)
  have hq3 := primeTerm_mem_three_fifths
  have hq4 := primeTerm_mem_four_fifths
  have hqn1 := primeTerm_mem_small (c := -(1 / 5)) (by norm_num)
  have hqn2 := primeTerm_mem_small (c := -(2 / 5)) (by norm_num)
  have hqn3 := primeTerm_mem_small (c := -(3 / 5)) (by norm_num)
  have hqn4 := primeTerm_mem_small (c := -(4 / 5)) (by norm_num)
  refine gaussianGram5_posDef_of_entry_bound (G := gaussianGram5 (1 / 20)) (ε := 36 / 10000)
    (gaussianGram5_symm _) ?_ (by norm_num) (by norm_num [gramMargin5])
  intro i j
  rw [gaussianGram5_apply]
  fin_cases i <;> fin_cases j <;>
    simp only [centre5] <;>
    norm_num [gramCentre5] <;>
    (try simp only [poleTerm_neg, densityTerm_neg]) <;>
    norm_num <;>
    rw [abs_le] <;> constructor <;>
    linarith [hp0.1, hp0.2, hp1.1, hp1.2, hp2.1, hp2.2, hp3.1, hp3.2, hp4.1, hp4.2,
      hd0.1, hd0.2, hd1.1, hd1.2, hd2.1, hd2.2, hd3.1, hd3.2, hd4.1, hd4.2,
      hq0.1, hq0.2, hq1.1, hq1.2, hq2.1, hq2.2, hq3.1, hq3.2, hq4.1, hq4.2,
      hqn1.1, hqn1.2, hqn2.1, hqn2.2, hqn3.1, hqn3.2, hqn4.1, hqn4.2]

/-- **M0′ at 5×5, closed.**  The exact `5 × 5` Gaussian Weil Gram matrix at
`σ = 1/20` is positive definite. -/
theorem gaussianGram5_posDef : (gaussianGram5 (1/20)).PosDef :=
  gaussianGram5_posDef_of_density_enclosure_loose
    ⟨densityTerm_mem_c0.1, densityTerm_mem_c0.2⟩
    ⟨densityTerm_mem_c1.1, densityTerm_mem_c1.2⟩
    ⟨densityTerm_mem_c2.1, densityTerm_mem_c2.2⟩
    ⟨densityTerm_mem_c3.1, densityTerm_mem_c3.2⟩
    ⟨densityTerm_mem_c4.1, densityTerm_mem_c4.2⟩

end PrimeSpectrumTensor
