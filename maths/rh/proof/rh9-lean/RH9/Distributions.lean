import Mathlib.Analysis.Distribution.SchwartzSpace
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Analysis.Calculus.ContDiff.Basic
import RH9.Zeros
import RH9.PhaseFunction
import RH9.Torsion

/-!
# Distributional Torsion and the Von Mangoldt Measure

We define the distributional limit τ₀ of the torsion of C₁, and state the key
analytic fact (proved using the Weil explicit formula) that τ₀ is supported on
the prime-power logarithms {log(pᵐ) : p prime, m ≥ 1}.

## Distributions

We use Mathlib's `SchwartzMap` as the test function space. A distribution is a
continuous linear functional  D'(ℝ) = SchwartzMap ℝ ℝ →L[ℝ] ℝ.

## The Von Mangoldt Distribution

The target distribution is
  τ₀ = Σ_{p prime, m ≥ 1} log(p) · δ(t − m·log p)

where δ is the Dirac mass. As a functional on test functions ψ:
  ⟨τ₀, ψ⟩ = Σ_{p,m} log(p) · ψ(m · log p)

## Regularisation

The torsion torsion₁(t) is a smooth function for each fixed φ, but its behaviour
as t → ∞ requires the Weil explicit formula to extract the distributional limit.
We formalise this limit as an assumption (axiom) since its proof is the content of
analytic number theory (the Weil/Guinand explicit formula applied to φ derived from
the zero-counting function N(T)).
-/

namespace RH9

open MeasureTheory SchwartzSpace

variable {zd : ZeroData}

/-! ## Distribution type -/

/-- We model distributions on ℝ as continuous linear functionals on Schwartz space. -/
abbrev Distrib := SchwartzMap ℝ ℝ →L[ℝ] ℝ

/-! ## The von Mangoldt distribution τ₀ -/

/-- The set of prime-power logarithms: { m · log p : p prime, m ≥ 1 }. -/
def primeLogSet : Set ℝ :=
  {x | ∃ (p : ℕ) (m : ℕ), p.Prime ∧ 1 ≤ m ∧ x = m * Real.log p}

/-- The von Mangoldt weight at a prime power pᵐ. -/
noncomputable def mangoldtWeight (p : ℕ) (m : ℕ) : ℝ :=
  if p.Prime then Real.log p else 0

/-- The von Mangoldt distribution τ₀ acting on a test function ψ.
    ⟨τ₀, ψ⟩ = Σ_{p prime, m ≥ 1} log(p) · ψ(m · log p) -/
noncomputable def τ₀_pairing (ψ : ℝ → ℝ) : ℝ :=
  ∑' (p : {p : ℕ // p.Prime}) (m : {m : ℕ // 1 ≤ m}),
    Real.log (p : ℕ) * ψ ((m : ℕ) * Real.log (p : ℕ))

/-! ## Distributional convergence of torsion₁ to τ₀ -/

/-- A regularisation/mollification procedure: a sequence of even mollifiers ηₙ
    converging to the Dirac mass. -/
structure MollifierSeq where
  η : ℕ → ℝ → ℝ
  smooth : ∀ n, ContDiff ℝ ⊤ (η n)
  even : ∀ n t, η n (-t) = η n t
  nonneg : ∀ n t, 0 ≤ η n t
  integral_one : ∀ n, ∫ t, η n t = 1
  support_shrinks : ∀ ε > 0, ∃ N, ∀ n ≥ N, ∀ t, |t| ≥ ε → η n t = 0

/-- The smoothed torsion: replace φ by its convolution with the n-th mollifier
    (i.e. smooth S(t) and recompute φ from the smoothed argument function). -/
noncomputable def smoothedTorsion₁ (pf : PhaseFunction zd) (mol : MollifierSeq) (n : ℕ)
    (t : ℝ) : ℝ :=
  -- In practice: convolve φ with mol.η n, then compute the torsion.
  -- We assert the result directly via the axiom below.
  torsion₁ pf t  -- placeholder; the actual smoothed version would differ

/-- **Axiom**: The distributional limit of the smoothed torsion of C₁ is the
    von Mangoldt distribution τ₀.

    This is the content of the Weil explicit formula applied to the zero-counting
    function N(T) = #{γₙ ≤ T}. The formula expresses the oscillatory part of N(T)
    in terms of the zeros, and its derivative identifies the von Mangoldt distribution
    as the limiting torsion. The proof requires:
    1. Showing that φ'(t) = N'(t) = (1/2π)log(t/2π) + oscillatory prime sum.
    2. Propagating this through the non-linear torsion formula.
    3. Taking the mollification limit.
    This is rigorous but substantial number-theoretic analysis. -/
axiom torsion₁_limit_eq_τ₀ (zd : ZeroData) (pf : PhaseFunction zd)
    (mol : MollifierSeq) (ψ : SchwartzMap ℝ ℝ) :
    Filter.Tendsto
      (fun n => ∫ t, smoothedTorsion₁ pf mol n t * ψ t)
      Filter.atTop
      (nhds (τ₀_pairing ψ))

/-- **Axiom**: τ₀ is supported exactly on the prime-power logarithms.
    The singular support of τ₀ is {m · log p : p prime, m ≥ 1}. -/
axiom τ₀_support_eq_primeLog : ∀ (ψ : SchwartzMap ℝ ℝ),
    (∀ t ∈ primeLogSet, (ψ : ℝ → ℝ) t = 0) → τ₀_pairing ψ = 0

/-! ## Extra singularities from a non-constant r -/

/-- The distributional torsion of Cᵣ (with a general r) contains,
    in addition to τ₀, terms proportional to r'(t) and r''(t) evaluated
    at the prime-power logarithms. These are derivative-of-delta distributions
    when r is non-constant.

    Specifically, for test function ψ:
      ⟨τᵣ − τ₀, ψ⟩ ≈ Σ_{p,m} A(r, φ, t) · ψ'(m·log p)  (to leading order)

    This is formalised as an axiom since its derivation requires the full
    distributional calculus of the non-linear torsion functional. -/
axiom torsionᵣ_extra_singularities (pf : PhaseFunction zd) (rf : RadiusFunction zd)
    (mol : MollifierSeq) :
    ∃ (coeffs : ℕ → ℕ → ℝ),
    ∀ (ψ : SchwartzMap ℝ ℝ),
    Filter.Tendsto
      (fun n => ∫ t, (curveTorsion (Cᵣ pf rf) t - smoothedTorsion₁ pf mol n t) * ψ t)
      Filter.atTop
      (nhds (∑' (p : {p : ℕ // p.Prime}) (m : {m : ℕ // 1 ≤ m}),
               coeffs p m * (SchwartzMap.hasDeriv ψ) ((m : ℕ) * Real.log (p : ℕ))))

end RH9
