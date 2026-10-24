# Prefix agreement of the slice correlations with corr h N

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corrSlice_eq_corr_of_lt`, lines 377–388

## Statement

> `theorem corrSlice_eq_corr_of_lt {h a N : ℕ} (hN : N + h < a) :`
> `    corrSlice h a N = corr h N`

where `corrSlice h a N = ∑ n ∈ Finset.Icc 1 N, liouvilleSlice a n * liouvilleSlice a (n + h)` and
`corr h N = ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)`.

The file's docstring: "**Prefix agreement of the correlations.** For every prefix with
`N + h < a` the slice has exactly the same correlation as `λ`: the values `corr h 1, …,
corr h N` carry no information that could distinguish `λ` from a function differing from
it at a later index."

## Hypotheses and notation

- `λ^{(a)}` is `λ` with the value at index `a` negated; `corrSlice` is its two-point correlation.
- Hypothesis `hN : N + h < a` (the prefix is short enough that neither `n` nor `n + h` reaches the flipped index).

## Proof / evidence

Lean declaration `corrSlice_eq_corr_of_lt` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 381–388): `Finset.sum_congr` plus `slice_agree` on both `n` and `n + h`, with the index inequalities closed by `omega`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 lists it in the certified slice layer).

## Dependencies and related results

- Uses [Prefix agreement of the slice with λ](lean-rh46-chowla-slice-prefix-agreement.md).
- Companion: [The slice perturbation has ℓ²-mass exactly 4](lean-rh46-chowla-corrslice-perturbation-l2-mass-four.md).
- This is the second half of the round's logical core; the README harvest is [§1.4 — prefix agreement does not determine the correlation asymptotic](../tpp/tpp-rh46-readme-prefix-agreement-indeterminacy.md).

## Notes

- The source states the consequence in prose: because the perturbation at `a` is nonzero, two functions agreeing on an arbitrarily long prefix can have different correlation sums, so no pointwise or finite-prefix argument can prove `corrAsymptotic h`. The file does **not** assert `corrAsymptotic 2` (two-point Chowla is open).
- The declaration is `theorem`, hence Kind Theorem.
