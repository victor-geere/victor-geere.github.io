# Theorem 3.5 (the term-level split fails)

**Kind:** Theorem
**Status:** VERIFIED (numerical, exhaustive exact subset-sum)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §3 "The balance split at `Re(S) = 0` (rh43)", "Theorem 3.5 (the term-level split fails)", line 99

## Statement

> **Theorem 3.5 (the term-level split fails).**  At a balance point the *numbers*
> `P/2, P/2, M/2, M/2` are two equal positive and two equal negative pieces, but the
> *terms* usually cannot be partitioned into two equal sub-sums: at `N = 6`,
> `P/2 = 0.830037…` while the best subset sums to `0.660075…` (exact defect
> `0.169962576…`); at `N = 20` the exact defect is `0.005557721…`.
> *Status:* NUMERICAL (exhaustive exact subset-sum).
> *The obstruction:* `cos(t log 1) = 1` is the largest positive term; it exceeds `P/2`
> whenever `P < 2`.

## Hypotheses and notation

- The setting is a balance point of §3, where by [Theorem 3.1](tpp-dict-04-balance-split-identity.md) `P_N = |M_N|`; `P` is the total positive part and `M` the total negative part of the terms.
- "Best subset" = the subset of the positive terms whose sum is closest to `P/2`; the defect is `P/2` minus that sum.
- The obstruction concerns `cos(t log 1) = 1`, the `n = 1` term, the largest positive term.

## Proof / evidence

The source's status line is "NUMERICAL (exhaustive exact subset-sum)", and the two exact defects quoted (`0.169962576…` at `N = 6`, `0.005557721…` at `N = 20`) are the evidence. No proof is given; the result is a finite computation only.

## Dependencies and related results

- [Theorem 3.1 (the identity)](tpp-dict-04-balance-split-identity.md) — the number-level balance that this theorem says does not lift to the term level.

## Notes

- Ledger entry for the **rh43** round (section headed "(rh43)").
- The theorem is numerical-only, and the word "usually" in the source's statement is reproduced: this is not a claim that no `N` admits an equal partition.
