# negative budget `N(p) = Σ_{k≥1}(2k+1)^{−p} = (1−2^{−p})ζ(p)−1`

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C2, line 64

## Statement

The ledger row, verbatim:

> | C2 | negative budget `N(p) = Σ_{k≥1}(2k+1)^{−p} = (1−2^{−p})ζ(p)−1` | THEOREM | rh42 §2 |

## Hypotheses and notation

- `N(p) = Σ_{k≥1}(2k+1)^{−p}` is the **negative budget**, the total available on the odd indices.
- `ζ` is the Riemann zeta function; `p` is the exponent of the Tau alphabet `α_n = (−1)^n/(n+2)^p` (ledger row B3, a **DEFINITION**, not harvested).
- The closed form subtracts the missing `k = 0` term: `(1−2^{−p})ζ(p) = Σ_{k≥1}(2k−1)^{−p}`, so `N(p) = (1−2^{−p})ζ(p) − 1`.

## Proof / evidence

The ledger records `THEOREM` with source `rh42 §2` and gives no proof. The capstone chapter records the closed forms (with Lean provenance at `p = 2, 4`) as [P2 — the budgets](tpp-dict-05-budget-algebra.md) and [the even/odd split of ζ](tpp-dict-04-even-odd-split-of-zeta.md).

## Dependencies and related results

- [Positive budget `P(p) = Σ_{k≥1}(2k)^{−p} = 2^{−p}ζ(p)`](tpp-dict-00-positive-budget.md) (C1).
- [The budget relations](tpp-dict-00-budget-relations.md) (C3): `P+N = ζ−1`, `P−N = 1−η`.
- `η` from [the eta identity](tpp-dict-00-eta-functional-identity.md) (A2).

## Notes

- Ledger entry restating round **rh42** (§2).
- The ledger's status here is plain `THEOREM` (contrast row C1, which is Lean-restricted to `p = 2, 4`).
