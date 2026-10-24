# E1 — plateau value max_L p(L) = a_m + 2

**Kind:** Claim
**Status:** PROVED (paper argument; `K1_plateau_theorem.md`, Theorem B)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E1

## Statement

> **Plateau value `max_L p(L) = a_m + 2`** — a function of the last support position alone

The source points to the proof in [`K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md).

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position; `p(L) = #{ distinct length-L factors of w }`.
- The maximum is over the eligible range of `L` (see register row E2: non-empty when `N ≥ 2a_m + 2`).

## Proof / evidence

Register row E1's evidence cell reads: "`verify_agentB.py` B-c: 255/255 eligible N=20 words, 765 random eligible supports, 0 counterexamples; and 609 = 607+2, 6071 = 6069+2, 253 = 251+2, 82 = 80+2, 55 = 53+2". The written proof is [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md).

## Dependencies and related results

- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) and [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).
- Register rows E2, E3, E4, E5, E6, E7, and the cross-references D3/D5.

## Notes

- The register's "Honest summary" lists E1 among the `PROVED` rows after the closure of open problem K1; the source credits the *observation* to Agent B with Agent A's independent prediction.
