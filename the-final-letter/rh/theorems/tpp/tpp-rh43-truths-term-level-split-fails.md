# Theorem 11′ (the term-level split fails, and this is a *different* question)

**Kind:** Theorem
**Status:** REFUTED (strict reading) + VERIFIED (exhaustive subset-sum at the certified roots); the general question is OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §3 "The four-part split: two readings, opposite answers" (ledger row T9′)

## Statement

> **Theorem 11′ (the term-level split fails, and this is a *different* question).** If "two equal positive parts" is read as *the positive **terms** partition into two subsets of equal sum* (and likewise for the negative terms), then the split does **not** exist at the certified roots. At `N = 6`, `t = 1.3625080873347417…`: `P = 1.660074847…`, so `P/2 = 0.830037423…`, while the best subset of the positive terms sums to `0.660074847…` — an exact subset-sum defect of `0.169962576…`; the negative side is short of `|M|/2` by `0.065392329…`. The cause is structural: `cos(t log 1) = 1` is the first positive term and it exceeds `P/2` whenever `P < 2`, so `1` can never be in a half; at the roots here `P` runs `1.00, 1.28, 1.48, 1.66, 2.02, 2.40, 2.74` for `N = 3, 4, 5, 6, 8, 10, 12`, so the strict split fails at every one of them (the defect shrinks like `1/N` but is positive at each tested root; for `N >= 8` it is no longer the first term that binds).

**PROVED** for the structural obstruction (`cos(t log 1) = 1`, and a single-term positive side for `N = 3`), **VERIFIED** exactly by exhaustive subset-sum over the positive and negative term sets at the certified roots.

`N = 3` makes the failure visible at its simplest: the positive side is the single term `{1}`, which cannot be split at all.

> **This is the one place where the two readings of the question genuinely part company.** The *split* (the positive total versus the negative total) balances for every `N >= 2`; the *term-level partition into two equal halves* does not, at the balance points, because `1` is always the first positive term.

*If one instead relaxes "two-and-two" to "any number of equal pieces", the three-piece identity is exact at a balance point: `P/3 + P/3 + P/3 = P`, `M/3 + M/3 + M/3 = M`, and `P/3 = |M|/3`; but that is a decomposition of the totals, not of the terms.*

## Hypotheses and notation

- Reading **R2′**: "the positive **terms** partition into two subsets of equal sum, and the negative terms likewise" — strictly stronger than `P = |M|` (reading R1).
- At `N = 6`, the certified root `t = 1.3625080873347417…` (compare the 47-digit bracket `[1.36250808733474170983, +8.76e-47]` in §1.3).
- The *exact subset-sum defect* of a side is the shortfall of the best achievable subset sum from `P/2` (resp. `|M|/2`).
- `cos(t log 1) = 1` is the first positive term and the largest one; a nonempty equal split needs `1 <= P/2`, i.e. `P >= 2`.

## Proof / evidence

- **PROVED** for the structural obstruction (`cos(t log 1) = 1`, and a single-term positive side for `N = 3`).
- **VERIFIED** exactly by exhaustive subset-sum over the positive and negative term sets at the certified roots ([`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §5).
- Ledger row T9′: status "**REFUTED** (strict reading) + **VERIFIED**", evidence "§3, script §5".
- HANDOFF.md §2.5 records the same failure: "`cos(t log 1) = 1` is the first positive term and it exceeds `P/2` whenever `P < 2`, which holds at the smallest positive root for every `N` tested … and an exhaustive subset-sum confirms the defect."

## Dependencies and related results

- Contrast [Theorem 11 (the numeric split is exact)](tpp-rh43-truths-numeric-split-exact.md) (T9) — the numeric pieces `P/2, M/2` do pair up perfectly.
- Refuted statement [F7](tpp-rh43-truths-f7-balance-implies-term-split-refuted.md) is the same failure ("a balance point implies the *terms* can be split two-and-two", false).
- Related: [The positive-values-only two-set problem](tpp-rh43-truths-positive-only-two-subset-problem.md) (T14).

## Notes

- The source states whether the term-level split can ever succeed at *some* balance point of some `N` (where `P >= 2` and the defect closes) is **OPEN**; the defect data (`0.5, 0.358, 0.262, 0.170, 0.0108, 0.0202, 0.0286` for `N = 3,4,5,6,8,10,12`) "suggests it does not close for the real-part convention."
- The refutation is at the certified balance points tested; it is not claimed for every `(N, t)`.
