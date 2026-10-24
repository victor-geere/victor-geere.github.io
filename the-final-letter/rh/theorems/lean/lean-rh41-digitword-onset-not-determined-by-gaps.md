# Theorem 6 (onset determinacy) — the onset is not determined by the gap sequence

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; the finite instances are closed by `native_decide` and `decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 540–548, declaration `Rh41.onset_not_determined_by_gaps`

## Statement

> **Theorem 6 (onset determinacy).** The onset is *not* a function of `(gap sequence, N)`: the supports `{0,2}` and `{1,3}` have the same gap sequence and the same truncation `N = 6`, but onsets `3` and `2`.
>
> (Note: the example printed in `TRUTHS.md` §5 interchanges these two values; this statement is the one checked by `rh41/rigorous_check.py`.)

Formally (Lean 4 / Mathlib):

```lean
theorem onset_not_determined_by_gaps :
    gapSeq ({0, 2} : Finset ℕ) = gapSeq ({1, 3} : Finset ℕ) ∧
      IsOnset ({0, 2} : Finset ℕ) 6 3 ∧ IsOnset ({1, 3} : Finset ℕ) 6 2
```

where `gapSeq S` is the list of consecutive gaps of `S` and

```lean
def IsOnset (S : Finset ℕ) (N on : ℕ) : Prop :=
  1 ≤ on ∧ on ≤ N ∧ complexity S N on = (Icc 1 N).sup (fun L => complexity S N L) ∧
    ∀ L, 1 ≤ L → L < on → complexity S N L < complexity S N on
```

## Hypotheses and notation

- `S = {0,2}` and `S = {1,3}` — the two supports; both have gap sequence `[2]` and truncation `N = 6`.
- `IsOnset S N on` — `on` is the least `L ∈ [1,N]` at which `p` attains its maximum over `[1,N]`.
- Asserted onsets: `3` for `{0,2}`, `2` for `{1,3}`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.onset_not_determined_by_gaps` in `Rh41/DigitWord.lean` (lines 546–553). The gap-sequence equality is by `native_decide`; each `IsOnset` conjunct is by `decide`, and the minimality clauses over `L` are closed with `interval_cases L <;> decide`.

## Dependencies and related results

- [`Rh41.DigitWord.complexity`](lean-rh41-digitword-main-complexity-law.md), `IsOnset`, `gapSeq` — the definitions in the same file.

## Notes

- This theorem is also a correction of the printed example: "the example printed in `TRUTHS.md` §5 interchanges these two values; this statement is the one checked by `rh41/rigorous_check.py`."
- The `Rh41/Alphabet.lean` header records the same correction in prose.
