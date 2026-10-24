# Lean formal core — theorems / paper series

## Build

```bash
cd the-final-letter/topics/theorems-paper-series
./lean/check.sh
```

The script wraps the shared checker at `../../tools/check-lean.sh`, which uses
the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`).
`BUILD.log` records the last successful check:

```
[check] OK   Topic.lean
```

The two `if_pos`/`if_neg` deprecation warnings in the log are from the current
Mathlib naming (`ite_eq_left`/`ite_eq_right`); they do not affect the proof.

## What is defined

`Topic.lean` works over `ℚ` in namespace `GDST`, with the normalised target
`x = θ/π`:

| Name | Definition |
|---|---|
| `alpha n` | `1 / (n + 2)` — the harmonic fraction |
| `run x N` | the greedy remainder after indices `0 … N−1` |
| `selectedWeight w x N` | `Σ_{k<N, δ_k=1} w k` |
| `rejectedWeight w x N` | `Σ_{k<N, δ_k=0} w k` |
| `totalWeight w N` | `Σ_{k<N} w k` |

The selection word is read off the recursion: `δ_k = 1` iff
`alpha k ≤ run x k`.

## What is proved

| Name | Statement |
|---|---|
| `alpha_pos` | `0 < alpha n` |
| `alpha_strictAnti` | `alpha` is strictly antitone |
| `run_le_self` | `run x N ≤ x` |
| `run_nonneg` | `0 ≤ x → 0 ≤ run x N` |
| `run_eq_sub_selected` | `run x N = x - selectedWeight alpha x N` |
| `selected_add_rejected` | `selectedWeight w x N + rejectedWeight w x N = totalWeight w N` |
| `gdst_pi_example` | `run 1 5 = 0 ∧ selectedWeight alpha 1 5 = 1` |

The last theorem is the source's own example `1 = 1/2 + 1/3 + 1/6`. No
`sorry`, `axiom`, or `admit` occurs. All seven statements are genuine finite
facts about the greedy recursion; none is a vacuous `rfl`.

## What is not formalised

- **The infinite greedy expansion.** The source's Theorem 1.5 needs
  `r_N → 0`; only the finite invariant is proved.
- **Digit monotonicity and thresholds.** The source's Theorems 1.7 and 1.9 are
  *false* as stated; the Python layer contains an exact counterexample
  (`test_digit_monotonicity_theorem_is_false`). They are deliberately not
  formalised.
- **The super-exponential sparsity claim.** The source's proof has an invalid
  step; only its arithmetic tail is tested, not proved.
- **The GDST analytic layer.** Absolute convergence, the meromorphic
  continuation, the transfer operator, trace-class and Fredholm determinant
  identities, the Jacobi matrices, the moment problem and the claimed proof of
  the Riemann hypothesis are all outside this file. They are recorded as source
  claims or open items in the programme README.
- **Real-valued angles.** The formal core is stated over `ℚ` for the
  normalised target `x = θ/π`. Rescaling by `π` and passing to `ℝ` would add
  nothing to the finite combinatorics.

In particular this file does **not** assert the Riemann hypothesis, GRH, twin
primes, Chowla, Sarnak, or Elliott.

[Back to the programme](../README.md) · [Topic index](../../README.md)
