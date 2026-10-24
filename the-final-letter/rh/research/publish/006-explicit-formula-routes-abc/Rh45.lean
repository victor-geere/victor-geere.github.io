/-
  Rh45 — root module of the rh45 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh45.Explicit` — the algebraic layer of the round "the explicit formula's
    algebraic skeleton": the Cauchy and Gaussian kernels with their evenness,
    positivity, exact values and the `s ↔ 1 - s` symmetry of their shifts about
    `1/2`; the collapse of the pole pair to a single term for a transform even
    about `1/2` (`polePair_eq`); the two-sided exponential weight with its value
    `π/2` at the origin; the smoothed zero count with its monotonicity and
    non-negativity; the splitting of the prime side into its `±log` halves and
    the halving for even weights; the classical counting-function main term
    `(T/2π) log (T/(2πe)) + 7/8` with the rewrite that pins the constant `7/8`;
    and the elementary integral behind the Cauchy kernel, culminating in the
    Fourier pairing `∫_ℝ expWeight u · cos (t u) du = (π/2) · cauchyKernel t`.

  * `Rh45.Routes` — the certification logic of §6 of
    `../../eta-euler-acceleration.html`: Route A (sign change + positive
    derivative ⟹ unique simple zero, in both the exact and the enclosure form),
    Route B (the Turing reduction: certified on-line zeros plus a rigorous total
    count forcing equality), and Route C (the validated-truncation error assembly
    together with Mathlib's Chebyshev bound as the prime-tail input).

  * `Rh45.Archimedean` — the archimedean term of the explicit formula: the
    kernel `Ψ(t) = −log π + Re ψ(1/4 + i t/2)` with its continuity and
    measurability, the digamma recurrence and reflection formula on the line
    `Re z = 1/4`, the chain rule `Ψ^{(k)}(t) = (i/2)^k ψ^{(k)}(1/4 + i t/2)`
    behind the round's `2^{−k}` derivative budget, the Leibniz bound
    `|(φΨ)^{(4)}| ≤ M₀P₄ + 4M₁P₃ + 6M₂P₂ + 4M₃P₁ + M₄P₀`, and the composite
    Simpson assembly reaching `(b−a)h⁴/180 · Σ_k binom(4,k) M_k P_{4−k}`.

  * `Rh45.VonMangoldtSieve` — the counterexample behind the Route C sieve bug:
    `Λ` is not additive (`Λ 6 = 0` but `Λ 2 + Λ 3 = log 6 > 0`), so the linear
    sieve recurrence that computes completely additive functions cannot compute
    `Λ`.

  * `Rh45.RouteBAnalytic` — the analytic (symmetric) layer of Route B: the
    functional equation `ξ(1 − s) = ξ(s)` for `ξ(s) = ½ s (s−1) π^{−s/2} Γ(s/2) ζ(s)`,
    the reflection identities `logDeriv f (1 − s) = −logDeriv f s` and
    `logDeriv f (conj s) = conj (logDeriv f s)`, and the contour reduction
    `∮_{∂R} ξ′/ξ = I₃ − conj I₃ = 2i · Im I₃` for the three-segment path `I₃`
    over the right half of `[0,1] × [t₀,t₁]`, hence `Im(I₃) = π Z` from an
    argument-principle count `∮_{∂R} ξ′/ξ = 2πi Z`.
-/
import Rh45.Explicit
import Rh45.Archimedean
import Rh45.Routes
import Rh45.VonMangoldtSieve
import Rh45.RouteBAnalytic
