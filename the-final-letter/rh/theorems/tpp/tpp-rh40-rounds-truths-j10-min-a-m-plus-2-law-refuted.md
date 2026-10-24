# J10 (refuted) — p(L) = min(a_m + 2, N − L + 1) for all L

**Kind:** Claim
**Status:** REFUTED (fails exactly on `L = 1 … onset − 1` (604 values for 1/π), per E7)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J10

## Statement

> `p(L) = min(a_m + 2, N − L + 1)` for **all** `L`

## Hypotheses and notation

- `a_m` = last support position; `N` = truncation length; the law is asserted for all `L`.
- "onset" is the plateau onset (register rows E8, E8a).

## Proof / evidence

Register row J10's verdict cell reads: "`REFUTED`"; its witness cell reads: "fails exactly on `L = 1 … onset − 1` (604 values for 1/π), per E7". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register row E7 (the correct large-`L` law, whose simpler form *is* this one and fails on the same prefix), E8, E8a, J6, J14.

## Notes

- The failure set is exactly the prefix below the plateau onset, which is why the indicator `[L ≤ N − a_m − 1]` is needed in Theorem A. Do not re-propose this law.
