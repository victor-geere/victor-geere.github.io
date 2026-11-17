# Lean layer — digamma-contour-shift

## Imported (harvested)

`import DigammaEnclosure` from `intersection-form-zeta/lean` supplies:

* `IntersectionForm.digamma_expansion` — the Euler–Maclaurin expansion of
  `Complex.digamma` with an explicit remainder integral;
* `IntersectionForm.norm_remainder_five_le` — the remainder bound
  `‖R(w)‖ ≤ 1/(81 (Re w)^5)`.

## Proved here

* `digamma_expansion_harvested` (T1) — the expansion, re-exported;
* `digamma_remainder_le_harvested` (T2) — the remainder bound, re-exported;
* `digamma_sub_log_le` (T3) — the bounded error `‖ψ(w) − log w‖ ≤ 19` on
  `Re w ≥ 1/4`, built from T1/T2 by the triangle inequality and the crude
  numerical bounds at `‖w‖ ≥ 1/4`;
* `norm_log_le` (T4) and `archFactor_norm_le` (T5) — the logarithmic growth of
  the archimedean factor on horizontal segments:
  `‖archFactor(x+iT)‖ ≤ (1/2)(log π + log((T+2)/2) + π + 19)` for
  `1/4 ≤ x/2`, `x ≤ 2`, `T ≥ 2`;
* `gaussianTest` and `gaussianTest_norm_le` (T6) — the Gaussian test and its
  horizontal decay `‖H_c(x+iT)‖ ≤ 2πσ² e^{σ²·9/4 + |c|·3/2} e^{−σ²T²}` for
  `1/4 ≤ x ≤ 2`;
* `horizontal_segment_le` (T7) — the horizontal-segment integral bound
  `‖∫_{1/2}^{2} archFactor(x+iT)H(x+iT) dx‖ ≤ (3/2)·(log bound)·K·e^{−σ²T²}`;
* `analyticAt_Gamma_of_re_pos`, `differentiableAt_digamma_of_re_pos`,
  `differentiableAt_archFactor`, `differentiable_gaussianTest` and
  `differentiableOn_rect` (T8–T10) — analyticity of `Γ` and differentiability
  of `digamma`, `archFactor` and the product on the rectangle;
* `differentiableOn_of_re_pos` (T12) and `rectangle_identity` (T11) — the
  Cauchy boundary identity for `archFactor·H_c` on `[1/2,2] × [−T,T]`, the
  starting point of the contour shift;
* `archFactor_norm_le_abs` (T13) and `horizontal_segment_le_abs` (T14) — the
  symmetric bounds in terms of `|y|`, covering both horizontal segments.

## The shift (proved)

* `tendsto_exp_neg_sq`, `tendsto_sq_mul_exp_neg_sq`,
  `tendsto_sq_add_one_mul_exp_neg_sq`, `tendsto_log_mul_exp_neg_sq` (T15–T18) —
  the Gaussian/logarithmic limits;
* `tendsto_horizontal_atTop`, `tendsto_horizontal_neg` (T19–T20) — both
  horizontal segments vanish;
* `archimedeanShift_gaussian` (T21) — **`ArchimedeanShiftLim H_c`**: the
  truncated vertical integrals at `Re s = 1/2` and `Re s = 2` have equal limits;
* `tendsto_line_two_of_shift` (T22) — the shift transfers any critical-line
  limit to `Re s = 2`, the form needed by the explicit-formula evaluation;
* `norm_log_le_global`, `archFactor_norm_le_global`, `integrable_line`,
  `tendsto_line_integral`, `tendsto_line_two_lim` (T23–T27) — the global strip
  bounds, integrability on the vertical line, and the **archimedean evaluation
  at `Re s = 2`**: the truncated `Re = 2` integral converges to the full
  critical-line integral;
* `omega`, `psiIm`, `densityTerm`, `imTerm` and `gaussianTest_half_add` (T28)
  — the critical-line objects and the trigonometric form of the test, the
  ingredients of the explicit archimedean value;
* `archFactor_half_add` and `archFactor_gaussianTest_re` (T29–T30) — the
  critical-line form of `archFactor` and the **pointwise real part of the
  integrand**: `Re[archFactor·H_c] = −πσ²e^{−σ²y²}(Ω(y)cos(cy) + Im ψ(y)sin(cy))`;
* `abs_omega_le`, `abs_psiIm_le`, `integrable_majorant` (T31–T33) — the
  bounds relating `Ω`, `Im ψ` to `archFactor`, and integrability of the
  Gaussian majorant, the inputs to the integral identity.

The proof combines the rectangle Cauchy identity (T11) with the vanishing
horizontal segments: on `Im s = T` the archimedean factor grows at most like
`log T` (T5) while the Gaussian test decays like `e^{−σ²T²}` (T6).

No `sorry`, `axiom` or `admit`.
