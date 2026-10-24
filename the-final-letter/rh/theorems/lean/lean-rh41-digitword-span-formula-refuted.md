# Row 6 refuted — the span formula p(L) = min(L + span, N - L + 1)

**Kind:** Theorem
**Status:** REFUTED (Lean counterexample, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 598–603, declaration `Rh41.refuted_span_formula`

## Statement

> Refuted: `p(L) = min(L + span, N - L + 1)` (row 6); support `{139,151}`, `N = 172`, `L = 13`: `p(13) = 15`, the formula reads `min 25 160 = 25`.

Formally (Lean 4 / Mathlib):

```lean
theorem refuted_span_formula :
    complexity ({139, 151} : Finset ℕ) 172 13 = 15 ∧
      min (13 + (151 - 139)) (172 - 13 + 1) = 25
```

## Hypotheses and notation

- Witness: `S = {139, 151}` (span `151 - 139 = 12`), `N = 172`, `L = 13`.
- True value `p(13) = 15`; the formula reads `min (13 + 12) (172 - 13 + 1) = min 25 160 = 25`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.refuted_span_formula` in `Rh41/DigitWord.lean` (lines 600–604): first conjunct by `native_decide`, arithmetic by `norm_num`.

## Dependencies and related results

- [Row 1 refuted — the unrestricted main formula](lean-rh41-digitword-main-formula-refuted.md) — the same formula family, whose `min(a_m+1, N-L+1)` form is correct only under `L ≥ a_m + 1`.
- [Theorem 5 (C1 regime)](lean-rh41-digitword-c1-regime-theorem-5.md) — gives `p(L) = L + 1` precisely when `L ≤ min(min gap, a_0, N - a_0 - 1)`; here `L = 13` exceeds the gap `12`.

## Notes

- Row 6 of the refuted-formula table of `TRUTHS.md` §5. The witness violates the bound `L ≤ min gap` of Theorem 5.
