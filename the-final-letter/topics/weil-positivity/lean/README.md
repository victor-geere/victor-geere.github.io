# Lean formal core — Weil positivity

## Build

```bash
the-final-letter/topics/weil-positivity/lean/check.sh
```

The wrapper adds the `absolute-polarized-hodge-index-realization` and
`finite-window-zeros` Lean directories to `LEAN_PATH`, then elaborates
`Topic.lean`.

## What is proved

| Name | Statement |
|---|---|
| `WeilPositivity` | the named finite critical-line positivity statement |
| `weilPositivity` | harvested: every finite critical-line family has a PSD Gram matrix |
| `OffLineBlock` | the isolated 2×2 block of an off-line quadruple |
| `OffLineBlockPSD` | the block is positive semidefinite |
| `not_offLineBlockPSD_of_offLine` | an off-line zero produces a non-PSD block |
| `no_offLine_of_all_blocks_psd` | universal block positivity implies RH |
| `twoByTwo_diag_posSemidef_iff` | `!![a, b; b, a]` is PSD iff `|b| ≤ a` |
| `offLineBlockPSD_iff` | the isolated block is PSD iff `|S(c)| ≤ S(0)` |
| `not_offLineBlockPSD_of_abs_lt` | `S(0) < |S(c)|` breaks the isolated block |
| `not_offLineBlockPSD_iff` | block failure is exactly `S(0) < |S(c)|` |
| `exists_abs_offLineQuad_gt_of_offLine` | an off-line zero forces some `c` with `S(0) < |S(c)|` |
| `all_blocks_psd_iff_scalar` | universal block positivity ⇔ the scalar inequality for every parameter |
| `no_offLine_of_all_abs_le` | the scalar bound for all parameters implies RH |
| `exists_abs_offLineQuad_gt_of_not_RH` | failure of RH produces `c, σ, δ, γ` with `δ ≠ 0` and `S(0) < |S(c)|` |
| `exists_abs_offLineQuad_gt_any` | for every `K` some `c` has `K < |S(c)|` |

No `sorry`, `axiom` or `admit`.

## What is not claimed

- **Unconditional Weil positivity.**  It is RH-equivalent; the file proves
  only the finite on-line statement and the `blocks ⇒ RH` direction.
- **The assembly from the three upstream programmes.**  The plan is in
  [`HANDOFF.md`](../HANDOFF.md); the individual inputs live in
  `zero-infinitude`, `log-derivative-growth`, and `zero-density-bound`.
- **The full Gram-matrix extension** of the off-line obstruction (only the
  isolated 2×2 block is formalised here).  The scalar criterion makes the
  isolated obstruction a single real inequality, but does not extend it to the
  full block.

[Back to the programme](../README.md) · [Topic index](../../README.md)
