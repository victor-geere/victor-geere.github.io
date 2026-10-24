# (a) The π rotation splits the section

**Kind:** Proposition
**Status:** CITED (literature, Cantoni–Butler block-diagonalisation); VERIFIED (numerical, |JTJ − T| = 0 exactly over all 45 sections)
**Area:** rh-html
**Source:** [`rh26.html`](../../html/rh26.html) — §2 "(a) The π rotation splits the section", eqs. (1)–(2)

## Statement

> Turn the construction half a turn. The kernel row is a function of the separation alone and E<sub>h</sub>(−v) = E<sub>h</sub>(v), so the section
>
> T<sub>h</sub>[p][q] = E<sub>h</sub>((p − q)h),   p, q = 0 … n−1
>
> is symmetric *and* persymmetric: with J the exchange matrix — the half-turn, p ↦ n−1−p — one has JT<sub>h</sub>J = T<sub>h</sub>. That is measured, not assumed: over all 45 sections in this document the largest entry of JTJ − T is zero, exactly, in floating point. A centrosymmetric matrix commutes with J, so it is block-diagonal in J's eigenbasis, and the two blocks are the +1 and −1 eigenspaces: vectors symmetric about the centre and vectors antisymmetric about it. Cantoni–Butler makes this explicit. Writing P for the top-left quarter and Q for the top-right quarter reversed, the odd block is P − Q and the even block is P + Q, bordered when n is odd by √2 times the centre column. Then
>
> λ<sub>min</sub>(T<sub>h</sub>) = min( λ<sub>min</sub>(P + Q), λ<sub>min</sub>(P − Q) ),
>
> reproduced here to 5×10⁻⁹ relative at every section size and every window. The two halves are the cosine and sine channels: a symmetric u has a real cosine transform on the lattice and an antisymmetric one a pure sine transform, so (2) is the section's own version of the reflection v ↦ −v that the functional equation puts on the critical line.

## Hypotheses and notation

- E<sub>h</sub> is even: E<sub>h</sub>(−v) = E<sub>h</sub>(v).
- T<sub>h</sub> is the section with entries T<sub>h</sub>[p][q] = E<sub>h</sub>((p − q)h), p, q = 0 … n−1, lattice step h.
- J is the exchange (half-turn) matrix, p ↦ n−1−p, so that (Jv)<sub>p</sub> = v<sub>n−1−p</sub>.
- P is the top-left quarter of T<sub>h</sub>; Q is the top-right quarter reversed; the even block is P + Q and the odd block is P − Q, bordered when n is odd by √2 times the centre column.
- "Reproduced to 5×10⁻⁹ relative" is the source's measurement of (2) against the whole section.

## Proof / evidence

The block-diagonalisation is Cantoni–Butler's, cited and not reproved; the source says so in §7's references ("Cantoni and Butler's block-diagonalisation is cited, not reproved"). What the source adds is a measurement: JT<sub>h</sub>J = T<sub>h</sub> holds exactly, in floating point, at all 45 sections, and (2) is reproduced to 5×10⁻⁹ relative at every section size and every window. The source also records the cost: the blocks are Toeplitz-plus-Hankel, not Toeplitz, so the O(n²) Levinson/Durbin recursion does not apply to them; the dense route gains 2(n/2)³ = n³/4, measured at n = 76 as 3.8 ms whole section against 1.0 ms as two blocks, 3.8×.

## Dependencies and related results

- Cantoni–Butler block-diagonalisation of a centrosymmetric matrix — cited, not reproved.
- The evenness E<sub>h</sub>(−v) = E<sub>h</sub>(v) is the source's starting point for the π rotation.
- Used by rh27a §3, where the split is spent on the certificates (see [rh27a-parity-split-spent](../rh27a/rh27a-parity-split-spent.md)).

## Notes

- The source is explicit that "the split is a factor, not a reduction": it does not let either channel be certified alone (see [rh26-which-half-binds](rh26-which-half-binds.md)).
- This file harvests the block-diagonalisation statement as the source states it; the figure's caption repeats the same numbers (λ<sub>min</sub> = 1.515×10⁻⁵ even and 1.518×10⁻⁵ odd at the 25-node section of Figure 1).
