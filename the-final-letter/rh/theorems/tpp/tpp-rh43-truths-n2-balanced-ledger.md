# T4 — N = 2 is balanced exactly at `t = pi/log 2` (the zero is tangential)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`) + VERIFIED (numerical, 74-digit certified enclosures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T4 (§1.1)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T4 | `N = 2` balanced exactly at `t = pi/log 2`; the zero is tangential | **PROVED**+**VERIFIED** | §1.1, Lean `balanced_two` etc. |

The §1.1 numbered form:

> **Theorem 3 (N = 2 is balanced, exactly, at `t = pi/log 2`).**
>
> ```
> S_2(pi/log 2) = 1 + exp(-i pi) = 0          (exactly)
> Re S_2(pi/log 2) = 1 + cos(pi) = 0
> P_2 = 1  (the term n = 1),   M_2 = -1  (the term n = 2)
> ```
>
> The zero is **tangential**: `Re S_2(t) = 1 + cos(t log 2) >= 0`, with equality exactly at `t = (2k+1) pi/log 2`, so a search for a *sign change* misses it.

## Hypotheses and notation

- `t` real; `S_2(t) = 1 + exp(-i t log 2)`, `Re S_2(t) = 1 + cos(t log 2) >= 0`.
- Equality exactly at `t = (2k+1) pi/log 2`, `k` integral; "tangential" means the zero is a touching zero, not a sign change.
- At that point `P_2 = 1` (term `n = 1`) and `M_2 = -1` (term `n = 2`): both parts non-degenerate.

## Proof / evidence

- Ledger row T4: "**PROVED**+**VERIFIED**", evidence "§1.1, Lean `balanced_two` etc."
- Lean declarations in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean): `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two`, `zetaPartial_two_pi_div_log_two`.
- **VERIFIED** in the script §2 with 74-digit certified enclosures by the auditor.

## Dependencies and related results

- The numbered form is [N = 2 is balanced](tpp-rh43-truths-n2-balanced-tangential.md); the complex exact vanishing is [T11](tpp-rh43-truths-s2-exact-vanishing.md).
- Refutes [F1](tpp-rh43-truths-f1-balance-iff-n-ge-3-refuted.md) and [F2](tpp-rh43-truths-f2-n2-no-root-refuted.md).

## Notes

- Ledger row T4 restates §1.1 Theorem 3; the source records that the first draft of the script and Lean file both claimed "no root for `N = 2`" and that the correction is recorded rather than deleted.
- The Lean declaration `not_balanced_two_zero` only says `t = 0` is unbalanced at `N = 2`; it does not contradict this result.
