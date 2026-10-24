# Refuted — "bounded gaps OR termination, never both"

**Kind:** Claim
**Status:** REFUTED (counterexample: `α_n = 2^{−(n+1)}` has both)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> "bounded gaps OR termination, never both"
>
> counterexample: `α_n = 2^{−(n+1)}` has both.

## Hypotheses and notation

- The refuted dichotomy: for a greedy alphabet, bounded gaps between taken indices and exact termination are mutually exclusive.
- The witness is `α_n = 2^{−(n+1)}` at `x = 1`: it selects **every** index (gaps all `1`, hence bounded) and terminates exactly (residual `= (1/2)^n → 0`).

## Proof / evidence

The counterexample is displayed in the source's §5 table and is the content of [Theorem 11](tpp-rh41-truths-theorem-11-dichotomy-false.md).

Machine-checked as `Alphabet.expAlpha_bounded_gaps_and_termination` in `Rh41/Alphabet.lean`.

## Dependencies and related results

- [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md) — the numbered form of this refutation.
- [Refuted — `α_n = (n+2)^{−3/2}` has bounded gaps](tpp-rh41-truths-refuted-power-alpha-bounded-gaps.md).

## Notes

- The source adds the row under the heading "Refuted — do not re-propose".
- As the round's Lean README records, "terminates exactly" is formalised as `residual = (1/2)^n → 0`, not as finite termination.
