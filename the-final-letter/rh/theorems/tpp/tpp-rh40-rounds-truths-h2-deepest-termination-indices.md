# H2 — deepest termination indices for q ≤ 30

**Kind:** Claim
**Status:** VERIFIED (exact rational censuses and targeted runs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §H "Rational termination", register row H2

## Statement

> Deepest termination indices below 5·10⁶: `4/17 = 3 039 344`, `14/19 = 2 359 419`, `7/23 = 1 019 083`, `9/29 = 648 787`, `21/23 = 644 045`, `17/19 = 375 971`, `12/29 = 320 072`, `19/23 = 138 459`; and the two extremes `4/25 = 53 307 974`, `27/29 = 1 003 066 151`

## Hypotheses and notation

- Reduced rationals `p/q` with `q ≤ 30`; entries are `p/q = termination index`.
- "Below 5·10⁶" applies to the first eight; the last two are the targeted-run extremes.

## Proof / evidence

Register row H2's evidence cell reads: "censuses + targeted runs (the 27/29 run took 1130 s)".

## Dependencies and related results

- Register rows H1, H3, D7.
- The ledger records the `268/277` figure as a cap artefact (row 7 of `ledger.md`).

## Notes

- These are the source's "power-of-ten traps": the termination index can be astronomically deep, so a small cap silently truncates the answer.
