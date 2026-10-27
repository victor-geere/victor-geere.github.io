# [O'S] Lemma 8.2 — the moment-ratio bound

**Kind:** Lemma
**Status:** CITED (literature — O'Sullivan, arXiv:2007.13582v2; derived there from the Lambert-W asymptotic of [O'S] Theorem 1.4)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §3 "Where each exponent is manufactured"

## Statement

> The engine is the moment-ratio bound (Lemma 8.2, from the Lambert-W asymptotic of Theorem 1.4): γ(n+j)/γ(n) < 1.01·(3c²·log²n/16n)^j on 0 ≤ j ≤ n^c − n, c > 4/3 — the ratio γ(n+1)/γ(n) ≍ log²n/16n is the small parameter that the J-route never gets to use raw.

## Hypotheses and notation

- γ is the papers' γ(n) = the directory's a(n) (no rescaling, source §1); the bound controls the moment ratio γ(n+j)/γ(n).
- The range is 0 ≤ j ≤ n^c − n with c > 4/3; the constants are 1.01 and 3c²/16.
- "from the Lambert-W asymptotic of Theorem 1.4" describes the lemma's provenance in [O'S]; Theorem 1.4 itself is not stated in this source.

## Proof / evidence

The source quotes the bound without proof and records its use: "Assembling ((8.5)): the sum is at most 1.03·Σ_{j≥2} d/(j!)²·(9d·log⁴n/32n²)^j, and the j = 2 term decides it:
```
d · (d·log⁴n/n²)²  ≲  1     ⟺     (n/log²n)⁴  ≳  d³     ⟺     n/log²n ≳ d^{3/4}.
```"

The source's constant audit: "the constants (1.01, e < 3, c = 2) are all absorptions."

## Dependencies and related results

- Feeds the (8.2) sum of [O'S] and hence [O'S] Theorem 1.3 ([harvested](xihorn-uniformity-osullivan-theorem-13.md)); the Turán criterion it feeds is [Turán's Theorem III](xihorn-uniformity-turan-theorem-iii.md).
- [O'S] Theorem 1.4 (the Lambert-W asymptotic) is named in the source but not stated there, so it is not harvested.

## Notes

- The source notes a small slippage in the exponent c: "The engine is the moment-ratio bound (Lemma 8.2, from the Lambert-W asymptotic of Theorem 1.4): γ(n+j)/γ(n) < 1.01·(3c²·log²n/16n)^j on 0 ≤ j ≤ n^c − n, c > 4/3", while the constants audit says "c = 2"; both readings are reproduced as printed.
- No proof is reproduced in the source.
