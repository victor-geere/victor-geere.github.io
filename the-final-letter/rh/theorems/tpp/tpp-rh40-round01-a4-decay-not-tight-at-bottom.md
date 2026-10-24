# A4 — decay p(L) = N − L + 1 for L ≥ N − a_m

**Kind:** Claim
**Status:** VERIFIED (numerical; true but not tight at the bottom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.2 "From Agent A", verdict-table row A4

## Statement

> decay `p(L) = N − L + 1` for `L ≥ N − a_m`

## Hypotheses and notation

- Word: 1/π, support `(2, 13, 607)`, `N = 1400`, so `N − a_m = 793`.
- The tight range is `L ∈ [N − a_m − 1, N − 1]` (register row E5 of `truths.md`).

## Proof / evidence

The verdict-table row's verdict reads: "**TRUE but not tight at the bottom**"; its mediator check reads: "A wrote `L ≥ N − a_m` with `N − a_m = 793`; the laws holds there (p(793) = 608), but it also holds at `L = 792`, which A's inequality excludes. The tight range is `L ∈ [N − a_m − 1, N − 1]`, and its lower end is the crossover point the whole round is about".

## Dependencies and related results

- Register rows E5, D5 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md); rows B7 and M3 of the same table; ledger error row 5.
- Row M3's off-by-one ("decay begins at `N − a_m = 792`") is the error this row corrects.

## Notes

- The statement as A wrote it is true but weaker than the truth; the source records the tight range without altering A's inequality in the statement cell.
