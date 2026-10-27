# Lean formal core — p-adic and stochastic zeta

## Build

```bash
cd the-final-letter/topics/padic-stochastic-zeta
./lean/check.sh
```

The wrapper calls the shared `../../tools/check-lean.sh`, which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful check.

## What is proved

`Topic.lean` imports Mathlib and works in the namespace `PadicStoch`. It defines:

- `pNorm p q = padicNorm p q`, the p-adic norm on `ℚ`;
- `encode p s = Nat.ofDigits p s`, the finite little-endian digit encoding;
- `eulerFactor p = 1 - p⁻¹`, the local Euler factor at `s = 1`;
- `klFactor p k = 1 - p^(k-1)`, the Kubota–Leopoldt interpolation factor;
- `klValue p = klFactor p 2 * (-(1/12))`, the value at `s = -1`.

It proves:

| Name | Statement |
|---|---|
| `pNorm_p_pow` | For prime `p`, `‖pⁿ‖_p = p^{-n}` |
| `pNorm_p_pow_strictAnti` | For prime `p`, `n ↦ ‖pⁿ‖_p` is strictly antitone |
| `pNorm_nonarchimedean` | `‖q+r‖_p ≤ max(‖q‖_p, ‖r‖_p)` |
| `encode_example` | `encode 3 [2,1,0] = 5` |
| `eulerFactor_telescope` | `(1−p⁻¹) Σ_{k<N} p^{-k} = 1−p^{-N}` |
| `klValue_eq` | `klValue p = (p−1)/12` |
| `klValue_pos` | `1 < p → 0 < klValue p` |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised

The archived source is an expository essay, not a proof. The following are **not** in the Lean file:

- the p-adic completion `ℚ_p` and the topology/compactness of `ℤ_p`;
- convergence of infinite digit sequences (only finite encodings are treated);
- the Kubota–Leopoldt measure, the p-adic zeta function, and the interpolation theorem for general `k`;
- continuity, analyticity, and regularity at `s = 1`;
- Bernoulli/Kummer congruences beyond the explicit rational values used at `k = 2,4`;
- any stochastic process, stochastic representation of zeta, or p-adic spectral operator.

`pNorm_p_pow`, `pNorm_p_pow_strictAnti`, and `pNorm_nonarchimedean` use Mathlib's `padicNorm` API rather than rebuilding the theory of `ℚ_p`. `klValue_eq` and `klValue_pos` are rational bookkeeping at `k = 2`; they do not assert the existence of the p-adic zeta function. These limitations are recorded as source claims or open items in the programme README.

[Back to the programme](../README.md) · [Topic index](../../README.md)
