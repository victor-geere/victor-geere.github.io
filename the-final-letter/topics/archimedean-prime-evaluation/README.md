# Archimedean and prime evaluation

**Status:** the elementary formal core and the two named inputs. The evaluations
themselves are **open**; nothing here proves the Riemann hypothesis.

This topic isolates the two analytic computations that stand between the
assembled Gaussian explicit formula (see [`missing-bridge`](../missing-bridge/README.md),
T134) and an unconditional statement:

1. the **archimedean evaluation** — the vertical integral of
   `log π − ψ(1/4+it/2)` against the Gaussian test, identified with
   `−2π·densityTerm`;
2. the **prime evaluation** — the vertical integral of the von Mangoldt
   Dirichlet series against the Gaussian test, identified with
   `−2π·primeTermSym`.  Its precise Lean statements are
   `primeRightIntegral`, `PrimeRightLimit`, `termwiseIntegral`,
   `GaussianFourierTransform`, `PrimeTermwiseInterchange` and
   `PrimeSeriesEvaluation` (all in `lean/Topic.lean`, all unproved).

## Objects

* `gaussianZeroTest c σ s = 2πσ² exp(σ²(s−1/2)²) exp(−c(s−1/2))` — the Gaussian
  test of the explicit-formula programme;
* `Ω(t) = Re ψ(1/4+it/2) − log π` — the archimedean kernel;
* `densityTerm c σ = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`;
* `primeTerm c σ = −2 Σ_n Λ(n)/√n · √π σ exp(−(log n − c)²/(4σ²))`, and its
  symmetrisation `primeTermSym c σ = (primeTerm c σ + primeTerm (−c) σ)/2`;
* `ArchimedeanEvaluation`, `PrimeEvaluation`, `VerticalLimitIdentification`.

## Theorem ledger

| Kind | Item | Statement | Lean |
|---|---|---|---|
| Theorem | T1 | The two evaluations imply the vertical-limit identification. | `verticalLimitIdentification_of_evaluations` |
| Theorem | T2 | The Gaussian test on the critical line. | `gaussianZeroTest_half_add` |
| Theorem | T3 | `e^{−ict} = cos(ct) − i sin(ct)`. | `exp_neg_mul_I` |
| Theorem | T4 | Real part of the critical-line test. | `gaussianZeroTest_half_add_re` |
| Theorem | T5 | Imaginary part of the critical-line test. | `gaussianZeroTest_half_add_im` |
| Theorem | T6 | **Pointwise archimedean integrand identity** on the critical line. | `arch_integrand_identity` |
| Theorem | T7 | **Critical-line archimedean evaluation**, conditional on integrability of the two pieces. | `archIntegral_eq` |
| Theorem | T8 | **Gaussian test at `Re s = 2`** in Gaussian form. | `gaussianZeroTest_two_add` |
| Theorem | T9 | **Gaussian Fourier transform**: the closed form of `∫ e^{−iy log n}H_c(2+iy)dy`. | `termwiseIntegral_eq` |
| Theorem | T10 | `GaussianFourierTransform c σ` holds for `σ > 0`. | `gaussianFourierTransform` |
| Theorem | T11 | **Finite termwise exchange**: the vertical integral of a finite prime partial sum splits into the sum of the term integrals. | `primePartialIntegral_eq` |
| Theorem | T12 | Term integrability on `Re s = 2` (Gaussian decay). | `integrable_term` |
| Theorem | T13 | Term limit: truncated term integral tends to `termwiseIntegral`. | `tendsto_term_integral` |
| Theorem | T14 | Partial-sum limit: truncated partial-sum integral tends to the finite sum. | `tendsto_primePartial_integral` |
| Theorem | T15 | Uniform bound on `termwiseIntegral`. | `termwiseIntegral_norm_le` |
| Theorem | T16 | **Summability of the prime series** at `Re s = 2`. | `summable_primeSeries` |
| Theorem | T17 | **The termwise interchange, proved.** | `primeTermwiseInterchange` |
| Theorem | T18 | **The limit pass**: the uniform tail bound plus the partial-sum limits gives `PrimeRightLimit` at the series value. | `primeRightLimit_of_uniformTail` |
| Theorem | T19 | Continuity of `y ↦ LSeries(Λ, 2+iy)` on the line. | `continuous_LSeries_line` |
| Theorem | T19 | Summability of the von Mangoldt series at `Re s = 2`. | `summable_vonMangoldt_div_sq` |
| Theorem | T20 | The tail of a summable series tends to zero. | `tendsto_tail_summable` |
| Theorem | T21 | The von Mangoldt tail tends to zero at `Re s = 2`. | `tendsto_tail_vonMangoldt_div_sq` |
| Theorem | T22 | The series value of `PrimeTermwiseInterchange` is unique. | `primeTermwiseInterchange_unique` |
| Theorem | T23 | **The von Mangoldt L-series at `Re s = 2`, explicitly**: `LSeries(Λ, 2+iy) = Σ' Λ(n)/n²·e^{−iy log n}`. | `LSeries_vonMangoldt_eq` |
| Computation | C1 | `Ω(0) = Re ψ(1/4) − log π`. | `test_omega_at_zero_matches_digamma` |
| Computation | C2 | `densityTerm 0 (1/20)` positive; negative at `c = 1/5`. | `test_density_term_zero_positive`, `test_density_term_negative_at_one_fifth` |
| Computation | C3 | Real/imaginary parts of the critical-line test. | `test_critical_line_parts_match_complex_value` |
| Computation | C4 | Closed form of the critical-line archimedean integral, residual `< 1e−10`. | `test_arch_identity_residual_small` |
| Computation | C5 | `primeTermSym 1 (1/20) ≈ −0.02126`. | `test_prime_term_sym_negative_at_one` |
| Source claim | S1 | The vertical limits of the assembled Gaussian explicit formula are `ArchR, PrimeR, ArchL, PrimeL` (missing-bridge T134). | — |
| Theorem | T25 | **O1 closed:** `ArchimedeanEvaluation c σ A A′` proved for `A` the critical-line integral for `c` and `A′` for `−c`. | `archimedeanEvaluation_proved` |
| Theorem | T42 | **O2 convergence closed:** `PrimeRightLimit` at the termwise sum, with `UniformTailBound` proved. The remaining O2 item is the arithmetic identification with `−2π·primeTermSym`. | `primeRightLimit` |
| Open | O3 | **The prime side at the critical line.** `primeRightLimit` produces the value at `Re s = 2`, `Σ' Λ(n)/n²·termwiseIntegral`. The explicit formula needs the critical-line prime term `Σ' Λ(n)/√n·(Gaussian at log n)`, i.e. `ζ'/ζ` on `Re s = 1/2`, which needs the analytic continuation and functional equation — not the Dirichlet series in its half-plane of convergence. The two values genuinely differ: `primeLimitRe2 / (−2π·primeTermSym) ≈ 0.1308` at `c = σ = 1` (see `prime_gap_ratio` in `python/programme.py`). | — |

