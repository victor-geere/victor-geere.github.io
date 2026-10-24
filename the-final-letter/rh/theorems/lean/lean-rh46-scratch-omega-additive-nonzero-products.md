# Ω is additive on nonzero products

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Scratch3.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch3.lean) — lines 21–25

## Statement

> `theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :`
> `    Omega (m * n) = Omega m + Omega n`

That is: for nonzero natural numbers `m` and `n`, the number of prime factors of `m * n`
counted with multiplicity is the sum of the counts for `m` and for `n`.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n` (the file's local name for Mathlib's prime-factor count, `Ω n = (n.primeFactorsList).length`).
- Hypotheses `hm : m ≠ 0`, `hn : n ≠ 0`; both are used (the proof invokes Mathlib's `cardFactors_mul` with exactly these hypotheses).

## Proof / evidence

Lean declaration `Omega_mul` in `research/twin-prime-parity/rounds/rh46/lean/Scratch3.lean` (lines 21–25), proved by unfolding the local definition and applying Mathlib's `ArithmeticFunction.cardFactors_mul hm hn`. The proof is complete, with no `sorry`.

Re-elaboration check (toolchain `leanprover/lean4:v4.35.0-rc2` + Mathlib4): an identical copy of `Scratch3.lean` reports errors only in the later declarations `liouville_six` and `liouville_mul` (`unsolved goals` at lines 45, 54, 62); `Omega_mul` is accepted with no error and no `sorry`.

## Dependencies and related results

- Uses Mathlib's `ArithmeticFunction.cardFactors_mul`.
- The same declaration name and statement occur in the certified `Rh46/Chowla.lean` (lines 109–113) and in [Ω is additive on nonzero products](lean-rh46-chowla-omega-additive-nonzero-products.md) under the `lean-rh46-chowla` prefix.
- The law is the engine of complete multiplicativity: it is what the nonzero form `liouville_mul` needs, and its absence at `m = 0` is exactly why the unrestricted scratch claim is [false](lean-rh46-scratch-liouville-multiplicativity-refuted.md).

## Notes

- The `Scratch*` family (`Scratch.lean`–`Scratch5.lean`, prefix `lean-rh46-scratch`) was folded; this statement occurs in `Scratch3.lean` only.
- The nonzero hypotheses are essential: `cardFactors 0 = 0`, so at `m = 0` the identity would read `Ω n = 0`.
- The source gives no prose title; the Lean name is `Omega_mul`.
