# λ modified at a nonzero index is not λ

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `slice_ne`, lines 359–364

## Statement

> `theorem slice_ne (a : ℕ) (ha : a ≠ 0) : liouvilleSlice a ≠ liouville`

where `liouvilleSlice a n = if n = a then -liouville a else liouville n`. I.e. the
sign-flipped function is a genuinely different function from `λ` whenever the flipped
index is nonzero.

## Hypotheses and notation

- `liouvilleSlice a` is `λ` with the value at the single index `a` negated.
- Hypothesis `ha : a ≠ 0`.

## Proof / evidence

Lean declaration `slice_ne` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 360–364): if the two functions were equal, evaluating at `a` would give `-λ(a) = λ(a)`, hence `λ(a) = 0`, contradicting `liouville_ne_zero ha`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`).

## Dependencies and related results

- Uses `slice_self` (line 319) and `liouville_ne_zero` (line 180).
- Concrete instance: `slice_two_corr_two` (`liouvilleSlice 2 2 ≠ liouville 2`, lines 434–438), not harvested separately as a concrete evaluation.
- Related: [Prefix agreement of the slice with λ](lean-rh46-chowla-slice-prefix-agreement.md) (the slice is nonetheless invisible below `a`).

## Notes

- The hypothesis `ha : a ≠ 0` is necessary as written: the `a = 0` slice would flip `λ(0) = 1` to `-1`, which still differs from `λ` — but the file's proof routes through `liouville_ne_zero`, which requires `a ≠ 0`; the harvested statement is exactly the source's.
- The declaration is `theorem`, hence Kind Theorem.
