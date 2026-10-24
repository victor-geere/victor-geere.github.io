# Theorem 2.3 (census)

**Kind:** Theorem
**Status:** PROVED (paper argument; source also NUMERICAL, 70/70 checks in `rh42/verify/reachable.log`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §2 "The exact reachable set (rh42)", "Theorem 2.3 (census)", line 64

## Statement

> **Theorem 2.3 (census).**  For `n < n_min(p)` the two pieces of
> `S_n = S_{n+1} ∪ (a_n + S_{n+1})` are disjoint, so `S_1` is a union of exactly
> `2^{n_min(p)−1}` intervals of total measure `2^{n_min−1} T_{n_min}`; the reachable
> fraction of the budget collapses to `0` as `p → ∞`.

## Hypotheses and notation

- `S_n` is the reachable set built from the tail of the sequence (`S_1` being the full reachable set), with the recursive splitting `S_n = S_{n+1} ∪ (a_n + S_{n+1})`.
- `n_min(p)` is the source's onset index at which the two pieces of the recursion first meet.
- `T_{n_min}` is the tail sum at that index, in the notation of [Theorem 2.1](tpp-dict-04-brown-criterion.md).
- The statement concerns the regime beyond the completeness thresholds of [Theorem 2.2](tpp-dict-04-completeness-thresholds.md), where the reachable set is a finite union of intervals.

## Proof / evidence

The source gives no separate proof for this item. The joint status line placed after this theorem covers §2's Theorems 2.2 and 2.3:

> *Status:* THEOREM + NUMERICAL (`rh42/verify/reachable.log`, 70/70 checks).

## Dependencies and related results

- [Theorem 2.1 (Brown's criterion)](tpp-dict-04-brown-criterion.md) and [Theorem 2.2 (completeness thresholds)](tpp-dict-04-completeness-thresholds.md).
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) restates: "Beyond `p*` the reachable set is a union of exactly `2^{n_min(p)−1}` disjoint intervals."

## Notes

- Ledger entry for the **rh42** round (section headed "(rh42)"). The existing harvest file [Theorem 10 (census)](tpp-rh42-truths-theorem-10-census.md) records the same **rh42** statement.
- The source does not define `n_min(p)` beyond its use here; the notation is reproduced as printed.
