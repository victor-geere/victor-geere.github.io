# The collapse: λ<sub>min</sub>/E<sub>h</sub>(0) is a function of n/N<sub>eff</sub>

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §3 "The collapse", lines 414–491, boxed bin table at lines 896–901 and boxed rh27c table at lines 916–922

## Statement

> Against the depth alone the points scatter over 1.5×10<sup>7</sup>. Against n/N<sub>eff</sub> they lie on a single curve. Over the four bins covering n/N<sub>eff</sub> < 0.3 — half the family, spanning two decades of window, two of mesh and two of depth — the spread *within a bin* is:
>
> n/N<sub>eff</sub> in [0.003, 0.01)   5 points   λ<sub>min</sub>/E<sub>h</sub>(0) from 9.57×10<sup>−1</sup> to 9.99×10<sup>−1</sup>   spread 1.04×
> n/N<sub>eff</sub> in [0.01, 0.03)   10 points   λ<sub>min</sub>/E<sub>h</sub>(0) from 7.02×10<sup>−1</sup> to 9.99×10<sup>−1</sup>   spread 1.42×
> n/N<sub>eff</sub> in [0.03, 0.1)   30 points   λ<sub>min</sub>/E<sub>h</sub>(0) from 6.16×10<sup>−1</sup> to 9.88×10<sup>−1</sup>   spread 1.60×
> n/N<sub>eff</sub> in [0.1, 0.3)   30 points   λ<sub>min</sub>/E<sub>h</sub>(0) from 4.92×10<sup>−1</sup> to 9.78×10<sup>−1</sup>   spread 1.99×
>
> Never worse than 1.99×. ... And it fails past n = N<sub>eff</sub>: beyond n/N<sub>eff</sub> = 1 the spread in a bin reaches 5.8×10<sup>4</sup>. The collapse is a statement about the regime where the section is shorter than the measure is wide, and nothing past it.

Consequence stated for rh27c's five supports (n = 18/Δ′ + 1):

> The three narrow supports are at n/N<sub>eff</sub> = 1.58, 1.45, 1.29, a spread of 1.23×, and their λ<sub>min</sub>/E<sub>h</sub>(0) agree to 10%. They were not three supports independently agreeing on a ceiling. They were three readings of very nearly one point on this curve.

## Hypotheses and notation

- The family is five windows × five meshes × eight depths, 200 certificates, each a λ<sub>min</sub> computed from the zero side (conditional on RH).
- N<sub>eff</sub> is the effective count of §2; n is the section length; E<sub>h</sub>(0) is the diagonal.
- "spread" is the ratio of the largest to the smallest value in the bin.

## Proof / evidence

Numerical. The source notes the collapse is not a repackaging of either single variable: binning the same 200 numbers by depth alone spreads them by up to 1.5×10<sup>7</sup>, and by window alone by up to 3.1×10<sup>7</sup>.

## Dependencies and related results

- [rh30-effective-count-set-by-window](rh30-effective-count-set-by-window.md) — the coordinate n/N<sub>eff</sub>.
- rh27c (whose flat stretch this explains), rh28 (which called it a saturation), [rh29-depth-curve-past-one-decade](../rh29/rh29-depth-curve-past-one-decade.md).
- [rh31-collapse-fails-off-searched-family](../rh31/rh31-collapse-fails-off-searched-family.md) — the later destruction test that refutes the law off the searched family.

## Notes


- The source's own strongest claim about it is a measured one, and it is hedged: the collapse holds "to within a factor of 1.99×" only for n/N<sub>eff</sub> < 0.3, and rh30 §10(a) states that proving even a weak version would be the object a conjunction needs. That proof is an open direction, not harvested.
- The rh27c table in the box gives n = 39, 76, 151, 301, 601 with λ<sub>min</sub>/E<sub>h</sub>(0) = 0.0408, 0.1154, 0.2846, 0.2731, 0.2992 and n/N<sub>eff</sub> = 5.54, 4.39, 1.58, 1.45, 1.29.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
