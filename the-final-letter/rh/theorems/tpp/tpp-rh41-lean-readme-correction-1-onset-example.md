# Correction 1 — the printed onset example is interchanged

**Kind:** Claim
**Status:** PROVED (Lean; gap-sequence part by `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 1

## Statement

> **Theorem 6 / §5 row "the onset is a function of the gaps".** The printed example has the two onsets interchanged. With `N = 6` the complexity profiles are `{0,2} ↦ (2,3,4,3,2,1)` and `{1,3} ↦ (2,3,3,3,2,1)`, so the onsets are `3` and `2`, not `2` and `3`. `rigorous_check.py::onset` computes the corrected values, and `DigitWord.onset_not_determined_by_gaps` proves them.

## Hypotheses and notation

- The two supports are `{0,2}` (i.e. `a_0 = 0`, gaps `(2,)`) and `{1,3}` (i.e. `a_0 = 1`, same gap sequence), both with truncation `N = 6`.
- The complexity profiles are listed as tuples `(p(1), p(2), …)`; the onset is the first `L` at which the profile attains its maximum.
- `rigorous_check.py::onset` is the round's Python ground-truth function.

## Proof / evidence

The source gives the two profiles explicitly and names the machine-checked declaration `DigitWord.onset_not_determined_by_gaps`, whose gap-sequence part uses `native_decide` (per the README's "Trust and methodology" section). The corrected values are computed by `rigorous_check.py::onset`; the round's cross-check table verifies "Theorem 6 onsets" in 2 cases.

## Dependencies and related results

- [Theorem 6 (onset determinacy)](tpp-rh41-truths-theorem-6-onset-determinacy.md) — the theorem being corrected.
- [Refuted — the onset is a function of the gaps](tpp-rh41-truths-refuted-onset-function-of-gaps.md) — the §5 ledging row carrying the interchanged example.

## Notes

- This is a **correction of a printed example only**: the conclusion of Theorem 6 (the onset is not determined by `(gap sequence, N)`) is unaffected.
- `native_decide` means the gap-sequence part relies on the Lean compiler (`Lean.ofReduceBool`) rather than pure kernel reduction; the README lists the affected declarations explicitly.
