# E8a — Theorem E (determinacy): the plateau onset is not a function of (gaps, N) but is a function of (gaps, N, a_0)

**Kind:** Theorem
**Status:** PROVED (paper argument; the negative half by counterexample, the positive half by construction)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E8a

## Statement

> **Theorem E (determinacy).** The plateau onset is NOT a function of `(gaps, N)` alone (1 486 of 2 299 keys carry >1 onset at `m+1 ≤ 4`, `6 ≤ N ≤ 24`) but IS a function of `(gaps, N, a_0)` (positive half is a tautology)

## Hypotheses and notation

- `gaps` is the multiset/sequence of consecutive gaps `d_j = a_j − a_{j−1}`; `m+1 ≤ 4` and `6 ≤ N ≤ 24` bound the tested corpus.
- `a_0` is the first support position. The onset is the smallest `L` at which `p(L) = a_m + 2`.

## Proof / evidence

Register row E8a's evidence cell reads: "`K_remaining.md` §2.1". The written proof is [Theorem E — determinacy of the plateau onset](tpp-rh40-k-remaining-theorem-e-onset-determinacy.md).

## Dependencies and related results

- Register row E8 (no closed form found), J11 and J12 (refuted onset candidates), E1 (the value), K2 (the problem this partially answers).

## Notes

- The source tags the positive half as "a tautology" — only the negative half is substantive; the row's status is still `PROVED` in the source.
