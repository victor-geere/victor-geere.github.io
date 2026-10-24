# E5 — decay law: p(L) = N − L + 1 for exactly L ∈ [N − a_m − 1, N − 1]

**Kind:** Claim
**Status:** PROVED (paper argument; Corollary of Theorem A)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E5

## Statement

> **Decay law.** `p(L) = N − L + 1` for exactly `L ∈ [N − a_m − 1, N − 1]`

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position; `p(L) = #{ distinct length-L factors of w }`.
- "Exactly" means the range is tight: equality holds on that interval and on no larger one.

## Proof / evidence

Register row E5's evidence cell reads: "`verify_agentB.py` B-b; holds contiguously to `p(N−1) = 2` on all four dialogue words". The written proof is a corollary of [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the general law this specialises.
- Register rows D1, D2, D3, D5, E1, E6, E7, F1, G5.

## Notes

- The register's "Honest summary" lists E5 among the `PROVED` rows (E1, E5, E6, E7 and D3, D5). The ledger's attributed-results table records the same law as "The decay law as a corollary (C2b) … `PROVED`".
