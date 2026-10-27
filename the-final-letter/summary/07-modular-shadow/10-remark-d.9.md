# Remark D.9 (Rank one and rank two: the absent Hecke theory)

| Field | Value |
|---|---|
| Type | Remark |
| Status | Remark |
| Source | [publication.html Addendum D](../../geometric-dynamical-phase-transitions/publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | no separate proof block |

## Statement

The depth-one Euler sums of Definition 3.0 have an exact place in the lattice description of modular forms, and it locates the obstruction of Corollary C.10 a third time.

A modular form of weight \(k\) is, equivalently, a function \(F\) on lattices \(\Lambda\subset\mathbb{C}\), homogeneous of degree \(-k\): \(F(\lambda\Lambda)=\lambda^{-k}F(\Lambda)\) (Serre [\[21, Ch. VII\]](../../geometric-dynamical-phase-transitions/publication.html#ref-serre)). The basic example is the Eisenstein series \[
G_k(\Lambda)=\sum_{\omega\in\Lambda\setminus\{0\}}\omega^{-k},
\] which is the depth-one Euler sum of weight \(k\) summed over a rank-two lattice. Taking instead the rank-one lattice \(\Lambda=\mathbb{Z}\subset\mathbb{C}\) gives \[
G_k(\mathbb{Z})=\sum_{n\in\mathbb{Z}\setminus\{0\}}n^{-k}=\bigl(1+(-1)^k\bigr)\zeta(k)=2\zeta(k)\quad(k\text{ even}),
\] so \(\zeta(k)\) *is* the rank-one Eisenstein series, and \(H_x^{(k)}\) of Definition 3.0 is its one-sided truncation.

In this language the mean-zero filter is the sublattice operator \(\Lambda\mapsto G_k(\Lambda)-N\,G_k(N\Lambda)\). Homogeneity gives \(G_k(N\Lambda)=N^{-k}G_k(\Lambda)\), hence \[
G_k(\Lambda)-N\,G_k(N\Lambda)=\bigl(1-N^{1-k}\bigr)G_k(\Lambda),
\] which at \(\Lambda=\mathbb{Z}\) is twice the purification identity of Lemma 2.2 evaluated at \(s=k\). The elementary factor \(1-N^{1-s}\) that runs through the whole paper is therefore nothing but the degree \(-k\) homogeneity relation for the index-\(N\) sublattice. (Checked numerically at \(k=4,6\) and \(N=2,3,5\).)

The dichotomy is now visible as a count. A rank-one lattice has *exactly one* sublattice of index \(N\), namely \(N\mathbb{Z}\); the operator above is consequently the scalar \(1-N^{1-k}\) and carries no arithmetic. A rank-two lattice has \(\sigma_1(N)=\sum_{d\mid N}d\) sublattices of index \(N\) — \(3,4,7,6,12,28\) for \(N=2,3,4,5,6,12\) — and the sum of \(G_k\) over all of them is the Hecke operator \(T_N\), whose eigenvalue relations are precisely the Euler product. The framework of this paper has no Hecke theory available to it because rank one has no room for one: there is a single sublattice, so the multiplicative structure that distinguishes \(\zeta\) from the twist of Addendum C never arises. This is Remark C.11 and Corollary C.10 again, in lattice coordinates.

*Scope.* The correspondence above is between lattice-sum constructions, not an attachment of elliptic curves to the polygons, and no such attachment exists here. By Lemma C.4(ii) the Davenport–Heilbronn function is built from the two *odd* characters mod \(5\) — the coefficients \(b_\chi\) vanish on both even characters — hence from weight-one Eisenstein series, not from cusp forms; there is no associated newform, elliptic curve or period lattice. Nor do the period-polynomial relations of Gangl–Kaneko–Zagier [\[22\]](../../geometric-dynamical-phase-transitions/publication.html#ref-gkz) apply: those govern *double* zeta values of weight \(k\), whereas the depth-one sums here vanish identically in \(\mathcal{A}\) by Lemma D.2, and \(S_k(\mathrm{SL}_2(\mathbb{Z}))=0\) for every \(k<12\). Entering that circle of ideas requires depth two, and would in any case remain at integer weight, subject to Remark D.8.

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
