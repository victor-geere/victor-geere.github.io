# R3 (refuted) — "a_1 ≤ A − a_1 ⟹ the sub-sums fill [0,A]"

**Kind:** Claim
**Status:** REFUTED (smallest witness; machine-checked)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R3

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R3 | "`a_1 ≤ A − a_1` ⟹ the sub-sums fill `[0,A]`" | `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1 = 1/2` and misses `1/5`; machine-checked (`single_condition_not_sufficient`) |

## Hypotheses and notation

- Refuted single-condition form of Brown's criterion: for a non-increasing positive sequence with total `A`, the condition `a_1 ≤ A − a_1` (first term at most the sum of the rest) would imply the sub-sums fill `[0, A]`.
- Witness sequence `(1/2, 2/5, 1/20, 1/20)`: `a_1 = 1/2`, `A − a_1 = 1/2`, so the condition holds with equality, yet the sub-sum `1/5` is missing.

## Proof / evidence

Machine-checked refutation: Lean declaration `single_condition_not_sufficient` in [`lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) (the §3 note lists `Reachable.lean` as containing "the machine-checked refutation `single_condition_not_sufficient`").

## Dependencies and related results

- [Theorem 6 (Brown's criterion, T10/T13 core)](tpp-rh42-truths-theorem-6-brown-criterion.md) — the correct statement, requiring `a_n ≤ T_{n+1}` for **every** `n`.
- The source's §3 correction names this refutation when it says the single condition is "**not** sufficient" (the §3 text cross-references it as "**Theorem 12 (REFUTED)**", a stale label; see the Notes of Theorem 6).

## Notes

- The source states the correct criterion needs **every** `n` "which is what makes the `p`-series work."
- The witness is a *finite* sequence of four terms; the missing sub-sum is `1/5`.
