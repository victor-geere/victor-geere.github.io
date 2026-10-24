# E7 — the large-L law (Theorem A)

**Kind:** Theorem
**Status:** PROVED (paper argument; `K1_plateau_theorem.md`, Theorem A)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E7

## Statement

> **The large-`L` law (Theorem A).** For `max(span, a_m+1) ≤ L ≤ N−1`, `p(L) = min(a_m + 1, N − L + 1) + [L ≤ N − a_m − 1]`; the simpler `min(a_m + 2, N − L + 1)` fails exactly on `1 ≤ L ≤ plateau-onset − 1`

## Hypotheses and notation

- `N` = truncation length; `a_0 < … < a_m` = support positions; `span = a_m − a_0`; `p(L) = #{ distinct length-L factors of w }`.
- `[·]` is the Iverson indicator; the second clause compares with the simpler candidate `min(a_m + 2, N − L + 1)`.

## Proof / evidence

Register row E7's evidence cell reads: "`probes.py`; mismatch sets are precisely the prefix `[1, onset−1]` on all seven words tested (1/π, log 2, √2−1, (10,20,40,80), true e−2, (9,25), (5,10))". The written proof is [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md), [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md).
- Register rows D2, D3, D5, E1, E4, E5, E6, E8, G4, G5, J10.

## Notes

- The register's "Honest summary" stresses that Theorem A is **combinatorial, not arithmetic**: it holds for every finitely supported 0/1 word, so it explains the plateau without using the greedy structure at all.
