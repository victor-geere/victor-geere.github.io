# K7d — the three cases of the power family

**Kind:** Claim
**Status:** VERIFIED (numerical: max gaps 76 762 at `p=1.5`; 795 962 at `p=1.7`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7d

## Statement

> Within the power family: `p ≤ 1` no termination / `1 < p ≤ p*` **no termination either, with unbounded gaps** / `p > p*` no termination, gaps 1

## Hypotheses and notation

- The family is `α_n = (n+2)^{−p}` at `x = 1`; `p*` is the root of `ζ(p) = 2` (register row K7a).
- "Gaps" are the consecutive gaps of the selected support.

## Proof / evidence

Register row K7d's state cell reads: "**`VERIFIED`** (max gaps 76 762 at `p=1.5`; 795 962 at `p=1.7`)"; its evidence cell reads: "§5.3" (`K_remaining.md`).

## Dependencies and related results

- Register rows K7a (the threshold), K7b (the refuted bounded-gap witness), K7f (the corrected structure theorem that proves the middle case).

## Notes

- The middle case is exactly what refutes the deleted witness of row K7b; the gaps are unbounded there rather than all equal to 1.
