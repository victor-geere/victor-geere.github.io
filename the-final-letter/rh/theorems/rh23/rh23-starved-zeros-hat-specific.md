# The four starved zeros were the hat's, not the mesh's — rh20's c₀ does not survive the change of window

**Kind:** Proposition
**Status:** PROVED (paper argument; the transform identity) with VERIFIED (numerical) figures
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §4 "(iii) The window at other meshes"

## Statement

> The hat's weight at γ is |B<sub>Δ</sub>(γ)|² = (Δ sinc²(γΔ/2))², whose zeros sit at γ = 2πq/Δ; a zero that lands near one is starved by construction. A general window in the family has |ĥ(γ)|² = |φ̂<sub>δ</sub>(γ)|²A(γ)², A(γ) = Σ<sub>k</sub>a<sub>k</sub>cos(kγδ), and its notches are wherever the search put the roots of A — not at 2πq/Δ.
>
> The searched window's four worst zeros are a different set — not one of rh20's four is among them — and they are 1.3×10<sup>5</sup>× higher.
>
> **rh20's constant does not survive; its conclusion does.** rh20's ceiling was c₀ = 2.1002465 with |B<sub>Δ</sub>(γ)|² ≤ c₀/γ² for every Δ, and the impossibility of (W) for any finite family of meshes followed from it. The searched window exceeds c₀/γ² by 41× — c₀ was a statement about the triangle hat's transform, and this document has changed the transform. What replaces it is rh21's barrier, w ≤ πC(0)/T, which was proved for *every* compactly supported window and which the searched window still obeys. rh20's route stays closed; the proof of its closure now runs through rh21 rather than through c₀.

## Hypotheses and notation

- rh20's four starved zeros are γ = 52.970, 79.337, 103.726, 105.447, "each within 0.05 of a notch of both meshes"; the hat's weight is |B<sub>Δ</sub>(γ)|² = (Δ sinc²(γΔ/2))², whose notches sit at γ = 2πq/Δ.
- A general family window has |ĥ(γ)|² = |φ̂<sub>δ</sub>(γ)|²A(γ)² with A(γ) = Σ<sub>k</sub>a<sub>k</sub>cos(kγδ).
- c₀ = 2.1002465 (rh20); the barrier w ≤ πC(0)/T (rh21) is the replacement.
- (W) is the window statement in rh18's chain (L)⟺(W)⟺(Bo).

## Proof / evidence

The transform identity |ĥ(γ)|² = |φ̂<sub>δ</sub>(γ)|²A(γ)² is stated in the source; the numbers (1.3×10<sup>5</sup>× higher, factor 4.0 spread, 41× above c₀/γ²) are measured. The source's own framing:

> This is exactly the kind of drift rh22 §2's audit was built to catch, and it is recorded here in the same terms.

## Dependencies and related results

- rh20's ceiling c₀ = 2.1002465, its θ-scan of six thousand mesh ratios, and its certification of six union node sets.
- rh21's barrier πC(0)/T, "proved for *every* compactly supported window".
- The (W)-side extension, stated in the same section: "All six are rebuilt here with the searched window, and all six stay positive definite, with minimum pivots up by 1153–3274×" (dictionary gloss: "hat-specific constant — a bound proved from B<sub>Δ</sub>(r) = Δ sinc²(rΔ/2), which no other window obeys").
- The same identity recurs as rh24 equation (3) ([the notch ladder belongs to the basis](../rh24/rh24-notch-ladder-basis.md)).

## Notes

- **This is a correction of a published rh20 ceiling's scope**, not of rh20's conclusion. The source is explicit: "c₀ was a statement about the triangle hat's transform, and this document has changed the transform."
- The second-mesh gain collapses correspondingly: "the hat's floor over the first forty zeros is 8.087×10<sup>-10</sup> at one mesh and 1.361×10<sup>-5</sup> at its best pair, a gain of 16834×. The searched window's floor at *one* mesh is 1.043×10<sup>-4</sup> … and its best pair reaches 9.085×10<sup>-4</sup>, a gain of only 8.7×."
