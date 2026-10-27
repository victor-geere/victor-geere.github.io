# λ n ≠ 0 for every n ≠ 0

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Check11.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Check11.lean) — lines 9–12; declaration `Rh46.liouville_ne_zero`

## Statement

> `theorem liouville_ne_zero {n : ℕ} (hn : n ≠ 0) : liouville n ≠ 0 := by`
> `  rcases Nat.even_or_odd (Omega n) with h | h`
> `  · rw [liouville, h.neg_one_pow]; norm_num`
> `  · rw [liouville, h.neg_one_pow]; norm_num`

with the local definitions (lines 6–7)

> `def Omega (n : ℕ) : ℕ := ArithmeticFunction.cardFactors n`
> `def liouville (n : ℕ) : ℤ := (-1) ^ Omega n`

That is: the Liouville function, defined here as `λ(n) = (-1)^{Ω(n)}` with `Ω` the prime-factor count with multiplicity, never takes the value `0` at a nonzero argument.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n` (`Ω n` = number of prime factors counted with multiplicity); `liouville n = (-1) ^ Omega n : ℤ`.
- Hypothesis `hn : n ≠ 0`. The statement also holds at `n = 0`, where the file's convention gives `liouville 0 = (-1)^0 = 1`; the hypothesis is therefore not needed for the mathematics, only as stated.
- The proof works by parity of `Ω n`: an even `Ω n` gives `(-1)^{Ω n} = 1`, an odd one gives `-1`.

## Proof / evidence

Complete Lean proof, no `sorry`: the declaration `Rh46.liouville_ne_zero` in `research/twin-prime-parity/rounds/rh46/lean/Check11.lean`, lines 9–12. `Nat.even_or_odd (Omega n)` splits into the two parities; in each case `Even.neg_one_pow` / `Odd.neg_one_pow` (as `h.neg_one_pow`) rewrites `(-1) ^ Omega n` to `1` or `-1`, and `norm_num` closes `1 ≠ 0` / `-1 ≠ 0`.

The proof is complete and the file elaborates: I re-elaborated `Check11.lean` with the round's own toolchain (`leanprover/lean4:v4.35.0-rc2` + Mathlib4, `LEAN_PATH` reconstructed from `lake env`, as `lean/check.sh` does) and it exits 0. It is one of only three `Check*` files of the family that leave a compiled artifact in the workspace (`Check7.olean`, `Check11.olean`, `Check32.olean` are present; no other `Check*.olean` is).

## Dependencies and related results

- Mathlib only: `Nat.even_or_odd`, `Even.neg_one_pow`, `Odd.neg_one_pow`.
- The same statement occurs in the round's certified development as `Rh46.liouville_ne_zero` in [`Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (lines 180–181), where it is an immediate corollary of `liouville_mem`; there it is not harvested separately because its content is covered by [λ n is 1 or −1 for every n ≥ 1](lean-rh46-chowla-liouville-takes-sign-values.md).
- It also occurs in the scratch family, harvested under a different prefix as [λ n ≠ 0 for every n ≠ 0](lean-rh46-scratch-liouville-nonzero.md) (`Scratch.lean`, lines 44–47). This file is the `Check*` copy of the same declaration.
- Sibling harvested sign facts: [λ n ^ 2 = 1 at every n (λ is a sign)](lean-rh46-scratch-liouville-square-is-one.md), [|λ n| ≤ 1 for every n](lean-rh46-scratch-liouville-abs-le-one.md).

## Notes

- The `Check*` family is scratch/tactic-probe work for the round's development. The source gives the declaration no prose title; the title above is the mathematical content and the Lean name is `liouville_ne_zero`.
- Deliberately not harvested from the same file: the two `example` blocks (lines 14–15, an instance of this lemma; lines 17–20, the indicator-sum identity `∑_{n ∈ Icc 1 N} (if n = a then x else 0) = x`), since `example`s are out of scope; the local definitions `Omega` (line 6) and `liouville` (line 7), also out of scope.
