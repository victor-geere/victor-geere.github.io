# Refuted — α_n = (n+2)^{−3/2} has bounded gaps

**Kind:** Claim
**Status:** REFUTED (counterexample: max gap 76 762)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `α_n = (n+2)^{−3/2}` has bounded gaps
>
> counterexample: max gap 76 762.

## Hypotheses and notation

- `α_n = (n+2)^{−3/2}` is the alphabet at `p = 3/2`; "gaps" are the gaps between consecutive taken indices in the greedy process at target `x = 1`.
- The refuted claim is that those gaps are bounded. The source's counterexample is the observed maximum gap `76 762`.

## Proof / evidence

The source's counterexample is the observed maximum gap `76 762`; the same orbit data is quoted in [Theorem 10](tpp-rh41-truths-theorem-10-alphabet-structure.md) ("taken `= {0,…,8, 34, 954, 77716, …}` with max gap 76 762").

Machine-checked in `Rh41/Alphabet.lean`: `Alphabet.powerAlpha_never_halts`, `Alphabet.powerAlpha_infinitely_many_taken` (where `powerAlpha` is `(n+2)^{-p}` for natural `p ≥ 1`). The specific value `76 762` is listed by the round's Lean README under "Not formalised".

## Dependencies and related results

- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — the third row asserting **unbounded** gaps in this regime.
- [Refuted — "bounded gaps OR termination, never both"](tpp-rh41-truths-refuted-bounded-gaps-or-termination.md) — the related §5 row.

## Notes

- The maximum gap `76 762` is quoted exactly as printed.
- The source adds the row under the heading "Refuted — do not re-propose".
