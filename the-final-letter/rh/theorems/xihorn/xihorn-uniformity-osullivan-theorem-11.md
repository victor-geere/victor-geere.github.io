# [O'S] Theorem 1.1 — the Jensen criterion for RH

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, *Zeros of Jensen polynomials and asymptotics for the Riemann xi function*, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §1 "The problem, stated exactly", quoted theorem box

## Statement

> **[O'S] Theorem 1.1.** *The Riemann hypothesis is true if and only if J_{d,n}(X) is hyperbolic for all d ≥ 1, n ≥ 0.*

## Hypotheses and notation

- In the papers' notation, "[t]he Jensen polynomial of degree d and shift n is
  ```
  J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j        ([O'S] (1.3) = POSITIVITY (13))
  ```"
- Notation reconciliation of the source: "Both papers write γ(n) for what [POSITIVITY.md](../../xi-horn/POSITIVITY.md) (12) calls a(n) = γ(n)·n!/(2n)! — their γ(m) := m!/(2m)!·ξ^(2m)(½), no rescaling." (GORZ19 used a normalisation 8× larger.)
- Hyperbolic = all zeros real; the two axes of the "for all" are d ≥ 1 and n ≥ 0.
- The companion source's reading: "[O'S] Corollary 3.2: ξ^(n) is hyperbolic ⟺ J_{d,n} is hyperbolic for every d ≥ 1."

## Proof / evidence

The source quotes the theorem without proof; it is the criterion on which the whole file's map turns. The source's asymmetry reading: "The two axes of that 'for all' are not the same kind of hard… **Fixed n, all d.** … The all-d limit at fixed n **is** the theorem being sought, one derivative at a time. **Fixed d, all n.** Tractable, and the only direction in which anything has ever moved".

## Dependencies and related results

- [O'S] Corollary 3.2 ([harvested](xihorn-uniformity-osullivan-corollary-32.md)) localizes the all-d direction at a single shift.
- The Hermite-basis analogue is [O'S] Theorem 1.2 ([harvested](xihorn-uniformity-osullivan-theorem-12.md)).
- In the companion source: [xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md](xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md), where the same criterion is quoted in the F^{(n)} form.

## Notes

- Quoted in the source from [zeros-jensens-polynomials.pdf](../../xi-horn/zeros-jensens-polynomials.pdf); the source records that "Quotes were extracted from these PDFs directly; §7 records how".
- The source's framing paragraph: "none of this is a route to the Riemann Hypothesis. Farmer says so at title length (arXiv:2008.07206, cited by [GOR⁺] as their [10])".
