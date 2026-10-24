# `balanced_iff_realPartial_eq_zero` — the reduction of the round's question to one real equation

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `balanced_iff_realPartial_eq_zero` | `balanced N t ↔ realPartial N t = 0` — **the reduction of the round's question to one real equation** |

with the definition

```lean
def balanced (N : ℕ) (t : ℝ) : Prop := posRe N t = -negRe N t
```

## Hypotheses and notation

- `balanced N t` is defined as `posRe N t = -negRe N t`, i.e. the positive and negative real-part totals have equal magnitude.
- `realPartial N t = ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))` is the real part of the partial sum.
- `↔` is a Lean `Iff`.

## Proof / evidence

- **PROVED** in Lean: `balanced_iff_realPartial_eq_zero (N : ℕ) (t : ℝ)` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The README describes this as "**the reduction of the round's question to one real equation**".

## Dependencies and related results

- Counterpart in the truths harvest: [The split is an identity, and balance is a single equation](tpp-rh43-truths-split-is-an-identity.md).
- Related harvested Lean README file: [The balance-to-equal-split equivalence](tpp-rh43-lean-readme-balanced-iff-equal-split.md).
- Companion: [The real part is the sum of the positive and negative parts](tpp-rh43-lean-readme-realpartial-split-identity.md).

## Notes

- The README's companion entry `balanced_iff_equal_split` requires the extra conjunct `p1 + n1 = 0`; without it the statement is false, with `N = 2, t = 0` as a counterexample (`not_balanced_two_zero`).
