# Digamma asymptotics and the archimedean contour shift

**Status:** the digamma expansion, the asymptotic bounds, the archimedean
contour shift and the archimedean evaluation `L_c.re + L_{−c}.re = −2π·densityTerm`
are proved. Nothing here proves the Riemann hypothesis.

This is the analysis project identified as the blocker for the explicit formula
in [`archimedean-prime-evaluation`](../archimedean-prime-evaluation/README.md):
the archimedean evaluation needs the vertical integral moved from `Re s = 2` to
`Re s = 1/2`.

## Provenance

The key analytic input already exists in this repository, in
[`intersection-form-zeta/lean/DigammaEnclosure.lean`](../intersection-form-zeta/lean/DigammaEnclosure.lean):

* the Euler–Maclaurin expansion
  `ψ(w) = log w − 1/(2w) − 1/(12w²) + 1/(120w⁴) − R(w)`;
* the remainder bound `‖R(w)‖ ≤ 1/(81 (Re w)^5)`.

These are harvested here as T1/T2 and are the foundation of the shift.

**Functional-equation source (I3).**  The shift statement itself is
functional-equation-free: `lean/Shift.lean` imports only `DigammaEnclosure` and
`Mathlib`, and no `*_one_sub` lemma is used.  Any later archimedean evaluation
that does need the functional equation can now cite
`ZetaFromTheta.zetaTheta_one_sub` from
[`zeta-from-theta`](../zeta-from-theta/README.md) (D4), whose constant-level
provenance audit contains no `*_one_sub` of the zeta/Hurwitz development, rather
than routing through the Hurwitz zeta.  Nothing in the present ledger changes.

## Objects

* `archFactor s = (1/2) log π − (1/2) ψ(s/2)` — the archimedean factor;
* `ArchimedeanShift H` — the shift identity for a test function `H`.
* `digamma_sub_log_le` — the bounded digamma error (T3), the key estimate that
  keeps `archFactor` from growing faster than logarithmically on horizontal
  segments;
* `norm_log_le` and `archFactor_norm_le` (T4/T5) — the resulting logarithmic
  bound `‖archFactor(x+iT)‖ ≤ (1/2)(log π + log((T+2)/2) + π + 19)`.

## Theorem ledger

