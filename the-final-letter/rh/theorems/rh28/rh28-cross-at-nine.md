# (a) The cross, at nine points — two new certified floors

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh28.html`](../../html/rh28.html) — §2 "(a) The cross, at nine points"

## Statement

> Nothing new is needed. rh27a's backend α takes the support and the mesh as parameters, and rh27b and this document supply two more of each.
>
> ```
> Δ′ = 0.06   n = 301, v = 18.00   λ_min = 4.8132×10⁻²   ρ = 7.44×10⁻¹¹   floor 4.7650×10⁻²   [15 s]
> Δ′ = 0.03   n = 601, v = 18.00   λ_min = 2.8347×10⁻²   ρ = 4.86×10⁻¹¹   floor 2.8063×10⁻²   [51 s]
> ```
>
> Both floors positive, both sections confirmed positive definite by an independent dense route in exact 60-digit arithmetic. The margins are wide — 6.5×10⁸ and 5.8×10⁸ against their own radii — … The certified set is now 9 points, five meshes at one support crossed by five supports at one mesh, and every support rh27c's §5 test used carries a floor.

## Hypotheses and notation

- Backend α unchanged from rh27a: verified Cholesky at 40 digits, exact-product residual at 90, rh24's binned radius, rh26's half-turn split, rh27a's certified ψ̃ table to r = 4800.
- The two supports Δ′ = 0.06 and 0.03 are the ones rh27c §5 searched but left uncertified.
- λ<sub>min</sub> is the computed smallest eigenvalue, ρ the certified radius, floor = λ<sub>min</sub> − ρ.
- The AT table at r = 4800 is 96,001 certified interval nodes and costs 56 seconds per support.

## Proof / evidence

Numerical certificate: both floors are positive and both sections are confirmed positive definite by an independent dense route in exact 60-digit arithmetic; the margins are 6.5×10⁸ and 5.8×10⁸ times their own radii. The source notes the wider margins are because these are short sections in nodes at a fine mesh, "and arithmetic is not what limits them".

## Dependencies and related results

- rh27a's parameterised backend α ([rh27a-three-certificates-at-depth-18](../rh27a/rh27a-three-certificates-at-depth-18.md)).
- rh27b's seven-point cross ([rh27b-three-certified-floors-cross](../rh27b/rh27b-three-certified-floors-cross.md)); the union is nine points.
- It puts rh27c §5's refutation of rh27b's power law on certified ground at every point it uses.

## Notes


- The source is careful about the value: "Nine is still measure zero against every support, every mesh and every depth."
- The margins 6.5×10⁸ and 5.8×10⁸ are quoted from the source's §2 text.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
