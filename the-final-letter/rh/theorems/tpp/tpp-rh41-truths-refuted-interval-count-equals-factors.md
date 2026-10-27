# Refuted — Σ_j |intervals| counts the factors

**Kind:** Claim
**Status:** REFUTED (counterexample: the intervals overlap)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `Σ_j |intervals|` counts the factors
>
> counterexample: the intervals overlap.

## Hypotheses and notation

- The candidate claim is that summing the sizes of a family of intervals (indexed by `j`) gives the number of distinct length-`L` factors `p(L)`.
- The refutation is that the intervals **overlap**, so the sum overcounts.

## Proof / evidence

The source's counterexample column states only that the intervals overlap; no numerical witness is given in this row.

Not formalised: the round's Lean README lists this row ("`Σ_j |intervals|`") under "Not formalised".

## Dependencies and related results

- [The offset-tuple count equals the bit-string factor count](tpp-rh41-truths-claim-offset-tuple-equals-bit-factor.md) — the correct counting of distinct factors, via the bijection `toBit`/`bitFactor`.
- [Refuted — the first-difference identity with a left-special correction](tpp-rh41-truths-refuted-first-difference-left-special.md) — the other un-formalised §5 row.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose" and gives no numerical witness beyond the overlap statement.
