# negative half complete iff `p ≤ q = 2.0767752…`

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C7, line 69

## Statement

The ledger row, verbatim:

> | C7 | negative half complete **iff** `p ≤ q = 2.0767752…` | THEOREM | rh42 §3 |

## Hypotheses and notation

- "The negative half" is the reachable set generated from the negative budget `N(p)` ([C2](tpp-dict-00-negative-budget.md)); "complete" is in the sense of [Brown's criterion](tpp-dict-00-brown-criterion.md).
- `q` is defined by `N(q) = 2·3^{−q}` (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §1).
- The numerical value is quoted exactly as in the ledger: `q = 2.0767752…` (the ellipsis is the source's).

## Proof / evidence

The ledger records `THEOREM` with source `rh42 §3` and gives no proof text. The round's statement is [Theorem 8 (completeness thresholds)](tpp-rh42-truths-theorem-8-completeness-thresholds.md); the capstone chapter's item P4 is [the completeness thresholds](tpp-dict-05-completeness-thresholds.md).

## Dependencies and related results

- [Brown's criterion](tpp-dict-00-brown-criterion.md) (C5) and the negative budget [C2](tpp-dict-00-negative-budget.md).
- [Positive half complete iff `ζ(p) ≥ 2`](tpp-dict-00-positive-half-complete-threshold.md) (C6), and [the four thresholds `pN < pP < p* < q`](tpp-dict-00-four-thresholds.md) (C9), where `q` is the largest.

## Notes

- Ledger entry restating round **rh42** (§3).
- The defining equation `N(q) = 2·3^{−q}` is quoted from the source's notation table; the threshold value is preserved digit-for-digit (`2.0767752…`).
