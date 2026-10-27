# The pole pair collapses to one term for a transform even about `1/2`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean`](../../research/twin-prime-parity/rounds/rh45/lean/Rh45/Explicit.lean) — §4 "The pole pair", lines 216–230; declaration `Rh45.polePair_eq`

## Statement

> **The pole pair collapses to one term.** If the transform is even about `1/2`, i.e. `F (1 - x) = F x` for all `x`, then `F 0 = F 1` and the two pole contributions coincide:
> `polePair F = 2 * F (1/2 + 1/2)`.
>
> This is the algebraic core of "the pole `s = 1` contributes one term"; the factor `2` is the multiplicativity of the count, not a second pole.

## Hypotheses and notation

- `F : ℝ → ℝ` — the test function ("transform"), viewed as a function of the spectral variable `s`.
- Hypothesis `hF : ∀ x, F (1 - x) = F x` — `F` is even about `1/2`.
- `polePair F = F (1/2 + 1/2) + F (1/2 - 1/2) = F 1 + F 0` — the two pole contributions `s = 1` and `s = 0` of the explicit formula (definition, line 210).

## Proof / evidence

Complete Lean proof, no `sorry` (file header, lines 55–56). Declaration `Rh45.polePair_eq` in `Rh45/Explicit.lean` (lines 223–230): from `hF 1` one gets `F 0 = F 1`, then `polePair_def` and `ring` give `polePair F = 2 * F (1/2 + 1/2)`. The file elaborates successfully via `lean/check.sh` (`verify/lean_check.log`: `[check] OK   Rh45/Explicit.lean (29s)`).

## Dependencies and related results

- `Rh45.polePair_def : polePair F = F 1 + F 0` (line 213, an elementary normalisation, not harvested separately).
- [The `s ↔ 1 − s` symmetry of the shifted Cauchy and Gaussian kernels about `s = 1/2`](lean-rh45-explicit-shifted-kernels-symmetric-about-half.md) — supplies transforms even about `1/2`.

## Notes

- The source's docstring stresses that the factor `2` is "the multiplicativity of the count, not a second pole"; this caveat is quoted in the Statement and must not be misread as two coincident poles.
