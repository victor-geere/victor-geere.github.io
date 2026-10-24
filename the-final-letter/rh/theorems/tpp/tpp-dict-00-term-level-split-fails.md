# the term-level two-and-two split fails at balance points

**Kind:** Theorem
**Status:** VERIFIED (numerical, exact subset-sum)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D7, line 83

## Statement

The ledger row, verbatim:

> | D7 | the term-level two-and-two split **fails** at balance points | NUMERICAL (exact subset-sum) | rh43 §3 |

## Hypotheses and notation

- "Balance points" are the heights with `Re S_N(t) = 0` ([D2](tpp-dict-00-balance-split-identity.md), [D3](tpp-dict-00-existence-of-balance-heights.md)).
- "The term-level two-and-two split" is the programme's attempted pairing of terms at such a height; the ledger records that it **fails**.
- The evidence type is **exact subset-sum** computation (not an asymptotic argument).

## Proof / evidence

The ledger records `NUMERICAL (exact subset-sum)` with source `rh43 §3`; no proof is given in the dictionary. The zeta-relations chapter records the same as [the term-level split fails](tpp-dict-04-term-level-split-fails.md).

## Dependencies and related results

- [The balance identity](tpp-dict-00-balance-split-identity.md) (D2) and [the existence of balance heights](tpp-dict-00-existence-of-balance-heights.md) (D3).
- [The term-level two-and-two split of the correlation](tpp-dict-00-correlation-not-multiplicative.md) is a different failure (no Euler product) recorded under F3.

## Notes


- This is a **negative** result recorded by a finite (exact) computation; the ledger labels it `NUMERICAL`, so it is harvested as VERIFIED (numerical), never as a theorem.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh43/verify/zeta_split.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
