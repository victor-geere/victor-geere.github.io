# `realPartial 2` vanishes at `t = π / log 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §6 "The truncation at `N = 2` is balanced at `t = π / log 2`", lines 383–389

## Statement

> **`realPartial 2` vanishes at `t = π / log 2`.**

```lean
theorem realPartial_two_pi_div_log_two : realPartial 2 (Real.pi / Real.log 2) = 0
```

The source explains the point: the zeros of `realPartial 2` are *tangential* at `t = (2k+1)π / log 2`, where `realPartial 2 t = 1 + cos (t log 2) = 1 + cos π = 0`.

## Hypotheses and notation

- `realPartial 2 t = 1 + cos (t log 2)` (the expansion `realPartial_two`, line 318).
- `Real.pi / Real.log 2` with `Real.log 2 ≠ 0`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `realPartial_two_pi_div_log_two` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 384–389). It rewrites the expansion, cancels `(π / log 2) * log 2 = π` (from `Real.log_pos`), and evaluates `cos π = -1`.

## Dependencies and related results

- [`N = 2` is balanced at `t = π / log 2`](lean-rh43-balance-two-balanced-at-pi-over-log-two.md) — the immediate consequence.
- [The complex partial sum vanishes at the same point](lean-rh43-balance-zeta-partial-two-vanishes-at-pi-log-two.md).
- [At `t = 0` the `N = 2` truncation is not balanced](lean-rh43-balance-two-not-balanced-at-zero.md) — a different point, so there is no contradiction.
- Harvested counterpart from the round's README: [`balanced_two` / `exists_balanced_two` — N = 2 is balanced at `π/log 2`](../tpp/tpp-rh43-lean-readme-balanced-two.md).

## Notes

- The source's section heading calls this family of zeros *tangential*; the docstring's wording is preserved here.
