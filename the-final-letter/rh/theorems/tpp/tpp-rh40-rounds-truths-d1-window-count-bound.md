# D1 — window count: p(L) ≤ N − L + 1, and p(N) = 1, p(N−1) = 2

**Kind:** Claim
**Status:** VERIFIED (elementary; `probes.py` probe 1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §D "Coordinate laws and window counts", register row D1

## Statement

> **Window count.** `p(L)` counts over `N − L + 1` window starts, so `p(L) ≤ N − L + 1`; and `p(N) = 1`, `p(N−1) = 2` for any finitely supported word

## Hypotheses and notation

- `N` = truncation length; `p(L) = #{ distinct length-L factors of w }` (register row A1).
- `w` is finitely supported, so for `L = N` there is a single window and for `L = N − 1` there are two.

## Proof / evidence

Register row D1's evidence cell reads: "direct; `probes.py` probe 1". The source states this as elementary bookkeeping.

## Dependencies and related results

- Register row D2 (the bound is never binding until `L ≥ N − a_m − 1`) and D3/E5 (where it becomes an equality).
- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) and [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md), where the bound is attained.

## Notes

- The source adds a blockquote note to this row: "HANDOFF §8.3 lists `p(L) ≤ N − L + 1` as a Tier-1 Lean target. Formalising it is easy and nearly useless; the load-bearing lemma is the injectivity statement behind E1."
