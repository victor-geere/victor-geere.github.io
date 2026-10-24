# The window barrier w ≤ πC(0)/T

**Kind:** Theorem
**Status:** PROVED (paper argument, elementary and unconditional)
**Area:** rh-html
**Source:** [`rh21.html`](../../html/rh21.html) — §5 "The window, and the room under the barrier", equation (4)

## Statement

> Let h be any window supported in [−Δ, Δ], and suppose |ĥ(γ)|² ≥ w for every γ in [0, T]. Then

> (4)  2Tw ≤ ∫<sub>−T</sub><sup>T</sup>|ĥ|² ≤ ∫<sub>ℝ</sub>|ĥ|² = 2π‖h‖₂² = 2πC(0)  ⟹  w ≤ πC(0)/T.

The source's reading: "One line, unconditional, and it bounds the weight floor by <i>1/T</i> where the hat manages 1/γ⁴. C(0) = ‖h‖₂² is exactly the quantity that has to stay finite for the comb to be a finite sum, so (4) is not an artefact of a normalisation — it is the trade the construction already makes, priced."

## Hypotheses and notation

- h is any compactly supported window with support in [−Δ, Δ]; ĥ its transform; C = h ⋆ ȟ, so C(0) = ‖h‖₂².
- w is a uniform lower bound for |ĥ(γ)|² on [0, T]; the inequality is w ≤ πC(0)/T.
- The barrier is a statement about the hat generally, "both simpler and much weaker" than rh20's c₀/γ²; rh20's [Ceiling](../rh20/rh20-universal-ceiling.md) is the special case for the triangle hat.

## Proof / evidence

The source gives the one-line proof displayed in (4): the mean-value/Plancherel chain 2Tw ≤ ∫<sub>−T</sub><sup>T</sup>|ĥ|² ≤ ∫<sub>ℝ</sub>|ĥ|² = 2π‖h‖₂² = 2πC(0). Numerical instantiation reported by the source: "At unit energy, over the first 40 zeros (up to γ = 122.9), the barrier is 2.56×10⁻² and the triangle hat achieves a typical weight of 6.76×10⁻⁶ — 3,780× under it." Admissibility is unaffected: "unit energy keeps C(0) finite, so C = h⋆ȟ is bounded, the comb remains a finite sum, and rh18's identity at arbitrary nodes applies unchanged." The document's 32 named checks include "the barrier".

## Dependencies and related results

- [rh20's Ceiling](../rh20/rh20-universal-ceiling.md) is the triangle-hat case of the same obstruction.
- [The Slepian gain](rh21-slepian-window-gain.md) measures how much of the barrier's room a better window can take.
- [rh18 T1a](../rh18/rh18-t1a-weil-identity.md) is what keeps a modified window admissible.

## Notes

- The source's status line: "Hypotheses: RH itself, for the zeros-side kernel of §2 … The barrier of §5 is elementary and unconditional."
- The source is careful about what is claimed: "Not that a Slepian is the right choice … no search over windows was run. The search is the successor."
- The source's methodological warning belongs to this section: the minimum over zeros is not a property of the window ("Tripling the discretisation moves the Slepian's minimum by 140× while its typical weight moves by 1.15×"), so window comparisons must be scored on a typical weight — "the first draft of this document was scored on the minimum and was wrong by three orders".
