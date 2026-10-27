# Theorem 1.3 (the pole, halved)

**Kind:** Theorem
**Status:** PROVED (paper argument; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §1 "The sign budgets (rh42)", "Theorem 1.3 (the pole, halved)", line 25

## Statement

> **Theorem 1.3 (the pole, halved).**  `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1`: the pole of
> `ζ` appears **once on each side**.

## Hypotheses and notation

- `P`, `N` as in [Theorem 1.1](tpp-dict-04-even-odd-split-of-zeta.md).
- `p ↓ 1` means `p → 1` from above; this is the asymptotic regime of the pole of `ζ` at `p = 1`.

## Proof / evidence

The source gives no separate proof for this item; it carries only the joint §1 status line (quoted in full in [Theorem 1.1](tpp-dict-04-even-odd-split-of-zeta.md)):

> *Status:* THEOREM (`rh42/lean/Rh42/Budget.lean` proves the closed forms
> `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`,
> `P(2)+N(2) = π²/6 − 1` from Mathlib's `hasSum_zeta_two/four`) + NUMERICAL
> (`rh42/verify/helix_zeta.log`).

The Lean declarations listed cover the closed forms at `p = 2, 4`, not this `p ↓ 1` asymptotic; the asymptotic itself is stated as THEOREM and supported by the numerical log.

## Dependencies and related results

- [Theorem 1.1 (the even/odd split of ζ)](tpp-dict-04-even-odd-split-of-zeta.md) and [Theorem 1.2 (the algebra)](tpp-dict-04-sign-budget-algebra.md).
- The existing harvest file [Theorem 4 (T5, H4)](tpp-rh42-truths-theorem-4-pole-asymptotics.md) records the same **rh42** statement.

## Notes

- Ledger entry: §1 of this dictionary chapter is headed "(rh42)"; the result restates the **rh42** round.
