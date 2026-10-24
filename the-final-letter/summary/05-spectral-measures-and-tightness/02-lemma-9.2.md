# Lemma 9.2 (Zeros of \(\eta\) per unit height)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §9](../../geometric-dynamical-phase-transitions/publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

For every integer \(N\ge 2\) and every \(T\in\mathbb{R}\), the number of zeros of \(\eta_N^{(N^2)}\) in the rectangle \(\{-1\le\sigma\le 2,\ \lvert t-T\rvert\le 3/2\}\) is at most \(20\log N+2\).

## Proof

\(\eta\) is entire. At \(z_0=3+iT\), \[
\bigl\lvert\eta_N^{(N^2)}(z_0)\bigr\rvert\ge 1-\sum_{m\ge 2}m^{-3}-(N-2)\sum_{j\ge 1}(jN)^{-3}
\ge 1-(\zeta(3)-1)-\frac{(N-2)\,\zeta(3)}{N^{3}}\ge\tfrac34,
\] uniformly in \(N\ge 2\) and \(T\). Every point of the rectangle lies within distance \(\sqrt{16+9/4}<4.3\) of \(z_0\). On \(\lvert z-z_0\rvert\le 8.6\) one has \(\sigma\ge-5.6\), so \[
\lvert\eta\rvert\le\sum_{m\le N^2}\lvert c_m^{(N)}\rvert\,m^{5.6}\le (N^2)^{6.6}+(N-1)\sum_{j\le N}(jN)^{5.6}\le 2N^{13.2}.
\] Jensen's formula (Ahlfors [\[4\]](../../geometric-dynamical-phase-transitions/publication.html#ref-ahlfors)) on the disks of radii \(4.3\) and \(8.6\) about \(z_0\) bounds the zero count in the inner disk by \[
n(4.3)\le\frac{\log\bigl(2N^{13.2}\big/\tfrac34\bigr)}{\log 2}\le 20\log N+2.
\]
