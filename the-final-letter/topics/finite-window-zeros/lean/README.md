# Lean core — finite-window zeros

## Build

```bash
cd the-final-letter/topics/finite-window-zeros
./lean/check.sh
```

`check.sh` compiles the 18-file core (`Topic.lean` … `EMOnLine.lean`)
against the shared Mathlib at `~/lean/mathlib4`. `Cert.lean` imports the
verified complex-power atom from the sibling `partial-sum-plus-tail` topic via
`LEAN_EXTRA_PATH`; the rest of the dossier is self-contained. No file contains
`sorry`, `axiom` or `admit`.

## What is formalised

| Declaration | Content |
|---|---|
| `altPartial` | The finite alternating sum `Σ_{n<N} (-1)^n/(n+1)^s`. |
| `pairPartial`, `pairTerm` | The grouped odd/even partial sum and its `m`-th term. |
| `altPartial_two_mul` | **Finite regrouping.** The alternating sum over `2M` terms is the grouped sum over `M` pairs. |
| `hasDerivAt_cpow_ofReal` | The derivative of `x ↦ x^{-s}` along the positive real axis is `-s x^{-s-1}`. |
| `norm_pairTerm_le` | **Pair estimate.** For `Re s ≥ σ > 0`, `‖(2m+1)^{-s} - (2m+2)^{-s}‖ ≤ ‖s‖(2m+1)^{-σ-1}`. |
| `summable_pairMajorant`, `summable_pairMajorant'` | The comparison sequence `(2m+1)^{-p}` is summable for `p > 1`. |
| `summable_pairTerm` | The grouped eta series is summable for `Re s > 0`. |
| `etaGrouped` | The grouped eta series `∑' m, pairTerm s m`. |
| `stripBox`, `differentiableOn_etaGrouped`, `differentiableAt_etaGrouped` | `etaGrouped` is differentiable on bounded rectangles in `Re s > 0`, hence at every `s` with `0 < Re s`. |
| `etaGrouped_eq_one_sub_two_cpow_mul_zeta` | The eta identity `(1-2^{1-s})ζ(s)=η(s)` for `Re s > 1`. |
| `..._of_im_pos`, `..._of_im_neg` | The identity on the upper and lower open quadrants, by the identity theorem. |
| `..._of_re_pos` | The identity for every `0 < Re s`, `s ≠ 1`, by continuity on the real axis. |
| `zeta_ne_zero_of_eta_ne_zero`, `zeta_ne_zero_of_eta_mem` | Transfer: a nonzero `etaGrouped` value (or an enclosing set excluding zero) certifies `ζ(s) ≠ 0`. |
| `tsum_pairMajorant_add_le` | The tail comparison for `(2(m+M)+1)^{-p}` (`p > 1`). |
| `norm_tsum_pairTerm_tail_le` | Norm bound for the grouped eta tail after `M` pairs. |
| `Cert.lean` | The 100-pair certificate: `CpowPair`, `pairBox`, `sumBox`, `params`, `containsZero`, and `zeta_half_plus_five_ne_zero` (`ζ(1/2+5i) ≠ 0`). |
| `Seg.lean` | The rectangle certificate for `t ∈ [5, 5.000003]`: `Sseg` and `zeta_ne_zero_segment`. |
| `Krawczyk.lean` | The complex mean value inequality `norm_sub_le_of_deriv_bound` and the Newton-map Lipschitz bound `norm_newton_sub_le`, `newton_mapsTo_closedBall`, and the Krawczyk theorem `exists_zero_of_krawczyk`. |
| `EMOnLine.lean` | T487–T494: `zero_unique_of_contraction` and `zeta_zero_unique` (the Krawczyk inequality is a contraction, so the zero in the ball is unique); `zeta_zero_one_sub_conj`, `mem_ball_one_sub_conj`, `im_ne_zero_of_ball` (the reflection `s ↦ 1 − conj s` preserves zeros and the ball); and **`zeta_zero_14_on_line_simple`**: `∃ z ∈ closedBall s14 (1/5), ζ z = 0 ∧ z.re = 1/2 ∧ ζ′(z) ≠ 0`, with `zeta_zero_14_on_line` and `zeta_zero_14_simple` as corollaries. No `partial-sum-plus-tail` evaluator is used. |
| `EulerMaclaurin.lean` | `integral_bernoulli`, `integral_bernoulli_one`, `periodicBernoulli`, `integral_periodicBernoulli`, `continuousAt_periodicBernoulli_of_not_int`, and `continuousAt_periodicBernoulli_int`; first bricks toward a Lean Euler–Maclaurin remainder, including one-step summation by parts (`sum_by_parts_zero_one`) the base identity (`integral_B1_mul_deriv`), its interval translation (`integral_B1_mul_deriv_int`), finite Euler–Maclaurin summation (`sum_range_euler_maclaurin`), the two-step (`sum_by_parts_two_step`) three-step (`sum_by_parts_three_step`) Bernoulli expansions, the general induction (`integral_eq_emExpansion`), the shifted-power derivative (`hasDerivAt_one_add_rpow`), the complex power derivative (`hasDerivAt_cpow_neg`), complex one-step summation by parts (`sum_by_parts_zero_one_complex`), the complex general expansion (`integral_eq_emExpansionC`), the `emG` derivative sequence (`hasDerivAt_emG`), its complex EM instantiation (`integral_emG_eq_emExpansionC`), the `(x+1)^{-s}` corollary (`integral_cpow_eq_emExpansionC`), complex translation lemmas, the complex base/interval identities (`integral_B1_mul_deriv_complex`, `integral_B1_mul_deriv_int_complex`), complex finite summation (`sum_range_euler_maclaurin_complex`), its `[0,∞)` version (`sum_range_euler_maclaurin_complex_nonneg`), the shifted-power specialisation (`sum_shifted_cpow_euler_maclaurin`), the norm formula (`norm_cpow_neg_ofReal`), pointwise (`norm_correction_integrand_le`), integral (`norm_integral_correction_le`), summed (`norm_sum_correction_le`, `sum_shifted_rpow_le`) correction bounds, the finite value enclosure (`finite_sum_enclosure`), weight monotonicity (`antitoneOn_shifted_rpow`), the tail integral bound (`integral_rpow_neg_le_inv`), the sharp weight bound (`sum_shifted_rpow_le_inv`), the uniform correction/value bounds (`norm_sum_correction_le_uniform`, `finite_sum_enclosure_uniform`), the `B₂` bound (`abs_BR_two_le`), the second-order interval identity (`integral_B1_mul_deriv_int_one`), the telescoping sum (`sum_range_sub_complex`), the natural-index second-order identity (`integral_B1_mul_deriv_nat`), the `emG` telescoping sum (`sum_range_emG_one_sub`), and the summed second-order correction (`sum_correction_second_order`). |

## What is not formalised

- The tail comparison used by `pair_tail_bound` in Python.
- A **segment** certificate. The point certificate at `1/2 + 5i` is complete
  (`zeta_half_plus_five_ne_zero`); extending it to a critical-line interval
  requires one box per subinterval. This is not a new mathematical input, only
  more computation.
- Any zero-free segment statement. The Python point certificate at
  `1/2 + 5i` is a computation, not a kernel-checked theorem.

[Back to the dossier](../README.md) · [Status §7](../../../status.html) ·
[Objective III Lean core](../../partial-sum-plus-tail/lean/README.md)
