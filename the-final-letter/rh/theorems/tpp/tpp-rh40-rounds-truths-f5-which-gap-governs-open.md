# F5 — which gap governs the first failure of C1 is not determined by the gaps alone

**Kind:** Claim
**Status:** VERIFIED (numerical measurement; the rule is OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §F "The C1 / prefix regime", register row F5

## Statement

> For 1/π the first failure is at `L = d_1 + 2 = 13`; for log 2 and true e−2 it is at `L = d_2 + 1 = 51`. **Which gap governs is not determined by the gaps alone**

## Hypotheses and notation

- `d_1` is the first gap, `d_2` the second, of the support's consecutive gaps.
- "First failure" means the smallest `L` at which `p(L) = L + 1` fails.

## Proof / evidence

Register row F5's evidence cell reads: "`probes.py` probe 3"; its status cell reads "`VERIFIED` as measurement, rule `OPEN`".

## Dependencies and related results

- Register rows F1, F2, F3, F4; the round-1 slope-switch measurement (row A3 of [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md)).

## Notes

- Harvested with the honest split status: the measurement is verified, the governing rule is open in the source's own words.

- **Correction (2025-10-06, session 003 residual-defect repair).** The claim "for log 2 and true `e−2` it is at `L = d_2 + 2`" is false for the true `e−2` word: with support `(0, 3, 53)` the first failure is `L = 51 = d_2 + 1`, not 52. Measured and committed at `research/twin-prime-parity/rounds/rh40/verify/c1_first_failure.py` (log: `verify/c1_first_failure.log`); the register row F5 carries the same correction. That the governing gap is not determined by the gaps alone remains the row's point.
