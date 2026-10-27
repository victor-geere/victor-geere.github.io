# Corollary 6 (the hardest shift is nearly the easiest)

**Kind:** Corollary
**Status:** PROVED (paper argument, n-fold application of the contrapositive of L3(i))
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §4 "Four corollaries", Corollary 6

## Statement

> **Corollary 6 (the hardest shift is nearly the easiest).** D(0) ≤ D(n) + n for every n; hence `D* ≤ D(0)` always, and `D(0) < D* + ν` whenever ν < ∞.

## Hypotheses and notation

- D(n) := min{ d : n ∈ E(d) } (:= ∞ if none), the witness degree of shift n; D\* := min{ d : E(d) ≠ ∅ } = min_n D(n) (§1.3).
- E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }; ν := min{ n ≥ 0 : F^{(n)} ∈ LP } (equation (8)).
- L3(i) is the implication "J_{d,n} hyperbolic ⟹ J_{d−1,n+1} hyperbolic" of [Lemma L3](xihorn-gorz-gap-l3-propagation.md).

## Proof / evidence

The source's proof, verbatim: "The same n-fold application of L3(i); the second bound applies it at the n₀ < ν achieving D\* = D(n₀). ∎"

The source's gloss: "So the shift that carries RH itself, n = 0, fails at a degree exceeding the earliest failure anywhere by less than ν. Unconditionally [GOR⁺] Corollary 1.3 gives D\* > 9 × 10²⁴, so under ¬RH with ν < ∞ the n = 0 column's first failure lies in (9 × 10²⁴, D\* + ν) — a window of width ν above a threshold nobody can compute past."

## Dependencies and related results

- [Lemma L3](xihorn-gorz-gap-l3-propagation.md); [Corollary 5 (column reduction)](xihorn-gorz-gap-c5-column-reduction.md) is the finite-degree shadow of the same argument.
- Cited [GOR⁺] Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)) supplies D\* > 9 × 10²⁴.
- Checked in the source's model: "Corollary 6's D(0) ≤ D(n) + n holds at every n < ν" at b = 100, c = 2525, where D(0) = 102, D(1) = 110, D(2) = 119, D(3) = 129, D(4) = 140, D(5) = 153, …, D(24) = 5478.

## Notes

- The reading depends on ¬RH and ν < ∞ being assumed for the window statement; unconditionally only D\* > 9 × 10²⁴ is asserted. The source phrases it exactly that way.
- The title is the source's own; the content is the pair of inequalities, not a claim about ξ's actual degrees.
