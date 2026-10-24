# T7 — certified root brackets for N = 3..50

**Kind:** Theorem
**Status:** VERIFIED (numerical, 47 certified digits per bracket)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T7 (§1.3, auditor C3)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T7 | certified root brackets for `N = 3..50` | **VERIFIED** | §1.3, auditor C3, script §4 |

The §1.3 numbered form:

> **Theorem 6 (certified root table).** For every `N` in the table there is a *sign change* of `Re S_N` on the stated rational bracket, hence a root inside it. The computation is done with the `ivmath` engine (value + guaranteed error), so the brackets are certificates, not estimates.
>
> | N | certified bracket of the smallest positive root | width |
> |---|---|---|
> | 3 | [2.42665205162968924406, +8.76e-47] | 47 digits (auditor) |
> | 4 | [1.85039292764260780631, +8.76e-47] | 47 digits (auditor) |
> | 5 | [1.55009817600781349235, +8.76e-47] | 47 digits (auditor) |
> | 6 | [1.36250808733474170983, +8.76e-47] | 47 digits (auditor) |
> | 8 | [1.13684395014600383258, +8.76e-47] | 47 digits (auditor) |
> | 10 | [1.00316316617548533919, +8.76e-47] | 47 digits (auditor) |
> | 12 | [0.91319827876062629357, +8.76e-47] | 47 digits (auditor) |
> | 20 | [0.72461569909908482871, +8.76e-47] | 47 digits (auditor) |
> | 50 | [0.52144338691777468350, +8.76e-47] | 47 digits (auditor) |

## Hypotheses and notation

- `N` in the nine tabulated values; the wider computation covers `N = 3, …, 20, 25, 30, 40, 50`.
- Each bracket is `[a, a + 8.76e-47]` and contains a certified sign change of `Re S_N`; by the auditor's C3 each is certified as the *smallest* positive root via "no zero on `[0, s_lo]`" plus a strict derivative sign on `[s_lo, b]`.
- Round's own script widths: `3.5e-21` for `N <= 16`, `1.2e-13` at `N = 20`, `2.4e-10` at `N = 30`, `4.9e-07` at `N = 40`, `1.2e-07` at `N = 50`.

## Proof / evidence

- Ledger row T7: "**VERIFIED**", evidence "§1.3, auditor C3, script §4".
- The nine 47-digit brackets come from the auditor's independent engine ([`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py), check C3); the script reproduces its own brackets by bisection with `ivmath`.

## Dependencies and related results

- The numbered form is [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md).
- Related: [T8](tpp-rh43-truths-existence-every-n-ledger.md).

## Notes

- Ledger row T7 restates §1.3 Theorem 6; the precision warning about `mpmath.findroot` is part of that statement.
