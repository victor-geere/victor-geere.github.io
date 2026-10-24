# `N = 2` balances exactly at `t = π/log 2` (tangential zero)

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D4, line 80

## Statement

The ledger row, verbatim:

> | D4 | `N = 2` balances **exactly** at `t = π/log 2` (tangential zero) | THEOREM (Lean) | rh43 |

## Hypotheses and notation

- `S_2(t) = 1 + 2^{−it}`; "balances" means `Re S_2(t) = 0` ([D2](tpp-dict-00-balance-split-identity.md)).
- The height is `t = π/log 2`; the ledger calls this a **tangential zero** (the zero touches without crossing).
- The word "exactly" is the ledger's.

## Proof / evidence

The ledger records `THEOREM (Lean)` with source `rh43` and gives no proof text. The companion statements are [D5](tpp-dict-00-n3-balance-by-sign-change.md) (`N = 3` by sign change) and [D6](tpp-dict-00-s3-nonvanishing.md) (`S_2(π/log 2) = 0` exactly); the capstone chapter records the same as [P9 — S₃ has no zero, S₂ vanishes at π/log 2](tpp-dict-05-s3-nonvanishing-s2-zero.md).

## Dependencies and related results

- [The balance identity](tpp-dict-00-balance-split-identity.md) (D2) and [the existence of balance heights](tpp-dict-00-existence-of-balance-heights.md) (D3).
- The contrast with `N = 3`: [S₃ has no zero](tpp-dict-00-s3-nonvanishing.md).

## Notes

- Ledger entry restating round **rh43**.
- "Tangential" is the source's term for the character of this zero; the pairing with [D6](tpp-dict-00-s3-nonvanishing.md) (the same height is an exact zero of `S_2`) is the ledger's, not an added remark.
