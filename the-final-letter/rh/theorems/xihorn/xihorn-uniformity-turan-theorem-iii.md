# Turán's Theorem III ([O'S] Theorem 8.1)

**Kind:** Theorem
**Status:** CITED (literature — Turán; quoted as [O'S] Theorem 8.1, O'Sullivan, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §3 "Where each exponent is manufactured"

## Statement

> Both proofs certify hyperbolicity with the same tool, Turán's Theorem III ([O'S] Theorem 8.1): a Hermite combination G = Σ c_j·H_j has real simple zeros when
>
> ```
> Σ_{j=0}^{d−2} 2^j·j!·c_j²   <   2^d·(d−1)!·c_d².                        (8.1)
> ```

## Hypotheses and notation

- G = Σ c_j·H_j is a Hermite combination; H_j is the Hermite polynomial; c_j are its coefficients.
- The criterion (8.1) is sufficient for G to have real **simple** zeros.
- The source's role for it: "Both proofs certify hyperbolicity with the same tool".

## Proof / evidence

The source quotes the criterion without proof and traces how each exponent uses it:

- **The e^d, in [GOR⁺]:** "J_{d,n} is not a Hermite combination; it has to be renormalised into one. … Feeding those bounds into the Turán condition (their (2.9)) costs (2+16C²)^{d/3}: **the exponential is the price of the renormalisation error**".
- **The d^{3/4}, in [O'S]:** "P is a Hermite combination already, so (8.1) applies with c_j = C(d,j)·γ(n+d−j) directly and becomes ([O'S] (8.2), the identity (d−j)!·C(d,j)²/(2^j(d−1)!) = d·C(d,j)/(2^j·j!) doing the bookkeeping):
  ```
  Σ_{j=2}^{d}  d/(2^j·j!) · C(d,j) · γ(n+j)²/γ(n)²   <   1.               (8.2)
  ```"
- The source's accounting of the extra factor: "**(8.1) ⟹ (8.2):** with c_j = C(d,j)·γ(n+d−j), the weight is (d−j)!·C(d,j)²/(2^j·(d−1)!) = d·C(d,j)/(2^j·j!). One line of algebra; it is where Turán's extra factor of d enters."

## Dependencies and related results

- Consumed by [GOR⁺] Theorem 1.1 ([harvested](xihorn-uniformity-gorplus-theorem-11.md)) and [O'S] Theorem 1.3 ([harvested](xihorn-uniformity-osullivan-theorem-13.md)).
- The moment-ratio bound feeding (8.2) is [O'S] Lemma 8.2 ([harvested](xihorn-uniformity-osullivan-lemma-82.md)).
- The source's `[ ]` item "Sharpen the certificate below Turán III" says the factor d that (8.1) inserts "is the price of comparing every coefficient against the leading one alone", and that removing it would give n/log²n ≳ d^{1/2} — explicitly "a derivation, not a computation", not harvested as a result.

## Notes

- The criterion is quoted as a single display, (8.1); the source does not reproduce Turán's proof.
