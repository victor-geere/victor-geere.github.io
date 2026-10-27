# λ n ≠ 0 for every n ≠ 0

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Scratch.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch.lean) — lines 44–47

## Statement

> `theorem liouville_ne_zero {n : ℕ} (hn : n ≠ 0) : liouville n ≠ 0`

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n`.
- Hypothesis `hn : n ≠ 0` (the statement also holds at `n = 0`, where `liouville 0 = 1`).

## Proof / evidence

Lean declaration `liouville_ne_zero` in `research/twin-prime-parity/rounds/rh46/lean/Scratch.lean` (lines 44–47). The proof is complete, with no `sorry`: it splits on the parity of `Omega n` (`Nat.even_or_odd`) and evaluates `(-1)^k` by `norm_num` in each case.

Re-elaboration check (toolchain `leanprover/lean4:v4.35.0-rc2` + Mathlib4): the only errors reported for an identical copy of `Scratch.lean` are inside the later declaration `liouville_mul` (lines 31 and 35); `liouville_ne_zero` is accepted with no error and no `sorry`.

## Dependencies and related results

- Uses only Mathlib (`Nat.even_or_odd`, `Even.neg_one_pow`, `Odd.neg_one_pow`).
- The same statement appears in the certified `Rh46/Chowla.lean` as `liouville_ne_zero` (lines 180–181), where it is an immediate corollary of `liouville_mem`; it is not harvested under the `lean-rh46-chowla` prefix because its content is covered there by [λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md).
- Sibling scratch facts: [λ n ^ 2 = 1 at every n](lean-rh46-scratch-liouville-square-is-one.md), [|λ n| ≤ 1 for every n](lean-rh46-scratch-liouville-abs-le-one.md).

## Notes

- The `Scratch*` family (`Scratch.lean`–`Scratch5.lean`, prefix `lean-rh46-scratch`) was folded; this statement occurs only in `Scratch.lean`.
- The source gives no prose title; the Lean name is `liouville_ne_zero`.
