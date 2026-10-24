# Lemma F.10 (Landau–Gonek on the register)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum F](../../geometric-dynamical-phase-transitions/publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Let \(N\ge2\), \(T\ge2\), and let \(N(T)\) be the number of zeros \(\rho=\beta+i\gamma\) of \(\Xi\) with \(0<\gamma\le T\). Then \[
\sum_{0<\gamma\le T}\eta_N^{(N^2)}(\rho)
=N(T)-\frac{T}{2\pi}\,S_N+O\bigl(N^{4}\log(NT)\log\log N\bigr),
\qquad
S_N=\sum_{2\le m\le N^2}\frac{c_m^{(N)}\Lambda(m)}{m},
\] and \[
S_N=2\log N-\mathbf 1_{[N=p^a]}\,\log p\,\frac{1-p^{-a-1}}{1-p^{-1}}+O(1).
\] In particular, for \(T\gg N^4\log N\), the polygon summed over the zeros is the zero count corrected by a von Mangoldt sum over the register: the clock's spikes \(c_m=1-N\) meet \(\Lambda\) exactly when the period is a prime power.

## Proof

Gonek's explicit form of Landau's formula [\[46\]](../../geometric-dynamical-phase-transitions/publication.html#ref-gonek): for \(x,T>1\), \[
\sum_{0<\gamma\le T}x^{\rho}=-\frac{T}{2\pi}\Lambda(x)+O\bigl(x\log(2xT)\log\log3x\bigr)+O\Bigl(\log x\min\bigl(T,\tfrac{x}{\langle x\rangle}\bigr)\Bigr)+O\Bigl(\log2T\min\bigl(T,\tfrac1{\log x}\bigr)\Bigr),
\] where \(\langle x\rangle\) is the distance from \(x\) to the nearest prime power other than \(x\). For an integer \(m\ge2\), \(\langle m\rangle\ge1\), so the error is \(O(m\log(2mT)\log\log3m+\log T)\). The zeros are symmetric under \(\rho\mapsto1-\overline\rho\), which preserves \(0<\gamma\le T\), and \(m^{-\rho}=m^{-1}\,\overline{m^{\,1-\overline\rho}}\); hence \(\sum_\gamma m^{-\rho}=m^{-1}\overline{\sum_\gamma m^{\rho}}=-(T/2\pi)\Lambda(m)/m+O(\log(2mT)\log\log3m+m^{-1}\log T)\), \(\Lambda\) being real. The term \(m=1\) contributes \(N(T)\). Multiply by \(c_m^{(N)}\) and sum: \(\sum_{m\le N^2}\lvert c_m\rvert\,m\le\sum_{m\le N^2}m+N\sum_{j\le N}Nj\ll N^4\), which gives the stated error. For \(S_N\), \(\sum_{m\le N^2}\Lambda(m)/m=2\log N+O(1)\) (Mertens), and \(N\sum_{j\le N}\Lambda(Nj)/(Nj)=\sum_{j\le N}\Lambda(Nj)/j\) is non-zero only when \(N=p^a\) and \(j=p^b\), \(b\le a\), giving \(\log p\sum_{b=0}^{a}p^{-b}\). Part 4 of `quantum_fisher_zeros_test.py` checks the ingredients on the first \(1500\) zeros: at \(T=\gamma_{1500}=1980.91\), \(\operatorname{Re}\sum_\gamma m^{-\rho}\) against \(-(T/2\pi)\Lambda(m)/m\) is \(-109.25\) vs \(-109.27\) (\(m=2\)), \(-114.74\) vs \(-115.45\) (\(3\)), \(-53.75\) vs \(-54.63\) (\(4\)), \(-101.33\) vs \(-101.48\) (\(5\)), \(0.86\) vs \(0\) (\(6\)), \(-87.65\) vs \(-87.64\) (\(7\)); the imaginary parts are all below \(0.7\). For the polygon, \(\sum_\gamma\eta_2^{(4)}(\rho)=1548.26+0.15i\) against \(N(T)-(T/2\pi)S_2=1548.44\) with \(S_2=-0.1537\), and \(\sum_\gamma\eta_3^{(9)}(\rho)=1425.36-1.52i\) against \(1427.54\) with \(S_3=0.2298\); \(N=2,3\) are prime powers, and the spike correction is visible in the sign of \(S_2\).
