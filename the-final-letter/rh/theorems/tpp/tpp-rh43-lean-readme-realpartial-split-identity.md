# `realPartial_eq_posRe_add_negRe` — the real part is the sum of the positive and negative parts

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `realPartial_eq_posRe_add_negRe` | `realPartial N t = posRe N t + negRe N t` (the identity, with the `cos = 0` terms vanishing) |

The definitions, from the same file:

```lean
noncomputable def realPartial (N : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))

noncomputable def posRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos > 0
  ∑ k ∈ (Finset.range N).filter (fun k => 0 < Real.cos (t * Real.log (k + 1))),
    Real.cos (t * Real.log (k + 1))

noncomputable def negRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos < 0
  ∑ k ∈ (Finset.range N).filter (fun k => Real.cos (t * Real.log (k + 1)) < 0),
    Real.cos (t * Real.log (k + 1))
```

## Hypotheses and notation

- `N : ℕ`, `t : ℝ`; `realPartial N t = ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))`.
- `posRe N t` sums the terms with `0 < Real.cos (t * Real.log (k + 1))`; `negRe N t` sums the terms with `Real.cos (t * Real.log (k + 1)) < 0`.
- The identity is exact because the `cos = 0` terms contribute `0`.

## Proof / evidence

- **PROVED** in Lean: `realPartial_eq_posRe_add_negRe` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The file reports no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`, and a `#print axioms` audit over every theorem reporting exactly `[propext, Classical.choice, Quot.sound]`.

## Dependencies and related results

- Counterpart in the truths harvest: [The split is an identity](tpp-rh43-truths-split-is-an-identity.md).
- Related Lean declaration in the same table: `zetaPartial_re_eq_posRe_add_negRe` (the complex analogue, not harvested — see Notes).
- Companion harvested file: [The balance reduction `balanced N t ↔ realPartial N t = 0`](tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md).

## Notes

- The same table also lists `posRe_nonneg`, `negRe_nonpos` (`0 ≤ posRe N t`, `negRe N t ≤ 0`) and `zetaPartial_re_eq_posRe_add_negRe`, which are immediate consequences of the definitions; the source itself does not present them as separate results beyond this table.
