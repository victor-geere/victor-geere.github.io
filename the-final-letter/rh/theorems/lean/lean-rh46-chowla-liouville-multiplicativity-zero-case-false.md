# The 0 case of complete multiplicativity is genuinely false

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_mul_zero_false`, lines 166–171

## Statement

> `theorem liouville_mul_zero_false :`
> `    ¬ (liouville (0 * 2) = liouville 0 * liouville 2)`

The file's docstring: "**The `0` case is genuinely false**: at `n = 2` the would-be
identity reads `λ 0 = λ 0 * λ 2`, i.e. `1 = -1`."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ` with the file's convention `λ 0 = 1`; `λ 2 = -1`, `λ 4 = 1`, `λ 6 = 1` are likewise certified in the same file.
- No hypotheses: it is the concrete negation at the pair `(m, n) = (0, 2)`.

## Proof / evidence

Lean declaration `liouville_mul_zero_false` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 168–171), proved by `rw [Nat.zero_mul, liouville_zero, liouville_two]; norm_num`, so the two sides are `1` and `-1`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`).

## Dependencies and related results

- Uses the concrete values `liouville_zero` (line 116) and `liouville_two` (line 126); both are skipped in this harvest as `_zero`/concrete-evaluation lemmas.
- It is the honest boundary of [Complete multiplicativity of λ, nonzero form](lean-rh46-chowla-liouville-completely-multiplicative.md).
- It refutes the unrestricted scratch claim [Complete multiplicativity of λ, asserted without nonzero hypotheses (refuted)](lean-rh46-scratch-liouville-multiplicativity-refuted.md).

## Notes

- The statement is a negated equality (a counterexample), and is reproduced here exactly as the source states it; the mathematical content is "the `m = 0` instance of `λ(mn) = λ(m)λ(n)` is false for `n = 2`".
- The declaration is `theorem`, hence Kind Theorem.
