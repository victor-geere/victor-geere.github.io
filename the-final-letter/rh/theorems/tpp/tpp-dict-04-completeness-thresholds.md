# Theorem 2.2 (completeness thresholds)

**Kind:** Theorem
**Status:** PROVED (paper argument; source also NUMERICAL, 70/70 checks in `rh42/verify/reachable.log`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §2 "The exact reachable set (rh42)", "Theorem 2.2 (completeness thresholds)", line 59

## Statement

> **Theorem 2.2 (completeness thresholds).**
> ```
> positive half complete (S = [0,P])  ⟺  ζ(p) ≥ 2            ⟺  p ≤ p* = 1.7286472389981836…
> negative half complete (S = [0,N])  ⟺  N(p) ≥ 2·3^{−p}     ⟺  p ≤ q  = 2.0767751792…
> ```

## Hypotheses and notation

- `S` is the reachable set of sub-sums over arbitrary subsets of the half-series in question; `P = P(p)` and `N = N(p)` are the positive/negative budgets of [Theorem 1.1](tpp-dict-04-even-odd-split-of-zeta.md).
- "positive half complete" means `S = [0,P]`; "negative half complete" means `S = [0,N]`.
- Completeness of the half is decided by Brown's criterion, [Theorem 2.1](tpp-dict-04-brown-criterion.md).
- `p* = 1.7286472389981836…` and `q = 2.0767751792…` are the threshold exponents. The right-hand inequalities are printed with different precision: `p*` to 16 decimals, `q` to 10 decimals.

## Proof / evidence

The source gives no separate proof for this item. The joint status line placed after Theorem 2.3 covers §2's Theorems 2.2 and 2.3:

> *Status:* THEOREM + NUMERICAL (`rh42/verify/reachable.log`, 70/70 checks).

## Dependencies and related results

- [Theorem 2.1 (Brown's criterion)](tpp-dict-04-brown-criterion.md) — the completeness criterion reduced to the two threshold inequalities.
- [Theorem 2.3 (census)](tpp-dict-04-census-of-reachable-set.md) — what happens beyond the thresholds.
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) restates the same two thresholds and points to `rh42/lean/Rh42/Reachable.lean` and `Budget.lean`.

## Notes

- Ledger entry for the **rh42** round (section headed "(rh42)"). The existing harvest file [Theorem 8 (completeness thresholds)](tpp-rh42-truths-theorem-8-completeness-thresholds.md) records the same **rh42** statement.
- The source gives no numerical enclosure for `p*` or `q` beyond the printed digits; no additional precision is asserted here.
