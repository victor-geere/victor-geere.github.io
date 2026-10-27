# Theorem D.7 (No modular collapse for the twist)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum D](publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | yes |

## Statement

Let \(a^{\mathrm{DH}}\) be the sequence of Definition C.3, and let \(K=\mathbb{Q}(\xi)\). Then: (i) \(\xi\) has minimal polynomial \(x^4+2x^3-6x^2-2x+1\), so \(K=\mathbb{Q}\bigl(\sqrt{10+2\sqrt5}\bigr)=\mathbb{Q}(\zeta_{20})^{+}\) is the real quartic subfield of the twentieth cyclotomic field. In particular \(K\ne\mathbb{Q}(i,\sqrt5)\), and the rotation coefficient of Lemma C.4(ii) is \[
b=\tfrac12\bigl(1-i\xi\bigr)\in\mathbb{Q}(\zeta_{20}),\qquad [\mathbb{Q}(\zeta_{20}):\mathbb{Q}]=8 .
\] (ii) The collapsing term of Lemma D.3 is absent, because \(a^{\mathrm{DH}}_5=0\): the one residue class that reindexes carries zero weight. Hence \(F_{\mathcal{A}}[a^{\mathrm{DH}}](k)\) is a genuine combination of level-five finite polylogarithms \(\mathcal{L}_k(\zeta_5^{\,j})=\sum_{n<p}\zeta_5^{\,jn}n^{-k}\), with no depth-one Euler sum available. (iii) \(F_{\mathcal{A}}[a^{\mathrm{DH}}](k)\neq0\) in \(\mathcal{A}_K\) for \(1\le k\le8\). Over \(1824\) samples — all \(p<1500\) split in \(K\), all four conjugate choices of \(\mathfrak{p}\), all \(k\le8\) — exactly \(5\) values vanish, against \(5.65\) predicted by the random-incidence heuristic \(\sum_p 1/p\). The choice-free Galois trace is non-zero in \(455\) of \(456\) cases.

## Proof

\(i\) Eliminating \(\sqrt5\) from \(\xi(\sqrt5-1)+2=\sqrt{10-2\sqrt5}\) gives the quartic, whose root near \(0.284079\) is \(\xi\); the substitution \(y=\xi-\xi^{-1}\) reduces it to \(y^2+2y-4=0\), so \(y=-1-\sqrt5\) and \(\xi=\tfrac12\bigl(-1-\sqrt5+\sqrt{10+2\sqrt5}\bigr)\). Were \(\sqrt{10+2\sqrt5}\in\mathbb{Q}(i,\sqrt5)\), being real it would lie in the real subfield \(\mathbb{Q}(\sqrt5)\), forcing \(10+2\sqrt5\) to be a square there and its norm \(100-20=80\) to be a rational square, which it is not. The value of \(b\) is Lemma C.4(ii) with \(\operatorname{Im}b=-\xi/2\). (ii) is Lemma D.3 with \(q=5\) and \(a_5=0\). (iii) is the computation described.
