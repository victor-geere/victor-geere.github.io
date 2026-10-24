# `S_3(t) ≠ 0` for every real `t`; `S_2(π/log 2) = 0` exactly

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D6, line 82

## Statement

The ledger row, verbatim:

> | D6 | `S_3(t) ≠ 0` for every real `t`; `S_2(π/log 2) = 0` exactly | THEOREM (Lean) | rh43 §2 |

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` at `σ = 0`; here `N = 2, 3`.
- The first clause is a non-vanishing statement for all real `t`; the second is an **exact** evaluation at the single height `t = π/log 2`.

## Proof / evidence

The ledger records `THEOREM (Lean)` with source `rh43 §2` and gives no proof text. The same pair is recorded in the capstone chapter as [P9 — S₃ has no zero, S₂ vanishes at π/log 2](tpp-dict-05-s3-nonvanishing-s2-zero.md).

## Dependencies and related results

- [D4 — `N = 2` balances exactly at `t = π/log 2`](tpp-dict-00-n2-balance-at-pi-over-log2.md), which is the same exact evaluation read as a balance.
- [D5 — `N = 3` balances by sign change](tpp-dict-00-n3-balance-by-sign-change.md): the balance there is a sign change of the *real part*, not a zero of `S_3`.
- [The balance identity](tpp-dict-00-balance-split-identity.md) (D2).

## Notes

- Ledger entry restating round **rh43** (§2).
- The distinction between *balance* (`Re S_N = 0`) and *vanishing* (`S_N = 0`) is essential here: `N = 3` balances but never vanishes.
