# Uniqueness of the lawful profile (the Fermi function)

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically to 4×10⁻¹⁶)
**Area:** rh-html
**Source:** [`rh6.html`](../../html/rh6.html) — §2 "The congruent cone: η's integral form as the lawful smoothing", lines 351–358

## Statement

> Is the Fermi profile one lawful choice among many? No — and this is the sharpest fact in this document's first half. Suppose any profile <i>K</i>(<i>x</i>), independent of <i>t</i>, represents the value: η(<i>s</i>)Γ(<i>s</i>) = ∫ <i>K</i>(<i>x</i>)<i>x</i><sup><i>s</i>−1</sup> d<i>x</i> on a vertical line. Mellin inversion then <i>recovers</i> <i>K</i> from the value: (4) <i>K</i>(<i>x</i>) = (1/2π<i>i</i>) ∫<sub>σ−<i>i</i>∞</sub><sup>σ+<i>i</i>∞</sup> η(<i>s</i>) Γ(<i>s</i>) <i>x</i><sup>−<i>s</i></sup> d<i>s</i>, computed here numerically on σ = 2: <i>K</i>(1) = 0.268941… against 1/(<i>e</i>+1) to 4×10<sup>−16</sup>, and <i>K</i>(2) against 1/(<i>e</i>²+1) to 10<sup>−15</sup>. **The value remembers its cone.** There is exactly one <i>t</i>-independent profile congruent with η, it is the Fermi function, and its lawfulness is therefore not an achievement but a theorem: Axiom 9, for the analytic lift, costs nothing and permits nothing else.

## Hypotheses and notation

- A profile <i>K</i>(<i>x</i>) is required to be independent of the altitude <i>t</i> and to represent the value on a vertical line: η(<i>s</i>)Γ(<i>s</i>) = ∫ <i>K</i>(<i>x</i>)<i>x</i><sup><i>s</i>−1</sup> d<i>x</i>.
- "Congruent with η" means equal to the value, "not approximately but identically, at every <i>s</i>" (rh6 §2).
- The Fermi function is 1/(<i>e</i><sup><i>x</i></sup>+1); equation (4) is the Mellin inversion integral.
- Axiom 9 (rh6 §1) is the order axiom: any continuous representation of the numeral must have strictly monotone phase.

## Proof / evidence

The source's argument is Mellin inversion: if a <i>t</i>-independent profile <i>K</i> represents the value, then (4) recovers <i>K</i> from η(<i>s</i>)Γ(<i>s</i>), so the profile is uniquely determined; evaluating it gives the Fermi function. The source reports the numerical check on σ = 2: <i>K</i>(1) = 0.268941… against 1/(<i>e</i>+1) to 4×10<sup>−16</sup>, and <i>K</i>(2) against 1/(<i>e</i>²+1) to 10<sup>−15</sup>.

## Dependencies and related results

- η(<i>s</i>) Γ(<i>s</i>) = ∫<sub>0</sub><sup>∞</sup> <i>x</i><sup><i>s</i>−1</sup>/(<i>e</i><sup><i>x</i></sup>+1) d<i>x</i>, equation (3), the Fermi–Dirac form.
- The companion theorem box of the same section, "The axioms survive the smoothing" (rh6-axioms-survive-the-smoothing.md).
- rh6 §5.1's dictionary lists this result as "uniqueness of the lawful profile — Mellin inversion theorem".
- rh6 §2 contrasts it with the bare cone of rh5 §3, "which is not a representation of η at all but of the Γ-factors alone"; on the critical line that cone's modulus is √2 · (1 + <i>e</i><sup>−2π<i>t</i></sup>)<sup>−1/2</sup>, equal to √2 within 10<sup>−13</sup> at γ₁₀.

## Notes

- Unlike the other harvests from rh6, this result is stated inline in §2 and explicitly called a theorem ("its lawfulness is therefore not an achievement but a theorem"), not placed in a `box thm` block. It is harvested under the spec's rule for a result the source states as a result of this workspace.
- The source's own framing: the uniqueness means Axiom 9, "for the analytic lift, costs nothing and permits nothing else".
