# Corollary 2 (plateau)

**Kind:** Corollary
**Status:** PROVED (paper argument; Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §1 "The complexity function"

## Statement

> **Corollary 2 (plateau).** For `max(span, a_m+1) ≤ L ≤ N − a_m − 1`, `p(L) = a_m + 2`.

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, `span = a_m − a_0`, truncation length `N`, `p(L)` the number of distinct length-`L` factors.
- The range is non-empty exactly when `max(span, a_m+1) ≤ N − a_m − 1` (the "plateau").

## Proof / evidence

Immediate from Theorem 1: in that range `min(a_m+1, N−L+1) = a_m+1` and `[ L ≤ N−a_m−1 ] = 1`, so `p(L) = a_m + 1 + 1 = a_m + 2`. The source states the corollary without a separate proof.

Machine-checked as `DigitWord.complexity_plateau` in `Rh41/DigitWord.lean` (no `sorry`).

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the formula this specialises.
- [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md) — turns the plateau value into the maximum when `N ≥ 2a_m + 2`.

## Notes

- The statement is the source's exact wording; the source gives no proof text beyond its placement after Theorem 1.
