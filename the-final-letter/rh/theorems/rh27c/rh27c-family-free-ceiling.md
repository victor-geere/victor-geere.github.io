# (b) The ceiling — λ<sub>min</sub>(T<sub>h</sub>)/C<sub>h</sub>(0) ≤ ln((2 + ‖h′‖<sub>2</sub>/‖h‖<sub>2</sub>)/2π) + 4 sinh Δ′ + G(2Δ′)

**Kind:** Proposition
**Status:** PROVED (paper argument; sharp along rh25's extremal sequence, slack 0.0106 → 0.00008; Jensen step costs 0.23–0.53 nats)
**Area:** rh-html
**Source:** [`rh27c.html`](../../html/rh27c.html) — §3 "(b) The ceiling", eqs. (3)–(5)

## Statement

> Let h be real, even, supported in [−Δ′, Δ′], with h′ ∈ L². Write C<sub>h</sub> = h ⋆ h, so C<sub>h</sub>(0) = ‖h‖² and Ĉ<sub>h</sub> = |ĥ|² ≥ 0. The kernel's diagonal is E<sub>h</sub>(0) = pole(0) + arch(0) − comb(0), and each of the three is bounded separately.
>
> **The arch, by Jensen.** … Plancherel with ĥ(r) = ∫h(t)e<sup>−irt</sup>dt and h even gives ∫<sub>0</sub><sup>∞</sup>|ĥ|²dr = π‖h‖² and ∫<sub>0</sub><sup>∞</sup>r²|ĥ|²dr = π‖h′‖². So
>
> `dμ(r) = |ĥ(r)|² dr / (π‖h‖²)`
>
> is a probability measure on [0, ∞), and arch(0)/C<sub>h</sub>(0) is exactly 𝔼<sub>μ</sub>[ψ̃] — not an estimate of it, the same number. Now apply (1), then Jensen to the concave ln(2+·), then Cauchy–Schwarz to replace the first moment by the second:
>
> 𝔼<sub>μ</sub>[ψ̃] ≤ 𝔼<sub>μ</sub>[ln(2+r)] − ln 2π ≤ ln(2 + 𝔼<sub>μ</sub>[r]) − ln 2π ≤ ln((2 + ‖h′‖/‖h‖)/2π).
>
> **The pole, by Cauchy–Schwarz.** pole(0) = 2ĥ(i/2)² and ĥ(i/2) = ∫h(t)e<sup>t/2</sup>dt ≤ ‖h‖·(∫<sub>−Δ′</sub><sup>Δ′</sup>e<sup>t</sup>dt)<sup>½</sup>, so pole(0)/C<sub>h</sub>(0) ≤ 4 sinh Δ′. Uniform in h, and it vanishes with the support.
>
> **The comb, by the gear mass.** |C<sub>h</sub>(x)| ≤ C<sub>h</sub>(0) for every x, and C<sub>h</sub> is supported in [−2Δ′, 2Δ′], so |comb(0)|/C<sub>h</sub>(0) ≤ G(2Δ′) = Σ<sub>|ln m| ≤ 2Δ′</sub> Λ(m)m<sup>−½</sup>. … this is *zero* whenever 2Δ′ < ln 2 = 0.693, because the nearest prime power to 1 is 2.
>
> Putting the three together with the elementary λ<sub>min</sub>(T<sub>h</sub>) ≤ E<sub>h</sub>(0) — the smallest eigenvalue of a Toeplitz section is at most any diagonal entry:
>
> λ<sub>min</sub>(T<sub>h</sub>)/C<sub>h</sub>(0)  ≤  E<sub>h</sub>(0)/C<sub>h</sub>(0)  ≤  ln((2 + ‖h′‖<sub>2</sub>/‖h‖<sub>2</sub>)/2π) + 4 sinh Δ′ + G(2Δ′),
>
> for every real even h of half-support Δ′ with h′ ∈ L², at every section size, on every lattice. That is the first bound in this arc that names no family, no mesh, no M and no generator.

## Hypotheses and notation

- h real, even, supported in [−Δ′, Δ′], with h′ ∈ L²; C<sub>h</sub> = h ⋆ h, C<sub>h</sub>(0) = ‖h‖², Ĉ<sub>h</sub> = |ĥ|² ≥ 0.
- E<sub>h</sub>(0) = pole(0) + arch(0) − comb(0) is the kernel's diagonal.
- G(2Δ′) = Σ<sub>|ln m| ≤ 2Δ′</sub> Λ(m)m<sup>−½</sup>; it is zero whenever 2Δ′ < ln 2 = 0.693.
- Δ′ is the half-support; ‖h′‖<sub>2</sub>/‖h‖<sub>2</sub> is the Sobolev ratio the bound penalises.

## Proof / evidence

Paper argument in three separately bounded pieces (Jensen for the arch, Cauchy–Schwarz for the pole, the gear mass for the comb), then λ<sub>min</sub> ≤ E<sub>h</sub>(0). Sharpness: along h = √2 cos(r₀t)φ<sub>Δ</sub>(t) — the sequence rh25 §4 used to prove no ceiling exists — the slack runs 0.0106 at r₀ = 200 down to 0.00008 at 25000, closing like 2/r₀ (the lemma's own gap, not a second loss). On the arc's own searched windows the Jensen step costs between 0.23 and 0.53 nats and is the only lossy link in the chain. The check suite reports the ceiling "checked to hold at every window in the document".

## Dependencies and related results

- [rh27c-lemma-psi-tilde-majorant](rh27c-lemma-psi-tilde-majorant.md) — the inequality the arch step applies.
- rh25 §4's extremal sequence and the fact that no family-bound ceiling exists.
- It subsumes the family ceilings ([rh27c-family-ceilings-subsumed](rh27c-family-ceilings-subsumed.md)) and makes the prediction tested in [rh27c-power-law-refuted](rh27c-power-law-refuted.md).
- rh28 later tightens the diagonal step with the Fejér ceiling ([rh28-fejer-ceiling](../rh28/rh28-fejer-ceiling.md)).

## Notes

- The source is explicit that this is an upper bound and does not certify anything: "A document that proves a ceiling has not moved towards RH by a single certified point."
- At Δ′ = 0.03 the pair (5) plus a certified floor gives the arc's first bracket, λ<sub>min</sub>/C<sub>h</sub>(0) ∈ [1.2794, 5.40].
- The Kind is given as Proposition because the source calls it "the ceiling" and treats it as a bound, not a named theorem.
