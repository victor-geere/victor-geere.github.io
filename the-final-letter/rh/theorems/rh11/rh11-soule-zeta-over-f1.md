# Soulé's ζ over 𝔽₁: ζ_{P¹/𝔽₁}(s) = 1/(s(s−1)), ζ_{P²/𝔽₁}(s) = 1/(s(s−1)(s−2))

**Kind:** Theorem
**Status:** PROVED (paper argument; computed as limits)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §5 "Spec ℤ over 𝔽₁: the determinant dream, computed", equation (3)

## Statement

> Then the decisive computation, due in concept to Soulé (2004): a variety X counted over every 𝔽<sub>q</sub> has a zeta function Z(X/𝔽<sub>q</sub>, q<sup>−s</sup>), and its 𝔽₁-zeta is the normalised limit ζ<sub>X/𝔽₁</sub>(s) = lim<sub>q→1</sub>(q−1)<sup>N(1)</sup> Z(X/𝔽<sub>q</sub>, q<sup>−s</sup>). Computed:
>
> ζ<sub>P¹/𝔽₁</sub>(s) = 1/(s(s−1)) ,&nbsp;&nbsp; ζ<sub>P²/𝔽₁</sub>(s) = 1/(s(s−1)(s−2)) .

## Hypotheses and notation

- N(1) is the number of 𝔽₁-points of X used as the normalisation exponent; for P² it is 3, so the limit is lim<sub>q→1</sub>(q−1)³ Z(P²/𝔽<sub>q</sub>, q<sup>−s</sup>).
- The limits are evaluated at q = 1+ε with Richardson extrapolation and checked against the closed forms.

## Proof / evidence

The source computes the limits and reports the agreement: "computed at each s as the limit lim<sub>q→1</sub>(q−1)³ Z(P²/𝔽<sub>q</sub>, q<sup>−s</sup>) with Richardson extrapolation (dots), against 1/s(s−1)(s−2) (line): agreement ≤ 10<sup>−5</sup> everywhere, ≤ 10<sup>−6</sup> at the four spot-checked points." Its reading: the factor s(s−1) — the polynomial prefactor that completes ζ to ξ — "emerges from pure counting over the one-element field".

## Dependencies and related results

- [GL_n(𝔽₁) = S_n](rh11-gl-n-over-f1-equals-symmetric-group.md) — the companion 𝔽₁ count in §4.
- [The Hadamard product for ξ](rh11-hadamard-product-for-xi.md) — the ξ whose prefactor s(s−1) this computation produces.
- rh12 §6 builds the counting function of the would-be curve from the same program.

## Notes

- The computation is "due in concept to Soulé (2004)"; the source presents the closed forms as what the normalised limit computes, with numerical agreement rather than a written proof.
- The source's reading: "That is the strongest sense in which the base question is well-posed."
