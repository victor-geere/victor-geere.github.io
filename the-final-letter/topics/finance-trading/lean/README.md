# Lean formal core — finance / trading ebooks

## Build

```bash
cd the-final-letter/topics/finance-trading
./lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../../tools/check-lean.sh) and the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

`Topic.lean` imports Mathlib, opens `namespace FinanceLattice`, and defines

- `binomWeight p k j = p^j * (1 - p)^(k - j) * (k.choose j : ℝ)`;
- `nodeValue S₀ u d k j = S₀ * u^j * d^(k - j)`;
- `action S ε = S * (1 / (S * ε))`.

It proves seven source-relevant facts:

| Name | Statement |
|---|---|
| `binomWeight_nonneg` | `0 ≤ binomWeight p k j` for `0 ≤ p ≤ 1` |
| `sum_binomialWeight` | `Σ_{j=0}^{k} binomWeight p k j = 1` |
| `nodeValue_pos` | `0 < nodeValue S₀ u d k j` for `S₀, u, d > 0` |
| `action_eq_inv` | `action S ε = 1 / ε` for `S ≠ 0`, `ε ≠ 0` |
| `sum_lattice_action` | the binomial-weighted action sum on level `k` is `1 / ε` |
| `total_action_sum` | `Σ_{k=0}^{n} 1/ε = ((n : ℝ) + 1) / ε` |
| `log_two_point_growth_lt` | `½ log(1 − r²) < −r²/2` for `0 < r < 1` |

There is no `sorry`, no `axiom`, and no `admit`.

## What is not formalised

- The convergence of the binomial lattice to geometric Brownian motion / Black–Scholes (the source only sketches it).
- The `f(S,a) = e^{aS}` lattice sum, which the source describes only as an MGF/geometric series.
- The continuous-compounding integral identity and the Malliavin-calculus discussion.
- The general volatility-drag approximation `g ≈ μ − σ²/2` for GBM, and the Kelly optimum `f* = μ/σ²`.
- Every empirical claim in the ebooks (the `μ/σ²` thresholds, the asset table, the 5–15% dynamic-Kelly improvement).

These are recorded as source claims or open items in the programme README. They are not Lean theorems here.

## Why the core is small

The archived source is a table of contents, and its mathematical pages are expository, largely AI-generated ebooks. Only the binomial-lattice action computation in `continuous-lattice.html` §3–§4 gives a finite, exactly stated identity; the two-point volatility-drag inequality is the exact finite shadow of a second claim. The rest is not a formalisable theorem corpus.

[Back to the programme](../README.md) · [Topic index](../../README.md)
