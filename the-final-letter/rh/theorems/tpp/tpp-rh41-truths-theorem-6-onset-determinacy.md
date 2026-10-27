# Theorem 6 (onset determinacy)

**Kind:** Theorem
**Status:** PROVED (Lean; gap-sequence part by `native_decide`; printed example corrected)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §2 "Auxiliary structure"

## Statement

> **Theorem 6 (onset determinacy).** Write `onset(w) = min{ L : p(L) = max p }`. Then `onset` is **not** determined by `(gap sequence, N)` (3 896 of 7 521 keys are multi-valued), while it is trivially determined by `(gap sequence, N, a_0)` since those determine the support. So any formula for the onset must use absolute positions, not just the gaps.

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, truncation length `N`, `p(L)` the number of distinct length-`L` factors.
- `onset(w) = min{ L : p(L) = max p }` is the first length at which the factor count attains its maximum.
- A key `(gap sequence, N)` is **multi-valued** when two supports with the same gap sequence and the same `N` (hence different `a_0`) give different onsets.
- `a_0` is the absolute position of the first support point; the gap sequence alone fixes only the shape, not the position.

## Proof / evidence

The source gives the exhaustive count `3 896 of 7 521` keys multi-valued as the certificate for non-determinacy; the positive half (`(gap sequence, N, a_0)` determines the support, hence the onset) is a triviality, since absolute positions are determined by `a_0` together with the gaps.

Machine-checked as `DigitWord.onset_not_determined_by_gaps` in `Rh41/DigitWord.lean`; the gap-sequence part of this declaration uses `native_decide`. The corrected onset values are computed by `rigorous_check.py::onset` and cross-checked in 2 cases.

## Dependencies and related results

- [Refuted — the onset is a function of the gaps](tpp-rh41-truths-refuted-onset-function-of-gaps.md) — the §5 ledger row of the same content, with the printed example.
- [Correction 1 — the printed onset example is interchanged](tpp-rh41-lean-readme-correction-1-onset-example.md).
- The signed-round sequel: [The onset is still not determined by (gaps, N)](tpp-rh42-truths-onset-not-determined-by-gaps.md).
- Restated by the §5 ledger row "the onset is a function of the gaps" (same round).

## Notes

- The source's printed example for this theorem is **wrong** and is corrected by the round's Lean README: with `N = 6` the complexity profiles are `{0,2} ↦ (2,3,4,3,2,1)` and `{1,3} ↦ (2,3,3,3,2,1)`, so the onsets are `3` and `2`, not `2` and `3`. The theorem's conclusion (non-determinacy) is unaffected.
- The count `3 896 of 7 521` is quoted exactly as printed.
