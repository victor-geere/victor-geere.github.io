# I7 — the residual-orbit limit question cannot be settled by iterating a fixed-precision x

**Kind:** Claim
**Status:** VERIFIED (obstruction; follows from I5/I6)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I7

## Statement

> Consequently the residual-orbit limit question (K6) **cannot** be settled by directly iterating a fixed-precision `x`: the iteration runs out of digits long before any average can stabilise. Any treatment must work with the exact squaring map symbolically

## Hypotheses and notation

- K6 is the register's open problem "the limit is independent of `x`" (later `REFUTED`, register row K6).
- Fixed-precision iteration means running the residual recursion in floating point / mpmath at a fixed dps.

## Proof / evidence

Register row I7's status cell reads: "`VERIFIED` as an obstruction"; its evidence cell reads: "follows from I5/I6".

## Dependencies and related results

- Register rows I5, I6, I8, K6, D6.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- An obstruction result: it rules out a method, and does not assert anything about the limit's value.
