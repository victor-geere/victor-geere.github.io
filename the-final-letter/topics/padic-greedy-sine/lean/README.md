# Lean formal core — p-adic greedy sine

## Build

```bash
the-final-letter/topics/padic-greedy-sine/lean/check.sh
```

The wrapper calls [`../../tools/check-lean.sh`](../../tools/check-lean.sh) and elaborates this
folder against the local Mathlib installation. The last successful run is recorded in
[`BUILD.log`](BUILD.log).

## What is defined

`Topic.lean` works in `namespace PadicGreedy`:

| Name | Definition |
|---|---|
| `pNorm p q` | `padicNorm p q`, the p-adic norm on `ℚ` |
| `trunc p x N` | `Nat.ofDigits p ((Nat.digits p x).take N)`, the low `N` base-`p` digits |

## What is proved

| Name | Statement |
|---|---|
| `trunc_eq_mod` | `trunc p x N = x % p^N` |
| `trunc_lt` | `trunc p x N < p^N` |
| `trunc_add` | `trunc p x N + p^N * (x / p^N) = x` |
| `pNorm_p_pow` | `‖p^n‖_p = p^{-n}` |
| `pNorm_p_neg_pow` | `‖p^{-n}‖_p = p^n`; the proposed steps grow |
| `pNorm_p_pow_strictAnti` | `n ↦ ‖p^n‖_p` is strictly decreasing |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised

- **The p-adic sine series.** `sin_p`, its convergence disk, analyticity, and its zeros are in
  the Python layer, not Lean.
- **The Newton polygon.** The first-slope computation and the root-valuation deduction are
  computational; the Newton polygon theorem itself is not formalised.
- **The `p=2` root.** Whether `sin_2` has a nonzero root of valuation `1` is open.
- **Any relation to `ζ_p`.** None is asserted; the Kubota–Leopoldt function is not constructed
  here.
- **A global adelic product.** No replacement for the Euler product is proposed.

The formal core is deliberately the finite arithmetic that survives the step correction: the
base-`p` truncation identity and the norm bookkeeping that shows `p^{-n}` cannot be the steps.

[Back to the programme](../README.md) · [Topic index](../../README.md)
