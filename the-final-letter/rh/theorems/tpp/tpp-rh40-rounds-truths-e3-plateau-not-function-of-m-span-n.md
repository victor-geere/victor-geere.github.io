# E3 — the plateau value is not a function of (m, span, N)

**Kind:** Claim
**Status:** VERIFIED (numerical; 45/55 keys multi-valued at N=20)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E3

## Statement

> The plateau value is **not** a function of `(m, span, N)`

## Hypotheses and notation

- `m` is the index of the last support position, `span = a_m − a_0`, `N` the truncation length.
- The plateau value is `max_L p(L) = a_m + 2` (register row E1).

## Proof / evidence

Register row E3's evidence cell reads: "45/55 keys multi-valued at N=20; witness `(0,)→2` vs `(11,)→10` at `m=1, span=0, N=20`".

## Dependencies and related results

- Register row E1 (the value is a function of `a_m` alone instead).
- Register row E8a (the onset is not a function of `(gaps, N)` but is a function of `(gaps, N, a_0)`).

## Notes

- This is the obstruction the K1 proof had to route around: `a_m` alone determines the value, which `(m, span, N)` do not.
