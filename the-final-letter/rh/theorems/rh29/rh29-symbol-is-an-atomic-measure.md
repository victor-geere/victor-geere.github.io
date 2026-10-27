# (i) Bochner, with the arrow filled in

**Kind:** Proposition
**Status:** PROVED (paper argument, under RH; checked at all five supports)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §3 "The measure, and three things that follow", item (i), lines 1453–1457 and statement box at lines 539–543

## Statement

> μ = ∑<sub>ρ</sub> ĥ(γ<sub>ρ</sub>)<sup>2</sup> δ<sub>γ<sub>ρ</sub>Δ′ mod 2π</sub>  on the circle,  T<sub>n</sub>[j][k] = μ̂(j−k).

and

> rh18 proved lattice ⇔ windows ⇔ Bochner ⇔ RH and could name the measure only as "the one Herglotz gives." It is this one. The total mass is the diagonal: μ(&#120general;) = 2∑ĥ(γ)<sup>2</sup> = E<sub>h</sub>(0), checked at all five supports.

## Hypotheses and notation

- γ<sub>ρ</sub> are the ordinates of the non-trivial zeros ρ; Δ′ is the mesh.
- ĥ(γ<sub>ρ</sub>)<sup>2</sup> are the weights, fixed by the window; the mesh fixes the positions γ<sub>ρ</sub>Δ′ mod 2π.
- μ̂ is the Fourier coefficient sequence of μ on the circle; T<sub>n</sub> is the Toeplitz section of the arc's row E<sub>h</sub>.
- The zero side is conditional on RH (see the source's "What is conditional and what is not" box).

## Proof / evidence

The source's evidence is the identity of §2 together with the verification across supports: "checked at all five supports", against the prime side at every node. Section 2 records the two-sided check agreeing to 1.38×10<sup>−7</sup> absolute at Δ′ = 0.48 on a row whose diagonal is 0.707, and to 3.37×10<sup>−5</sup> at the worst of the five supports.

## Dependencies and related results

- [rh29-explicit-formula-right-to-left](rh29-explicit-formula-right-to-left.md) — the identity this turns into a moment sequence.
- [rh29-row-cannot-leave-its-diagonal](rh29-row-cannot-leave-its-diagonal.md) and [rh29-lambda-min-tends-to-zero](rh29-lambda-min-tends-to-zero.md) — items (ii) and (iii), both read off this measure.
- Herglotz–Bochner and rh18's equivalence chain (lattice ⇔ windows ⇔ Bochner ⇔ RH) are cited, not reproved.

## Notes

- The total-mass symbol is written in the source as the malformed entity `&#120general;`; it is reproduced verbatim above rather than repaired.
- The measure is purely atomic (see item (iii)): countably many points, no absolutely continuous part.
- The window sets the weights, the mesh sets the positions — the source calls this separation "the whole content of §§4–6".
