# λ n ^ 2 = 1 at every n (λ is a sign)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Scratch.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Scratch.lean) — line 24

## Statement

> `theorem liouville_sq (n : ℕ) : liouville n ^ 2 = 1`

That is: for every natural number `n` — including `n = 0` — the Liouville value
`λ(n) = (-1)^(Ω n)` satisfies `λ(n)^2 = 1`.

## Hypotheses and notation

- `Omega n = ArithmeticFunction.cardFactors n`, the number of prime factors of `n` counted with multiplicity.
- `liouville n = (-1) ^ Omega n : ℤ` is the local ℤ-valued Liouville function of the file; the file's convention gives `liouville 0 = 1`.
- No hypothesis on `n`: the identity is asserted for every `n : ℕ`.

## Proof / evidence

Lean declaration `liouville_sq` in `research/twin-prime-parity/rounds/rh46/lean/Scratch.lean` (line 24). The proof is complete and contains no `sorry`: it rewrites `λ n ^ 2 = (-1)^(Ω n + Ω n)`, uses `Ω n + Ω n = 2 * Ω n`, and applies `(even_two_mul (Omega n)).neg_one_pow`.

Re-elaboration check (toolchain `leanprover/lean4:v4.35.0-rc2` + Mathlib4, the round's `lean/check.sh` environment): an identical copy of `Scratch.lean` reports errors only inside the later declaration `liouville_mul` (`unsolved goals` at lines 31 and 35); `liouville_sq` itself is accepted with neither error nor `sorry` warning. (`Scratch.lean` as a whole does not elaborate — see [the refuted multiplicativity claim](lean-rh46-scratch-liouville-multiplicativity-refuted.md).)

## Dependencies and related results

- Uses only Mathlib (`even_two_mul`, `neg_one_pow`).
- The same declaration name and statement occur in the certified `Rh46/Chowla.lean` (lines 184–187), documented there as "**`λ n` is a sign.**", and in the certified harvest as [λ n is a sign: λ n ^ 2 = 1 at every n](lean-rh46-chowla-liouville-square-is-one.md).
- Sibling scratch facts: [λ n ≠ 0 for every n ≠ 0](lean-rh46-scratch-liouville-nonzero.md), [|λ n| ≤ 1 for every n](lean-rh46-scratch-liouville-abs-le-one.md).

## Notes

- `Scratch.lean` carries no prose title for this result; the title above is its mathematical content, and the Lean name is `liouville_sq`.
- The five files `Scratch.lean`, `Scratch2.lean`, `Scratch3.lean`, `Scratch4.lean`, `Scratch5.lean` share the prefix `lean-rh46-scratch` and are near-duplicate drafts of the same Liouville lemmas; they were folded into this single harvest (see the fragment `theorems/.index/lean-rh46-scratch.md`). This statement appears only in `Scratch.lean`.
