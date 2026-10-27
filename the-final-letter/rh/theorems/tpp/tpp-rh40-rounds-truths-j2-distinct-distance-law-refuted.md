# J2 (refuted) — p(L) = L + 1 + #{distinct distances ≤ L}

**Kind:** Claim
**Status:** REFUTED (1/π **`L = 11`** (13 vs 12) — ★HANDOFF §5 wrongly records `L = 12` (both sides give 14))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J2

## Statement

> `p(L) = L + 1 + #{distinct distances ≤ L}`

## Hypotheses and notation

- The distances are the distinct values `a_j − a_i ≤ L` among support pairs.
- `p(L)` is the distinct-factor count; the law is asserted for all `L`.

## Proof / evidence

Register row J2's verdict cell reads: "`REFUTED`"; its witness cell reads: "1/π **`L = 11`** (13 vs 12) — ★HANDOFF §5 wrongly records `L = 12` (both sides give 14)". The section preamble adds: "Each was refuted by exact enumeration. The **true first failure** is given where the handoff's recorded witness does not reproduce — those two are starred."

## Dependencies and related results

- Register row J1 (the pair-count variant), J3, F1.
- The ledger records the same HANDOFF defect (row 9 of `ledger.md`).

## Notes

- The ★ marks a case where the handoff's *recorded* witness does not reproduce; the true first failure is the one printed here. Do not re-propose this law.
