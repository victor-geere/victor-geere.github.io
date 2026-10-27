# Refuted — the onset is a function of the gaps

**Kind:** Claim
**Status:** REFUTED (counterexample: `gaps=(2,)`, `N=6`: onset 2 for `(0,2)`, 3 for `(1,3)`; the onsets are in fact 3 and 2)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> the onset is a function of the gaps
>
> counterexample: `gaps=(2,)`, `N=6`: onset 2 for `(0,2)`, 3 for `(1,3)`.

## Hypotheses and notation

- The onset is `onset(w) = min{ L : p(L) = max p }`, as in [Theorem 6](tpp-rh41-truths-theorem-6-onset-determinacy.md); "the gaps" is the gap sequence of the support.
- The witness is the gap sequence `(2,)` with `N = 6` and the two supports `(0,2)` and `(1,3)` (differing only in absolute position `a_0`).

## Proof / evidence

The counterexample is displayed in the source's §5 table and is the content of [Theorem 6](tpp-rh41-truths-theorem-6-onset-determinacy.md).

Machine-checked as `DigitWord.onset_not_determined_by_gaps`; the gap-sequence part uses `native_decide`.

## Dependencies and related results

- [Theorem 6 (onset determinacy)](tpp-rh41-truths-theorem-6-onset-determinacy.md) — the numbered form of this refutation.
- [Correction 1 — the printed onset example is interchanged](tpp-rh41-lean-readme-correction-1-onset-example.md).

## Notes

- **The printed witness values are wrong and are corrected by the round's Lean README:** with `N = 6` the profiles are `{0,2} ↦ (2,3,4,3,2,1)` and `{1,3} ↦ (2,3,3,3,2,1)`, so the onsets are `3` and `2`, not `2` and `3`. The values `2` and `3` above are quoted from `TRUTHS.md` exactly as printed; the refuted claim itself (onset is a function of the gaps) stands.
- The source adds the row under the heading "Refuted — do not re-propose".
