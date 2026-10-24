# At `t = 0` the `N = 2` truncation is not balanced

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; counterexample)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §6, lines 363–373

## Statement

> At `t = 0` the truncation at `N = 2` is `2`, so it is not balanced. This is also the counterexample showing that the bare equal-splitting data (without the balance of the two halves, `p1 + n1 = 0`) does not imply `balanced`: at `N = 2`, `t = 0` the data `p1 = p2 = 1`, `n1 = n2 = 0` splits `posRe = 2` and `negRe = 0` into equal halves. It does **not** say that `N = 2` is never balanced: at `t = π / log 2` it is balanced (`balanced_two`).

```lean
theorem not_balanced_two_zero : ¬ balanced 2 0
```

## Hypotheses and notation

- `N = 2`, `t = 0`; `realPartial 2 t = 1 + cos (t log 2)` (`realPartial_two`, line 318) and `realPartial 2 0 = 2` (`realPartial_two_at_zero`, line 323).
- `balanced N t := posRe N t = -negRe N t`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `not_balanced_two_zero` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 369–373). Assuming `balanced 2 0`, the accounting theorem turns it into `realPartial 2 0 = 0`, contradicting `realPartial_two_at_zero : realPartial 2 0 = 2`.

## Dependencies and related results

- [Accounting theorem: `balanced N t ↔ realPartial N t = 0`](lean-rh43-balance-accounting-theorem-balanced-iff-real-part-zero.md).
- [The balance-to-equal-split characterisation](lean-rh43-balance-balanced-iff-equal-split.md) — where this is cited as the reason the conjunct `p1 + n1 = 0` is necessary.
- [The `N = 2` truncation is balanced at `t = π / log 2`](lean-rh43-balance-two-balanced-at-pi-over-log-two.md) — the contrast showing `N = 2` is not excluded in general.

## Notes

- The source is explicit that this is a statement about `t = 0` only, not a claim that `N = 2` is never balanced. The auxiliary evaluations `realPartial_two` and `realPartial_two_at_zero` are definitional unfoldings/evaluations and are not harvested separately; they are recorded here.
