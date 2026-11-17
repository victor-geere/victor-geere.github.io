import Topic
import ZeroCounting
import Mathlib

/-!
# Absolute summability of the Gaussian zero sum

Given the linear growth of `ξ₀` and an enumeration of its nontrivial zeros, the
Gaussian zero sum over the critical-strip zeros is absolutely summable.  The
zero-counting is handled by the Jensen bound and inverse-square summability in
`Hadamard.lean` (via `zeroTailSummable_of_nontrivial_xi₀_enumeration`), not
assumed.
-/

set_option maxHeartbeats 800000

noncomputable section

open Complex Matrix Filter Topology
open scoped BigOperators

namespace MissingBridge

open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeRectangle AbsoluteHodgeHadamard MissingBridge
open PrimeSpectrumTensor

/-- Summability of the Gaussian exponential over the nontrivial zeros, from the
linear growth of `ξ₀` and an enumeration. -/
theorem summable_exp_im_sq_of_xi₀_growth
    [Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}]
    {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B)
    (a : ℕ → ℂ) (hinj : Function.Injective a)
    (hrange : ∀ n, xi₀ (a n) = 0) (hpos : ∀ n, 0 < (a n).re)
    (hrange_eq : Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re})
    (σ : ℝ) (hσ : 0 < σ) (hγ : Tendsto (fun n : ℕ => |(a n).im|) atTop atTop) :
    Summable (fun z : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} =>
      Real.exp (-(σ ^ 2 * ((z : ℂ).im) ^ 2))) := by
  have hExp : ZeroTailSummable (fun n : ℕ => (a n).im) σ :=
    zeroTailSummable_of_nontrivial_xi₀_enumeration hA hB hgrowth a hinj hrange hpos σ hσ hγ
  let f : ℕ → {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} := fun n => ⟨a n, hrange n, hpos n⟩
  have hf : Function.Bijective f := by
    refine ⟨fun m n h => hinj (Subtype.ext_iff.mp h), fun z => ?_⟩
    obtain ⟨n, hn⟩ := show (z : ℂ) ∈ Set.range a from by rw [hrange_eq]; exact z.2
    exact ⟨n, Subtype.ext hn⟩
  let e : ℕ ≃ {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} := Equiv.ofBijective f hf
  have he : ∀ n, (e n : ℂ) = a n := by
    intro n
    show ((Equiv.ofBijective f hf) n : ℂ) = a n
    rw [Equiv.ofBijective_apply]
  have hExpSeq : Summable (fun n : ℕ => Real.exp (-(σ ^ 2 * ((a n).im) ^ 2))) := by
    simpa [ZeroTailSummable] using hExp
  have hcomp : Summable ((fun z : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} =>
      Real.exp (-(σ ^ 2 * ((z : ℂ).im) ^ 2))) ∘ e) := by
    have hfun : ((fun z : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} =>
        Real.exp (-(σ ^ 2 * ((z : ℂ).im) ^ 2))) ∘ e)
        = (fun n : ℕ => Real.exp (-(σ ^ 2 * ((a n).im) ^ 2))) := by
      funext n
      simp only [Function.comp_apply, he n]
    rw [hfun]
    exact hExpSeq
  exact e.summable_iff.mp hcomp

end MissingBridge

namespace MissingBridge

open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeRectangle AbsoluteHodgeHadamard MissingBridge
open PrimeSpectrumTensor

