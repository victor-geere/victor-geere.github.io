# D7 — rational termination: every rational x terminates; θ = π gives the support {0,1,4}

**Kind:** Claim
**Status:** VERIFIED (exact `Fraction` arithmetic; H-section census)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D7

## Statement

> **Rational termination.** Every rational `x` terminates; `θ = π` gives the support `{0,1,4}`; the termination index can be astronomically deep (`4/17` needs `n = 3 039 344`)

## Hypotheses and notation

- `x` rational, arithmetic exact (`Fraction`), never binary floats.
- `θ = π` means `x = 1` in the `(n+2)^{−p}`-style reading used by the section; the support is the set of selected indices.

## Proof / evidence

Register row D7's evidence cell reads: "H-section" (§H of the same file: rows H1–H4, census at caps up to 2·10⁹ and targeted exact runs).

## Dependencies and related results

- Register rows H1–H4, A5, and [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md).

## Notes

- The row's depth figure `n = 3 039 344` for `4/17` is one of the source's power-of-ten traps; the extreme is `27/29 = 1 003 066 151` (row H2).
