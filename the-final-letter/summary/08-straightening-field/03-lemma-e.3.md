# Lemma E.3 (The straightening potential and its branch points)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum E](../../geometric-dynamical-phase-transitions/publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

## Statement

On any simply connected \(U\subseteq D\setminus(\{0\}\cup f^{-1}\{0,\infty\})\) the function \[
g_f(s)=\log f(s)-\log s
\] has a single-valued holomorphic branch, unique up to \(2\pi i\mathbb{Z}\); its real part is \(\log\varrho\) and its imaginary part is a continuous determination of the straightening angle \(\psi_f\). Its derivative \[
g_f'(s)=\frac{f'(s)}{f(s)}-\frac1s
\] is meromorphic on \(D\) with simple poles only, of residue \(+m\) at a zero of \(f\) of multiplicity \(m\), residue \(-m\) at a pole of order \(m\), and residue \(-1\) at \(s=0\). Consequently the branch points of \(g_f\) — the obstructions to a globally continuous choice of ray family — are exactly the zeros of \(f\), together with the poles of \(f\) and the point \(0\).

## Proof

Standard: \(f(s)/s\) is holomorphic and nonvanishing on \(U\), so it admits a holomorphic logarithm there because \(U\) is simply connected (Ahlfors [\[4, Ch. 4\]](../../geometric-dynamical-phase-transitions/publication.html#ref-ahlfors)). The residue statement is the logarithmic-derivative computation, applied to \(f\) and to \(\mathrm{id}\) separately.
