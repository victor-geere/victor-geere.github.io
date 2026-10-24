# No uniform Dirichlet floor: λ<sub>min</sub>(G)/mass decays for every window tried

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §4 "The Dirichlet floor"

## Statement

> So: does a Dirichlet polynomial of length N have to be large somewhere on the zeros? λ<sub>min</sub>(G)/mass is exactly that question, and the answer is that it decays, for every window tried.

> For the searched-0.12 window the floor runs 0.5685 at N = 8 to 0.0034 at N = 96. Only the Δ = 0.06 window is even a power law: forced through one it gives N<sup>−0.63</sup> with every point within 0.17 in ln. The 0.12 window is not — forced through a power its exponent reads −1.76 and the worst point is 1.52 out in ln, because the decay accelerates. And the gentler window collapses too, just later: 0.040 at N = 128 and 8.6×10⁻³ at N = 160.

> There is no uniform Dirichlet floor here. Changing the sampling did not buy one, and it is worth being plain that this was the outcome hoped for when the section was written.

## Hypotheses and notation

- G is the unwrapped Gram of §3; λ<sub>min</sub>(G)/mass is the floor normalised by the measure's mass.
- Windows: the searched 0.12 window, the Δ = 0.06 window, and a gentler window.

## Proof / evidence

Numerical, over the computed eigenvalues: 0.5685 → 0.0034 from N = 8 to 96 on the 0.12 window; the Δ = 0.06 window fits N<sup>−0.63</sup> with every point within 0.17 in ln; the 0.12 window's forced exponent is −1.76 with the worst point 1.52 out in ln; the gentlest window gives 0.040 at N = 128 and 8.6×10⁻³ at N = 160.

## Dependencies and related results

- [rh34-unwrapped-gram-and-dirichlet-polynomial](rh34-unwrapped-gram-and-dirichlet-polynomial.md) — the matrix whose floor this is.
- rh30 §10 (a) — the collapse the arc wants proved, which this measurement works against.
- [rh36-collapse-forced-suppression](../rh36/rh36-collapse-forced-suppression.md) — the later explanation: a shortened partial sum sits near chance and only collapses once it can resolve a zero.

## Notes


- The source flags the negative expectation explicitly: this was the outcome hoped for when the section was written, and the sampling change did not buy a floor.
- The section is conditional on RH through rh29's zero table (4,308 ordinates, γ ≤ 4800).

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
