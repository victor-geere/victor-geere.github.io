# The ceiling (3) — a proven upper bound on m₀ for every window in the family

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — the optimum sits 2.3–2.7× under it)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §4 "The family, and a ceiling over it", equation (3)

## Statement

> For a *fixed* unit vector c, the quantity cᵀT<sub>h</sub>c is linear in C<sub>h</sub> and hence a quadratic form aᵀM<sub>c</sub>a in the coefficients; its maximum over the family at fixed energy aᵀGa = C<sub>h</sub>(0) is the top generalised eigenvalue of (M<sub>c</sub>, G), computed by a shifted power iteration on the whitened form. Since max<sub>h</sub> min<sub>c</sub> ≤ min<sub>c</sub> max<sub>h</sub>,
>
> (3) m₀(h) ≤ min<sub>c ∈ 𝒞</sub> λ<sub>top</sub>(M<sub>c</sub>, G)·C<sub>h</sub>(0) for every h in the family and any finite set 𝒞.

## Hypotheses and notation

- The family is the eight-parameter δ = 0.03 spline family of equation (1): h = Σ<sub>|k| ≤ 7</sub> a<sub>k</sub>φ<sub>δ</sub>(· − kδ), a<sub>k</sub> = a<sub>−k</sub>.
- c is a unit test vector; T<sub>h</sub> is the section matrix; m₀(h) = λ<sub>min</sub>(T<sub>h</sub>) is the quantity the certificates spend.
- M<sub>c</sub> is the quadratic form matrix of a ↦ cᵀT<sub>h</sub>c; G is the Gram matrix of the energy constraint aᵀGa = C<sub>h</sub>(0); λ<sub>top</sub> is the top generalised eigenvalue of the pencil (M<sub>c</sub>, G).
- 𝒞 is any finite set of test vectors.

## Proof / evidence

> This is the analogue of rh20's c₀, but for the quantity the certificates actually spend rather than for the weight at a zero. It costs nothing extra: every worst-case vector the search meets is a legitimate member of 𝒞, so the ceiling tightens automatically as the search runs.

The source records the failure mode of the numerical side honestly:

> Because the power iteration runs on an indefinite form it is shifted before iterating — otherwise it converges to whichever eigenvalue is largest in modulus, which can be the most negative one, and the first draft of this document reported a *negative* ceiling for exactly that reason.

Figure 3's caption states the result's standing: "The ceiling is a theorem, not a guess. For a fixed test vector c the form cᵀT<sub>h</sub>c is quadratic in the coefficients, so its maximum over the family is a generalised eigenvalue, and max<sub>h</sub> min<sub>c</sub> ≤ min<sub>c</sub> max<sub>h</sub>."

## Dependencies and related results

- Weak duality for a maximin (the source's own dictionary gloss; standard name "weak duality for a maximin").
- rh20's c₀ = 2.1002465 weight ceiling is the analogue for the weight at a zero.
- Used against the search in §5 ("Each optimum stops 2.3–2.7× below the bound (3)").
- Carried to the M = 16 family, where the ceiling sits 1.80–3.17× above the optimum against 2.33–2.69× in rh22's (see [rh23-ceiling-comparison-8-vs-16.md](../rh23/rh23-ceiling-comparison-8-vs-16.md)).

## Notes

- The bound holds only for *the family* and any finite set 𝒞; the source is explicit that "nothing says it is closer, and nothing bounds what a larger family (δ = 0.015, seventeen coefficients) would reach."
- rh23's §3 corrects the coefficient count of the larger family named in this open item (sixteen, not seventeen) and rh24 reports that the shifted power iteration used to compute λ<sub>top</sub> drifts in the *vector* at high dimension (sin(angle) = 6.1×10<sup>-1</sup> at 64 coefficients); the ceiling *values* still hold every published number, and rh24 says so.
