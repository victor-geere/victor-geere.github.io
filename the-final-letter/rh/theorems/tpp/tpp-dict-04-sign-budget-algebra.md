# Theorem 1.2 (the algebra)

**Kind:** Theorem
**Status:** PROVED (Lean: §1 closed forms in `Rh42/Budget.lean` at `p = 2, 4`; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §1 "The sign budgets (rh42)", "Theorem 1.2 (the algebra)", line 20

## Statement

> **Theorem 1.2 (the algebra).**  For every `p > 1`,
> ```
> P + N = ζ(p) − 1 ,   P − N = 1 − η(p) ,   P = (ζ−η)/2 ,   N = (ζ+η−2)/2 ,
> ```
> and `P(p) > N(p)` for all `p > 0` (the asymmetry is exactly `1 − η(p)`).

## Hypotheses and notation

- `P`, `N`, `η` as in [Theorem 1.1](tpp-dict-04-even-odd-split-of-zeta.md): `P = Σ_{k≥1}(2k)^{−p}`, `N = Σ_{k≥1}(2k+1)^{−p}`, `η(p) = Σ_{n≥1}(−1)^{n−1} n^{−p}`.
- The four identities are asserted **for every `p > 1`**; the inequality `P(p) > N(p)` is asserted **for all `p > 0`**, exactly as printed.

## Proof / evidence

The source gives no separate proof for this item; it carries only the joint §1 status line (quoted in full in [Theorem 1.1](tpp-dict-04-even-odd-split-of-zeta.md)):

> *Status:* THEOREM (`rh42/lean/Rh42/Budget.lean` proves the closed forms
> `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`,
> `P(2)+N(2) = π²/6 − 1` from Mathlib's `hasSum_zeta_two/four`) + NUMERICAL
> (`rh42/verify/helix_zeta.log`).

## Dependencies and related results

- [Theorem 1.1 (the even/odd split of ζ)](tpp-dict-04-even-odd-split-of-zeta.md), which supplies the closed forms of `P`, `N`, `η`.
- The inequality `P(p) > N(p)` for all `p > 0` restates the corresponding **rh42** result, also recorded in the existing harvest file [Theorem 3 (T4)](tpp-rh42-truths-theorem-3-p-gt-n.md).
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) restates `P + N = ζ(p) − 1`, `P − N = 1 − η(p)`, `P > N for all p > 0`.

## Notes

- Ledger entry: §1 of this dictionary chapter is headed "(rh42)", so the result restates the **rh42** round.
- The source prints the first display for `p > 1` and the inequality for `p > 0`; the difference in range is in the source and is not smoothed over here.
