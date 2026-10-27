# Corollary 3 (decay)

**Kind:** Corollary
**Status:** PROVED (paper argument; Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §1 "The complexity function"

## Statement

> **Corollary 3 (decay).** For `L ≥ max(span, a_m+1, N − a_m − 1)`, `p(L) = N − L + 1`; in particular `p(N−1) = 2` and `p(N) = 1`.

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md).
- In the stated range `L > N − a_m − 1`, so the Iverson bracket of Theorem 1 vanishes and `min(a_m+1, N−L+1) = N−L+1`.

## Proof / evidence

Immediate from Theorem 1; the source states the corollary without a separate proof.

Machine-checked as `DigitWord.complexity_decay`, with the two endpoints as `DigitWord.complexity_eq_one_of_le` (`p(N) = 1`) and `DigitWord.complexity_eq_two_of_pred` (`p(N-1) = 2`), in `Rh41/DigitWord.lean` (no `sorry`).

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the formula this specialises.

## Notes

- The endpoint statements `p(N−1) = 2` and `p(N) = 1` are part of the source's sentence and are formalised separately in Lean.
