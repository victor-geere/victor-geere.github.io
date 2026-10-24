# Theorem 6 (certified root table)

**Kind:** Theorem
**Status:** VERIFIED (numerical, 47 certified digits per bracket)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.3 "Roots for every `N = 3, …, 50`, certified" (ledger row T7)

## Statement

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

The round's own script brackets the same roots with its `ivmath` engine (bisection to widths `3.5e-21` for `N <= 16`, `1.2e-13` at `N = 20`, `2.4e-10` at `N = 30`, `4.9e-07` at `N = 40`, `1.2e-07` at `N = 50`, with a sign change certified at each step; `verify/zeta_split.log` §4), and for every `N = 3, …, 20, 25, 30, 40, 50`.

These nine brackets, each with 47 certified digits, come from the auditor's independent engine ([`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py), C3); each is certified by "no zero on `[0, s_lo]`" together with a strict derivative sign on `[s_lo, b]`, so the root is the *smallest* positive one. The main script reproduces its own brackets by bisection with the `ivmath` engine (**VERIFIED**).

> **A warning worth carrying.** `mpmath.findroot` with its default tolerance returns `2.4266520516296892218…` for the `N = 3` root — wrong from the 18th digit. The true value is `2.426652051629689244058575646886684647621…`. Any round value quoted to more than ~17 digits must come from a certified bracket.

## Hypotheses and notation

- `N` takes the nine tabulated values `3, 4, 5, 6, 8, 10, 12, 20, 50`; the wider computation covers `N = 3, …, 20, 25, 30, 40, 50`.
- Each bracket is a rational interval `[a, a + 8.76e-47]` containing a sign change of `Re S_N`; `s_lo` and `b` are the bracket endpoints used in the smallest-root certification.
- `ivmath.py` is "the rigorous engine: `Num` = value + guaranteed error at 400 dps"; the auditor's engine uses fixed-point directed rounding.

## Proof / evidence

- **VERIFIED** — ledger row T7, evidence "§1.3, auditor C3, script §4".
- The nine 47-digit brackets come from [`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py) check C3; the auditor's complete run reports **102/102 checks pass**.
- [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §4 reproduces its own brackets by bisection with the `ivmath` engine.

## Dependencies and related results

- Uses the `ivmath` engine ([`ivmath.py`](../../research/twin-prime-parity/rounds/rh43/ivmath.py)) and the auditor's independent engine.
- Related: [Existence for every N >= 3](tpp-rh43-truths-existence-every-n.md) (T8); [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md) (T5).

## Notes

- The brackets are certificates of a *sign change* on the stated interval, hence of a root inside it; the widest bracket is `[a, a + 8.76e-47]`.
- The precision warning is part of the source's statement: `mpmath.findroot`'s default tolerance is wrong from the 18th digit for the `N = 3` root.
