# Theorem 11′ — the term-level two-and-two split fails at the certified roots

**Kind:** Theorem
**Status:** REFUTED (strict reading) + VERIFIED (exhaustive subset-sum)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §3 "The four-part split: two readings, opposite answers" (ledger row T9′)

## Statement

> **Theorem 11′ (the term-level split fails, and this is a *different* question).** If "two equal positive parts" is read as *the positive **terms** partition into two subsets of equal sum* (and likewise for the negative terms), then the split does **not** exist at the certified roots. At `N = 6`, `t = 1.3625080873347417…`: `P = 1.660074847…`, so `P/2 = 0.830037423…`, while the best subset of the positive terms sums to `0.660074847…` — an exact subset-sum defect of `0.169962576…`; the negative side is short of `|M|/2` by `0.065392329…`.

## Hypotheses and notation

- The term-level reading (**R2′**): the positive terms partition into two subsets of equal sum, and the negative terms likewise.
- At the certified root `N = 6`, `t = 1.3625080873347417…`: positive total `P = 1.660074847…`, `P/2 = 0.830037423…`, best positive subset sum `0.660074847…`, exact defect `0.169962576…`; negative-side defect `0.065392329…` from `|M|/2`.
- The structural obstruction is `cos(t log 1) = 1` (truths.md §3, Theorem 11′) — see the sibling file for the full statement.

## Proof / evidence

- Ledger row T9′: status "**REFUTED** (strict reading) + **VERIFIED**", evidence "§3, script §5".
- **VERIFIED** exactly by exhaustive subset-sum over the positive and negative term sets at the certified roots ([`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §5).
- HANDOFF.md §2.5 gives the same `0.16996…` defect at `N = 6`.

## Dependencies and related results

- The complete statement with the structural cause, the `P` values `1.00, 1.28, 1.48, 1.66, 2.02, 2.40, 2.74` for `N = 3,4,5,6,8,10,12`, and the `N = 3` single-term case is [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md).
- Contrast [Theorem 11 (the numeric split is exact)](tpp-rh43-truths-numeric-split-exact.md) (T9); refuted statement [F7](tpp-rh43-truths-f7-balance-implies-term-split-refuted.md).

## Notes

- Ledger row T9′ and §3 Theorem 11′ are the same result stated twice (ledger form and numbered-theorem form); this file records the ledger row, the sibling file records the numbered theorem.
- The general question — whether the term-level split can ever succeed at *some* balance point of some `N` — is **OPEN** in the source.
