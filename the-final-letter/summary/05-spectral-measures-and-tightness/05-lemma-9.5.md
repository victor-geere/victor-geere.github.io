# Lemma 9.5 (Localisation, trapping, exact counts below polylogarithmic heights)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §9](../../geometric-dynamical-phase-transitions/publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

Set \(\omega(t)=c_\delta/\log(2+\lvert t\rvert)\) with \(c_\delta\) small. There is \(N_1(\delta,\varepsilon)\) such that for all \(N\ge N_1\):

1.  every \(s\in S_{\delta/2}\) with \(\lvert\eta_N^{(N^2)}(s)\rvert\le P_N(s)N^{-\varepsilon}\) and \(2\le\lvert t\rvert\le(\log N)^2\) lies within \(\omega(t)<1\) of a zero \(\rho=\beta+i\gamma\) of \(\Xi\);
2.  for each such \(\rho\) there is \(r\in\bigl(10\,\omega(\gamma),20\,\omega(\gamma)\bigr)\) with \(\lvert\eta\rvert\ge P_N\,\kappa_N\) on the circle \(\lvert s-\rho\rvert=r\), where \(\kappa_N=\exp\bigl(-C_\delta(\log\log N)(\log\log\log N)\bigr)>2N^{-\varepsilon}\); consequently every component of \(\Omega_N\) meeting \(D(\rho,\omega)\) is contained in \(D(\rho,r)\), and each such component contains a zero of \(\eta_N^{(N^2)}\) (minimum principle);
3.  the number of zeros of \(\eta_N^{(N^2)}\) in \(D(\rho,r)\) equals the number of zeros of \(\Xi\) there, with multiplicity (Rouché), and is at most \(C\log(2+\lvert\gamma\rvert)\).

## Proof

\(i\) Lemma 9.3 gives \(\lvert\zeta(s)\rvert\le N^{-\varepsilon}+C_\delta\bigl(2+(\log N)^2\bigr)N^{-\delta/2}\le 2N^{-\varepsilon_2}\) with \(\varepsilon_2=\min(\varepsilon,\delta/4)\), for \(N\) large. Were the distance to every zero at least \(\omega(t)\), Lemma 9.4 would give \[
\lvert\zeta(s)\rvert\ge(2+\lvert t\rvert)^{-C_2(1+\log(1/\omega))}\ge\exp\bigl(-C_\delta(\log\log N)(\log\log\log N)\bigr),
\] which exceeds \(2N^{-\varepsilon_2}\) for all large \(N\), since \((\log\log N)(\log\log\log N)=o(\log N)\). For \(\lvert t\rvert\ge 2\) the zeros of \(\zeta\) here are the zeros of \(\Xi\); \(\beta\ge\sigma-\omega\ge\delta/4\), and symmetrically on the right. (ii) Let \(n\le C\log(2+\lvert\gamma\rvert)\) be the number of zeros in \(D(\rho,25\,\omega)\), with multiplicity (Riemann–von Mangoldt). They exclude annuli of total width \(\omega/2\) from the range of \(r\), so some \(r\) keeps the circle at distance \(\ge\omega/(4n)\) from every zero, and Lemma 9.4 with \(\omega/(4n)\) gives \(\lvert\zeta\rvert\ge\kappa_N\) there, because \(\log(4n/\omega)=O(\log\log\log N)\) at heights \(\le(\log N)^2\). The circle stays in \(\delta/4\le\sigma\le 1-\delta/4\) for an elementary reason, with no zero-free region required: by (i) the point \(s\) lies in \(S_{\delta/2}\) and \(\lvert\rho-s\rvert\le\omega\), so \(\delta/2-\omega\le\beta\le 1-\delta/2+\omega\), and the circle reaches only \(\beta\pm 20\,\omega\); imposing \(c_\delta\le\delta/84\) gives \(21\,\omega\le\delta/4\) and hence \(\delta/4\le\sigma\le1-\delta/4\) throughout. (An earlier version derived the upper bound on \(\beta\) from the zero-free region of de la Vallée Poussin. That is an Euler-product input and is deliberately avoided here, so that Theorem C.8 and Corollary C.10 are not circular.) By Theorem 4.3, on the circle \[
\frac{\lvert\eta\rvert}{P_N}\ge\lvert\zeta\rvert-C_\delta(2+\lvert t\rvert)N^{-\sigma}\ge\kappa_N-C_\delta(\log N)^2N^{-\delta/4}\ge\tfrac{\kappa_N}{2}>N^{-\varepsilon},
\] the last comparison because \((\log\log N)(\log\log\log N)=o(\log N)\). A component of \(\Omega_N\) has \(\lvert\eta\rvert<P_NN^{-\varepsilon}\) throughout, cannot meet the circle, and is connected, hence is trapped in \(D(\rho,r)\subset\operatorname{int}S_{\delta/8}\), where \(h_N\) of Definition 5.4 is holomorphic. Were a trapped component free of zeros of \(\eta\), the maximum principle applied to \(1/h_N\) — boundary values of modulus \(N^{\varepsilon}\) — would force \(\lvert h_N\rvert\ge N^{-\varepsilon}\) inside, contradicting openness. Distinct components contain distinct zeros. (iii) On the circle, \(\lvert\eta-(1-N^{1-s})\zeta\rvert\le C_\delta(2+\lvert t\rvert)N^{1-2\sigma}\le\tfrac12 P_N\kappa_N\le\bigl\lvert(1-N^{1-s})\zeta\bigr\rvert\) for large \(N\), and Rouché equates the zero counts of \(\eta\) and of \((1-N^{1-s})\zeta\); the elementary factor has no zero for \(\sigma<1\) (Lemma 2.2). The count is \(n\).
