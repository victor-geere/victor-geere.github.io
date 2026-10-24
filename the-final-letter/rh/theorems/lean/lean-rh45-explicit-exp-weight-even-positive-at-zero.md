# The two-sided exponential weight `(π/2) exp (−|u|/2)`: evenness, positivity and the value `π/2` at the origin

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §3 "The two-sided exponential weight", lines 188–203; declarations `Rh45.expWeight_even`, `Rh45.expWeight_pos`, `Rh45.expWeight_nonneg`, `Rh45.expWeight_at_zero`

## Statement

> **Evenness of the exponential weight.** `expWeight (-u) = expWeight u` for every `u : ℝ`.
>
> **Strict positivity of the exponential weight.** `0 < expWeight u` for every `u : ℝ`.
>
> Non-negativity: `0 ≤ expWeight u`.
>
> **The value at the origin:** `expWeight 0 = π/2`.

where the weight is

> `expWeight u = (Real.pi / 2) * Real.exp (-|u| / 2)`.

## Hypotheses and notation

- `u : ℝ`; no hypotheses.
- `expWeight u = (π/2) exp (-|u|/2)` — the two-sided exponential weight of the round (definition, line 183); `|u|` is the real absolute value, `Real.pi` is `π`.
- The source notes the two-sided exponential weight has Laplace transform `1/(1/4 - s²)` in the strip `|Re s| < 1/2` and Fourier transform `4/(1+4t²)` (see the integral files).

## Proof / evidence

Complete Lean proofs, no `sorry` (file header, lines 55–56). Declarations in `Rh45/Explicit.lean`: `Rh45.expWeight_even` (line 189, by `abs_neg`), `Rh45.expWeight_pos` (line 193, `mul_pos` of `positivity` and `Real.exp_pos`), `Rh45.expWeight_nonneg` (line 198, the `.le` of the strict statement) and `Rh45.expWeight_at_zero` (line 201, by `simp`). The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- Defining equation `Rh45.expWeight_def` (definitional rewrite, not harvested).
- [The Cauchy kernel is the Fourier transform of the exponential weight](lean-rh45-explicit-cauchy-kernel-as-fourier-transform.md) — uses `expWeight 0`-type rewriting and the evenness.
- Mathlib `abs_neg`, `Real.exp_pos`.

## Notes

- The non-negativity declaration is the `.le` of the strict positivity declaration and is recorded here rather than harvested separately.
- These are the weight's own structural facts; they are stated in the same source section, which is why they are harvested as one file.
