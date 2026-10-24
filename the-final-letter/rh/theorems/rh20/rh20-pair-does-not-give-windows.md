# Consequence — a pair fixes deletion, nothing fixes starvation

**Kind:** Corollary
**Status:** PROVED (paper argument, from the Ceiling |B<sub>Δ</sub>(γ)|² ≤ c₀/γ²)
**Area:** rh-html
**Source:** [`rh20.html`](../../html/rh20.html) — §5 "The ceiling, and the answer", theorem box "The answer"

## Statement

> Consequence. A pair fixes deletion — the failure mode of rh19 §4 — and nothing fixes starvation. Above γ = 2384 no mesh at all gives a zero even the weight one golden pair guarantees below it; above γ = 14,492 nothing gives weight 10⁻⁸. So (L) at two meshes does not give (W), and enlarging the family cannot change that: the deficiency is not in the lattice, it is in the hat.

## Hypotheses and notation

- "Deletion" is the failure mode of rh19 §4: a zero landing in a notch, weight → 0 (at Δ* = 2π/γ₁ the weight of γ₁ is |B(γ₁)|² = 4.6×10⁻⁶⁷).
- "Starvation" is a zero above the reach of any hat, weight ≤ c₀/γ².
- The golden pair's floor is 3.696×10⁻⁷ ([the four starved zeros](rh20-four-starved-zeros.md)); γ = 2384 is where c₀/γ² falls below it, γ = 14,492 where it falls below 10⁻⁸.
- (L) and (W) are the faces of [rh18's equivalence](../rh18/rh18-t-p2-closed.md).

## Proof / evidence

Direct from [the Ceiling](rh20-universal-ceiling.md): since max<sub>Δ∈𝔉</sub>|B<sub>Δ</sub>(γ)|² ≤ c₀/γ² for any family 𝔉, no family can give a zero above γ = 2384 even the weight one pair guarantees below it. The source's summary of the round: "The answer is negative, and it is more informative than expected, because the obstacle turns out not to be the one named." The document's 38 named checks include the assertions for the ceiling and for the negative results.

## Dependencies and related results

- [Ceiling](rh20-universal-ceiling.md) is the theorem this corollary reads off.
- [The four starved zeros](rh20-four-starved-zeros.md) supplies the gain figures (2,857× at the golden pair).
- [rh19's notch finding](../rh19/rh19-notch-deletes-first-zero.md) is "the failure mode of rh19 §4" being repaired.
- rh21 §5 takes up the hat: "the deficiency is not in the lattice, it is in the hat" is the opening for [the window barrier](../rh21/rh21-window-barrier.md) and the Slepian gain.

## Notes

- Harvested from the theorem box "The answer"; it is the box's second labelled item and is labelled "Consequence.", hence Kind: Corollary.
- The source's closing judgement: "rh19 ranked this question first because it looked like the cheapest way to strengthen (L), and the honest result is that it is not a way at all." Hypotheses: Weil's criterion (cited) for the RH face; IEEE-754 and libmpdec.
