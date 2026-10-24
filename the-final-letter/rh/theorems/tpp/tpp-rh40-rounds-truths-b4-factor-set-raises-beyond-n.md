# B4 — factor_set and p_offset raise on L > N instead of silently returning an empty set

**Kind:** Claim
**Status:** VERIFIED (code behaviour; defect found by Agent B, fixed)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §B "The definition of record, and its equivalence", register row B4

## Statement

> `factor_set` and `p_offset` **raise** on `L > N` instead of silently returning an empty set (defect found by Agent B, fixed)

## Hypotheses and notation

- `factor_set` and `p_offset` are the two factor-counting entry points of `code/digitword.py`.
- `N` is the truncation length, `L` the factor length.

## Proof / evidence

Register row B4's evidence cell reads: "`code/digitword.py`".

## Dependencies and related results

- Register row B2 (`p_offset == p_bruteforce`), the equivalence whose API this row protects.
- Register row D1 (the window count `p(L) ≤ N − L + 1`), which is why `L > N` has no content.

## Notes

- This is an API-behaviour result, not a mathematical theorem; the source records it as the fix of a defect found by Agent B.
