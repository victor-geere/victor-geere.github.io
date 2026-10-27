# Corollary 5 (column reduction)

**Kind:** Corollary
**Status:** PROVED (paper argument, n-fold application of the contrapositive of L3(i))
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §4 "Four corollaries", Corollary 5

## Statement

> **Corollary 5 (column reduction).** If J_{d,0} is hyperbolic for every d ≤ D, then J_{d,n} is hyperbolic for every (d, n) with d + n ≤ D.

## Hypotheses and notation

- D is a non-negative integer bound on the degree; d + n ≤ D ranges over the triangle of (degree, shift) pairs.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); hyperbolic = all zeros real.
- L3(i) is the implication "J_{d,n} hyperbolic ⟹ J_{d−1,n+1} hyperbolic" of [Lemma L3 (propagation)](xihorn-gorz-gap-l3-propagation.md).

## Proof / evidence

The source's proof, verbatim: "Suppose J_{d,n} is not hyperbolic with d + n ≤ D. Apply the contrapositive of L3(i) n times: J_{d+1,n−1}, J_{d+2,n−2}, …, J_{d+n,0} are each non-hyperbolic. But d + n ≤ D. ∎"

The source's gloss: "The whole two-parameter family is decided by its **n = 0 column**: D checks certify a triangle of ≈ D²/2 pairs. This is the cheap direction of GORZ verification, and it needs no zero data at all."

## Dependencies and related results

- [Lemma L3](xihorn-gorz-gap-l3-propagation.md) (contrapositive of L3(i)); [L1](xihorn-gorz-gap-l1-derivative-ladder.md).
- Applied in [Corollary 6](xihorn-gorz-gap-c6-hardest-shift-nearly-easiest.md) and read at D = ∞ in [Corollary 7](xihorn-gorz-gap-c7-column-decides-nu-zero.md).
- Confirmed in the source's §7.4 instance: at b = 100, c = 2525 (ν = 25), D\* = D(0) = 102, J_{d,0} is hyperbolic for every d ≤ 101, and "Corollary 5 certifies the whole triangle d + n ≤ 101 — ≈ 5 000 pairs from 101 one-dimensional checks. Confirmed: no exception inside that triangle, by the closed form for n < 40 and by brute force for d ≤ 11, n ≤ 7."

## Notes

- The source's §10 warning: "**5. Corollary 5 does not beat Corollary 1.3.** [GOR⁺] cover the infinite strip d ≤ 9 × 10²⁴ at every shift; Corollary 5 covers a triangle. Its content is the reduction of dimension — one column decides the family — not extra coverage."
- The source records that [Corollary 1.3](xihorn-gorz-gap-gorplus-corollary-13.md) is the n = 0 column "verified through d ≤ 9 × 10²⁴".
