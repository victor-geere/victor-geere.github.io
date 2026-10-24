# I4 — ∫₀¹ log(1−f) df = −1 exactly

**Kind:** Claim
**Status:** VERIFIED (numerical/exact; `probes.py` probe 5)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I4

## Statement

> `∫₀¹ log(1−f) df = −1` exactly — A's scaling-limit value is correct **as an integral**

## Hypotheses and notation

- `f` is the fractional-part variable of the squaring law `r_{k+1} = (1−f)r_k²/(1+(1−f)r_k)` (register row D6).
- The qualification "as an integral" is the source's own.

## Proof / evidence

Register row I4's evidence cell reads: "`probes.py` probe 5".

## Dependencies and related results

- Register rows D6, I8, K6c, K6d, K6f.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The clause "as an integral" is essential: the corresponding *orbit* average is refuted (register row K6f), and the finite-`r` means are not `−1` (row I8). The source does not claim the integral value transfers to the orbit.
