# the factor-complexity law `p(L)` (plateau, C1 regime)

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. B — the greedy harmonic sine", row B2, line 51

## Statement

The ledger row, verbatim:

> | B2 | the factor-complexity law `p(L)` (plateau, C1 regime) | THEOREM (Lean) | rh41 `TRUTHS.md`, `lean/` |

The row is a **name-only** entry: it states no formula. The law itself is set out in round **rh41** (`TRUTHS.md` and the round's `lean/` directory), to which the ledger points.

## Hypotheses and notation

- `p(L)` is the factor-complexity function of the greedy word; the ledger restricts this row's validity to the **plateau, C1 regime**.
- `L` is the factor length.
- No formula or range for `L` is given in this row.

## Proof / evidence

The ledger records `THEOREM (Lean)` and cites rh41 `TRUTHS.md` and `lean/`. The dictionary itself gives no proof.

## Dependencies and related results

- The sister capstone chapter states the same law as its item P1: [the factor-complexity law](tpp-dict-05-factor-complexity-law.md) (`p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for `L ≥ a_m+1`).
- The greedy word itself is defined in [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) (ledger row B1, a **DEFINITION**, not harvested).

## Notes

- Ledger entry restating round **rh41**; the status is quoted exactly, including the C1-regime restriction.
