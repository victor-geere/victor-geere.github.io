# K7a — termination threshold for α_n = (n+2)^{−p} at unit target: ζ(p) ≥ 2, p* = 1.72864723899818362

**Kind:** Claim
**Status:** VERIFIED (mediator) — and **target-dependent**: for `x = 1/2` the threshold is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7a

## Statement

> Termination threshold for `α_n = (n+2)^{−p}`, unit target: terminates iff `ζ(p) ≥ 2`, `p* = 1.72864723899818362`

and, for the other target stated in the same row,

> for `x = 1/2` the threshold is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223`

## Hypotheses and notation

- Alphabet `α_n = (n+2)^{−p}`, `p > 1`; target `x = 1` (unit target) or `x = 1/2`.
- `p*` is the root of `ζ(p) = 2`; the second constant is the root of `ζ(p) = 3/2`.
- The termination criterion is `Σ α_n ≥ x` (the source's own reading).

## Proof / evidence

Register row K7a's state cell reads: "**`VERIFIED`** (mediator) — and **target-dependent**: for `x = 1/2` the threshold is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223`"; its evidence cell reads: "`K_remaining.md` §5.1".

## Dependencies and related results

- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md).
- Register rows I2 (`p* = 1.728647239…` at dps 25), K7b, K7d, K7e, K7f.
- The ledger records (row 32 of `ledger.md`) that a delegated agent quoted the threshold as `p = 1.728647…` for *general* `x`; it is target-dependent.

## Notes

- The two constants are quoted exactly as the source prints them, to 17 digits.
