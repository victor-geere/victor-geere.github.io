# A5 — for rational x the process always terminates

**Kind:** Claim
**Status:** VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A5

## Statement

> For rational `x` the process always terminates

## Hypotheses and notation

- `x` rational; all arithmetic in the census is exact (`Fraction` for rationals) — "never binary floats" per the register's notation paragraph.
- Termination means the residual reaches exactly `0`.

## Proof / evidence

Register row A5's evidence cell reads: "H-section census" (§H of the same file, rows H1–H4). The source states this without proof.

## Dependencies and related results

- Register row H1 (all 277 reduced `p/q` with `q ≤ 30` terminate), H2 (deepest indices), H3 (the count is a cap artefact), H4 (`θ = π` gives support `{0,1,4}`).
- Register row D7 (rational termination, with `θ = π` giving support `{0,1,4}` and `4/17` needing `n = 3 039 344`).
- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md).

## Notes

- The source's status is `VERIFIED` (a finite census), and H3 below shows the *counts* are cap artefacts; the qualitative statement is the one kept here.
