# I2 — p* = 1.728647239… where ζ(p*) = 2

**Kind:** Claim
**Status:** VERIFIED (numerical, `mp.findroot` at dps 25)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I2

## Statement

> `p* = 1.728647239…` where `ζ(p*) = 2`

## Hypotheses and notation

- `p*` is the unique root of `ζ(p) = 2` used as the threshold in the programme's termination criteria.
- The ellipsis is the source's own.

## Proof / evidence

Register row I2's evidence cell reads: "`mp.findroot` at dps 25".

## Dependencies and related results

- Register row K7a, whose threshold is `p* = 1.72864723899818362` and which records that the threshold is **target-dependent** (for `x = 1/2` it is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223`).
- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md).

## Notes

- The value here is quoted to 9 decimals as the source prints it; the sharper `1.72864723899818362` is used in register row K7a.
