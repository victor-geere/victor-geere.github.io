# [O'S] Corollary 3.8 — J-hyperbolicity implies P-hyperbolicity, never the converse

**Kind:** Corollary
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §2 "The two theorems, verbatim"

## Statement

> And the per-instance comparison is one-way ([O'S] Corollary 3.8: J_{d,n} hyperbolic ⟹ P_{d,n} hyperbolic — the paper states this implication only).

## Hypotheses and notation

- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j and P_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) ([O'S] (1.3), (1.4)).
- Hyperbolic = all zeros real; the implication is per instance (d, n). The source reads it as strict — but "never the converse" is the **source's** gloss, not the paper's: Corollary 3.8 states the implication and says nothing about the converse.
- γ is the papers' γ(n) = the directory's a(n) (no rescaling, source §1).

## Proof / evidence

The source quotes it without proof and illustrates the strictness at d = 2: "at d = 2 the J-instance is the Turán inequality γ(n+1)² ≥ γ(n)γ(n+2) ([O'S] (1.5), CNV 1986), while the P-instance is γ(n+1)² **+ 2γ(n)²** ≥ γ(n)γ(n+2) ([O'S] (1.6)) — the same inequality with a free positive term added. Weaker one instance at a time; identical in conjunction. That trade — weaken every instance, keep the conjunction equivalent to RH — is the entire mechanism of the improvement".

## Dependencies and related results

- [O'S] Theorem 1.2 ([harvested](xihorn-uniformity-osullivan-theorem-12.md)) and [O'S] Theorem 1.3 ([harvested](xihorn-uniformity-osullivan-theorem-13.md)) are the P-family statements; the J-family criterion is [O'S] Theorem 1.1 ([harvested](xihorn-uniformity-osullivan-theorem-11.md)).
- The source's §5 cites it as an example of instance re-pricing under the Ω dial: "Instances re-price (Corollary 3.8's strict implication; H2's twelve decades of measured slack); the conjunction is a gauge invariant, and the conjunction is the hard direction."

## Notes

- The source does not print the corollary's own wording; the statement above is the source's rendering. It is harvested because the source sets it out as a labelled rung of the mechanism, with content.
- No proof is reproduced in the source.

- **Primary-source correction (2025-10-06, session 003 citation audit).** This document added a strictness claim to the paper's Corollary 3.8 — "never the converse", with the converse said to fail. The paper's Corollary 3.8 is the one-way implication "If `J^{d,n}(x)` is hyperbolic then `P^{d,n}(x)` is hyperbolic" and nothing more: neither "never" nor "strict" appears in it, and it does not assert that the converse fails. The implication and its numbering (3.8) are faithful. The added clause is removed below.
