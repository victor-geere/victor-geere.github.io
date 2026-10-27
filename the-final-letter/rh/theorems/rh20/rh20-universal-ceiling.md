# Ceiling

**Kind:** Theorem
**Status:** PROVED (paper argument; the constant c₀ carries a certified enclosure, c₀ ≤ 2.100246463)
**Area:** rh-html
**Source:** [`rh20.html`](../../html/rh20.html) — §5 "The ceiling, and the answer", theorem box "The answer"; equation (3)

## Statement

> Ceiling. For every Δ &gt; 0 and every γ ≠ 0, |B<sub>Δ</sub>(γ)|² ≤ c₀/γ² with c₀ = 2.100246. Hence for <i>any</i> family of meshes 𝔉, however large, max<sub>Δ∈𝔉</sub>|B<sub>Δ</sub>(γ)|² ≤ c₀/γ².

Derivation as stated in §5:

> (3)  B<sub>Δ</sub>(γ) = Δ·sinc²(γΔ/2) = (2/γ)·sin²(x)/x  ⟹  |B<sub>Δ</sub>(γ)|² ≤ c₀/γ²,   c₀ = 4·max<sub>x</sub>(sin²x/x)².

## Hypotheses and notation

- x = γΔ/2; B<sub>Δ</sub>(r) = Δ·sinc²(rΔ/2) is the hat transform; γ is a zero ordinate.
- c₀ = 2.100246, with c₀ ≤ 2.100246463 certified by the interval kit; the maximum sits at the root of tan x = 2x, at x* = 1.165561.
- 𝔉 is any family of meshes, however large.
- The bound contains no Δ: "It is a property of the hat, not of any lattice."

## Proof / evidence

The source's proof is one substitution and one stationary point: writing x = γΔ/2 gives B<sub>Δ</sub>(γ) = (2/γ)·sin²x/x, whose maximum sits at the root of tan x = 2x, at x* = 1.165561, giving c₀ = 2.100246. The source reports: "certified below 2.100246463 by the interval kit, and attained: over 120 meshes × 2000 heights the largest measured |B|²γ² is 2.100245, which is 99.9999% of the bound." The document's 38 named checks in 29 s include "the ceiling constant carries both a float value and a certified enclosure, and is checked against 240,000 measured (Δ, r) pairs".

## Dependencies and related results

- [Consequence](rh20-pair-does-not-give-windows.md) is the immediate corollary of this bound.
- [The first joint notch](rh20-first-joint-notch.md) and [the four starved zeros](rh20-four-starved-zeros.md) are the weight-side findings that the Ceiling shows cannot be repaired by adding meshes.
- [rh21's window barrier](../rh21/rh21-window-barrier.md) generalises the observation to arbitrary compactly supported windows (w ≤ πC(0)/T), and notes this document's c₀/γ² is the special case for the triangle hat.

## Notes

- Harvested from the theorem box "The answer"; the box's second paragraph is a separate labelled result, harvested as [Consequence](rh20-pair-does-not-give-windows.md).
- Hypotheses in full, as the source lists them: Weil's criterion, cited, for the RH face of rh18's equivalence; IEEE-754 and libmpdec behaving as specified, for the interval-certified c₀ and the 60-digit Cholesky pivots. "The ceiling (3) itself is elementary: one substitution and one stationary point, and its constant carries a certified enclosure."
