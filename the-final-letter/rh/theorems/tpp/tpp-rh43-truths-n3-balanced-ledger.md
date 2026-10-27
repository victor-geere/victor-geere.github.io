# T5 — N = 3 is balanced via IVT, `Re S_3(5/2) < 0`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`, no numerical axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T5 (§1.2)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T5 | `N = 3` balanced via IVT, `Re S_3(5/2) < 0` | **PROVED** | §1.2, Lean `exists_balanced_partial_sum` |

The §1.2 numbered form:

> **Theorem 4 (existence of a balanced partial sum).** There is `t` in `(0, 5/2)` with `Re S_3(t) = 0`; hence `balanced 3 t` holds. Indeed
>
> ```
> Re S_3(t) = 1 + cos(t log 2) + cos(t log 3)
> Re S_3(0) = 3 > 0
> Re S_3(5/2) < 0 ,     the certified value being -0.08433575829842532…
> ```
>
> and `Re S_3` is continuous, so the intermediate value theorem gives a root.

## Hypotheses and notation

- `S_3(t) = 1 + 2^{-it} + 3^{-it}`, `Re S_3(t) = 1 + cos(t log 2) + cos(t log 3)`; `t` real.
- `Re S_3(0) = 3 > 0`; `Re S_3(5/2) < 0` with certified value `-0.08433575829842532…`.

## Proof / evidence

- Ledger row T5: "**PROVED**", evidence "§1.2, Lean `exists_balanced_partial_sum`".
- Lean declarations (with `realPartial_three_at_zero`, `realPartial_three_five_halves_neg`, `exists_zero_realPartial_three`, `exists_realPartial_three_eq_zero`) in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean); inputs `cos((5/2) log 2) < -0.16` and `cos((5/2) log 3) < -0.92` from Mathlib log/π bounds and Taylor inequalities; no numerical axiom.

## Dependencies and related results

- The numbered form is [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md).
- Related: [T6](tpp-rh43-truths-n4-balanced-ledger.md), [T7](tpp-rh43-truths-certified-root-ledger.md), [T8](tpp-rh43-truths-existence-every-n-ledger.md).

## Notes

- Ledger row T5 restates §1.2 Theorem 4.
