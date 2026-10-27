# Lean formal core — iota helix function

## Build

```bash
the-final-letter/topics/iota-helix-function/lean/check.sh
```

The wrapper calls the shared `topics/tools/check-lean.sh`, which elaborates against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines, in `namespace Iota`:

- `radius σ n = n ^ (-σ)`;
- `phase t n = π (n - 1) - t log n`;
- `xcoord σ t n = radius σ n * cos (phase t n)`;
- `ycoord σ t n = radius σ n * sin (phase t n)`;
- `point σ t n = (xcoord, ycoord, n)`;
- `etaPartial σ N = Σ_{k<N} (-1)^k radius σ (k+1)`.

It proves:

| Name | Statement |
|---|---|
| `radius_pos` | `0 < radius σ n` for `n ≥ 1` |
| `radius_lt_radius` | `σ > 0` and `0 < m < n` imply `radius σ n < radius σ m` |
| `step_length` | `xcoord² + ycoord² = radius²` |
| `phase_succ_sub` | `phase t (n+1) - phase t n = π - t log ((n+1)/n)` for `n ≥ 1` |
| `point_one` | `point σ t 1 = (1, 0, 1)` |
| `real_axis_term` | at `t = 0`, `xcoord = (-1)^n radius` and `ycoord = 0` |
| `etaPartial_pos` | `σ > 0` and `N ≥ 1` imply `0 < etaPartial σ N` |

The last proof uses two private finite-sum lemmas:

- `altSum_even`: the even alternating sum equals the sum of consecutive pairs;
- `altSum_pos`: a positive strictly decreasing sequence has positive finite alternating sums.

No `sorry`, no `axiom`, no `admit`. There is no vacuous `rfl`-only declaration: every theorem is a genuine order, trigonometric, logarithmic, or finite-sum statement about the source objects.

## What the source actually supplies

The archived `iota-framework.html` is a speculative narrative, and the companion `iota-function.tex` contains the helix notation used above. The source does not prove:

- convergence of the complex eta series or its analytic continuation;
- the complex identity `radius * exp(I * phase) = (-1)^(n-1) * n^(-s)`;
- injectivity of the discrete or continuous iota map, or the recovery formulas;
- the continuous iota integral and its greedy inequality;
- the claimed arc-length trichotomy at `σ = 1`;
- the claim that the greedy condition is equivalent to RH.

Those items are recorded as source claims or open items in the [programme README](../README.md). In particular, the Lean file does **not** formalise, assume, or imply RH, GRH, twin primes, Chowla, or any zero-location statement.

## Convention note

`Topic.lean` uses the companion note's phase `π(n-1) - t log n`, which is consistent with the eta series term `(-1)^(n-1) n^(-s)`. The framework page writes the imaginary component with `+sin(t log n)`; that is the conjugate convention and is documented as an erratum in the programme dossier. The Lean `real_axis_term` theorem is the bridge back to the alternating eta series on `t = 0`.

[Back to the programme](../README.md) · [Topic index](../../README.md)
