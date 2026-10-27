# Row 4 refuted — the gap-deficit formula p(L) = L + 1 + Σ max(0, L - d_j)

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 584–589, declaration `Rh41.refuted_gap_deficit_formula`

## Statement

> Refuted: the gap-deficit formula (row 4); `1/π`, `L = 20`. The two gaps of the support are `11` and `594`, so `Σ max(0, L - d_j) = 9` and the formula reads `21 + 9 = 30`, while `p(20) = 24`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_gap_deficit_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 20 = 24 ∧
      20 + 1 + (max 0 (20 - (13 - 2)) + max 0 (20 - (607 - 13))) = 30
```

## Hypotheses and notation

- Witness: `S = {2, 13, 607}`, `N = 1400`, `L = 20`.
- The two gaps of `S` are `13 - 2 = 11` and `607 - 13 = 594`; the deficit sum is `max 0 (20 - 11) + max 0 (20 - 594) = 9`.
- True value `p(20) = 24`; the formula reads `20 + 1 + 9 = 30`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_gap_deficit_formula` in `Rh41/DigitWord.lean` (lines 587–590): the first conjunct by `native_decide`, the arithmetic second conjunct by `norm_num`.

## Dependencies and related results

- [Row 5 refuted — the linear-slope formula](lean-rh41-digitword-slope-formula-refuted.md) — the same support, `L = 100`.

## Notes

- Row 4 of the refuted-formula table of `TRUTHS.md` §5.
