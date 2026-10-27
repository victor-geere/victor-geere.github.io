# Lemma 6.3 (Local diagonal)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §6](publication.html#sec6) · 6. Continuous-radius interpolation |
| Proof in source | yes |

## Statement

On the packet \(I_k=[(k-1)R,(k+1)R]\), with \(u=m/R-k\) and local mass \(M_k=\sum_{m\in I_k}\lvert c_m(R)\rvert m^{-1/2}\), \[
\partial_R c_m=-\varphi(u)+(k+u)\varphi'(u),
\] and the diagonal \[
D_k=\sum_{m\in I_k}c_m(R)\,(\partial_R c_m(R))\,m^{-1}
\] satisfies \[
D_k=-\int_{-1}^{1}\frac{\varphi(u)}{k+u}\,du+R\int_{-1}^{1}\frac{\varphi(u)^2}{k+u}\,du+R_{\mathrm{EM}}^{(k)}.
\] The \(\varphi'\) term integrates by parts to zero by compact support of \(\varphi\). Apostol’s remainder [\[12\]](publication.html#ref-apostol) is \(R_{\mathrm{EM}}^{(k)}=\int\overline{B}_1 f_k'\) with \(\lvert\overline{B}_1\rvert\le\tfrac12\). Summing in \(k\) gives \[
\sum_{k=1}^R D_k=R\Bigl(\int\varphi^2\Bigr)\log R+O_\varphi(R)+\sum_k R_{\mathrm{EM}}^{(k)},
\] which is not a multiple of \(R^{-1}\rho^2\). The evaluation \(\int(1-R\varphi)(-\varphi)\,du=-\tfrac12\) is false (that integral equals \(-1+R\int\varphi^2\)).

## Proof

Substitute the expressions for \(c_m\) and \(\partial_R c_m\), change variables, and integrate the \(\varphi'\) term by parts. The harmonic sum \(\sum_{k\le R}k^{-1}=\log R+O(1)\) produces the displayed main term. No identification of \(\sum_k\lvert\eta^{(k)}\rvert^2\) with \(\rho^2\) is claimed.
