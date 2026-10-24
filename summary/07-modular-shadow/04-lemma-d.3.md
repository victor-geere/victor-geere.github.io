# Lemma D.3 (Only the zero class reindexes)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum D](publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | yes |

## Statement

Let \(a\) be \(q\)-periodic and \(p\nmid q\). Then \[
\sum_{n=1}^{p-1}a_n n^{-k}
= a_q\,q^{-k}\,H^{(k)}_{\lfloor (p-1)/q\rfloor}
\;+\;\sum_{r=1}^{q-1}a_r\!\!\sum_{\substack{n<p\\ n\equiv r\ (q)}}\!\! n^{-k}
\qquad\text{in }\mathbb{F}_p,
\] where \(H_M^{(k)}=\sum_{j\le M}j^{-k}\) is the depth-one Euler sum of Definition 3.0 at integer weight. The first term is the only one that reduces to a depth-one Euler sum: the substitution \(n=qj\) is available precisely on the class \(n\equiv0\), and on no other.

## Proof

Split the range by residue class mod \(q\). On the class \(n\equiv 0\) the integers below \(p\) divisible by \(q\) are exactly \(qj\) with \(1\le j\le\lfloor(p-1)/q\rfloor\), and \((qj)^{-k}=q^{-k}j^{-k}\). On a class \(n\equiv r\not\equiv0\) the terms are \((qj+r)^{-k}\), which does not factor. Verified in \(780\) cases, \(q\in\{2,3,5,6,7\}\), \(k\le3\), \(p<300\), with no exception.
