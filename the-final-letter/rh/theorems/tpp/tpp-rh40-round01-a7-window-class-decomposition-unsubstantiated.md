# A7 — window-class decomposition T(i,j) with union cardinality

**Kind:** Claim
**Status:** **REFUTED as stated / repaired (2026-10-11 attack; OP-34).** The class sum over-counts `p(L)` on **604/1399** `L` for `x = 1/π` (the classes are not disjoint); the corrected collision criterion `factor(t)=factor(t') ⟺ x(t)=x(t') ∧ shape(t)=shape(t')` and the exact shape-union formula `p(L) = [∃all-zero] + Σ_shapes |⋃_{C: shape} X(C)|` are **PROVED** (6 378 064 exhaustive cases, 0 mismatches). See `research/attacks/OP-34-36-37-35.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.2 "From Agent A", verdict-table row A7

## Statement

> window-class decomposition `T(i,j)` with union cardinality

## Hypotheses and notation

- `T(i,j)` is Agent A's window-class decomposition; "union cardinality" means the count is taken over the union of the classes rather than their sum.
- The source reports A's own estimate of 1–2 % over-counting.

## Proof / evidence

The verdict-table row's verdict reads: "**UNSUBSTANTIATED**"; its mediator check reads: "A marks it `[DREAM]` himself and reports 1–2 % over-counting. The mediator did not attempt it; it is round 2 material".

## Dependencies and related results

- Register rows F3, F4 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) (the exact C1 formulation and the refuted candidates); row A8 of the same table.
- The ledger records the related refuted encoding (row 25 of `ledger.md`: the `(i, x, jmax)` and `(i, x)` encodings are not injective).

## Notes

- Harvested because it is a labelled claim in the verdict table, with status honestly recorded as untested; the source itself calls it `[DREAM]`.
