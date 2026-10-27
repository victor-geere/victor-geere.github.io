# The slice perturbation has ℓ²-mass exactly 4

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corrSliceSqSub`, lines 390–405

## Statement

> `theorem corrSliceSqSub {a N : ℕ} (ha : 1 ≤ a) (haN : a ≤ N) :`
> `    ∑ n ∈ Finset.Icc 1 N, (liouvilleSlice a n - liouville n) ^ 2 = 4`

The file's docstring: "**The slice perturbation has `ℓ²`-mass exactly `4`.** On a prefix
containing the flipped index exactly one index contributes, and it contributes `(±2)²`."

## Hypotheses and notation

- `liouvilleSlice a` is `λ` with the value at index `a` negated; the sum runs over `1 ≤ n ≤ N`.
- Hypotheses `ha : 1 ≤ a`, `haN : a ≤ N`, so the flipped index lies inside the summed prefix.

## Proof / evidence

Lean declaration `corrSliceSqSub` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 392–405): the pointwise perturbation `liouvilleSlice a n - liouville n` is `-2 λ(a)` at `n = a` and `0` otherwise (`slice_sub_self`, line 323), so the summand is `4` exactly at `n = a` (`mul_pow`, `liouville_sq`), and `Finset.sum_ite_eq'` reduces the sum to `4`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 lists it in the certified slice layer).

## Dependencies and related results

- Uses `slice_sub_self` (pointwise perturbation, line 323) and [λ n is a sign: λ n ^ 2 = 1 at every n](lean-rh46-chowla-liouville-square-is-one.md).
- Companion prefix statement: [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md).
- The file header (lines 57–60) names this and `corrSlice_eq_corr_of_lt` as the rigorously proved companions of the perturbed-correlation identity that is only stated in a comment: [The exact perturbation of the correlation by one sign flip](lean-rh46-chowla-corrslice-perturbation-identity.md).

## Notes

- The source's `slice_sub_self` is not harvested separately: it is the definitional case-split that this theorem uses, and its exact content is quoted here.
- The declaration is `theorem`, hence Kind Theorem.
