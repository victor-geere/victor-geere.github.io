# Lemma F.6 (Dirichlet characters inside the additive basis)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum F](publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Let \(\chi\) be a primitive character mod \(q\) with Gauss sum \(\tau(\chi)=\sum_{a\bmod q}\chi(a)e(a/q)\). Then for every \(n\), \[
\chi(n)=\frac{1}{\tau(\overline\chi)}\sum_{a\bmod q}\overline\chi(a)\,e(an/q),
\qquad\text{hence}\qquad
H_x^{(s)}[\chi]=\frac{1}{\tau(\overline\chi)}\sum_{a\bmod q}\overline\chi(a)\,H_x^{(s)}\bigl[e(a\,\cdot/q)\bigr],
\] so every Dirichlet \(L\)-function, and every twisted pair of Definition C.5 built from one, is a \(\mathbb{C}\)-combination of the level-\(q\) depth-one Euler sums of Definition C.1 — the same space in which Lemma C.2 places the polygon and the Davenport–Heilbronn twist. Hypothesis (M) is the condition that the coefficient vector \((a_1,\dots,a_q)\) lies on the finite set of completely multiplicative vectors, the orbit of the characters; it is a condition on a point of the space, not on the basis.

## Proof

The first identity is the standard Gauss-sum expansion of a primitive character (Montgomery–Vaughan \[7, §9.2\]); substituting it termwise into \(\sum_{n\le x}\chi(n)n^{-s}\) gives the second. Saias–Weingartner (Theorem C.12) identifies the (M)-locus inside the periodic sequences as \(P(s)L(s,\chi)\).
