# T10 — `S_3(t) != 0` for all `t`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; axiom audit `[propext, Classical.choice, Quot.sound]`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T10 (§2)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T10 | `S_3(t) != 0` for all `t` | **PROVED** | §2, Lean `zetaPartial_three_ne_zero` |

The §2 numbered form:

> **Theorem 8 (algebraic independence at work).** For `N = 3`, `S_3(t) != 0` for every real `t`. **PROVED** in Lean (`Rh43.zetaPartial_three_ne_zero`): writing `x = exp(-i t log 2)`, `y = exp(-i t log 3)`, the equation `1 + x + y = 0` forces `cos(t log 2) = cos(t log 3) = -1/2`, hence `3t log 2, 3t log 3` in `2 pi Z`; a nonzero solution then gives integers `n, m != 0` with `m log 2 = n log 3`, hence `3^{|n|} = 2^{|m|}`, which forces `3 | 2`. The audit reports only `propext, Classical.choice, Quot.sound`.

## Hypotheses and notation

- `t` real; `S_3(t) = 1 + 2^{-it} + 3^{-it}`.
- `!=` is negation of equality; the reduction produces integers `n, m != 0` with `m log 2 = n log 3`, i.e. `3^{|n|} = 2^{|m|}`.
- `3 | 2` denotes the (false) divisibility statement forced by the hypothetical solution.

## Proof / evidence

- Ledger row T10: "**PROVED**", evidence "§2, Lean `zetaPartial_three_ne_zero`".
- Lean declaration: `zetaPartial_three_ne_zero (t : ℝ) : zetaPartial 3 t ≠ 0` in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean); axiom audit reports only `propext, Classical.choice, Quot.sound`.

## Dependencies and related results

- The numbered form is [Theorem 8 (algebraic independence at work)](tpp-rh43-truths-s3-nonvanishing.md).
- Related: [T11](tpp-rh43-truths-s2-exact-vanishing.md) (the contrasting `N = 2` vanishing); [T16/§2 Theorem 10](tpp-rh43-truths-balance-needs-only-real-equation.md).

## Notes

- Ledger row T10 restates §2 Theorem 8. The proof is self-contained in Lean; the prose phrase "algebraic independence at work" is the source's framing, while the written argument is the elementary reduction above.
