# Refuted — the first-difference identity with a left-special correction

**Kind:** Claim
**Status:** REFUTED (left-special count is 0 throughout; the correct correction is the count of factors with no right extension)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> the first-difference identity with a left-special correction
>
> counterexample: left-special count is 0 throughout; the correct correction is the count of length-`L` factors with no right extension.

## Hypotheses and notation

- The first-difference (Cassaigne) identity expresses `p(L+1) − p(L)` as a sum of factor counts; the refuted variant attaches a correction counting **left-special** factors.
- "Left-special" means a factor with more than one left extension; "no right extension" means a factor that cannot be extended to the right inside the word.
- In this word the left-special count is `0` throughout.

## Proof / evidence

The source's counterexample column states that the left-special count is `0` throughout and that the correct correction is the count of length-`L` factors with no right extension.

Not formalised: the round's Lean README lists "the first-difference (Cassaigne) identity rows of §5" under "Not formalised".

## Dependencies and related results

- [The offset-tuple count equals the bit-string factor count](tpp-rh41-truths-claim-offset-tuple-equals-bit-factor.md) — the factor-count identification this identity would work on.
- [Refuted — `Σ_j |intervals|` counts the factors](tpp-rh41-truths-refuted-interval-count-equals-factors.md) — the other un-formalised §5 row.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose" and gives no numerical witness beyond the zero left-special count.
