# [O'S] Theorem 1.3 — the exponential made polynomial

**Kind:** Theorem
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §2 "The two theorems, verbatim", subsection "[O'S] Theorem 1.3 — the exponential made polynomial"

## Statement

> **[O'S] Theorem 1.3.** *For all d sufficiently large, P_{d,n}(X) is hyperbolic whenever n/log²n ≥ d^{3/4}/2.*

## Hypotheses and notation

- P_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) ([O'S] (1.4)); γ is the papers' γ(n) = the directory's a(n) (no rescaling, source §1).
- "d sufficiently large" is part of the statement; the threshold is n/log²n ≥ d^{3/4}/2.
- Hyperbolic = all zeros real.
- The source's summary of the comparison with the J family: "Same equivalence, threshold e^{0.9634·d} → d^{3/4}·log²n."

## Proof / evidence

The source quotes the theorem and traces the manufacture of its exponent ("Where each exponent is manufactured", §3). The /2 constant is accounted for: "The /2 in the theorem is (27/1024)^{1/4} = 0.403 rounded generously" — from (8.5)'s closing condition (9d·log⁴n/32n²)² ≤ 3/d, i.e. n/log²n ≥ (27/1024)^{1/4}·d^{3/4} = 0.403·d^{3/4} ≈ d^{3/4}/2.48.

The source's trace of the 3/4: "**So 3/4 is literally 3 over 4**: three powers of d in the dominant term — two from C(d,2), *one from the factor d that Turán's criterion itself inserts* — against four powers of n/log²n from the squared, squared ratio. Every constant in that chain is slack except C(d,2), which is the polynomial's actual coefficient."

## Dependencies and related results

- [O'S] Theorem 1.2 ([harvested](xihorn-uniformity-osullivan-theorem-12.md)) supplies the equivalence; Turán's Theorem III ([O'S] Theorem 8.1, [harvested](xihorn-uniformity-turan-theorem-iii.md)) and the moment-ratio bound [O'S] Lemma 8.2 ([harvested](xihorn-uniformity-osullivan-lemma-82.md)) do the certification.
- The comparison bound is [GOR⁺] Theorem 1.1 ([harvested](xihorn-uniformity-gorplus-theorem-11.md)), n ≥ ce^d.
- The dial statement behind the improvement is [O'S] Theorem 3.5 ([harvested](xihorn-uniformity-osullivan-theorem-35.md)); the Ω-invariance of the all-d conjunction is [harvested](xihorn-uniformity-omega-dial-invariance.md).

## Notes

- The source's `[ ]` item "Measure the true onset, then fit its exponent" says: "Theorem 1.3's d^{3/4} is an *upper bound manufactured by (8.2)*… Nobody — either paper included — knows where P_{d,n} hyperbolicity *actually* switches on at small d, and it is a finite computation with an O(1), scale-free margin."
- The source's `[ ]` item "Sharpen the certificate below Turán III" calls n/log²n ≳ d^{1/2} "the reachable prize", explicitly labelled "a derivation, not a computation… a route someone should walk, not a result". It is not harvested as a theorem.
