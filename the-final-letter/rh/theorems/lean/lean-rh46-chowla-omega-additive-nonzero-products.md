# Ω is additive on nonzero products

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `Omega_mul`, lines 108–113

## Statement

> `theorem Omega_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :`
> `    Omega (m * n) = Omega m + Omega n`

That is: for nonzero naturals `m`, `n`, the number of prime factors of `m * n` counted
with multiplicity equals the sum of the counts for `m` and `n`.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n`, i.e. `Ω n = (n.primeFactorsList).length` — Mathlib's prime-factor count, counted with multiplicity.
- Hypotheses `hm : m ≠ 0`, `hn : n ≠ 0`. Both are necessary: `Ω 0 = 0`, so at `m = 0` the identity would read `Ω n = 0`.

## Proof / evidence

Lean declaration `Omega_mul` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 109–113); the proof unfolds `Omega` to `ArithmeticFunction.cardFactors` and applies Mathlib's `ArithmeticFunction.cardFactors_mul hm hn`. The proof is complete — the file contains no `sorry`.

The file is certified in the round: `verify/lean_check.log` records `[check] OK   Rh46/Chowla.lean (23s)` and the README §4 records "**CERTIFIED** — 456 lines, **38 theorems**, 7 definitions, `./check.sh --all` **exit 0**, no `sorry`/`admit`/`axiom`/`native_decide`".

## Dependencies and related results

- Mathlib's `ArithmeticFunction.cardFactors_mul`; the local definition `Omega` (`def Omega`, line 84).
- Used by [Complete multiplicativity of λ, nonzero form](lean-rh46-chowla-liouville-completely-multiplicative.md), which turns additivity of `Ω` into multiplicativity of `λ` via `pow_add`.
- The same statement is carried by `Scratch3.lean` under the separate prefix `lean-rh46-scratch`: [Ω is additive on nonzero products](lean-rh46-scratch-omega-additive-nonzero-products.md).

## Notes

- The source gives this result the docstring "`Omega` is additive on nonzero products."; there is no numbered theorem.
- `Omega_eq_cardFactors` (line 87) is proved by `rfl` and is not harvested (definitional unfolding); `Omega_zero`/`Omega_one` (lines 99–106) are skipped as `_zero`/`_one` lemmas.
