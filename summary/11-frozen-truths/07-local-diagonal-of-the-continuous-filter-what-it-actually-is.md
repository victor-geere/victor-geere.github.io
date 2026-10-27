# 7. Local diagonal of the continuous filter (what it actually is)

> Source: [`truths.md`](truths.md), §7. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 7.1

For the interpolated coefficients \(c_m(R)=1-R\sum_k\varphi(m/R-k)\) with \(\varphi\in C_c^\infty([-1,1])\), \(\int\varphi=1\), the map \(R\mapsto\eta_R(R^2)(s)\) is \(C^1\) on \([2,\infty)\) for each fixed \(s\) with \(\operatorname{Re}s\in(0,1)\), with majorant \(\sum_{m\le R^2}\lvert\partial_R(c_m m^{-s})\rvert\ll_\varphi R^{1-\sigma}\log R\). The sharp integer truncation is only piecewise \(C^1\).

## Truth 7.2

On a packet \(I_k=[(k-1)R,(k+1)R]\),
\[
\sum_{m\in I_k}c_m(R)\,(\partial_R c_m(R))\,m^{-1}
=-\int_{-1}^{1}\frac{\varphi(u)}{k+u}\,du+R\int_{-1}^{1}\frac{\varphi(u)^2}{k+u}\,du+R_{\mathrm{EM}}^{(k)},
\]
and summing in \(k\) produces \(R(\int\varphi^2)\log R+O_\varphi(R)\) plus Apostol remainders. This is not a multiple of \(R^{-1}\rho^2\). The integer depth bound 4.1 does not pass through this form.

---
