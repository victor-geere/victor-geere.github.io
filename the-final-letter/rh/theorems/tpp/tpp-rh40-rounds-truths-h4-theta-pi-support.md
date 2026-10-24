# H4 — θ = π terminates with exactly the support {0, 1, 4}

**Kind:** Claim
**Status:** VERIFIED (exact `Fraction` loop)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §H "Rational termination", register row H4

## Statement

> `θ = π` (i.e. `x = 1`) terminates with exactly the support `{0, 1, 4}`; `1/2 + 1/3 + 1/6 = 1`

## Hypotheses and notation

- `θ = π` is the target in the trigonometric reading, i.e. `x = 1` for the greedy; arithmetic is exact (`Fraction`).
- The support is the set of selected indices.

## Proof / evidence

Register row H4's evidence cell reads: "exact `Fraction` loop". The identity `1/2 + 1/3 + 1/6 = 1` is the source's exact verification.

## Dependencies and related results

- Register rows A5, D7, H1, H5.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) §3.4, where the support of true e−2 is likewise pinned exactly.

## Notes

- The float counterpart of this computation is register row H5, which gives a spurious support; the source's point is that exact rationals are mandatory.
