# (b) A ceiling with the mesh in it (the Fejér ceiling)

**Kind:** Proposition
**Status:** PROVED (paper argument, one line of linear algebra; verified to hold at every support); VERIFIED (numerical ratios)
**Area:** rh-html
**Source:** [`rh28.html`](../../html/rh28.html) — §3 "(b) A ceiling with the mesh in it", eqs. (1)–(2)

## Statement

> rh27c's ceiling ends in λ<sub>min</sub>(T<sub>n</sub>) ≤ E<sub>h</sub>(0), which is true for the elementary reason that the smallest eigenvalue of a symmetric matrix is at most any diagonal entry. It is also the worst test vector available: a coordinate vector, which sees none of the lattice. Any other unit vector does better, and one of them is free.
>
> u<sub>j</sub> = e<sup>ijθ</sup>/√n  ⟹  u*T<sub>n</sub>u = Σ<sub>|k|<n</sub> (1 − |k|/n) E<sub>h</sub>(kΔ′) e<sup>ikθ</sup> = F<sub>n</sub>(θ),
>
> the Fejér mean of the row, because the number of (i, j) with i − j = k in an n × n block is n − |k|. So
>
> λ<sub>min</sub>(T<sub>n</sub>)  ≤  min<sub>θ∈[0,π]</sub> F<sub>n</sub>(θ),
>
> computable from exactly the row the arc already builds, at the cost of one scan over θ. That is the bound rh27c asked for, and the whole of its content is that the section is Toeplitz.
>
> The diagonal exceeds λ<sub>min</sub> by 24.5, 8.7, 3.5, 3.7, 3.3 at the five supports; the Fejér minimum by 2.75, 1.53, 1.12, 1.14, 1.13. So (2) closes 93% of the gap at the worst support and 95% at the best.

## Hypotheses and notation

- T is the Toeplitz section T[i][j] = E<sub>h</sub>((i−j)Δ′) of order n; the lattice step is Δ′.
- u<sub>j</sub> = e<sup>ijθ</sup>/√n is a unit vector; u*T<sub>n</sub>u is the Fejér mean F<sub>n</sub>(θ) = Σ<sub>|k|<n</sub>(1 − |k|/n)E<sub>h</sub>(kΔ′)e<sup>ikθ</sup>.
- The bound is min<sub>θ∈[0,π]</sub> F<sub>n</sub>(θ), computed at the cost of one scan over θ.
- At Δ′ = 0.48 the section has only 39 nodes, so the ratio is 2.75; the bound is inside 1.14× from n = 151 on.

## Proof / evidence

Paper argument: a plane wave is a unit vector, so its Rayleigh quotient is an upper bound on λ<sub>min</sub>, and the count of (i, j) with i − j = k in an n × n block is n − |k|, giving exactly the Fejér mean. The check suite reports "the Fejér bound checked to hold at every support". The ratios (2.75, 1.53, 1.12, 1.14, 1.13 against the diagonal's 24.5, 8.7, 3.5, 3.7, 3.3) are measured.

## Dependencies and related results

- [rh27c-family-free-ceiling](../rh27c/rh27c-family-free-ceiling.md) — the ceiling whose diagonal step this replaces.
- Toeplitz–Fejér is cited, not reproved.

## Notes

- The source is explicit that this is still only an upper bound: "It is still an upper bound … It does not certify anything and it does not enter any floor."
- The source describes where the bound is not tight rather than averaging it away: "At Δ′ = 0.48 the ratio is 2.75, which is not close."
