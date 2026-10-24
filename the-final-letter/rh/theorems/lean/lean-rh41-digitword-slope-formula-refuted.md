# Row 5 refuted — the linear-slope formula p(L) = 2L - 10 on 12 ≤ L ≤ 593

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 592–596, declaration `Rh41.refuted_slope_formula`

## Statement

> Refuted: the linear-slope formula `p(L) = 2L - 10` on `12 ≤ L ≤ 593` (row 5); `1/π`, `L = 100`: `p(100) = 104`, the formula reads `190`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_slope_formula :
    complexity ({2, 13, 607} : Finset ℕ) 1400 100 = 104 ∧ 2 * 100 - 10 = 190
```

## Hypotheses and notation

- Witness: `S = {2, 13, 607}`, `N = 1400`, `L = 100` (within the claimed range `12 ≤ L ≤ 593`).
- True value `p(100) = 104`; the formula predicts `2·100 - 10 = 190`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_slope_formula` in `Rh41/DigitWord.lean` (lines 594–597): first conjunct by `native_decide`, the arithmetic second conjunct by `norm_num`.

## Dependencies and related results

- [Row 4 refuted — the gap-deficit formula](lean-rh41-digitword-gap-deficit-formula-refuted.md) — same support, `L = 20`.
- [Theorem 12 (impossibility half) — no linear profile](lean-rh41-impossibility-no-linear-growth.md) — the structural reason a linear growth law must fail.

## Notes

- Row 5 of the refuted-formula table of `TRUTHS.md` §5. The observed `p` is far below the proposed slope `2`.
