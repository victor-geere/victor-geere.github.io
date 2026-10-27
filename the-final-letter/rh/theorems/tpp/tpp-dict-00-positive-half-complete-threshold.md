# positive half complete iff `ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472…`

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C6, line 68

## Statement

The ledger row, verbatim:

> | C6 | positive half complete **iff** `ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472…` | THEOREM | rh42 `Reachable.lean` |

## Hypotheses and notation

- "The positive half" is the reachable set generated from the positive budget `P(p)` ([C1](tpp-dict-00-positive-budget.md)); "complete" means the sub-sums fill the full interval, in the sense of [Brown's criterion](tpp-dict-00-brown-criterion.md).
- `p*` is defined by `ζ(p*) = 2` (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §1).
- The numerical value is quoted exactly as in the ledger: `p* = 1.7286472…` (the ellipsis is the source's).

## Proof / evidence

The ledger records `THEOREM` and names the Lean file `rh42 Reachable.lean`; it gives no proof text. The round's statement is [Theorem 8 (completeness thresholds)](tpp-rh42-truths-theorem-8-completeness-thresholds.md); the capstone chapter's item P4 is [the completeness thresholds](tpp-dict-05-completeness-thresholds.md).

## Dependencies and related results

- [Brown's criterion](tpp-dict-00-brown-criterion.md) (C5).
- [Negative half complete iff `p ≤ q = 2.0767752…`](tpp-dict-00-negative-half-complete-threshold.md) (C7) and [the four thresholds](tpp-dict-00-four-thresholds.md) (C9).
- The pole split [C4](tpp-dict-00-pole-split-budgets.md) explains why `p = 1` is the boundary regime.

## Notes

- Ledger entry restating round **rh42**; the Lean file named is `Reachable.lean`.
- The threshold value is preserved digit-for-digit (`1.7286472…`); no further precision is claimed by this row.
