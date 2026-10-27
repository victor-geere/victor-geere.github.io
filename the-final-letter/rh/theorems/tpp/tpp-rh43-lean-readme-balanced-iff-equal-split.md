# The balance-to-equal-split equivalences (`balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`); the `iff` needs the conjunct `p1 + n1 = 0`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table rows)

## Statement

> | theorem | statement |
> |---|---|
> | `balanced_equal_split` | balance yields two equal positive and two equal negative pieces `P/2, P/2, M/2, M/2` |
> | `equal_split_balanced` | conversely, an equal split with `p1 + n1 = 0` gives balance |
> | `balanced_iff_equal_split` | the `iff`, with the necessary conjunct `p1 + n1 = 0` (without it the statement is false: `N = 2, t = 0` is a counterexample, `not_balanced_two_zero`) |

## Hypotheses and notation

- `balanced N t` is `posRe N t = -negRe N t`; `P/2`, `M/2` are the two equal positive and two equal negative pieces at a balance point.
- In `equal_split_balanced` and `balanced_iff_equal_split` the pieces are named `p1, p2, n1, n2`; the **necessary conjunct is `p1 + n1 = 0`**.
- The counterexample to the version without the conjunct is `N = 2, t = 0` (Lean: `not_balanced_two_zero`).

## Proof / evidence

- **PROVED** in Lean: declarations `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The README records that `not_balanced_two_zero` shows the conjunct is necessary.

## Dependencies and related results

- Counterpart in the truths harvest: [The numeric split is exact](tpp-rh43-truths-numeric-split-exact.md) (T9 / Theorem 11).
- Companion harvested Lean README file: [The reduction `balanced N t ↔ realPartial N t = 0`](tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md).

## Notes

- The conjunct `p1 + n1 = 0` is part of the statement as the source gives it; the `iff` is *false* without it, and the source supplies the counterexample `N = 2, t = 0`.
