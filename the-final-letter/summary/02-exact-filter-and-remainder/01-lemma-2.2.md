# Lemma 2.2 (Purification identity, integer filter)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §2](../../geometric-dynamical-phase-transitions/publication.html#sec2) · 2. Preliminaries |
| Proof in source | yes |

## Statement

For every integer \(N\ge 2\) the coefficients \[
c_m^{(N)}=\begin{cases}1 & N\nmid m,\\1-N & N\mid m\end{cases}
\] satisfy \[
\sum_{m=1}^\infty c_m^{(N)}m^{-s}=(1-N^{1-s})\zeta(s),\qquad\operatorname{Re}s>1,
\] with meromorphic continuation to the whole plane. The elementary factor \(1-N^{1-s}\) has zeros only on the line \(\operatorname{Re}s=1\).

## Proof

Write the Dirichlet series for \(\zeta(s)\) and subtract the terms with \(N\mid m\), which produces the factor \(N^{1-s}\zeta(s)\). Equivalently, \(c_m^{(N)}\) is the convolution of the constant sequence \(1\) with the finite geometric sum over the non-trivial \(N\)-th roots of unity.
