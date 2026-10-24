# Complete multiplicativity of λ, asserted without nonzero hypotheses (refuted)

**Kind:** Theorem
**Status:** REFUTED (Lean witness in `Scratch5.lean`; the `liouville_mul` declarations of `Scratch.lean` and `Scratch3.lean` do not elaborate)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Scratch.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch.lean) — lines 29–42; [`Scratch3.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch3.lean) — lines 48–65; [`Scratch5.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch5.lean) — lines 23–26

## Statement

> `theorem liouville_mul (m n : ℕ) : liouville (m * n) = liouville m * liouville n`

i.e. λ is completely multiplicative with **no** restriction on the arguments. With the
file's convention `λ(0) = 1` the case `m = 0` reads `λ(0) = λ(0) · λ(n)`, i.e.
`1 = λ(n)`.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n`; `liouville n = (-1) ^ Omega n : ℤ`, so `liouville 0 = 1` by the file's convention (Mathlib's `ArithmeticFunction.liouville 0` is `0` instead).
- The declarations as written have **no** hypotheses — in particular neither `m ≠ 0` nor `n ≠ 0` is required, contrary to what the identity needs.

## Proof / evidence

- **The statement is false.** `Scratch5.lean` (lines 23–26) proves the negation at `m = 0`, `n = 2`:
  `example : ¬ (liouville (0 * 2) = liouville 0 * liouville 2)`, by `rw [Nat.zero_mul, liouville_zero, liouville_two]; norm_num` — the would-be identity reads `1 = -1`. This counterexample is an `example` block (not itself harvested); it is the witness for the status REFUTED.
- **The two asserting declarations do not elaborate, so their proofs are not complete.** Re-elaborating identical copies (toolchain `leanprover/lean4:v4.35.0-rc2` + Mathlib4, the round's `lean/check.sh` environment):
  - `Scratch.lean` exits 1 with `unsolved goals` at lines 31 and 35 — the `m = 0` and `n = 0` branches of `liouville_mul`;
  - `Scratch3.lean` exits 1 with `unsolved goals` at lines 45, 54 and 62 — in `liouville_six` and in the two zero-case branches of `liouville_mul`.
  Neither file produces a `.olean`, unlike `Scratch2.lean` and `Scratch5.lean`.
- `Scratch2.lean` (lines 20–28) attempts the same `m = 0` case and leaves a literal `sorry` at line 27; `Scratch4.lean` re-attempts the false `λ(0)·λ(n) = 1` as `example`s and also fails.
- The correct hypothesis-carrying form is `liouville_mul` in `Rh46/Chowla.lean` (lines 162–164), proved for `m ≠ 0`, `n ≠ 0`, with the zero case refuted there by `liouville_mul_zero_false`; harvested as [Complete multiplicativity of λ, nonzero form](lean-rh46-chowla-liouville-completely-multiplicative.md) and [The 0 case of complete multiplicativity is genuinely false](lean-rh46-chowla-liouville-multiplicativity-zero-case-false.md).

## Dependencies and related results

- Uses the local definitions `Omega` and `liouville` and the trivial cases `liouville_zero` (skipped as a `_zero` lemma).
- The correct additivity law for Ω on nonzero products is [Ω is additive on nonzero products](lean-rh46-scratch-omega-additive-nonzero-products.md) (`Omega_mul`, `Scratch3.lean`).
- Contrast: [λ n ^ 2 = 1 at every n](lean-rh46-scratch-liouville-square-is-one.md) is true and proved in the same file.

## Notes

- Folding: this statement is carried by the near-duplicate scratch drafts `Scratch.lean` (`liouville_mul`, lines 29–42) and `Scratch3.lean` (`liouville_mul`, lines 48–65), which share the prefix `lean-rh46-scratch`; the two copies are harvested once here. `Scratch2.lean`, `Scratch4.lean` and `Scratch5.lean` attack the same `m = 0` case (`Scratch5.lean` correctly, as an `example`).
- The source never labels this result with a prose title; the title above is the mathematical content, and the Lean name is `liouville_mul` in the two scratch files.
- A related scratch error, not harvested as a result of its own: `Scratch3.lean` also states `theorem liouville_six : liouville 6 = -1` (line 45), which is false — `Ω 6 = 2`, so `λ 6 = +1`, as certified by `liouville_six` in `Rh46/Chowla.lean` (line 142). That declaration likewise fails to elaborate (`unsolved goals` at line 45).
