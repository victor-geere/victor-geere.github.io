# R4 (refuted) — "the greedy is optimal for a decreasing sequence"

**Kind:** Claim
**Status:** REFUTED (smallest witness; verified exactly)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R4; and §4 "Correction (REFUTED)"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R4 | "the greedy is optimal for a decreasing sequence" | `(1/2, 3/10, 3/10)`, `x = 3/5`: greedy `1/2`, optimum `3/5` |

The source's §4 correction states the same refutation with more detail:

> **Correction (REFUTED).** Greedy optimality is *not* a general fact: on the
> decreasing sequence `(1/2, 3/10, 3/10)` at `x = 3/5` the greedy takes `1/2`,
> while `3/10 + 3/10 = 3/5` is the maximum sub-sum `≤ x`. It is Theorem 7 that
> rescues the `p`-series. **VERIFIED** exactly,
> [`reachable.py`](../../research/twin-prime-parity/rounds/rh42/reachable.py) §1.

## Hypotheses and notation

- Refuted general claim: for *any* non-increasing sequence, the greedy sub-sum algorithm attains the maximum sub-sum `≤ x`.
- Witness: sequence `(1/2, 3/10, 3/10)`, target `x = 3/5`. The greedy takes `1/2` (cannot then take `3/10`), giving residual `1/10`; the optimum is `3/10 + 3/10 = 3/5`.

## Proof / evidence

Verified exactly in `reachable.py` §1 (source's citation). The §4 correction is stated as **VERIFIED** exactly; the §9 row records the same witness.

## Dependencies and related results

- [Theorem 11 (greedy optimality, new)](tpp-rh42-truths-theorem-11-greedy-optimality.md) — the positive result, valid for these sequences only.
- [Theorem 7 (unimodality)](tpp-rh42-truths-theorem-7-unimodality.md) — "It is Theorem 7 that rescues the `p`-series."

## Notes

- This file merges the §9 table row R4 and the §4 "**Correction (REFUTED)**" paragraph: they state the same refutation, the §4 version adding the proof-witness explanation and the exact verification. Both source locations are named in the Source line.
- The refutation is about general decreasing sequences; it does **not** contradict Theorem 11, which is specific to the budget/alphabet sequences.
