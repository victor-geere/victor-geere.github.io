# Lemma D.2 (Vanishing of the untwisted depth-one sum)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum D](../../geometric-dynamical-phase-transitions/publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | yes |

## Statement

For every fixed integer \(k\ge1\), \[
\sum_{n=1}^{p-1}n^{-k}\equiv 0\pmod p\qquad\text{whenever }(p-1)\nmid k,
\] hence \(H_{\mathcal{A}}^{(k)}=0\) in \(\mathcal{A}\). Only finitely many \(p\) are excluded, namely those with \(p\le k+1\).

## Proof

As \(n\) runs over \(\mathbb{F}_p^\times\) so does \(n^{-1}\), so the sum is \(\sum_{n=1}^{p-1}n^{j}\) with \(j\equiv-k\pmod{p-1}\); this is \(-1\) if \((p-1)\mid j\) and \(0\) otherwise. Since \(k\ge1\) is fixed, \((p-1)\mid k\) forces \(p\le k+1\).
