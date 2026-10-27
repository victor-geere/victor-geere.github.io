# The scale-free verdict reverses; the narrow window wins

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh27b.html`](../../html/rh27b.html) — §3 "Comparing eigenvalues across supports, honestly" and "The verdict, and it goes the other way"

## Statement

> λ<sub>min</sub> is homogeneous in the window's normalisation, so its raw value at two different supports is not a comparison of anything. The scale to divide by is C<sub>h</sub>(0), the kernel's own diagonal — and it can be taken out exactly, because the *window family* is scale-free: C<sub>h</sub>(0)/Δ′ depends on θ alone, and the same shape at three widths gives the same number to eleven figures. At θ = 0, where the generator is the triangle, that number is 2/3 exactly. So λ<sub>min</sub>/C<sub>h</sub>(0) is the quantity to compare, and it is a genuine comparison.
>
> λ<sub>min</sub>/C<sub>h</sub>(0) is 1.069 at Δ′ = 0.12, 0.360 at 0.24 and 0.104 at 0.48 — a factor 10.3 in favour of the narrow window. rh21's conclusion was that Δ = 0.24 was a reasonable stopping point on the way *up* in support; nothing in rh21 argued that going *down* was bad, and it turns out that going down is where the eigenvalue is.

## Hypotheses and notation

- λ<sub>min</sub> is homogeneous in the window's normalisation; C<sub>h</sub>(0) = ‖h‖² is the kernel's own diagonal, C<sub>h</sub> = h ⋆ h.
- The window family is scale-free: C<sub>h</sub>(0)/Δ′ is a function of the shape parameter θ = cδ alone, constant to eleven figures across a factor of four in Δ′; exactly 2/3 at θ = 0 (the triangle generator).
- The three supports are Δ′ = 0.12, 0.24, 0.48 at M = 16; the values 1.069, 0.360, 0.104 are the scale-free eigenvalues at the best window of each support.

## Proof / evidence

Numerical: the exactness of the normalisation is measured to eleven figures (2/3 exactly at θ = 0), and the three scale-free values are the searched optima. The source states this is "the only honest comparison" and that the arc's Δ = 0.24 convention sits "on the wrong side of the optimum tested here, in the direction nobody looked".

## Dependencies and related results

- [rh27b-third-term-of-the-ledger](rh27b-third-term-of-the-ledger.md) — the omitted term that contributes to the reversal.
- [rh27b-support-beats-shape](rh27b-support-beats-shape.md) — the raw search the scale-free values come from.
- rh27c later shows the growth of λ<sub>min</sub>/C<sub>h</sub>(0) with narrowing support is logarithmic, not a power law ([rh27c-power-law-refuted](../rh27c/rh27c-power-law-refuted.md)).

## Notes


- "Scale-free" here is the arc's own term for λ<sub>min</sub>/C<sub>h</sub>(0); it is legitimate only because of the exactness of C<sub>h</sub>(0)/Δ′.
- The values 1.069, 0.360 and 0.104 are the searched optima (not the triangle row); the triangle row's own scale-free values are 0.9612, 0.2913, 0.0897.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
