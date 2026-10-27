# L2 — the aliasing bound (rh17 §1)

**Kind:** Lemma
**Status:** CITED (literature, rh17 §1)
**Area:** rh-html
**Source:** [`rh27a.html`](../../html/rh27a.html) — §2 "L2 is about the rule, not the range", eq. (2)

## Statement

> L2: the infinite-trapezoid aliasing error at step h = 0.05 carries the factor 2/(e<sup>16π</sup> − 1) = 2.96×10⁻²², a statement about the rule on the whole half-line and not about any particular truncation.

The source's derivation of the constant:

> rh17's second lemma bounds the aliasing error of the infinite trapezoid at step h. The integrand extends analytically in r as far as the nearest pole of ψ(¼ + ir/2), at |Im r| = ½; rh17 works inside that at a = 0.4, where the modulus it needs grows only like e<sup>0.4v</sup>, and the Poisson aliasing then carries the factor 2/(e<sup>2πa/h</sup> − 1) =
>
> 2/(e<sup>16π</sup> − 1) = 2.96×10⁻²²   at h = 0.05.
>
> That statement is about Σ<sub>j∈ℤ</sub> against ∫<sub>ℝ</sub>. It says nothing about J, and changing J does not touch it.

## Hypotheses and notation

- h = 0.05 is the trapezoid step; H = 0.05 in rh27a's (1).
- a = 0.4 is the half-width of the strip inside the nearest pole of ψ(¼ + ir/2) at |Im r| = ½.
- J is the last trapezoid index retained; the lemma is independent of J.
- "the rule" is the trapezoid rule on the whole half-line; "the range" is the truncation at J.

## Proof / evidence

The source attributes the lemma and its constants to rh17 §1 and cites it rather than reproving it; it reports that the constant was "recomputed rather than cited" in the check suite of a later document (rh27c's bill), and that in rh27a the factor "sits 15 orders below the smallest of them at every cut tried".

## Dependencies and related results

- rh17 §1 lemma L2 — the cited original.
- [rh27a-l1-one-sided-cut](rh27a-l1-one-sided-cut.md) — the companion lemma.
- [rh27a-bigger-cut-same-theorem](rh27a-bigger-cut-same-theorem.md) — the corollary drawn from L1 and L2 together.

## Notes

- The source states L2 in the abstract and elaborates in §2; the numerical value 2.96×10⁻²² at h = 0.05 is quoted exactly.
- Status is CITED (literature) because rh27a cites rh17 rather than proving L2 here.
