# Six certified union node sets

**Kind:** Claim
**Status:** VERIFIED (numerical, six node sets positive definite by 60-digit Cholesky; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh20.html`](../../html/rh20.html) — §4 "The other side of the same ratio"; the certificates are tabulated in Figure 4

## Statement

> rh18's identity holds at arbitrary real nodes with a single hat width, so a pair supplies more than two separate statements: the union Δ₁ℤ ∪ Δ₂ℤ is itself a legitimate node set, and 𝒲(g⋆ǧ) on hat-splines over that set is a Gram form to be certified. Six of them are, by 60-digit Cholesky, at half-support 11.52 — the certificates are in Figure 4.

The conditioning result stated with it:

> Reduced modulo Δ₁ the union is a single orbit {mθ mod 1}, so its gaps take at most three values — verified in exact rational arithmetic at all six pairs. What separates them is not the count but the balance. The golden pair's three distances are 2.20 + 3.50 + 5.70 (×10⁻³), a ratio of 2.6; a near-rational's are 0.03 + 79.30 + 79.33, a ratio of 2,644. And the certified pivots track the balance exactly: 4.99×10⁻⁶ for the golden pair against 2.76×10⁻⁹ for the near-rational, a factor of 1,810.

The certified table (Figure 4; θ = Δ₂/Δ₁, n the node count):

| θ | n | min gap | 3 distances ×10⁻³ | balance | gain | pivot | 1st joint notch |
|---|---|---|---|---|---|---|---|
| 0.5000 | 97 | 0.12000 | 120.0 | 1.0 | 1× | 6.39×10⁻⁶ | 5.2×10¹ |
| 0.6667 | 97 | 0.08000 | 80.0 | 1.0 | 5× | 7.17×10⁻⁶ | 7.9×10¹ |
| 0.7000 | 111 | 0.02400 | 24.0 | 1.0 | 181× | 4.61×10⁻⁶ | 2.6×10² |
| 0.5813 | 131 | 0.00150 | 1.5 + 3.0 + 4.5 | 3.0 | 7,114× | 1.78×10⁻⁶ | 4.2×10³ |
| 0.6179 | 126 | 0.00220 | 2.2 + 3.5 + 5.7 | 2.6 | 2,857× | 4.99×10⁻⁶ | 6.3×10⁴ |
| 0.6667 | 120 | 0.00003 | 0.0 + 79.3 + 79.3 | 2644.3 | 5× | 2.76×10⁻⁹ | 6.3×10⁵ |

The standard name for the "three values" fact is the three-distance (Steinhaus) theorem; the source cites V. T. Sós (1958) and S. Świerczkowski (1959).

## Hypotheses and notation

- The node set is the union Δ₁ℤ ∪ Δ₂ℤ; a legitimate test set by [T1a — the Weil identity at arbitrary nodes](../rh18/rh18-t1a-weil-identity.md).
- All six forms are certified at half-support 11.52 by 60-digit Cholesky.
- Balance = max/min of the three gaps of the union reduced mod Δ₁; gain is the weight-floor gain over the single mesh; pivot is the minimum Cholesky pivot.
- Exact rational arithmetic is used for the three-distance verification.

## Proof / evidence

The six node sets are asserted positive definite; the document's 38 named checks in 29 s include "all six union sections are asserted positive definite" and "the three-distance count is verified in exact rational arithmetic". The source's conclusion: "The pair that is best on both at once, out of the six certified, is the golden one."

## Dependencies and related results

- [rh18 T1a](../rh18/rh18-t1a-weil-identity.md) makes the union a legitimate node set.
- [The four starved zeros](rh20-four-starved-zeros.md) is the weight-side companion result.
- [The first joint notch](rh20-first-joint-notch.md) supplies the joint-notch column of the table.

## Notes


- Harvested as a stated numerical result of the round; not labelled a theorem.
- Figure 4's caption also states the two headline numbers in words: "what a pair fixes: deletion … the low-zero weight floor rises from 1.29×10⁻¹⁰ to 3.70×10⁻⁷, a factor 2857 — and the union sections stay positive definite."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
