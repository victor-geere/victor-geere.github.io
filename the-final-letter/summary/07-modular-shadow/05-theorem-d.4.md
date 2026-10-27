# Theorem D.4 (The modular polygon of the mean-zero filter)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum D](../../geometric-dynamical-phase-transitions/publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | yes |

## Statement

Let \(N\ge2\), let \(k\ge1\) be an integer, and let \(p\nmid N\) with \((p-1)\nmid k\). Then, exactly in \(\mathbb{F}_p\), \[
\sum_{n=1}^{p-1}c_n^{(N)}\,n^{-k}\;=\;-\,N^{1-k}\,H^{(k)}_{\lfloor (p-1)/N\rfloor}.
\] Equivalently, in \(\mathcal{A}\), the modular polygon of the mean-zero filter of period \(N\) is \(-N^{1-k}\) times the depth-one Euler sum *truncated at \(p/N\)*.

## Proof

Write \(c_n^{(N)}=1-N\cdot\mathbf{1}_{N\mid n}\). The constant part contributes \(\sum_{n<p}n^{-k}=0\) by Lemma D.2. The remaining part is \(-N\) times the \(r\equiv0\) term of Lemma D.3 with \(q=N\), namely \(-N\cdot N^{-k}H^{(k)}_{\lfloor(p-1)/N\rfloor}\). Verified with no mismatch for \(N\in\{2,3,5,7\}\), \(k\in\{1,2,3\}\) and every prime \(p<400\).
