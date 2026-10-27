# The large-L law p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/ledger.md`](../../research/twin-prime-parity/rounds/rh40/rounds/ledger.md) — "Attributed results (not errors — recorded so credit and status are clear)", row 3

## Statement

> The large-`L` law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position; `p(L) = #{ distinct length-L factors of w }`.
- `[·]` is the Iverson indicator; the law holds on `max(span, a_m+1) ≤ L ≤ N−1` (register row E7).

## Proof / evidence

The ledger's attributed-results table gives the who/status cells: "**mediator**" and "`PROVED`". The written proof is [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).

## Dependencies and related results

- Register row E7 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — the same result, harvested as [tpp-rh40-rounds-truths-e7-large-l-law-theorem-a.md](tpp-rh40-rounds-truths-e7-large-l-law-theorem-a.md).
- The same table's row 4 (the decay corollary) and row 2 (the plateau value).

## Notes

- **Restatement.** This row restates register entry E7 of `truths.md` (same round, rh40); it is the ledger's own attribution of the proof to the mediator.
