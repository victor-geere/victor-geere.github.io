# |λ n| ≤ 1 for every n

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Scratch.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch.lean) — lines 49–52

## Statement

> `theorem liouville_abs_le_one (n : ℕ) : |liouville n| ≤ 1`

That is: `|λ(n)| ≤ 1` for every natural number `n`, including `n = 0`.

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n`; `|·|` is the integer absolute value.
- No hypothesis on `n`.

## Proof / evidence

Lean declaration `liouville_abs_le_one` in `research/twin-prime-parity/rounds/rh46/lean/Scratch.lean` (lines 49–52). The proof is complete, with no `sorry`: it splits on the parity of `Omega n` and evaluates `|±1| ≤ 1` by `norm_num`.

Re-elaboration check (toolchain `leanprover/lean4:v4.35.0-rc2` + Mathlib4): the only errors reported for an identical copy of `Scratch.lean` are inside the later declaration `liouville_mul` (lines 31 and 35); `liouville_abs_le_one` is accepted with no error and no `sorry`.

## Dependencies and related results

- Uses only Mathlib (`Nat.even_or_odd`, `Even.neg_one_pow`, `Odd.neg_one_pow`).
- The same declaration name and statement occur in the certified `Rh46/Chowla.lean` (lines 190–193), where it is the per-summand input to `corr_abs_le`; harvested as [|λ n| ≤ 1 for every n](lean-rh46-chowla-liouville-abs-le-one.md) under the `lean-rh46-chowla` prefix.
- Sibling scratch facts: [λ n ^ 2 = 1 at every n](lean-rh46-scratch-liouville-square-is-one.md), [λ n ≠ 0 for every n ≠ 0](lean-rh46-scratch-liouville-nonzero.md).

## Notes

- The `Scratch*` family (`Scratch.lean`–`Scratch5.lean`, prefix `lean-rh46-scratch`) was folded; this statement occurs only in `Scratch.lean`.
- The identical statement is also harvested from `Rh46/Chowla.lean` under its own prefix; that duplication is deliberate, since the two sources carry separate assigned prefixes and separate index fragments.
