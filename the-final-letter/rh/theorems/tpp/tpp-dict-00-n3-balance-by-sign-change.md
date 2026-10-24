# `N = 3` balances via `Re S_3(5/2) < 0 < 3 = Re S_3(0)`

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D5, line 81

## Statement

The ledger row, verbatim:

> | D5 | `N = 3` balances via `Re S_3(5/2) < 0 < 3 = Re S_3(0)` | THEOREM (Lean) | rh43 |

## Hypotheses and notation

- `S_3(t) = 1 + 2^{−it} + 3^{−it}`; balance means `Re S_3(t) = 0` ([D2](tpp-dict-00-balance-split-identity.md)).
- The two endpoint evaluations are `Re S_3(5/2) < 0` and `Re S_3(0) = 3`; the sign change locates a balance height in `(0, 5/2)`.

## Proof / evidence

The ledger records `THEOREM (Lean)` with source `rh43` and gives no proof text. The companion statements are [D3](tpp-dict-00-existence-of-balance-heights.md) (existence for every `N ≥ 2`), [D4](tpp-dict-00-n2-balance-at-pi-over-log2.md) (`N = 2`) and [D6](tpp-dict-00-s3-nonvanishing.md) (`S_3` never vanishes); the capstone chapter records the same as [P8 — balance is attained for every `N ≥ 2`](tpp-dict-05-balance-attained-every-n.md).

## Dependencies and related results

- [The balance identity](tpp-dict-00-balance-split-identity.md) (D2).
- **Not** an exact-zero statement: by [D6](tpp-dict-00-s3-nonvanishing.md), `S_3(t) ≠ 0` for every real `t`, so here only the *real part* changes sign.

## Notes

- Ledger entry restating round **rh43**.
- The numbers `5/2` and `3` are quoted exactly as in the ledger.
