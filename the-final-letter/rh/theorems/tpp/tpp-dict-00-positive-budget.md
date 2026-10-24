# positive budget `P(p) = Σ_{k≥1}(2k)^{−p} = 2^{−p}ζ(p)`

**Kind:** Theorem
**Status:** PROVED (Lean at `p=2,4`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C1, line 63

## Statement

The ledger row, verbatim:

> | C1 | positive budget `P(p) = Σ_{k≥1}(2k)^{−p} = 2^{−p}ζ(p)` | THEOREM (Lean at `p=2,4`) | rh42 §2 |

## Hypotheses and notation

- `P(p) = Σ_{k≥1}(2k)^{−p}` is the **positive budget**, the total available on the even indices.
- `ζ` is the Riemann zeta function; `p` is the exponent of the Tau alphabet `α_n = (−1)^n/(n+2)^p` (ledger row B3, a **DEFINITION**, not harvested).
- The Lean leg is explicitly limited to `p = 2, 4` by the ledger's own parenthetical.

## Proof / evidence

The ledger records `THEOREM (Lean at p=2,4)` with source `rh42 §2` and gives no proof. The capstone chapter records the same closed forms with their Lean provenance as [P2 — the budgets](tpp-dict-05-budget-algebra.md) and [the even/odd split of ζ](tpp-dict-04-even-odd-split-of-zeta.md).

## Dependencies and related results

- [Negative budget `N(p) = Σ_{k≥1}(2k+1)^{−p} = (1−2^{−p})ζ(p)−1`](tpp-dict-00-negative-budget.md) (C2).
- [The budget relations](tpp-dict-00-budget-relations.md) (C3) and [the pole split](tpp-dict-00-pole-split-budgets.md) (C4).

## Notes

- Ledger entry restating round **rh42** (§2).
- The status is quoted with the source's own restriction: the Lean development covers `p = 2, 4`, not all `p`.
