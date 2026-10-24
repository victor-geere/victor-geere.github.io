# E2 — the plateau is non-empty when a_m + 1 ≤ N − a_m − 1, i.e. N ≥ 2a_m + 2

**Kind:** Claim
**Status:** PROVED (paper argument; and E1 is proved)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E2

## Statement

> The plateau is non-empty when `a_m + 1 ≤ N − a_m − 1`, i.e. `N ≥ 2a_m + 2`; all four dialogue words satisfy it

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position.
- The plateau is the range of `L` on which `p(L) = a_m + 2` (register row E1).

## Proof / evidence

Register row E2's status cell reads: "**`PROVED`** (and E1 is proved)". The written proof is [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md), whose §2 notes "the dialogue words all satisfy `a_m + 1 ≤ N − a_m − 1`, i.e. `N ≥ 2a_m + 2`".

## Dependencies and related results

- Register row E1 (the plateau value), E4 (the bound is not decorative outside this condition), E6 (where the plateau ends).

## Notes

- The condition is exactly the one under which the plateau interval is non-empty, not a condition on the value.
