# `P_N + M_N = Re S_N`; balance ⟺ `P_N = \|M_N\|` ⟺ `Re S_N(t) = 0`

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D2, line 78

## Statement

The ledger row, verbatim:

> | D2 | `P_N + M_N = Re S_N`; balance ⟺ `P_N = \|M_N\|` ⟺ `Re S_N(t) = 0` | THEOREM (Lean) | rh43 `Balance.lean` |

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}`, the zeta partial sum at `σ = 0`; `P_N(t)` and `M_N(t)` are the **positive and negative real parts** of `S_N(t)` — the split by sign of `cos(t log n)` (ledger row D1, a **DEFINITION**, not harvested).
- "Balance" means `P_N = |M_N|`; the row identifies it with `Re S_N(t) = 0`.
- As written in the source, the absolute value is escaped: `\|M_N\|`.

## Proof / evidence

The ledger records `THEOREM (Lean)` and names `rh43 Balance.lean`; it gives no proof text. The same identity is recorded in the capstone chapter as [P7 — the balance identity](tpp-dict-05-balance-identity.md) and in the zeta-relations chapter as [the balance split identity](tpp-dict-04-balance-split-identity.md).

## Dependencies and related results

- The existence question for such a height: [for every `N ≥ 2` there is a height with `Re S_N(t) = 0`](tpp-dict-00-existence-of-balance-heights.md) (D3), with the explicit cases [D4](tpp-dict-00-n2-balance-at-pi-over-log2.md) and [D5](tpp-dict-00-n3-balance-by-sign-change.md).
- The definitional split is row D1 of the same index (not harvested: it is a **DEFINITION**).

## Notes

- Ledger entry restating round **rh43**; the Lean file named is `Balance.lean`.
- The relation is an identity between the parts and the real part; the "balance ⟺" clauses are equivalences stated by the ledger and are not weakened or strengthened here.
