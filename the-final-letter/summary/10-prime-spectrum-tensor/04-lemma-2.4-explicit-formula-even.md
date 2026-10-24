# Lemma 2.4 (explicit formula, even form)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

For every \(g\) in the cone,
\[
2\,\Pi(g)\;=\;\hat g\Bigl(\frac i2\Bigr)+\hat g\Bigl(-\frac i2\Bigr)\;-\;\sum_{\rho}\hat g(\gamma_\rho)\;+\;\frac{1}{2\pi}\int_{\mathbb{R}}\hat g(t)\,\Omega(t)\,dt,
\]
the sum over zeros converging absolutely.

*Proof.* Shift the line of Lemma 2.3 from \(\operatorname{Re}s=c\) to \(\operatorname{Re}s=-\varepsilon\), through rectangles of height \(T_j\to\infty\) chosen so that \(\zeta'/\zeta(\sigma+iT_j)\ll\log^2T_j\) uniformly in \(-1\le\sigma\le2\) (Davenport §17). On the horizontals \(\lvert F\rvert\ll T_j^{-(2+\delta)}\) (the argument \((s-\tfrac12)/i\) stays in the strip \(\lvert\operatorname{Im}z\rvert\le\tfrac12+\varepsilon\)), so they vanish in the limit. The poles crossed are: \(s=1\) (residue of \(-\zeta'/\zeta\) is \(+1\)), contributing \(F(1)\); and each non-trivial zero \(\rho\) (residue \(-m_\rho\)), contributing \(-\sum_\rho F(\rho)\), absolutely convergent since \(F(\rho)=\hat g(\gamma_\rho)\ll(1+\lvert\operatorname{Re}\gamma_\rho\rvert)^{-(4+2\delta)}\) against \(N(T+1)-N(T)\ll\log T\). Trivial zeros and \(s=0\) are not crossed (\(\zeta(0)=-\tfrac12\neq0\)). Hence
\[
\Pi(g)=F(1)-\sum_\rho F(\rho)+\frac{1}{2\pi i}\int_{(-\varepsilon)}\Bigl(-\frac{\zeta'}{\zeta}\Bigr)F .
\]
On \((-\varepsilon)\) use \(\zeta(s)=\chi(s)\zeta(1-s)\), i.e. \(-\zeta'/\zeta(s)=-\chi'/\chi(s)+\zeta'/\zeta(1-s)\). The substitution \(w=1-s\) and \(F(1-w)=F(w)\) turn the second piece into \(\frac{1}{2\pi i}\int_{(c)}\frac{\zeta'}{\zeta}F=-\Pi(g)\) by Lemma 2.3. For the first piece, \(\chi(s)=2^s\pi^{s-1}\sin(\pi s/2)\Gamma(1-s)\) has in \(-\varepsilon<\operatorname{Re}s<\tfrac12\) exactly one pole of \(\chi'/\chi\), at \(s=0\), simple with residue \(1\) (the simple zero of \(\sin(\pi s/2)\)), so
\(\frac{1}{2\pi i}\int_{(-\varepsilon)}\frac{\chi'}{\chi}F=\frac{1}{2\pi i}\int_{(1/2)}\frac{\chi'}{\chi}F-F(0)\).
On the critical line, \(\chi(s)=\pi^{s-1/2}\Gamma(\tfrac{1-s}2)/\Gamma(\tfrac s2)\) gives
\(\frac{\chi'}{\chi}(\tfrac12+it)=\log\pi-\operatorname{Re}\psi(\tfrac14+\tfrac{it}2)=-\Omega(t)\), which is real, whence
\(-\frac{1}{2\pi i}\int_{(-\varepsilon)}\frac{\chi'}{\chi}F=F(0)+\frac1{2\pi}\int\hat g(t)\,\Omega(t)\,dt\).
Assembling, with \(F(0)=\hat g(i/2)\) and \(F(1)=\hat g(-i/2)\), gives the display. \(\square\)

The identity of Lemma 2.4 is verified numerically to a residual of \(6\times10^{-25}\) on the witness of §4 (Appendix). It is Weil's explicit formula for \(\zeta\) in the even normalisation (Weil 1952; Bombieri 2000; Iwaniec–Kowalski, ch. 5).

---
