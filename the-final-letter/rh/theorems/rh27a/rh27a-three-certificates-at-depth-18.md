# The descent, certified at depth 18 (three certificates)

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27a.html`](../../html/rh27a.html) — §4 "(c) The descent, certified at depth 18", eq. (6)

## Statement

> Backend α, unchanged, with the sum run to J = 96,000 instead of 12,000 and the Cholesky issued per block:
>
> ```
> Δ/4   n = 301,  v = 18.00   λ_min = 1.2097×10⁻³   ρ = 3.98×10⁻¹⁰   floor 1.1976×10⁻³   [8 s]
> Δ/8   n = 601,  v = 18.00   λ_min = 5.9193×10⁻⁵   ρ = 7.89×10⁻¹⁰   floor 5.8600×10⁻⁵   [457 s]
> Δ/16  n = 1201, v = 18.00   λ_min = 4.7799×10⁻⁹   ρ = 1.57×10⁻⁹    floor 3.1594×10⁻⁹   [1123 s]
> ```
>
> Three certificates, all at depth 18: Δ/4 at n = 301, floor 1.1976×10⁻³; Δ/8 at n = 601, floor 5.8600×10⁻⁵; Δ/16 at n = 1201, floor 3.1594×10⁻⁹. … Adding Δ and Δ/2, already at 18, the certified set is five meshes at one depth.

## Hypotheses and notation

- Backend α unchanged from rh19 and rh25, with the trapezoid sum run to J = 96,000 instead of 12,000 and the Cholesky issued per block (rh27a §3).
- One window throughout: rh25's searched notch-free optimum at M = 16.
- λ<sub>min</sub> is the computed smallest eigenvalue, ρ the certified radius, floor = λ<sub>min</sub> − ρ the certified lower bound for the exact section.
- Depth v = 18 is the horizon rh19 fixed; the sections are at n = 301, 601 and 1201.

## Proof / evidence

Numerical certificate: the same backend α as rh26 §5, at the longer cut, issued per block. The source states the run times (8 s, 457 s, 1123 s) and that rh26's ladder had these same meshes stopping at 10.80, 6.66 and 6.61 with the cut at 600 "not for want of budget, but because the section stopped being positive there".

## Dependencies and related results

- [rh27a-bigger-cut-same-theorem](rh27a-bigger-cut-same-theorem.md) — the longer sum is certified at once for every J.
- [rh27a-parity-split-spent](rh27a-parity-split-spent.md) — what makes the 1201-node section affordable.
- Continues [rh26-four-sub-lattice-floors](../rh26/rh26-four-sub-lattice-floors.md); the certified set is five meshes at one depth, still a column at one support.

## Notes


- The source is careful that the certified set is still a column: "five points against every support and every mesh and every depth is measure zero, exactly as before."
- The floor values are quoted exactly; note the source writes the Δ/16 λ<sub>min</sub> as 4.7799×10⁻⁹ and its floor as 3.1594×10⁻⁹.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
