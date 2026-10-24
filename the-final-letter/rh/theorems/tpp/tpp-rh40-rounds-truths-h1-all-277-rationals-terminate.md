# H1 — all 277 reduced p/q with q ≤ 30 terminate

**Kind:** Claim
**Status:** VERIFIED (exact rational census at cap 5·10⁶ plus targeted runs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §H "Rational termination", register row H1

## Statement

> **All 277** reduced `p/q` with `q ≤ 30` terminate. At cap `5·10⁶`, 275 of 277 are reached; the two that need more are `4/25` (index **53 307 974**) and `27/29` (index **1 003 066 151**), both now resolved exactly

## Hypotheses and notation

- Reduced rationals `p/q` with `q ≤ 30`; a "cap" is the search budget in steps.
- "Index" is the termination index `n` at which the residual reaches `0`.

## Proof / evidence

Register row H1's evidence cell reads: "census at cap 5·10⁶ (20 s) plus targeted runs for the two stragglers".

## Dependencies and related results

- Register rows A5, D7, H2, H3, H4, H5.
- Register rows K7a–K7f (termination criteria for other alphabets).

## Notes

- The source's row H3 shows the *count* of terminations is a cap artefact; the qualitative statement here is the one the census supports.
