# censused reachable set: `2^{n_min−1}` intervals, measure `2^{n_min−1}T_{n_min}`

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C8, line 70

## Statement

The ledger row, verbatim:

> | C8 | censused reachable set: `2^{n_min−1}` intervals, measure `2^{n_min−1}T_{n_min}` | THEOREM | rh42 §3 |

## Hypotheses and notation

- "The reachable set" is the set of sub-sums of the budget sequence (the object governed by [Brown's criterion](tpp-dict-00-brown-criterion.md), C5).
- `n_min` is the least index at which the completeness condition of Brown's criterion fails; `T_{n_min} = Σ_{k≥n_min} a_k` is the corresponding tail sum.
- The census says the reachable set is a union of exactly `2^{n_min−1}` intervals, with total measure `2^{n_min−1} T_{n_min}`.

## Proof / evidence

The ledger records `THEOREM` with source `rh42 §3` and gives no proof. The round's statement is [Theorem 10 — census](tpp-rh42-truths-theorem-10-census.md); the capstone chapter records the same count as [P4 — completeness thresholds](tpp-dict-05-completeness-thresholds.md) and the zeta-relations chapter as [census of the reachable set](tpp-dict-04-census-of-reachable-set.md).

## Dependencies and related results

- [Brown's criterion](tpp-dict-00-brown-criterion.md) (C5) supplies `n_min`.
- Thresholds [C6](tpp-dict-00-positive-half-complete-threshold.md), [C7](tpp-dict-00-negative-half-complete-threshold.md): when the half is complete, `n_min` is infinite and the census degenerates.
- The related growth of the interval count is recorded in the round as [R8 — interval count growth](tpp-rh42-truths-r8-interval-count-growth.md).

## Notes

- Ledger entry restating round **rh42** (§3).
- `n_min` is used by the ledger's own phrasing without further definition in this row; the round's file carries the definition.
