# (7) The hyperbolic hat — a generator whose transform never vanishes

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §3 "(a) The notch-free family, searched", equations (1) and (7)

## Statement

> (1) U<sub>c</sub>(x) = sinh(c(δ − |x|))/sinh(cδ) on [−δ, δ], V<sub>c</sub> = U<sub>c</sub> ⋆ U<sub>c</sub>, C<sub>h</sub> = Σ<sub>e</sub> W<sub>e</sub> V<sub>c</sub>(· − eδ).
>
> The cure is not to search harder but to change the generator … Applied to the *generator* rather than the window, with g = e<sup>cs</sup> on a single cell, it gives (1) — and
>
> (7) Û<sub>c</sub>(r) = 2c(cosh cδ − cos rδ) / (sinh cδ · (c² + r²)) ≥ 2c(cosh cδ − 1) / (sinh cδ · (c² + r²)) > 0
>
> at every real r, because the numerator is |e<sup>cδ</sup>e<sup>−irδ</sup> − 1|² and c ≠ 0 keeps the circle off the point 1. At the hat's first notch, δ = Δ/8, Û<sub>c</sub> is 4.35×10<sup>-5</sup> at θ = 0.24 where φ̂<sub>δ</sub> is 4.6×10<sup>-35</sup> — which is not small, but zero. The whole ladder is gone from the basis, and it is gone by an inequality rather than by a search.

## Hypotheses and notation

- U<sub>c</sub> is the hyperbolic hat on one cell [−δ, δ]; V<sub>c</sub> = U<sub>c</sub> ⋆ U<sub>c</sub>; C<sub>h</sub> = Σ<sub>e</sub> W<sub>e</sub> V<sub>c</sub>(· − eδ) with W the fourth-order autocorrelation of the coefficients.
- θ = cδ is the family's dimensionless shape parameter ("U<sub>c</sub> depends on c and δ only through θ and x/δ").
- Û<sub>c</sub> is the transform of U<sub>c</sub>; the numerator |e<sup>cδ</sup>e<sup>−irδ</sup> − 1|² vanishes only where e<sup>−irδ</sup> = e<sup>−cδ</sup>, which for c ≠ 0 is off the unit circle.

## Proof / evidence

The inequality follows from cos rδ ≤ 1, with the numerator written as |e<sup>cδ</sup>e<sup>−irδ</sup> − 1|² and c ≠ 0 keeping the circle off the point 1. The source records the anchor to the previous rounds:

> U<sub>c</sub> is cardinal — U<sub>c</sub>(0) = 1 and U<sub>c</sub>(±δ) = 0 — so a window's coefficients are its nodal values, refinement is resampling, and the families nest exactly as rh24's did … And rh24's two reference windows are both inside it: the triangle hat is c → 0, and h(t) = sinh(Δ−|t|) is the rate-1 member, reproduced here to 10⁻¹⁵ with Û<sub>1</sub>A recovering rh24's 2(coshΔ − cos rΔ)/(1+r²) to 10⁻¹².

## Dependencies and related results

- rh24's obstruction ([the notch ladder belongs to the basis](../rh24/rh24-notch-ladder-basis.md)) is what this generator removes.
- rh24's sinh window ([equation (4)](../rh24/rh24-sinh-window.md)) is the rate-1 member of this family.
- Admissibility through the Weil test function C<sub>h</sub> = h⋆ȟ with Ĉ<sub>h</sub> = |ĥ|² ≥ 0.

## Notes

- This is the only window in the arc whose transform is *provably* non-vanishing on the real line: the source calls the searched constrained member "the first window in the arc that is searched, certified, and uniformly positive at once".
- The figures 4.35×10<sup>-5</sup>, 4.6×10<sup>-35</sup>, θ = 0.24, 10⁻¹⁵, 10⁻¹² are quoted exactly.
