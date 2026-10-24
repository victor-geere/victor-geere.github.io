# J6 (refuted) — model D: p(L) = min(L + span, N − L + 1)

**Kind:** Claim
**Status:** REFUTED (`{139,151}`, `N = 172`, `L = 13`: 25 vs 15)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J6

## Statement

> `p(L) = min(L + span, N − L + 1)` (model D)

## Hypotheses and notation

- `span = a_m − a_0`; `N` = truncation length; `p(L)` the distinct-factor count.
- The law is asserted for all `L`.

## Proof / evidence

Register row J6's verdict cell reads: "`REFUTED`"; its witness cell reads: "`{139,151}`, `N = 172`, `L = 13`: 25 vs 15". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register rows D1 (the ceiling `N − L + 1`), E7 (the correct large-`L` law), J10, J14.

## Notes

- Do not re-propose this law; the failure is in the plateau region, where the true value is ruled by `a_m` rather than `span`.
