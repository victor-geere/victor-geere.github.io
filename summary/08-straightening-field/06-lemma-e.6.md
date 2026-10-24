# Lemma E.6 (The normalised polygon has closure vector \(s\))

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum E](publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

## Statement

Suppose \(\eta_N^{(M)}(s)\ne0\) and \(s\ne0\), and set \[
\widehat\Pi_N^{(M)}(s)=\mathsf{R}_{\eta}^{-1}\,\Pi_N^{(M)}(s)
\qquad\text{where }\mathsf{R}_\eta=\mathsf{R}_{\eta_N^{(M)}}(s).
\] Then \(\widehat\Pi\) is the image of \(\Pi\) under a single similitude — a rotation by \(-\psi_\eta(s)\) followed by a dilation by \(\lvert s\rvert/\lvert\eta\rvert\) — and its terminal vertex is exactly \(s\), for every \(N\), \(M\) and every admissible \(s\). Its \(m\)-th edge is \[
\widehat e_m=\frac{s}{\eta_N^{(M)}(s)}\,c_m^{(N)}m^{-s},
\qquad
\lvert\widehat e_m\rvert=\frac{\lvert s\rvert}{\lvert\eta_N^{(M)}(s)\rvert}\,\lvert c_m^{(N)}\rvert\,m^{-\sigma},
\] so the edge *directions* are those of \(\Pi\) rigidly rotated, and the edge lengths are those of \(\Pi\) uniformly scaled by \(\lvert s\rvert/\lvert\eta\rvert\).

## Proof

\(\mathsf{R}_\eta^{-1}\) is multiplication by the constant \(s/\eta_N^{(M)}(s)\), which is independent of \(m\); apply it to each vertex. The terminal vertex is \(\mathsf{R}_\eta^{-1}\eta=s\) by Definition E.1.
