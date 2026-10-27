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

  * `Rh45.SimpsonPanel` — the single-panel Simpson estimate, *proved*: the
    composite rule `simpsonPanel`/`simpsonSum`, the corrected
    `SimpsonPanelEstimate` (with the missing `C⁴` hypothesis, and for `0 ≤ H`),
    its proof `simpsonPanelEstimate`, and the exactness of Simpson's rule on
    cubics and the Peano-kernel decomposition behind the sharp constant
    `(2H)⁵/2880`.

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

  * `Rh45.ArgumentPrinciple` — the rectangle argument principle missing from
    Mathlib: the winding number `∮_{∂R} (s − a)⁻¹ = 2πi` for `a` strictly inside
    `[0,1] × [t₀,t₁]` and `= 0` for `a` outside the closed rectangle, and the
    factorised argument principle
    `f = C · ∏_{z∈Z} (s − z)^(m z) ⟹ ∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`, together
    with `routeB_reduction_factorized`, which discharges the `hAP` hypothesis of
    `routeB_reduction` in that factorised case (superseded, see `Rh45.RouteBGeneral`).

  * `Rh45.Weierstrass` — the missing "divide out the zeros" step: an analytic
    function on the closed rectangle whose zeros there are exactly `Z` with
    orders `m` factors as `f = g · ∏_{z∈Z} (s − z)^(m z)` with `g` analytic and
    nowhere zero on the rectangle (`exists_factorization`); consequently
    `∮_{∂R} g′/g = 0` for zero-free analytic `g`
    (`rectBoundary_logDeriv_eq_zero`) and the **general** argument principle
    `argument_principle_general`, with the zero set and multiplicities defined
    rather than assumed.

  * `Rh45.RouteBGeneral` — Route B with the zero count derived rather than
    assumed: `routeB_reduction_general` gives
    `(rightPath (logDeriv f) t₀ t₁).im = π · ∑_{z∈Z} m z` from analyticity of `f`,
    its zero data on the rectangle, and `f(1−s) = f(s)`, `f(conj s) = conj (f s)`,
    with no factorisation hypothesis and no constant `C`; this supersedes
    `routeB_reduction_factorized`.

  * `Rh45.XiEntire` — the two concrete ingredients for instantiating Route B at `ξ`,
    filling the "Not formalised here" gap of `README.md`: the conjugation symmetry
    `completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s)` (and
    `Gammaℝ_conj`), and the entire normalisation `xi₀ s = ½ s(s−1) Λ₀(s) + ½` with
    `xi = xi₀` away from `0, 1`, `xi₀(1−s) = xi₀ s`, `xi₀(conj s) = conj (xi₀ s)`,
    `Differentiable ℂ xi₀`, and `logDeriv xi = logDeriv xi₀` off `{0,1}`.  The
    instantiation `xi_routeB_general` gives
    `(rightPath (logDeriv ξ) t₀ t₁).im = π · ∑_{z∈Z} m z`.

  * `Rh45.GammaProduct` — the locally uniform Euler product limit: `GammaSeq · n` is
    analytic on the right half-plane with the uniform integral bound
    `‖GammaSeq s n‖ ≤ Real.Gamma s.re`, it converges *locally uniformly* to `Γ` there
    (Cauchy's integral formula on a circle strictly containing the disc, plus dominated
    convergence of the resulting contour integral), Weierstrass' theorem gives locally
    uniform convergence of every derivative `deriv^[k]`, and a direct uniform quotient
    estimate gives the same for `logDeriv`.  This is the analytic input for the
    polygamma series; the explicit formula for `deriv^[k] (logDeriv (GammaSeq · n))`
    is the follow-up `Rh45/PolygammaSeries.lean`.

  * `Rh45.PolygammaSeries` — the second half: the explicit formula
    `deriv^[k] (logDeriv (GammaSeq · n)) s = (-1)^{k+1} k! ∑_{j≤n} (s+j)^{-k-1}`
    (`k ≥ 1`, hypothesis only `∀ j ≤ n, s + j ≠ 0`), the Gauss/Hurwitz series
    `HasSum (fun j => (s+j)^{-k-1}) (((-1)^{k+1} k!)⁻¹ ψ^{(k)}(s))` obtained by
    iterated Weierstrass differentiation and `n → ∞`, absolute summability and the
    norm bound `‖ψ^{(k)}(s)‖ ≤ k! ∑_j (re s + j)^{-k-1}`, and consequently the
    *unconditional* archimedean budget `‖Ψ^{(k)}(t)‖ ≤ psiSeriesBound k` for `k ≥ 1`
    (`Rh45.archimedean_deriv_bound`).  The `k = 0` series diverges, so
    `Rh45.psiSeriesBound_zero` records `psiSeriesBound 0 = 0`.
-/
import Rh45.Explicit
import Rh45.SimpsonPanel
import Rh45.Archimedean
import Rh45.Routes
import Rh45.VonMangoldtSieve
import Rh45.RouteBAnalytic
import Rh45.ArgumentPrinciple
import Rh45.Weierstrass
import Rh45.RouteBGeneral
import Rh45.XiEntire
import Rh45.GammaProduct
import Rh45.PolygammaSeries
