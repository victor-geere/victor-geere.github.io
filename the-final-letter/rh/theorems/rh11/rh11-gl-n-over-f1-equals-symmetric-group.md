# GL_n(𝔽₁) = S_n

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §4 "Dig three — counting over 𝔽₁", equation (2)

## Statement

> GL<sub>*n*</sub>(𝔽₁) = S<sub>*n*</sub> :
> &nbsp;&nbsp;#GL₃/(q−1)³q³ → 3! = 6,&nbsp;&nbsp;#GL₄/(q−1)⁴q⁶ → 4! = 24.

with the surrounding grammar of the same paragraph: the q-integer [*n*]<sub>q</sub> = 1+q+⋯+q<sup>*n*−1</sup> counts the points of P<sup>*n*−1</sup>(𝔽<sub>q</sub>) and at q → 1 is *n* (projective space over 𝔽₁ is a finite set of points; [3]<sub>q</sub> → 3 verified to 10<sup>−12</sup>); the q-binomial [4 2]<sub>q</sub> counts planes in 𝔽<sub>q</sub>⁴ and limits to 6 = the number of 2-element subsets of a 4-element set (Grassmannians over 𝔽₁ are subset lattices).

## Hypotheses and notation

- 𝔽₁ is the field with one element in Tits' sense: not a field, but the name of the limit q → 1.
- #GL<sub>*n*</sub>(𝔽<sub>q</sub>) = q<sup>n(n−1)/2</sup>(q−1)<sup>n</sup>[*n*]<sub>q</sub>! (verified as an exact integer identity at q = 2, 3); the normalisation is by the torus-and-unipotent factor (q−1)<sup>n</sup>q<sup>n(n−1)/2</sup>.
- Every quantity below is an actual limit at q = 1+ε with Richardson extrapolation, checked against its exact integer target.

## Proof / evidence

The source gives the limit computation and the exact integer identity for the group count, and verifies the limits numerically against their integer targets: [3]<sub>q</sub> → 3 to 10<sup>−12</sup>, [4 2]<sub>q</sub> → 6, #GL₃/(q−1)³q³ → 3! = 6, #GL₄/(q−1)⁴q⁶ → 4! = 24. The source reads the result as: "The symmetric group — rh5 §5's clock world … is the general linear group of the missing base."

## Dependencies and related results

- [Soulé's ζ over 𝔽₁](rh11-soule-zeta-over-f1.md) — the companion counting computation in §5.
- rh5 §5's clock world is the permutation substrate this identification names.
- rh12 §6 uses the same 𝔽₁ grammar when it builds the counting function N(q).

## Notes

- The statement is a limit identity for the normalised group counts; the source presents it as the first hard evidence that "geometry over 𝔽₁" is the right name, not as new mathematics. The numerical limits are quoted as verified against exact targets.
