import Mathlib
import GaussianGram
import Transfer
import PoleEnclosure
import PrimeEnclosure

/-!
# R3 — the assembly: O4 reduced to one density enclosure

This file combines the three terms of every Gram entry:

* the pole term, enclosed in [`PoleEnclosure.lean`](PoleEnclosure.lean);
* the prime term, enclosed in [`PrimeEnclosure.lean`](PrimeEnclosure.lean);
* the **density term**, which is the one remaining input.

`gaussianGram4_posDef_of_density_enclosure` proves

> if the density term at the four separations `0, 1/5, 2/5, 3/5` lies in the
> explicit rational intervals of the statement, then
> `(gaussianGram4 (1/20)).PosDef`,

with no other hypothesis.  The intervals are `±10⁻³` bands around the
numerically computed density values; they are deliberately loose, because the
transfer `posDef_of_entry_bound` tolerates an entry error up to `0.005675`.

So O4 is reduced to a single concrete statement: the four interval
memberships in the hypothesis.  That is R2 of
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4.
-/

noncomputable section

set_option maxHeartbeats 2000000

namespace PrimeSpectrumTensor

/-- The density term is even in `c`. -/
theorem densityTerm_neg (c σ : ℝ) : densityTerm (-c) σ = densityTerm c σ := by
  unfold densityTerm
  congr 2
  funext t
  rw [neg_mul, Real.cos_neg]

/-- One Gram entry, split into its three terms. -/
theorem gaussianGram4_apply (σ : ℝ) (i j : Fin 4) :
    gaussianGram4 σ i j =
      poleTerm (centre4 i - centre4 j) σ + densityTerm (centre4 i - centre4 j) σ +
        (primeTerm (centre4 i - centre4 j) σ + primeTerm (centre4 j - centre4 i) σ) / 2 := by
  simp only [gaussianGram4, gaussianGramEntry, gaussianW, Matrix.of_apply]
  have h1 : centre4 j - centre4 i = -(centre4 i - centre4 j) := by ring
  rw [h1, poleTerm_neg, densityTerm_neg]
  ring

/-- **R3: the assembly.**

Given the density term in the four stated rational intervals, the exact `4×4`
Gaussian Weil Gram matrix at `σ = 1/20` is positive definite.  The pole and
prime terms are supplied by `PoleEnclosure.lean` and `PrimeEnclosure.lean`. -/
theorem gaussianGram4_posDef_of_density_enclosure
    (hd0 : (107 / 10000 : ℝ) ≤ densityTerm 0 (1 / 20) ∧
      densityTerm 0 (1 / 20) ≤ 127 / 10000)
    (hd1 : (-491 / 10000 : ℝ) ≤ densityTerm (1 / 5) (1 / 20) ∧
      densityTerm (1 / 5) (1 / 20) ≤ -471 / 10000)
    (hd2 : (-251 / 10000 : ℝ) ≤ densityTerm (2 / 5) (1 / 20) ∧
      densityTerm (2 / 5) (1 / 20) ≤ -231 / 10000)
    (hd3 : (-179 / 10000 : ℝ) ≤ densityTerm (3 / 5) (1 / 20) ∧
      densityTerm (3 / 5) (1 / 20) ≤ -159 / 10000) :
    (gaussianGram4 (1 / 20)).PosDef := by
  have hp0 := poleTerm_mem_c0
  have hp1 := poleTerm_mem_c1
  have hp2 := poleTerm_mem_c2
  have hp3 := poleTerm_mem_c3
  have hq0 := primeTerm_mem_small (c := 0) (by norm_num)
  have hq1 := primeTerm_mem_small (c := 1 / 5) (by norm_num)
  have hq2 := primeTerm_mem_small (c := 2 / 5) (by norm_num)
  have hq3 := primeTerm_mem_three_fifths
  have hqn1 := primeTerm_mem_small (c := -(1 / 5)) (by norm_num)
  have hqn2 := primeTerm_mem_small (c := -(2 / 5)) (by norm_num)
  have hqn3 := primeTerm_mem_small (c := -(3 / 5)) (by norm_num)
  refine gaussianGram4_posDef_of_entry_bound (G := gaussianGram4 (1 / 20)) (ε := 12 / 10000)
    (gaussianGram4_symm _) ?_ (by norm_num) (by norm_num [gramMargin])
  intro i j
  rw [gaussianGram4_apply]
  fin_cases i <;> fin_cases j <;>
    simp only [centre4] <;>
    norm_num [gramCentre4] <;>
    (try simp only [poleTerm_neg, densityTerm_neg]) <;>
    norm_num <;>
    rw [abs_le] <;> constructor <;>
    linarith [hp0.1, hp0.2, hp1.1, hp1.2, hp2.1, hp2.2, hp3.1, hp3.2,
      hd0.1, hd0.2, hd1.1, hd1.2, hd2.1, hd2.2, hd3.1, hd3.2,
      hq0.1, hq0.2, hq1.1, hq1.2, hq2.1, hq2.2, hq3.1, hq3.2,
      hqn1.1, hqn1.2, hqn2.1, hqn2.2, hqn3.1, hqn3.2]


