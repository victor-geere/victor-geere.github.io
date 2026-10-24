# F2 — the C1 regime extends strictly below the next gap

**Kind:** Claim
**Status:** VERIFIED (numerical; measured first failures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §F "The C1 / prefix regime", register row F2

## Statement

> The C1 regime extends **strictly below the next gap**, so HANDOFF §4's statement (`0 < L ≤ min_j d_j`) badly understates it. Measured first failures: `L = 13` (1/π, gap 11), `34` (log 2, gaps 4,32,6033), `12` (√2−1 and (10,20,40,80)), `51` (true e−2, support `(0,3,53)`, `N = 2000`)

## Hypotheses and notation

- The C1 law is `p(L) = L + 1` (register rows C1, F1).
- `d_j` are the consecutive gaps; the quoted gaps "4,32,6033" are log 2's.

## Proof / evidence

Register row F2's evidence cell reads: "`probes.py` probe 3; `tests/...::test_c1_holds_beyond_min_gap_and_ends_below_next_gap`".

## Dependencies and related results

- Register rows C1, F1 (Theorem D), F3 (the exact formulation), F5 (which gap governs, `OPEN`).
- The ledger records that the mediator's generalisation of this row was itself an error (row 8 of `ledger.md`): true for the four dialogue words, not established in general.

## Notes

- The row is a measurement plus an indictment of HANDOFF §4's range; the general rule for the first failure is not claimed.

- **Correction (2025-10-06, session 003 residual-defect repair).** The recorded first-failure witness for the **true** `e−2` word was `4`. Measured, it is `51`: for the support `(0, 3, 53)` at `N = 2000` the C1 law first fails at `L = 51 = d_2 + 1`. The measurement is committed at [`research/twin-prime-parity/rounds/rh40/verify/c1_first_failure.py`](../../research/twin-prime-parity/rounds/rh40/verify/c1_first_failure.py) (log: `verify/c1_first_failure.log`), written because the credited `verify/probes.py` probe 3 tests random supports rather than any named word and the regression test covers four words, with its "e-2" entry being the dialogue word `(10,20,40,80)`. The register row F2 carries the same correction.
