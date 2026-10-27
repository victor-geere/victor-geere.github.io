# J13 (refuted) — C1 boundary = 1 + min(min_j d_j, min_j(d_j + d_{j+1})) (Agent A, round 1)

**Kind:** Claim
**Status:** REFUTED (4 903 violations inside its own claimed range, 449 too early, over 17 375 sampled eligible words; exact on the four dialogue words only)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J13

## Statement

> C1 boundary `= 1 + min(min_j d_j, min_j(d_j + d_{j+1}))` (Agent A, round 1)

## Hypotheses and notation

- C1 is the law `p(L) = L + 1`; its "boundary" is the largest `L` at which it holds.
- `d_j` are the consecutive gaps; the candidate is a formula in the gaps alone.

## Proof / evidence

Register row J13's verdict cell reads: "`REFUTED` (all four)" (the four refuted candidates of register row F4); its witness cell reads: "4 903 violations inside its own claimed range, 449 too early, over 17 375 sampled eligible words; exact on the four dialogue words only".

## Dependencies and related results

- Register rows F1 (Theorem D), F2, F3 (the exact formulation), F4, F5.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) rows A1 and A2 (the rule disproven and its degenerate counterexample retracted), §3.2 (the test);
  the ledger records the same error (rows 11 and 12 of `ledger.md`).

## Notes

- Agent A's own counterexample `{13,244}`, `N = 253` is separately recorded as internally inconsistent (ledger row 12); the refutation of the rule does not depend on it.