## The Python layer

`python/programme.py` computes `omega`, `density_term`, `arch_im_term`,
`critical_line_re/im`, `arch_critical_line_real`, `arch_identity_residual`,
`prime_term` and `prime_term_sym` with `mpmath`. The identity checked in C4 is

`Re ∫ (log π − ψ(1/4+it/2)) H_c(1/2+it) dt
  = −2π·densityTerm − 2π·σ²∫ e^{−σ²t²} sin(ct) Im ψ(1/4+it/2) dt`,

whose residual is `~10⁻¹⁷` at the tested points. The second term is the
`Im ψ` correction; the identification with `−2π·densityTerm` alone requires it
to cancel in the symmetrised combination — that is part of O1.

In Lean, T6 gives this decomposition pointwise and T7 integrates it on the
critical line, conditional on integrability of `e^{−σ²t²}cos(ct)Ω(t)` and
`e^{−σ²t²}sin(ct)Im ψ(1/4+it/2)`.  The contour shift from `Re s = 2` (the actual
limit values of O1) is **not** formalised.

Run:

```
python3 -m pytest the-final-letter/topics/archimedean-prime-evaluation/tests -q
the-final-letter/topics/archimedean-prime-evaluation/lean/check.sh
```

## Dependency note (I4)

The pole/archimedean bookkeeping used by the explicit formula consumes the
functional equation.  With [`zeta-from-theta`](../zeta-from-theta/README.md)
that consumption no longer has to route through the Hurwitz development:
`ZetaFromTheta.zetaTheta_one_sub` (D4) proves the functional equation for the
theta-side object, and `ZetaFromTheta.riemannZeta_one_sub_from_theta` (M6)
assembles the `riemannZeta` statement with a constant-level provenance audit
([`AUDIT.md`](../zeta-from-theta/lean/AUDIT.md)) showing no `*_one_sub` lemma of
the zeta/Hurwitz development in its cone.  M6 retains the hypothesis
`Γℝ(1−s) ≠ 0`, so it is a second auditable route, not yet an unconditional
replacement.  No evaluation status in this topic changes.

## What is not formalised

The contour shift `Re s = 2 → Re s = 1/2` (with the digamma asymptotic
expansion and the functional equation) and the termwise Dirichlet-series /
Fourier evaluation of the prime side. These are substantive analytic
developments absent from this repository and from Mathlib; the Lean file
therefore contains only the elementary core and the named propositions.

## Links

* [Topics index](../README.md)
* [Missing bridge](../missing-bridge/README.md)
* [Zeta from theta — functional-equation source](../zeta-from-theta/README.md)
* [Scraps](../../scraps.html)
