# M6 — C1 as stated in §4 is false; regime ends below the next gap

**Kind:** Claim
**Status:** VERIFIED (numerical; probe 3 and both agents)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.3 "From the mediator (own earlier claims, per HANDOFF.md §8.4)", verdict-table row M6

## Statement

> C1 as stated in §4 is false; regime ends below the next gap

## Hypotheses and notation

- C1 is the law `p(L) = L + 1`; HANDOFF §4 stated its range as `0 < L ≤ min_j d_j`.
- "Ends below the next gap" is the claim that the first failure lies strictly below the next gap.

## Proof / evidence

The verdict-table row's verdict reads: "**STANDING**"; its mediator check reads: "probe 3 and both agents". The measured failures are in register row F2 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md): `L = 13` (1/π, gap 11), `34` (log 2), `12` (√2−1 and (10,20,40,80)), `4` (true e−2).

## Dependencies and related results

- Register rows C1, F1 (Theorem D), F2, F3, F4 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md); rows A1, A2 of the same table.
- Ledger error row 8 records the mediator's own over-generalisation of this row ("ends strictly below the next gap **in every case**" — true for the four dialogue words, not established in general).

## Notes

- The row states the *first* half positively (HANDOFF §4's range is false); the general "in every case" form was later logged as an error (ledger row 8).