| Kind | Item | Statement | Lean |
|---|---|---|---|
| Theorem | T1 | Harvested digamma expansion. | `digamma_expansion_harvested` |
| Theorem | T2 | Harvested remainder bound. | `digamma_remainder_le_harvested` |
| Theorem | T3 | **Bounded digamma error** in the strip: `‖ψ(w) − log w‖ ≤ 19` for `Re w ≥ 1/4`. | `digamma_sub_log_le` |
| Theorem | T4 | `‖log w‖ ≤ log‖w‖ + π` for `‖w‖ ≥ 1`. | `norm_log_le` |
| Theorem | T5 | **Logarithmic growth of `archFactor`** on horizontal segments. | `archFactor_norm_le` |
| Theorem | T6 | **Horizontal Gaussian decay** of the test on the strip. | `gaussianTest_norm_le` |
| Theorem | T7 | **Horizontal-segment integral bound**: the segment integral is `O(log T · e^{−σ²T²})`. | `horizontal_segment_le` |
| Theorem | T8 | `Γ` analytic on the right half-plane. | `analyticAt_Gamma_of_re_pos` |
| Theorem | T9 | Digamma differentiable on the right half-plane. | `differentiableAt_digamma_of_re_pos` |
| Theorem | T10 | `archFactor·H` differentiable on the rectangle. | `differentiableOn_rect` |
| Theorem | T11 | **Rectangle Cauchy identity** for `archFactor·H_c` on `[1/2,2] × [−T,T]`. | `rectangle_identity` |
| Theorem | T12 | `archFactor·H` differentiable on any set in the right half-plane. | `differentiableOn_of_re_pos` |
| Theorem | T13 | **Symmetric `archFactor` bound** in terms of `|y|`. | `archFactor_norm_le_abs` |
| Theorem | T14 | **Symmetric horizontal-segment bound** (both signs of `y`). | `horizontal_segment_le_abs` |
| Theorem | T15 | `e^{−σ²T²} → 0`. | `tendsto_exp_neg_sq` |
| Theorem | T16 | `T²e^{−σ²T²} → 0`. | `tendsto_sq_mul_exp_neg_sq` |
| Theorem | T17 | `(T²+1)e^{−σ²T²} → 0`. | `tendsto_sq_add_one_mul_exp_neg_sq` |
| Theorem | T18 | `log(T+2)e^{−σ²T²} → 0`. | `tendsto_log_mul_exp_neg_sq` |
| Theorem | T19 | **Horizontal integral → 0** as `Im s → +∞`. | `tendsto_horizontal_atTop` |
| Theorem | T20 | **Horizontal integral → 0** as `Im s → −∞`. | `tendsto_horizontal_neg` |
| Theorem | T21 | **The archimedean contour shift for the Gaussian test.** | `archimedeanShift_gaussian` |
| Theorem | T22 | **The shift transfers a critical-line limit to `Re s = 2`.** | `tendsto_line_two_of_shift` |
| Theorem | T23 | **Global `‖log w‖` bound** in the strip. | `norm_log_le_global` |
| Theorem | T24 | **Global archimedean bound** (no restriction on `|y|`). | `archFactor_norm_le_global` |
| Theorem | T25 | **Integrability of `archFactor·H_c` on the vertical line.** | `integrable_line` |
| Theorem | T26 | Truncated line integral converges to the full integral. | `tendsto_line_integral` |
| Theorem | T27 | **The archimedean evaluation at `Re s = 2`**: the truncated `Re=2` integral converges to the full critical-line integral. | `tendsto_line_two_lim` |
| Theorem | T28 | **Critical-line Gaussian test** in trigonometric form, with the objects `omega`, `psiIm`, `densityTerm`, `imTerm`. | `gaussianTest_half_add` |
| Theorem | T29 | `archFactor` on the critical line in real/imaginary form. | `archFactor_half_add` |
| Theorem | T30 | **Pointwise real part of the critical-line integrand.** | `archFactor_gaussianTest_re` |
| Theorem | T31 | `|Ω(y)|` bounded by twice the archimedean factor. | `abs_omega_le` |
| Theorem | T32 | `|Im ψ(1/4+iy/2)|` bounded by twice the archimedean factor. | `abs_psiIm_le` |
| Theorem | T33 | The Gaussian majorant `C(1+|y|)e^{−σ²y²}` is integrable. | `integrable_majorant` |
| Theorem | T34 | Continuity of `omega` and `psiIm`. | `continuous_omega`, `continuous_psiIm` |
| Theorem | T35 | Integrability of `e^{−σ²y²}cos(cy)Ω(y)` and `e^{−σ²y²}sin(cy)Im ψ(y)`. | `integrable_omega_cos`, `integrable_psiIm_sin` |
| Theorem | T36 | **Critical-line integral, real part:** `L.re = −π(densityTerm + imTerm)`. | `integral_re_eq` |
| Theorem | T37 | **The archimedean value summed over ±c:** `L_c.re + L_{−c}.re = −2π·densityTerm` — `ArchimedeanEvaluation`. | `archimedeanValue_sum` |
| Computation | C1 | Truncation close to `ψ` at `2+3i`. | `test_expansion_close_to_digamma` |
| Computation | C2 | Remainder bound holds numerically. | `test_remainder_bound_holds` |
| Computation | C3 | Remainder decays with `|Im w|`. | `test_remainder_decays` |
| Theorem | T21 | **`ArchimedeanShiftLim H_c` proved** (the shift from `Re s = 2` to `Re s = 1/2`). | `archimedeanShift_gaussian` |

## The Python layer

`python/programme.py` evaluates the truncation, the remainder, the harvested
bound and their ratio with `mpmath`. Run:

```
python3 -m pytest the-final-letter/topics/digamma-contour-shift/tests -q
the-final-letter/topics/digamma-contour-shift/lean/check.sh
```

## The missing analysis

The shift needs the rectangle identity for `archFactor(s)·H(s)` and the
vanishing of the horizontal segments. The digamma expansion gives at most
logarithmic growth of `archFactor` on `|Im s| = T` (the remainder is bounded on
the finite strip), while `H_c` decays like `e^{−σ²T²}`; the product tends to
zero. This is the next formalisation target (O1).

## Links

* [Topics index](../README.md)
* [Archimedean and prime evaluation](../archimedean-prime-evaluation/README.md)
* [Intersection form zeta](../intersection-form-zeta/README.md)
* [Zeta from theta — functional-equation source](../zeta-from-theta/README.md)
* [Scraps](../../scraps.html)
