# The axioms survive the smoothing

**Kind:** Theorem
**Status:** PROVED (paper argument; identities verified numerically to 10⁻¹⁶)
**Area:** rh-html
**Source:** [`rh6.html`](../../html/rh6.html) — §2 "The congruent cone: η's integral form as the lawful smoothing", theorem box at lines 345–350

## Statement

> **Annihilation → recursion.** Prepend one circle and half-turn it: the kernel <i>K</i>(<i>x</i>) = 1/(<i>e</i><sup><i>x</i></sup>+1) satisfies <i>K</i> = <i>e</i><sup>−<i>x</i></sup>(1 − <i>K</i>) — "the train is its first car minus a shifted copy of itself" — exactly the self-similarity that the axiom <i>a</i> + <i>A</i> = 0 gives the discrete helix. Verified to 10<sup>−16</sup>.
>
> **Doubling → the gauge identity.** The un-alternated train has the Bose kernel 1/(<i>e</i><sup><i>x</i></sup>−1) (and pays for it with the pole at <i>s</i> = 1). Pointwise, Bose − Fermi = 2/(<i>e</i><sup>2<i>x</i></sup>−1) — a doubled Bose kernel — and under the integral this is precisely ζΓ − ηΓ = 2<sup>1−<i>s</i></sup>ζΓ, i.e. η = (1−2<sup>1−<i>s</i></sup>)ζ: the gauge factor of rh4 §3, now a statement about kernels. Verified at <i>s</i> = 2+3<i>i</i> to 10<sup>−16</sup>.
>
> **Concatenation → convolution.** Gears compose by multiplication, <i>m</i><sup>−<i>s</i></sup><i>n</i><sup>−<i>s</i></sup> = (<i>mn</i>)<sup>−<i>s</i></sup>; on the cone the modes compose by multiplicative (Mellin) convolution with Γ as the unit of account. The digit algebra passes to the continuum with its operations intact.

## Hypotheses and notation

- The congruent cone is η's integral (Fermi–Dirac) form, valid on all of σ &gt; 0: η(<i>s</i>) Γ(<i>s</i>) = ∫<sub>0</sub><sup>∞</sup> <i>x</i><sup><i>s</i>−1</sup>/(<i>e</i><sup><i>x</i></sup> + 1) d<i>x</i>, equation (3), with 1/(<i>e</i><sup><i>x</i></sup>+1) = Σ<sub><i>n</i>=1</sub><sup>∞</sup> (−1)<sup><i>n</i>−1</sup><i>e</i><sup>−<i>nx</i></sup>.
- Fermi kernel: <i>K</i>(<i>x</i>) = 1/(<i>e</i><sup><i>x</i></sup>+1). Bose kernel: 1/(<i>e</i><sup><i>x</i></sup>−1). Γ is the gamma function, "the fixed exchange rate between circle and cone" (<i>n</i><sup>−<i>s</i></sup>Γ(<i>s</i>) = ∫ <i>x</i><sup><i>s</i>−1</sup><i>e</i><sup>−<i>nx</i></sup> d<i>x</i>).
- <i>a</i> + <i>A</i> = 0 is the phase-opposite (half-turn) axiom of the discrete construction.

## Proof / evidence

The three identities are algebraic in the two kernels: prepending and half-turning gives <i>e</i><sup>−<i>x</i></sup>(1 − 1/(<i>e</i><sup><i>x</i></sup>+1)) = 1/(<i>e</i><sup><i>x</i></sup>+1); Bose − Fermi = 1/(<i>e</i><sup><i>x</i></sup>−1) − 1/(<i>e</i><sup><i>x</i></sup>+1) = 2/(<i>e</i><sup>2<i>x</i></sup>−1); concatenation is multiplicativity of <i>n</i><sup>−<i>s</i></sup>, which is passed to the cone by Mellin convolution.

The source reports its own numerical checks: the recursion "Verified to 10<sup>−16</sup>", and the gauge identity "Verified at <i>s</i> = 2+3<i>i</i> to 10<sup>−16</sup>". The third item is an operation-preservation statement rather than a numerical identity.

## Dependencies and related results

- η(<i>s</i>) = (1 − 2<sup>1−<i>s</i></sup>) ζ(<i>s</i>), the gauge factor of rh4 §3, here re-derived as a statement about kernels.
- The real non-negative profile 1/(<i>e</i><sup><i>x</i></sup>+1) carries no phase, which is how the cone satisfies Axiom 9 (rh6 §1) with the phase as pure torsion.
- The section's uniqueness statement (harvested separately as rh6-unique-lawful-profile.md) is what makes this smoothing the only <i>t</i>-independent one.

## Notes

- The source's box is labelled "The axioms survive the smoothing" and is a `box thm` block; its three items are the transfer of the discrete axioms to the continuum kernel.
- The numerical figures quoted are exactly the source's: 10<sup>−16</sup> for the recursion, and 10<sup>−16</sup> at <i>s</i> = 2+3<i>i</i> for the gauge identity.
