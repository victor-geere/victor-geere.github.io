# J1 (refuted) — p(L) = L + 1 + #{pairs of 1s at distance ≤ L}

**Kind:** Claim
**Status:** REFUTED (1/π `L = 11` (law 13, truth 12); log 2 **`L = 4`** (6 vs 5) — ★HANDOFF §5 wrongly records log 2 at `L = 6` (both sides give 8))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J1

## Statement

> `p(L) = L + 1 + #{pairs of 1s at distance ≤ L}`

## Hypotheses and notation

- The pairs are unordered pairs of support positions `a_i < a_j` with `a_j − a_i ≤ L`.
- `p(L)` is the distinct-factor count; the law is asserted for all `L`.

## Proof / evidence

Register row J1's verdict cell reads: "`REFUTED`"; its witness cell reads: "1/π `L = 11` (law 13, truth 12); log 2 **`L = 4`** (6 vs 5) — ★HANDOFF §5 wrongly records log 2 at `L = 6` (both sides give 8)". The section preamble adds: "Each was refuted by exact enumeration. The **true first failure** is given where the handoff's recorded witness does not reproduce — those two are starred."

## Dependencies and related results

- Register row J2 (the distance-count variant), J3 (the gap-deficit variant), F1.
- The ledger records the same HANDOFF defect (row 10 of `ledger.md`).

## Notes

- The ★ marks a case where the handoff's *recorded* witness does not reproduce; the true first failure is the one printed here. Do not re-propose this law.
