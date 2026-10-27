# Prefix agreement of the slice with λ

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `slice_agree`, lines 329–333

## Statement

> `theorem slice_agree {a n : ℕ} (hn : n < a) : liouvilleSlice a n = liouville n`

where the slice is defined by

> `def liouvilleSlice (a n : ℕ) : ℤ := if n = a then -liouville a else liouville n`

i.e. `λ^{(a)}` is `λ` with the *value* at the single index `a` negated, and it agrees
with `λ` at every index below `a`.

## Hypotheses and notation

- `λ(n) = (-1)^{Ω(n)}`; `λ^{(a)}(n) = -λ(a)` if `n = a` and `= λ(n)` otherwise.
- Hypothesis `hn : n < a`.

## Proof / evidence

Lean declaration `slice_agree` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 332–333), proved by unfolding `liouvilleSlice` and discharging the `if` with `Nat.ne_of_lt hn`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 lists `slice_agree` in the certified slice layer).

## Dependencies and related results

- Uses the definition `liouvilleSlice` (line 316) and `Nat.ne_of_lt`.
- Used by [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).
- Companion statements in the same section: `slice_self` (`λ^{(a)}(a) = -λ(a)`, line 319, skipped as a `_self`/definitional lemma), `slice_sub_self` (line 323, skipped as definitional unfolding), `slice_ne_self_iff` (lines 344–357), `slice_ne` ([λ modified at a nonzero index is not λ](lean-rh46-chowla-slice-differs-from-liouville.md)).
- The README harvest of the round's prefix-indeterminacy claim is [§1.4 — prefix agreement does not determine the correlation asymptotic](../tpp/tpp-rh46-readme-prefix-agreement-indeterminacy.md).

## Notes

- This is the first half of the round's logical core (README §1.4): a function differing from `λ` at index `a` is indistinguishable from `λ` on every prefix shorter than `a`.
- The declaration is `theorem`, hence Kind Theorem.
