# (L) — lattice

**Kind:** Proposition
**Status:** OPEN (equivalent to the Riemann Hypothesis by Weil's criterion, cited not reproven — rh15's P3)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §2 "The functional, and the identity", theorem box "The three faces"

## Statement

> For every Δ &gt; 0 and every n, the section [E<sub>Δ</sub>((j−k)Δ)]<sub>j,k&lt;n</sub> is positive semidefinite.

## Hypotheses and notation

- E<sub>Δ</sub> is the arc's kernel (rh15 eq. (1)): 𝒲(f) = ∫ f(v)·2cosh(v/2) dv + (1/π)∫₀^∞ f̂(r) ψ̃(r) dr − Σ<sub>n</sub> Λ(n) n<sup>−1/2</sup> [f(log n) + f(−log n)], with ψ̃(r) = Re ψ(¼ + ir/2) − ln π.
- Δ &gt; 0 is the mesh; n is the section size; the section is the finite Toeplitz matrix [E<sub>Δ</sub>((j−k)Δ)]<sub>j,k&lt;n</sub>.
- This is the first of "three statements, each quantified over an infinite family".

## Proof / evidence

Not proved here. The source states each of the three faces is equivalent to the Riemann Hypothesis, "by Weil's criterion applied to the subclass C<sub>c</sub><sup>∞</sup> ⊂ 𝒜 (cited, not reproven — rh15's P3)", and closes with "what remains is (L) itself — all meshes, all depths: the hypothesis, now the only link in the chain". The round's actual theorem is the equivalence [T — P2, closed](rh18-t-p2-closed.md).

## Dependencies and related results

- Equivalences: [(W) — windows](rh18-face-w-windows.md), [(Bo) — Bochner](rh18-face-bo-bochner.md), and [T — P2, closed](rh18-t-p2-closed.md).
- rh17's [T1](../rh17/rh17-t1-certified-sections.md)–[T3](../rh17/rh17-t3-the-equation.md) certify three finite sections of the diagonal family, i.e. three instances, not (L).
- Cited: A. Weil, *Sur les "formules explicites" de la théorie des nombres premiers* (1952).

## Notes

- Harvested because the source labels it inside a theorem box as one of the three faces; it is an open statement, and the Status says so.
- The source's own framing: "What closing P2 does not do: prove (L), the lattice statement itself. That is RH, by the very equivalence proven here."
- rh19 and rh20 add rungs of (L) (certified finite sections) without proving (L).