/-- **Absolute summability from the linear growth of `ξ₀`.**  Given an
enumeration of the nontrivial zeros and the linear growth bound on `ξ₀`, the
Gaussian zero sum over the critical-strip zeros is absolutely summable. -/
theorem summable_gaussianZeroSum_of_xi₀_growth
    [Denumerable {z : ℂ // xi₀ z = 0 ∧ 0 < z.re}]
    {A B : ℝ} (hA : 0 ≤ A) (hB : 0 ≤ B)
    (hgrowth : ∀ z : ℂ, Real.log ‖xi₀ z‖ ≤ A * ‖z‖ + B)
    (a : ℕ → ℂ) (hinj : Function.Injective a)
    (hrange : ∀ n, xi₀ (a n) = 0) (hpos : ∀ n, 0 < (a n).re)
    (hrange_eq : Set.range a = {z : ℂ | xi₀ z = 0 ∧ 0 < z.re})
    (c σ : ℝ) (hσ : 0 < σ) (hγ : Tendsto (fun n : ℕ => |(a n).im|) atTop atTop) :
    Summable (fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      (gaussianZeroTest c σ (ρ : ℂ)).re) := by
  have hExpZ : Summable (fun z : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} =>
      Real.exp (-(σ ^ 2 * ((z : ℂ).im) ^ 2))) :=
    summable_exp_im_sq_of_xi₀_growth hA hB hgrowth a hinj hrange hpos hrange_eq σ hσ hγ
  -- the equivalence between the two zero subtypes
  let Φ : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} ≃
      {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} :=
    Equiv.ofBijective
      (fun z => (⟨z.1, by
        have hstrip := xi₀_zero_re_open_strip z.2.1 z.2.2
        have hz0 : (z : ℂ) ≠ 0 := by
          intro h; rw [h] at hstrip; simp at hstrip
        have hz1 : (z : ℂ) ≠ 1 := by
          intro h; rw [h] at hstrip; norm_num at hstrip
        have hΓ : (z : ℂ).Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hstrip.1
        refine ⟨?_, hstrip.1, hstrip.2⟩
        rw [completedZeta_eq_completedRiemannZeta hz0 hz1 hΓ]
        exact (xi₀_eq_zero_iff z hz0 hz1).mp z.2.1⟩ :
          {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}))
      ⟨fun z1 z2 h => Subtype.ext (congrArg (fun w : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} => (w : ℂ)) h), fun w => by
        have hstrip : 0 < (w : ℂ).re ∧ (w : ℂ).re < 1 := ⟨w.2.2.1, w.2.2.2⟩
        have hw0 : (w : ℂ) ≠ 0 := by intro h; rw [h] at hstrip; simp at hstrip
        have hw1 : (w : ℂ) ≠ 1 := by intro h; rw [h] at hstrip; norm_num at hstrip
        have hΓ : (w : ℂ).Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hstrip.1
        refine ⟨⟨w.1, ?_, hstrip.1⟩, Subtype.ext rfl⟩
        have hRZ : completedRiemannZeta (w : ℂ) = 0 := by
          rw [← completedZeta_eq_completedRiemannZeta hw0 hw1 hΓ]
          exact w.2.1
        exact (xi₀_eq_zero_iff w hw0 hw1).mpr hRZ⟩
  have hExpZ' : Summable (fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      Real.exp (-(σ ^ 2 * ((ρ : ℂ).im) ^ 2))) := by
    have hcomp : Summable ((fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        Real.exp (-(σ ^ 2 * ((ρ : ℂ).im) ^ 2))) ∘ Φ) := by
      have hfun : ((fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
          Real.exp (-(σ ^ 2 * ((ρ : ℂ).im) ^ 2))) ∘ Φ)
          = (fun z : {z : ℂ // xi₀ z = 0 ∧ 0 < z.re} =>
              Real.exp (-(σ ^ 2 * ((z : ℂ).im) ^ 2))) := by
        funext z
        rfl
      rw [hfun]
      exact hExpZ
    exact Φ.summable_iff.mp hcomp
  -- comparison with the zero-test entry
  have hbound : ∀ ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
      ‖(gaussianZeroTest c σ (ρ : ℂ)).re‖ ≤
        (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) *
          max (Real.exp (c / 2)) (Real.exp (-(c / 2)))) *
          Real.exp (-(σ ^ 2 * ((ρ : ℂ).im) ^ 2)) := by
    intro ρ
    have h := gaussianZeroTest_norm_le_strip (c := c) (σ := σ) hσ
      (ρ := (ρ : ℂ)) ρ.2.2.1 ρ.2.2.2
    exact le_trans (Complex.abs_re_le_norm _) h
  exact Summable.of_norm_bounded (hExpZ'.mul_left _) hbound

end MissingBridge
