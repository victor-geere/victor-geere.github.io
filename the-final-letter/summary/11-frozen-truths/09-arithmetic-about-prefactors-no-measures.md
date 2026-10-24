# 9. Arithmetic about prefactors (no measures)

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §9. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 9.1

\(P_N(s)\ge N^{1-\sigma}-1\). The inequality \(P_N(s)\ge N^{1/2-\varepsilon/2}\) forces \(\sigma\le\tfrac12+\varepsilon/2\) for large \(N\).

## Truth 9.2

On \(\sigma=\tfrac12\), \(P_N\asymp N^{1/2}\), so \(\lvert\eta\rvert\le P_N N^{-\varepsilon}\) and \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\) are the same comparison up to constants.

## Truth 9.3

Isolation packing is arithmetic. On \(O(N^{\kappa})\) vertical grid lines, with isolation radius \(N^{-\kappa}\) and tempering \((1+t^2)^{-1}\),
\[
N^{2\kappa}\int_{N^{1/2-\varepsilon}}^\infty\frac{dt}{1+t^2}\ll N^{2\kappa-1/2+\varepsilon}.
\]
If \(\kappa=\varepsilon\in(0,1/6)\), the exponent is \(3\varepsilon-1/2<0\).

## Truth 9.4

If a residual density on \(S_\delta\) is defined by
\[
\rho_N(\sigma+it)=\frac1N\min\bigl(1,\lvert\eta_N^{(N^2)}(\sigma+it)\rvert^2\bigr)\,(1+\lvert s\rvert^2)^{-1},
\]
then \(\int_{S_\delta}\rho_N=O(N^{-1})\), because \(\int_{S_\delta}(1+\lvert s\rvert^2)^{-1}\,d\sigma\,dt\ll 1\). This is the factor \(1/N\), not a theorem about \(\zeta\).

## Truth 9.5

Analyticity: if \(\rho\) is a simple zero and \(\lvert\sigma_N-\sigma\rvert\le N^{-\kappa}\), then \(\zeta(\sigma_N+i\gamma)=O_\rho(N^{-\kappa})\). The leaked main term at the nearest grid abscissa is \(O_\rho(P_N N^{-\kappa})\). For \(\kappa=\varepsilon\) this is the same order as the relative threshold \(P_N N^{-\varepsilon}\).

---
