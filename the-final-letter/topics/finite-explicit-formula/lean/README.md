# Lean build

`./check.sh` compiles `Topic.lean` against the shared Mathlib at `~/lean/mathlib4`.
No `sorry`, no `axiom`, no `admit`.

Formalised:

- `tent`, `tentAutocorr`;
- `tent_nonneg`;
- `tent_continuous`;
- `integral_tent_sq`;
- `integral_tent`;
- `integral_g01`;
- `integral_g12`;
- `integral_g02`, `integral_tentAutocorr`;
- `autocorr_at_zero`;
- `tent_zero`, `tent_one`;
- `autocorr_at_one`;
- `autocorr_at_three_halves`;
- `autocorr_at_five_halves`, `autocorr_at_two`;
- `tentAutocorr_eq_zero_of_two_le`, `autocorr_eq_zero_of_two_le`, `autocorr_outside_support`;
- `autocorr_between_one_two`;
- `autocorr_between_neg_two_neg_one`;
- `tentAutocorr_one`, `tentAutocorr_two`;
- `tentAutocorr_nonneg`;
- `tentAutocorr_even`;
- `tentAutocorr_pos`;
- `term2Value_negative` (the `n=2` prime term, in `PrimeSide.lean`);
- `primeSideValue_negative` (the full five-term prime side, in `PrimeSide.lean`).

Not formalised:

- the fact that `tentAutocorr` is the convolution `f*f`;
- the Fourier transform `ĝ = |f̂|²`;
- the explicit formula, the archimedean term and the zero side.

The Python layer certifies the finite prime side with `mpmath.iv`; it is a
computation, not a Lean theorem.
