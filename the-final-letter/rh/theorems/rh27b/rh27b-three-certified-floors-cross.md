# (c) The cross — three certified floors at three supports

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27b.html`](../../html/rh27b.html) — §4 "(c) The certified set stops being a column"

## Statement

> Backend α unchanged: a verified Cholesky of the shifted section in 40-digit arithmetic, an exact-product residual bound at 90 digits, and rh24's binned radius from the gear-mass histogram; the archimedean and pole terms carried as intervals through the same certified ψ̃ table rh27a built to r = 4800; rh26's half-turn split so the factorisation is issued per block at n³/4.
>
> ```
> Δ′ = 0.12   θ = 0.06   n = 151, v = 18.00   λ_min = 8.5459×10⁻²   ρ = 8.11×10⁻¹¹   floor 8.4604×10⁻²   [155 s]
> Δ′ = 0.24   θ = 0.96   n = 76,  v = 18.00   λ_min = 4.9824×10⁻²   ρ = 1.06×10⁻¹⁰   floor 4.9326×10⁻²   [136 s]
> Δ′ = 0.48   θ = 0.96   n = 39,  v = 18.24   λ_min = 2.8828×10⁻²   ρ = 1.88×10⁻¹⁰   floor 2.8539×10⁻²   [109 s]
> ```
>
> The depth is 18 exactly at Δ′ = 0.12 and 0.24 and 18.24 at 0.48, where a lattice of step 0.48 has no node at 18 and the section is carried one node further rather than one node short. All three positive, all three confirmed positive definite in exact 60-digit arithmetic by an independent dense route, and all three reproducing the float λ<sub>min</sub> that chose the shift under 60-digit inertia bisection.
>
> The certified set is now 7 points — five meshes at one support and three supports at one mesh, meeting at (0.24, Δ).

## Hypotheses and notation

- Backend α with rh27a's two parameters (the cut and the block split) left where rh27a left them.
- λ<sub>min</sub> is the computed smallest eigenvalue, ρ the certified radius, floor = λ<sub>min</sub> − ρ.
- The four θ = cδ shapes at M = 16; the best of each support is the one certified.
- The certificate at Δ′ = 0.48 is carried to v = 18.24 because the lattice of step 0.48 has no node at 18.

## Proof / evidence

Numerical certificate: verified Cholesky at 40 digits, exact-product residual at 90 digits, binned radius, intervals through rh27a's certified ψ̃ table; each certificate confirmed positive definite in exact 60-digit arithmetic by an independent dense route and reproducing the float λ<sub>min</sub> under 60-digit inertia bisection. Margins are 1.1×10⁹, 4.7×10⁸, 1.5×10⁸ times their own radii.

## Dependencies and related results

- rh27a's parameterised backend α ([rh27a-parity-split-spent](../rh27a/rh27a-parity-split-spent.md), [rh27a-three-certificates-at-depth-18](../rh27a/rh27a-three-certificates-at-depth-18.md)).
- rh26's five-mesh column; the union is the cross of 7 points.
- Extended to 9 points by rh28 ([rh28-cross-at-nine](../rh28/rh28-cross-at-nine.md)).

## Notes


- The source is explicit that the certificates are shallow in nodes (151, 76, 39) and "should not be read as though they were" comparable to rh27a's 1201-node certificate.
- The numbers are quoted exactly from the source's certificate box.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
