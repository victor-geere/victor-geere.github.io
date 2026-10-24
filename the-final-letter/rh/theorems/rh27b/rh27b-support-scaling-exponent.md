# The obstruction, and it can be measured (λ<sub>min</sub>/C<sub>h</sub>(0) ∝ Δ′<sup>−1.7111</sup>)

**Kind:** Claim
**Status:** VERIFIED (numerical, measured slope; the source flags it as "not a theorem"; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27b.html`](../../html/rh27b.html) — §5 "The obstruction, and it can be measured", eq. (1)

## Statement

> Is the support axis a *real* second infinity, or is it a gauge direction — could one certified support be pushed to all of them by rescaling? The window family says gauge: it is exactly scale-free — C<sub>h</sub>(0)/Δ′ a function of θ alone to eleven figures, and, at fixed shape, |ĥ|²'s half-width exactly proportional to 1/Δ′. But the kernel is not scale-free, because it has two scales of its own that do not move with Δ′ — the archimedean density ψ̃, whose crossing at r₊ = 6.289836 is a fixed frequency, and the prime lattice ln p, whose spacing is fixed on the v axis. So a certificate at one support cannot be rescaled into a certificate at another, and the failure is quantitative:
>
> λ<sub>min</sub>/C<sub>h</sub>(0)  ∝  Δ′<sup>−1.7111</sup>   at fixed shape, the two dyadic exponents being 1.7225 and 1.6998.
>
> Measured on the triangle row, where the shape is genuinely held fixed and the only thing changing is the width: 0.9612, 0.2913, 0.0897. The two exponents agree to 1.3%, so it is a power law and not a drift over the range tested. **If that exponent were 0, one certified support would give every support.** It is −1.7111, and that number is the exact sense in which the support axis is a second infinity.

## Hypotheses and notation

- λ<sub>min</sub>/C<sub>h</sub>(0) is the scale-free eigenvalue; C<sub>h</sub>(0)/Δ′ is a function of θ alone to eleven figures.
- "At fixed shape" means the triangle row (θ = 0), where only the width changes; the values 0.9612, 0.2913, 0.0897 are at Δ′ = 0.12, 0.24, 0.48.
- The two dyadic exponents 1.7225 and 1.6998 are the local slopes over the two dyadic steps, agreeing to 1.3% over the range tested ([0.12, 0.48]).
- The two fixed scales of the kernel are r₊ = 6.289836 (ψ̃'s crossing) and the prime lattice ln p.

## Proof / evidence

Numerical: the exponent is fitted on the triangle row over one dyadic range at one depth with one M. The source itself qualifies it: "−1.7111 is a measured slope over one dyadic range at one depth with one M, not a theorem, and an extrapolation of it to Δ′ → ∞ is exactly the kind of step this arc has refused elsewhere." It is also recorded in the dictionary entry "the scaling exponent".

## Dependencies and related results

- [rh27b-three-certified-floors-cross](rh27b-three-certified-floors-cross.md) — the certificates at the same three supports.
- rh27c §5 refutes the exponent as an exponent: the true behaviour is logarithmic, and rh27c's ceiling forced the break ([rh27c-power-law-refuted](../rh27c/rh27c-power-law-refuted.md)).

## Notes


- The source flags this result twice as not a theorem; the Status above records that flag.
- The refutation in rh27c does not remove the qualitative conclusion — the support axis is still a second infinity — only the power-law form of the quantification.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
