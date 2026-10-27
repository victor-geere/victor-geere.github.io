# (ii) The row cannot leave its diagonal

**Kind:** Theorem
**Status:** PROVED (paper argument, under RH; worst case measured 0.442 of the diagonal)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §3 "The measure, and three things that follow", item (ii), lines 1459–1469

## Statement

> (ii) The row cannot leave its diagonal, and this is a theorem.
> |E<sub>h</sub>(v)| = |∫e<sup>−ivr</sup>dμ| ≤ μ(&#120general;) = E<sub>h</sub>(0), for every v, at every support, at every mesh.

The source adds: "Measured, the worst case over the five supports is 0.442 of the diagonal, at Δ′ = 0.48; at 0.12 it is 0.155."

## Hypotheses and notation

- μ is the atomic measure of item (i), of total mass μ(&#120general;) = E<sub>h</sub>(0).
- v is the depth (the row index times the mesh); Δ′ is the mesh; the five supports are the arc's five searched windows.
- E<sub>h</sub>(v) = ∫e<sup>−ivr</sup>dμ is the row entry.
- Under RH, and only under RH, μ is a fixed finite positive measure.

## Proof / evidence

The proof is one line and is given in the source: E<sub>h</sub>(v) is a Fourier coefficient of the fixed finite positive measure μ, hence bounded in modulus by the total mass. The source contrasts this with the pole term, which "alone climbs by cosh 9 = 4,052 across the same range while the row does not grow at all"; under RH "there is nothing to cancel". Measured worst cases over the five supports: 0.442 of the diagonal at Δ′ = 0.48, 0.155 at Δ′ = 0.12.

## Dependencies and related results

- [rh29-symbol-is-an-atomic-measure](rh29-symbol-is-an-atomic-measure.md) — the measure whose Fourier coefficient the row is.
- [rh29-offline-quadruple-exclusion-test](rh29-offline-quadruple-exclusion-test.md) — §7 turns this bound into a test against off-line zeros.
- rh28, which measured the same boundedness at 151 nodes and called it "the cancellation".

## Notes

- The source states plainly that this is not a certificate: the whole zero side, and hence this bound, assumes RH.
- The source writes the total mass as the malformed entity `&#120general;`, reproduced verbatim.
- The five-line SVG caption in the source repeats the claim ("under RH it is a Fourier coefficient of a positive measure of total mass E<sub>h</sub>(0), so it can never leave the band").
