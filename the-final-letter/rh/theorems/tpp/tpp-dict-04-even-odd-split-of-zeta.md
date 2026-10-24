# Theorem 1.1 (the even/odd split of ζ)

**Kind:** Theorem
**Status:** PROVED (Lean: closed forms at `p = 2` and `p = 4` in `Rh42/Budget.lean`; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §1 "The sign budgets (rh42)", "Theorem 1.1 (the even/odd split of ζ)", line 14

## Statement

> ```
> P(p) = Σ_{k≥1} (2k)^{−p}    = 2^{−p} ζ(p)
> N(p) = Σ_{k≥1} (2k+1)^{−p}  = (1 − 2^{−p}) ζ(p) − 1
> η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)   (p ≠ 1),   η(1) = ln 2
> ```

`P(p)` is the even-denominator ("positive") budget, `N(p)` the odd-denominator ("negative") budget, and `η` the alternating series.

## Hypotheses and notation

- `P(p) = Σ_{k≥1} (2k)^{−p}` — the positive budget.
- `N(p) = Σ_{k≥1} (2k+1)^{−p}` — the negative budget.
- `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p}`, with the separate value `η(1) = ln 2` at `p = 1`, where the first closed form fails (`p ≠ 1`).
- The source prints no explicit range of `p` in this block; the neighbouring Theorem 1.2 states its algebra "for every `p > 1`", and Theorem 1.3 concerns `p ↓ 1`.
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) also calls these the "positive budget" and the "negative budget".

## Proof / evidence

The source gives one joint status line for §1 (Theorems 1.1–1.3), quoted verbatim:

> *Status:* THEOREM (`rh42/lean/Rh42/Budget.lean` proves the closed forms
> `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`,
> `P(2)+N(2) = π²/6 − 1` from Mathlib's `hasSum_zeta_two/four`) + NUMERICAL
> (`rh42/verify/helix_zeta.log`).

The Lean formalisation therefore covers the closed forms at `p = 2` and `p = 4` listed above; the general-`p` closed forms are stated by the source and backed by the numerical log.

## Dependencies and related results

- Mathlib's `hasSum_zeta_two` and `hasSum_zeta_four`.
- [Theorem 1.2 (the algebra)](tpp-dict-04-sign-budget-algebra.md) and [Theorem 1.3 (the pole, halved)](tpp-dict-04-pole-halved.md), the other two results of §1.
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) restates the budgets `P(p) = 2^{−p} ζ(p)` and `N(p) = (1 − 2^{−p}) ζ(p) − 1`.

## Notes

- The dictionary chapter is a ledger and §1 is explicitly headed "(rh42)": the result restates the **rh42** round of the programme.
- The parity caveat printed immediately after §1 is a separate, unlabelled blockquote, not a numbered result, and is not harvested here. It records that these budgets separate **index** parity and are sign-blind constants carrying no information about `Ω`-parity; measured `χ²(1) = 2.944` (`z = 0.99`) at `N = 10⁷`, and `Σ λ(n)(−1)^n λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly.
