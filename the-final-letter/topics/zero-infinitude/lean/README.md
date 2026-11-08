# Lean formal core — infinitude of the nontrivial zeros

## Build

```bash
the-final-letter/topics/zero-infinitude/lean/check.sh
```

The wrapper adds the `absolute-polarized-hodge-index-realization` and
`finite-window-zeros` Lean directories to `LEAN_PATH`, then elaborates
`Topic.lean` against the local Mathlib (`v4.35.0-rc2`).

## What is proved

| Name | Statement |
|---|---|
| `nontrivialZeros_countable` | `{z : ℂ | ξ₀ z = 0 ∧ 0 < Re z}` is countable |
| `nontrivialZeros_subtype_countable` | the nontrivial-zero subtype is `Countable` |
| `completedZeta_zero_of_xi₀_zero` | a nontrivial `ξ₀` zero is a zero of `completedZeta` |
| `tendsto_abs_atTop_of_summable_inv_sq` | summability of `Σ ((|γ n|+1)^2)⁻¹` forces `|γ n| → ∞` |
| `zeroTailSummable_of_nontrivial_xi₀_enumeration'` | any injective enumeration of nontrivial zeros has a summable Gaussian zero tail |
| `nontrivialZeros_denumerable_of_infinite` | infinitude makes the nontrivial-zero subtype `Denumerable` |
| `exists_nontrivial_xi₀_enumeration_of_infinite` | infinitude gives an injective enumeration with the right range |
| `exists_enumeration_and_zeroTailSummable_of_infinite` | infinitude gives the enumeration and `ZeroTailSummable` together |
| `nontrivialZeros_denumerable_iff_infinite` | `Denumerable` is exactly infinitude for the nontrivial-zero subtype |
| `zeroTailSummable_mono` | the Gaussian zero tail is monotone in the width |
| `exists_zero_abs_im_gt` | infinitude makes the zeros unbounded in ordinate |

No `sorry`, `axiom` or `admit`.

## What is open

- **Infinitude** of the nontrivial zero set — the only open item.  It is needed
  to obtain a `Denumerable` instance and hence an enumeration.  The library has
  countability, isolatedness, local finiteness and the zero-count bound, but no
  infinitude theorem.
- **Ordinate growth** is no longer open: `tendsto_abs_atTop_of_summable_inv_sq`
  derives it from inverse-square summability.
- The Gaussian tail capstone is no longer conditional on growth:
  `zeroTailSummable_of_nontrivial_xi₀_enumeration'` needs only the enumeration.
  The unconditional log-growth input is `exists_bound_log_norm_xi₀`.

[Back to the programme](../README.md) · [Topic index](../../README.md)
