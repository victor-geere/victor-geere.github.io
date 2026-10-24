# The cut is one-sided (rh17 lemma L1)

**Kind:** Lemma
**Status:** CITED (literature, rh17 §1 lemma L1); recomputed here
**Area:** rh-html
**Source:** [`rh26.html`](../../html/rh26.html) — §3 "The cut is one-sided", eqs. (4)–(5)

## Statement

> What is in the way is in rh17, stated once and never used since. rh17 §1, lemma L1: "ψ̃(r) = Re ψ(¼ + ir/2) − ln π > 1.10 for r ≥ 20, so the dropped tail beyond R₀ is a POSITIVE combination of cosine kernels — positive semidefinite — and never needs a bound at all." Recomputed here, ψ̃(r) crosses zero at
>
> `r₊ = 6.289836   (2π = 6.283185),   ψ̃(20) = 1.1578,   ψ̃(600) = 4.5591,`
>
> and is increasing on all of [r₊, 4800]. So for any cut R ≥ r₊ the discarded piece is
>
> D<sub>R</sub>(v) = (1/π)∫<sub>R</sub><sup>∞</sup> |ĥ(r)|² ψ̃(r) cos(rv) dr,   so
> Σ<sub>p,q</sub>u<sub>p</sub>u<sub>q</sub>D<sub>R</sub>((p−q)h) = (1/π)∫<sub>R</sub><sup>∞</sup> |ĥ(r)|² ψ̃(r) |Σ<sub>p</sub>u<sub>p</sub>e<sup>irph</sup>|² dr  ≥  0
>
> for every u and every lattice. The computed kernel is the exact kernel minus a positive semidefinite form. It follows that a cut section which is positive definite certifies the exact section with no tail budget at all — and that a cut section which is indefinite certifies nothing whatever. Every negative eigenvalue in (3) is, a priori, a candidate artefact.

## Hypotheses and notation

- ψ̃(r) = Re ψ(¼ + ir/2) − ln π, with ψ the digamma function.
- r₊ = 6.289836 is the numerically located zero of ψ̃; 2π = 6.283185.
- R is the cut of the archimedean integral; R₀ = 600 is the cut actually used throughout rh26.
- D<sub>R</sub> is the discarded tail of the archimedean integral past R.
- h is the window; |ĥ|² is the squared transform; the lattice step is h in the quadratic form, u an arbitrary vector.

## Proof / evidence

The source quotes the lemma from rh17 §1 and says it was "stated once and never used since"; it then recomputes the crossing rather than citing it, obtaining r₊ = 6.289836, ψ̃(20) = 1.1578 and ψ̃(600) = 4.5591, and verifying that ψ̃ is increasing on all of [r₊, 4800]. The one-sidedness itself is the elementary observation that each dropped term is a nonnegative multiple of a cosine kernel cos(r(u − w)), and a nonnegative combination of positive semidefinite kernels is positive semidefinite.

## Dependencies and related results

- rh17 §1 lemma L1 — the cited original.
- The Euler–Maclaurin/trapezoid companion L2 is stated in rh27a (see [rh27a-l2-aliasing-bound](../rh27a/rh27a-l2-aliasing-bound.md)); rh27a states L1 as well ([rh27a-l1-one-sided-cut](../rh27a/rh27a-l1-one-sided-cut.md)).
- Applied in rh26 §3 to explain why the cut at 600 manufactured false negatives, and again in rh27a to certify a longer sum.

## Notes

- rh26 also states the count: "Every negative eigenvalue in (3) is, a priori, a candidate artefact."
- Status is CITED (literature) for the lemma because rh26 quotes rh17 rather than proving it; the recomputation of r₊ and of ψ̃ at 20 and 600 is rh26's own and is reproduced here in the words of the source.
