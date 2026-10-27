# K7e — any terminating alphabet has finite support, hence max_L p(L) = a_m + 2

**Kind:** Claim
**Status:** PROVED (paper argument; direct from K1's Theorem A, and alphabet-independent)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7e

## Statement

> **Any terminating alphabet has finite support, hence `max_L p(L) = a_m + 2`; so no terminating alphabet can realise `p(L) = cL`**

## Hypotheses and notation

- A "terminating alphabet" is a greedy alphabet whose process halts exactly; finite support means only finitely many indices are taken.
- `a_m` is the last taken index; `p(L)` the distinct-factor count of the resulting word.

## Proof / evidence

Register row K7e's state cell reads: "**`PROVED`** — direct from K1's Theorem A, and alphabet-independent"; its evidence cell reads: "§5.4" (`K_remaining.md`).

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) and [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md).
- Register row E1 and [The inverse problem has no halting alphabet with linear complexity](tpp-rh40-k-remaining-inverse-problem-negative.md).
- Register row J7 (the refuted `p(L) = L + 1` law) and K7 (the inverse problem, closed negatively on this half).

## Notes

- This is the non-existence half of the programme's inverse problem C4; the source records the constructive half as open.
