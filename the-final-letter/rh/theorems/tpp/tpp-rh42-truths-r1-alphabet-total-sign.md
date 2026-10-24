# R1 (refuted) — the alphabet (−1)^n/(n+2) totals ln 2 − 1

**Kind:** Claim
**Status:** REFUTED (smallest witness below)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R1

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R1 | the alphabet `(−1)^n/(n+2)` totals `ln 2 − 1 = −0.30685…` | it totals `1 − ln 2 = +0.30685…` (Theorem 1) |

## Hypotheses and notation

- The alphabet is the signed/Tau alphabet at `p = 1`: `α_n = (−1)^n/(n+2)`, `n = 0, 1, 2, …`.
- `ln 2 − 1 = −0.30685281944005469058…` is the claimed (false) total; `1 − ln 2 = +0.30685281944005469058…` is the actual total.

## Proof / evidence

The witness is the corrected computation of [Theorem 1 (sign)](tpp-rh42-truths-theorem-1-sign.md): with `m = n+2`, `Σ_{m≥2}(−1)^m/m = −(ln 2 − 1) = 1 − ln 2`; the source also gives exact rational enclosures of width `6.3·10⁻⁴¹`. The source's §1 attribute this to the source pages' sign extraction, not to the pages' magnitude.

## Dependencies and related results

- [Theorem 1 (sign)](tpp-rh42-truths-theorem-1-sign.md) — the corrected statement.
- Handoff ledger rows T17 and R1 (§11) record the same correction ("the alphabet total is `1 − ln 2`, not `ln 2 − 1`"; "write out the reachable-set theory ... DONE" is unrelated but shares the id R1).

## Notes

- The source lists this under "**Refuted — do not re-propose**" with the witness "(Theorem 1)". It is the negated form of Theorem 1's statement, harvested separately because §9 labels it as a refuted result.
- The source notes the magnitude was always right on the pages; only the sign was flipped.
