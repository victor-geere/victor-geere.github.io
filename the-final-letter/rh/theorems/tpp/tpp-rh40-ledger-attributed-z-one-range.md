# Z(L) = 1 ⟺ L ∈ [N−a_m−1, N−1]

**Kind:** Claim
**Status:** VERIFIED (numerical; Agent B for the value, mediator for the exact range)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/ledger.md`](../../research/twin-prime-parity/rounds/rh40/rounds/ledger.md) — "Attributed results (not errors — recorded so credit and status are clear)", row 6

## Statement

> `Z(L) = 1 ⟺ L ∈ [N−a_m−1, N−1]`

## Hypotheses and notation

- `Z(L) = |F(L)| − #{prefixes of F(L+1)}` is the terminal-uniqueness indicator; `N` = truncation length, `a_m` = last support position.
- The interval has `a_m + 1` elements.

## Proof / evidence

The ledger's attributed-results table gives the who/status cells: "Agent B (value), mediator (exact range)" and "`VERIFIED`".

## Dependencies and related results

- Register row C6 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — the same result, harvested as [tpp-rh40-rounds-truths-c6-z-l-one-exact-range.md](tpp-rh40-rounds-truths-c6-z-l-one-exact-range.md).
- The ledger's error rows 6 and 7, which record the mediator's first count `#{L : Z(L)=1} = a_m` as off by one.

## Notes

- **Restatement.** This row restates register entry C6 of `truths.md` (same round, rh40).
