# Theorem E.7 (Finite-data argument principle)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved under Rouché hypothesis (E.1) |
| Source | [publication.html Addendum E](../../geometric-dynamical-phase-transitions/publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

> **Editorial note.** The Rouché condition (E.1) is an explicit hypothesis on the contour and $N$; the theorem computes the zero count from the two finite Euler sums.

## Statement

Let \(\sigma_0\in(\tfrac12,1)\) and let \(\Gamma\) be a rectifiable closed curve contained in the strip \(\{\sigma_0\le\sigma\le 1-\sigma_1\}\) for some \(\sigma_1\in(0,\tfrac12)\), null-homotopic in \(\mathbb{C}\setminus\{0\}\), with \(1\notin\Gamma\), avoiding the zeros of \(\zeta\). Put \[
T_\Gamma=\max_{s\in\Gamma}\lvert s\rvert,\qquad
m_\Gamma(N)=\min_{s\in\Gamma}\bigl\lvert 1-N^{1-s}\bigr\rvert\,\lvert\zeta(s)\rvert>0 ,
\] and let \(C=C(\sigma_1)\) be the implied constant of Theorem 4.3. If \[
C\,(1+T_\Gamma)\,N^{1-2\sigma_0}\;<\;m_\Gamma(N),
\tag{E.1}
\] then \(\eta_N^{(N^2)}\) has no zeros on \(\Gamma\), and \[
\operatorname{hol}\bigl(\eta_N^{(N^2)},\Gamma\bigr)
=\operatorname{hol}\bigl(1-N^{1-s},\Gamma\bigr)+Z_\zeta(\Gamma)+n(\Gamma,0).
\] Since the zeros of \(1-N^{1-s}\) are the points \(1+2\pi i k/\log N\), \(k\in\mathbb{Z}\), all lying on \(\sigma=1\) (Lemma 2.2), the first term is explicitly computable, and hence so is \[
Z_\zeta(\Gamma)=\operatorname{hol}\bigl(\eta_N^{(N^2)},\Gamma\bigr)-\operatorname{hol}\bigl(1-N^{1-s},\Gamma\bigr)-n(\Gamma,0),
\] a quantity determined entirely by the two depth-one finite Euler sums \(H^{(s)}_{N^2}\) and \(H^{(s)}_{N}\) of Definition 3.0 evaluated along \(\Gamma\).

## Proof

Write \(F(s)=(1-N^{1-s})\zeta(s)\) and \(E(s)=\eta_N^{(N^2)}(s)-F(s)\). By Theorem 4.3, \(\lvert E(s)\rvert\le C(1+\lvert s\rvert)N^{1-2\sigma}\le C(1+T_\Gamma)N^{1-2\sigma_0}\) on \(\Gamma\), using \(\sigma\ge\sigma_0\) and \(N\ge2\). Hypothesis (E.1) gives \(\lvert E\rvert<\lvert F\rvert\) on \(\Gamma\), so by Rouché's theorem (Ahlfors [\[4, Ch. 4\]](../../geometric-dynamical-phase-transitions/publication.html#ref-ahlfors)) \(\eta_N^{(N^2)}\) and \(F\) have the same number of zeros inside \(\Gamma\), and neither vanishes on \(\Gamma\). Both are holomorphic there — the pole of \(\zeta\) at \(s=1\) is cancelled by the zero of the prefactor, and \(\eta_N^{(N^2)}\) is entire — so \(P=0\) in Theorem E.4, and applying that theorem to \(\eta_N^{(N^2)}\) and to \(F\) in turn, and Lemma E.2(iii) to split \(Z_F=Z_\zeta+Z_{1-N^{1-s}}\), gives the displayed identity. Note the asymmetry in \(\sigma_0\) and \(\sigma_1\): the size of the error is governed by the lower bound \(\sigma\ge\sigma_0\), while the mere availability of Theorem 4.3 requires \(\Gamma\) to lie in a fixed closed substrip, which is what \(\sigma_1\) provides.
