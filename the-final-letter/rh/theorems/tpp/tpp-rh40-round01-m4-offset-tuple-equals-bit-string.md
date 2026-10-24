# M4 — offset-tuple count = bit-string count everywhere

**Kind:** Claim
**Status:** VERIFIED (numerical; confirmed to L = 1399 by both routes)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.3 "From the mediator (own earlier claims, per HANDOFF.md §8.4)", verdict-table row M4

## Statement

> offset-tuple count = bit-string count everywhere

## Hypotheses and notation

- The offset-tuple count is `p_offset`; the bit-string count is `p_bruteforce` (register row B2 of `truths.md`).
- "Everywhere" here means every `L` up to `L = 1399` at `N = 1400`.

## Proof / evidence

The verdict-table row's verdict reads: "**STANDING**"; its mediator check reads: "confirmed to L = 1399 by both routes".

## Dependencies and related results

- Register rows B2, B3, C9 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md), the last harvested as [tpp-rh40-rounds-truths-c9-offset-encoding-lossy-in-principle.md](tpp-rh40-rounds-truths-c9-offset-encoding-lossy-in-principle.md).
- §3.4 of the same file (the `digitword.py` audit: "`p_offset` vs `p_bruteforce`, all words of length 12 with ≤ 4 ones, all L ✅ exhaustive").

## Notes

- **Restatement.** This row restates register entries B2/B3 of `truths.md` (round 1 of the rh40 dialogue).
- Register row C9 keeps the in-principle lossiness caveat, which this row does not contradict (the equality is asserted only on the tested range).
