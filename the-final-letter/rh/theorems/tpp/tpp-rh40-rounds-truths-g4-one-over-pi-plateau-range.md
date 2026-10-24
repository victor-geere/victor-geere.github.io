# G4 — the plateau for 1/π is exactly L ∈ [605, 792], p = 609 = a_m + 2

**Kind:** Claim
**Status:** VERIFIED (numerical; `verify_agentB.py` B-b)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.1 "x = 1/π — support `(2, 13, 607)`, `N = 1400`", register row G4

## Statement

> Plateau is exactly `L ∈ [605, 792]`, `p = 609 = a_m + 2`, 188 values

## Hypotheses and notation

- Word: 1/π, support `(2, 13, 607)`, `N = 1400`, so `a_m = 607` and `a_m + 2 = 609`.
- "Plateau" is the range on which `p(L) = a_m + 2` (register row E1).

## Proof / evidence

Register row G4's evidence cell reads: "`verify_agentB.py` B-b".

## Dependencies and related results

- Register rows E1, E2, E6, G2, G5.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) row B6 (the same range) and row M3 (the mediator's off-by-one claim `[605, 791]`, recorded as an error).

## Notes

- The **proved** plateau starts at `max(span, a_m + 1) = 608`; the measured plateau starts at 605. The source keeps this discrepancy as open problem K2 and does not claim an onset formula.
