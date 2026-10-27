# [O'S] Theorem 1.2 — the Hermite-family criterion for RH

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §2 "The two theorems, verbatim", subsection "[O'S] Theorem 1.3 — the exponential made polynomial"

## Statement

> **[O'S] Theorem 1.2.** *The Riemann hypothesis is true if and only if P_{d,n}(X) is hyperbolic for all d ≥ 1, n ≥ 0.*

## Hypotheses and notation

- The family it is about ([O'S] (1.4)), "Hermite from the start":
  ```
  P_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X)
  ```
  where H_k is the Hermite polynomial.
- γ here is the papers' γ(n) = m!/(2m)!·ξ^(2m)(½) = the directory's a(n); no rescaling (source §1).
- Hyperbolic = all zeros real; the quantifier is over all d ≥ 1, n ≥ 0.
- The source notes the per-instance comparison with the J family: "[O'S] Corollary 3.8: J_{d,n} hyperbolic ⟹ P_{d,n} hyperbolic, never the converse".

## Proof / evidence

The source quotes it without proof. Its role in the file: "Same equivalence, threshold e^{0.9634·d} → d^{3/4}·log²n." The source's explanation: "at d = 2 the J-instance is the Turán inequality γ(n+1)² ≥ γ(n)γ(n+2) ([O'S] (1.5), CNV 1986), while the P-instance is γ(n+1)² **+ 2γ(n)²** ≥ γ(n)γ(n+2) ([O'S] (1.6)) — the same inequality with a free positive term added. Weaker one instance at a time; identical in conjunction. That trade — weaken every instance, keep the conjunction equivalent to RH — is the entire mechanism of the improvement".

## Dependencies and related results

- [O'S] Theorem 1.1 ([harvested](xihorn-uniformity-osullivan-theorem-11.md)) is the J-family criterion; [O'S] Theorem 1.3 ([harvested](xihorn-uniformity-osullivan-theorem-13.md)) is the effective threshold for this family.
- [O'S] Corollary 3.8 ([harvested](xihorn-uniformity-osullivan-corollary-38.md)) is the strict implication J ⟹ P.
- The P family is one setting of the Ω dial: it is returned by Ω = e^{−z²} ([O'S] Theorem 3.5, [harvested](xihorn-uniformity-osullivan-theorem-35.md)).

## Notes

- The family's d = 2 instance is a weaker inequality than the J-instance; the source stresses this is a per-instance weakening that leaves the all-d conjunction unchanged.
