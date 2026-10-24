# λ n is a sign: λ n ^ 2 = 1 at every n

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_sq`, lines 182–187

## Statement

> `theorem liouville_sq (n : ℕ) : liouville n ^ 2 = 1`

The file's docstring: "**`λ n` is a sign.** `λ n ^ 2 = 1` at *every* `n`, including
`n = 0`."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n` (prime factors with multiplicity); the file's convention is `λ 0 = 1`.
- No hypothesis on `n`: the identity holds at every natural number.

## Proof / evidence

Lean declaration `liouville_sq` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 184–187), proved by `pow_two`, `← pow_add`, `Omega n + Omega n = 2 * Omega n`, and `(even_two_mul (Omega n)).neg_one_pow`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 lists `liouville_sq` among the certified results).

## Dependencies and related results

- Uses Mathlib's `even_two_mul` and `neg_one_pow`.
- Feeds [The trivial bound: |corr h N| ≤ N](lean-rh46-chowla-corr-trivial-bound.md) and [Sharpness of the trivial bound: corr 0 N = N](lean-rh46-chowla-corr-zero-sharpness.md); also [The slice perturbation has ℓ²-mass exactly 4](lean-rh46-chowla-corrslice-perturbation-l2-mass-four.md) via `mul_pow`.
- Companion: [λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md).
- The same statement appears in the scratch draft: [λ n ^ 2 = 1 at every n (λ is a sign)](lean-rh46-scratch-liouville-square-is-one.md).

## Notes

- The declaration is `theorem`, hence Kind Theorem.
