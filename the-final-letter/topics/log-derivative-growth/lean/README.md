# Lean formal core — the `Z'/Z` growth bound

## Build

```bash
the-final-letter/topics/log-derivative-growth/lean/check.sh
```

## What is proved

| Name | Statement |
|---|---|
| `norm_logDeriv_le_of_bounds` | `0 < a ≤ ‖f s‖` and `‖f' s‖ ≤ b` imply `‖f'/f s‖ ≤ b/a` |
| `verticalLogDerivIntegrable_of_linear_bound` | harvested: a linear `Z'/Z` bound plus measurability gives `VerticalLogDerivIntegrable` |
| `integrable_one_add_abs_mul_exp_neg_sq` | harvested: `(1+|y|)exp(−σ²y²/2)` is integrable |
| `integrable_abs_pow_mul_exp_neg_mul_sq` | `|y|^k exp(−b y²)` is integrable for every `k` and `b > 0` |
| `integrable_one_add_abs_pow_mul_exp_neg_sq` | `(1+|y|)^k exp(−σ²y²/2)` is integrable for every `k` |
| `verticalLogDerivIntegrable_of_polynomial_bound` | a polynomial `Z'/Z` bound plus measurability gives `VerticalLogDerivIntegrable` |
| `verticalLogDerivIntegrable_of_linear_bound'` | the polynomial theorem specialises to the harvested linear bound |
| `measurable_riemannZeta` | `ζ` is measurable |
| `measurable_completedZeta` | `Z` is measurable |
| `measurable_logDeriv_completedZeta` | `Z'/Z` is measurable (Lean's `1/0 = 0`) |
| `aestronglyMeasurable_logDeriv_mul_gaussian` | `(Z'/Z)·H_c` is `AEStronglyMeasurable` on the vertical line |
| `verticalLogDerivIntegrable_of_polynomial_bound'` | a polynomial bound alone gives `VerticalLogDerivIntegrable` |
| `verticalLogDerivIntegrable_of_linear_bound''` | the linear case without a measurability hypothesis |
| `norm_logDeriv_le_of_sphere_bound` | circle bound + lower bound give `‖f'/f s‖ ≤ M/(R a)` |
| `norm_logDeriv_completedZeta_le_of_sphere` | the same for `Z`, away from `1` and the Gamma poles |
| `verticalLogDerivIntegrable_of_exp_bound` | a bound `M exp(A y²)` with `A < σ²` gives `VerticalLogDerivIntegrable` |
| `verticalLogDerivIntegrable_of_exp_bound'` | the same without a measurability hypothesis |
| `re_ge_of_mem_sphere_sub`, `re_ge_of_mem_closedBall_sub` | real part at least `x − R` on a circle/closed ball around `x + iy` |
| `exists_circle_growth_completedZeta_right` | Gaussian upper bound for `Z` on a right vertical circle |
| `verticalLogDerivIntegrable_of_right_growth_lower` | upper + exponential lower bound gives `VerticalLogDerivIntegrable` |
| `exists_positive_verticalLogDerivIntegrable_of_right_lower` | the lower bound alone yields some width `σ` with vertical integrability |
| `exists_zeta_lower_bound_right` | `‖ζ(s)‖ ≥ 1/4` for `Re s ≥ 2` |
| `verticalLogDerivIntegrable_left_of_right` | integrability on `Re s = 2` gives it on `Re s = −1` |
| `GammaRLowerBound` | the named Gamma input (now proved by `gammaR_lower_bound`) |
| `exists_Gamma_lower_shift` | shifted Gamma lower bound at `21/20 + iv` |
| `gammaR_lower_bound` | `GammaRLowerBound` is proved |
| `exists_verticalLogDerivIntegrable_right` | unconditional right-line integrability at `21/10` |
| `verticalLogDerivIntegrable_left_of_right_2110` | transfer `21/10 → −11/10` |
| `exists_verticalLogDerivIntegrable_left_2110` | unconditional left-line integrability at `−11/10` |
| `Gamma_one_add_I_lower` | `‖Γ(1+iy)‖ ≥ π|y|/(2e^{π|y|})` |
| `gammaR_lower_bound_two` | Gamma lower bound at `Re s = 2` |
| `exists_verticalLogDerivIntegrable_two`, `exists_verticalLogDerivIntegrable_neg_one` | unconditional vertical integrability at `2` and `−1` |
| `exists_verticalLogDerivIntegrable_right_of_gammaR_lower` | the named input closes the right line |
| `abs_sinh_le_exp`, `norm_sin_pi_mul_le` | `|sinh x| ≤ e^{|x|}` and `‖sin(π(u+iv))‖ ≤ 2e^{π|v|}` |
| `Gamma_one_sub_eq`, `Gamma_one_sub_norm_le` | recurrence to `Γ(2−w)/(1−w)` and its norm bound |
| `Gamma_lower_reflection` | strip lower bound `π‖v‖/(2Γ(2−u)e^{π‖v‖}) ≤ ‖Γ(u+iv)‖` |

No `sorry`, `axiom` or `admit`.

## What is open

- the **upper bound** `‖Z'(x+iy)‖ ≤ b(y)` (Cauchy/Stirling estimate);
- the **lower bound** `a(y) ≤ ‖Z(x+iy)‖` (zero-free region or Jensen);
- the resulting polynomial bound `‖Z'/Z‖ ≤ M(1+|y|)^k` (a linear bound is
  sufficient but not necessary);
Measurability is **not** open: `measurable_riemannZeta`,
`measurable_completedZeta`, `measurable_logDeriv_completedZeta` and
`aestronglyMeasurable_logDeriv_mul_gaussian` discharge it.

`verticalLogDerivIntegrable_of_polynomial_bound'` consumes only the polynomial
bound and `σ > 0`; `verticalLogDerivIntegrable_of_linear_bound''` is the
`k = 1` case.

[Back to the programme](../README.md) · [Topic index](../../README.md)
