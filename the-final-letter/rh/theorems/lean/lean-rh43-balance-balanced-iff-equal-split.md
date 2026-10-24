# The balance-to-equal-split characterisation

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`); the `iff` needs the conjunct `p1 + n1 = 0`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §3, lines 198–236

## Statement

> **Equal splitting of the two parts.** A balanced partial sum has its positive total split into two equal nonnegative halves and its negative total into two equal nonpositive halves, the two halves being opposite numbers.

```lean
theorem balanced_equal_split {N : ℕ} {t : ℝ} (hb : balanced N t) :
    ∃ p1 p2 n1 n2 : ℝ, p1 = p2 ∧ n1 = n2 ∧ 0 ≤ p1 ∧ n1 ≤ 0 ∧ p1 + n1 = 0 ∧
      p1 + p2 = posRe N t ∧ n1 + n2 = negRe N t ∧
      p1 + p2 + n1 + n2 = realPartial N t
```

The converse direction carries an extra hypothesis:

> Conversely, an equal splitting of the two parts *that also balances each half against the other* (`p1 + n1 = 0`) exhibits a balanced partial sum. The extra hypothesis is necessary: without it the converse is false, even though the four numbers still split the two totals (see `not_balanced_two_zero`).

```lean
theorem equal_split_balanced {N : ℕ} {t : ℝ} {p1 p2 n1 n2 : ℝ}
    (hp : p1 = p2) (hn : n1 = n2) (hbal : p1 + n1 = 0)
    (hpos : p1 + p2 = posRe N t) (hneg : n1 + n2 = negRe N t) : balanced N t
```

> **Equal splitting, iff form.** Balanced partial sums are exactly those whose positive total is the sum of two equal nonnegative halves and whose negative total is the sum of two equal nonpositive halves, the two halves themselves being opposite (`p1 + n1 = 0`).

```lean
theorem balanced_iff_equal_split (N : ℕ) (t : ℝ) :
    balanced N t ↔ ∃ p1 p2 n1 n2 : ℝ, p1 = p2 ∧ n1 = n2 ∧ 0 ≤ p1 ∧ n1 ≤ 0 ∧
      p1 + n1 = 0 ∧ p1 + p2 = posRe N t ∧ n1 + n2 = negRe N t ∧
      p1 + p2 + n1 + n2 = realPartial N t
```

## Hypotheses and notation

- `balanced N t` is `posRe N t = -negRe N t`; the witness pieces in the forward direction are `p1 = p2 = posRe N t / 2` and `n1 = n2 = negRe N t / 2`.
- In the converse, the four numbers `p1, p2, n1, n2` satisfy `p1 = p2`, `n1 = n2`, `p1 + p2 = posRe N t`, `n1 + n2 = negRe N t`, and the **additional conjunct is `p1 + n1 = 0`**.
- The `iff` form combines both directions, so it also requires `0 ≤ p1` and `n1 ≤ 0` on the right-hand side.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declarations `balanced_equal_split` (lines 201–211), `equal_split_balanced` (lines 217–224) and `balanced_iff_equal_split` (lines 230–236) in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean). The forward direction uses `posRe_nonneg` and `negRe_nonpos`; the `iff` assembles the two directions.

## Dependencies and related results

- [Splitting the real part: `realPartial N t = posRe N t + negRe N t`](lean-rh43-balance-real-part-splits-into-positive-negative-totals.md).
- [Accounting theorem: `balanced N t ↔ realPartial N t = 0`](lean-rh43-balance-accounting-theorem-balanced-iff-real-part-zero.md).
- [At `t = 0` the `N = 2` truncation is not balanced](lean-rh43-balance-two-not-balanced-at-zero.md) — the `N = 2`, `t = 0` counterexample showing the extra conjunct is necessary.
- Harvested counterpart from the round's README: [The balance-to-equal-split equivalences](../tpp/tpp-rh43-lean-readme-balanced-iff-equal-split.md).

## Notes

- The source is explicit that the converses are false without `p1 + n1 = 0`: the bare equal-splitting data does not imply balance. At `N = 2`, `t = 0` the data `p1 = p2 = 1`, `n1 = n2 = 0` splits `posRe = 2` and `negRe = 0` into equal halves yet the partial sum is not balanced.
