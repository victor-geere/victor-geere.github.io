# T2 — P + M = Re S_N; P = -M ⟺ Re S_N = 0; the four-piece reading

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger, row T2 (stated as Theorem 1 in §0.3)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T2 | `P + M = Re S_N`; `P = -M <=> Re S_N = 0`; the four-piece reading | **PROVED** | Theorem 1, Lean names of §0.3 |

The ledger row T2 abbreviates §0.3, Theorem 1, whose statement is:

> ```
> P_N(t) + M_N(t) = Re S_N(t) = 1 + sum_{n=2}^{N} cos(t log n)          (PROVED)
> P_N(t) = -M_N(t)   <=>   Re S_N(t) = 0                               (PROVED)
> P_N(t) = -M_N(t)   <=>   P_N(t)/2 + P_N(t)/2 + M_N(t)/2 + M_N(t)/2 has two equal
>                          positive and two equal negative pieces    (PROVED)
> ```

## Hypotheses and notation

- `S_N(t) = sum_{n=1}^{N} n^{-it}`, `t` real; `P_N >= 0` the sum of the positive real parts, `M_N <= 0` the sum of the negative real parts (see truths.md §0.1).
- "The four-piece reading" is reading **R2** of the round's question (§0.2): `P_N(t)/2 = |M_N(t)|/2` — since `P = |M|` already implies `P/2 = |M|/2`, R2 *is* R1, the extra equality being automatic.

## Proof / evidence

Ledger evidence: "Theorem 1, Lean names of §0.3". In Lean ([`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)): `realPartial_eq_posRe_add_negRe`, `posRe_nonneg`, `negRe_nonpos`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`. **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §1.

## Dependencies and related results

- The same content as [Theorem 1 (the split is an identity)](tpp-rh43-truths-split-is-an-identity.md); the ledger row is a restatement of that theorem.
- Related: [The numeric split is exact](tpp-rh43-truths-numeric-split-exact.md) (T9).

## Notes

- Ledger row T2 restates §0.3 Theorem 1; both are recorded here because the source states them in two places (a ledger row with an id, and a numbered theorem with a title).
