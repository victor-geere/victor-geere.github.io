# Theorem 11 (the numeric split is exact)

**Kind:** Theorem
**Status:** PROVED (paper argument, trivial algebra once T2 holds; Lean declarations named)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §3 "The four-part split: two readings, opposite answers" (ledger row T9)

## Statement

> **Theorem 11 (the numeric split is exact).** At any balance point the four numbers `P/2, P/2, M/2, M/2` are two equal positive and two equal negative pieces: `P/2 = |M|/2` follows from `P = |M|`, and `P/2 + P/2 + M/2 + M/2 = P + M = 0`.

## Hypotheses and notation

- A *balance point* is a pair `(N, t)` with `P_N(t) = |M_N(t)|`, equivalently `Re S_N(t) = 0`.
- `P = P_N(t) >= 0`, `M = M_N(t) <= 0`; `P/2, P/2` are the two positive pieces and `M/2, M/2` the two negative pieces.
- The statement is about the *numbers* `P/2`, `M/2` and not about a partition of the terms (contrast Theorem 11′, ledger row T9′).

## Proof / evidence

- **PROVED** (trivial algebra once T2 holds); in Lean this is `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`.
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §5 at `N = 3` (`P = 1 = |M|`, four pieces `±1/2`).
- Ledger row T9: status "**PROVED**", evidence "§3, Lean `balanced_equal_split`".

## Dependencies and related results

- Depends on [T2 / Theorem 1](tpp-rh43-truths-split-identity-and-balance-equation.md) (`P + M = Re S_N` and `P = -M ↔ Re S_N = 0`).
- Related: [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md) — the opposite answer for the term-level reading.
- The source also notes the three-piece relaxation: `P/3 + P/3 + P/3 = P`, `M/3 + M/3 + M/3 = M`, and `P/3 = |M|/3` at a balance point, but "that is a decomposition of the totals, not of the terms."

## Notes

- The source flags that this is the *numeric* reading only; the term-level reading is a different question with the opposite answer (T9′, F7).
