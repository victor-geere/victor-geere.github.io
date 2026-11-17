# Lean formal core — the zero-side bridge

## Build

```bash
the-final-letter/topics/zero-side-bridge/lean/check.sh
```

The core itself lives in
[`absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean),
because its `ExplicitFormula` module and the `intersection-form-zeta`
`Archimedean` module used by the density layer do not coexist in one `LEAN_PATH`.
`check.sh` puts both on the path, and `Topic.lean` re-exports the five statement
under the `ZeroSideBridge` namespace.

## What is proved

| Name | Statement |
|---|---|
| `critical_line_eq_fourier` | `H_c(1/2 + it) = 2πσ² exp(−σ²t²) exp(−ict)`, i.e. `ĝ_c(t)` |
| `pole_sum_eq_poleTerm` | `H_c(0) + H_c(1) = 4πσ² exp(σ²/4) cosh(c/2)`, the pole term of `W` |
| `weight_eq_mode_mul` | `H_{a−b}(1/2+it) = gaussianMode a σ t · conj(gaussianMode b σ t)` |
| `zeroSideGram_posSemidef` | the zero-side Gram matrix of on-line frequencies is PSD |
| `contour_identity` | the rectangle contour identity for a finite zero set |

All audit to `[propext, Classical.choice, Quot.sound]`.

## What is not proved

The equality `gaussianGramEntry = Σ_ρ ĝ_c(γ_ρ)` itself.  The three obligations —
the prime/archimedean evaluation, the rectangle limit, and the zero-set
enumeration — are listed in [`../README.md`](../README.md) §4.  No `sorry`,
`axiom` or `admit` appears anywhere in the chain.
