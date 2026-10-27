# 09 — Quantum placements

Addendum F asks which results of quantum and statistical physics address the gaps that remain, and in what form. It is a survey with a few exact identifications, not a proof of anything new about the zeros. Every item is tested against the Davenport–Heilbronn litmus of Corollary C.10: an item can close a gap only if it fails for the DH function, i.e. only if it consumes an Euler product, a positivity, or a self-adjointness that a sum of two $L$-functions does not have.

## Exact identifications

- [Lemma F.1 (The averaged accumulated phase factor is the period-two polygon)](summary/09-quantum-placements/01-lemma-f.1.md): the Wei et al. phase factor is $-\eta_2^{(M)}$.
- [Proposition F.2 (Free-energy density; latent drop σ)](summary/09-quantum-placements/03-proposition-f.2.md): the three scales of Definition 4.4 are free-energy densities in units of $\log N$, with generic level $1-\sigma$, zero level $1-2\sigma$, latent drop $\sigma$, coinciding only at $\sigma=\tfrac12$.
- [Proposition F.3 (Clock-register realisation)](summary/09-quantum-placements/04-proposition-f.3.md): a finite clock register realises the polygon.
- [Lemma F.5 (The archimedean window is the prime-free regime)](summary/09-quantum-placements/06-lemma-f.5.md): the Connes–Consani window $[2^{-1/2},2^{1/2}]$ is exactly the regime in which no prime enters the explicit formula. This is the wall of C.10 seen from the multiplicative side.
- [Lemma F.6 (Dirichlet characters inside the additive basis)](summary/09-quantum-placements/07-lemma-f.6.md): Gauss sums show the (M)-locus is a finite set inside the additive basis.
- [Lemma F.8 (Clock zeros)](summary/09-quantum-placements/08-lemma-f.8.md), [Corollary F.9 (Uniform depth and slow passage on the window)](summary/09-quantum-placements/09-corollary-f.9.md) and [Lemma F.10 (Landau–Gonek on the register)](summary/09-quantum-placements/02-lemma-f.10.md) are tractable consequences: clock zeros are displaced zeros of $1-N^{1-s}$; for $\varepsilon>13/194$, Bourgain gives uniform prefactor/depth/speed/Marty clauses; Landau–Gonek brings $\Lambda$ into the polygon.

## The open placement

- [Open item F.4 (A Lee–Yang property for the polygon)](summary/09-quantum-placements/05-open-item-f.4.md): is there a ferromagnetic spin system whose finite partition functions are $\eta_N^{(N^2)}$, or any reweighting confining every finite zero to a line? It passes the litmus. The boundary is sharp: plain partial sums have zeros in $\sigma>1$ (Montgomery) and cluster to the line without lying on it (Gonek–Ledoan); Bombieri–Hejhal show density statements are blind to a density-zero off-line set, so the property must be pointwise.

## Assessment

- [Remark F.11 (What Lemma F.10 shows, and the sign of Λ)](summary/09-quantum-placements/10-remark-f.11.md) and [Remark F.12 (Negative weights and Open item F.4)](summary/09-quantum-placements/11-remark-f.12.md) record the limits.
- [Remark F.13 (Assessment)](summary/09-quantum-placements/12-remark-f.13.md) is the paper’s own summary: exact identifications are done; everything else is placement. Nothing in Sections 1–14 or Addenda B–E depends on Addendum F.
- [Publication Addendum A — quantum dictionary](summary/09-quantum-placements/14-publication-addendum-a-dictionary.md) records the DQPT / Loschmidt / amplitude-estimation dictionary inside `publication.html`. It is explanatory, not a theorem.

**Status.** F.1, F.2, F.3, F.5, F.6, F.8, F.9 and F.10 are proved (some with numerical verification). F.4 is open. The GUE input for uniform slow passage at small $\varepsilon$ remains conjectural and is not used by any theorem.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/09-quantum-placements/TOC.md)