/-! ## A relaxed enclosure

The transfer tolerates an entry error of `0.005675 = 4·0.001419`.  The pole term
is known to `2·10⁻⁶` and the prime term to `2.2·10⁻⁵`, so the density term may be
off by up to `3.5·10⁻³`.  The theorem below therefore accepts four **`±3.5·10⁻³`**
intervals, i.e. `3.5×` wider than `gaussianGram4_posDef_of_density_enclosure`.

That is the version the numerical generator should target. -/

/-- **The relaxed certificate.** -/
theorem gaussianGram4_posDef_of_density_enclosure_loose
    (hd0 : (82 / 10000 : ℝ) ≤ densityTerm 0 (1 / 20) ∧
      densityTerm 0 (1 / 20) ≤ 152 / 10000)
    (hd1 : (-5158 / 100000 : ℝ) ≤ densityTerm (1 / 5) (1 / 20) ∧
      densityTerm (1 / 5) (1 / 20) ≤ -4458 / 100000)
    (hd2 : (-2754 / 100000 : ℝ) ≤ densityTerm (2 / 5) (1 / 20) ∧
      densityTerm (2 / 5) (1 / 20) ≤ -2054 / 100000)
    (hd3 : (-2034 / 100000 : ℝ) ≤ densityTerm (3 / 5) (1 / 20) ∧
      densityTerm (3 / 5) (1 / 20) ≤ -1334 / 100000) :
    (gaussianGram4 (1 / 20)).PosDef := by
  have hp0 := poleTerm_mem_c0
  have hp1 := poleTerm_mem_c1
  have hp2 := poleTerm_mem_c2
  have hp3 := poleTerm_mem_c3
  have hq0 := primeTerm_mem_small (c := 0) (by norm_num)
  have hq1 := primeTerm_mem_small (c := 1 / 5) (by norm_num)
  have hq2 := primeTerm_mem_small (c := 2 / 5) (by norm_num)
  have hq3 := primeTerm_mem_three_fifths
  have hqn1 := primeTerm_mem_small (c := -(1 / 5)) (by norm_num)
  have hqn2 := primeTerm_mem_small (c := -(2 / 5)) (by norm_num)
  have hqn3 := primeTerm_mem_small (c := -(3 / 5)) (by norm_num)
  refine gaussianGram4_posDef_of_entry_bound (G := gaussianGram4 (1 / 20)) (ε := 40 / 10000)
    (gaussianGram4_symm _) ?_ (by norm_num) (by norm_num [gramMargin])
  intro i j
  rw [gaussianGram4_apply]
  fin_cases i <;> fin_cases j <;>
    simp only [centre4] <;>
    norm_num [gramCentre4] <;>
    (try simp only [poleTerm_neg, densityTerm_neg]) <;>
    norm_num <;>
    rw [abs_le] <;> constructor <;>
    linarith [hp0.1, hp0.2, hp1.1, hp1.2, hp2.1, hp2.2, hp3.1, hp3.2,
      hd0.1, hd0.2, hd1.1, hd1.2, hd2.1, hd2.2, hd3.1, hd3.2,
      hq0.1, hq0.2, hq1.1, hq1.2, hq2.1, hq2.2, hq3.1, hq3.2,
      hqn1.1, hqn1.2, hqn2.1, hqn2.2, hqn3.1, hqn3.2]

end PrimeSpectrumTensor

