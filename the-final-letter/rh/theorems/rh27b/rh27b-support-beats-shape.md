# (a) The search at three supports — the support is the coarse knob

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27b.html`](../../html/rh27b.html) — §2 "(a) The search at three supports"

## Statement

> Twelve of them: θ ∈ {0, 0.06, 0.24, 0.96} at each of Δ′ ∈ {0.12, 0.24, 0.48}. Every one is checked notch-free after the fact, by minimising the trigonometric factor over a whole period rather than at the search's own sample points; the worst margin is 5.99×10⁻⁷, at Δ′ = 0.48 with the triangle generator, and it is positive. At Δ = 0.24 the best of the four agrees with rh25's own optimum to within 7% — 6.6% above it, the two being stochastic restarts of the same procedure over the same θ ladder — which is the regression that licenses reading the other two supports as comparable.
>
> The curves are flat and the gaps between them are not. Taken scale-free — divided by C<sub>h</sub>(0), for the reason §3 gives — the four shapes at a fixed support move λ<sub>min</sub> by at most 1.24×, while the three supports at a fixed shape move it 10.7×, a lever 8.7× longer. […] on this scale the shape is a fine adjustment and the support is the coarse one.
>
> The optimal shape is not the same at every support. At Δ′ = 0.12 it is θ = 0.06; at 0.24 it is θ = 0.96, and at 0.48 the same, θ = 0.96.

## Hypotheses and notation

- Three window half-supports Δ′ ∈ {0.12, 0.24, 0.48}, four shape parameters θ = cδ ∈ {0, 0.06, 0.24, 0.96}; M = 16 at every one, so the window carries the same thirty-one coefficients throughout.
- The generator mesh is δ = Δ′/16; the lattice step is Δ′ itself; the depth is 18 throughout.
- Notch-free means the trigonometric factor is positive over a whole period; the margin is minimised over a whole period, not at the search's own sample points.
- Scale-free means divided by the kernel's own diagonal C<sub>h</sub>(0).

## Proof / evidence

Numerical search: rh25's β-space bundle search at depth 18 at each of the twelve (support, shape) points, with the true λ<sub>min</sub> evaluated at accepted points. Notch-freeness is re-verified after the fact over a whole period at all twelve optima, worst margin 5.99×10⁻⁷. The regression at Δ = 0.24 reproduces rh25's own optimum to 6.6%.

## Dependencies and related results

- rh25's hyperbolic generator and β search; rh26's gear-mass histogram; rh27a's certified ψ̃ table to r = 4800.
- The scale-free comparison is completed in [rh27b-scale-free-verdict-reverses](rh27b-scale-free-verdict-reverses.md).

## Notes


- The source's own qualification: the twelve searches are a finite set, "three supports is no more dense in (0, ∞) than one was" (see [rh27b-support-scaling-exponent](rh27b-support-scaling-exponent.md)).
- The optimum moving with the support is stated as "the first sign that the family is not simply being rescaled".

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
