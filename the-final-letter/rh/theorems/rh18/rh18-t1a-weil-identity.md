# T1a — the Weil identity at arbitrary nodes

**Kind:** Theorem
**Status:** PROVED (paper argument, four lines of bookkeeping; VERIFIED numerically, worst relative residual 6.0×10⁻¹⁴)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §2 "The functional, and the identity", equation (2); labelled "T1a" in Figure 4 and in the figure caption

## Statement

> For a hat-spline window on arbitrary real nodes t₁ &lt; … &lt; t<sub>m</sub> — no lattice assumed —
>
> (2)  g = Σ<sub>k</sub> c<sub>k</sub> h<sub>Δ</sub>(· − t<sub>k</sub>)  ⟹  𝒲(g ⋆ ǧ) = Σ<sub>j,k</sub> c<sub>j</sub> c<sub>k</sub> E<sub>Δ</sub>(t<sub>j</sub> − t<sub>k</sub>).

## Hypotheses and notation

- h<sub>Δ</sub> is the triangle hat on [−Δ, Δ] with peak 1; C = h ⋆ ȟ is its autocorrelation (the piecewise-cubic bump of support [−2Δ, 2Δ]); B(r) = ĥ(r) = Δ sinc²(rΔ/2), so Ĉ = B².
- t₁ &lt; … &lt; t<sub>m</sub> are arbitrary real nodes; c<sub>k</sub> real coefficients; g the resulting hat-spline.
- 𝒲 is the Weil functional; E<sub>Δ</sub> the arc's kernel section.

## Proof / evidence

The source gives the proof: "g ⋆ ǧ = Σ c<sub>j</sub>c<sub>k</sub> C(· − (t<sub>j</sub>−t<sub>k</sub>)) by definition of C; the prime term distributes because C is even; the archimedean term because Ĉ = B², pointwise at every frequency — so the identity holds for the exact integral and for any quadrature of it alike; and the pole term because Ĉ(i/2) = B(i/2)² = B<sub>i</sub>², the analytic continuation the arc's pole term was built from." Independent verification: "Four node configurations — lattice, two irregular, one mixed set of twelve — three terms each: worst relative residual 2.2×10⁻¹⁴ (archimedean, an algebraic identity per frequency), 6.0×10⁻¹⁴ (pole, independent quadrature), 9.5×10⁻¹⁵ (primes, exact convolution)." The figure records "T1a identity residual, four node configurations, three terms: ≤ 6×10⁻¹⁴ relative".

## Dependencies and related results

- Equation (1) of the source defines 𝒲; equation (2) is the bridge used by [T — P2, closed](rh18-t-p2-closed.md).
- Feeds [(Bo) — Bochner](rh18-face-bo-bochner.md) (arrow (W) ⟹ (Bo)) and [T2 — the ε(Δ; g) bound](rh18-t2-epsilon-bound.md).
- The identity is rh14's pole-versus-primes merge read at window level.

## Notes

- The source names this result T1a in Figure 4 (and in the Figure 1 caption as "the T1a identity"), while the body states it as equation (2); no T1 is stated in this document (rh17's T1 is a different result).
- The three verification residuals are quoted exactly as the source gives them; the headline figure is the worst, 6.0×10⁻¹⁴ relative.
- No new mathematics is claimed for the identity itself; its role is structural — "The bridge between them is an identity, not an estimate."
