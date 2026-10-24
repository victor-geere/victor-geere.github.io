# Corollary 4 (the wedge is flat)

**Kind:** Corollary
**Status:** PROVED (paper argument, immediate from Theorem 2)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §4 "Four corollaries", Corollary 4

## Statement

> **Corollary 4 (the wedge is flat).** For every d ≥ 1 and every n ≥ ν, J_{d,n} is hyperbolic. The boundary of the hyperbolic region in the (d, n) quarter plane is the horizontal line n = ν.

## Hypotheses and notation

- ν := min{ n ≥ 0 : F^{(n)} ∈ LP } (equation (8)); E_∞ = [0, ν) ([Theorem 2](xihorn-gorz-gap-t2-initial-segment.md)).
- J_{d,n} is hyperbolic means all its zeros are real; the (d, n) quarter plane is the parameter plane of degree d and shift n.
- The two published onset thresholds named for comparison: [GOR⁺]'s n ≥ ce^d and [O'S]'s n/log²n ≥ d^{3/4}/2 for the Hermite family.

## Proof / evidence

The source gives no separate proof; it says "Immediate from Theorem 2, but worth stating in these terms". The source's gloss: "the two published onset thresholds — [GOR⁺]'s n ≥ ce^d and [O'S]'s n/log²n ≥ d^{3/4}/2 for the Hermite family — are curves rising in d above a truth that does not rise at all. Any measured onset table will therefore fit a constant, not an exponent, once d is large enough; the exponents being fitted belong to the certificates."

## Dependencies and related results

- [Theorem 2 (initial segment)](xihorn-gorz-gap-t2-initial-segment.md).
- The source's §11 dictionary entry "the flat wedge": "every J_{d,n} with n ≥ ν is hyperbolic, for every d; the true onset boundary is the horizontal line n = ν, so [GOR⁺]'s e^d and [O'S]'s d^{3/4}log²n are certificate artifacts above a flat truth".

## Notes

- This is one of the source's own results ("What is new here is the *consequence for the exception sets* — Theorems 1–3 and Corollaries 4–6").
- The claim is conditional on nothing beyond the definitions of ν and E(d); the *value* of ν is not known (ν < ∞ and ν = 0 are both open).
