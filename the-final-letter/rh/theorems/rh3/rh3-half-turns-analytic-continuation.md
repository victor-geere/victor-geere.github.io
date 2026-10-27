# What the half-turns are for

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh3.html`](../../html/rh3.html) — §9 "Why η and not ζ", theorem box at lines 634–637

## Statement

> The alternation is the analytic-continuation device. The plain zeta train exists only for σ &gt; 1; the alternating one exists on all of σ &gt; 0, which is where the critical strip is. Geometrically: **the reason the strip can be seen at all is that the frame turns by π per level.** This is the one axiom of the construction whose analytic content is both load-bearing and completely understood.

## Hypotheses and notation

- "The plain zeta train" is the un-alternated Dirichlet train, convergent only for σ = Re s &gt; 1; "the alternating one" is the half-turned train, i.e. η(s) = Σ (−1)<sup><i>n</i>−1</sup> <i>n</i><sup>−<i>s</i></sup>, with the phase-opposite rule <i>a</i> + <i>A</i> = 0 carrying the sign.
- The half-turns are the cumulative alternation: a rotation by π per level (α<sub><i>n</i></sub> = (<i>n</i>−1)π in the construction).
- The critical strip is 0 &lt; σ &lt; 1. The "axiom" named at the end is the phase-opposite axiom of the nested-circle construction, "the one axiom of the construction whose analytic content is both load-bearing and completely understood".
- Equation (17) of the same section: η(<i>s</i>) = (1 − 2<sup>1−<i>s</i></sup>) ζ(<i>s</i>).

## Proof / evidence

The source argues the convergence in §9 immediately before the box:

> With the half-turns on, pairing level 2<i>k</i>−1 against level 2<i>k</i> leaves a residue of size O(|<i>s</i>|·<i>k</i><sup>−σ−1</sup>), and Σ<i>k</i><sup>−σ−1</sup> converges for every σ &gt; 0.

It records the failure of the un-alternated train as evidence for what the half-turns buy: at <i>s</i> = ½ + <i>i</i>γ₁ the un-alternated partial sums "grow like √<i>N</i>/|1 − <i>s</i>|, which is 7.0704 at <i>N</i> = 10<sup>4</sup> against a measured 7.0705, and doubles each time <i>N</i> quadruples".

## Dependencies and related results

- η(<i>s</i>) = (1 − 2<sup>1−<i>s</i></sup>) ζ(<i>s</i>) — equation (17), stated in the same section and used throughout the construction.
- The gauge closures of the prefactor: 1 − 2<sup>1−<i>s</i></sup> vanishes at <i>s</i><sub><i>k</i></sub> = 1 + 2π<i>ik</i>/log 2; at <i>k</i> = 1 that is <i>t</i> = 9.064720…, where ζ has modulus 1.3511. rh3 §9 quarantines these as gauge closures (presentation artifacts, not properties of ζ) and points to rh4 §3.
- rh3 §12 leaves the retuning λ<sub><i>n</i></sub> ∈ (0, 1] undetermined: with λ ≡ 1 the rigidity claim is exactly the Riemann Hypothesis.

## Notes

- The source presents this as the reason the construction's numeral is η rather than ζ, and as the one axiom whose analytic content is "load-bearing and completely understood". The convergence of the alternating Dirichlet series on σ &gt; 0 is classical; the source supplies its own pairing argument for it, quoted above.
- The box is a rung of §9's argument that the strip is visible in this presentation; it is not a claim about the location of the zeros. The document's standing disclaimer (rh3 §1) says: "Nothing in this document is a step towards the Riemann Hypothesis, and nothing in it is new."
