# Sharpness of the trivial bound: corr 0 N = N

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corr_zero`, lines 224–234

## Statement

> `theorem corr_zero (N : ℕ) : corr 0 N = N`

i.e. `S(x, 0) = x`. The file's docstring: "**Sharpness of the trivial bound.** `corr 0 N
= N` for all `N`. For a function that is identically `1` the correlation is likewise
exactly `N`, so any argument using only `|λ| = 1` cannot yield a bound better than `N`."

## Hypotheses and notation

- `corr h N = ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)`.
- No hypothesis on `N : ℕ`.

## Proof / evidence

Lean declaration `corr_zero` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 227–234): every summand is `λ(n) * λ(n + 0) = λ(n)^2 = 1` by `liouville_sq`, so the sum is the cardinality `N`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §1.1 and §5 record the row "`S(x,0) = x` (λ(n)² = 1)" as PROVED with `corr_abs_le`, `corr_zero`).

## Dependencies and related results

- Uses [λ n is a sign: λ n ^ 2 = 1 at every n](lean-rh46-chowla-liouville-square-is-one.md).
- Together with `corr_abs_le` it shows the trivial bound is attained; the asymptotic consequence is [corrAsymptotic 0 is false](lean-rh46-chowla-corr-asymptotic-zero-false.md).
- The README harvest of this row is [§1.1 — the trivial two-point bounds `|S(x,h)| ≤ x`, `S(x,0) = x`](../tpp/tpp-rh46-readme-trivial-two-point-bounds.md).

## Notes

- The docstring's comparison with `λ ≡ 1` is the source's own justification that boundedness plus multiplicativity cannot by itself give `o(x)`.
