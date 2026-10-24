# E4 — max_L p(L) &gt; a_m + 2 is possible outside the eligibility condition

**Kind:** Claim
**Status:** VERIFIED (numerical; witness `(30,)`, `N = 34`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E4

## Statement

> `max_L p(L) > a_m + 2` is possible **outside** the eligibility condition, so E2 is not decorative

## Hypotheses and notation

- The eligibility condition is `N ≥ 2a_m + 2` (register row E2).
- `a_m` = last support position; `p(L)` the factor count.

## Proof / evidence

Register row E4's evidence cell reads: "`(30,)`, `N = 34`: max `p = 5` while `a_m + 2 = 32`".

## Dependencies and related results

- Register rows E1, E2, E7 (the large-`L` law holds only for `max(span, a_m+1) ≤ L ≤ N−1`).

## Notes

- The witness shows the theorem's range restriction cannot be dropped.
