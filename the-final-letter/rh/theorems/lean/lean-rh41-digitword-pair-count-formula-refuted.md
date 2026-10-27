# Row 2 refuted — p(L) = L + 1 + #{pairs at distance ≤ L}

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 572–575, declaration `Rh41.refuted_pair_count_formula`

## Statement

> Refuted: `p(L) = L + 1 + #{pairs at distance ≤ L}` (row 2); `1/π`, `L = 11`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_pair_count_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 11 = 12 ∧
      11 + 1 + pairCount ({2, 13, 607} : Finset ℕ) 11 = 13
```

where `pairCount S L = ((S.product S).filter (fun p => p.1 < p.2 ∧ p.2 - p.1 ≤ L)).card` is "the number of support pairs at distance at most `L`" (line 555).

## Hypotheses and notation

- Witness: the support of the `1/π` digit word truncated at `N = 1400`, namely `S = {2, 13, 607}` (its gaps are `11` and `594`), at `L = 11`.
- True value `p(11) = 12`; the formula predicts `11 + 1 + pairCount S 11 = 13`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_pair_count_formula` in `Rh41/DigitWord.lean` (lines 573–576), both conjuncts by `native_decide`.

## Dependencies and related results

- [Row 3 refuted — the distinct-distance formula](lean-rh41-digitword-dist-count-formula-refuted.md) — the same witness and `L`, with `distCount` in place of `pairCount`.

## Notes

- Row 2 of the refuted-formula table of `TRUTHS.md` §5. `native_decide` means the finite instance is settled by compiled evaluation of a decidable proposition.
