# Lean layer — archimedean-prime-evaluation

`Topic.lean` contains the elementary formal core and the named inputs.

## Proved

* `gaussianZeroTest_half_add` — the exact value of the Gaussian test on the
  critical line, `H_c(1/2+it) = 2πσ² e^{−σ²t²} e^{−ict}`.
* `exp_neg_mul_I` — `e^{−ict} = cos(ct) − i sin(ct)`.
* `gaussianZeroTest_half_add_re` / `_im` — the real and imaginary parts,
  `2πσ²e^{−σ²t²}cos(ct)` and `−2πσ²e^{−σ²t²}sin(ct)`.
* `verticalLimitIdentification_of_evaluations` — the two evaluation equalities
  imply the vertical-limit identification of the Gaussian explicit formula.
* `arch_integrand_identity` — the pointwise splitting of the critical-line
  archimedean integrand into the `Ω·cos` piece and the `Im ψ·sin` correction.
* `archIntegral_eq` — the **critical-line** archimedean evaluation: conditional
  on integrability of the two pieces, the integral is
  `−2π·densityTerm − 2πσ²∫ e^{−σ²t²}sin(ct)Im ψ`.
* `gaussianZeroTest_two_add` — the Gaussian test at `Re s = 2` in Gaussian form.
* `termwiseIntegral_eq` — **the Gaussian Fourier transform**, proved: the
  closed form of `∫ e^{−iy log n}H_c(2+iy)dy`.
* `gaussianFourierTransform` — the named `GaussianFourierTransform` proposition,
  discharged for `σ > 0`.
* `primePartialIntegral_eq` — the **finite termwise exchange**: for a finite
  prime partial sum, the vertical integral splits exactly into the sum of the
  term integrals (T11).
* `integrable_term` / `tendsto_term_integral` / `tendsto_primePartial_integral`
  — term integrability, the term limit, and the partial-sum limit (T12–T14).
* `termwiseIntegral_norm_le` — uniform bound on `termwiseIntegral` (T15).
* `summable_primeSeries` — summability of the prime series at `Re s = 2` (T16).
* `primeTermwiseInterchange` — **the termwise interchange, proved** (T17):
  the partial sums converge to the sum of the termwise integrals.
* `UniformTailBound` and `primeRightLimit_of_uniformTail` — the uniform tail
  bound (named) and the limit pass (T18) giving `PrimeRightLimit` at the series
  value.
* `summable_vonMangoldt_div_sq`, `tendsto_tail_summable`,
  `tendsto_tail_vonMangoldt_div_sq` — the von Mangoldt series at `Re s = 2`, the
  general tail-to-zero lemma, and the von Mangoldt tail limit (T19–T21).
* `primeTermwiseInterchange_unique` — uniqueness of the series value (T22).
* `LSeries_vonMangoldt_eq` — **the von Mangoldt L-series at `Re s = 2`,
  explicitly** as `Σ' Λ(n)/n²·e^{−iy log n}` (T23).  This is the pointwise
  identity underlying `UniformTailBound`.

## Named, not proved

* `ArchimedeanEvaluation c σ A A′` — `A.re + A′.re = −2π·densityTerm c σ`.
* `PrimeEvaluation c σ P P′` — `P.re + P′.re = −2π·primeTermSym c σ`.

The archimedean evaluation needs the contour shift from `Re s = 2` to `Re s = 1/2`
together with the digamma asymptotics; the prime evaluation needs termwise
integration of the von Mangoldt Dirichlet series against the Gaussian (Perron /
Fourier). Neither computation is present in this repository or in Mathlib. The
Python layer verifies the critical-line archimedean identity numerically; the
off-line contour shift is exactly the missing step.

No `sorry`, `axiom` or `admit` is used.

## O2 — the precise statements

The prime-side evaluation is now stated exactly in `Topic.lean`, as definitions
(no proof is claimed):

* `primeRightIntegral c σ T` — the right-side vertical integral
  `∫_{-T}^{T} LSeries(Λ, 2+iy)·H_c(2+iy) dy`;
* `PrimeRightLimit c σ P` — its limit `P` as `T → ∞` (the `PrimeR` of the
  assembled formula);
* `termwiseIntegral c σ n` — the `n`-th Gaussian–Fourier term
  `∫ e^{−iy log n}·H_c(2+iy) dy`;
* `GaussianFourierTransform c σ` — the closed form of that term,
  `2πσ² e^{9σ²/4−3c/2}·(π/σ²)^{1/2}·e^{−(3σ²−c−log n)²/(4σ²)}` — **proved**
  (T9/T10);
* `PrimeTermwiseInterchange c σ P` — the partial sums
  `Σ_{n<N} Λ(n)/n²·termwiseIntegral c σ n` converge to `P` — **proved** (T17);
* `PrimeSeriesEvaluation c σ P` — the conjunction of the three.

These are the exact missing statements: the Gaussian Fourier transform (an
elementary Gaussian integral with a linear phase, not in Mathlib), the termwise
interchange (uniform convergence of the Dirichlet series on `Re s = 2`), and the
identification of the resulting series with `−2π·primeTermSym`.  None is proved.
