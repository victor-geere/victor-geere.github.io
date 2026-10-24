# T9 — the numeric four-part split is exact at a balance point

**Kind:** Theorem
**Status:** PROVED (paper argument, trivial algebra once T2 holds; Lean declarations named)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T9 (§3)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T9 | the numeric four-part split `P/2, P/2, M/2, M/2` is exact at a balance point | **PROVED** | §3, Lean `balanced_equal_split` |

The §3 numbered form of the same result:

> **Theorem 11 (the numeric split is exact).** At any balance point the four numbers `P/2, P/2, M/2, M/2` are two equal positive and two equal negative pieces: `P/2 = |M|/2` follows from `P = |M|`, and `P/2 + P/2 + M/2 + M/2 = P + M = 0`.

## Hypotheses and notation

- A balance point satisfies `P = |M|`, i.e. `Re S_N(t) = 0` (T2 / Theorem 1).
- The four pieces are the *numbers* `P/2, P/2, M/2, M/2` (with `M <= 0`), not a partition of the terms.

## Proof / evidence

- **PROVED** (trivial algebra once T2 holds); in Lean: `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`.
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §5 at `N = 3` (`P = 1 = |M|`, four pieces `±1/2`).
- Ledger row T9: status "**PROVED**", evidence "§3, Lean `balanced_equal_split`".

## Dependencies and related results

- Depends on [T2 / Theorem 1](tpp-rh43-truths-split-identity-and-balance-equation.md).
- Contrast the term-level reading [T9′](tpp-rh43-truths-term-level-split-defects-n6.md) / [Theorem 11′](tpp-rh43-truths-term-level-split-fails.md).

## Notes

- Ledger row T9 restates §3 Theorem 11; the source also records the three-piece relaxation `P/3 + P/3 + P/3 = P`, `M/3 + M/3 + M/3 = M`, `P/3 = |M|/3` at a balance point, which "is a decomposition of the totals, not of the terms."
