# The complex partial sum vanishes at `N = 2`, `t = π / log 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §7 "The complex partial sums: `N = 2` vanishes, `N = 3` never does", lines 446–455

## Statement

> **`N = 2` vanishes exactly at `t = π / log 2` up to the periodicity of the cosine:** `zetaPartial 2 (π / log 2) = 1 + exp(-iπ) = 0`.

```lean
theorem zetaPartial_two_pi_div_log_two : zetaPartial 2 (Real.pi / Real.log 2) = 0
```

The source's section prose: at `N = 2` we have `zetaPartial 2 (π / log 2) = 1 + exp(-iπ) = 0`; no blanket non-vanishing statement about the complex partial sums is true.

## Hypotheses and notation

- `zetaPartial N t = ∑_{k<N} (k+1)^{-it} = ∑_{k<N} exp(-i t log (k+1))`, an ordinary finite sum.
- `zetaPartial 2 t = 1 + exp(-i t log 2)` (the expansion `zetaPartial_two`, line 433); at `t = π / log 2` the exponential is `exp(-iπ)`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `zetaPartial_two_pi_div_log_two` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 448–455). It rewrites with the expansion `zetaPartial_two`, uses `(π / log 2) * log 2 = π` and `Complex.exp_ofReal_mul_I`, then evaluates `cos π = -1`, `sin π = 0`.

## Dependencies and related results

- [The blanket non-vanishing claim is false](lean-rh43-balance-blanket-nonvanishing-claim-refuted.md) — the refutation that uses this vanishing as its witness.
- [The `N = 2` truncation is balanced at `t = π / log 2`](lean-rh43-balance-two-balanced-at-pi-over-log-two.md) — the real-part statement at the same point.
- [The `N = 3` truncation never vanishes](lean-rh43-balance-zeta-partial-three-never-vanishes.md) — the contrasting positive result.
- Harvested counterpart from the round's README: [`zetaPartial_two_pi_div_log_two` — `S_2(π/log 2) = 0` exactly](../tpp/tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md).

## Notes

- The source qualifies the word "exactly" with "up to the periodicity of the cosine"; the statement itself is the single evaluation at `t = π / log 2`. The expansion `zetaPartial_two` is definitional and is not harvested separately.
