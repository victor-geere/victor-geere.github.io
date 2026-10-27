# zeros located from `ζ` evaluations alone to 32–33 digits

**Kind:** Theorem
**Status:** VERIFIED (numerical, 32–33 digits)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E7, line 97

## Statement

The ledger row, verbatim:

> | E7 | zeros located from `ζ` evaluations alone to 32–33 digits | NUMERICAL | rh45 audit C2 |

## Hypotheses and notation

- The claim is that non-trivial zeros are **located** using evaluations of `ζ` alone (no zero-finding oracle, no separately tabulated zero data).
- The precision is quoted exactly: **32–33 digits** (a range, as in the source).
- The source is `rh45 audit C2`.

## Proof / evidence

The ledger records `NUMERICAL` with source `rh45 audit C2`; no proof is given and none is claimed. This is a finite-precision computational certificate, not a theorem about the zeros' locations.

## Dependencies and related results

- [(P6) Counting formula](tpp-dict-01-zero-counting-formula.md) and [E6 — the counting asymptotic](tpp-dict-00-zero-counting-asymptotic.md) supply the counting context in the same round.
- [E5 — the explicit formula with the archimedean term](tpp-dict-00-weil-explicit-formula-archimedean-term.md) is the analytic tool of the same round `rh45`.

## Notes


- Harvested with status **VERIFIED (numerical)** only: the ledger says `NUMERICAL`, and the precision range `32–33 digits` is reproduced exactly.
- The ledger does not say *which* zeros, nor to what height; nothing is added here.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh45/verify/independent_check.py`, `research/twin-prime-parity/rounds/rh45/verify/independent_check.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
