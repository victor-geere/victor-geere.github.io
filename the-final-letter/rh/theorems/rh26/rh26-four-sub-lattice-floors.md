# The certificates, off the diagonal (four sub-lattice floors)

**Kind:** Claim
**Status:** VERIFIED (numerical, 60-digit inertia bisection and an independent dense Cholesky; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh26.html`](../../html/rh26.html) — §5 "The certificates, off the diagonal", eq. (8)

## Statement

> Backend α unchanged from rh19 and rh25 — a verified Cholesky at 40 digits, an exact-product residual at 90, plus the radius row-sums — with two things made parameters. The certified arch and pole are evaluated at node spacing s·δ rather than at Δ, and the comb row is recombined at stride s.
>
> ```
> Δ     n = 76,  v = 18.00   λ_min = 4.6755×10⁻²   ρ = 1.04×10⁻¹⁰   floor 4.6287×10⁻²
> Δ/2   n = 151, v = 18.00   λ_min = 1.0962×10⁻³   ρ = 2.02×10⁻¹⁰   floor 1.0852×10⁻³
> Δ/4   n = 151, v = 9.00    λ_min = 3.2110×10⁻³   ρ = 4.41×10⁻¹²   floor 3.1789×10⁻³
> Δ/8   n = 151, v = 4.50    λ_min = 3.2424×10⁻³   ρ = 9.14×10⁻¹³   floor 3.2099×10⁻³
> Δ/16  n = 151, v = 2.25    λ_min = 3.1095×10⁻⁶   ρ = 5.78×10⁻¹³   floor 3.0784×10⁻⁶
> ```
>
> Four floors on sub-lattices, where the arc had none. The deepest *in v* is 1.0852×10⁻³ at n = 151 on Δ/2 — the same depth 18 the Δ-lattice certificates reach, at half the mesh. Every λ<sub>min</sub> is confirmed by inertia bisection in exact 60-digit arithmetic rather than by the float bisection that found it, and every positive-definiteness claim by an independent dense Cholesky sharing no code with the bisection.

## Hypotheses and notation

- Backend α: verified Cholesky at 40 digits, exact-product residual at 90 digits, plus the radius row-sums; the certified arch and pole evaluated at node spacing s·δ and the comb row recombined at stride s.
- The certified window is rh25's searched notch-free optimum at M = 16 (one window throughout rh26 §5).
- λ<sub>min</sub> is the computed smallest eigenvalue of the cut section; ρ is the certified (binned) radius; floor = λ<sub>min</sub> − ρ is the certified lower bound for the exact section.
- The Δ row is the regression reproducing rh25's own floor at n = 76; the four sub-lattice floors are those at Δ/2, Δ/4, Δ/8 and Δ/16.
- The depths 9, 4.5 and 2.25 on the finer rungs are the source's budget choice for the 40-digit Cholesky, not where positivity stops.

## Proof / evidence

Numerical certificate: each λ<sub>min</sub> is confirmed by inertia bisection in exact 60-digit arithmetic, and each positive-definiteness claim by an independent dense Cholesky sharing no code with the bisection. The source notes that the depths on the finer rungs are short because "the section size was capped so that the 40-digit Cholesky and the 90-digit residual stay inside this document's budget, which is O(n³) in each", and states that §4's ladder puts the M = 16 window's reach at 10.80, 6.66 and 6.61 on those meshes at R₀ = 600 and past 18 with the tail restored.

## Dependencies and related results

- rh25's backend α, rh24's binned radius, rh19's streaming comb, rh26 §1's gear-mass histogram.
- [rh26-one-sided-cut](rh26-one-sided-cut.md) — why a cut section that is positive definite certifies the exact section with no tail budget.
- Continued by rh27a, which certifies Δ/4, Δ/8 and Δ/16 at depth 18 ([rh27a-three-certificates-at-depth-18](../rh27a/rh27a-three-certificates-at-depth-18.md)).

## Notes


- The source uses five rows in (8); only four are sub-lattice floors, and the Δ row is stated as a regression. The heading of §5 is kept as the title with the count made explicit.
- The tabulated numbers are quoted exactly as the source writes them, with `λ_min` and `ρ` transliterated from the source's `<sub>` markup.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
