# C1 — p(L) = L + 1 for 1 ≤ L ≤ min gap

**Kind:** Claim
**Status:** VERIFIED (numerical, `probes.py` probe 3: 2 000/2 000 random trials)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §C "The greedy word itself", register row C1

## Statement

> `p(L) = L + 1` for `1 ≤ L ≤ min gap`

## Hypotheses and notation

- `p(L) = #{ distinct length-L factors of w }` (register row A1).
- `min gap` is `min_j d_j`, the smallest consecutive gap `d_j = a_j − a_{j−1}` of the support `a_0 < … < a_m`.

## Proof / evidence

Register row C1's evidence cell reads: "`probes.py` probe 3: 2 000/2 000 random trials". The source states this without proof.

## Dependencies and related results

- Register row F1 (**Theorem D**), which proves the C1 law in the strictly larger regime `L ≤ min(min_j d_j, a_0, N − a_0 − 1)`.
- Register row F2, which records that the C1 regime extends strictly below the next gap, so this row's range badly understates it.
- Register row F3 (the exact formulation) and F4 (no closed form in the gaps alone).

## Notes

- The row is the original C1 law; the source's later Theorem D (row F1) supersedes the range but keeps the statement.
