# Complete multiplicativity of λ, nonzero form

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_mul`, lines 158–164

## Statement

> `theorem liouville_mul {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0) :`
> `    liouville (m * n) = liouville m * liouville n`

The file's docstring: "**Complete multiplicativity, nonzero form.** `Ω` is additive for
all products of nonzero naturals, so `λ` is completely multiplicative there."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ`, `Omega n = ArithmeticFunction.cardFactors n` (prime factors counted with multiplicity), with the file's convention `λ 0 = 1`.
- Hypotheses `hm : m ≠ 0`, `hn : n ≠ 0`; both are used.

## Proof / evidence

Lean declaration `liouville_mul` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 162–164), proved from `Omega_mul hm hn` and `pow_add`. The proof is complete; the file has no `sorry` (round certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4: 38 theorems, exit 0, no `sorry`/`admit`/`axiom`/`native_decide`). The README §4 names this among the certified results: "`liouville_mul` (nonzero; with `liouville_mul_zero_false` refuting the zero case)".

## Dependencies and related results

- Uses [Ω is additive on nonzero products](lean-rh46-chowla-omega-additive-nonzero-products.md) (`Omega_mul`).
- The nonzero hypotheses are necessary: [The 0 case of complete multiplicativity is genuinely false](lean-rh46-chowla-liouville-multiplicativity-zero-case-false.md) (`liouville_mul_zero_false`).
- The same statement is asserted *without* hypotheses, and refuted, in the scratch draft `Scratch.lean`/`Scratch3.lean`: [Complete multiplicativity of λ, asserted without nonzero hypotheses (refuted)](lean-rh46-scratch-liouville-multiplicativity-refuted.md).
- Companion boundedness facts: [λ n is a sign: λ n ^ 2 = 1 at every n](lean-rh46-chowla-liouville-square-is-one.md), [|λ n| ≤ 1 for every n](lean-rh46-chowla-liouville-abs-le-one.md).

## Notes

- For `n ≠ 0`, `λ` agrees with Mathlib's completely multiplicative `ArithmeticFunction.liouville` ([The bridge to Mathlib](lean-rh46-chowla-liouville-agrees-with-mathlib.md)).
- The declaration is `theorem`, hence Kind Theorem.
