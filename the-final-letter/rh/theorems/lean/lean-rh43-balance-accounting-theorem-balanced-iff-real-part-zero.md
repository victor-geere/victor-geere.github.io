# Accounting theorem: `balanced N t ↔ realPartial N t = 0`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §3 "Balanced partial sums and the accounting theorem", lines 181–196

## Statement

> **Accounting theorem.** The partial sum is balanced exactly when its real part vanishes.

```lean
theorem balanced_iff_realPartial_eq_zero (N : ℕ) (t : ℝ) :
    balanced N t ↔ realPartial N t = 0
```

where the source defines

```lean
def balanced (N : ℕ) (t : ℝ) : Prop := posRe N t = -negRe N t
```

> **Balanced.** The positive and the negative parts of the real part of the partial sum have the same total magnitude.

## Hypotheses and notation

- `N : ℕ`, `t : ℝ` arbitrary.
- `balanced N t` is by definition `posRe N t = -negRe N t`, i.e. the positive and negative totals of the real part have the same magnitude.
- `realPartial N t = ∑_{k<N} cos (t log (k+1))`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `balanced_iff_realPartial_eq_zero` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 187–196). It is a two-line consequence of the splitting identity `realPartial_eq_posRe_add_negRe`: from `posRe + negRe = 0` one gets `posRe = -negRe`, and conversely `posRe = -negRe` makes the real part vanish.

## Dependencies and related results

- [Splitting the real part: `realPartial N t = posRe N t + negRe N t`](lean-rh43-balance-real-part-splits-into-positive-negative-totals.md) — the identity the proof rewrites with.
- [The balance-to-equal-split characterisation](lean-rh43-balance-balanced-iff-equal-split.md) — the finer accounting of the two totals at a balance point.
- Harvested counterpart from the round's README: [`balanced_iff_realPartial_eq_zero` — the reduction of the round's question to one real equation](../tpp/tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md).

## Notes

- This is the reduction that turns the round's balance question into a single real equation `realPartial N t = 0`; the existence theorem for a balanced partial sum is then obtained from a zero of `realPartial 3`.
