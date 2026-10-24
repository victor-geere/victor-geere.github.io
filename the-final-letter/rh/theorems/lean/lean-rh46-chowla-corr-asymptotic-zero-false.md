# corrAsymptotic 0 is false

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corrAsymptotic_zero_false`, lines 236–253

## Statement

> `theorem corrAsymptotic_zero_false : ¬ corrAsymptotic 0`

with the file's definition

> `def corrAsymptotic (h : ℕ) : Prop :=`
> `  ∀ ε > 0, ∃ X, ∀ N ≥ X, |((corr h N : ℤ) : ℝ)| ≤ ε * N`

The file's docstring: "`corrAsymptotic 0` is **false**: `corr 0 N = N` never satisfies
`|corr 0 N| ≤ ε * N` for `ε < 1` and large `N`. The only asymptotic statement in the
file; it shows that `corrAsymptotic` is a genuine restriction."

## Hypotheses and notation

- `corr h N = ∑_{1 ≤ n ≤ N} λ(n)λ(n + h)`; `corrAsymptotic h` is the assertion `S(x,h) = o(x)` in ε-`X` form.
- The theorem is the negation at `h = 0`.

## Proof / evidence

Lean declaration `corrAsymptotic_zero_false` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 239–253): take `ε = 1/2` and `N > max(X, 1)`; then `|corr 0 N| = N > N/2`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §5 row: "the correlation of `λ ≡ 1` is `x`, so `o(x)` is not formal | **PROVED** (Lean: `corrAsymptotic_zero_false`)").

## Dependencies and related results

- Uses [Sharpness of the trivial bound: corr 0 N = N](lean-rh46-chowla-corr-zero-sharpness.md).
- Restates in the file's §7 packaging `corrAsymptotic_reading` (lines 451–458), which is skipped in this harvest because its content is the conjunction of this theorem, [Prefix agreement of the slice correlations with corr h N](lean-rh46-chowla-corrslice-prefix-agreement.md), and a vacuous `→ True` conjunct.
- The README harvest of the same point is [§1.1 — the correlation of `λ ≡ 1` is exactly `x`, so `o(x)` is not formal](../tpp/tpp-rh46-readme-correlation-zero-asymptotic-false.md).

## Notes

- The source is explicit that this is the **only** asymptotic fact proved in the file and that it says nothing about `h ≠ 0`: "Nothing here asserts `corrAsymptotic 2`, or any `corrAsymptotic h` with `h ≠ 0`". Two-point Chowla (`corrAsymptotic 2`) is open (file header, lines 62–64).
- The declaration is `theorem`, hence Kind Theorem.
