import Topic

/-!
# Vertical limits and the enumeration reduction

This file assembles the Gaussian explicit formula from the concrete vertical
limits at `Re s = 2` (`archRight`, `primeRight` in `Topic.lean`), and reduces
`GaussianExplicitFormulaInfinite` to the enumeration data (cofinal sequence,
absolute summability, chain limit, value).

All remaining analytic inputs are explicit hypotheses; nothing here asserts RH.
-/

noncomputable section

open Complex Matrix Filter Topology
open scoped BigOperators

namespace MissingBridge

open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeRectangle
open PrimeSpectrumTensor

/-- **End-to-end assembly with concrete vertical limits.** -/
theorem gaussianZeroSum_re_eq_gram_of_vertical
    (c σ : ℝ) (hσ : 0 < σ) (S : ℝ → Finset ℂ) (Zsum : ℂ)
    (A P A' P' : ℂ)
    (hcontour : ∀ T : ℝ,
      rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) (-1) 2 (-T) T =
        ((∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
          (2 * (Real.pi : ℂ) * I))
    (hbottom : Filter.Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (-T : ℝ) * I))
      atTop (nhds 0))
    (htop : Filter.Tendsto (fun T : ℝ => ∫ x : ℝ in (-1)..2,
      logDeriv completedZeta ((x : ℂ) + (T : ℝ) * I) * gaussianZeroTest c σ ((x : ℂ) + (T : ℝ) * I))
      atTop (nhds 0))
    (hsum : Filter.Tendsto (fun T : ℝ =>
      (∑ ρ ∈ S T, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) atTop
      (nhds (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1)))
    (hA : Filter.Tendsto (archRight c σ) atTop (nhds A))
    (hP : Filter.Tendsto (primeRight c σ) atTop (nhds P))
    (hA' : Filter.Tendsto (archRight (-c) σ) atTop (nhds A'))
    (hP' : Filter.Tendsto (primeRight (-c) σ) atTop (nhds P'))
    (hident : VerticalLimitIdentification c σ A P A' P') :
    Zsum.re = gaussianGramEntry c 0 σ := by
  have hright := tendsto_right (c := c) (σ := σ) hA hP
  have hleft := tendsto_left (c := c) (σ := σ) hA' hP'
  have hright' : Filter.Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((2 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((2 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (-A - P)) := by simpa using hright
  have hleft' : Filter.Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ (((-1 : ℝ) : ℂ) + (y : ℂ) * I))
      atTop (nhds (A' + P')) := by simpa using hleft
  have hassemble := explicit_formula_gaussianZeroTest_arch_prime c σ hσ S Zsum A P A' P'
    hcontour hbottom htop hright' hleft' hsum
  have hpole : (gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1).re =
      PrimeSpectrumTensor.poleTerm c σ := by
    rw [show PrimeSpectrumTensor.poleTerm c σ = MissingBridge.poleTerm c σ from rfl]
    exact (poleTerm_eq_re_gaussianZeroTest_pole_sum c σ).symm
  exact gaussianZeroSum_re_eq_gram hassemble hident hpole

/-- **Enumeration reduction.** -/
theorem gaussianExplicitFormulaInfinite_of_enumeration
    (henum : ∀ (σ c : ℝ), ∃ (S : ℕ → Finset {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1})
        (Zsum : ℂ),
      Monotone S ∧ (∀ ρ, ∃ n, ρ ∈ S n) ∧
      Summable (fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        (gaussianZeroTest c σ (ρ : ℂ)).re) ∧
      Filter.Tendsto (fun n => ∑ ρ ∈ S n, (gaussianZeroTest c σ (ρ : ℂ)).re) Filter.atTop
        (nhds Zsum.re) ∧
      Zsum.re = gaussianGramEntry c 0 σ) :
    GaussianExplicitFormulaInfinite := by
  intro σ c
  obtain ⟨S, Zsum, hmono, hcover, hsumm, htend, hval⟩ := henum σ c
  have hsum := hasSum_of_cofinal
    (f := fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      (gaussianZeroTest c σ (ρ : ℂ)).re) S hmono hcover hsumm htend
  rwa [hval] at hsum

end MissingBridge
