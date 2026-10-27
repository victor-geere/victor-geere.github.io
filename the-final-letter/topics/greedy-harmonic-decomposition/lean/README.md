# Lean formal core — greedy harmonic decomposition

## Build

```bash
the-final-letter/topics/greedy-harmonic-decomposition/lean/check.sh
```

The script uses the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). It writes `BUILD.log` output to the terminal; the committed log records the last successful check.

## What is proved

`Topic.lean` defines

- `GHD.alpha n = π / (n + 2)`;
- `GHD.Kdiag t = (t³ + (π − t)³) / (3π²)`.

It proves:

| Name | Statement |
|---|---|
| `alpha_pos` | `0 < alpha n` |
| `alpha_strictAnti` | `alpha` is strictly antitone |
| `alpha_tendsto_zero` | `alpha n → 0` |
| `scaled_alpha` | `(n + 2) * alpha n = π` |
| `Kdiag_pos` | `0 < Kdiag t` for `0 < t < π` |
| `Kdiag_symm` | `Kdiag t = Kdiag (π − t)` |
| `Kdiag_half` | `Kdiag (π/2) = π/12` |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised

- The greedy recursion itself and the induction proving `θ n* = α n` for all `n`.
- The `O(1/N)` convergence of the sine reconstruction.
- Selection monotonicity, selection density, and the asymptotic threshold distribution.
- Positive semidefiniteness of the full correlation kernel.

These are recorded as source claims or open items in the programme README. They are not Lean theorems here.

[Back to the programme](../README.md) · [Topic index](../../README.md)
