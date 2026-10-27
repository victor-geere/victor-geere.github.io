# Row 3 refuted — p(L) = L + 1 + #{distinct distances ≤ L}

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 578–581, declaration `Rh41.refuted_dist_count_formula`

## Statement

> Refuted: `p(L) = L + 1 + #{distinct distances ≤ L}` (row 3); `1/π`, `L = 11`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_dist_count_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 11 = 12 ∧
      11 + 1 + distCount ({2, 13, 607} : Finset ℕ) 11 = 13
```

where `distCount S L` is "the number of distinct distances at most `L` between support points" (line 560).

## Hypotheses and notation

- Witness: `S = {2, 13, 607}` (the `1/π` support at `N = 1400`), `L = 11`.
- True value `p(11) = 12`; the formula predicts `11 + 1 + distCount S 11 = 13`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_dist_count_formula` in `Rh41/DigitWord.lean` (lines 579–582), both conjuncts by `native_decide`.

## Dependencies and related results

- [Row 2 refuted — the pair-count formula](lean-rh41-digitword-pair-count-formula-refuted.md) — same witness and `L`, with `pairCount` in place of `distCount`.

## Notes

- Row 3 of the refuted-formula table of `TRUTHS.md` §5.
