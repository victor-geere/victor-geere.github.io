# Exact values of the Cauchy kernel: `4`, `2`, `16/13` and `4/5`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §2 "The exact values of the Cauchy kernel", lines 139–171; declarations `Rh45.cauchyKernel_zero`, `Rh45.cauchyKernel_half`, `Rh45.cauchyKernel_three_quarters`, `Rh45.cauchyKernel_value`, `Rh45.cauchyKernel_one`

## Statement

> `cauchyKernel 0 = 4`.
>
> `cauchyKernel (1/2) = 2`.
>
> `cauchyKernel (3/4) = 16/13`.
>
> The exact values of the Cauchy kernel used by the numerics, collected:
> `cauchyKernel 0 = 4 ∧ cauchyKernel (1/2) = 2 ∧ cauchyKernel (3/4) = 16/13`.
>
> `cauchyKernel 1 = 4/5`.

The source adds, for the value at `3/4`:

> The brief's value `16/25` is the value of the *other* natural normalisation `1/(1 + t²)` at `t = 3/4`; for the kernel `1/(1/4 + t²)` used throughout this development one has `1/4 + (3/4)² = 13/16`, hence `16/13`.

## Hypotheses and notation

- `cauchyKernel t = 1 / (1/4 + t²)` — the Cauchy kernel of the round (definition, line 72).
- No hypotheses; the four evaluation points are `t = 0`, `1/2`, `3/4`, `1`.

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.cauchyKernel_zero` (line 140), `Rh45.cauchyKernel_half` (line 144), `Rh45.cauchyKernel_three_quarters` (line 152), `Rh45.cauchyKernel_value` (line 156, the conjunction of the first three) and `Rh45.cauchyKernel_one` (line 161). Each is proved by unfolding the defining equation and `norm_num`. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Defining equation `Rh45.cauchyKernel_def` (not harvested).
- `Rh45.cauchyKernel_one` (`cauchyKernel 1 = 4/5`) is used by [the refutation of the literal symmetry](lean-rh45-explicit-literal-symmetry-refuted.md).

## Notes

- The four evaluations are elementary `norm_num` computations and would be plumbing on their own; they are harvested because the source presents them as the round's exact kernel values ("the exact values of the Cauchy kernel used by the numerics") and because the `16/13` line is a stated **correction of the brief's `16/25`** (which belongs to the different normalisation `1/(1 + t²)`).
- `cauchyKernel_value` is the conjunction of the three values already listed and is not a separate mathematical statement; it is recorded inside this file rather than as its own theorem file.
