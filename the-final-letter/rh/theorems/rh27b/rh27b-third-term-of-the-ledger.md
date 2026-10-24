# The third term of rh21's ledger, which runs the other way

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27b.html`](../../html/rh27b.html) — §3 "(b) rh21's ledger, re-run — and the term it is missing"

## Statement

> rh21 priced a wider window twice: the comb must reach e<sup>2Δ′</sup> further (2.05× from 0.12 to 0.48) and rh18's K<sub>lin</sub> grows with it. Both hold. The third term runs the other way — at fixed M a wider window is *smoother*, because Û<sub>c</sub>'s prefactor goes like 1/δ, so it drops 39× less archimedean weight past the cut, scale-free.
>
> At fixed M, the window's generator mesh is δ = Δ′/16 — so a *wider* support means *wider* generators, and the window is smoother, not rougher. Its transform therefore decays faster, and less of the archimedean integrand is left beyond the cut. Measured at v = 0, the weight still dropped past R₁ = 4800 is 2.76×10⁻⁵ at Δ′ = 0.12, 7.67×10⁻⁶ at 0.24 and 2.46×10⁻⁶ at 0.48 — raw, the wide window drops 11.2× less; taken scale-free, for the reason the next paragraph gives, **39× less**.

The mechanism:

> Far from the origin Û<sub>c</sub>(r) = 2c(cosh cδ − cos rδ)/(sinh cδ · (c² + r²)) is 2c(cosh θ − cos rδ)/(sinh θ · r²) to leading order, whose mean prefactor 2θ cosh θ/(δ sinh θ) is proportional to **1/δ**. So doubling the support halves the transform out there, and at the shared θ = 0.96 the measurement returns exactly that factor of two. The integrand itself falls like r<sup>−4</sup> — doubling the band divides its scale-free mean by 16 at every support, checked — and over three decades past the cut those band means fall monotonically with the support.

## Hypotheses and notation

- Price one (the comb): the kernel row at depth v needs every prime power below e<sup>v + 2Δ′</sup>; from 0.12 to 0.48 that is a factor e<sup>0.72</sup> = 2.05.
- Price two (K<sub>lin</sub>): rh18 §3's linear-continuity constant, quoted from rh18 rather than re-measured.
- The third term: the archimedean weight still dropped past the cut R₁ = 4800, at v = 0, relative to C<sub>h</sub>(0).
- U<sub>c</sub> is the hyperbolic generator with shape parameter c on generators of half-width δ; θ = cδ.
- One qualification: the three transforms reach comparable *peaks* out at the cut; they separate only in the mean, which is what the dropped weight integrates.

## Proof / evidence

Numerical, plus the read-off from the generator: the measured dropped weights 2.76×10⁻⁵, 7.67×10⁻⁶, 2.46×10⁻⁶ (raw ratio 11.2×, scale-free 39×), the r<sup>−4</sup> fall of the integrand, and the exact factor of two at θ = 0.96. The source notes rh21 could not have priced this "because at the time the window was a fixed triangle and M was not a free parameter".

## Dependencies and related results

- rh21 §4's support argument, re-run here; rh18 §3's K<sub>lin</sub>; rh25's hyperbolic generator.
- Feeds [rh27b-scale-free-verdict-reverses](rh27b-scale-free-verdict-reverses.md), where the same normalisation reverses the verdict.

## Notes


- The source's summary: "The trade is not one-sided."
- This is a correction of the ledger (an omitted term), not a refutation of rh21's two prices, both of which are stated to hold.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
