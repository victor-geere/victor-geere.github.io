# The four starved zeros are the whole criterion

**Kind:** Claim
**Status:** VERIFIED (numerical, 6000 ratios scanned; each failure attributed to one of four zeros; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh20.html`](../../html/rh20.html) — §3 "What a pair buys, and where it buys nothing"

## Statement

> What the criterion is. The floor at a single mesh is set by one zero. At Δ = 0.24 it is zero #32 at γ = 105.447, whose weight is 1.294×10<sup>−10</sup> because 2π/Δ = 26.180 and 4.0278 of those notch spacings reaches it. A second mesh rescues that zero unless it too has a notch there — and the same holds for the next few starved zeros. So the failures are indexed by a <i>finite list</i>. Scanning 6000 ratios: 1,020 of them (17.0%) gain less than 10×, and at every single one the responsible zero is one of exactly four — 52.970, 79.337, 103.726, 105.447 — each sitting within 0.0425 of a notch of <i>both</i> meshes, in units of the notch spacing. The set of bad pairs is arithmetic and finite, not Diophantine; it is a property of where four particular zeros happen to lie.

The source's companion negative result:

> The guess that fails. … θ = 3/5 is as simple a rational as exists, its Diophantine quality q‖qθ‖ is exactly zero, and it gains 2,857× — the same as 1/φ. Meanwhile θ = 1/2 gains 1.0× and θ = 3/4 gains 1.0×: nothing at all. Diophantine quality is not the criterion.

## Hypotheses and notation

- F(Δ₁, Δ₂) = min<sub>j ≤ 40</sub> max(|B<sub>Δ₁</sub>(γ<sub>j</sub>)|², |B<sub>Δ₂</sub>(γ<sub>j</sub>)|²), the pair's weight floor over the first 40 zeros.
- Single mesh: at Δ = 0.24, F = 1.294×10⁻¹⁰; at Δ* = 0.444521 it is 4.563×10⁻⁶⁷. Golden pair: 3.696×10⁻⁷ (a factor 2,857); best ratio θ* = 0.581214: 9.230×10⁻⁷ (a factor 7,134).
- The four starved zeros: 52.970, 79.337, 103.726, 105.447; "within 0.0425 of a notch" is in units of the notch spacing.
- q‖qθ‖ is the Diophantine quality (Khinchin, cited) that the scan shows is not the criterion.

## Proof / evidence

The source reports a scan of 6000 ratios θ ∈ [0.3, 1]: 1,020 (17.0%) gain less than 10×, and at every one of them the responsible zero is one of the four listed. The document's 38 named checks in 29 s include assertions for "the two negative results — that Diophantine quality is not the criterion, and that every failure is one of four zeros". The source's own interpretation: "The set of bad pairs is arithmetic and finite, not Diophantine."

## Dependencies and related results

- Uses the zero weights |B<sub>Δ</sub>(γ)|² and rh14's statement E<sub>Δ</sub>(v) = Σ<sub>γ</sub>|B<sub>Δ</sub>(γ)|²cos(γv) on RH.
- [The first joint notch](rh20-first-joint-notch.md) supplies the rational-mesh setup; the failure list is the finite counterpart of the "r<sub>joint</sub> above the horizon" criterion.
- [rh19's notch finding](../rh19/rh19-notch-deletes-first-zero.md) is the Δ* case the pair rescues.
- [The ceiling and its consequence](rh20-universal-ceiling.md) explain why no family of meshes repairs the starvation that survives.

## Notes


- Harvested as a stated result of the round (the abstract's "what replaces it is smaller and sharper: four specific zeros"), though the source does not label it a theorem. Status is measurement-backed.
- The source is explicit that a pair "lifts the floor by three orders" at good ratios, so rh19's worry about marginal surviving weights was misplaced; the obstruction is structural, not quantitative.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
