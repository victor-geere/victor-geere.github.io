# G3 — RS(L) runs for 1/π up to L = 699

**Kind:** Claim
**Status:** VERIFIED (numerical; `probes.py` probe 4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §G.1 "x = 1/π — support `(2, 13, 607)`, `N = 1400`", register row G3

## Statement

> `RS(L)` for `L ≤ 699` runs `1` on `[1,10]`, `2` on `[11,13]`, `1` on `[14,604]`, `0` on `[605,699]` — i.e. `RS(L)` equals the slope wherever `Z(L) = 0`, exactly as C4 requires

## Hypotheses and notation

- `RS(L)` is the right-special factor count of length `L`; `Z(L) = |F(L)| − #{prefixes of F(L+1)}` (register row C3).
- The slope is `p(L+1) − p(L)`, so `Z(L) = 0` gives `slope = RS(L)` by register row C4.

## Proof / evidence

Register row G3's evidence cell reads: "`probes.py` probe 4".

## Dependencies and related results

- Register rows C2, C4, G2, J8.

## Notes

- The row is the measured corroboration of the corrected identity C4 on 1/π.
