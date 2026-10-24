# `zetaPartial_three_ne_zero` — S_3(t) ≠ 0 for every real t

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; axiom audit `[propext, Classical.choice, Quot.sound]`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `zetaPartial_three_ne_zero` | `S_3(t) ≠ 0` for **every** real `t` (reduce to `m log 2 = n log 3`, i.e. `3^{|n|} = 2^{|m|}`) |

with the complex partial sum defined as

```lean
noncomputable def zetaPartial (N : ℕ) (t : ℝ) : ℂ :=
  ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * Real.log (k + 1))
-- i.e. the sum of n^{-it} for n = 1, …, N
```

## Hypotheses and notation

- `t : ℝ` arbitrary; `zetaPartial 3 t = 1 + 2^{-it} + 3^{-it}`.
- The proof reduces `S_3(t) = 0` to integers `n, m` with `m log 2 = n log 3`, i.e. `3^{|n|} = 2^{|m|}`.

## Proof / evidence

- **PROVED** in Lean: `zetaPartial_three_ne_zero (t : ℝ) : zetaPartial 3 t ≠ 0` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- A temporary `#print axioms` audit over every theorem reports exactly `[propext, Classical.choice, Quot.sound]`.

## Dependencies and related results

- Counterpart in the truths harvest: [Theorem 8 (algebraic independence at work)](tpp-rh43-truths-s3-nonvanishing.md), ledger row [T10](tpp-rh43-truths-s3-nonvanishing-ledger.md).
- Contrast the harvested [exact complex vanishing at N = 2](tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md).

## Notes

- The README's Notes on the proofs record that the *complex* split `posPart + negPart = zetaPartial` (with the `cos = 0` terms) is deliberately **not** stated: a term with `cos = 0` has nonzero imaginary part and belongs to neither filter, so the complex identity is false.
